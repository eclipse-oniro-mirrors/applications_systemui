/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Log from "../default/Log";
import SourceLoaderFactory from "./sourceloader/SourceLoaderFactory";
import SourceLoader from "./sourceloader/SourceLoader";
import { FilterData, ItemComponentData, RootConfigInfo } from "./common/Constants";
import {
    AbilityInfoWithId,
    BundleEventType,
    ListenerHandle,
    queryAbility,
    registerBundleListener,
} from "./common/BundleParseUtil";
import { AbilityInfo } from "bundle/abilityInfo";

export type PluginListener = {
    onItemAdd: (itemData: ItemComponentData) => void;
    onItemRemove: (itemData: ItemComponentData) => void;
};

const TAG = "PluginDataSourceManager";
const INVALID_USERID = -1;

export default class PluginDataSourceManager {
    mAction: string = "";
    mUserId: number = INVALID_USERID;
    mListenerHandle: ListenerHandle | undefined = undefined;
    mFilterDatas: Map<string, string> = new Map();
    mLoaders: Map<string, SourceLoader> = new Map();
    mFactory: SourceLoaderFactory;

    constructor(listener: PluginListener) {
        this.mFactory = new SourceLoaderFactory({
            add: listener.onItemAdd,
            remove: listener.onItemRemove,
        });
    }

    initDataSource(configs: RootConfigInfo) {
        Log.showInfo(TAG, `initDataSource, configs: ${JSON.stringify(configs)}`);
        this.mAction = configs.action;
        configs.filterDatas.forEach((data: FilterData) => this.mFilterDatas.set(data.abilityName, data.id));
        for (let pluginType in configs.loaderConfig) {
            const sourceLoader = this.mFactory.getSourceLoader(pluginType, configs.loaderConfig[pluginType]);
            if (sourceLoader instanceof SourceLoader) {
                this.mLoaders.set(pluginType, sourceLoader);
                Log.showInfo(TAG, `getSourceLoader plugin: ${pluginType}, loader${this.mLoaders.get(pluginType)}`);
            }
        }
        Log.showInfo(TAG, `action:${this.mAction}, filterData: ${JSON.stringify(this.mFilterDatas)}`);
        registerBundleListener(this, (handle) => {
            this.mListenerHandle = handle;
        });
    }

    async onBundleNotify(bundleName: string, event: BundleEventType) {
        Log.showInfo(TAG, `onBundleNotify, bundleName: ${bundleName}, event: ${event}`);
        if (event == BundleEventType.BUNDLE_CHANGE || event == BundleEventType.BUNDLE_REMOVE) {
            this.mLoaders.forEach((loader) => loader.onBundleRemove(bundleName));
        }
        if (event == BundleEventType.BUNDLE_CHANGE || event == BundleEventType.BUNDLE_ADD) {
            let abilityInfos = await queryAbility(this.mAction, this.mUserId, bundleName);
            Log.showInfo(TAG, `abilityInfos: ${JSON.stringify(abilityInfos)}`);
            abilityInfos.forEach((info) => this.notifyAbilityAdd(info));
        }
    }

    clearAll() {
        Log.showInfo(TAG, `clearAll`);
        this.unregisterListener();
        this.mLoaders.forEach((sourceLoader) => sourceLoader.clearData());
    }

    async loadData(userId: number) {
        if (this.mUserId != userId) {
            this.mUserId = userId;
            this.mLoaders.forEach((sourceLoader) => sourceLoader.clearData());
            let abilityInfos = await queryAbility(this.mAction, this.mUserId);
            abilityInfos.forEach((info) => this.notifyAbilityAdd(info));
        }
        this.mLoaders.forEach((sourceLoader) => sourceLoader.reloadData(this.mUserId));
    }

    private notifyAbilityAdd(info: AbilityInfo) {
        let itemId = this.mFilterDatas.get(info.name);
        if (!itemId) {
            Log.showInfo(TAG, `notifyAbilityAdd, can't find itemId, ability:${info.name}`);
            return;
        }
        let abilityInfo: AbilityInfoWithId = {
            ...info,
            itemId: itemId,
        };
        if (!abilityInfo.metaData || !abilityInfo.metaData.length) {
            Log.showInfo(TAG, `Can't find metaData, abilityId: ${abilityInfo.name}`);
            return;
        }
        this.mLoaders.forEach((loader) => loader.onAbilityAdd(abilityInfo));
    }

    private unregisterListener() {
        this.mListenerHandle?.unRegister();
        this.mListenerHandle = undefined;
    }
}
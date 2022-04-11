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

import { Event } from "../../default/Event/EventUtil";

export default class Constants {
    static INIT_CONFIG = "initConfig";
    static INIT_FINISH = "initFinish";
    static CLEAR_ALL = "clearAll";
    static ADD_ITEM = "addItem";
    static REMOVE_ITEM = "removeItem";
    static LOCAL_DEVICE = "local";
    static LOAD_DATA = "loadData";
}

export type FilterData = {
    id: string;
    abilityName: string;
};

export type RootConfigInfo = {
    action: string;
    filterDatas: FilterData[];
    loaderConfig: {
        [key in any]: LoaderConfigInfo;
    };
};

export type LoaderConfigInfo = {
    [key: string]: any;
};

export enum PluginType {
    META = 1,
    DATA_ABILITY = 2,
    PLUGIN_COMPONENT = 3,
}

export function obtainMsg(action: string, data: any) {
    return { action: action, data: data };
}

export type ItemComponentData = {
    id: string;
    pluginType: number;
    deviceId: string;
    bundleName: string;
    abilityName: string;
    abilityLabelId: number;
    abilityIconId: number;
    label?: string;
    iconUrl?: Resource | string;
    template?: string;
    state?: any;
    actionData?: ActionData;
}

export class ActionData {
    clickAction?: Event;
    longClickAction?: Event;
    launchType?: number;
    pluginData?: any;
    extra?: any;
}
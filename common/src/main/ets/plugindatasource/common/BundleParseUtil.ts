/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import bundleManager from "@ohos.bundle";
import { ExtensionAbilityInfo } from "bundle/extensionAbilityInfo";
import commonEvent from "@ohos.commonEvent";
import { AbilityInfo } from "bundle/abilityInfo";
import Log from "../../default/Log";

export type AbilityInfoWithId = AbilityInfo & { itemId: string };
export type BundleListener = {
  onBundleNotify: (bundleName: string, event: BundleEventType) => void;
};
export type ListenerHandle = {
  unRegister: () => void;
};
export type PluginData = {
  [key: string | number]: any;
};

export enum BundleEventType {
  BUNDLE_ADD,
  BUNDLE_CHANGE,
  BUNDLE_REMOVE,
  UNKNOWN_EVENT,
}

const TAG = "SourceLoader-BundleParseUtil";
const DEFAULT_BUNDLE_FLAG =
  bundleManager.BundleFlag.GET_ABILITY_INFO_WITH_METADATA | bundleManager.BundleFlag.GET_ABILITY_INFO_WITH_PERMISSION;
const EXTENSIONTYPE = 20;

const BUNDLE_SUBSCRIBE_INFO = {
  events: [
    commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED,
    commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED,
    commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED,
  ],
};

export async function queryAbility(action: string, userId: number, bundleName?: string): Promise<Array<AbilityInfo | ExtensionAbilityInfo>> {
  Log.showDebug(TAG, `queryAbility, action: ${action} , userId: ${userId}`);
  if (bundleName) {
    Log.showDebug(TAG, `queryAbility, bundleName: ${bundleName}`);
    let abilitys = [];
    try {
      abilitys = await bundleManager.queryAbilityByWant(
        {
          action: action,
          bundleName: bundleName,
        },
        DEFAULT_BUNDLE_FLAG,
        userId
      );
    } catch (error) {
      Log.showError(TAG, `queryAbility, queryAbilityByWant error: ${JSON.stringify(error)}`);
    }
    let extensionAbilitys = [];
    try {
      extensionAbilitys = await bundleManager.queryExtensionAbilityInfos(
        {
          action: action,
          bundleName: bundleName,
        },
        EXTENSIONTYPE,
        DEFAULT_BUNDLE_FLAG,
        userId
      );
    } catch (error) {
      Log.showError(TAG, `queryAbility, queryExtensionAbilityInfos error: ${JSON.stringify(error)}`);
    }
    Log.showDebug(TAG, `queryAbility, end`);
    let rets = [...abilitys, ...extensionAbilitys];
    Log.showDebug(TAG, `queryAbility, rets: ${JSON.stringify(rets)}`);
    return rets;
  }
  let abilitys = [];
  try {
    abilitys = await bundleManager.queryAbilityByWant({ action: action }, DEFAULT_BUNDLE_FLAG, userId);
  } catch (error) {
    Log.showError(TAG, `queryAbility, queryAbilityByWant error: ${JSON.stringify(error)}`);
  }
  let extensionAbilitys = [];
  try {
    extensionAbilitys = await bundleManager.queryExtensionAbilityInfos({ action: action }, EXTENSIONTYPE, DEFAULT_BUNDLE_FLAG, userId);
  } catch (error) {
    Log.showError(TAG, `queryAbility, queryExtensionAbilityInfos error: ${JSON.stringify(error)}`);
  }
  Log.showDebug(TAG, `queryAbility, end`);
  let rets = [...abilitys, ...extensionAbilitys];
  Log.showDebug(TAG, `queryAbility, rets: ${JSON.stringify(rets)}`);
  return rets;
}


export function filterAbilityInfo(info: AbilityInfoWithId, filterKey: string): PluginData | undefined {
  Log.showInfo(TAG, `filterAbilityInfo, info: ${JSON.stringify(info)} filterKey: ${filterKey}`);
  let pluginDatas = [];
  if(info.metaData && info.metaData.length){
    pluginDatas = info.metaData.filter((data) => data.name == filterKey);
  } else if(info.metadata && info.metadata.length){
    pluginDatas = info.metadata.filter((data) => data.name == filterKey);
  }
  Log.showInfo(TAG, `filterAbilityInfo, pluginDatas: ${JSON.stringify(pluginDatas)}`);
  if (!pluginDatas.length) {
    Log.showDebug(TAG, `filterKey: ${filterKey}, metadata: ${JSON.stringify(info.metadata.values)}`);
    return undefined;
  }
  let pluginData;
  if(pluginDatas[0].value && pluginDatas[0].value.length > 0){
    pluginData = JSON.parse("{" + pluginDatas[0].value + "}");
  } else if(pluginDatas[0].extra && pluginDatas[0].extra.length > 0){
    pluginData = JSON.parse("{" + pluginDatas[0].extra + "}");
  }
  if (!pluginData) {
    Log.showError(TAG, `Can't parse pluginData: ${pluginDatas[0]}, filterKey: ${filterKey}`);
    return undefined;
  }
  Log.showInfo(TAG, `filterAbilityInfo, pluginData: ${JSON.stringify(pluginData)}`);
  return pluginData;
}

export function registerBundleListener(listener: BundleListener, callback: (handle: ListenerHandle) => void) {
  commonEvent.createSubscriber(BUNDLE_SUBSCRIBE_INFO, (err, handle) => {
    Log.showDebug(TAG, `registerBundleListener, err: ${JSON.stringify(err)}, handle: ${handle}`);
    if (err.code != 0) {
      Log.showError(TAG, `Can't regitser bundle subscribe, err: ${JSON.stringify(err)}`);
      return;
    }
    commonEvent.subscribe(handle, (err, data) => {
      Log.showInfo(TAG, `bundle change, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      if (err.code != 0) {
        Log.showError(TAG, `Can't handle bundle change, err: ${JSON.stringify(err)}`);
        return;
      }
      let event = BundleEventType.UNKNOWN_EVENT;
      switch (data.event) {
        case commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED:
          event = BundleEventType.BUNDLE_ADD;
          break;
        case commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED:
          event = BundleEventType.BUNDLE_CHANGE;
          break;
        case commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED:
          event = BundleEventType.BUNDLE_REMOVE;
          break;
        default:
          Log.showError(TAG, `unknow event: ${event}`);
      }
      listener.onBundleNotify(data.bundleName ?? "unkown", event);
    });
    callback({
      unRegister: () => {
        commonEvent.unsubscribe(handle, () => {
          Log.showInfo(TAG, `unRegister bundle info listener, handle: ${handle}`);
        });
      },
    });
  });
}

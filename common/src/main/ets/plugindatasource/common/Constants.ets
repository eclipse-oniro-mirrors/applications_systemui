/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

export default class Constants {
  static INIT_CONFIG = "initConfig";
  static INIT_FINISH = "initFinish";
  static CLEAR_ALL = "clearAll";
  static ADD_ITEM = "addItem";
  static REMOVE_ITEM = "removeItem";
  static LOAD_DATA = "loadData";
  static DEFAULT_USER_ID = 0;
  static DEFAULT_BUNDLE_FLAG = 0x00000020 | 0x00000008;
}

export enum PluginType {
  SIMPLE = 1,
  OBSERVER = 2,
  LISTENER = 3,
}

export function obtainMsg(action, data) {
  return { "action": action, "data": data };
}

export class ItemComponentData {
  id: string;
  pluginType: number;
  deviceId: string;
  bundleName: string;
  abilityName: string;
  abilityLabelId: number;
  abilityIconId: number;
  label: string;
  iconUrl: Resource | string;
  template?: string;
  state?: any;
  actionData?: ActionData;
}

export class ActionData {
  clickAction?: string;
  longClickAction?: string;
  launchType?: number;
  pluginData?: any;
  extra?: any;
}
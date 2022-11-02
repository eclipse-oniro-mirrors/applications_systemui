//@ts-nocheck
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
import Window from '@ohos.window';
import parameter from '@ohos.systemparameter';
import parameter from '@ohos.systemparameter';
import settings from '@ohos.settings';

export interface Rect {
  left: number;
  top: number;
  width: number;
  height: number;
};

export type WindowType = 'status' | 'navigation' | 'volume';

export function getWindowName(windowType): WindowType {
  switch (windowType) {
    case Window.WindowType.TYPE_NAVIGATION_BAR:
      return 'navigation';
    case Window.WindowType.TYPE_STATUS_BAR:
      return 'status';
    case Window.WindowType.TYPE_VOLUME_OVERLAY:
      return 'volume';
  }
}

export default class Constants {
  static readonly URI_VAR: string = 'datashare:///com.ohos.settingsdata.DataAbility';
  static readonly KEY_BRIGHTNESS_STATUS = settings.display.SCREEN_BRIGHTNESS_STATUS;
  static readonly KEY_TIME_FORMAT = settings.date.TIME_FORMAT;
  static readonly KEY_NAVIGATIONBAR_STATUS = 'settings.display.navigationbar_status';

  /**
   * 获取拼接后的uri，适配settingsdata去常驻
   *
   * @param key settings key
   */
  static getUriSync(key: string): string {
    return "datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=" + key;
  }
}

export enum FASlotName {
  AUTO_ROTATE = 'auto_rotate',
  AIR_PLANE = 'air_plane',
  BATTERY = 'battery',
  BLUETOOTH = 'bluetooth',
  CAPSULE = 'capsule',
  CLOCK = 'clock',
  EMPTY = 'empty',
  LOCATION = 'location',
  NOTIFICATION = 'notification',
  RING_MODE = 'ring_mode',
  SIGNAL = 'signal',
  WIFI = 'wifi',
  NFC = 'nfc',
}

export function isNfcAvailable(){
  if (parameter.getSync("const.SystemCapability.Communication.NFC.Core", "false") == "false"){
    return false
  } else {
    return true
  }
 }

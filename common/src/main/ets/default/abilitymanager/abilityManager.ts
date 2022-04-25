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

import Log from '../Log';

const TAG = 'AbilityManager';

export default class AbilityManager {
  static ABILITY_NAME_ENTRY = 'SystemUi_Entry';
  static ABILITY_NAME_STATUS_BAR = 'SystemUi_StatusBar';
  static ABILITY_NAME_NAVIGATION_BAR = 'SystemUi_NavigationBar';
  static ABILITY_NAME_VOLUME_PANEL = 'SystemUi_VolumePanel';
  static ABILITY_NAME_NOTIFICATION_MANAGEMENT = 'SystemUi_NotificationManagement';
  static ABILITY_NAME_DROPDOWN_PANEL = 'SystemUi_DropdownPanel';
  static ABILITY_NAME_NOTIFICATION_PANEL = 'SystemUi_NotificationPanel';
  static ABILITY_NAME_CONTROL_PANEL = 'SystemUi_ControlPanel';
  static ABILITY_NAME_BANNER_NOTICE = 'SystemUi_BannerNotice';
  static ABILITY_NAME_APP_LIST = 'SystemUi_AppList';

  static ABILITY_NAME_OWNER_WANT = 'Owner_Want';

  static setContext(abilityName: string, context) {
    Log.showInfo(TAG, `setContext, abilityName: ${abilityName}`);
    globalThis[abilityName + '_Context'] = context;
  }

  static getContext(abilityName?: string) {
    Log.showInfo(TAG, `getContext, abilityName: ${abilityName}`);
    if (!abilityName) {
      abilityName = AbilityManager.ABILITY_NAME_ENTRY;
    }
    return globalThis[abilityName + '_Context'];
  }

  static setAbilityData(abilityName, key, data) {
    Log.showInfo(TAG, `setAbilityData, abilityName: ${abilityName} key: ${key} data: ${JSON.stringify(data)}`);
    globalThis[abilityName + '_data_' + key] = data;
  }

  static getAbilityData(abilityName, key) {
    Log.showInfo(TAG, `getAbilityData, abilityName: ${abilityName} key: ${key} `);
    return globalThis[abilityName + '_data_' + key];
  }

  static startAbility(want, callback?: Function) {
    Log.showInfo(TAG, `startAbility, want: ${JSON.stringify(want)}`);
    let context = AbilityManager.getContext();
    context.startAbility(want).then(() => {
      Log.showInfo(TAG, `startAbility, then`);
      if (callback) {
        callback(null);
      }
    }).catch((error) => {
      Log.showInfo(TAG, `startAbility, error: ${JSON.stringify(error)}`);
      callback(error);
    })
  }
}

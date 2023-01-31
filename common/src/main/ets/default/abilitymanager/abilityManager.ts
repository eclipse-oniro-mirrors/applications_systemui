
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

import { BusinessError } from 'basic';
import common from '@ohos.app.ability.common'
import Want from '@ohos.application.Want';
import Log from '../Log';

const TAG = 'AbilityManager';

export default class AbilityManager {
  static readonly ABILITY_NAME_ENTRY = 'SystemUi_Entry';
  static readonly ABILITY_NAME_STATUS_BAR = 'SystemUi_StatusBar';
  static readonly ABILITY_NAME_NAVIGATION_BAR = 'SystemUi_NavigationBar';
  static readonly ABILITY_NAME_VOLUME_PANEL = 'SystemUi_VolumePanel';
  static readonly ABILITY_NAME_NOTIFICATION_MANAGEMENT = 'SystemUi_NotificationManagement';
  static readonly ABILITY_NAME_DROPDOWN_PANEL = 'SystemUi_DropdownPanel';
  static readonly ABILITY_NAME_NOTIFICATION_PANEL = 'SystemUi_NotificationPanel';
  static readonly ABILITY_NAME_CONTROL_PANEL = 'SystemUi_ControlPanel';
  static readonly ABILITY_NAME_BANNER_NOTICE = 'SystemUi_BannerNotice';
  static readonly ABILITY_NAME_APP_LIST = 'SystemUi_AppList';
  static readonly ABILITY_NAME_OWNER_WANT = 'Owner_Want';

  static setContext(abilityName: string, context): void {
    Log.showDebug(TAG, `setContext, abilityName: ${abilityName}`);
    globalThis[abilityName + '_Context'] = context;
  }

  static getContext(abilityName?: string) {
    Log.showDebug(TAG, `getContext, abilityName: ${abilityName}`);
    if (!abilityName) {
      abilityName = AbilityManager.ABILITY_NAME_ENTRY;
    }
    return globalThis[abilityName + '_Context'];
  }

  static setAbilityContext(abilityName: string, context: common.UIAbilityContext): void {
    Log.showDebug(TAG, `setContext, abilityName: ${abilityName}`);
    globalThis[abilityName + '_Context'] = context;
  }

  static getAbilityContext(abilityName?: string): common.UIAbilityContext {
    Log.showDebug(TAG, `getContext, abilityName: ${abilityName}`);
    if (!abilityName) {
      abilityName = AbilityManager.ABILITY_NAME_ENTRY;
    }
    return globalThis[abilityName + '_Context'];
  }

  static setAbilityData(abilityName: string, key: string, data: any): void {
    Log.showDebug(TAG, `setAbilityData, abilityName: ${abilityName} key: ${key} data: ${JSON.stringify(data)}`);
    globalThis[abilityName + '_data_' + key] = data;
  }

  static getAbilityData(abilityName: string, key: string): any {
    Log.showDebug(TAG, `getAbilityData, abilityName: ${abilityName} key: ${key} `);
    return globalThis[abilityName + '_data_' + key];
  }

  static setContextName(abilityName: string, contextName: string): void {
    Log.showDebug(TAG, `setContextName, abilityName: ${abilityName}`);
    globalThis[abilityName + '_ContextName'] = contextName;
  }

  static getContextName(abilityName?: string): string {
    Log.showDebug(TAG, `setContextName, abilityName: ${abilityName}`);
    if (!abilityName) {
      abilityName = AbilityManager.ABILITY_NAME_ENTRY;
    }
    return globalThis[abilityName + '_ContextName'];
  }

  static startAbility(context: any, want: Want, callback?: (error?: BusinessError) => void): void {
    Log.showDebug(TAG, `startAbility, want: ${JSON.stringify(want)}`);
    if (context == null) {
     context = AbilityManager.getContext();
    }
    context.startAbility(want).then(() => {
      Log.showInfo(TAG, 'startAbility, then');
      if (callback) {
        callback();
      }
    }).catch((error: BusinessError) => {
      Log.showError(TAG, `startAbility, error: ${JSON.stringify(error)}`);
      if (callback) {
        callback(error);
      }
    });
  }

  static startServiceExtensionAbility(context: any, want: Want, callback?: (error?: BusinessError) => void): void {
    Log.showDebug(TAG, `startServiceExtensionAbility, want: ${JSON.stringify(want)}`);
    if (context == null) {
      context = AbilityManager.getContext();
    }
    context.startServiceExtensionAbility(want).then(() => {
      Log.showInfo(TAG, 'startServiceExtensionAbility, then');
      if (callback) {
        callback();
      }
    }).catch((error: BusinessError) => {
      Log.showError(TAG, `startServiceExtensionAbility, error: ${JSON.stringify(error)}`);
      if (callback) {
        callback(error);
      }
    });
  }
}

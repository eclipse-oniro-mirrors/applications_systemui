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

import settings from '@ohos.settings';
import Log from './Log';
import Constants from './Constants';
import createOrGet from './SingleInstanceHelper';
import Context from 'application/ServiceExtensionContext';
import AbilityManager from './abilitymanager/abilityManager';

const TAG = 'SettingsUtil';

export class SettingsUtil {
  context: Context;

  constructor() {
    Log.showDebug(TAG, 'constructor');
    this.context = AbilityManager.getContext(AbilityManager.ABILITY_NAME_CONTROL_PANEL);
  }

  getValue(name: string, defValue?: string): string {
    Log.showDebug(TAG, `getValue, name: ${name} defValue: ${defValue}`);
    let value: string = null;
    try {
      value = settings.getValueSync(this.context, name, defValue ? defValue : '');
    } catch (e) {
      Log.showError(TAG, `getValue e: ${JSON.stringify(e)}`);
    }
    Log.showDebug(TAG, `getValue, value: ${value}`);
    return value;
  }

  setValue(name: string, value: string): boolean {
    Log.showDebug(TAG, `setValue, name: ${name} value: ${value}`);
    let result = false;
    try {
      result = settings.setValueSync(this.context, name, value);
    } catch (e) {
      Log.showError(TAG, `setValue e: ${JSON.stringify(e)}`);
    }
    Log.showDebug(TAG, `setValue, result: ${result}`);
    return result;
  }
}

let sSettingsUtil = createOrGet(SettingsUtil, TAG);

export default sSettingsUtil;
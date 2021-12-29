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

import Log from '../../../../../../common/src/main/ets/default/Log.ets';
import commonEvent from '@ohos.commonEvent';
import settings from '@ohos.settingsnapi';
import featureAbility from '@ohos.ability.featureAbility';

const SYSTEMUI_BRIGHTNESS = 'brightness';
const TAG = 'Control-brightnessManager';
var mBrightnessValue = AppStorage.SetAndLink('BrightnessValue', 255);

export class brightnessManager {
  helper: any
  uri: string

  init(): void{
    Log.showInfo(TAG, 'init');
    this.uri = settings.getUri(SYSTEMUI_BRIGHTNESS);
    Log.showInfo(TAG, 'settings geturi of brightness is ' + this.uri);
    this.helper = featureAbility.acquireDataAbilityHelper(this.uri);
    this.getValue();
  }

  registerBrightness() {
    this.helper.on("dataChange", this.uri, (err) => {
      let data = settings.getValue(this.helper, SYSTEMUI_BRIGHTNESS, '100')
      Log.showInfo(TAG, `after brightness datachange settings getValue ${parseInt(data)}`);
      mBrightnessValue.set(parseInt(data));
    })
  }

  unRegisterBrightness() {
    this.helper.off("dataChange", this.uri, (err) => {
      Log.showInfo(TAG, `unregister brightness helper`);
    })
  }

  getValue() {
    Log.showInfo(TAG, 'getValue');
    let data = settings.getValue(this.helper, SYSTEMUI_BRIGHTNESS, '100');
    Log.showInfo(TAG, `settings getValue ${parseInt(data)}`);
    mBrightnessValue.set(parseInt(data));
  }

  setValue(callback) {
    Log.showInfo(TAG, 'setValue');
    let value = parseInt(callback.value);
    Log.showInfo(TAG, `setValue ${value}`);
    mBrightnessValue.set(value);
    Log.showInfo(TAG, `brightness setValue ${value} end`);
    settings.setValue(this.helper, SYSTEMUI_BRIGHTNESS, callback.value.toString());
    Log.showInfo(TAG, `settings setValue ${callback.value} end`);
  }
}


let mBrightnessManager = new brightnessManager();

export default mBrightnessManager as brightnessManager;
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

import Log from '../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import commonEvent from '@ohos.commonEvent';
import settings from '@ohos.settings';
import featureAbility from '@ohos.ability.featureAbility';
import Brightness from '@ohos.brightness';
import CommonConstants from "../../../../../../common/src/main/ets/default/Constants";

const SYSTEMUI_BRIGHTNESS = settings.display.SCREEN_BRIGHTNESS_STATUS;;
const TAG = 'Control-brightnessManager';
var mBrightnessValue = AppStorage.SetAndLink('BrightnessValue', 100);

export class brightnessManager {
  helper: any;
  uri: string;
  SLIDER_CHANG_MODE_MOVING = 1;

  init(): void{
    Log.showDebug(TAG, 'init');
    this.uri = settings.getUriSync(SYSTEMUI_BRIGHTNESS);
    Log.showDebug(TAG, 'settings geturi of brightness is ' + this.uri);
    this.helper = featureAbility.acquireDataAbilityHelper(AbilityManager.getContext(), CommonConstants.URI_VAR);
    this.getValue();
  }

  registerBrightness() {
    this.helper.on("dataChange", this.uri, (err) => {
      let data = settings.getValueSync(this.helper, SYSTEMUI_BRIGHTNESS, '100');
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
    let data = settings.getValueSync(this.helper, SYSTEMUI_BRIGHTNESS, '100');
    Log.showDebug(TAG, `settings getValue ${parseInt(data)}`);
    mBrightnessValue.set(parseInt(data));
  }

  setValue(callback, sliderChangeMode:number) {
    let value = parseInt(callback.value);
    Log.showDebug(TAG, `setValue ${value}`);
    mBrightnessValue.set(value);
    if(sliderChangeMode === this.SLIDER_CHANG_MODE_MOVING){
      Brightness.setValue(callback.value);
    }else{
      settings.setValueSync(this.helper, SYSTEMUI_BRIGHTNESS, callback.value.toString());
      Log.showDebug(TAG, `settings setValue ${callback.value} end`);
    }
  }
}


let mBrightnessManager = new brightnessManager();

export default mBrightnessManager as brightnessManager;
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

import Log from '../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import commonEvent from '@ohos.commonEvent';
import settings from '@ohos.settings';
import systemParameter from '@ohos.systemparameter'
import dataShare from '@ohos.data.dataShare';
import Brightness from '@ohos.brightness';
import Context from 'application/ServiceExtensionContext';
import Constants from "../../../../../../common/src/main/ets/default/Constants";
import createOrGet from '../../../../../../common/src/main/ets/default/SingleInstanceHelper';

const TAG = 'Control-brightnessManager';
var mBrightnessValue = AppStorage.SetAndLink('BrightnessValue', 100);

export class brightnessManager {
  helper: dataShare.DataShareHelper;
  uri: string;
  context: Context;
  SLIDER_CHANG_MODE_MOVING = 1;
  private sliderChangeMode: number;

  constructor() {
    this.uri = Constants.getUriSync(Constants.KEY_BRIGHTNESS_STATUS);
    Log.showInfo(TAG, 'settings geturi of brightness is ' + Constants.URI_VAR);
    this.context = AbilityManager.getContext(AbilityManager.getContextName(AbilityManager.ABILITY_NAME_CONTROL_PANEL));
    this.init();
  }

  async init(): Promise<void> {
    Log.showInfo(TAG, 'init');
    this.helper = await dataShare.createDataShareHelper(this.context, this.uri);
    Log.showInfo(TAG, `init helper ${this.helper}`);
    this.registerBrightness();
    this.getValue();
  }

  registerBrightness() {
    this.helper.on("dataChange", this.uri, () => {
      if (this.sliderChangeMode == 1) {
        return;
      }
      let data = settings.getValueSync(this.context, Constants.KEY_BRIGHTNESS_STATUS, JSON.stringify(this.getDefault()));
      Log.showInfo(TAG, `after brightness datachange settings getValue ${parseInt(data)}`);
      mBrightnessValue.set(parseInt(data));
    })
  }

  unRegisterBrightness() {
    this.helper?.off("dataChange", this.uri, (err) => {
      Log.showInfo(TAG, `unregister brightness helper`);
    })
  }

  getValue() {
    Log.showInfo(TAG, 'getValue');
    let data = settings.getValueSync(this.context, Constants.KEY_BRIGHTNESS_STATUS, JSON.stringify(this.getDefault()));
    Log.showInfo(TAG, `settings getValue ${parseInt(data)}`);
    mBrightnessValue.set(parseInt(data));
  }

  setValue(value: number, sliderChangeMode: number) {
    this.sliderChangeMode = sliderChangeMode;
    Log.showInfo(TAG, `setValue ${value}`);
    Brightness.setValue(value);
  }

  getMin(){
    return parseInt(systemParameter.getSync('const.display.brightness.min'))
  }

  getMax(){
    return parseInt(systemParameter.getSync('const.display.brightness.max'))
  }

  getDefault(){
    return parseInt(systemParameter.getSync('const.display.brightness.default'))
  }
}

let mBrightnessManager = createOrGet(brightnessManager, TAG);

export default mBrightnessManager as brightnessManager;
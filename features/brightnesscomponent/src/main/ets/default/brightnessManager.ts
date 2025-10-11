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
const UPDATE_INTERVAL = 1000;

export class brightnessManager {
  helper: dataShare.DataShareHelper;
  uri: string;
  context: Context;
  SLIDER_CHANG_MODE_MOVING = 1;
  private sliderChangeMode: number;
  private timer: number = -1;

  constructor() {
    this.uri = Constants.getUriSync(Constants.KEY_BRIGHTNESS_STATUS);
    Log.showInfo(TAG, 'settings geturi of brightness is ' + Constants.URI_VAR);
    this.context = AbilityManager.getContext(AbilityManager.getContextName(AbilityManager.ABILITY_NAME_CONTROL_PANEL));
    this.init();
  }

  async init(): Promise<void> {
    Log.showInfo(TAG, 'init');
    this.createDataShare(10);
    Log.showInfo(TAG, `init helper ${this.helper}`);
  }

  public createDataShare(retryTimes: number) {
    if (this.timer !== -1) {
      clearInterval(timer);
      this.timer = -1;
    }
    Log.showInfo(TAG, `createDataShare, context ${this.context},retryTimes${retryTimes}`);
    if (retryTimes < 0) {
      Log.showError(TAG, `reached maximum retry attempts`);
      return;
    }
    retryTimes = retryTimes - 1;
    this.timer = setInterval(() => {
      if (this.context == undefined || this.context == null) {
        Log.showInfo(TAG, `constructor, context is null`);
        this.context =
          AbilityManager.getContext(AbilityManager.getContextName(AbilityManager.ABILITY_NAME_CONTROL_PANEL));
        this.createDataShare(retryTimes);
      } else {
        Log.showInfo(TAG, `constructor, this.context ${this.context}`);
        if (this.timer !== -1) {
          clearInterval(timer);
          this.timer = -1;
        }
        dataShare.createDataShareHelper(this.context, this.uri)
          .then((dataHelper) => {
            Log.showInfo(TAG, `createDataShareHelper success.`);
            this.helper = dataHelper;
            this.registerBrightness();
            this.getValue();
          })
          .catch((err: BusinessError) => {
            Log.showError(TAG, `createDataShare fail. ${JSON.stringify(err)}`);
            this.createDataShare(retryTimes);
          });
      }
    }, UPDATE_INTERVAL);
  }

  registerBrightness() {
    this.helper.on("dataChange", this.uri, () => {
      if (this.sliderChangeMode == 1) {
        return;
      }
      if (this.context == undefined || this.context == null) {
        Log.showInfo(TAG, `registerBrightness: ${context}`);
        return;
      }
      try {
        let data = settings.getValueSync(this.context, Constants.KEY_BRIGHTNESS_STATUS, JSON.stringify(this.getDefault()));
        Log.showDebug(TAG, `after brightness datachange settings getValue ${parseInt(data)}`);
        mBrightnessValue.set(parseInt(data));
      } catch (err) {
        Log.showError(TAG, `registerBrightness: ${context}, ${JSON.stringify(err)}`);
      }

    })
  }

  unRegisterBrightness() {
    this.helper?.off("dataChange", this.uri, (err) => {
      Log.showInfo(TAG, `unregister brightness helper`);
    })
  }

  getValue() {
    Log.showDebug(TAG, 'getValue');
    if (this.context == undefined || this.context == null) {
      Log.showInfo(TAG, `getValue: ${context}`);
      return;
    }
    try {
      let data = settings.getValueSync(this.context, Constants.KEY_BRIGHTNESS_STATUS, JSON.stringify(this.getDefault()));
      Log.showInfo(TAG, `settings getValue ${parseInt(data)}`);
      mBrightnessValue.set(parseInt(data));
    } catch (err) {
      Log.showError(TAG, `getValue: ${context}, ${JSON.stringify(err)}`);
    }
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
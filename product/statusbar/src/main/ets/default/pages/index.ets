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

import Log from '../../../../../../../common/src/main/ets/default/Log.ets'
import ReadConfigUtil from '../../../../../../../common/src/main/ets/default/ReadConfigUtil.ets'
import Notification from './notification.ets'
import ControlCenterComponent from './control.ets'
import Constants from './common/constants.ets'
import NavigationEvent from './common/navigationEvent.ets'
import mBrightnessManager from '../../../../../../../features/brightnesscomponent/src/main/ets/default/brightnessManager.ets';
import HeightConfigUtils from '../../../../../../../common/src/main/ets/default/heightcofigUtils/HeightConfigUtils.ets';
import StatusBarComponent from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/pages/StatusBarComponent.ets';
import WindowManager from '../../../../../../../common/src/main/ets/default/WindowManager.ets';
import Window from '@ohos.window';

const STATUS_BAR_COMPONENT_CONFIG_FILE_PATH = "/data/accounts/account_0/applications/com.ohos.systemui/" +
"com.ohos.systemui.statusbar/assets/statusbar/resources/rawfile/statusbarcomponentConfig.json";

const CONTROL_CENTER_COMPONENT_CONFIG_FILE_PATH = "/data/accounts/account_0/applications/com.ohos.systemui/" +
"com.ohos.systemui.statusbar/assets/statusbar/resources/rawfile/controlcentercomponentConfig.json";

const TAG = 'StatusBar-Index'

let mWindowManager;
let mHeightConfigUtils;

@Entry
@Component
struct Index {
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0
  @StorageLink("showStatusBar") showStatusBar: boolean = true
  @StorageLink("showHorizontal") showHorizontal: boolean = true
  @StorageLink("ableToMaximize") ableToMaximize: boolean = true
  @StorageLink('minHeight') minHeight: number = 0
  @StorageLink('maxWidth') maxWidth: number = 0
  @StorageLink('StatusMinH') StatusMinH: number = 24
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0
  @State statusBarComponentConfig: any = {};
  @State controlCenterComponentConfig: any = {};
  mCallback: any;

  onBackPress(): boolean {
    return true;
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start showStatusBar: ${this.showStatusBar}`);
    mHeightConfigUtils = new HeightConfigUtils();
    let StatusMinH;
    let StatusCoefficient;

    StatusMinH = AppStorage.SetAndLink("StatusMinH", 24);
    StatusCoefficient = AppStorage.SetAndLink("StatusCoefficient", 1.0);
    StatusMinH.set(mHeightConfigUtils.getStatusMinH());
    StatusCoefficient.set(mHeightConfigUtils.getStatusCoefficient());

    {
      let configData = ReadConfigUtil.ReadConfigFile(STATUS_BAR_COMPONENT_CONFIG_FILE_PATH);
      for (let key in configData) {
        this.statusBarComponentConfig[key] = configData[key];
      }
    }
    {
      let controlCenterConfigData = ReadConfigUtil.ReadConfigFile(CONTROL_CENTER_COMPONENT_CONFIG_FILE_PATH);
      for (let key in controlCenterConfigData) {
        this.controlCenterComponentConfig[key] = controlCenterConfigData[key];
      }
    }

    let signalObserved = AppStorage.SetAndLink("signalObserved", false);
    signalObserved.set(false);

    mWindowManager = new WindowManager();
    mWindowManager.initWindowManager();
    this.mCallback = {
      "onStateChange": this.onStateChange.bind(this)
    }
    NavigationEvent.registerCallback(this.mCallback);
    Log.showInfo(TAG, `aboutToAppear, end showStatusBar: ${this.showStatusBar}`);
  }

  onStateChange(data) {
    if (this.ableToMaximize) {
      this.showStatusBar = true;
      mWindowManager.setWindowMin((result) => {
      })
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear, showStatusBar: ${this.showStatusBar}`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      if (this.showStatusBar) {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          StatusBarComponent({
            mStatusBarComponentConfig: this.statusBarComponentConfig,
            mStatusBarColor: '#ffffffff'
          })
        }
        .width('100%')
        .height('100%')
        .backgroundColor($r("app.color.statusbar_background"))
        .onTouch(this.touchEvent.bind(this))
      } else if (this.showHorizontal && this.ableToMaximize) {
        if (vp2px(this.startX) <= parseInt((this.maxWidth / 2).toString())) {
          Notification({ showStatusBar: $showStatusBar, minHeight: this.minHeight })
        } else {
          ControlCenterComponent({
            showStatusBar: $showStatusBar,
            minHeight: this.minHeight,
            mControlCenterComponentConfig: this.controlCenterComponentConfig
          })
        }
      }
    }
    .width('100%')
    .height('100%')
    .constraintSize({ minHeight: this.StatusMinH + 'px'})
  }

  touchEvent(event: TouchEvent) {
    Log.showInfo(TAG, 'touchEvent================' + event.touches)
    if (!this.showHorizontal && !this.ableToMaximize) {
      return;
    }
    if (event.type == Constants.TOUCHTYPE_DOWN) { //down
      this.startX = event.touches[0].screenX
      this.startY = event.touches[0].screenY
      Log.showInfo(TAG, `touchStart=======startX: ${this.startX}, startY: ${this.startY}`)
    } else if (event.type == Constants.TOUCHTYPE_MOVE) { //move
      this.moveX = event.touches[0].screenX - this.startX
      this.moveY = event.touches[0].screenY - this.startY
    } else if (event.type == Constants.TOUCHTYPE_UP) { //up
      Log.showInfo(TAG, `touchEnd, moveX: ${this.moveX}, moveY: ${this.moveY}`)
      if (this.moveY > 10) {
        this.showStatusBar = false;
        mWindowManager.setWindowMax((result) => {
        });
      }
    }
  }
}

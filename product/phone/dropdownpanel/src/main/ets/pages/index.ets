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

import BatteryIcon from '../../../../../../../features/batterycomponent/src/main/ets/default/pages/batteryIcon'
import ClockIcon from '../../../../../../../features/clockcomponent/src/main/ets/default/pages/clockIcon'
import WifiIcon from '../../../../../../../features/wificomponent/src/main/ets/default/pages/wifiIcon'
import BluetoothIcon from '../../../../../../../features/bluetoothcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemBluetoothComponent'
import SignalIcon from '../../../../../../../features/signalcomponent/src/main/ets/default/pages/signalIcon'
import LocationIcon from '../../../../../../../features/locationcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemLocationComponent'
import RingModeIcon from '../../../../../../../features/ringmodecomponent/src/main/ets/com/ohos/pages/StatusBarIconItemRingModeComponent'

import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import image from "@ohos.multimedia.image"
import Log from '../../../../../../../common/src/main/ets/default/Log'
import Trace from '../../../../../../../common/src/main/ets/default/Trace'
import WindowManager, { WindowType, WINDOW_SHOW_HIDE_EVENT
} from '../../../../../../../common/src/main/ets/default/WindowManager'
import EventManager, { unsubscribe } from "../../../../../../../common/src/main/ets/default/event/EventManager"
import { START_ABILITY_EVENT } from "../../../../../../../common/src/main/ets/default/event/EventUtil"
import CommonStyleManager from '../../../../../../../common/src/main/ets/default/CommonStyleManager'
import MultimodalInputManager from '../../../../../../../common/src/main/ets/default/MultimodalInputManager'
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import HeightConfigUtils from '../../../../../../../common/src/main/ets/default/heightcofigUtils/HeightConfigUtils'
import StatusBarVM from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/viewmodel/StatusBarVM'
import NavigationEvent from './common/navigationEvent'
import Notification from './notification'
import ControlCenterComponent from './control'
import StyleManager from './common/StyleManager'
import dataShare from '@ohos.data.dataShare';
import settings from '@ohos.settings';
import Constants from "../../../../../../../common/src/main/ets/default/Constants";

const TAG = 'DropdownPanel-Index'

let mHeightConfigUtils

const SHOW_ANIM_CONFIG = {
  duration: 300,
  tempo: 1.0,
  curve: Curve.Friction,
  delay: 0,
  iterations: 1,
  playMode: PlayMode.Normal
};
const HIDE_ANIM_CONFIG = {
  duration: 200,
  tempo: 1.0,
  curve: Curve.EaseOut,
  delay: 0,
  iterations: 1,
  playMode: PlayMode.Normal,
}

class insertTemplate{
  type: TransitionType;
  opacity: number;
  scale: Object
}

@Entry
@Component
struct Index {
  @State showComponentName: string = undefined;
  @State componentOptAreaHeightPX: number = 0;
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0;
  mCallback: any;
  mClearCallbacks: unsubscribe[];
  settingDataKey = 'settings.display.navigationbar_status';
  urivar: string = null;
  helper: dataShare.DataShareHelper = null;
  mNavigationBarStatusDefaultValue: string = '1';
  navigationBarWidth: number = 0;
  mNeedUpdate: boolean = false;
  mWidthPx: number = 0;
  @State mNotificationInsert: insertTemplate = new insertTemplate();
  @State mNotificationDelete: insertTemplate = new insertTemplate();
  @State mControlCenterInsert: insertTemplate = new insertTemplate();
  @State mControlCenterDelete: insertTemplate = new insertTemplate();
  @State componentOptAreaTranslateY: string = '0px';
  @State backgroundOpacity: number = 0;

  onBackPress(): boolean {
    return true
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);

    setAppBgColor('#00000000');
    CommonStyleManager.setAbilityPageName(TAG);
    StyleManager.setStyle();

    let dropdownRect = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL, 'rect');
    let navigationBarRect = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
    this.initHelper(dropdownRect, navigationBarRect);
    this.resizeDropdownPanelAndNavigationBar(dropdownRect, navigationBarRect);
    Log.showDebug(TAG, `getValueSync componentOptAreaHeightPX: ${this.componentOptAreaHeightPX}`);

    this.componentOptAreaTranslateY = (-this.componentOptAreaHeightPX * 0.1) + 'px';

    this.mClearCallbacks = [];
    this.mClearCallbacks.push(
    EventManager.subscribe('DropdownEvent', (args) => this.onDropdownEvent(args)),
    EventManager.subscribe(START_ABILITY_EVENT, (args) => this.onStartAbility(args)),
    EventManager.subscribe('hideNotificationWindowEvent', (args) => this.onHideNotificationWindowEvent(args)));

    mHeightConfigUtils = new HeightConfigUtils();
    let StatusCoefficient;

    StatusCoefficient = AppStorage.SetAndLink("StatusCoefficient", 1.0);
    StatusCoefficient.set(mHeightConfigUtils.getStatusCoefficient());

    let signalObserved = AppStorage.SetAndLink("signalObserved", false);
    signalObserved.set(false);

    this.mCallback = {
      "onStateChange": (data) => this.onStateChange(data),
      "onNotificationShowOrHide": (data) => this.onNotificationShowOrHide(data),
      "onControlShowOrHide": (data) => this.onControlShowOrHide(data)
    };
    NavigationEvent.registerCallback(this.mCallback);
    MultimodalInputManager.registerControlListener(this.mCallback);
    MultimodalInputManager.registerNotificationListener(this.mCallback);
    Log.showDebug(TAG, `aboutToAppear, end`);
  }

  private async initHelper(dropdownRect, navigationBarRect): Promise<void> {
    this.urivar = Constants.getUriSync(Constants.KEY_NAVIGATIONBAR_STATUS);
    this.helper = await dataShare.createDataShareHelper(AbilityManager.getContext(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL), this.urivar);
    Log.showDebug(TAG, `initHelper ${this.helper}, uri: ${JSON.stringify(this.urivar)}`);
    this.helper?.on("dataChange", this.urivar, () => {
      this.resizeDropdownPanelAndNavigationBar(dropdownRect, navigationBarRect);
      Log.showInfo(TAG, `NavigationBar status change, componentOptAreaHeightPX: ${this.componentOptAreaHeightPX}`);
    });
  }

  onPageShow() {
    Log.showInfo(TAG, `onPageShow, start`)
    if (!this.showComponentName) {
      return
    }
    StatusBarVM.setUseInWindowName(WindowType.DROPDOWN_PANEL)
    Trace.end(Trace.CORE_METHOD_START_DROPDOWNPANEL)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    this.mClearCallbacks.forEach((mClearCallback: Function) => {
      mClearCallback()
      mClearCallback = undefined
    })
    this.mClearCallbacks = undefined
  }

  resizeDropdownPanelAndNavigationBar(dropdownRect, navigationBarRect) {
    Log.showDebug(TAG, `resizeDropdownPanelAndNavigationBar, dropdownRect: ${JSON.stringify(dropdownRect)} navigationBarRect: ${JSON.stringify(navigationBarRect)}`)
    let context = AbilityManager.getContext(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL);
    this.mNavigationBarStatusDefaultValue = settings.getValueSync(context, this.settingDataKey, '1');
    this.componentOptAreaHeightPX = this.mNavigationBarStatusDefaultValue == '1' ? dropdownRect.height - navigationBarRect.realHeight : dropdownRect.height;
    this.navigationBarWidth = this.mNavigationBarStatusDefaultValue == '1' ? navigationBarRect.height : 0;
    WindowManager.resetSizeWindow(WindowType.NAVIGATION_BAR, { ...navigationBarRect, height: this.navigationBarWidth })
    WindowManager.resetSizeWindow(WindowType.DROPDOWN_PANEL, { ...dropdownRect, height: this.componentOptAreaHeightPX })
  }

  onNotificationShowOrHide(data) {
    Log.showDebug(TAG, `mNotificationAsyncCallback preKeys: ${data.preKeys}, finalKey: ${data.finalKey}`);
    Log.showDebug(TAG, `this.showComponentName: ${this.showComponentName}`);
    if (this.showComponentName == 'Notification') {
      this.hideSelf();
    } else {
      this.showSelf('Notification');
    }
    Log.showDebug(TAG, `mNotificationAsyncCallback end`);
  }

  onControlShowOrHide(data) {
    Log.showDebug(TAG, `mControlAsyncCallback preKeys: ${data.preKeys}, finalKey: ${data.finalKey}`);
    Log.showDebug(TAG, `this.showComponentName: ${this.showComponentName}`);
    if (this.showComponentName == 'ControlCenter') {
      this.hideSelf();
    } else {
      this.showSelf('ControlCenter');
    }
    Log.showDebug(TAG, `mControlAsyncCallback end`);
  }

  onStateChange(data) {
    Log.showDebug(TAG, `onStateChange, data: ${JSON.stringify(data)}`)
    Log.showDebug(TAG, `onStateChange, showComponentName: ${this.showComponentName}`)
    if (this.showComponentName) {
      this.hideSelf()
    }
  }

  onDropdownEvent(args) {
    Log.showDebug(TAG, `onDropdownEvent, args: ${JSON.stringify(args)}`)
    this.showSelf(args.dropdownArea == 'left' ? 'Notification' : 'ControlCenter')
  }

  onStartAbility(args) {
    Log.showDebug(TAG, `onStartAbility, args: ${args}`)
    this.hideSelf()
  }

  onHideNotificationWindowEvent(args) {
    Log.showDebug(TAG, `onHideNotificationWindowEvent, args: ${args}`)
    this.hideSelf()
  }

  onTouchMove(data) {
    Log.showDebug(TAG, `onTouchMove, data: ${JSON.stringify(data)}`)
    if (data.direction == 'top') {
      this.hideSelf()
    } else if (data.direction == 'left' && data.touchComponent == 'notification') {
      this.switchNotificationOrControlCenter('ControlCenter')
    } else if (data.direction == 'right' && data.touchComponent == 'control') {
      this.switchNotificationOrControlCenter('Notification')
    } else if (data.direction == 'drop_left' && data.touchComponent == 'control') {
      this.showComponentName = 'Notification'
    } else if (data.direction == 'drop_right' && data.touchComponent == 'notification') {
      this.showComponentName = 'ControlCenter'
    }
  }

  switchNotificationOrControlCenter(showComponentName) {
    Log.showDebug(TAG, `switchNotificationOrControlCenter, showComponentName: ${showComponentName}`)
    this.mNotificationInsert = { type: TransitionType.Insert, opacity: 0, translate: { x: (-this.mWidthPx) + 'px' } }
    this.mControlCenterInsert = { type: TransitionType.Insert, opacity: 0, translate: { x: (this.mWidthPx) + 'px' } }
    let transitionDelete = {
      type: TransitionType.Delete,
      opacity: 0,
      scale: { x: 0.8, y: 0.8, centerX: '50%', centerY: '50%' }
    }
    this.mNotificationDelete = transitionDelete
    this.mControlCenterDelete = transitionDelete
    this._animateTo({ ...SHOW_ANIM_CONFIG, onFinish: () => {
      Log.showInfo(TAG, `switchNotificationOrControlCenter, show anim finish.`);
    } }, () => {
      this.showComponentName = showComponentName
    })
  }

  showSelf(showComponentName) {
    Log.showDebug(TAG, `showSelf, showComponentName: ${showComponentName}`)
    this.showComponentName = showComponentName
    WindowManager.showWindow(WindowType.DROPDOWN_PANEL)
    this.componentOptAreaTranslateY = '0px'
    this.backgroundOpacity = 1
    Trace.start(Trace.CORE_METHOD_START_DROPDOWNPANEL)
  }

  hideSelf() {
    Log.showDebug(TAG, `hideSelf`)
    this._animateTo({ ...SHOW_ANIM_CONFIG, onFinish: () => {
      Log.showInfo(TAG, `hideSelf, hide anim finish.`);
      this.showComponentName = undefined
      WindowManager.hideWindow(WindowType.DROPDOWN_PANEL)
    } }, () => {
      this.componentOptAreaTranslateY = (-this.componentOptAreaHeightPX * 0.1) + 'px'
      this.backgroundOpacity = 0
    })
  }

  _animateTo(config, callback) {
    Log.showDebug(TAG, `_animateTo, config: ${JSON.stringify(config)}`)
    animateTo(config, callback)
    setTimeout(config.onFinish, config.duration + config.delay)
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r("app.media.dropdownpanel_bgc"))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Fill)
        .blur(25)
        .opacity(1)
      Column() {
        if (this.showComponentName == 'Notification') {
          Column() {
            Notification({ touchMoveCallback: (data) => this.onTouchMove(data) })
          }
          .width('100%')
          .height('100%')
          .transition(this.mNotificationInsert)
          .transition(this.mNotificationDelete)
        } else if (this.showComponentName == 'ControlCenter') {
          Column() {
            ControlCenterComponent({
              touchMoveCallback: (data) => this.onTouchMove(data)
            })
          }
          .width('100%')
          .height('100%')
          .transition(this.mControlCenterInsert)
          .transition(this.mControlCenterDelete)
        }
      }
      .width('100%')
      .height(this.componentOptAreaHeightPX + 'px')
      .translate({ y: this.componentOptAreaTranslateY })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.default_background"))
    .opacity(1)
    .onAreaChange((e, e2) => {
      Log.showInfo(TAG, `onAreaChange, e: ${JSON.stringify(e)} e2: ${JSON.stringify(e2)}`);
      this.mWidthPx = vp2px(Number(e2.width))
    })
  }
}

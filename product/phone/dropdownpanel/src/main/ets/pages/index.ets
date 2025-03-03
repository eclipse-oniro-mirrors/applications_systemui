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
import HeightConfigUtils from '../../../../../../../common/src/main/ets/default/heightcofigUtils/HeightConfigUtils'
import StatusBarVM from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/viewmodel/StatusBarVM'
import NavigationEvent, { NavigationCallBack } from './common/navigationEvent'
import Notification from './notification'
import ControlCenterComponent from './control'
import StyleManager from './common/StyleManager'
import dataShare from '@ohos.data.dataShare';
import settings from '@ohos.settings';
import Constants from "../../../../../../../common/src/main/ets/default/Constants";
import { TouchMoveData, Rect, ConfigInfo } from '@ohos/common';
import { Context } from '@kit.AbilityKit';
import { inputConsumer } from '@kit.InputKit';

const TAG = 'DropdownPanel-Index'

interface IArg {
  dropdownArea?: string
}

let mHeightConfigUtils: HeightConfigUtils

const SHOW_ANIM_CONFIG: AnimateParam = {
  duration: 300,
  tempo: 1.0,
  curve: Curve.Friction,
  delay: 0,
  iterations: 1,
  playMode: PlayMode.Normal
};

enum DropdownPanelComponentName {
  NONE = 'None',
  CONTROL_CENTER = 'ControlCenter',
  NOTIFICATION = 'Notification'
}

@Entry
@Component
struct Index {
  @State showComponentName: DropdownPanelComponentName = DropdownPanelComponentName.NONE;
  @State componentOptAreaHeightPX: number = 0;
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0;
  private mCallback?: NavigationCallBack;
  private mClearCallbacks?: unsubscribe[];
  settingDataKey = 'settings.display.navigationbar_status';
  private urivar?: string;
  private helper?: dataShare.DataShareHelper;
  mNavigationBarStatusDefaultValue: string = '1';
  navigationBarWidth: number = 0;
  mNeedUpdate: boolean = false;
  @State mWidthPx: number = 0;
  @State mNotificationInsert: TransitionOptions = {};
  @State mNotificationDelete: TransitionOptions = {};
  @State mControlCenterInsert: TransitionOptions = {};
  @State mControlCenterDelete: TransitionOptions = {};
  @State componentOptAreaTranslateY: string = '0px';
  @State backgroundOpacity: number = 0;

  onBackPress(): boolean {
    return true
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);
    WindowManager.setWindowBgColor(WindowType.DROPDOWN_PANEL,'#00000000')
    CommonStyleManager.setAbilityPageName(TAG);
    StyleManager.setStyle();

    let dropdownRect: Rect = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL, 'rect');
    let navigationBarRect: ConfigInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
    this.initHelper(dropdownRect, navigationBarRect);
    this.resizeDropdownPanelAndNavigationBar(dropdownRect, navigationBarRect);
    Log.showDebug(TAG, `getValueSync componentOptAreaHeightPX: ${this.componentOptAreaHeightPX}`);

    this.componentOptAreaTranslateY = (-this.componentOptAreaHeightPX * 0.1) + 'px';

    this.mClearCallbacks = [];
    this.mClearCallbacks.push(
    EventManager.subscribe('DropdownEvent', (args: IArg) => this.onDropdownEvent(args)),
    EventManager.subscribe(START_ABILITY_EVENT, (args: IArg) => this.onStartAbility(args)),
    EventManager.subscribe('hideNotificationWindowEvent', (args: IArg) => this.onHideNotificationWindowEvent(args)));

    mHeightConfigUtils = new HeightConfigUtils();

    let StatusCoefficient = AppStorage.SetAndLink("StatusCoefficient", 1.0);
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

  private async initHelper(dropdownRect: Rect, navigationBarRect: ConfigInfo): Promise<void> {
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
    if (this.showComponentName === DropdownPanelComponentName.NONE) {
      return
    }
    StatusBarVM.setUseInWindowName(WindowType.DROPDOWN_PANEL)
    Trace.end(Trace.CORE_METHOD_START_DROPDOWNPANEL)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    this.mClearCallbacks&&this.mClearCallbacks.forEach((mClearCallback: Function | undefined) => {
      mClearCallback&&mClearCallback()
      mClearCallback = undefined
    })
    this.mClearCallbacks = undefined
  }

  resizeDropdownPanelAndNavigationBar(dropdownRect: Rect, navigationBarRect: ConfigInfo) {
    Log.showDebug(TAG, `resizeDropdownPanelAndNavigationBar, dropdownRect: ${JSON.stringify(dropdownRect)} navigationBarRect: ${JSON.stringify(navigationBarRect)}`)
    let context: Context = AbilityManager.getContext(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL);
    if (context == undefined || context == null) {
      Log.showInfo(TAG, `resizeDropdownPanelAndNavigationBar: ${context}`);
      return;
    }
    try {
      this.mNavigationBarStatusDefaultValue = settings.getValueSync(context, this.settingDataKey, '1');
      this.componentOptAreaHeightPX = this.mNavigationBarStatusDefaultValue == '1' ? dropdownRect.height - navigationBarRect.realHeight : dropdownRect.height;
      this.navigationBarWidth = this.mNavigationBarStatusDefaultValue == '1' ? navigationBarRect.realHeight : 0;
    } catch (err) {
      Log.showError(TAG, `resizeDropdownPanelAndNavigationBar: ${context}, ${JSON.stringify(err)}`);
    }
    const currRect: Rect = {
      left: 0,
      top: 0,
      width: 0,
      height: this.navigationBarWidth
    };
    dropdownRect.height = this.componentOptAreaHeightPX;
    WindowManager.resetSizeWindow(WindowType.NAVIGATION_BAR, currRect);
    WindowManager.resetSizeWindow(WindowType.DROPDOWN_PANEL, dropdownRect );
  }

  onNotificationShowOrHide(data: inputConsumer.KeyOptions) {
    Log.showDebug(TAG, `mNotificationAsyncCallback preKeys: ${data.preKeys}, finalKey: ${data.finalKey}`);
    Log.showDebug(TAG, `this.showComponentName: ${this.showComponentName}`);
    if (this.showComponentName === DropdownPanelComponentName.NOTIFICATION) {
      this.hideSelf();
    } else {
      this.showSelf(DropdownPanelComponentName.NOTIFICATION);
    }
    Log.showDebug(TAG, `mNotificationAsyncCallback end`);
  }

  onControlShowOrHide(data: inputConsumer.KeyOptions) {
    Log.showDebug(TAG, `mControlAsyncCallback preKeys: ${data.preKeys}, finalKey: ${data.finalKey}`);
    Log.showDebug(TAG, `this.showComponentName: ${this.showComponentName}`);
    if (this.showComponentName === DropdownPanelComponentName.CONTROL_CENTER) {
      this.hideSelf();
    } else {
      this.showSelf(DropdownPanelComponentName.CONTROL_CENTER);
    }
    Log.showDebug(TAG, `mControlAsyncCallback end`);
  }

  onStateChange(data: string) {
    Log.showDebug(TAG, `onStateChange, data: ${JSON.stringify(data)}`)
    Log.showDebug(TAG, `onStateChange, showComponentName: ${this.showComponentName}`)
    if (this.showComponentName !== DropdownPanelComponentName.NONE) {
      this.hideSelf()
    }
  }

  onDropdownEvent(args: IArg) {
    Log.showDebug(TAG, `onDropdownEvent, args: ${JSON.stringify(args)}`)
    this.showSelf(args.dropdownArea == 'left' ? DropdownPanelComponentName.NOTIFICATION : DropdownPanelComponentName.CONTROL_CENTER)
  }

  onStartAbility(args: IArg) {
    Log.showDebug(TAG, `onStartAbility, args: ${args}`)
    this.hideSelf()
  }

  onHideNotificationWindowEvent(args: IArg) {
    Log.showDebug(TAG, `onHideNotificationWindowEvent, args: ${args}`)
    this.hideSelf()
  }

  onTouchMove(data: TouchMoveData) {
    Log.showDebug(TAG, `onTouchMove, data: ${JSON.stringify(data)}`)
    if (data.direction == 'top') {
      this.hideSelf()
    } else if (data.direction == 'left' && data.touchComponent == 'notification') {
      this.switchNotificationOrControlCenter(DropdownPanelComponentName.CONTROL_CENTER)
    } else if (data.direction == 'right' && data.touchComponent == 'control') {
      this.switchNotificationOrControlCenter(DropdownPanelComponentName.NOTIFICATION)
    } else if (data.direction == 'drop_left' && data.touchComponent == 'control') {
      this.showComponentName = DropdownPanelComponentName.NOTIFICATION
    } else if (data.direction == 'drop_right' && data.touchComponent == 'notification') {
      this.showComponentName = DropdownPanelComponentName.CONTROL_CENTER
    }
  }

  switchNotificationOrControlCenter(showComponentName: DropdownPanelComponentName) {
    Log.showDebug(TAG, `switchNotificationOrControlCenter, showComponentName: ${showComponentName}`)
    this.mNotificationInsert = { type: TransitionType.Insert, opacity: 0, translate: { x: (-this.mWidthPx) + 'px' } }
    this.mControlCenterInsert = { type: TransitionType.Insert, opacity: 0, translate: { x: (this.mWidthPx) + 'px' } }
    let transitionDelete: TransitionOptions = {
      type: TransitionType.Delete,
      opacity: 0,
      scale: { x: 0.8, y: 0.8, centerX: '50%', centerY: '50%' }
    }
    this.mNotificationDelete = transitionDelete
    this.mControlCenterDelete = transitionDelete
    SHOW_ANIM_CONFIG.onFinish = () => {
      Log.showInfo(TAG, `switchNotificationOrControlCenter, show anim finish.`);
    }
    this._animateTo(SHOW_ANIM_CONFIG, () => {
      this.showComponentName = showComponentName
    })
  }

  showSelf(showComponentName: DropdownPanelComponentName) {
    Log.showDebug(TAG, `showSelf, showComponentName: ${showComponentName}`)
    this.showComponentName = showComponentName
    WindowManager.showWindow(WindowType.DROPDOWN_PANEL)
    this.componentOptAreaTranslateY = '0px'
    this.backgroundOpacity = 1
    Trace.start(Trace.CORE_METHOD_START_DROPDOWNPANEL)
  }

  hideSelf() {
    Log.showDebug(TAG, `hideSelf`)
    SHOW_ANIM_CONFIG.onFinish = () => {
      Log.showInfo(TAG, `hideSelf, hide anim finish.`);
    };
    this._animateTo(SHOW_ANIM_CONFIG, () => {
      this.componentOptAreaTranslateY = (-this.componentOptAreaHeightPX * 0.1) + 'px'
      this.backgroundOpacity = 0
      this.showComponentName = DropdownPanelComponentName.NONE
    }, true)
  }

  _animateTo(config: AnimateParam, callback: () => void, ishideWindow: boolean = false) {
    Log.showDebug(TAG, `_animateTo, config: ${JSON.stringify(config)}`)
    animateTo(config, callback)
    if (ishideWindow) {
      const delay = Number(config.duration) + Number(config.delay)
      setTimeout(() => WindowManager.hideWindow(WindowType.DROPDOWN_PANEL), delay)
    }
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
        if (this.showComponentName === DropdownPanelComponentName.NOTIFICATION) {
          Notification({ touchMoveCallback: (data: TouchMoveData): void => this.onTouchMove(data) })
            .transition(this.mNotificationInsert)
            .transition(this.mNotificationDelete)
        }
        if (this.showComponentName === DropdownPanelComponentName.CONTROL_CENTER) {
          ControlCenterComponent({
            touchMoveCallback: (data: TouchMoveData): void => this.onTouchMove(data)
          })
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

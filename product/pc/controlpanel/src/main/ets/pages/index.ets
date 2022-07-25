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
import Log from '../../../../../../../common/src/main/ets/default/Log'
import HeightConfigUtils from '../../../../../../../common/src/main/ets/default/heightcofigUtils/HeightConfigUtils'
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager'
import StyleConfiguration, { IndexStyle } from './common/StyleConfiguration'
import StyleManager from './common/StyleManager'
import ControlCenterComponent from './control'
import WindowManager, {
  WindowType,
  WINDOW_SHOW_HIDE_EVENT,
} from "../../../../../../../common/src/main/ets/default/WindowManager";
import EventManager, { unsubscribe } from "../../../../../../../common/src/main/ets/default/event/EventManager";
import { START_ABILITY_EVENT } from "../../../../../../../common/src/main/ets/default/event/EventUtil";
import MultimodalInputManager, {
  MultiKeyCode,
} from "../../../../../../../common/src/main/ets/default/MultimodalInputManager";

const TAG = 'ControlPanel-Index'
const SHOW_EVENT = "showControlCenter";
const HIDE_EVENT = "hideControlCenter";
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

let mHeightConfigUtils

@Entry
@Component
struct Index {
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0
  @State style: IndexStyle = new IndexStyle()
  @State mBackground: PixelMap | undefined = undefined;
  @State mBlur: number = 0;
  @State mOpacity: number = 0.0;
  @State mWidthSize: number = 0.2
  @State mHeightSize: number = 0.2
  @State mHeightPx: number = 0
  mClearCallbacks: Array<unsubscribe> = [];
  mShowAnimReady: boolean = false;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`)

    setAppBgColor('#00000000')
    this.style = StyleConfiguration.getIndexStyle()
    StyleManager.setStyle()

    let rect = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_CONTROL_PANEL, 'rect')
    this.mHeightPx = rect.height

    mHeightConfigUtils = new HeightConfigUtils();
    let StatusCoefficient;

    StatusCoefficient = AppStorage.SetAndLink("StatusCoefficient", 1.0);
    StatusCoefficient.set(mHeightConfigUtils.getStatusCoefficient());

    this.initWindowPolicy();
    Log.showDebug(TAG, `aboutToAppear, end`)
  }

  onPageShow() {
    this.startShowAnim();
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    this.mClearCallbacks.forEach((unsubscribe) => unsubscribe());
    this.mClearCallbacks.length = 0;
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image(this.mBackground)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Fill)
      Column() {
        Scroll(new Scroller()) {
          Column() {
            ControlCenterComponent({
              modeChangeCallback: (isEdit) => this.onModeChange(isEdit)
            })
          }
          .width('100%')
          .onAreaChange((e, e2) => {
            Log.showInfo(TAG, `onAreaChange, e: ${JSON.stringify(e)} e2: ${JSON.stringify(e2)}`);
          })
        }
        .scrollBarColor(Color.Gray)
        .scrollBarWidth(10)
        .width('100%')
      }
      .backgroundColor($r('app.color.default_background'))
      .width('100%')
      .height('100%')
    }
    .scale({
      x: this.mWidthSize,
      y: this.mHeightSize,
      z: 1,
      centerX: '100%',
      centerY: '0%'
    })
    .opacity(this.mOpacity)
    .clip(true)
    .borderRadius(this.style.borderRadius)
    .width('100%')
    .height(this.mHeightPx + 'px')
  }

  initWindowPolicy() {
    Log.showDebug(TAG, `init controlcenter panel window Policy`);
    this.mClearCallbacks.push(
    EventManager.subscribe(SHOW_EVENT, () => WindowManager.showWindow(WindowType.CONTROL_PANEL)),
    EventManager.subscribe(HIDE_EVENT, () => this.hideWindow()),
    EventManager.subscribe(START_ABILITY_EVENT, () => this.hideWindow()),
    EventManager.subscribe(WINDOW_SHOW_HIDE_EVENT, (args) => {
      let { windowName, isShow } = args;
      Log.showInfo(TAG, `WINDOW_SHOW_HIDE_EVENT windowName: ${windowName}, isShow: ${isShow}`);
      windowName == WindowType.NOTIFICATION_PANEL && isShow && this.hideWindow();
      windowName == WindowType.CONTROL_PANEL && isShow && (this.mShowAnimReady = true);
    }),
    MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.I], (data) => {
      let windowInfo = WindowManager.getWindowInfo(WindowType.CONTROL_PANEL);
      Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}, windowInfo: ${windowInfo?.visibility}`);
      if (windowInfo) {
          windowInfo.visibility
          ? this.hideWindow()
          : WindowManager.showWindow(WindowType.CONTROL_PANEL);
      }
    })
    );
  }

  _animateTo(config, callback) {
    animateTo(config, callback)
    setTimeout(config.onFinish, config.duration + config.delay)
  }

  async startShowAnim() {
    if (!this.mShowAnimReady) {
      return;
    }
    this.mShowAnimReady = false;
    this._animateTo({ ...SHOW_ANIM_CONFIG, onFinish: () => {
      Log.showInfo(TAG, `show anim finish.`);
      this.mBlur = 20;
    } }, () => {
      this.mBlur = 20
      this.mOpacity = 1.0
      this.mWidthSize = 1.0
      this.mHeightSize = 1.0
    })
  }

  hideWindow() {
    Log.showDebug(TAG, `hide anim start: ${JSON.stringify(this)}`);
    this._animateTo({ ...HIDE_ANIM_CONFIG, onFinish: () => {
      Log.showInfo(TAG, `anim finish, hide Notification window.`);
      this.mBlur = 0
      WindowManager.hideWindow(WindowType.CONTROL_PANEL);
    }
    }, () => {
      this.mBlur = 0
      this.mOpacity = 0.0
      this.mWidthSize = 0.2
      this.mHeightSize = 0.2
    })
  }

  onModeChange(isEdit) {
    Log.showDebug(TAG, `onModeChange, isEdit: ${isEdit}`)
    let initRect = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_CONTROL_PANEL, 'rect')
    let newRect = initRect
    if (isEdit) {
      let dis = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_CONTROL_PANEL, 'dis')
      newRect = { ...initRect, height: StyleManager.calcScaleSize(346) }
    }
    Log.showDebug(TAG, `onModeChange, newRect: ${JSON.stringify(newRect)}`)
    this._animateTo({
      duration: 300,
      tempo: 1.0,
      curve: Curve.Friction,
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        Log.showInfo(TAG, `onModeChange, show anim finish.`)
        if (newRect.height <= initRect.height) {
          WindowManager.resetSizeWindow(WindowType.CONTROL_PANEL, newRect)
        }
      }
    }, () => {
      Log.showInfo(TAG, `onModeChange, animateTo`)
      if (newRect.height > initRect.height) {
        WindowManager.resetSizeWindow(WindowType.CONTROL_PANEL, newRect)
      }
      this.mHeightPx = newRect.height
    })
  }
}

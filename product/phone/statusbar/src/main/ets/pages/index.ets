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
import Trace from '../../../../../../../common/src/main/ets/default/Trace'
import WindowManager, {WindowType, WINDOW_SHOW_HIDE_EVENT
} from '../../../../../../../common/src/main/ets/default/WindowManager'
import EventManager, {unsubscribe} from "../../../../../../../common/src/main/ets/default/event/EventManager"
import {obtainLocalEvent} from "../../../../../../../common/src/main/ets/default/event/EventUtil"
import CommonStyleManager from '../../../../../../../common/src/main/ets/default/CommonStyleManager'
import HeightConfigUtils from '../../../../../../../common/src/main/ets/default/heightcofigUtils/HeightConfigUtils'
import StatusBarComponent from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/pages/StatusBarComponent'
import StatusBarVM from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/viewmodel/StatusBarVM'
import {StatusBarData} from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/Constants'
import Constants from './common/constants'
import StyleManager from './common/StyleManager'
import StatusbarConfig from './common/StatusbarConfig'
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'

const TAG = 'StatusBar-Index'
const SLIDING_STATUS_BAR_DISTANCE = 18

let mHeightConfigUtils;

@Entry
@Component
struct Index {
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0
  @State mStatusBarData: StatusBarData = new StatusBarData()
  @StorageLink('StatusMinH') StatusMinH: number = 24
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0
  mClearCallback: unsubscribe | undefined
 dropdownpanelIsOpen:boolean = false
  onBackPress(): boolean {
    return true;
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);

    this.updateStatusBarData();

    setAppBgColor('#00000000');
    CommonStyleManager.setAbilityPageName(TAG);
    StyleManager.setStyle();

    this.mClearCallback = EventManager.subscribe(WINDOW_SHOW_HIDE_EVENT, (args) => this.onWindowShowHideEvent(args));

    mHeightConfigUtils = new HeightConfigUtils();
    let StatusMinH;
    let StatusCoefficient;

    StatusMinH = AppStorage.SetAndLink("StatusMinH", 24);
    StatusCoefficient = AppStorage.SetAndLink("StatusCoefficient", 1.0);
    StatusMinH.set(mHeightConfigUtils.getStatusMinH());
    StatusCoefficient.set(mHeightConfigUtils.getStatusCoefficient());

    let signalObserved = AppStorage.SetAndLink("signalObserved", false);
    signalObserved.set(false);

    Log.showInfo(TAG, `aboutToAppear, end`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
    this.mClearCallback && this.mClearCallback()
    this.mClearCallback = undefined
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        StatusBarComponent({
          mStatusBarComponentConfig: StatusbarConfig,
          moduleName: 'phone_statusbar'
        })
      }
      .width('100%')
      .height('100%')
      .onTouch(this.touchEvent.bind(this))
    }
    .width('100%')
    .height('100%')
    .constraintSize({ minHeight: this.StatusMinH })
    .onAreaChange((e, e2) => {
      Log.showInfo(TAG, `onAreaChange, e: ${JSON.stringify(e)} e2: ${JSON.stringify(e2)}`);
        this.updateStatusBarData();
    })
  }

  updateStatusBarData() {
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'config');
    let statusBarData: StatusBarData = new StatusBarData();
    statusBarData.displayWidth = configInfo.maxWidth;
    statusBarData.displayHeight = configInfo.maxHeight;
    statusBarData.showHorizontal = configInfo.showHorizontal;
    statusBarData.ableToMaximize = configInfo.ableToMaximize;
    statusBarData.realWidth = configInfo.realWidth;
    statusBarData.realHeight = configInfo.realHeight;
    statusBarData.left = configInfo.xCoordinate;
    statusBarData.top = configInfo.yCoordinate;
    StatusBarVM.updateStatusBarData(statusBarData);
    this.mStatusBarData = StatusBarVM.getStatusBarData();
  }

  touchEvent(event: TouchEvent) {
    Trace.start(Trace.CORE_METHOD_START_TOUCHEVENT);
    Log.showDebug(TAG, 'touchEvent' + event.touches)
    if (event.type == Constants.TOUCHTYPE_DOWN) { //down
      this.startX = event.touches[0].screenX
      this.startY = event.touches[0].screenY
      Log.showInfo(TAG, `touchStart, startX: ${this.startX}, startY: ${this.startY}`)
    } else if (event.type == Constants.TOUCHTYPE_MOVE) { //move
      this.moveX = event.touches[0].screenX - this.startX
      this.moveY = event.touches[0].screenY - this.startY
      if (this.moveY > SLIDING_STATUS_BAR_DISTANCE && !this.dropdownpanelIsOpen) {
        this.dropdownpanelIsOpen=true
        this.onDropdown();
        this.moveY = 0;
      }
    } else if (event.type == Constants.TOUCHTYPE_UP) { //up
      this.dropdownpanelIsOpen = false
      Log.showInfo(TAG, `touchEnd, moveX: ${this.moveX}, moveY: ${this.moveY}`)
      Trace.end(Trace.CORE_METHOD_START_TOUCHEVENT)
    }
  }

  onDropdown() {
    Log.showDebug(TAG, `this.mStatusBarData ` + JSON.stringify(this.mStatusBarData) )
    Log.showDebug(TAG, `this.mStatusBarData.showHorizontal` + this.mStatusBarData.showHorizontal)
    Log.showDebug(TAG, `this.mStatusBarData.ableToMaximize` + this.mStatusBarData.ableToMaximize)
    if (!this.mStatusBarData.showHorizontal || !this.mStatusBarData.ableToMaximize) {
      return
    }
    let dropdownArea: string = null
    if (this.checkDropdownShowStatus(StatusbarConfig.dropdownRanges.notification)) {
      dropdownArea = 'left'
    } else if (this.checkDropdownShowStatus(StatusbarConfig.dropdownRanges.control)) {
      dropdownArea = 'right'
    }
    if (dropdownArea) {
      EventManager.publish(obtainLocalEvent('DropdownEvent', {
        dropdownArea: dropdownArea
      }))
    }
  }

  checkDropdownShowStatus(range) {
    let rangeStartX = this.mStatusBarData.realWidth * range.startPosition + this.mStatusBarData.left
    let rangeEndX = this.mStatusBarData.realWidth * range.endPosition + this.mStatusBarData.left
    return (vp2px(this.startX) >= rangeStartX) && (vp2px(this.startX) <= rangeEndX)
  }

  onWindowShowHideEvent(args) {
    Log.showDebug(TAG, `onWindowShowHideEvent, args: ${JSON.stringify(args)}`)
    if (args.windowName == WindowType.DROPDOWN_PANEL) {
      if (args.isShow) {
      } else {
        StatusBarVM.setUseInWindowName(WindowType.STATUS_BAR)
      }
    }
  }
}

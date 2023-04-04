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

import {isNfcAvailable} from '../../../../../../../common/src/main/ets/default/Constants';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import ControlCenterComponent from '../../../../../../../features/controlcentercomponent/src/main/ets/com/ohos/pages/ControlCenterComponent'
import BatteryIcon from '../../../../../../../features/batterycomponent/src/main/ets/default/pages/batteryIcon'
import ClockIcon from '../../../../../../../features/clockcomponent/src/main/ets/default/pages/clockIcon'
import WifiIcon from '../../../../../../../features/wificomponent/src/main/ets/default/pages/wifiIcon'
import BluetoothIcon from '../../../../../../../features/bluetoothcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemBluetoothComponent'
import SignalIcon from '../../../../../../../features/signalcomponent/src/main/ets/default/pages/signalIcon'
import LocationIcon from '../../../../../../../features/locationcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemLocationComponent'
import RingModeIcon from '../../../../../../../features/ringmodecomponent/src/main/ets/com/ohos/pages/StatusBarIconItemRingModeComponent'
import NfcIcon from '../../../../../../../features/nfccomponent/src/main/ets/com/ohos/pages/StatusBarIconItemNFComponent'
import Log from '../../../../../../../common/src/main/ets/default/Log'
import Constants from './common/constants'
import StyleConfiguration, { ControlStyle } from './common/StyleConfiguration'
import ControlCenterConfig from './common/ControlCenterConfig';

const TAG = 'DropdownPanel-Control';

@Component
export default struct Control {
  private touchMoveCallback: Function
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0
  @State style: ControlStyle = StyleConfiguration.getControlStyle()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
    AbilityManager.setContextName(AbilityManager.ABILITY_NAME_CONTROL_PANEL,AbilityManager.ABILITY_NAME_DROPDOWN_PANEL);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  build() {
    Column() {
      Column() {
        statusBar({ touchMoveCallback: (data) => this.touchMoveCallback(data) })
      }
      .width('100%')
      .height(this.style.statusBarHeight)
      .padding({
        top: $r("app.float.status_bar_padding_top_bottom"),
        bottom: $r("app.float.status_bar_padding_top_bottom"),
        left: $r("sys.float.ohos_id_max_padding_start"),
        right: $r("sys.float.ohos_id_max_padding_end")
      })
      .layoutWeight(0)

      Scroll(new Scroller()) {
        Column() {
          ControlCenterComponent({
            touchMoveCallback: (data) => this.controlCenterTouchMoveCallback(data),
            mControlCenterComponentConfig: ControlCenterConfig,
            moduleName: 'phone_dropdownpanel',
          })
        }
        .width('100%')
      }
      .width('100%')
      .scrollBarColor(Color.Gray).scrollBarWidth(10)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .onTouch(this.controlTouch.bind(this))
  }

  controlTouch(event: TouchEvent) {
    Log.showDebug(TAG, `controlTouch================ event: ${event}`)
    if (event.type == Constants.TOUCHTYPE_DOWN) {
      this.startX = event.touches[0].screenX
      this.startY = event.touches[0].screenY
      Log.showInfo(TAG, `controlTouch=======startX: ${this.startX}, startY: ${this.startY}`)
    } else if (event.type == Constants.TOUCHTYPE_MOVE) {
      this.moveX = event.touches[0].screenX - this.startX
      this.moveY = event.touches[0].screenY - this.startY
    } else if (event.type == Constants.TOUCHTYPE_UP) {
      Log.showInfo(TAG, `controlTouch, moveX: ${this.moveX}, moveY: ${this.moveY}`)
      if (this.moveY < -30) {
        if (this.touchMoveCallback) {
          this.touchMoveCallback({ 'direction': 'top', 'touchComponent': 'control' })
          this.moveY = 0
        }
      }
    }
  }

  controlCenterTouchMoveCallback(data) {
    Log.showDebug(TAG, `controlCenterTouchMoveCallback data: ${JSON.stringify(data)}`)
    data['touchComponent'] = 'control'
    if (this.touchMoveCallback) {
      this.touchMoveCallback(data)
    }
  }
}

@Component
struct statusBar {
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0
  private touchMoveCallback: Function
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0

  build() {
    Column(){
      Stack(){

        Row(){
          Row(){}.width('50%').height('100%').onTouch((touchEvent) => {this.touchEvent(touchEvent, 'left')})
          Row(){}.width('50%').height('100%').onTouch((touchEvent) => {this.touchEvent(touchEvent, 'right')})
        }.width('100%').height('100%')

        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            SignalIcon()
            WifiIcon()
          }

          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
            LocationIcon()
            BluetoothIcon()
            RingModeIcon()
            if( isNfcAvailable() ){
              NfcIcon()
            }
            BatteryIcon()
            ClockIcon()
          }
        }
        .width('100%')
        .height('100%')
      }
    }
  }

  touchEvent(event: TouchEvent, touchLocation: string) {
    if (event.type == Constants.TOUCHTYPE_DOWN) {
      this.startX = event.touches[0].screenX
      this.startY = event.touches[0].screenY
      Log.showInfo(TAG, `statusBar startX: ${this.startX}, startY: ${this.startY}`)
    } else if (event.type == Constants.TOUCHTYPE_MOVE) {
      this.moveX = event.touches[0].screenX - this.startX
      this.moveY = event.touches[0].screenY - this.startY
    } else if (event.type == Constants.TOUCHTYPE_UP) {
      Log.showInfo(TAG, `statusBar, moveX: ${this.moveX}, moveY: ${this.moveY}`)
      if (this.moveY > 15) {
        if (this.touchMoveCallback) {
          if(touchLocation == 'left'){
            this.touchMoveCallback({ 'direction': 'drop_left', 'touchComponent': 'control' })
          }else if(touchLocation == 'right'){
            this.touchMoveCallback({ 'direction': 'drop_right', 'touchComponent': 'notification' })
          }

        }
      }
    }
  }
}

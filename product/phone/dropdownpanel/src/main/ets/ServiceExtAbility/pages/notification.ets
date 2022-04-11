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

import Log from '../../../../../../../../common/src/main/ets/default/Log'
import EventManager, {unsubscribe}  from "../../../../../../../../common/src/main/ets/default/event/EventManager"
import {obtainStartAbility} from "../../../../../../../../common/src/main/ets/default/event/EventUtil"
import Constants from './common/constants'
import BatteryIcon from '../../../../../../../../features/batterycomponent/src/main/ets/default/pages/batteryIcon'
import ClockIcon from '../../../../../../../../features/clockcomponent/src/main/ets/default/pages/clockIcon'
import WifiIcon from '../../../../../../../../features/wificomponent/src/main/ets/default/pages/wifiIcon'
import BluetoothIcon from '../../../../../../../../features/bluetoothcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemBluetoothComponent'
import SignalIcon from '../../../../../../../../features/signalcomponent/src/main/ets/default/pages/signalIcon'
import LocationIcon from '../../../../../../../../features/locationcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemLocationComponent'
import RingModeIcon from '../../../../../../../../features/ringmodecomponent/src/main/ets/com/ohos/pages/StatusBarIconItemRingModeComponent'
import NotificationListComponent from '../../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/view/NotificationListComponent'
import ViewModel from '../../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/viewmodel/ViewModel'
import ResourceUtil from '../../../../../../../../common/src/main/ets/default/ResourceUtil'
import TimeManager, { TimeEventArgs, TIME_CHANGE_EVENT } from '../../../../../../../../common/src/main/ets/default/TimeManager'

const TAG = 'DropdownPanel-notification'
const GRID_SIZE = 6;
const IMAGE_SIZE_L = 40;
const IMAGE_SIZE_S = 48;
const NO_NOTIFICATION_TOP_MARGIN = 40;
const TIME_TEXT_MARGIN = 8;
const TIME_BOTTOM_OFFSET = 7;
const SETTING_ICON_MARGIN = 12;

@Component
export default struct Notification {
  private touchMoveCallback: Function
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0
  @StorageLink('notificationList') notificationList: any[] = []

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Row()
          .height(24)
          .width('100%')
          .backgroundColor($r("app.color.statusbar_background_color"))
      }.height('100%')

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
          statusBar()
          CenterTitle({
            touchMoveCallback: (data) => this.CenterTitleTouchMoveCallback(data)
          })
          if (this.notificationList.length == 0) {
            Text($r("app.string.no_notification"))
              .fontColor($r("sys.color.ohos_id_color_text_primary_contrary"))
              .fontSize($r("sys.float.ohos_id_text_size_sub_title2"))
              .fontWeight(FontWeight.Medium)
              .alignSelf(ItemAlign.Center)
              .margin({ top: NO_NOTIFICATION_TOP_MARGIN })
          } else {
            NotificationListComponent()
          }
        }.padding({
          left: $r("sys.float.ohos_id_notification_margin_start"),
          right: $r("sys.float.ohos_id_notification_margin_end")
        })
        .height('100%')
      }

      if (this.notificationList.length > 0) {
        Image($r('app.media.delete_all'))
          .width(IMAGE_SIZE_L)
          .height(IMAGE_SIZE_L)
          .margin({ bottom: 32 })
          .onClick(() => {
            ViewModel.removeAllNotifications();
          })
      }
    }.onTouch(this.touchEvent.bind(this))
  }

  touchEvent(event: TouchEvent) {
    if (event.type == Constants.TOUCHTYPE_DOWN) {
      this.startX = event.touches[0].screenX
      this.startY = event.touches[0].screenY
      Log.showInfo(TAG, `touchStart2=======startX: ${this.startX}, startY: ${this.startY}`)
    } else if (event.type == Constants.TOUCHTYPE_MOVE) {
      this.moveX = event.touches[0].screenX - this.startX
      this.moveY = event.touches[0].screenY - this.startY
    } else if (event.type == Constants.TOUCHTYPE_UP) {
      Log.showInfo(TAG, `touchEnd2, moveX: ${this.moveX}, moveY: ${this.moveY}`)
      if (this.moveY < -30) {
        if (this.touchMoveCallback) {
          this.touchMoveCallback({ 'direction': 'top', 'touchComponent': 'notification' })
        }
      }
    }
  }

  CenterTitleTouchMoveCallback(data) {
    Log.showInfo(TAG, `CenterTitleTouchMoveCallback, data: ${JSON.stringify(data)}`)
    data['touchComponent'] = 'notification'
    if (this.touchMoveCallback) {
      this.touchMoveCallback(data)
    }
  }
}

@Component
struct statusBar {
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        SignalIcon()
        WifiIcon()
      }

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        LocationIcon()
        BluetoothIcon()
        RingModeIcon()
        BatteryIcon()
        ClockIcon()
      }
    }
    .height(24)
    .width('100%')
  }
}

@Component
struct CenterTitle {
  private touchMoveCallback: Function
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0
  @State mTimeString: string = '';
  @State mTime: string = '01:01'
  unSubscriber?: unsubscribe;

  aboutToAppear() {
    Log.showInfo(TAG, `CenterTitle, aboutToAppear`)
    this.unSubscriber = EventManager.subscribe(TIME_CHANGE_EVENT, (args: TimeEventArgs) => {
      this.updateTimeString(args.date)
    });
    this.updateTimeString(new Date())
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'CenterTitle aboutToDisappear');
    this.unSubscriber && this.unSubscriber();
    this.unSubscriber = undefined;
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.End, justifyContent: FlexAlign.Start }) {
      Text(this.mTime)
        .fontColor($r("sys.color.ohos_id_color_text_primary_contrary"))
        .fontSize('36fp')
        .fontWeight(FontWeight.Medium)
        .margin({ left: TIME_TEXT_MARGIN })
      Text(this.mTimeString)
        .fontColor($r("sys.color.ohos_id_color_text_primary_contrary"))
        .fontSize($r("sys.float.ohos_id_text_size_sub_title3"))
        .fontWeight(FontWeight.Medium)
        .margin({ left: TIME_TEXT_MARGIN, bottom: TIME_BOTTOM_OFFSET })
        .flexGrow(1)
      Image($r('app.media.ic_settings'))
        .objectFit(ImageFit.Contain)
        .width(IMAGE_SIZE_S)
        .height(IMAGE_SIZE_S)
        .margin({ right: SETTING_ICON_MARGIN, bottom: TIME_BOTTOM_OFFSET })
        .onClick(this.settingClick.bind(this))
    }
    .margin({ top: TIME_TEXT_MARGIN, bottom: TIME_TEXT_MARGIN })
    .onTouch(this.touchEvent.bind(this))
  }

  async updateTimeString(date: Date) {
    this.mTime = TimeManager.formatTime(date);
    let timeString = (date.getMonth() + 1) + (await ResourceUtil.getString($r('app.string.month')));
    timeString += date.getDate() + (await ResourceUtil.getString($r('app.string.month')));
    timeString += await ResourceUtil.getString(Constants.WEEKDAY_LIST[date.getMonth()]);
    this.mTimeString = timeString;
  }

  settingClick() {
    Log.showInfo(TAG, ` settingClick `)
    EventManager.publish(obtainStartAbility('com.ohos.systemui', 'com.ohos.systemui.notificationmanagement.MainAbility'))
  }

  touchEvent(event: TouchEvent) {
    if (event.type == Constants.TOUCHTYPE_DOWN) {
      this.startX = event.touches[0].screenX
      this.startY = event.touches[0].screenY
      Log.showInfo(TAG, `CenterTitle touchStart2=======startX: ${this.startX}, startY: ${this.startY}`)
    } else if (event.type == Constants.TOUCHTYPE_MOVE) {
      this.moveX = event.touches[0].screenX - this.startX
      this.moveY = event.touches[0].screenY - this.startY
    } else if (event.type == Constants.TOUCHTYPE_UP) {
      Log.showInfo(TAG, `CenterTitle touchEnd2, moveX: ${this.moveX}, moveY: ${this.moveY}`)
      if (this.moveX < -30) {
        if (this.touchMoveCallback) {
          this.touchMoveCallback({ 'direction': 'left' })
        }
      } else if (this.moveX > 30) {
        if (this.touchMoveCallback) {
          this.touchMoveCallback({ 'direction': 'right' })
        }
      }
    }
  }
}

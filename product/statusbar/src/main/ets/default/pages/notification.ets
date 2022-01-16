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
import Constants from './common/constants.ets'
import FeatureAbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/featureAbilityManager.ets'
import BatteryIcon from '../../../../../../../features/batterycomponent/src/main/ets/default/pages/batteryIcon.ets'
import ClockIcon from '../../../../../../../features/clockcomponent/src/main/ets/default/pages/clockIcon.ets'
import WifiIcon from '../../../../../../../features/wificomponent/src/main/ets/default/pages/wifiIcon.ets'
import BluetoothIcon from '../../../../../../../features/bluetoothcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemBluetoothComponent.ets'
import SignalIcon from '../../../../../../../features/signalcomponent/src/main/ets/default/pages/signalIcon.ets'
import LocationIcon from '../../../../../../../features/locationcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemLocationComponent.ets'
import RingModeIcon from '../../../../../../../features/ringmodecomponent/src/main/ets/com/ohos/pages/StatusBarIconItemRingModeComponent.ets'
import NotificationListComponent from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/view/NotificationListComponent.ets'
import WindowManager from '../../../../../../../common/src/main/ets/default/WindowManager.ets'
import ViewModel from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/viewmodel/ViewModel.ets'

const TAG = 'StatusBar-notification'

let mWindowManager;
let mFeatureAbilityManager;

@Component
export default
struct Notification {
  @Link showStatusBar: boolean
  private minHeight: number
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0
  @StorageLink('notificationList') notificationList: any[] = []


  aboutToAppear() {
    mWindowManager = new WindowManager();
    mFeatureAbilityManager = new FeatureAbilityManager();
    Log.showInfo(TAG, `aboutToAppear Start`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      statusBar({minHeight:this.minHeight})
      quicklySetting({ showStatusBar: $showStatusBar})
      Stack({ alignContent: Alignment.TopStart }) {
        NotificationListComponent()
        if (this.notificationList.length > 0) {
          Image($r('app.media.delete_all')) //icon: remove all notifications
            .objectFit(ImageFit.Contain)
            .width($r('app.float.deleteall_image_width'))
            .height($r('app.float.deleteall_image_height'))
            .borderRadius($r('app.float.deleteall_image_borderradius'))
            .opacity($r('app.float.deleteall_image_opacity'))
            .onClick(() => {
              ViewModel.removeAllNotifications();
            })
            .position({ x: '44.5%', y: '85%' })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.default_background'))
    .onTouch(this.touchEvent.bind(this))
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
        this.showStatusBar = true;
        mWindowManager.setWindowMin((result)=>{

        })
      }
    }
  }
}

@Component
struct statusBar {
  private minHeight: number
  @StorageLink('StatusCoefficient') StatusCoefficient:number = 1.0

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
    .width('100%')
    .height(this.minHeight + 'px')
  }
}

@Component
struct quicklySetting {
  @Link showStatusBar: boolean
  @StorageLink('time') mTime: string = '01:01'
  @StorageLink('month') mMonth: number = 1
  @StorageLink('day') mDay: number = 1
  @StorageLink('weekDay') mWeekDay: number = 1
  @State showDay: string = 'day'
  @State showMonth: string = 'month'
  @State showWeekDay: any = 'weekday'

  aboutToAppear() {
    Log.showInfo(TAG, `quicklySetting, aboutToAppear`)
    //show month
    this.showMonth = this.alignmentNumber(this.mMonth);
    //show day
    this.showDay = this.alignmentNumber(this.mDay);
    //show weekDay
    this.showWeekDay = Constants.WEEKDAY_LIST[this.mWeekDay-1];
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `quicklySetting, aboutToDisappear, showStatusBar: ${this.showStatusBar}`)
  }

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
        Text(this.mTime)
          .fontColor($r('app.color.quicklysetting_time_fontcolor'))
          .fontSize($r('app.float.quicklysetting_time_fontsize'))
        Flex({direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center}){
          dateItem({number: this.showMonth, unit: Constants.MARK_MONTH})
          dateItem({number: this.showDay, unit: Constants.MARK_DAY})
          Text(this.showWeekDay)
            .fontColor($r('app.color.quicklysetting_date_fontcolor'))
            .fontSize($r('app.float.quicklysetting_date_fontsize'))
        }
      }
      .width('50%')
      .height('100%')
      .margin({ left: $r('app.float.quicklysetting_textflex_marginleft') })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End }) {
        Image($r('app.media.ic_settings'))
          .objectFit(ImageFit.Contain)
          .onClick(this.settingClick.bind(this))
      }
      .width($r('app.float.quicklysetting_image_width'))
      .height($r('app.float.quicklysetting_image_height'))
      .margin({ right: $r('app.float.quicklysetting_image_marginright') })

    }
    .width('100%')
    .height(Constants.QUICKLY_SETTING_H)
    .borderRadius($r('app.float.quicklysetting_borderradius'))
    .margin({ left: $r('app.float.quicklysetting_marginleft'), right: $r('app.float.quicklysetting_marginright') })
  }

  settingClick() {
    Log.showInfo(TAG,` settingClick `)
    this.showStatusBar = true;
    mWindowManager.setWindowMin((result)=>{
      mFeatureAbilityManager.openAbility(TAG, {
        want: {
          bundleName: 'com.ohos.settings',
          abilityName: 'com.ohos.settings.MainAbility'
        }
      });
    });
  }
  alignmentNumber(timeOrDate){
    if(timeOrDate < Constants.DIGITS){
      return '0' + timeOrDate
    }else{
      return '' + timeOrDate
    }
  }
}

@Component
struct dateItem {

  @Prop number: string
  @Prop unit: number

  build() {
    Row() {
      Text(this.number)
        .fontColor($r('app.color.quicklysetting_date_fontcolor'))
        .fontSize($r('app.float.quicklysetting_date_fontsize'))
      if (this.unit == Constants.MARK_MONTH) {
        Text($r('app.string.month'))
          .fontColor($r('app.color.quicklysetting_date_fontcolor'))
          .fontSize($r('app.float.quicklysetting_date_fontsize'))
      }
      if (this.unit == Constants.MARK_DAY) {
        Text($r('app.string.day'))
          .fontColor($r('app.color.quicklysetting_date_fontcolor'))
          .fontSize($r('app.float.quicklysetting_date_fontsize'))
      }
    }
  }
}

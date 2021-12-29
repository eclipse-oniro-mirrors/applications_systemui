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

import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import Constants from '../common/Constants.ets'
import ViewModel from '../viewmodel/StatusBarVM.ets'
import IconItemComponent from './IconItemComponent.ets'
import BatteryIcon from '../../../../../../../batterycomponent/src/main/ets/default/pages/batteryIcon.ets'
import ClockIcon from '../../../../../../../clockcomponent/src/main/ets/default/pages/clockIcon.ets'
import WifiIcon from '../../../../../../../wificomponent/src/main/ets/default/pages/wifiIcon.ets'
import SignalIcon from '../../../../../../../signalcomponent/src/main/ets/default/pages/signalIcon.ets'
import CapsuleIcon from '../../../../../../../capsulecomponent/src/main/ets/default/pages/CapsuleIcon.ets'

const TAG = 'StatusBarComponent'
const TAG_StatusBarGroup = 'StatusBarGroup'
const TAG_StatusBarEmptyIcon = 'StatusBarEmptyIcon'
const TAG_StatusBarNotificationIcon = 'StatusBarNotificationIcon'

@Component
export default struct StatusBarComponent {
  @State mStatusBarComponentConfig: any = {}
  @Prop mStatusBarColor: string
  @StorageLink('StatusBarLayout') mStatusBarLayout: any = [[], [], []]
  @StorageLink('maxWidth') @Watch('onSizeUpdated') maxWidth: number = 0
  @StorageLink('maxHeight') @Watch('onSizeUpdated') maxHeight: number = 0
  @StorageLink('minHeight') @Watch('onSizeUpdated') minHeight: number = 0
  @StorageLink('StatusBarComponentIsStart') mIsStart: boolean = false

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start, mStatusBarComponentConfig: ${JSON.stringify(this.mStatusBarComponentConfig)}`)
    if (this.maxWidth > 0 && this.maxHeight > 0 && this.minHeight > 0) {
      this.initViewModel()
    }
    Log.showInfo(TAG, `aboutToAppear End`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  onSizeUpdated(propName: string): void {
    Log.showInfo(TAG, `onSizeUpdated, propName: ${propName} maxWidth: ${this.maxWidth} maxHeight: ${this.maxHeight} minHeight: ${this.minHeight}`)
    if (this.maxWidth == 0 || this.maxHeight == 0 || this.minHeight == 0) {
      return
    }
    this.initViewModel()
  }

  initViewModel() {
    Log.showInfo(TAG, `initViewModel`)
    if (this.mIsStart) {
      return
    }
    this.mIsStart = true
    ViewModel.initViewModel(this.mStatusBarComponentConfig, {
      width: this.maxWidth,
      height: this.maxHeight,
      statusBarHeight: this.minHeight
    })
  }

  build() {
    Row() {
      StatusBarGroup({
        mColor: this.mStatusBarColor,
        mComponents: this.mStatusBarLayout[0],
        mLayoutWeight: 1,
        mAlignItems: HorizontalAlign.Start
      })
      StatusBarGroup({
        mColor: this.mStatusBarColor,
        mComponents: this.mStatusBarLayout[1],
        mLayoutWeight: 0,
        mAlignItems: HorizontalAlign.Center
      })
      StatusBarGroup({
        mColor: this.mStatusBarColor,
        mComponents: this.mStatusBarLayout[2],
        mLayoutWeight: 1,
        mAlignItems: HorizontalAlign.End
      })
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct StatusBarGroup {
  @Prop mColor: string
  @State mComponents: string[] = []
  @State mLayoutWeight: number = 1
  @State mAlignItems: HorizontalAlign = HorizontalAlign.Center;
  @StorageLink('StatusBarEmptyWidth') mStatusBarEmptyWidth: any = 0

  aboutToAppear() {
    Log.showInfo(TAG_StatusBarGroup, `aboutToAppear Start`)
    Log.showInfo(TAG_StatusBarGroup, `aboutToAppear, mLayoutWeight: ${this.mLayoutWeight} mAlignItems: ${this.mAlignItems} `)
  }

  aboutToDisappear() {
    Log.showInfo(TAG_StatusBarGroup, `aboutToDisAppear`)
  }

  build() {
    Column() {
      Row() {
        ForEach(this.mComponents, (componentName: string) => {
          Row() {
            if (componentName == Constants.EMPTY) {
              StatusBarEmptyIcon()
            } else if (componentName == Constants.WIFI) {
              WifiIcon()
            } else if (componentName == Constants.SIGNAL) {
              SignalIcon()
            } else if (componentName == Constants.CLOCK) {
              ClockIcon()
            } else if (componentName == Constants.BATTERY) {
              BatteryIcon()
            } else if (componentName == Constants.CAPSULE) {
              CapsuleIcon()
            } else if (componentName == Constants.NOTIFICATION) {
              StatusBarNotificationIcon()
            } else {
              IconItemComponent({
                keyId: componentName,
                color: this.mColor
              })
            }
          }
          .height('100%')
        }, (componentName: string) => componentName)
      }
    }
    .alignItems(this.mAlignItems)
    .layoutWeight(this.mLayoutWeight)
  }
}

@Component
struct StatusBarEmptyIcon {
  @StorageLink('StatusBarEmptyWidth') mStatusBarEmptyWidth: any = 0

  aboutToAppear() {
    Log.showInfo(TAG_StatusBarEmptyIcon, `aboutToAppear Start`)
    Log.showInfo(TAG_StatusBarEmptyIcon, `aboutToAppear, mStatusBarEmptyWidth: ${this.mStatusBarEmptyWidth} `)
  }

  aboutToDisappear() {
    Log.showInfo(TAG_StatusBarEmptyIcon, `aboutToDisAppear`)
  }

  build() {
    Row().width(this.mStatusBarEmptyWidth).height('100%')
  }
}

@Component
struct StatusBarNotificationIcon {
  @StorageLink('notificationList') notificationList: any = []
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0

  aboutToAppear() {
    Log.showInfo(TAG_StatusBarNotificationIcon, `aboutToAppear Start`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG_StatusBarNotificationIcon, `aboutToDisAppear`)
  }

  build() {
    Row() {
      if (this.notificationList.length > 3) {
        ForEach(this.notificationList.slice(0, 3), (item: any) => {
          Image(item.smallIcon)
            .objectFit(ImageFit.ScaleDown)
            .height(Constants.STATIC_BAR_ICON_HEIGHT * this.StatusCoefficient)
            .width(Constants.STATIC_BAR_ICON_WIDTH * this.StatusCoefficient)
            .margin({ right: Constants.STATIC_BAR_ICON_MARGIN })
        })
        Row() {
          Text('...')
            .fontSize(20)
        }
      } else {
        ForEach(this.notificationList, (item: any) => {
          Image(item.smallIcon)
            .objectFit(ImageFit.ScaleDown)
            .height(Constants.STATIC_BAR_ICON_HEIGHT * this.StatusCoefficient)
            .width(Constants.STATIC_BAR_ICON_WIDTH * this.StatusCoefficient)
            .margin({ right: Constants.STATIC_BAR_ICON_MARGIN })
        })
      }
    }
    .width(this.notificationList.length > 3 ?
      (Constants.STATIC_BAR_ICON_WIDTH + Constants.STATIC_BAR_ICON_MARGIN) * 4 :
      (Constants.STATIC_BAR_ICON_WIDTH + Constants.STATIC_BAR_ICON_MARGIN) * this.notificationList.length)
  }
}

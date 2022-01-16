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

import Log from '../default/Log.ets'
import UniformConfig from './UniformConfig.ets'

const TAG = 'SimpleToggleBase.ets'

@Component
export default struct SimpleToggleBase {
  private mConfig = UniformConfig.config
  @Prop mToggleId: string
  @Link @Watch('onIconUpdated') mIcon: string | Resource
  @State @Watch('onIconStrUpdated') mIconStr: string = ''
  private mUseIconStr: boolean = false
  private mAutoIconColor: boolean = false
  @Link @Watch('onChangeSwitchUpdated') mChangeSwitch: boolean
  @Link mLabel: string | Resource
  @State mLabelStr: string = ''
  private mUseLabelStr: boolean = false
  @Prop mShowLabel: boolean
  @Prop mEditMode: boolean
  private mClickEvent: Function
  private mLongClickEvent: Function
  private appStorageIconKey: string
  private appStorageChangeSwitchKey: string

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, mToggleId: ${this.mToggleId}`)
    Log.showInfo(TAG, `aboutToAppear, mLabel: ${JSON.stringify(this.mLabel)}`)
    if (this.mEditMode) {
      this.appStorageIconKey = "TOGGLE_ICON_" + this.mToggleId
      this.appStorageChangeSwitchKey = "TOGGLE_CHANGE_SWITCH_" + this.mToggleId
      if (this.mUseIconStr) {
        AppStorage.SetOrCreate(this.appStorageIconKey, this.mIconStr)
      } else {
        AppStorage.SetOrCreate(this.appStorageIconKey, this.mIcon)
      }
      AppStorage.SetOrCreate(this.appStorageChangeSwitchKey, this.mChangeSwitch)
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  onIconUpdated(propName: string): void {
    Log.showInfo(TAG, `onIconUpdated, propName: ${propName} mIcon: ${JSON.stringify(this.mIcon)}`)
    if (this.mEditMode) {
      AppStorage.SetOrCreate(this.appStorageIconKey, this.mIcon)
    }
  }

  onIconStrUpdated(propName: string): void {
    Log.showInfo(TAG, `onIconStrUpdated, propName: ${propName} mIconStr: ${this.mIconStr}`)
    if (this.mEditMode) {
      AppStorage.SetOrCreate(this.appStorageIconKey, this.mIconStr)
    }
  }

  onChangeSwitchUpdated(propName: string): void {
    Log.showInfo(TAG, `onIconUpdated, propName: ${propName} mChangeSwitch: ${this.mChangeSwitch}`)
    if (this.mEditMode) {
      AppStorage.SetOrCreate(this.appStorageChangeSwitchKey, this.mChangeSwitch)
    }
  }

  build() {
    Column() {
      Stack() {
        Flex()
          .backgroundColor(this.mChangeSwitch == false ? this.mConfig.iconOffBG : this.mConfig.iconOnBG)
          .clip(new Circle({ width: this.mConfig.circleWidth, height: this.mConfig.circleHeight }))
          .width(this.mConfig.circleWidth)
          .height(this.mConfig.circleHeight)
        if (this.mAutoIconColor) {
          Image(this.mUseIconStr ? this.mIconStr : this.mIcon)
            .size({ width: this.mConfig.iconWidth, height: this.mConfig.iconHeight })
            .objectFit(ImageFit.Contain)
            .fillColor(this.mChangeSwitch ? this.mConfig.iconOnColor : this.mConfig.iconOffColor)
        } else {
          Image(this.mUseIconStr ? this.mIconStr : this.mIcon)
            .size({ width: this.mConfig.iconWidth, height: this.mConfig.iconHeight })
            .objectFit(ImageFit.Contain)
        }
      }
      .width(this.mConfig.circleWidth)
      .height(this.mConfig.circleHeight)

      if (this.mShowLabel) {
        Column()
          .width(this.mConfig.circleWidth)
          .height(10)

        Text(this.mUseLabelStr ? this.mLabelStr : this.mLabel)
          .fontSize(this.mConfig.simpleToggleTitleSize)
      }
    }
    .onClick(this.onIconItemClick.bind(this))
    .gesture(LongPressGesture({ repeat: false }).onAction(this.onIconItemLongPressGesture.bind(this)))
  }

  onIconItemClick(event: ClickEvent) {
    Log.showInfo(TAG, `onIconItemClick`)
    if (this.mClickEvent) {
      this.mClickEvent()
    }
  }

  onIconItemLongPressGesture(event: GestureEvent) {
    if (this.mEditMode) {
      return
    }
    Log.showInfo(TAG, `onIconItemLongPressGesture, event: ${JSON.stringify(event)}`)
    if (this.mLongClickEvent) {
      this.mLongClickEvent()
    }
  }
}

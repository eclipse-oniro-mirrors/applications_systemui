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
import EventManager from "../../../../../../../../common/src/main/ets/default/event/EventManager"
import {obtainStartAbility} from "../../../../../../../../common/src/main/ets/default/event/EventUtil"
import Constants from '../common/Constants'
import StyleConfiguration from '../common/StyleConfiguration'

const TAG = 'Control-UpTitle'

@Component
export default struct UpTitle {
  private touchMoveCallback: Function
  private simpleToggleLayoutEditStartCallback: Function
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0
  @State mSettingIsHover: boolean = false
  @State mEditIsHover: boolean = false
  @State style: any = StyleConfiguration.getControlCenterUpTitleStyle()

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear');
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.End, justifyContent: FlexAlign.SpaceBetween }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Row()
          .width(this.style.marginLeft)
          .height('100%')
        Text($r('app.string.control_center'))
          .fontColor(this.style.fontColor)
          .fontSize(this.style.fontSize)
          .fontWeight(FontWeight.Bold)
      }
      .height('100%')

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        Stack() {
          Flex()
            .backgroundColor(this.mSettingIsHover ? this.style.imageHoverColor : this.style.imageTransparentColor)
            .clip(new Rect({
              width: this.style.imageHoverWidth,
              height: this.style.imageHoverHeight
            }).radius(this.style.imageHoverRadius))
            .width(this.style.imageHoverWidth)
            .height(this.style.imageHoverHeight)
          Image($r('app.media.ic_public_settings'))
            .objectFit(ImageFit.Contain)
            .size({ width: this.style.imageWidth,
              height: this.style.imageHeight })
            .fillColor(this.style.titleImageColor)
            .onClick(this.settingClick.bind(this))
            .onHover((isHover) => {
              this.mSettingIsHover = isHover;
            })
        }
        .width(this.style.imageHoverWidth)
        .height(this.style.imageHoverHeight)

        Row()
          .width(this.style.upTitleSpace)
          .height('100%')
        Stack() {
          Flex()
            .backgroundColor(this.mEditIsHover ? this.style.imageHoverColor : this.style.imageTransparentColor)
            .clip(new Rect({
              width: this.style.imageHoverWidth,
              height: this.style.imageHoverHeight
            }).radius(this.style.imageHoverRadius))
            .width(this.style.imageHoverWidth)
            .height(this.style.imageHoverHeight)
          Image($r('app.media.ic_public_edit'))
            .objectFit(ImageFit.Contain)
            .size({ width: this.style.imageWidth,
              height: this.style.imageHeight })
            .fillColor(this.style.titleImageColor)
            .onClick(this.editClick.bind(this))
            .onHover((isHover) => {
              this.mEditIsHover = isHover;
            })
        }
        .width(this.style.imageHoverWidth)
        .height(this.style.imageHoverHeight)

        Row()
          .width(this.style.marginRight)
          .height('100%')
      }
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .onTouch(this.touchEvent.bind(this))
  }

  settingClick() {
    Log.showInfo(TAG, `settingClick`)
    EventManager.publish(obtainStartAbility('com.ohos.settings', 'com.ohos.settings.MainAbility'))
  }

  editClick() {
    Log.showInfo(TAG, `editClick`)
    if (this.simpleToggleLayoutEditStartCallback) {
      this.simpleToggleLayoutEditStartCallback()
    }
  }

  touchEvent(event: TouchEvent) {
    if (event.type == Constants.TOUCHTYPE_DOWN) {
      this.startX = event.touches[0].screenX
      this.startY = event.touches[0].screenY
      Log.showInfo(TAG, `quicklySetting touchStart2=======startX: ${this.startX}, startY: ${this.startY}`)
    } else if (event.type == Constants.TOUCHTYPE_MOVE) {
      this.moveX = event.touches[0].screenX - this.startX
      this.moveY = event.touches[0].screenY - this.startY
    } else if (event.type == Constants.TOUCHTYPE_UP) {
      Log.showInfo(TAG, `quicklySetting touchEnd2, moveX: ${this.moveX}, moveY: ${this.moveY}`)
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
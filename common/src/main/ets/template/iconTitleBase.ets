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

import Log from '../default/Log';
import StyleConfiguration, { IconTitleBaseStyle } from './common/StyleConfiguration'
import iconComponent from './iconComponent'

const TAG = 'iconTitleBase'

@Component
export default struct iconBaseComponent {
  private iconOn: any
  private iconOff: any
  @State iconOffStr: string = ""
  @State iconOnStr: string = ""
  @Link mTitle: string | Resource
  @State mTitleStr: string = ""
  private useIconStr = false
  private useTitleStr = false
  private mClickEvent: Function
  private mLongClickEvent: Function
  @State mTextIsHover: boolean = false
  @Link changeSwitch: boolean
  @State style: IconTitleBaseStyle = StyleConfiguration.getIconTitleBaseStyle()

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear')
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  build() {
    Row() {
      Column().width(this.style.marginLeft).height('100%').layoutWeight(0)
      Row() {
        Row() {
          iconComponent({
            useIconStr: this.useIconStr,
            iconOff: this.iconOff,
            iconOn: this.iconOn,
            iconOffStr: this.iconOffStr,
            iconOnStr: this.iconOnStr,
            changeSwitch: $changeSwitch,
          })
        }
        .onClick(() => {
          console.log(`start clickEvent ${this.changeSwitch}`)
          if (this.mClickEvent) {
            this.mClickEvent()
          }
          console.log(`end clickEvent ${this.changeSwitch}`)
        })
      }
      .height('100%')
      .layoutWeight(0)

      Column().width(this.style.componentGap).height('100%').layoutWeight(0)
      Row() {
        Row() {
          Column().width(this.style.textMargin).height('100%').layoutWeight(0)
          Text(this.useTitleStr ? this.mTitleStr : this.mTitle)
            .fontSize(this.style.titleSize)
            .fontColor(this.style.titleColor)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
            .layoutWeight(1)
            .onHover((isHover) => {
              this.mTextIsHover = isHover;
            })
          Column().width(this.style.textMargin).height('100%').layoutWeight(0)
        }
        .width('100%')
        .height(this.style.textHoverHeight)
        .width(this.style.textHoverWidth)
        .backgroundColor(this.mTextIsHover ? this.style.hoverColor : this.style.transparentColor)
        .borderRadius(this.style.textHoverRadius)
        .clip(true)
      }.height('100%')
      .layoutWeight(1)

      Column().width(this.style.marginRight).height('100%').layoutWeight(0)
    }
    .borderRadius(this.style.borderRadius)
    .clip(true)
    .backgroundColor(this.style.backgroundColor)
    .height('100%')
    .width('100%')
  }
}
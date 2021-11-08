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

import UniformConfig from './UniformConfig.ets'
import Log from '../default/Log.ets';
import iconComponent from './iconComponent.ets'

const TAG= 'iconTitleBase.ets'

@Component
export default
struct iconBaseComponent {

  private iconOn: any
  private iconOff: any
  private mTitle: string = "None"
  private mConfig = UniformConfig.config;
  private mClickEvent: Function

  @Link changeSwitch: boolean
  aboutToAppear() {
    Log.showInfo(TAG,'aboutToAppear')
  }

  aboutToDisappear () {
    Log.showInfo(TAG,'aboutToDisappear')
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        iconComponent({
          iconOff: this.iconOff,
          iconOn: this.iconOn,
          changeSwitch: $changeSwitch,
        })
      }
      .height('100%')
      .onClick(() => {
        console.log(`start clickEvent ${this.changeSwitch}`)
        this.mClickEvent()
        console.log(`end clickEvent ${this.changeSwitch}`)
      })
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
        Text(this.mTitle)
          .fontSize(this.mConfig.titleSize)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ left: 10 })
      }
      .height('100%')
    }
    .borderRadius(this.mConfig.baseBorderRadius)
    .backgroundColor(this.mConfig.baseColor)
    .height('100%')
    .width('100%')
  }
}
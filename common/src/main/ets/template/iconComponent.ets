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

@Component
export default
struct iconComponent {

  private mConfig = UniformConfig.config;
  @State iconOff: any = ""
  @State iconOn: any = ""

  @Link changeSwitch: boolean

  aboutToAppear() {
    console.log(`------iconTitleBaseComponent  ${this.changeSwitch} ${JSON.stringify(this.iconOff)}  ${JSON.stringify(this.iconOn) }`)
  }
  build() {
    Column() {
      Stack() {
        Flex()
          .backgroundColor(this.changeSwitch == false? this.mConfig.iconOffBG : this.mConfig.iconOnBG)
          .clip(new Circle({ width: this.mConfig.circleWidth, height: this.mConfig.circleHeight }))
          .width(this.mConfig.circleWidth)
          .height(this.mConfig.circleHeight)
        Image(this.changeSwitch == false? this.iconOff: this.iconOn)
          .size({ width: this.mConfig.iconWidth, height: this.mConfig.iconHeight })
          .objectFit(ImageFit.Contain)
      }.margin({ left: 10 })
    }
  }
}

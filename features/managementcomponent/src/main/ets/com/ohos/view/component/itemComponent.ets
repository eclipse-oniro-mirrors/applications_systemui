/**
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
import ConfigData from '../../common/constants.ets';

@Component
export default struct ItemComponent {
  @Prop title: string
  @Prop value: string
  @State arrow: string | PixelMap | Resource= ''

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Row() {
        Text(this.title)
          .fontSize($r('app.float.itemComp_titel_font'))
          .fontColor($r('app.color.itemComp_title_color'))
          .width(ConfigData.WH_45_100)
          .textAlign(TextAlign.Start)
          .fontWeight(FontWeight.Bold)
        Text(this.value)
          .fontSize($r('app.float.itemComp_value_font'))
          .fontColor($r('app.color.itemComp_font_color'))
          .width(ConfigData.WH_45_100)
          .textAlign(TextAlign.End);
        Image(this.arrow)
          .width($r('app.float.itemComp_image_width'))
          .height($r('app.float.itemComp_image_height'))
      }
      .width(ConfigData.WH_100_100)
      .alignItems(VerticalAlign.Center)
      .padding({ left: $r('app.float.itemComp_padding_l') })
    }
    .width(ConfigData.WH_100_100)
    .height($r('app.float.itemComp_height'))
    .border({ width: $r('app.float.border_width'), color: Color.White,
      radius: $r('app.float.border_radius') })
    .backgroundColor(Color.White)
    .margin({
      left: $r('app.float.page_margin_l'),
      right: $r('app.float.page_margin_r'),
      bottom: $r('app.float.itemComp_margin_b')
    })
  }
}

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
export default struct SlotItemComponent {
  @Prop slotType: number;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Row() {
        if (this.slotType === 0) {
          Text($r('app.string.slot_unknown')).fontColor($r('app.color.background_color'))
            .fontSize($r('app.float.slotComp_font'))
            .textAlign(TextAlign.Start)
        }
        if (this.slotType === 1) {
          Text($r('app.string.slot_social_communication')).fontColor($r('app.color.background_color'))
            .fontSize($r('app.float.slotComp_font'))
            .textAlign(TextAlign.Start)
        }
        if (this.slotType === 2) {
          Text($r('app.string.slot_service_information')).fontColor($r('app.color.background_color'))
            .fontSize($r('app.float.slotComp_font'))
            .textAlign(TextAlign.Start)
        }
        if (this.slotType === 3) {
          Text($r('app.string.slot_content_information')).fontColor($r('app.color.background_color'))
            .fontSize($r('app.float.slotComp_font'))
            .textAlign(TextAlign.Start)
        }
        if (this.slotType === 0xFFFF) {
          Text($r('app.string.slot_other')).fontColor($r('app.color.background_color'))
            .fontSize($r('app.float.slotComp_font'))
            .textAlign(TextAlign.Start)
        }
      }
      .flexShrink(0)
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Start)

      if (this.slotType !== 0) {
        Row() {
          Image($r('app.media.ic_settings_arrow'))
            .width($r('app.float.slotComp_image_width'))
            .height($r('app.float.slotComp_image_height'))
            .visibility(Visibility.Visible);
        }
        .margin({ right: $r('app.float.page_margin_r') })
        .align(Alignment.End);
      }
    }
    .margin({ left: $r('app.float.page_margin_l') })
    .width(ConfigData.WH_100_100);
  }
}
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
import Router from '@system.router';

@Component
export default
struct HeadComponent {
  private isActive: boolean= true;
  private icBackIsVisibility: boolean= true;
  private headName: string= '';
  @State isTouch: boolean= false;

  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .width($r('app.float.appitem_icon_width'))
        .height($r('app.float.appitem_icon_height'))
        .borderRadius($r('app.float.image_border_radius'))
        .margin({
        left: $r('app.float.page_margin_r'),
        top: $r('app.float.page_margin_t'),
        bottom: $r('app.float.page_margin_b')
      })
        .backgroundColor(this.isTouch ? $r('app.color.background_color') : $r('app.color.background_transparent'))
        .visibility(this.icBackIsVisibility ? Visibility.Visible : Visibility.None)
        .onTouch(() => {
        this.isTouch = true;
        Router.back();
      })
      Text(this.headName)
        .fontSize($r('app.float.page_title_font'))
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
        .width(ConfigData.WH_100_100)
        .maxLines(ConfigData.MAX_LINES_1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: $r('app.float.page_margin_l'), right: $r('app.float.page_margin_r') });
    }
    .width(ConfigData.WH_100_100)
    .height($r('app.float.page_title_height'))
    .alignItems(VerticalAlign.Center)
    .align(Alignment.Start)
    .backgroundColor( $r('app.color.background_color'))
  }
}
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

import Constants, {NotificationItemData} from '../../common/constants.ets';
import CheckEmptyUtils from '../../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';

@Component
export default struct PictureItem {
  @State itemData: NotificationItemData= undefined
  @Prop isExpand: boolean

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
        Text(this.isExpand ? this.itemData.expandedTitle : this.itemData.title)
          .maxLines(Constants.DEFAULT_MAX_LINES)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize($r('app.float.notification_title_fontsize'))
          .fontColor($r('app.color.title_text_color'))
          .fontWeight(FontWeight.Bold)
          .lineHeight(Constants.CONTENT_LINE_HEIGHT)
        Text(this.isExpand ? this.itemData.text : this.itemData.briefText)
          .maxLines(this.isExpand ? Constants.EXPENDED_MAX_LINES : Constants.DEFAULT_MAX_LINES)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .constraintSize({ maxHeight: $r('app.float.notification_expanded_text_maxheight') })
          .fontSize($r('app.float.notification_content_fontsize'))
          .fontColor($r('app.color.content_text_color'))
          .lineHeight(Constants.CONTENT_LINE_HEIGHT)
          .margin({ top: $r('app.float.content_margin_top') })
        if (!CheckEmptyUtils.isEmpty(this.itemData.picture) && this.isExpand) {
          Column() {
            Image(this.itemData.picture)
              .objectFit(ImageFit.Contain)
              .height($r("app.float.picture_default_height"))
          }
          .margin({ top: $r('app.float.content_margin_top') })
        }
      }
    }
  }
}
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

import Constants from '../common/constants.ets';
import {NotificationItemData} from '../../../../../../../../notificationService/src/main/ets/com/ohos/notificationservice/common/constants.ets';

@Component
export default struct MultiItem {
  @State itemData: NotificationItemData= undefined
  @Prop isExpand: boolean

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
      Text(this.isExpand ? this.itemData.longTitle : this.itemData.title)
        .maxLines(Constants.DEFAULT_MAX_LINES)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize($r('app.float.notification_title_fontsize'))
        .fontColor($r('app.color.title_text_color'))
        .fontWeight(FontWeight.Bold)
        .lineHeight(Constants.CONTENT_LINE_HEIGHT)
      if (this.isExpand) {
        ForEach(this.itemData.lines,
          (item: string) => {
            Text(`${item}`)
              .fontSize($r('app.float.notification_content_fontsize'))
              .fontColor($r('app.color.content_text_color'))
              .margin({ top: $r('app.float.content_margin_top') })
          }, (item: string) => item.toString()
        )
      } else {
        Text(this.itemData.text)
          .fontSize($r('app.float.notification_content_fontsize'))
          .maxLines(Constants.DEFAULT_MAX_LINES)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor($r('app.color.content_text_color'))
          .margin({ top: $r('app.float.content_margin_top') })
      }
    }.width('100%')
  }
}

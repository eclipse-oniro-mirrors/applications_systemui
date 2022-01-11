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

import Constants from '../../common/constants.ets';
import basicItem from './basicItem.ets';
import longItem from './longItem.ets';
import multiItem from './multiItem.ets';
import pictureItem from './pictureItem.ets';
import titleItem from './titleItem.ets';
import Log from '../../../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import ViewModel from '../../viewmodel/ViewModel.ets';
import ActionComponent from './actionComponent.ets';

const TAG = 'NoticeItem-GeneralItem';

@Component
export default struct GeneralItem {
  private generalItemData: any = {}
  @State hasPicture: boolean = false
  @State isExpand: boolean = false
  @State needExpand: boolean = true

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
    if (CheckEmptyUtils.isEmpty(this.generalItemData.largeIcon)) {
      this.hasPicture = false;
    } else {
      this.hasPicture = true;
    }
    this.needExpand = this.checkItemNeedExpand()
  }

  checkItemNeedExpand() {
    if (this.generalItemData.contentType === Constants.NOTIFICATION_TYPE_BASIC
    && (!(this.generalItemData.actionButtons?.length > 0))) {
      return false;
    } else {
      return true;
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
  }

  build() {
    Column() {
      titleItem({
        notificationSmallIcon: this.generalItemData.smallIcon,
        notificationName: this.generalItemData.appName,
        notificationTime: this.generalItemData.time,
        isExpand: $isExpand,
        needExpand: this.needExpand
      })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          if (this.generalItemData.contentType === Constants.NOTIFICATION_TYPE_BASIC) {
            basicItem({
              itemData: this.generalItemData
            });
          }
          if (this.generalItemData.contentType === Constants.NOTIFICATION_TYPE_LONG) {
            longItem({
              itemData: this.generalItemData,
              isExpand: this.isExpand
            });
          }
          if (this.generalItemData.contentType === Constants.NOTIFICATION_TYPE_MULTILINE) {
            multiItem({
              itemData: this.generalItemData,
              isExpand: this.isExpand
            });
          }
          if (this.generalItemData.contentType === Constants.NOTIFICATION_TYPE_PICTURE) {
            pictureItem({
              itemData: this.generalItemData,
              isExpand: this.isExpand
            });
          }
        }
        .width(this.hasPicture ? '85%' : '100%')
        .margin({ top: $r('app.float.body_margin_top') })

        if (this.hasPicture) {
          Column() {
            Image(this.generalItemData.largeIcon)
              .objectFit(ImageFit.Contain)
              .width(50)
              .height(50)
          }
          .alignItems(HorizontalAlign.End)
          .margin({ top: $r('app.float.body_margin_top') })
          .width('15%')
        }
      }
      .onClick(() => {
        ViewModel.clickItem(this.generalItemData);
      })

      if (this.isExpand) {
        ActionComponent({ itemData: this.generalItemData })
      }
    }
    .backgroundColor($r('app.color.notificationitem_background'))
    .opacity($r('app.float.item_opicaty'))
    .borderRadius($r('app.float.item_borderradius'))
    .margin({
      left: $r('app.float.item_marginleft'),
      right: $r('app.float.item_marginright'),
      top: $r('app.float.item_margintop')
    })
    .padding({
      left: $r('app.float.item_paddingleft'),
      right: $r('app.float.item_paddingright'),
      bottom: $r('app.float.item_paddingbottom')
    })

  }
}

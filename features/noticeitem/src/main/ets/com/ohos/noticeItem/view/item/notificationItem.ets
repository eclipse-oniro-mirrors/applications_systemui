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
import basicItem from './basicItem.ets';
import longItem from './longItem.ets';
import multiItem from './multiItem.ets';
import pictureItem from './pictureItem.ets';
import titleItem from './titleItem.ets';
import Log from '../../../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import ViewModel from '../../viewmodel/ViewModel.ets';
import SettingDialog from './settingDialog.ets';
import ConfirmDialog from './confirmDialog.ets';
import ActionComponent from './actionComponent.ets';

const TAG = 'NoticeItem-NotificationItem';

@Component
export default struct NotificationItem {
  private itemData: any = {}
  @State hasPicture: boolean = false
  @State isExpand: boolean = false
  @State needExpand: boolean = true
  @State deleteIconDisplay: boolean = false;
  @State itemWidth: string = '100%'
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0

  settingDialogController: CustomDialogController = new CustomDialogController({
    builder: SettingDialog({
      itemData: this.itemData,
      action: this.showConfirmDialog.bind(this)
    }),
    autoCancel: false,
    offset: { dx: 0, dy: 200 }
  });

  confirmDialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmDialog({
      title: $r('app.string.closeNovice'),
      bundleName: this.itemData.name,
      action:  ViewModel.removeNotificationItem.bind(ViewModel,this.itemData,true)
    }),
    autoCancel: false,
    offset: { dx: 0, dy: 250 }
  });

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
    if (CheckEmptyUtils.isEmpty(this.itemData.largeIcon)) {
      this.hasPicture = false;
    } else {
      this.hasPicture = true;
    }
    this.needExpand = this.checkItemNeedExpand()
  }

  checkItemNeedExpand() {
    if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_BASIC && (!(this.itemData.actionButtons?.length > 0))) {
      return false;
    } else {
      return true;
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          titleItem({
            notificationSmallIcon: this.itemData.smallIcon,
            notificationName: this.itemData.appName,
            notificationTime: this.itemData.time,
            isExpand: $isExpand,
            needExpand: this.needExpand
          })

          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
              if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_BASIC) {
                basicItem({
                  itemData: this.itemData
                });
              }
              if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_LONG) {
                longItem({
                  itemData: this.itemData,
                  isExpand: this.isExpand
                });
              }
              if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_MULTILINE) {
                multiItem({
                  itemData: this.itemData,
                  isExpand: this.isExpand
                });
              }
              if (this.itemData.contentType === Constants.NOTIFICATION_TYPE_PICTURE) {
                pictureItem({
                  itemData: this.itemData,
                  isExpand: this.isExpand
                });
              }
            }
            .width(this.hasPicture ? '85%' : '100%')
            .margin({ top: $r('app.float.body_margin_top') })

            if (this.hasPicture) {
              Column() {
                Image(this.itemData.largeIcon)
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
            ViewModel.clickItem(this.itemData);
          })

          if (this.isExpand) {
            ActionComponent({ itemData: this.itemData })
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
          bottom: this.isExpand ? 0 : $r('app.float.item_paddingbottom')
        })
        .onTouch(this.touchNotificationItem.bind(this))
        .width(this.itemWidth)

        if (this.deleteIconDisplay) {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
            Row({ space: 30 }) {
              Image($r("app.media.ic_setting")) //setting
                .objectFit(ImageFit.Contain)
                .width($r('app.float.item_delete_image_width'))
                .height($r('app.float.item_delete_image_height'))
                .onClick(this.showSettingDialog.bind(this))
              Image($r('app.media.delete')) //delete
                .objectFit(ImageFit.Contain)
                .width($r('app.float.item_delete_image_width'))
                .height($r('app.float.item_delete_image_height'))
                .onClick(() => {
                  ViewModel.removeNotificationItem(this.itemData, true);
                })
            }
          }
          .width('30%')
        }
      }
    }
  }

  showSettingDialog() {
    Log.showInfo(TAG, `showSettingDialog`)
    this.settingDialogController.open()
  }

  showConfirmDialog() {
    Log.showInfo(TAG, `showConfirmDialog`)
    this.confirmDialogController.open()
  }

  touchNotificationItem(event: TouchEvent) {
    if (event.type == Constants.TOUCH_TYPE_DOWN) { //down
      this.startX = event.touches[0].x;
      this.startY = event.touches[0].y;
      Log.showInfo(TAG, `touchStart=======startX: ${this.startX}, startY: ${this.startY}`);
    } else if (event.type == Constants.TOUCH_TYPE_MOVE) { //move
      this.moveX = event.touches[0].x - this.startX;
      this.moveY = event.touches[0].y - this.startY;
    } else if (event.type == Constants.TOUCH_TYPE_UP) { //up
      Log.showInfo(TAG, `touchEnd, moveX: ${this.moveX}, moveY: ${this.moveY}`);
      if (this.deleteIconDisplay) {
        if (this.moveX > Constants.HIDDEN_TRANSLATE_X) {
          //hidden
          this.deleteIconDisplay = false;
          this.itemWidth = '100%';
          Log.showInfo(TAG, 'hidden');
        }
      } else {
        if (this.moveX < Constants.DISPLAY_TRANSLATE_X) {
          this.deleteIconDisplay = true;
          this.itemWidth = '70%';
          Log.showInfo(TAG, 'display');
        } else if (this.moveX > Constants.REMOVE_TRANSLATE_X) {
          ViewModel.removeNotificationItem(this.itemData, true);
        }
      }
    }
  }
}

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

import Constants  from '../../common/constants.ets';
import GeneralItem from './generalItem.ets';
import CustomItem from './customItem.ets';
import Log from '../../../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import ViewModel from '../../viewmodel/ViewModel.ets';
import SettingDialog from './settingDialog.ets';
import ConfirmDialog from './confirmDialog.ets'

const TAG = 'NoticeItem-NotificationItem';

@Component
export default struct NotificationItem {
  private itemData: any = {}
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
      action: ViewModel.removeNotificationItem.bind(ViewModel, this.itemData, true)
    }),
    autoCancel: false,
    offset: { dx: 0, dy: 250 }
  });

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          if (CheckEmptyUtils.isEmpty(this.itemData.template)) {
            GeneralItem({ generalItemData: this.itemData })
          } else {
            CustomItem({ customItemData: this.itemData })
          }
        }
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
              if (this.itemData.isRemoveAllowed) {
                Image($r('app.media.delete')) //delete
                  .objectFit(ImageFit.Contain)
                  .width($r('app.float.item_delete_image_width'))
                  .height($r('app.float.item_delete_image_height'))
                  .onClick(() => {
                    ViewModel.removeNotificationItem(this.itemData, true);
                  })
              }
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

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
import basicItem from './basicItem.ets';
import longItem from './longItem.ets';
import multiItem from './multiItem.ets';
import titleItem from './titleItem';
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import mNotificationService from '../../../../../../../../../features/notificationService/src/main/ets/com/ohos/notificationservice/NotificationService.ets'
import WantAgent from '@ohos.wantAgent';
import WindowManager from '../../../../../../../../../common/src/main/ets/default/WindowManager.ets';
import {NotificationItemData} from '../../../../../../../../notificationService/src/main/ets/com/ohos/notificationservice/common/constants.ets';

const TAG = 'NoticeItem-NotificationItem';
let mWindowManager;

@Component
export default struct NotificationItem {
  @Link showStatusBar: boolean
  private itemData: NotificationItemData
  @State hasPicture: boolean = false
  @State isExpand: boolean = false
  @State needExpand: boolean = true
  @State deleteIconDisplay: boolean = false;
  @State itemWidth: string = '100%'
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToDisAppear Start`)
    mWindowManager = new WindowManager();
    if (CheckEmptyUtils.isEmpty(this.itemData.largeIcon)) {
      this.hasPicture = false;
    } else {
      this.hasPicture = true;
    }
    this.needExpand=this.checkItemNeedExpand()
  }

  checkItemNeedExpand(){
    if(this.itemData.contentType===Constants.NOTIFICATION_TYPE_BASIC&&(!(this.itemData.actionButtons?.length>0))){
      return false;
    }else{
      return true;
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          titleItem({
            notificationSmallIcon: this.itemData.smallIcon,
            notificationName: this.itemData.name,
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
              .width('15%')
            }
          }.onClick(this.clickItem.bind(this))

          if(this.isExpand){
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
            ForEach(this.itemData.actionButtons, (item: any) => {
              Text(item.title)
                .fontSize(20)
                .height(30)
                .fontColor(Color.Blue)
                .margin({ right: 20 })
                .onClick(() => {
                Log.showInfo(TAG, `clickbuttonEvent: ${JSON.stringify(item.wantAgent)}`)
                this.startTargetAbility(item.wantAgent)
              })
            })
          }
          .margin({ top: 10 })
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
        .onTouch(this.touchNotificationItem.bind(this))
        .width(this.itemWidth)

        if (this.deleteIconDisplay) {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
            Image($r('app.media.delete')) //delete
            .objectFit(ImageFit.Contain)
              .width($r('app.float.item_delete_image_width'))
              .height($r('app.float.item_delete_image_height'))
              .onClick(() => {
              this.removeNotificationItem(this.itemData.hashcode);
            })
          }
          .width('30%')
        }
      }
    }
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
          this.removeNotificationItem(this.itemData.hashcode);
        }
      }
    }
  }

  removeNotificationItem(hashCode: string) {
    Log.showInfo(TAG, 'removeNotificationItem');
    mNotificationService.removeNotificationItem(hashCode, true);
  }

  clickItem() {
    Log.showInfo(TAG, 'click Item');
    this.startTargetAbility(this.itemData.want);
  }

  startTargetAbility(want) {
    Log.showInfo(TAG, 'startTargetAbility');
    //close window
    this.showStatusBar = true;
    mWindowManager.setWindowMin((result) => {
      Log.showInfo(TAG, `setWindowMin ${result}`);
    });
    //open app
    Log.showInfo(TAG, `itemClick  wantAgent ${JSON.stringify(this.itemData.want)} id: ${this.itemData.id}`);
    let TriggerInfo = {
      code: 0,
      want: '',
      permission: '',
      extraInfo: {}
    };
    WantAgent.trigger(want, TriggerInfo, ((err, data) => {
      Log.showInfo(TAG, `itemClick  wantAgent trigger err ${JSON.stringify(err)} data ${JSON.stringify(data)}`);
    }));
    //remove notification
    this.removeNotificationItem(this.itemData.hashcode);
  }
}

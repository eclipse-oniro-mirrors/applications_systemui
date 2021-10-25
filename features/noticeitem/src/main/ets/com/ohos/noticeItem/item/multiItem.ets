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
import titleItem from './titleItem';
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import mNotificationService from '../../../../../../../../../features/notificationService/src/main/ets/com/ohos/notificationservice/NotificationService.ets'
import WantAgent from '@ohos.wantAgent';
import WindowManager from '../../../../../../../../../common/src/main/ets/default/WindowManager.ets';

const TAG = 'NoticeItem-multiItem';

let mWindowManager;

@Component
export default
struct MultiItem {
  @Link showStatusBar: boolean
  @Prop notificationId: string
  private notificationSmallIcon: PixelMap
  private notificationLargeIcon: PixelMap
  private notificationActionButtons: any
  @State hasPicture: boolean = false
  @Prop notificationHashCode: string
  @Prop notificationText: string
  @Prop notificationBriefText: string
  @Prop notificationLongTitle: string
  private notificationLines: string[]
  @Prop notificationName: string
  @Prop notificationTime: string
  @Prop notificationTitle: string
  private notificationWant: any
  @State isExpand: boolean = false
  @State needExpand: boolean = true
  @State iconDisplay: boolean = false;
  @State itemWidth: string = '100%'
  startX: number = 0
  startY: number = 0
  @State moveX: number = 0
  @State moveY: number = 0

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear id: ${this.notificationId}`);
    mWindowManager = new WindowManager();
    if (CheckEmptyUtils.isEmpty(this.notificationLargeIcon)) {
      this.hasPicture = false;
    } else {
      this.hasPicture = true;
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear id: ${this.notificationId}`);
  }

  build() {
    Row() {
      Column() {
        titleItem({
          notificationSmallIcon: this.notificationSmallIcon,
          notificationName: this.notificationName,
          notificationTime: this.notificationTime,
          isExpand: $isExpand,
          needExpand: this.needExpand
        })

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
            Text(this.isExpand ? this.notificationLongTitle : this.notificationTitle)
              .maxLines(Constants.DEFAULT_MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize($r('app.float.notification_title_fontsize'))
              .fontColor($r('app.color.title_text_color'))
              .fontWeight(FontWeight.Bold)
              .lineHeight(Constants.CONTENT_LINE_HEIGHT)
            if (this.isExpand) {
              ForEach(this.notificationLines,
                (item: string) => {
                  Text(`${item}`)
                    .fontSize($r('app.float.notification_content_fontsize'))
                    .fontColor($r('app.color.content_text_color'))
                    .margin({ top: $r('app.float.content_margin_top') })
                }, (item: string) => item.toString()
              )
            } else {
              Text(this.notificationText)
                .fontSize($r('app.float.notification_content_fontsize'))
                .maxLines(Constants.DEFAULT_MAX_LINES)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontColor($r('app.color.content_text_color'))
                .margin({ top: $r('app.float.content_margin_top') })
            }
          }
          .width(this.hasPicture ? '85%' : '100%')
          .margin({ top: $r('app.float.body_margin_top') })

          if (this.hasPicture) {
            Column() {
              Image(this.notificationLargeIcon)
              .objectFit(ImageFit.Contain)
                .width(50)
                .height(50)
            }
            .alignItems(HorizontalAlign.End)
            .width('15%')
          }
        }
        .onClick(this.clickMultiItem.bind(this))

        if (this.isExpand) {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
            ForEach(this.notificationActionButtons, (item: any) => {
              Text(item.title)
                .fontSize(20)
                .height(30)
                .fontColor(Color.Blue)
                .margin({ right: 20 })
                .onClick(() => {
                Log.showInfo(TAG, `clickbuttonEvent: ${JSON.stringify(item.wantAgent)}`)
                this.startTargetAbility(item.wantAgent)
              })
            }
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


      if (this.iconDisplay) {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
          Image($r('app.media.delete')) //delete
          .objectFit(ImageFit.Contain)
            .width($r('app.float.item_delete_image_width'))
            .height($r('app.float.item_delete_image_height'))
            .onClick(() => {
            this.removeNotificationItem(this.notificationHashCode);
          })
        }
        .width('30%')
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
      if (this.iconDisplay) {
        if (this.moveX > Constants.HIDDEN_TRANSLATE_X) {
          //hidden
          this.iconDisplay = false;
          this.itemWidth = '100%';
          Log.showInfo(TAG, 'hidden');
        }
      } else {
        if (this.moveX < Constants.DISPLAY_TRANSLATE_X) {
          this.iconDisplay = true;
          this.itemWidth = '70%';
          Log.showInfo(TAG, 'display');
        } else if (this.moveX > Constants.REMOVE_TRANSLATE_X) {
          this.removeNotificationItem(this.notificationHashCode);
        }
      }
    }
  }

  removeNotificationItem(hashCode: string) {
    Log.showInfo(TAG, 'removeNotificationItem');
    mNotificationService.removeNotificationItem(hashCode, true);
  }

  clickMultiItem() {
    Log.showInfo(TAG, 'clickMultiItem');
    this.startTargetAbility(this.notificationWant);
  }

  startTargetAbility(want) {
    Log.showInfo(TAG, 'startTargetAbility');
    //close window
    this.showStatusBar = true;
    mWindowManager.setWindowMin((result) => {
      Log.showInfo(TAG, `setWindowMin ${result}`);
    });
    //open app
    Log.showInfo(TAG, `longitemClick  wantAgent ${JSON.stringify(this.notificationWant)} id: ${this.notificationId}`);
    let TriggerInfo = {
      code: 0,
      want: '',
      permission: '',
      extraInfo: {}
    };
    WantAgent.trigger(want, TriggerInfo, ((err, data) => {
      Log.showInfo(TAG, `longitemClick  wantAgent trigger err ${JSON.stringify(err)}`);
      Log.showInfo(TAG, `longitemClick  wantAgent trigger data ${JSON.stringify(data)}`);
    }));
    //remove notification
    this.removeNotificationItem(this.notificationHashCode);
  }
}

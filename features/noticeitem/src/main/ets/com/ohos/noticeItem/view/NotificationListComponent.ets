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

import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import Constants from '../common/constants.ets';
import NotificationItem from './item/notificationItem.ets'
import ViewModel from '../viewmodel/ViewModel.ets'

const TAG = 'NoticeItem-NotificationListComponent';

@Component
export default struct NotificationListComponent {
  @StorageLink('notificationList') notificationList: any[] = []
  @StorageProp('maxHeight') maxHeight: number = 0
  @StorageProp('minHeight') minHeight: number = 0
  @State notificationH: number = 0

  aboutToAppear() {
    Log.showInfo(TAG, `notificationList, aboutToAppear`)
    this.notificationH = this.maxHeight - (this.minHeight * 2) - Constants.QUICKLY_SETTING_H;
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      if (this.notificationList.length == 0) {
        //text: no notification
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text($r('app.string.nonotification_text'))
            .fontColor($r('app.color.nonotification_text_color'))
        }
      } else {
        Stack({ alignContent: Alignment.TopStart }) {
          List() {
            ForEach(this.notificationList, (item: any) => {
              ListItem() {
                NotificationItem({ itemData: item })
              }
            }, (item: any) => item.hashcode.toString())
          }
          .onTouch((event: TouchEvent) => {
            Log.showInfo(TAG, `Touch Event ${event.type} at Point ${event.touches[0].x}, ${event.touches[0].y}`)
            event.stopPropagation();
          })

          Flex() { //bottom Line
          }.width('100%').height('7%')
          .opacity($r('app.float.deleteall_image_opacity'))
          .position({ x: 0, y: '93%' })
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height(this.notificationH)
  }
}
/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import Log from '../../../../../../../common/src/main/ets/default/Log'
import EventManager from "../../../../../../../common/src/main/ets/default/event/EventManager"
import {obtainStartAbility} from "../../../../../../../common/src/main/ets/default/event/EventUtil"
import NotificationListComponent from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/view/NotificationListComponent'
import NotificationViewModel from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/viewmodel/NotificationViewModel'

const TAG = 'NotificationPanel-notification'
const NO_NOTIFICATION_TOP_MARGIN = 40;
const NOTIFICATION_TEXT_SIZE = 20;
const NOTIFICATION_TOTAL_MARGIN = 20;
const NOTIFICATION_ITEM_MARGIN = 16;
const NOTIFICATION_ICON_SIZE = 24;
const NOTIFICATION_TITLE_HEIGHT = 58;
const NOTIFICATION_TITLE_MARGIN = 4;
const NOTIFICATION_TITLE_ICON_MARGIN = 24;

@Component
export default struct Notification {
  @StorageLink('notificationList') notificationList: any[] = []

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
    AbilityManager.setContextName(AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL,AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      Column() {
        CenterTitle()
      }
      .flexShrink(0)
      if (this.notificationList.length == 0) {
        Text($r("app.string.no_notification"))
          .fontColor($r("sys.color.ohos_id_color_text_primary"))
          .fontSize($r("sys.float.ohos_id_text_size_sub_title2"))
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Center)
          .margin({ top: NO_NOTIFICATION_TOP_MARGIN })
      } else {
        Column() {
          NotificationListComponent({ config: { itemMargin: NOTIFICATION_ITEM_MARGIN } })
        }
        .flexShrink(1)
      }
    }.padding({ left: NOTIFICATION_TOTAL_MARGIN, right: NOTIFICATION_TOTAL_MARGIN })
    .width('100%')
  }
}

@Component
struct CenterTitle {
  aboutToAppear() {
    Log.showInfo(TAG, `CenterTitle, aboutToAppear`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `CenterTitle, aboutToDisappear`)
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r("app.string.notification_center"))
        .fontColor($r("sys.color.ohos_id_color_text_primary"))
        .fontSize(NOTIFICATION_TEXT_SIZE)
        .fontWeight(FontWeight.Medium)
        .margin({ left: NOTIFICATION_TITLE_MARGIN })
      Blank()
      Image($r('app.media.ic_public_settings'))
        .objectFit(ImageFit.Contain)
        .fillColor($r("app.color.notification_title_image_color"))
        .width(NOTIFICATION_ICON_SIZE)
        .height(NOTIFICATION_ICON_SIZE)
        .margin({ right: NOTIFICATION_TITLE_ICON_MARGIN })
        .onClick(this.settingClick.bind(this))
      Image($r('app.media.ic_public_delete'))
        .objectFit(ImageFit.Contain)
        .fillColor($r("app.color.notification_title_image_color"))
        .width(NOTIFICATION_ICON_SIZE)
        .height(NOTIFICATION_ICON_SIZE)
        .margin({ right: NOTIFICATION_TITLE_MARGIN })
        .onClick(() => {
          NotificationViewModel.removeAllNotifications();
        })
    }
    .height(NOTIFICATION_TITLE_HEIGHT)
  }

  settingClick() {
    Log.showDebug(TAG, ` settingClick `)
    EventManager.publish(obtainStartAbility('com.ohos.systemui', 'com.ohos.systemui.notificationmanagement.MainAbility'))
  }
}
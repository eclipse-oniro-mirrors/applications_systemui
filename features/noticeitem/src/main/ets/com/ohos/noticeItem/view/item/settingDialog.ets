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

import Constants,{NotificationItemData} from '../../common/constants.ets';
import Log from '../../../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import FeatureAbilityManager from '../../../../../../../../../../common/src/main/ets/default/abilitymanager/featureAbilityManager.ets';
import WindowManager from '../../../../../../../../../../common/src/main/ets/default/WindowManager.ets'
import Notification from '@ohos.notification';

const TAG = 'NoticeItem-Setting';

/**
 * Setting dialog
 */
@CustomDialog
export default struct SettingDialog {
  private itemData: NotificationItemData
  public controller: CustomDialogController
  public action: () => void

  build() {

    Column({ space: 30 }) {
      Row({ space: 10 }) {
        if (!CheckEmptyUtils.isEmpty(this.itemData.smallIcon)) {
          Image(this.itemData.smallIcon)
            .objectFit(ImageFit.Contain)
            .width($r('app.float.title_image_width'))
            .height($r('app.float.title_image_height'))
        }
        Text(this.itemData.appName)
          .fontSize($r('app.float.setting_title_fontsize'))
      }.width(Constants.SETTING_DIALOG_WITH)
      .margin({ top: 50 })

      Row() {
        Column() {
          Text($r('app.string.closeNotification'))
            .fontSize($r('app.float.setting_cont_fontsize'))
            .fontColor($r('app.color.dialog_font_color'))
            .height(Constants.SETTING_CONT_HEIGHT)

        }.alignItems(HorizontalAlign.Center)
        .width(Constants.SETTING_CONTENT_WITH)
      }
      .width(Constants.SETTING_DIALOG_WITH)
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Center)
      .border({ width: $r('app.float.setting_border_width'), color: Color.White,
        radius: $r('app.float.setting_border_radius') })
      .backgroundColor($r('app.color.dialog_font_back_color'))
      .onClick(this.closeNotification.bind(this))

      Row() {
        Column() {
          Text($r('app.string.moreSettings'))
            .fontSize($r('app.float.setting_cont_fontsize'))
            .fontColor($r('app.color.dialog_font_color'))
            .height(Constants.SETTING_CONT_HEIGHT)
        }.alignItems(HorizontalAlign.Center)
        .width(Constants.SETTING_CONTENT_WITH)
      }
      .width(Constants.SETTING_DIALOG_WITH)
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Center)
      .border({ width: $r('app.float.setting_border_width'), color: Color.White,
        radius: $r('app.float.setting_border_radius') })
      .backgroundColor($r('app.color.dialog_font_back_color'))
      .onClick(this.openAbility.bind(this))

      Row() {
        Column() {
          Text($r('app.string.cancel'))
            .maxLines(Constants.DEFAULT_MAX_LINES)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize($r('app.float.setting_cont_fontsize'))
            .fontColor($r('app.color.dialog_font_back_color'))
            .height(Constants.SETTING_CONT_HEIGHT)
        }.alignItems(HorizontalAlign.Center)
        .width(Constants.SETTING_CONTENT_WITH)
      }
      .width(Constants.SETTING_DIALOG_WITH)
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Center)
      .border({ width: $r('app.float.setting_border_width'), color: Color.White,
        radius: $r('app.float.setting_border_radius') })
      .backgroundColor($r('app.color.dialog_font_color'))
      .onClick(this.closeAbility.bind(this))
    }.height(Constants.SETTING_DIALOG_HEIGHT)
  }

  closeNotification() {
    this.action()
    this.closeAbility()
  }

  openAbility() {
    Log.showInfo(TAG, ` openAbility:showNotificationManagement`)
    let mWindowManager = new WindowManager();
    mWindowManager.setWindowMin((result) => {
      Log.showInfo(TAG, `showNotificationManagement setWindowMin`)
      let mFeatureAbilityManager = new FeatureAbilityManager()
      mFeatureAbilityManager.openAbility(TAG, {
        want: {
          bundleName: 'com.ohos.systemui',
          abilityName: 'com.ohos.systemui.notificationmanagement.MainAbility'
        }
      });
    });
    AppStorage.Set("showStatusBar", true);
    this.closeAbility()
  }

  closeAbility() {
    Log.showInfo(TAG, `closeAbility`)
    this.controller.close()
  }
}
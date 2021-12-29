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

//import Window from '@ohos.window';
import Log from '../../../../../../../common/src/main/ets/default/Log.ets';
import HeadComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headComponent.ets';
import AppItemComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/appItemComponent.ets';
import SwitchComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/switchComponent.ets';
import SlotLstComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/slotLstComponent.ets';
import ConfigData from '../common/constants.ets';
import Router from '@system.router'

const TAG = 'NotificationManagement-SetEnable';

let appInfo;

@Entry
@Component
export default struct SetEnable {
  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Column({ space: 30 }) {
        HeadComponent({ headName: $r('app.string.notificationManagement'), isActive: true });
        Row() {
          AppItemComponent({
            appIcon: appInfo.appIcon,
            appTitle: appInfo.appTitle,
            appSummary: appInfo.appSummary,
            appValue: '',
            appArrow: appInfo.appArrow,
            appArrowStyle: '',
            appUri: appInfo.appUri,
            appBundleName: appInfo.appBundleName,
            appUid: appInfo.appUid,
            appSwitch: 0
          });
        }
        .margin({ left: $r('app.float.page_margin_l'), right: $r('app.float.page_margin_r') })
        .align(Alignment.Start)
        .backgroundColor($r('app.color.background_color'))


        Row() {
          SwitchComponent({
            title: $r('app.string.allowNotification'),
            appBundleName: appInfo.appBundleName,
            appUid: appInfo.appUid
          })
        }.margin({ left: $r('app.float.page_margin_l'),
          right: $r('app.float.page_margin_r') })
        .align(Alignment.Start)

        Row() {
          SlotLstComponent({ appBundleName: appInfo.appBundleName,
            appUid: appInfo.appUid })
        }
        .align(Alignment.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .backgroundColor($r('app.color.background_color'))
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
    }
    .width(ConfigData.WH_100_100)

  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    appInfo = Router.getParams();
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
    Router.back();
  }
}

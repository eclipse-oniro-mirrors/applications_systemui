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
import NoDisturbComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/noDisturbComponent.ets';
import ItemComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/itemComponent.ets';
import ConfigData from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/common/constants.ets';
import AppLstComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/appLstComponent.ets';
import Router from '@system.router';

const TAG = 'NotificationManagement-Main';

@Entry
@Component
export default struct notificationManagenment {
  build() {
    Column() {
      Row() {
        HeadComponent({ headName: $r('app.string.notification'), isActive: true });
      }.flexShrink(0)

      Row() {
        Text($r('app.string.noDisturb'))
          .fontSize($r('app.float.page_phrases_font'))
          .height($r('app.float.page_phrases_height'))
          .margin({ left: $r('app.float.page_margin_l'), bottom: $r('app.float.page_margin_t') })
      }.align(Alignment.Start)
      .width(ConfigData.WH_100_100)
      .flexShrink(0)

      Row() {
        NoDisturbComponent()
      }
      .align(Alignment.Start)
      .onClick(() => {
        Log.showInfo(TAG, `NoDisturbComponent on click`)
        Router.push({ uri: 'pages/noDisturb'});
      }).width(ConfigData.WH_100_100)
      .flexShrink(0)

      Row() {
        Text($r('app.string.notificationManagement'))
          .fontSize($r('app.float.page_phrases_font'))
          .height($r('app.float.page_phrases_height'))
          .margin({ left: $r('app.float.page_margin_l'), bottom: $r('app.float.page_margin_t') })
      }.align(Alignment.Start)
      .width(ConfigData.WH_100_100)
      .flexShrink(0)

      Row() {
        ItemComponent({ title: $r('app.string.batch_Management'), value: '', arrow: $r('app.media.ic_settings_arrow') })
      }.onClick(() => {
        Log.showInfo(TAG, `BatchManagement on click`)
        Router.push({ uri: 'pages/batchSetEnable' });
      }).width(ConfigData.WH_100_100)
      .flexShrink(0)

      Column() {
        AppLstComponent()
      }.flexShrink(1)
    }
    .backgroundColor($r('app.color.background_color'))
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100);
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
  }

  aboutToDisappear(): void{
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  onPageShow(): void{
    Log.showInfo(TAG, `onPageShow`)
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
  }
}

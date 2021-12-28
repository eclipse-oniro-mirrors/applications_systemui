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
import ConfigData from '../common/constants.ets';
import Router from '@system.router'

const TAG = 'NotificationManagement-BatchSetEnable';

@Entry
@Component
export default
struct BatchSetEnable {
  @StorageLink('appManagementList') appList: any[]= [];

  build() {
    Column() {
      HeadComponent({ headName: $r('app.string.batch_Management'), isActive: true });
      List() {
        ForEach(this.appList, (item) => {
          ListItem() {
            AppItemComponent({
              appIcon: item.appIcon,
              appTitle: item.appTitle,
              appSummary: item.appSummary,
              appValue: item.appValue,
              appArrow: item.appArrow,
              appArrowStyle: '',
              appUri: '',
              appBundleName:item.appBundleName,
              appUid:item.appUid,
              appSwitch:1
            });
          }
          .height($r('app.float.appitem_item_height'));
        });
      }
      .divider({
        strokeWidth: 1,
        color: $r('app.color.background_color'),
        startMargin: $r('app.float.divider_margin_l'),
        endMargin: $r('app.float.divider_margin_r')
      })
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
      .margin({ bottom: '90' })
      .visibility(Visibility.Visible)
      .zIndex(0);
    }
    .align(Alignment.Center)
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
    .border({ width: $r('app.float.border_width'), color:Color.White,
      radius:$r('app.float.border_radius') })
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
    Router.back();
  }

}

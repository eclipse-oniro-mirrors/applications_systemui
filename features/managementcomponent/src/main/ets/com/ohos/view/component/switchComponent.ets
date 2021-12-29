/**
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
import ConfigData from '../../common/constants.ets';
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import Notification from '@ohos.notification';
import Router from '@system.router'

const TAG = 'ManagementComponent-SwitchComponent';

@Component
export default struct SwitchComponent {
  private title: '';
  private appBundleName: string = '';
  private appUid: number = 0;
  @State canNotice: boolean= false

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Row() {
        Text(this.title)
          .fontSize($r('app.float.switchComp_titel_font'))
          .fontColor(Color.Black)
          .align(Alignment.Start)
      }
      .flexShrink(0)
      .height($r('app.float.switchComp_height'))
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Start)
      .padding({ right: $r('app.float.switchComp_padding_r') })
      .margin({ left: $r('app.float.page_margin_l') })

      Row() {
        Toggle({ type: ToggleType.Switch, isOn: this.canNotice })
          .align(Alignment.End)
          .width($r('app.float.toggle_comp_width'))
          .height($r('app.float.toggle_comp_height'))
          .onChange((data) => {
            Log.showInfo(TAG, `Toggle onChange param: ` + this.appBundleName + "  data:" + data)
            Notification.enableNotification({ bundle: this.appBundleName, uid: this.appUid }, data, (err, result) => {
            })

          })
      }
      .alignItems(VerticalAlign.Center)
      .align(Alignment.End)
      .padding({ right: $r('app.float.switchComp_padding_r') })
    }.width(ConfigData.WH_100_100)
    .border({ width: $r('app.float.border_width'), color: Color.White,
      radius: $r('app.float.border_radius') })
    .backgroundColor(Color.White)
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    Notification.isNotificationEnabled({ bundle: this.appBundleName, uid: this.appUid })
      .then((data) => {
        Log.showInfo(TAG, `Notification.isNotificationEnabled:` + data)
        this.canNotice = data;
        Log.showInfo(TAG, `Notification.isNotificationEnabled isOn:` + this.canNotice)
      });
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
    Router.back();
  }
}
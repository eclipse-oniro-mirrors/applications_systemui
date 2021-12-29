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

const TAG = 'ManagementComponent-AppItemComponent';

@Component
export default struct AppItemComponent {
  @State canNotice: boolean= false;
  @Prop appIcon: string;
  @Prop appTitle: string;
  @Prop appSummary: string;
  @Prop appValue: string;
  @Prop appArrow: string;
  @Prop appArrowStyle: string;
  @Prop appUri: string;
  @Prop appSwitch: number;
  @Prop appBundleName: string;
  @Prop appUid: number;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Row() {
        Image(this.appIcon)
          .width($r('app.float.appitem_icon_width'))
          .height($r('app.float.appitem_icon_height'))
          .margin({ right: $r('app.float.appitem_icon_margin_r') })
          .visibility('' === this.appIcon ? Visibility.None : Visibility.Visible)
          .objectFit(ImageFit.Contain);
        Column() {
          Text(this.appTitle)
            .fontColor($r('app.color.appitem_label_fontcolor'))
            .fontSize($r('app.float.appitem_label_font'))
            .textAlign(TextAlign.Start)
            .maxLines(ConfigData.MAX_LINES_3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: $r('app.float.appitem_label_margin_t'), bottom: $r('app.float.appitem_labelmargin_b') });
          Row() {
            Text($r('app.string.version'))
              .fontColor($r('app.color.appitem_version_fontcolor'))
              .fontSize($r('app.float.appitem_version_font'))
              .textAlign(TextAlign.Start)
              .maxLines(ConfigData.MAX_LINES_1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .visibility(Visibility.Visible)
              .margin({ bottom: $r('app.float.appitem_version_margin_b') });
            Text(this.appSummary)
              .fontColor($r('app.color.appitem_version_fontcolor'))
              .fontSize($r('app.float.appitem_version_font'))
              .textAlign(TextAlign.Start)
              .maxLines(ConfigData.MAX_LINES_1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .visibility(Visibility.Visible)
              .margin({ bottom: $r('app.float.appitem_version_margin_b') });
          }
        }
        .alignItems(HorizontalAlign.Start);
      }
      .flexShrink(0)
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Start)

      Row() {
        if (this.appSwitch === 0) {
          Text(this.appValue)
            .fontSize($r('app.float.appitem_version_font'))
            .fontColor($r('app.color.appitem_version_fontcolor'))
            .margin({ right: $r('app.float.appitem_version_margin_r') })
            .align(Alignment.End);
          Image(this.appArrow)
            .width($r('app.float.arrow_icon_width'))
            .height($r('app.float.arrow_icon_height'))
            .visibility(Visibility.Visible);
        } else {
          Toggle({ type: ToggleType.Switch, isOn: this.canNotice })
            .align(Alignment.End)
            .width($r('app.float.toggle_comp_width'))
            .height($r('app.float.toggle_comp_height'))
            .onChange((flag) => {
              Log.showInfo(TAG, `Toggle onChange param: ` + this.appBundleName + "  data:" + flag)
              Notification.enableNotification({ bundle: this.appBundleName, uid: this.appUid }, flag, (err, result) => {
              })
            })
        }
      }
      .margin({ right: $r('app.float.page_margin_r') })
      .align(Alignment.End);
    }
    .margin({ left: $r('app.float.page_margin_l') })
    .width(ConfigData.WH_100_100)
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
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

import {UpTitle} from './UpTitle.ets'
import AirPlaneComponent from "../../../../../../../features/airplanecomponent/src/main/ets/default/pages/airplaneComponent.ets"
import WifiComponent from '../../../../../../../features/wificomponent/src/main/ets/default/pages/wifiComponent.ets'
import {MyBrightness} from '../../../../../../../features/brightnesscomponent/src/main/ets/default/pages/brightnessComponent.ets'
import {MyVol} from '../../../../../../../features/volumecomponent/src/main/ets/default/pages/volumeComponent.ets'
import mWifiManger from "../../../../../../../features/wificomponent/src/main/ets/default//WifiModel.ets"
import Log from '../../../../../../../common/src/main/ets/default/Log.ets';
import UniformConfig from '../../../../../../../common/src/main/ets/template/UniformConfig.ets'

const TAG='Control-ControlCenter'

var mUniform;
@Component
export default
struct ControlCenterComponent {
  @Link showStatusBar: boolean
  @StorageLink('flyModelStatus') flyModelStatus: boolean = false
  @StorageLink('wifiOpenStatus') wifiOpenStatus: boolean = false
  @StorageLink("mWifiOriginalStatus") mWifiOriginalStatus: boolean = false

  componentUniform = {
    iconOnBG: "#0A59F7",
    iconOffBG: "#F5F5F5",
    baseColor: "#CCFFFFFF",
    circleWidth: 80,
    circleHeight: 80,
    iconWidth: 50,
    iconHeight: 50,
    titleSize: 20,
    iconTitleMargin: 10,
    baseBorderRadius: 15,
  }

  aboutToAppear() {
    Log.showInfo(TAG,'aboutToAppear')
    // 初始化自定义组件样式
    mUniform = UniformConfig.initParams(this.componentUniform)

    console.log(`------${JSON.stringify(mUniform)}`);
  }

  aboutToDisappear () {
    Log.showInfo(TAG,'aboutToDisappear ')
  }

  build() {
    Column() {
      Column() {
        UpTitle({ showStatusBar: $showStatusBar })
      }
      .width('100%')
      .height($r('app.float.up_title_height'))
      .margin({ top: $r('app.float.center_item_margin_top'),
        left: $r('app.float.center_item_margin_left'),
        right: $r('app.float.center_item_margin_right') })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Flex() {
          WifiComponent()
        }
        .width('48%')
        .height('100%')

        Flex() {
          AirPlaneComponent()
        }
        .width('48%')
        .height('100%')
      }
      .width('100%')
      .height($r('app.float.wifi_and_air_height'))
      .margin({ top: $r('app.float.center_item_margin_top'),
        left: $r('app.float.center_item_margin_left'),
        right: $r('app.float.center_item_margin_right') })

      Column() {
        MyBrightness()
      }
      .width('100%')
      .height($r('app.float.vol_height'))
      .margin({ top: $r('app.float.center_item_margin_top'),
        left: $r('app.float.center_item_margin_left'),
        right: $r('app.float.center_item_margin_right') })

      Flex() {
        MyVol()
      }
      .width('100%')
      .height($r('app.float.vol_height'))
      .margin({ top: $r('app.float.center_item_margin_top'),
        left: $r('app.float.center_item_margin_left'),
        right: $r('app.float.center_item_margin_right') })
    }
    .width('100%')
  }
}

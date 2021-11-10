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

import mWifiManger from '../WifiModel.ets';
import Log from '../../../../../../../common/src/main/ets/default/Log.ets';
import iconTitleBase from '../../../../../../../common/src/main/ets/template/iconTitleBase.ets'
const TAG= 'Control-wifiComponent'

@Component
export default
struct WifiComponent {

  private IconInfo: any[] = [
    $r('app.media.wifi_d'),
    $r('app.media.wifi'),
  ]

  @StorageLink('wifiName') wifiName: string = 'WLAN'
  @StorageLink('wifiOpenStatus') wifiOpenStatus: boolean = false

  mClickEvent() {
    if (this.wifiOpenStatus == false) {
      console.log(`WLAN status is closing：${this.wifiOpenStatus} ”no“， set WLAN status enableWifi`)
      mWifiManger.enableWifi();
    } else {
      console.log(`WLAN status is opening：${this.wifiOpenStatus} ”yes“，se WLAN status disableWifi`)
      mWifiManger.disableWifi();
    }
  }

  aboutToAppear() {
    Log.showInfo(TAG,'aboutToAppear')
    mWifiManger.initWifiModel()
  }

  aboutToDisappear () {
    Log.showInfo(TAG,'aboutToDisappear')
  }

  build() {
    Column() {
      iconTitleBase({
        iconOff: this.IconInfo[0],
        iconOn: this.IconInfo[1],
        mTitle: this.wifiName,
        changeSwitch: $wifiOpenStatus,
        mClickEvent: this.mClickEvent.bind(this)
      })
    }
  }
}
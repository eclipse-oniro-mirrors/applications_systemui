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

import wifi from '@ohos.wifi';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import iconTitleBase from '../../../../../../../common/src/main/ets/template/iconTitleBase';

const TAG = 'Control-airPlaneComponent';

@Component
export default
struct airplaneComponent {

  private IconInfo: any[] = [
    $r('app.media.airplane_d'),
    $r('app.media.airplane'),
  ];
  @State flyModelTitle: Resource = $r("app.string.airplane_mode");
  @StorageLink('flyModelStatus') flyModelStatus: boolean = false;
  private mWifiOriginalStatus: boolean = false;


/*  when flyModelStatus == true, so airplane is opening,
 *  use variable mWifiOriginalStatus to record WLAN current status
 *  use system interface to WLAN current status: WifiInfo.isWifiActive()
 *  when flyModelStatus == false ,so airplane is closed
 *      get variable mWifiOriginalStatus
 *           if variable mWifiOriginalStatus == true, set WLAN status enableWifi()，conversely disableWifi().
 */
  mClickEvent() {
    this.flyModelStatus =!this.flyModelStatus;
    Log.showDebug(TAG, `flyModelStatus：${this.flyModelStatus}`);
    if (this.flyModelStatus == true) {
      this.mWifiOriginalStatus = wifi.isWifiActive();
      Log.showInfo(TAG, `airplane status is opening, WLAN Original Status ：${this.mWifiOriginalStatus}`);
      wifi.disableWifi();
    }else{
      if(this.mWifiOriginalStatus == true) {
        wifi.enableWifi();
        Log.showInfo(TAG, `airplane status closed, WLAN Original Status：${this.mWifiOriginalStatus},get system interface, set WLAN status enableWifi`);
      } else {
        wifi.disableWifi();
        Log.showInfo(TAG, `airplane status closed, WLAN Original Status：${this.mWifiOriginalStatus},,get system interface, set WLAN status disableWifi`);
      };
    };
  }

  aboutToAppear(){
    Log.showInfo(TAG, 'aboutToAppear');
  }

  aboutToDisappear (){
    Log.showInfo(TAG, 'aboutToDisappear ');
  }

  build() {
    Column() {
      iconTitleBase({
        iconOff: this.IconInfo[0],
        iconOn: this.IconInfo[1],
        mTitle: $flyModelTitle,
        changeSwitch: $flyModelStatus,
        mClickEvent: () => this.mClickEvent()
      })
    }.width('100%')
    .height('100%')
  }
}
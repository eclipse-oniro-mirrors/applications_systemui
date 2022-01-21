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

import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import FeatureAbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/featureAbilityManager.ets'
import WindowManager from '../../../../../../../../common/src/main/ets/default/WindowManager.ets'
import ViewModel from '../viewmodel/BluetoothVM.ets'
import iconTitleBase from '../../../../../../../../common/src/main/ets/template/iconTitleBase.ets'

const TAG = 'bluetooth-ControlCenterComplexToggleBluetoothComponent'

@Component
export default struct ControlCenterComplexToggleBluetoothComponent {
  private IconInfo: any[] = [
    $r("app.media.ic_controlcenter_bt_d"),
    $r("app.media.ic_controlcenter_bt"),
  ]
  @State mTitle: Resource = $r("app.string.control_center_complex_toggle_bluetooth_title")
  @StorageLink('BluetoothOpenStatus') BluetoothOpenStatus: boolean = false
  @StorageLink("showStatusBar") showStatusBar: boolean = false
  private mWindowManager
  private mFeatureAbilityManager

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear')
    this.mWindowManager = new WindowManager()
    this.mFeatureAbilityManager = new FeatureAbilityManager()
    ViewModel.initViewModel()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  build() {
    Column() {
      iconTitleBase({
        iconOff: this.IconInfo[0],
        iconOn: this.IconInfo[1],
        mTitle: $mTitle,
        changeSwitch: $BluetoothOpenStatus,
        mClickEvent: this.mClickEvent.bind(this),
        mLongClickEvent: this.mLongClickEvent.bind(this)
      })
    }.width('100%')
    .height('100%')
  }

  mClickEvent() {
    Log.showInfo(TAG, `mClickEvent, BluetoothOpenStatus: ${this.BluetoothOpenStatus}`)
//    if (this.BluetoothOpenStatus) {
//      ViewModel.disableBluetooth()
//    } else {
//      ViewModel.enableBluetooth()
//    }
  }

  mLongClickEvent() {
    Log.showInfo(TAG, `mLongClickEvent, BluetoothOpenStatus: ${this.BluetoothOpenStatus}`)

//    this.showStatusBar = true
//    this.mWindowManager.setWindowMin((result) => {
//      this.mFeatureAbilityManager.openAbility(TAG, {
//        want: {
//          bundleName: 'com.ohos.settings',
//          abilityName: 'com.ohos.settings.MainAbility',
//        }
//      })
//    })
  }
}
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
import {AudioRingMode} from '../common/Constants.ets'
import ViewModel from '../viewmodel/RingModeVM.ets'
import SimpleToggleBase from '../../../../../../../../common/src/main/ets/template/SimpleToggleBase.ets'

const TAG = 'ringmode-ControlCenterSimpleToggleRingModeComponent'

@Component
export default struct ControlCenterSimpleToggleRingModeComponent {
  @Prop keyId: string
  @Prop mShowLabel: boolean
  @Prop mEditMode: boolean
  @State mIcon: Resource = $r("app.media.ic_controlcenter_ring_on_filled")
  @State mLabel: Resource = $r("app.string.control_center_complex_toggle_ring_mode_title_on")
  @State mDefaultChangeSwitch: boolean  = true
  @StorageLink('RingModeComponentMode') @Watch('onRingModeUpdated') RingModeComponentMode: AudioRingMode = AudioRingMode.RINGER_MODE_NORMAL
  @StorageLink("showStatusBar") showStatusBar: boolean = false
  private mWindowManager
  private mFeatureAbilityManager

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear')
    this.mWindowManager = new WindowManager()
    this.mFeatureAbilityManager = new FeatureAbilityManager()
    ViewModel.initViewModel()
    this.onRingModeUpdated('RingModeComponentMode')
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  onRingModeUpdated(propName: string): void {
    Log.showInfo(TAG, `onRingModeUpdated, propName: ${propName} RingModeComponentMode: ${JSON.stringify(this.RingModeComponentMode)}`)
    if (this.RingModeComponentMode == AudioRingMode.RINGER_MODE_SILENT) {
      this.mIcon = $r("app.media.ic_controlcenter_ring_off_filled")
      this.mLabel = $r("app.string.control_center_complex_toggle_ring_mode_title_off")
    } else if (this.RingModeComponentMode == AudioRingMode.RINGER_MODE_VIBRATE) {
      this.mIcon = $r("app.media.ic_controlcenter_vibration_filled")
      this.mLabel = $r("app.string.control_center_complex_toggle_ring_mode_title_vibration")
    } else if (this.RingModeComponentMode == AudioRingMode.RINGER_MODE_NORMAL) {
      this.mIcon = $r("app.media.ic_controlcenter_ring_on_filled")
      this.mLabel = $r("app.string.control_center_complex_toggle_ring_mode_title_on")
    }
  }

  build() {
    SimpleToggleBase({
      mToggleId: this.keyId,
      mIcon: $mIcon,
      mChangeSwitch: $mDefaultChangeSwitch,
      mLabel: $mLabel,
      mShowLabel: this.mShowLabel,
      mEditMode: this.mEditMode,
      mClickEvent: this.mClickEvent.bind(this),
      mLongClickEvent: this.mLongClickEvent.bind(this)
    })
  }

  mClickEvent() {
    Log.showInfo(TAG, `mClickEvent, RingModeComponentMode: ${JSON.stringify(this.RingModeComponentMode)}`)
    if (this.RingModeComponentMode == AudioRingMode.RINGER_MODE_SILENT) {
      ViewModel.setRingerMode(AudioRingMode.RINGER_MODE_NORMAL)
    } else if (this.RingModeComponentMode == AudioRingMode.RINGER_MODE_VIBRATE) {
      ViewModel.setRingerMode(AudioRingMode.RINGER_MODE_SILENT)
    } else if (this.RingModeComponentMode == AudioRingMode.RINGER_MODE_NORMAL) {
      ViewModel.setRingerMode(AudioRingMode.RINGER_MODE_VIBRATE)
    }
  }

  mLongClickEvent() {
    Log.showInfo(TAG, `mLongClickEvent, RingModeComponentMode: ${JSON.stringify(this.RingModeComponentMode)}`)

    this.showStatusBar = true
    this.mWindowManager.setWindowMin((result) => {
      this.mFeatureAbilityManager.openAbility(TAG, {
        want: {
          bundleName: 'com.ohos.settings',
          abilityName: 'com.ohos.settings.MainAbility',
        }
      })
    })
  }
}
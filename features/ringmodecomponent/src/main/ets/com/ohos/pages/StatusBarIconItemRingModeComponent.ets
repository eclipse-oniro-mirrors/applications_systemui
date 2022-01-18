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
import Constants, {AudioRingMode} from '../common/Constants.ets'
import ViewModel from '../viewmodel/RingModeVM.ets'

const TAG = 'ringmode-StatusBarIconItemRingModeComponent'

@Component
export default struct StatusBarIconItemRingModeComponent {
  @StorageLink('RingModeComponentMode') RingModeComponentMode: AudioRingMode = AudioRingMode.RINGER_MODE_NORMAL
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0
  private ringModeIcons: any

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear')
    this.ringModeIcons = {}
    this.ringModeIcons[AudioRingMode.RINGER_MODE_SILENT.toString()] = $r("app.media.ic_statusbar_ring_off_filled")
    this.ringModeIcons[AudioRingMode.RINGER_MODE_VIBRATE.toString()] = $r("app.media.ic_statusbar_vibration_on")
    ViewModel.initViewModel()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      if (this.RingModeComponentMode != AudioRingMode.RINGER_MODE_NORMAL) {
        Image(this.ringModeIcons[this.RingModeComponentMode.toString()])
          .objectFit(ImageFit.Contain)
          .width(Constants.STATIC_BAR_ICON_WIDTH * this.StatusCoefficient)
          .height(Constants.STATIC_BAR_ICON_HEIGHT * this.StatusCoefficient)
      }
    }
    .width(this.RingModeComponentMode != AudioRingMode.RINGER_MODE_NORMAL ? Constants.STATIC_BAR_ICON_WIDTH * this.StatusCoefficient : 0)
    .height(this.RingModeComponentMode != AudioRingMode.RINGER_MODE_NORMAL ? Constants.STATIC_BAR_ICON_HEIGHT * this.StatusCoefficient : 0)
  }
}
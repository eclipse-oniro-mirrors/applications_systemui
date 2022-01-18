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
import LocationComponent from '../../../../../../../locationcomponent/src/main/ets/com/ohos/pages/ControlCenterSimpleToggleLocationComponent.ets'
import RingModeComponent from '../../../../../../../ringmodecomponent/src/main/ets/com/ohos/pages/ControlCenterSimpleToggleRingModeComponent.ets'
import Constants from '../common/Constants.ets'
import SimpleToggleComponent from './SimpleToggleComponent.ets'

const TAG = 'SimpleToggleLoadComponent'

@Component
export default struct SimpleToggleLoadComponent {
  @Prop keyId: string
  @Prop mShowLabel: boolean
  @Prop mEditMode: boolean

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start, keyId: ${this.keyId}`)
    Log.showInfo(TAG, `aboutToAppear Start, mShowLabel: ${this.mShowLabel} mEditMode: ${this.mEditMode}`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  build() {
    Column() {
      if (this.keyId == Constants.LOCATION) {
        LocationComponent({
          keyId: this.keyId,
          mShowLabel: this.mShowLabel,
          mEditMode: this.mEditMode
        })
      } else if (this.keyId == Constants.RING_MODE) {
        RingModeComponent({
          keyId: this.keyId,
          mShowLabel: this.mShowLabel,
          mEditMode: this.mEditMode
        })
      } else {
        SimpleToggleComponent({
          keyId: this.keyId,
          mShowLabel: this.mShowLabel,
          mEditMode: this.mEditMode
        })
      }
    }
  }
}
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

import Constants from '../common/constants'
import Log from '../../../../../../../../common/src/main/ets/default/Log'
import CommonStyleManager from '../../../../../../../../common/src/main/ets/default/StyleManager'
import VolumePanelComponent from '../../../../../../../../features/volumepanelcomponent/src/main/ets/com/ohos/pages/VolumePanelComponent'
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import StyleManager from '../common/StyleManager'

const TAG = 'VolumePanel-Index'

@Entry
@Component
struct Index {
  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
    setAppBgColor('#00000000')
    CommonStyleManager.setAbilityPageName(TAG)
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis')
    Log.showInfo(TAG, `configInfo Start, configInfo ${JSON.stringify(configInfo)}`);
    if (configInfo.width > configInfo.height) { // Pad、PC Mode
      StyleManager.setStyle()
    }
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  build() {
    Column() {
      VolumePanelComponent()
    }
    .width('100%')
    .height('100%')
  }
}

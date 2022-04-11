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

import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager'

export default {
  onCreate() {
    console.info('SystemUI volumePanel Application onCreate')
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis')
    let volumeRect;
    if (configInfo.width > configInfo.height) { // Pad、PC Mode
      const realWidth = 48;
      const realHeight = 284;
      volumeRect = {
        left: configInfo.width - vp2px(16) - vp2px(realWidth),
        top: (configInfo.height - vp2px(realHeight) ) / 2,
        width: vp2px(realWidth) ,
        height: vp2px(realHeight)
      }
    } else { // Phone Mode
      const realWidth = 96;
      const realHeight = 568;
      volumeRect = {
        left: configInfo.width - vp2px(32) - vp2px(realWidth),
        top: configInfo.height * 0.1,
        width: vp2px(realWidth) ,
        height: vp2px(realHeight)
      }
    }
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'rect', volumeRect)
    WindowManager.resetSizeWindow(WindowType.VOLUME_PANEL, volumeRect);
  },
  onDestroy() {
    console.info('SystemUI volumePanel Application onDestroy')
  },
}

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
import Log from '../../../../../../../common/src/main/ets/default/Log'
import CommonStyleManager from '../../../../../../../common/src/main/ets/default/CommonStyleManager'
import VolumePanelComponent from '../../../../../../../features/volumepanelcomponent/src/main/ets/com/ohos/pages/VolumePanelComponent'
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import StyleManager from '../common/StyleManager'
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager'

const TAG = 'VolumePanel-Index'

@Entry
@Component
struct Index {
  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis');
    let volumeRect;
    if (configInfo.width > configInfo.height) { // Pad、PC Mode
      const realWidth = 48;
      const realHeight = 284;
      volumeRect = {
        left: configInfo.width - vp2px(16) - vp2px(realWidth),
        top: (configInfo.height - vp2px(realHeight) ) / 2,
        width: vp2px(realWidth) ,
        height: vp2px(realHeight)
      };
    } else { // Phone Mode
      const realWidth = 48;
      const realHeight = 284;
      volumeRect = {
        left: configInfo.width - vp2px(16) - vp2px(realWidth),
        top: configInfo.height * 0.1,
        width: vp2px(realWidth) ,
        height: vp2px(realHeight)
      };
    }
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'rect', volumeRect);
    WindowManager.resetSizeWindow(WindowType.VOLUME_PANEL, volumeRect);

    setAppBgColor('#00000000');
    CommonStyleManager.setAbilityPageName(TAG)
    Log.showDebug(TAG, `configInfo Start, configInfo ${JSON.stringify(configInfo)}`);
    if (configInfo.width > configInfo.height) { // Pad、PC Mode
      StyleManager.setStyle();
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

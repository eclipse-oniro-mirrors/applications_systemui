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
import BaseStyleManager from '../../../../../../../common/src/main/ets/default/BaseStyleManager';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import StyleConfiguration from '../../../../../../../features/volumepanelcomponent/src/main/ets/com/ohos/common/StyleConfiguration';

const TAG = 'VolumePanel-StyleManager';

export class StyleManager extends BaseStyleManager {
  static readonly ABILITY_PAGE_NAME_VOLUMEPANEL = "VolumePanel-Index";

  constructor() {
    super(StyleManager.ABILITY_PAGE_NAME_VOLUMEPANEL);
  }

  setStyle(): void {
    Log.showDebug(TAG, 'setStyle');

    this.setStandardWidth(BaseStyleManager.STANDARD_DISPLAY_WIDTH_LARGE);
    let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_VOLUME_PANEL, 'dis');
    this.setMaxWidth(config.width);

    // Pad、PC Mode
    {
      let style = StyleConfiguration.getVolumePanelComponentStyle();
      style.volumePanelSliderMarginTop = this.calcScaleSizePx(40);
      style.volumePanSliderWidth = px2vp(this.calcScaleSize(8)).toString() + 'vp';
      style.volumePanSliderHeight = this.calcScaleSizePx(320);
      style.volumePanelSliderMarginBottom = this.calcScaleSizePx(40);
      style.volumePanelMutBtnIconSize = this.calcScaleSizePx(48);
      style.volumePanelMutBtnIconMarginBottom = this.calcScaleSizePx(24);
      style.volumePanelMuteBtnHeight = this.calcScaleSizePx(72);
      style.volumePanelSettingIconSize = this.calcScaleSizePx(48);
      style.volumePanelSettingButtonSize = this.calcScaleSizePx(96);
      style.volumePanelBackground = '#99FFFFFF';
      style.volumePanelSliderBlockColor = '#FFFFFFFF';
      style.volumePanelDividerHeight = this.calcScaleSizePx(1);
      style.volumePanelBorderRadius = this.calcScaleSizePx(48);
      style.volumeDividerWidth = this.calcScaleSizePx(60);
      style.volumeSliderTrackColor = '#FFAEE6E6';
      style.volumeSelectedColor = '#FF007DFF';
      style.volumeButtonBackgroundColor = '#00000000';
      style.volumePanelRingModeColor = '#FF007DFF';
      style.volumePanelDividerColor = '#FF9BCECE';
      style.volumePanelSettingColor = '#FF4D6666';
    }
  }
}

let styleManager = new StyleManager();

export default styleManager;
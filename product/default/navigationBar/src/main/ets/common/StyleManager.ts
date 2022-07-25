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
import Log from '../../../../../../../common/src/main/ets/default/Log';
import BaseStyleManager from '../../../../../../../common/src/main/ets/default/BaseStyleManager';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import StyleConfiguration from './StyleConfiguration';

const TAG = 'StatusBar-StyleManager';

export class StyleManager extends BaseStyleManager {
  static readonly ABILITY_PAGE_NAME_NAVIGATION_BAR = "NavigationBar-Index";

  constructor() {
    super(StyleManager.ABILITY_PAGE_NAME_NAVIGATION_BAR);
  }

  setPadStyle(): void {
    Log.showDebug(TAG, 'setPadStyle');

    let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
    this.setMaxWidth(config.maxWidth);
    this.setStandardWidth(BaseStyleManager.STANDARD_DISPLAY_WIDTH_NORMAL);

    // keyButton
    {
      let style = StyleConfiguration.getKeyButtonStyle();
      style.buttonWidth = this.calcScaleSizePx(88);
      style.buttonHeight = this.calcScaleSizePx(44);
      style.buttonBorderRadius = this.calcScaleSizePx(22);
      style.buttonIconWidth = this.calcScaleSizePx(15);
      style.buttonIconHeight = this.calcScaleSizePx(15);
    }
  }

  setPhoneStyle(): void {
    Log.showDebug(TAG, 'setPhoneStyle');

    let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
    this.setMaxWidth(config.maxWidth);
    this.setStandardWidth(BaseStyleManager.STANDARD_DISPLAY_WIDTH_SMALL);

    // keyButton
    {
      let style = StyleConfiguration.getKeyButtonStyle();
      style.buttonWidth = this.calcScaleSizePx(144);
      style.buttonHeight = this.calcScaleSizePx(72);
      style.buttonBorderRadius = this.calcScaleSizePx(36);
      style.buttonIconWidth = this.calcScaleSizePx(24);
      style.buttonIconHeight = this.calcScaleSizePx(24);
    }
  }
}

let styleManager = new StyleManager();

export default styleManager;
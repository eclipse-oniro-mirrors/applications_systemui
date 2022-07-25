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
import BaseStyleManager from '../../../../../../../../common/src/main/ets/default/BaseStyleManager';
import Log from '../../../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/abilitymanager';

const TAG = 'StatusBar-StyleManager';

export class StyleManager extends BaseStyleManager {
  static readonly ABILITY_PAGE_NAME_STATUSBAR = "StatusBar-Index";

  constructor() {
    super(StyleManager.ABILITY_PAGE_NAME_STATUSBAR);
  }

  setStyle(): void {
    Log.showDebug(TAG, 'setStyle');

    this.setStandardWidth(BaseStyleManager.STANDARD_DISPLAY_WIDTH_SMALL);

    let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'config');
    this.setMaxWidth(config.maxWidth);

    // xxx
    {
    }
  }
}

let styleManager = new StyleManager();

export default styleManager;
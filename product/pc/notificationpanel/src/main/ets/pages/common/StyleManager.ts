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
import IndexStyleConfiguration from './styleconfiguration';

const TAG = 'NotificationPanel-StyleManager';

export class StyleManager extends BaseStyleManager {
  static readonly ABILITY_PAGE_NAME_NOTIFICATIONPANEL = "NotificationPanel-Index";

  constructor() {
    super(StyleManager.ABILITY_PAGE_NAME_NOTIFICATIONPANEL);
  }

  setStyle(): void {
    Log.showDebug(TAG, 'setStyle');

    this.setStandardWidth(BaseStyleManager.STANDARD_DISPLAY_WIDTH_NORMAL);
    let dis = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL, 'dis');
    this.setMaxWidth(dis.width);

    // Index
    {
      let style = IndexStyleConfiguration.getIndexStyle();
      style.borderRadius = this.calcScaleSizePx(24);
    }
  }
}

let styleManager = new StyleManager();

export default styleManager;
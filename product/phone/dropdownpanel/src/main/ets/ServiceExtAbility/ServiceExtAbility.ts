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

import ServiceExtension from '@ohos.app.ability.ServiceExtensionAbility';
import display from '@ohos.display';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import NavBarConfiguration from '../../../../../../../features/navigationservice/src/main/ets/com/ohos/navigationservice/common/NavBarConfiguration';
import { Want } from 'ability/want';


const TAG = 'DropdownPanel_ServiceExtAbility';

class ServiceExtAbility extends ServiceExtension {
  async onCreate(want: Want): Promise<void> {
    Log.showInfo(TAG, `onCreate, want: ${JSON.stringify(want)}`);
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL, this.context);
    let defaultConfigInfo = await NavBarConfiguration.getConfiguration();
    let configInfo = NavBarConfiguration.setCustomConfiguration(defaultConfigInfo);
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config', configInfo);
    Log.showDebug(TAG, `onCreate, configInfo: ${JSON.stringify(configInfo)}`);
    globalThis[AbilityManager.ABILITY_NAME_OWNER_WANT] = want;

    display.getDefaultDisplay().then((dis) => {
      let rect = {
        left: 0,
        top: 0,
        width: dis.width,
        height: dis.height,
      };
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL, 'rect', rect);
      WindowManager.createWindow(this.context, WindowType.DROPDOWN_PANEL, rect, 'pages/index').then( (win) => {
        win.setLayoutFullScreen(true);
        Log.showInfo(TAG, 'onCreate, createWindow callback');
      }).catch((err) => {
      });

      let bannerRect = {
        left: 0,
        top: dis.height / 5,
        width: dis.width,
        height: dis.height / 20
      };
      AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_BANNER_NOTICE, 'bannerRect', bannerRect);
      WindowManager.createWindow(this.context, WindowType.BANNER_NOTICE, bannerRect, 'pages/bannerNotification')
        .then((win) => {
          Log.showInfo(TAG, 'onCreate, createWindow callback');
        })
        .catch((err) => Log.showError(TAG, `Can't create window, err:${JSON.stringify(err)}`));
    }).then(() => {
    }).catch((err) => {
    });
  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;

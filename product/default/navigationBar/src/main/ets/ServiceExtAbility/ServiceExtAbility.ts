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

import display from '@ohos.display';
import ServiceExtension from '@ohos.application.ServiceExtensionAbility';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import NavBarConfiguration from '../../../../../../../features/navigationservice/src/main/ets/com/ohos/navigationservice/common/NavBarConfiguration';
import { Want } from 'ability/want';

const TAG = 'NavigationBar_ServiceExtAbility';

class ServiceExtAbility extends ServiceExtension {
  private direction :number;

  async onCreate(want: Want): Promise<void> {
    Log.showInfo(TAG, `onCreate, want: ${JSON.stringify(want)}`);
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, this.context);

    display.on("change", (id) => {
      Log.showInfo(TAG, "display change, data: " + JSON.stringify(id))
      display.getAllDisplay().then((arrayDisplay) => {
        Log.showInfo(TAG, "getAllDisplay : " + JSON.stringify(arrayDisplay))
        for (let display of arrayDisplay) {
          Log.showInfo(TAG, "getAllDisplay start : " + JSON.stringify(arrayDisplay));
          if (id == display.id) {
            let nowDirection = -1;
            if (display.width > display.height) {
              nowDirection = 1;
            } else {
              nowDirection = 2;
            }
            if (nowDirection != this.direction) {
              this.createNewWindow(false);
            }
          }
        }
      })
    })
    this.createNewWindow(true);


  }

  async createNewWindow (isNewWindow : boolean) {
    let defaultConfigInfo = await NavBarConfiguration.getConfiguration();
    let configInfo = NavBarConfiguration.setCustomConfiguration(defaultConfigInfo);
    this.direction = configInfo.direction;
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config', configInfo);
    Log.showDebug(TAG, `onCreate, configInfo: ${JSON.stringify(configInfo)}`);
    let navigationBarRect = {
      left: configInfo.xCoordinate,
      top: configInfo.yCoordinate,
      width: configInfo.realWidth,
      height: configInfo.realHeight
    };

    if (isNewWindow) {
      WindowManager.createWindow(this.context, WindowType.NAVIGATION_BAR, navigationBarRect, 'pages/index')
        .then(() => {
          Log.showInfo(TAG, 'onCreate, createWindow success.');
          WindowManager.showWindow(WindowType.NAVIGATION_BAR).then(() => {
          }).catch(e => {
          });
        })
        .catch((err) => Log.showError(TAG, `Can't create window, err:${err}`));
    } else {
      WindowManager.resetSizeWindow(WindowType.NAVIGATION_BAR, navigationBarRect);
    }
  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
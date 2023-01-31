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
import ServiceExtension from '@ohos.app.ability.ServiceExtensionAbility';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import StatusBarConfiguration from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/StatusBarConfiguration';
import StatusBarConstants from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/Constants';
import { Want } from 'ability/want';
import deviceInfo from '@ohos.deviceInfo';

const TAG = 'StatusBar_ServiceExtAbility';
const deviceTypeInfo = deviceInfo.deviceType;

class ServiceExtAbility extends ServiceExtension {
  private direction :number;

  async onCreate(want: Want): Promise<void> {
    Log.showInfo(TAG, `onCreate, want: ${JSON.stringify(want)}`);
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_STATUS_BAR, this.context);
    globalThis[StatusBarConstants.PLUGIN_COMPONENT_OWNER_WANT_KEY] = want;
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
    let configInfo = await StatusBarConfiguration.getConfiguration();
    this.direction = configInfo.direction;
    let screenFactor;
    if (deviceTypeInfo === 'phone') {
      screenFactor = this.direction === 1 ? 1188 : 540;
    } else {
      screenFactor = this.direction === 1 ? 640 : 360;
    }
    if (configInfo.showHorizontal) {
      if (configInfo.realHeight == 0) {
        Log.showInfo(TAG, `hide statusbar`);
      } else {
        configInfo.realHeight = (configInfo.realHeight * configInfo.maxWidth) / screenFactor;
      }
      configInfo.minHeight = configInfo.realHeight;
      if (configInfo.yCoordinate > 0) {
        configInfo.yCoordinate = configInfo.maxHeight - configInfo.realHeight;
      }
    } else {
      if (configInfo.realWidth == 0) {
        Log.showInfo(TAG, `hide statusbar`);
      } else {
        configInfo.realWidth = (configInfo.realWidth * configInfo.maxWidth) / screenFactor;
      }
      configInfo.minHeight = configInfo.realWidth;
      if (configInfo.xCoordinate > 0) {
        configInfo.xCoordinate = configInfo.maxWidth - configInfo.realWidth;
      }
    }

    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'config', configInfo);
    Log.showDebug(TAG, `onCreate, configInfo: ${JSON.stringify(configInfo)}`);

    let statusBarRect = {
      left: configInfo.xCoordinate,
      top: configInfo.yCoordinate,
      width: configInfo.realWidth,
      height: configInfo.realHeight
    };
    if (isNewWindow) {
      WindowManager.createWindow(this.context, WindowType.STATUS_BAR, statusBarRect, 'pages/index').then(async () =>
      WindowManager.showWindow(WindowType.STATUS_BAR)
      ).then(() => {
      }).catch((err) => {
      });
    } else {
      WindowManager.resetSizeWindow(WindowType.STATUS_BAR, statusBarRect);
    }
  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
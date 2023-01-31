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
import Want from '@ohos.application.Want';
import display from '@ohos.display';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';

const TAG = 'NotificationPanel_ServiceExtAbility';

class ServiceExtAbility extends ServiceExtension {
  private direction :number;
  async onCreate(want: Want): Promise<void> {
    Log.showInfo(TAG, `onCreate, want: ${JSON.stringify(want)}`);
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL, this.context);
    globalThis[AbilityManager.ABILITY_NAME_OWNER_WANT] = want;

    let dis = await display.getDefaultDisplay();
    Log.showDebug(TAG, `onCreate, dis: ${JSON.stringify(dis)}`);
    let rect;
    if (dis.width > dis.height) { // Pad、PC Mode
      this.direction = 1;
      rect = {
        left: (834 * dis.width) / 1280,
        top: (44 * dis.width) / 1280,
        width: (402 * dis.width) / 1280,
        height: (381 * dis.width) / 1280,
      };
    } else if (dis.width < dis.height) { // Phone Mode
      this.direction = 2;
      rect = {
        left: (390 * dis.width) / 1280,
        top: (44 * dis.width) / 1280,
        width: (402 * 2 * dis.width) / 1280,
        height: (381 * 2* dis.width) / 1280,
      };
    }

    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL, 'rect', rect);
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL, 'dis', {
      width: dis.width,
      height: dis.height,
    });

    WindowManager.createWindow(this.context, WindowType.NOTIFICATION_PANEL, rect, 'pages/index').then(() => {
      Log.showInfo(TAG, 'onCreate, createWindow callback');
    }).catch(err => {
      Log.showError(TAG, `Can't create window, err:${JSON.stringify(err)}`);
    });

    let bannerRect = {
      left: 872 * dis.width / 1280,
      top: 44 * dis.width / 1280,
      width: 402 * dis.width / 1280,
      height: 100 * dis.width / 1280
    };
    AbilityManager.setAbilityData(AbilityManager.ABILITY_NAME_BANNER_NOTICE, 'bannerRect', bannerRect);
    WindowManager.createWindow(this.context, WindowType.BANNER_NOTICE, bannerRect, 'pages/bannerNotification')
      .then((win) => {
        Log.showInfo(TAG, 'onCreate, createWindow callback');
      })
      .catch((err) => Log.showError(TAG, `Can't create window, err:${JSON.stringify(err)}`));
  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;

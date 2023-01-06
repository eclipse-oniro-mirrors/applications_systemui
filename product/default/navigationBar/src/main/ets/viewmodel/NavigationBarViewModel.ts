//@ts-nocheck
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
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import getSingleInstance from '../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import TintStateManager, { TintState, TintStateListener
} from '../../../../../../../common/src/main/ets/default/TintStateManager';
import { NavigationBarComponentData, NAVIGATIONBAR_HIDE_EVENT } from '../common/constants';
import dataShare from '@ohos.data.dataShare';
import settings from '@ohos.settings';
import commonEvent from '@ohos.commonEvent';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import Constants from '../../../../../../../common/src/main/ets/default/Constants';

const TAG = 'NavigationBarViewModel';

const NAVIGATION_BAE_VIEW_MODEL_KEY = 'AppStorage_NavigationBarViewModel';

const NAVIGATION_BAR_COMPONENT_DATA_KEY = 'AppStorage_NavigationBarComponentData';

export default class NavigationBarViewModel {
  private readonly settingDataKey = 'settings.display.navigationbar_status';
  private readonly urivar: string;
  private readonly helper: dataShare.DataShareHelper;
  private readonly navigationBarStatusDefaultValue = '1';
  private isDisplay = true;
  mNavigationBarComponentData: NavigationBarComponentData  = {
    ...new NavigationBarComponentData()
  };
  mUseCount = 0;

  static getInstance(): NavigationBarViewModel {
    return getSingleInstance(NavigationBarViewModel, NAVIGATION_BAE_VIEW_MODEL_KEY);
  }

  constructor() {
    Log.showInfo(TAG, 'constructor');
    this.mNavigationBarComponentData =
    AppStorage.SetAndLink(NAVIGATION_BAR_COMPONENT_DATA_KEY, this.mNavigationBarComponentData).get()
    if (AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR) == null) {
      Log.showError(TAG, 'AbilityManager.getContext() is null');
    } else {
      Log.showInfo(TAG, 'context: ' + AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR));
    }
    this.initNavigationBarStatus();
    this.initHelper(this.dataChangesCallback.bind(this));
  }

  private async initHelper(callback: () => void): Promise<void> {
    this.urivar = Constants.getUriSync(Constants.KEY_NAVIGATIONBAR_STATUS);
    this.helper = await dataShare.createDataShareHelper(AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR), this.urivar);
    Log.showInfo(TAG, 'initHelper, helper: ' + this.helper + ', uri: ' + this.urivar);
    this.helper.on('dataChange', this.urivar, () => {
      Log.showInfo(TAG, 'onDataChange.');
      callback();
    });
  }

  install(): void {
    Log.showDebug(TAG, `install, useCount: ${this.mUseCount}`);
    if (!this.mUseCount) {
      TintStateManager.getInstance().registerListener('navigation', this as TintStateListener);
    }
    this.mUseCount++;
  }

  uninstall(): void {
    Log.showDebug(TAG, `uninstall, useCount: ${this.mUseCount}`);
    this.mUseCount--;
    if (this.mUseCount) {
      TintStateManager.getInstance().unregisterListener('navigation');
    }
  }

  getNavigationBarComponentData(): NavigationBarComponentData {
    Log.showDebug(TAG, 'getNavigationBarComponentData');
    return this.mNavigationBarComponentData;
  }

  onTintStateChange(tintState: TintState): void {
    Log.showDebug(TAG, `onTintStateChange, tintState: ${JSON.stringify(tintState)}`);
    if (typeof (tintState.isEnable) == 'boolean') {
      this.setWindowEnable(tintState.isEnable);
    }
    if (tintState.backgroundColor) {
      this.mNavigationBarComponentData.backgroundColor = tintState.backgroundColor;
    }
    if (tintState.contentColor) {
      this.mNavigationBarComponentData.contentColor = tintState.contentColor;
    }
    Log.showDebug(TAG, `onTintStateChange, backgroundColor ${this.mNavigationBarComponentData.backgroundColor},
      contentColor ${this.mNavigationBarComponentData.contentColor}`);
  }

  setWindowEnable(isEnable: boolean): void {
    Log.showDebug(TAG, `setWindowEnable, isEnable ${String(isEnable)}`);
    if (this.mNavigationBarComponentData.isEnable == isEnable) {
      return;
    }
    this.mNavigationBarComponentData.isEnable = isEnable;
    if (isEnable && this.isDisplay) {
      WindowManager.showWindow(WindowType.NAVIGATION_BAR).then(() => {
      }).catch((err) => {
      });
    } else {
      WindowManager.hideWindow(WindowType.NAVIGATION_BAR).then(() => {
      }).catch((err) => {
      });
    }
  }

  private setValue(value: string): void {
    let context = AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR);
    settings.setValueSync(context, this.settingDataKey, value);
  }

  private getValue(defaultValue?: string): string {
    let context = AbilityManager.getContext(AbilityManager.ABILITY_NAME_NAVIGATION_BAR);
    return settings.getValueSync(
      context, this.settingDataKey, defaultValue ? defaultValue : this.navigationBarStatusDefaultValue
    );
  }

  /**
   * Initialize the NavigationBar status.
   */
  initNavigationBarStatus(): void {
    try {
      let initValue = this.getValue();
      Log.showInfo(TAG, `initNavigationBarStatus initValue ${initValue}`);
      this.windowSwitches(initValue);
    } catch (e) {
      Log.showError(TAG, `initNavigationBarStatus error:  ${e.toString()}`);
    }
  }

  /**
   * Get NavigationBar status data.
   * @return
   */
  dataChangesCallback(): void {
    let getRetValue = this.getValue();
    Log.showInfo(TAG, `dataChangesCallback initValue ${getRetValue}`);
    this.windowSwitches(getRetValue);
  }

  private windowSwitches(navigationBarStatusValue: string): void {
    this.isDisplay = navigationBarStatusValue == '1' ? true : false;
    if (!this.isDisplay || !this.mNavigationBarComponentData.isEnable) {
      //For gesture navigation scenarios
      //Systemui hides the navigation bar,and then notifies the launcher that it can start moving down the dock bar.
      WindowManager.hideWindow(WindowType.NAVIGATION_BAR).then(() => {
        if(!this.isDisplay){
          commonEvent.publish(NAVIGATIONBAR_HIDE_EVENT, (err) => {
            if (err.code) {
              Log.showError(TAG, `${NAVIGATIONBAR_HIDE_EVENT} PublishCallBack err: ${JSON.stringify(err)}`);
            } else {
              Log.showInfo(TAG, `${NAVIGATIONBAR_HIDE_EVENT} Publish sucess`);
            }
          })
        }
      }).catch((err) => {
        Log.showError(TAG, `${NAVIGATIONBAR_HIDE_EVENT} Publish catch err: ${JSON.stringify(err)}`);
      });
    } else {
      WindowManager.showWindow(WindowType.NAVIGATION_BAR).then(() => {
      }).catch((err) => {
      });
    }
  }
}
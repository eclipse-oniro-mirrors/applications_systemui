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

import Log from '../../../../../../../common/src/main/ets/default/log';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/windowmanager';
import getSingleInstance from '../../../../../../../common/src/main/ets/default/singleinstancehelper';
import TintStateManager, {TintState, TintStateListener
} from '../../../../../../../common/src/main/ets/default/tintstatemanager';
import {NavigationBarComponentData} from '../common/constants';
import featureAbility from '@ohos.ability.featureAbility';
import settings from '@ohos.settings';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilitymanager';
import CommonConstants from "../../../../../../../common/src/main/ets/default/constants";

const TAG = 'NavigationBarViewModel';

const NAVIGATION_BAE_VIEW_MODEL_KEY = 'AppStorage_NavigationBarViewModel';

const NavigationBarComponentDataKey = 'AppStorage_NavigationBarComponentData';

export default class NavigationBarViewModel {
  private settingDataKey = 'settings.display.navigationbar_status';
  private urivar: string = null;
  private helper: any = null;
  private navigationBarStatusDefaultValue: string = '1';
  private isDisplay = true;
  mNavigationBarComponentData?: NavigationBarComponentData  = {
    ...new NavigationBarComponentData()
  };
  mUseCount?: number = 0;

  static getInstance(): NavigationBarViewModel {
    return getSingleInstance(NavigationBarViewModel, NAVIGATION_BAE_VIEW_MODEL_KEY);
  }

  constructor() {
    Log.showInfo(TAG, 'constructor');
    this.mNavigationBarComponentData =
    AppStorage.SetAndLink(NavigationBarComponentDataKey, this.mNavigationBarComponentData).get()
    this.urivar = settings.getUriSync(this.settingDataKey);
    if (AbilityManager.getContext() == null) {
      Log.showError(TAG, `AbilityManager.getContext() is null`);
    } else {
      Log.showInfo(TAG, 'context: ' + AbilityManager.getContext() +
        'stageMode: ' + AbilityManager.getContext().stageMode);
    }
    this.helper = featureAbility.acquireDataAbilityHelper(AbilityManager.getContext(), CommonConstants.URI_VAR);
    this.initNavigationBarStatus();
  }

  install?() {
    Log.showDebug(TAG, `install, useCount: ${this.mUseCount}`);
    if (!this.mUseCount) {
      TintStateManager.getInstance().registerListener('navigation', this as TintStateListener);
    }
    this.mUseCount++;
  }

  uninstall?() {
    Log.showDebug(TAG, `uninstall, useCount: ${this.mUseCount}`);
    this.mUseCount--;
    if (this.mUseCount) {
      TintStateManager.getInstance().unregisterListener('navigation');
    }
  }

  getNavigationBarComponentData?(): NavigationBarComponentData {
    Log.showDebug(TAG, `getNavigationBarComponentData`)
    return this.mNavigationBarComponentData;
  }

  onTintStateChange?(tintState: TintState) {
    Log.showDebug(TAG, `onTintStateChange, tintState: ${JSON.stringify(tintState)}`)
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

  setWindowEnable?(isEnable: boolean) {
    Log.showDebug(TAG, `setWindowEnable, isEnable ${isEnable}`);
    if (this.mNavigationBarComponentData.isEnable == isEnable) {
      return;
    }
    this.mNavigationBarComponentData.isEnable = isEnable;
    if (isEnable && this.isDisplay) {
      WindowManager.showWindow(WindowType.NAVIGATION_BAR);
    } else {
      WindowManager.hideWindow(WindowType.NAVIGATION_BAR);
    }
  }

  private setValue(value: string) {
    settings.setValueSync(this.helper, this.settingDataKey, value);
  }

  private getValue(defaultValue?: string) {
    return settings.getValueSync(
      this.helper, this.settingDataKey, defaultValue ? defaultValue : this.navigationBarStatusDefaultValue
    );
  }

  private registerListenForDataChanges(callback) {
    this.helper.on("dataChange", this.urivar, (data) => {
      callback(data);
    })
  }

  /**
   * Initialize the NavigationBar status.
   */
  public initNavigationBarStatus() {
    try {
      let initValue = this.getValue();
      Log.showInfo(TAG, `initNavigationBarStatus initValue ${initValue}`);
      this.windowSwitches(initValue);
      this.registerListenForDataChanges(this.dataChangesCallback.bind(this));
    } catch (e) {
      Log.showError(TAG, `initNavigationBarStatus error:  ${e.toString()}`);
    }
  }

  /**
   * Get NavigationBar status data.
   * @return
   */
  public dataChangesCallback(data: any) {
    if (data.code !== 0) {
      Log.showError(TAG, `dataChangesCallback failed, because ${data.message}`);
      return;
    } else {
      let getRetValue = this.getValue();
      Log.showInfo(TAG, `dataChangesCallback initValue ${getRetValue}`);
      this.windowSwitches(getRetValue);
    }
  }

  private windowSwitches(navigationBarStatusValue) {
    this.isDisplay = navigationBarStatusValue == '1' ? true : false;
    if (!this.isDisplay) {
      WindowManager.hideWindow(WindowType.NAVIGATION_BAR);
    } else {
      WindowManager.showWindow(WindowType.NAVIGATION_BAR);
    }
  }
}
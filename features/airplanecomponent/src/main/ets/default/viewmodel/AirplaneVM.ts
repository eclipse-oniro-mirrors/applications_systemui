//@ts-nocheck
/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import settings from '@ohos.settings';
import Context from 'application/ServiceExtensionContext';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import createOrGet from '../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import { TintContentInfo, getOrCreateTintContentInfo
} from '../../../../../../../common/src/main/ets/default/TintStateManager';
import { FASlotName } from '../../../../../../../common/src/main/ets/default/Constants';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import Constants from '../../../../../../../common/src/main/ets/default/Constants';
import AirplaneService from '../model/AirplaneService';
import type { AirplaneServiceListener } from '../common/Constants';
import { AIRPLANE_MODE_STATUS } from '../common/Constants';

const TAG = 'AirplaneVM';

class AirplaneVM implements AirplaneServiceListener {
  mIsStart: boolean = false;
  mAirplaneStatus: boolean = false;
  mTintContentInfo: TintContentInfo = getOrCreateTintContentInfo(FASlotName.AIR_PLANE);
  mIsToggling: boolean = false;
  context: Context;

  constructor() {
    this.context = AbilityManager.getContext(AbilityManager.getContextName(AbilityManager.ABILITY_NAME_CONTROL_PANEL));
    if (this.context == undefined | this.context == null) {
      return null;
    }
    try {
      this.mAirplaneStatus =
        settings.getValueSync(this.context, Constants.KEY_AIRPLANE_MODE_STATUS, AIRPLANE_MODE_STATUS.OFF) === AIRPLANE_MODE_STATUS.ON
    } catch (err) {
      log.showError(TAG, `AirplaneVM: ${context}, ${JSON.stringify(err)}`);
    }
    AppStorage.SetOrCreate('Airplane_Status', this.mAirplaneStatus);
  }

  startVM() {
    if (this.mIsStart) return;
    this.mIsStart = true;

    AirplaneService.registerListener(this);
    AirplaneService.startService();

    Log.showInfo(TAG, 'startVM')
  }

  stopVM() {
    if (!this.mIsStart) return;
    this.mIsStart = false;

    AirplaneService.stopService();
  }

  updateState(status: boolean) {
    Log.showInfo(TAG, `updateState ${status}`)
    this.mAirplaneStatus = status;
    AppStorage.Set('Airplane_Status', this.mAirplaneStatus);
  }

  getAirplaneStatus() {
    return this.mAirplaneStatus;
  }

  getTintContentInfo(): TintContentInfo {
    return this.mTintContentInfo;
  }

  async handleClick() {
    Log.showInfo(TAG, `handleClick ${this.mIsToggling}`)

    if (this.mIsToggling) return
    this.mIsToggling = true

    await AirplaneService[this.mAirplaneStatus ? "disableAirplaneMode" : "enableAirplaneMode"]();
    Log.showInfo(TAG, 'await over')
    this.mIsToggling = false
  }
}

const sAirplaneVM = createOrGet(AirplaneVM, TAG);

export default sAirplaneVM;

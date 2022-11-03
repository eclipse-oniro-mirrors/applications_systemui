/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import BatteryInfo from "@ohos.batteryInfo";
import commonEvent from "@ohos.commonEvent";
import createOrGet from "../../../../../../common/src/main/ets/default/SingleInstanceHelper";
import Constants from "./common/constants";
import Log from "../../../../../../common/src/main/ets/default/Log";
import {CommonEventData} from "commonEvent/commonEventData";
import {CommonEventManager, getCommonEventManager, POLICY} from "../../../../../../common/src/main/ets/default/commonEvent/CommonEventManager";

const TAG = "BatteryComponent-batteryModel";
const DEFAULT_PROGRESS = 100;
const SUBSCRIBE_INFO = {
  events: [commonEvent.Support.COMMON_EVENT_BATTERY_CHANGED],
};

function getChargingStatus(state: BatteryInfo.BatteryChargeState): boolean {
  Log.showDebug(TAG, `charging status update: ${state}`);
  let batteryStatus = false;
  switch (state) {
    case BatteryInfo.BatteryChargeState.DISABLE:
    case BatteryInfo.BatteryChargeState.ENABLE:
    case BatteryInfo.BatteryChargeState.FULL:
      batteryStatus = true;
      break;
    default:
      batteryStatus = false;
      break;
  }
  return batteryStatus;
}

export class BatteryModel {
  private mBatterySoc: any;
  private mBatteryCharging: any;
  private mManager?: CommonEventManager;

  initBatteryModel() {
    if (this.mManager) {
      return;
    }
    this.mManager = getCommonEventManager(
      TAG,
      SUBSCRIBE_INFO,
      () => this.updateBatteryStatus(),
      (isSubscribe: boolean) => isSubscribe && this.updateBatteryStatus()
    );
    Log.showDebug(TAG, "initBatteryModel");
    this.mBatterySoc = AppStorage.SetAndLink("batterySoc", 0);
    this.mBatteryCharging = AppStorage.SetAndLink("batteryCharging", false);
    this.mManager.subscriberCommonEvent();
    this.mManager.applyPolicy([POLICY.SCREEN_POLICY]);
  }

  unInitBatteryModel() {
    Log.showDebug(TAG, "unInitBatteryModel");
    this.mManager?.release();
    this.mManager = undefined;
  }

  /**
   * Get battery status and remaining power
   */
  private updateBatteryStatus() {
    Log.showInfo(TAG, "updateBatteryStatus");
    let batterySoc = BatteryInfo.batterySOC ?? DEFAULT_PROGRESS;
    let batteryCharging = BatteryInfo.chargingStatus;
    if (batterySoc <= 0) {
      // If the result is a negative number, set it as positive number.
      batterySoc = Math.abs(batterySoc) * Constants.PERCENT_NUMBER;
    }

    Log.showInfo(TAG, "batterySoc = " + batterySoc);

    // Set the battery status as charging when there is no battery hardware
    this.mBatterySoc.set(batterySoc);
    this.mBatteryCharging.set(getChargingStatus(batteryCharging));
  }
}

let mBatteryModel = createOrGet(BatteryModel, TAG);
export default mBatteryModel as BatteryModel;

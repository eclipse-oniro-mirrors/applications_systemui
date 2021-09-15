/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import Log from "../../../../../../common/src/main/ets/default/Log.ets";
import Constants from './common/constants.ets';
import BatteryInfo from '@ohos.batteryInfo';
import BatterySubscriber from '@ohos.commonevent';

const TAG = 'batteryStatus';

let mProgress = Constants.DEFAULT_PROGRESS;
let mBatteryEventSubscriber = null;
let mBatteryEventSubscribeInfo = {
  events: ['usual.event.BATTERY_CHANGED']
}
var mAppStorage = AppStorage.GetOrCreate();
var mBatterySoc;
var mBatteryCharging;

export class BatteryModel {
  initBatteryModel() {
    Log.showInfo(TAG, 'initBatteryModel');
    mBatterySoc = mAppStorage.setAndLink("batterySoc", 0);
    mBatteryCharging = mAppStorage.setAndLink("batteryCharging", false);
    if (mBatteryEventSubscriber == null) {
      this.registerBatteryListener();
    }
    this.getBatteryStatus();
  }

  uninitBatteryModel() {
    this.unregisterBatteryListener();
  }

  /**
     * Subscribe Battery events
     */
  private registerBatteryListener() {
    Log.showInfo(TAG, 'registerBatteryListener start');
    BatterySubscriber.createSubscriber(
      mBatteryEventSubscribeInfo,
      this.createBatterySubscriberCallBack.bind(this)
    );
  }

  /**
   * Unsubscribe wifi events
   *
   */
  private unregisterBatteryListener() {
    BatterySubscriber.unsubscribe(mBatteryEventSubscriber, () => {
      Log.showInfo(TAG, `unregister Battery Status Listener ===============`);
    });
  }

  /**
     * Callback of the subscriber
     *
     * @param {Object} err - error returns from the caller
     * @param {Object} data - data returns from the caller
     */

  private createBatterySubscriberCallBack(err, data) {
    Log.showInfo(TAG, `Subscriberregister createBatterySubscriberCallBack ${JSON.stringify(err)} ${JSON.stringify(data)}`);
    mBatteryEventSubscriber = data;
    BatterySubscriber.subscribe(mBatteryEventSubscriber, this.batterySubscriberCallBack.bind(this));
  }


  /**
     * Callback of the events
     *
     * @param {Object} err - error returns from the caller
     * @param {Object} data - data returns from the caller
     */

  private batterySubscriberCallBack(err, data) {
    Log.showInfo(TAG, `Subscriberregister data == ${JSON.stringify(data)}`);
    if (err.code == 0) {
      if (data.event == 'usual.event.BATTERY_CHANGED') {
        this.getBatteryStatus();
      }
    } else {
      Log.showInfo(TAG, 'Subscriberregister error when subscribing ========');
    }
  }


  /**
     * Get battery status and remaining power
     */
  private getBatteryStatus() {
    let batterySoc = BatteryInfo.batterySOC;
    let batteryCharging = BatteryInfo.chargingStatus;
    if (null == batterySoc) {
      // Set the battery Soc as full when there is no battery hardware
      batterySoc = mProgress;
    }
    if (batterySoc <= 0) {
      // If the result is a negative number, set it as positive number.
      batterySoc = Math.abs(batterySoc) * Constants.PERCENT_NUMBER;
    }
    // Set the battery status as charging when there is no battery hardware
    this.checkBatteryStatus(batteryCharging, (result) => {
      let batteryStatus = result;
      mBatterySoc.set(batterySoc);
      mBatteryCharging.set(batteryStatus);
    });
  }

  /**
     * Check the battery charging status
     *
     * @param {number} charging - the battery charging status
     * @param {object} callback - Function callback
     */
  private checkBatteryStatus(charging, callback) {
    Log.showInfo(TAG, `Battery updateBattery checkBatteryStatus: ${charging}`);
    let batteryStatus;
    switch (charging) {
      case Constants.NONE:
        batteryStatus = false;
        break;
      case Constants.DISABLE:
      case Constants.ENABLE:
      case Constants.FULL:
        batteryStatus = true;
        break;
      default:
        batteryStatus = false;
        break;
    }
    callback(batteryStatus);
  }
}

let mBatteryModel = new BatteryModel();
export default mBatteryModel as BatteryModel
;

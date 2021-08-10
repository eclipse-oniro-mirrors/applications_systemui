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

/**
 * Get the status of battery
 */

import BatteryInfo from '@ohos.batteryInfo';
import mLog from '../../common/utils/Log.js';

const TAG = 'batteryStatus';
const NONE = 0;
const ENABLE = 1;
const DISABLE = 2;
const FULL = 3;
const PERCENT_NUMBER = 100;
const BATTERY_CHARGING_COLOR = '#00ff21';
const BATTERY_HIGH_COLOR = '#ffffff';
const BATTERY_MEDIUM_COLOR = '#ffd800';
const BATTERY_LOW_COLOR = '#ff0000';
const BATTERY_LEVEL_HIGH = 50;
const BATTERY_LEVEL_LOW = 10;
const MAX_BATTERY_LENGTH = 51;

var mProgressWidth = 51;
var mProgress = 100;
var mBackgroundColor = '#00ff21';

export default class batteryStatus {
    constructor() {
    }

    /**
     * Return the progress width and background color for the battery
     *
     * @param {Object} callback - Callback function
     */
    getStatusImage(callback) {
        let batteryValue = {};
        this.setOnBatteryListener();
        batteryValue.mBackgroundColor = mBackgroundColor;
        batteryValue.mProgressWidth = mProgressWidth;
        mLog.showInfo(TAG, `color: ${batteryValue.mBackgroundColor} width: ${batteryValue.mProgressWidth}`);
        callback(JSON.stringify(batteryValue));
    }

    /**
    * Method of getting the battery status by looping
    */
    setOnBatteryListener() {
        let batterySOC;
        let batteryCharging;

        batterySOC = BatteryInfo.batterySOC;
        batteryCharging = BatteryInfo.chargingStatus;
        if (null == batterySOC) {
            // Set the battery SOC as full when there is no battery hardware
            batterySOC = mProgress;
        }
        if (batterySOC <= 0) {
            // If the result is a negative number, set it as positive number.
            batterySOC = Math.abs(batterySOC) * PERCENT_NUMBER;
        }
        // Set the battery status as charging when there is no battery hardware
        let batteryStatus = this.checkBatteryStatus(batteryCharging);
        this.updateBattery(batterySOC, batteryStatus);
    }

    /**
     * Update the battery progress width and background color
     *
     * param {number} val - battery SOC number
     * param {boolean} charging - battery charging status
     */
    updateBattery(val, charging) {
        mLog.showInfo(TAG, `Battery updateBattery: ${val} charging: ${charging}`);
        mProgress = val;
        if (charging) {
            mBackgroundColor = BATTERY_CHARGING_COLOR;
        } else if (val <= BATTERY_LEVEL_LOW) {
            mBackgroundColor = BATTERY_LOW_COLOR;
        } else if (val > BATTERY_LEVEL_LOW && val <= BATTERY_LEVEL_HIGH) {
            mBackgroundColor = BATTERY_MEDIUM_COLOR;
        } else if (val > BATTERY_LEVEL_HIGH) {
            mBackgroundColor = BATTERY_HIGH_COLOR;
        }
        mProgressWidth = MAX_BATTERY_LENGTH * mProgress / PERCENT_NUMBER;
        mLog.showInfo(TAG, `Battery updateBattery mBackgroundColor: ${mBackgroundColor}`);
    }

    /**
     * Check the battery charging status
     *
     * @param {number} charging - the battery charging status
     * @return {boolean} whether the battery is charging or not
     */
    checkBatteryStatus(charging) {
        mLog.showInfo(TAG, `Battery updateBattery checkBatteryStatus: ${charging}`);
        let batteryStatus
        switch (charging) {
            case DISABLE:
                batteryStatus = false;
                break;
            case NONE:
            case ENABLE:
            case FULL:
            default:
                batteryStatus = true;
                break;
        }
        return batteryStatus;
    }
}

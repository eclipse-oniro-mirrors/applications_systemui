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

import batteryInfo from '@ohos.batteryInfo';
import statusImage from '../statuscenter/manager/StatusImage.js';

const NONE = 0;
const ENABLE = 1;
const DISABLE = 2;
const FULL = 3;
const loopTime = 1000;
const percentNum = 100;

var mBackgroundColor = '#00ff21';
var mBatteryChargingColor = '#00ff21';
var mBatteryHighColor = '#ffffff';
var mBatteryMediumColor = '#ffd800';
var mBatteryLowColor = '#ff0000';
var mHighBatteryLevel = 50;
var mLowBatteryLevel = 10;
var mProgressWidth = 51;
var mProgress = 100;

export default class batteryStatus extends statusImage {
    constructor() {
        super();
    }

    getStatusImage() {
        let BatteryValue = {};
        BatteryValue.mBackgroundColor = mBackgroundColor;
        BatteryValue.mProgressWidth = mProgressWidth;
        console.info('color = ' + BatteryValue.mBackgroundColor + ' width = ' + BatteryValue.mProgressWidth);
        return JSON.stringify(BatteryValue);
    }

    startGettingStatus() {
        this.setOnBatteryListener();
    }

    // Method of getting the battery status
    setOnBatteryListener() {
        let that = this;
        let batterySOC;
        let batteryCharging;
        setInterval(function () {
            batterySOC = batteryInfo.batterySOC;
            console.info('batterySOC = ' + batterySOC);
            batteryCharging = batteryInfo.chargingStatus;
            console.info('batteryCharging = ' + batteryCharging);
            if (null == batterySOC) {
                // Set the battery SOC as full when there is no battery hardware
                batterySOC = 1;
            }
            if (batterySOC <= 0) {
                // If the result is a negative number, set it as positive number.
                batterySOC = Math.abs(batterySOC);
            }
            // Set the battery status as charging when there is no battery hardware
            let batteryStatus = that.checkBatteryStatus(batteryCharging);
            that.updateBattery(batterySOC * percentNum, batteryStatus);
        }, loopTime);
    }

    updateBattery(val, charging) {
        console.info('Battery updateBattery:' + val + ' charging:' + charging);
        mProgress = val;
        if (charging) {
            mBackgroundColor = mBatteryChargingColor;
        } else if (val <= mLowBatteryLevel) {
            mBackgroundColor = mBatteryLowColor;
        } else if (val > mLowBatteryLevel && val <= mHighBatteryLevel) {
            mBackgroundColor = mBatteryMediumColor;
        } else if (val > mHighBatteryLevel) {
            mBackgroundColor = mBatteryHighColor;
        }
        mProgressWidth = mProgressWidth * mProgress / percentNum;
        console.info('Battery updateBattery  mBackgroundColor:' + mBackgroundColor);
    }

    checkBatteryStatus(charging) {
        console.info('Battery updateBattery checkBatteryStatus:' + charging);
        let batteryStatus;
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

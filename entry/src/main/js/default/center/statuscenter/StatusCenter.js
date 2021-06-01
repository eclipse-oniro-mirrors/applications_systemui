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

import StatusManager from '../statuscenter/manager/IconManager.js';
import BatteryStatus from '../../center/battery/batteryStatus.js';

var mStatusManager = new StatusManager;
var mBatteryStatus = new BatteryStatus;

var time;
var mStatusList = [];
var mResultStatusList = [];

const LOOP_TIME = 1000;

export default class StatusCenter {
    constructor() {
    }

    // Method of getting the battery status
    setOnBatteryListener() {
        let batteryStatus = mBatteryStatus.getStatusImage();
        console.info('battery status = ' + batteryStatus);
        return batteryStatus;
    }

    // Method of setting the time to current
    setOnTimeListener(callback) {
        time = setInterval(function () {
            let date = new Date();
            // Get the hours and minutes by substring.
            callback(date.toTimeString().substring(0,5));
        }, LOOP_TIME);
    }

    stopUpdateTime() {
        clearInterval(time);
    }

    // Status Icon
    setOnStatusListener(callback) {
        mStatusManager.setStatusList(mStatusList);
        mResultStatusList = mStatusManager.getStatusList();
        callback(mResultStatusList);
    }
}
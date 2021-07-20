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
 * Handle all data needed by status bar and prepare the content for pages to show
 */

import BatteryStatus from '../../center/battery/batteryStatus.js';
import SignalStatus from '../../center/signal/signalStatus.js';
import DateManager from '../../center/statuscenter/manager/DateManager.js'
import mLog from '../../common/utils/Log.js';

const TAG = 'StatusCenter';
const LOOP_TIME = 1000;
var mSignalStatus = new SignalStatus();
var mBatteryStatus = new BatteryStatus();
var mDateManager = new DateManager();
var time;

export default class StatusCenter {
    constructor() {
    }

    /**
     * Get the images of cellular and wifi need to be showed on status bar
     *
     * @return {string} the image of wifi and cellular
     */
    setOnSignalListener() {
        let signalStatus = mSignalStatus.getStatusImage();
        mLog.showInfo(TAG, `signal image: ${signalStatus}`);
        return signalStatus;
    }

    /**
     * Return the progress width and background color for the battery
     *
     * @return {string} battery progress width and background color
     */
    setOnBatteryListener() {
        let batteryStatus = mBatteryStatus.getStatusImage();
        mLog.showInfo(TAG, `battery status: ${batteryStatus}`);
        return batteryStatus;
    }

    /**
     * Get current time
     *
     * @param {object} callback - Callback function
     */
    setOnTimeListener(callback) {
        time = setInterval(() => {
            let currentDate = mDateManager.getCurrentDate();
            callback(currentDate);
        }, LOOP_TIME);
    }

    /**
     * Stop the loop of getting current time
     */
    stopUpdateTime() {
        clearInterval(time);
    }
}
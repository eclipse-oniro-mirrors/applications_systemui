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
import WindowManager from '../../center/statuscenter/manager/WindowManager.js'
import mLog from '../../common/utils/Log.js';

const TAG = 'StatusCenter';
const LOOP_TIME = 2000;
const SIGNAL_LOOP_TIME = 3000;

var mSignalStatus = new SignalStatus();
var mBatteryStatus = new BatteryStatus();
var mDateManager = new DateManager();
var mWindowManager = new WindowManager();

let signalInterval = null;
let signalListener = [];
let signalStatus = '';

let batteryInterval = null;
let batteryListener = [];
let batteryStatus = '';

let timeInterval = null;
let timeListener = [];
let timeStatus = '';

export default class StatusCenter {
    constructor() {
        this.initBatteryData();
        this.initTimeData();
        this.initSignalData();
    }

    /**
     * Initialize signal data
     */
    initSignalData() {
        mLog.showInfo(TAG, 'initSignalData');
        signalInterval = setInterval(() => {
            mSignalStatus.getStatusImage((result) => {
                signalStatus = result;
                mLog.showInfo(TAG, `startSignalData signalStatus ${signalStatus}`);
                this.sendSignalData();
            });
        }, SIGNAL_LOOP_TIME);
    }

    /**
     *Register signal data monitoring
     *
     * @param {Object} callback - Callback function
     */
    registerSignalListen(callback) {
        mLog.showInfo(TAG, `registerSignalListen signalListener length: ${signalListener.length}`);
        mLog.showInfo(TAG, `registerSignalListen callback indexOf: ${signalListener.indexOf(callback)}`);
        if (signalListener.indexOf(callback) === -1) {
            signalListener.push(callback);
        }
        mLog.showInfo(TAG, `registerSignalListen signalListener length: ${signalListener.length}`);
    }

    /**
     *Unregister signal data monitoring
     *
     * @param {Object} callback - Callback function
     */
    unRegisterSignalListen(callback) {
        mLog.showInfo(TAG, `unRegisterSignalListen signalListener length: ${signalListener.length}`);
        signalListener.splice(signalListener.indexOf(callback), 1);
        mLog.showInfo(TAG, `unRegisterSignalListen signalListener length: ${signalListener.length}`);
    }

    /**
     * Return signal data to the page
     */
    sendSignalData() {
        mLog.showInfo(TAG, 'sendSignalData');

        // Deep copy the callback array
        let newSignalListener = [];
        for (let i = 0; i < signalListener.length; i++) {
            newSignalListener.push(signalListener[i]);
        }

        if (newSignalListener.length > 0) {
            for (let index = 0; index < newSignalListener.length; index++) {
                mLog.showInfo(TAG, `sendSignalData ${newSignalListener[index]}`);
                newSignalListener[index](signalStatus);
            }
        }
    }

    /**
     * Stop get signal data
     */
    stopUpdateSignal() {
        clearInterval(signalInterval);
    }

    /**
     * Initialize battery data
     */
    initBatteryData() {
        mLog.showInfo(TAG, 'initBatteryData');
        batteryInterval = setInterval(() => {
            mBatteryStatus.getStatusImage((result) => {
                batteryStatus = result;
                mLog.showInfo(TAG, `initBatteryData batteryStatus ${batteryStatus}`);
                this.sendBatteryData();
            });
        }, LOOP_TIME);
    }

    /**
     *Register battery data monitoring
     *
     * @param {Object} callback - Callback function
     */
    registerBatteryListen(callback) {
        mLog.showInfo(TAG, `registerBatteryListen BatteryListener length: ${batteryListener.length}`);
        mLog.showInfo(TAG, `registerBatteryListen callback indexOf: ${batteryListener.indexOf(callback)}`);
        if (batteryListener.indexOf(callback) === -1) {
            batteryListener.push(callback);
        }
        mLog.showInfo(TAG, `registerBatteryListen BatteryListener length: ${batteryListener.length}`);
    }

    /**
     *Unregister battery data monitoring
     *
     * @param {Object} callback - Callback function
     */
    unRegisterBatteryListen(callback) {
        mLog.showInfo(TAG, `unRegisterBatteryListen BatteryListener length: ${batteryListener.length}`);
        batteryListener.splice(batteryListener.indexOf(callback), 1);
        mLog.showInfo(TAG, `unRegisterBatteryListen BatteryListener length: ${batteryListener.length}`);
    }

    /**
     * Return battery data to the page
     */
    sendBatteryData() {
        mLog.showInfo(TAG, 'sendBatteryData');

        // Deep copy the callback array
        let newBatteryListener = [];
        for (let i = 0; i < batteryListener.length; i++) {
            newBatteryListener.push(batteryListener[i]);
        }

        if (newBatteryListener.length > 0) {
            for (let index = 0; index < newBatteryListener.length; index++) {
                mLog.showInfo(TAG, `sendSignalData ${newBatteryListener[index]}`);
                newBatteryListener[index](batteryStatus);
            }
        }
    }

    /**
     * Stop get signal data
     */
    stopUpdateBattery() {
        clearInterval(batteryInterval);
    }

    /**
     * Initialize time data
     */
    initTimeData() {
        mLog.showInfo(TAG, 'initTimeData');
        timeInterval = setInterval(() => {
            mDateManager.getCurrentDate((result) => {
                timeStatus = result;
                mLog.showInfo(TAG, `initTimeData timeStatus ${timeStatus}`);
                this.sendTimeData();
            });
        }, LOOP_TIME);
    }

    /**
     *Register time data monitoring
     *
     * @param {Object} callback - Callback function
     */
    registerTimeListen(callback) {
        mLog.showInfo(TAG, `registerTimeListen TimeListener length: ${timeListener.length}`);
        mLog.showInfo(TAG, `registerTimeListen callback indexOf: ${timeListener.indexOf(callback)}`);
        if (timeListener.indexOf(callback) === -1) {
            timeListener.push(callback);
        }
        mLog.showInfo(TAG, `registerTimeListen TimeListener length: ${timeListener.length}`);
    }

    /**
     *Unregister time data monitoring
     *
     * @param {Object} callback - Callback function
     */
    unRegisterTimeListen(callback) {
        mLog.showInfo(TAG, `unRegisterTimeListen TimeListener length: ${timeListener.length}`);
        timeListener.splice(timeListener.indexOf(callback), 1);
        mLog.showInfo(TAG, `unRegisterTimeListen TimeListener length: ${timeListener.length}`);
    }

    /**
     * Return time data to the page
     */
    sendTimeData() {
        mLog.showInfo(TAG, `sendTimeData`);

        // Deep copy the callback array
        let newTimeListener = [];
        for (let i = 0; i < timeListener.length; i++) {
            newTimeListener.push(timeListener[i]);
        }

        if (newTimeListener.length > 0) {
            for (let index = 0; index < newTimeListener.length; index++) {
                mLog.showInfo(TAG, `sendTimeData ${newTimeListener[index]}`);
                newTimeListener[index](timeStatus);
            }
        }
    }

    /**
     * Stop the loop of getting current time
     */
    stopUpdateTime() {
        clearInterval(timeInterval);
    }

    /**
     * Set the status bar window to maximum size
     *
     * @param {Object} callback - Callback function
     */
    setWindowMax(callback) {
        mWindowManager.setWindowMax((result) => {
            callback(result);
        });
    }

    /**
     * Set the status bar window to minimum size
     *
     * @param {Object} callback - Callback function
     */
    setWindowMin(callback) {
        mWindowManager.setWindowMin((result) => {
            callback(result);
        });
    }
}
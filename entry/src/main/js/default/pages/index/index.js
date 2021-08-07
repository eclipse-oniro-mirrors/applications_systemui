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

import BatteryStatus from '../../center/battery/batteryStatus.js';
import SignalStatus from '../../center/signal/signalStatus.js';
import StatusCenter from '../../center/statuscenter/StatusCenter.js'
import mLog from '../../common/utils/Log.js';

const CHANGE = true;
const NOT_CHANGE = false;
const MAX_HEIGHT = "100%";
const MAX_WIDTH = "100%";
const MIN_HEIGHT = "0px";
const MIN_WIDTH = "0px";
const SPREAD_HEIGHT = 10;
const SHRINK_HEIGHT = -10;
const Y_INITIAL = 0;
const LOOP_TIME = 100;
const TAG = 'index';
var mBatteryStatus = new BatteryStatus();
var mSignalStatus = new SignalStatus();
var mStatusCenter = new StatusCenter();

globalThis.$globalT;

export default {
    data: {
        isShow: false,
        showMask: '',
        startGlobalY: Y_INITIAL,
        moveY: Y_INITIAL,
        isChange: false,
        statusHeight: MAX_HEIGHT,
        statusWidth: MAX_WIDTH,
        largeStatusBarHeight: MIN_HEIGHT,
        largeStatusBarWidth: MIN_WIDTH,
        backgroundColor: "",
        showClock: true
    },
    onInit() {
        mLog.showInfo(TAG, `onInit start`);
        // add resources file bind
        globalThis.$globalT = this.$t.bind(this);
        this.backgroundColor = this.$t('colors.statusBackground');
        mSignalStatus.init();
        mBatteryStatus.init();
        mLog.showInfo(TAG, `onInit end`);
    },
    onBackPress() {
        mLog.showInfo(TAG, `statusBar onBackPress start`);
        if (this.statusHeight == MIN_HEIGHT) {
            this.isChange = CHANGE;
            this.statusHeight = MAX_HEIGHT
            this.statusWidth = MAX_WIDTH;
            this.largeStatusBarHeight = MIN_HEIGHT;
            this.largeStatusBarWidth = MIN_WIDTH;
            this.backgroundColor = this.$t('colors.statusBackground');
            this.setWindowMin();
        }
        mLog.showInfo(TAG, `statusBar onBackPress end`);
    },

    /**
     * Set button click
     * @param {object} dateEvent  quicklySetting Set button click return data
     */
    settingClick(dateEvent) {
        mLog.showInfo(TAG, `settingClick start dateEvent: ${JSON.stringify(dateEvent)}`);
        this.statusHeight = dateEvent.detail.statusHeight;
        this.statusWidth = dateEvent.detail.statusWidth;
        this.largeStatusBarHeight = dateEvent.detail.notificationHeight;
        this.largeStatusBarWidth = dateEvent.detail.notificationWidth;
        this.backgroundColor = dateEvent.detail.backgroundColor;
    },
    onDestroy() {
        mLog.showInfo(TAG, `onDestroy`);
    },

    /**
     * Monitor touch start method
     * @param {object} touchEvent  TouchStart return data
     */
    onTouchStartListener(touchEvent) {
        mLog.showInfo(TAG, `onTouchStartListener start touchEvent: ${JSON.stringify(touchEvent)}`);
        this.startGlobalY = touchEvent.touches[0].globalY;
        this.isChange = NOT_CHANGE;
    },

    /**
     * Monitor touch Move method
     * @param {object} touchEvent  TouchMove return data
     */
    onTouchMoveListener(touchEvent) {
        mLog.showInfo(TAG, `onTouchStartListener move touchEvent: ${JSON.stringify(touchEvent)}`);
        if (this.isChange == CHANGE) {
            return;
        }
        this.moveY = touchEvent.touches[0].globalY - this.startGlobalY;
        if (this.moveY >= SPREAD_HEIGHT) {
            this.isChange = CHANGE;
            this.statusHeight = MIN_HEIGHT;
            this.statusWidth = MIN_WIDTH;
            setTimeout(() => {
                this.largeStatusBarHeight = MAX_HEIGHT;
                this.largeStatusBarWidth = MAX_WIDTH;
                this.backgroundColor = "";
                this.setWindowMax();
            }, LOOP_TIME);
        } else if (this.moveY < SHRINK_HEIGHT) {
            this.isChange = CHANGE;
            this.statusHeight = MAX_HEIGHT
            this.statusWidth = MAX_WIDTH;
            setTimeout(() => {
                this.largeStatusBarHeight = MIN_HEIGHT;
                this.largeStatusBarWidth = MIN_WIDTH;
                this.backgroundColor = this.$t('colors.statusBackground');
                this.setWindowMin();
            }, LOOP_TIME);
        }
    },

    /**
     * Maximize window
     */
    setWindowMax() {
        mStatusCenter.setWindowMax((result) => {
            mLog.showInfo(TAG, `setWindowMax result: ${result}`);
        });
    },

    /**
     * Minimize window
     */
    setWindowMin() {
        mStatusCenter.setWindowMin((result) => {
            mLog.showInfo(TAG, `setWindowMin result ${result}`);
        });
    }
}
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

import StatusCenter from '../../center/statuscenter/StatusCenter.js';
import mLog from '../../common/utils/Log.js';
import FeatureAbility from '@ohos.ability.featureability';

const CHANGE = true;
const NOT_CHANGE = false;
const MAX_HEIGHT = '100%';
const MAX_WIDTH = '100%';
const MIN_HEIGHT = '0px';
const MIN_WIDTH = '0px';
const SPREAD_HEIGHT = 10;
const SHRINK_HEIGHT = -10;
const Y_INITIAL = 0;
const LOOP_TIME = 100;
const LOOP_TIME_UP = 300;
const TAG = 'index';
const MARK_MONDAY = 1;
const MARK_TUESDAY = 2;
const MARK_WEDNESDAY = 3;
const MARK_THURSDAY = 4;
const MARK_FRIDAY = 5;
const MARK_SATURDAY = 6;
const MARK_SUNDAY = 0;
const SETTINGS_BUNDLE_NAME = 'com.ohos.settings';
const SETTINGS_ABILITY_NAME = 'com.ohos.settings.MainAbility';

var mStatusCenter = new StatusCenter();

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
        backgroundColor: '',
        showClock: true,
        showLarge:false,
        mCellularType:'',
        mTypeShow:'',
        mCellularImage:'',
        mBackgroundColor:'',
        mProgressWidth:'',
        mTime:'',
        mDate:''

    },

    onInit() {
        mLog.showInfo(TAG, 'onInit start');
        this.backgroundColor = this.$t('colors.statusBackground');
        this.$app.$def.data.StatusCenter.registerSignalListen(this.getSignalImage.bind(this));
        this.$app.$def.data.StatusCenter.registerBatteryListen(this.getBatteryValue.bind(this));
        this.$app.$def.data.StatusCenter.registerTimeListen(this.getcurrentTime.bind(this));
        mLog.showInfo(TAG, 'onInit end');
    },

    onBackPress() {
        mLog.showInfo(TAG, 'statusBar onBackPress start');
        if (this.statusHeight === MIN_HEIGHT) {
            this.isChange = CHANGE;
            this.statusHeight = MAX_HEIGHT;
            this.statusWidth = MAX_WIDTH;
            this.largeStatusBarHeight = MIN_HEIGHT;
            this.largeStatusBarWidth = MIN_WIDTH;
            this.backgroundColor = this.$t('colors.statusBackground');
            this.setWindowMin();
            this.showLarge = false;
        }
        mLog.showInfo(TAG, 'statusBar onBackPress end');
    },

    /**
     * Set button click
     *
     * @param {Object} dateEvent  quicklySetting Set button click return data
     */
    settingClick(dateEvent) {
        mLog.showInfo(TAG, `settingClick start dateEvent: ${JSON.stringify(dateEvent)}`);
        this.showLarge = false;
        this.statusHeight = dateEvent.detail.statusHeight;
        this.statusWidth = dateEvent.detail.statusWidth;
        this.largeStatusBarHeight = dateEvent.detail.notificationHeight;
        this.largeStatusBarWidth = dateEvent.detail.notificationWidth;
        this.backgroundColor = dateEvent.detail.backgroundColor;
        setTimeout(() => {
            this.setWindowMin();
        }, LOOP_TIME);

        let result = FeatureAbility.startAbility({
            want: {
                bundleName: SETTINGS_BUNDLE_NAME,
                abilityName: SETTINGS_ABILITY_NAME,
            },
        }).then(data =>
        mLog.showInfo(TAG, `promise then: ${JSON.stringify(data)}`)).catch(error =>
        mLog.showError(TAG, `promise catch: ${JSON.stringify(error)}`));
        mLog.showInfo(TAG, `start ability ${result}`);
    },

    onDestroy() {
        mLog.showInfo(TAG, 'onDestroy');
        this.$app.$def.data.StatusCenter.unRegisterBatteryListen(this.getBatteryValue.bind(this));
        this.$app.$def.data.StatusCenter.unRegisterSignalListen()(this.getSignalImage.bind(this));
        this.$app.$def.data.StatusCenter.unRegisterTimeListen()(this.getcurrentTime.bind(this));
        this.$app.$def.data.StatusCenter.stopUpdateTime();
        this.$app.$def.data.StatusCenter.stopUpdateBattery();
        this.$app.$def.data.StatusCenter.stopUpdateSignal();
    },

    /**
     * Monitor touch start method
     *
     * @param {Object} touchEvent  TouchStart return data
     */
    onTouchStartListener(touchEvent) {
        mLog.showInfo(TAG, `onTouchStartListener start touchEvent: ${JSON.stringify(touchEvent)}`);
        this.startGlobalY = touchEvent.touches[0].globalY;
        this.isChange = NOT_CHANGE;
    },

    /**
     * Monitor touch Move method
     *
     * @param {Object} touchEvent  TouchMove return data
     */
    onTouchMoveListener(touchEvent) {
        mLog.showInfo(TAG, `onTouchStartListener move touchEvent: ${JSON.stringify(touchEvent)}`);
        if (this.isChange === CHANGE) {
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
                this.backgroundColor = '';
                this.setWindowMax();
                this.showLarge = true;
            }, LOOP_TIME);
        } else if (this.moveY < SHRINK_HEIGHT) {
            this.isChange = CHANGE;
            this.showLarge = false;
            this.statusHeight = MAX_HEIGHT;
            this.statusWidth = MAX_WIDTH;
            this.backgroundColor = this.$t('colors.statusBackground');
            setTimeout(() => {
                this.setWindowMin();
            }, LOOP_TIME_UP);
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
    },

    /**
     * Get signal icon Data
     *
     * @param {string} result result signal icon data
     */
    getSignalImage(result) {
        mLog.showInfo(TAG, `signalImage: ${result}`);
        this.mCellularType = JSON.parse(result).cellularType;
        if (this.mCellularType === '') {
            this.mTypeShow = false;
        } else {
            this.mTypeShow = true;
        }
        this.mCellularImage = JSON.parse(result).cellularImage;
    },

    /**
     * Get battery data
     *
     * @param {string} result result battery data
     */
    getBatteryValue(result) {
        mLog.showInfo(TAG, `batteryValue: ${JSON.parse(result)}`);
        this.mBackgroundColor = JSON.parse(result).mBackgroundColor;
        this.mProgressWidth = JSON.parse(result).mProgressWidth;
    },

    /**
     * Get currentTime data
     *
     * @param {string} result result currentTime data
     */
    getcurrentTime(result) {
        mLog.showInfo(TAG, `getcurrentTime: ${result}`);
        this.mTime = JSON.parse(result).time;
        let weekDay = '';
        switch (JSON.parse(result).date.weekDay) {
            case MARK_MONDAY:
            weekDay = this.$t('strings.monday');
            break;
            case MARK_TUESDAY:
            weekDay = this.$t('strings.tuesday');
            break;
            case MARK_WEDNESDAY:
            weekDay = this.$t('strings.wednesday');
            break;
            case MARK_THURSDAY:
            weekDay = this.$t('strings.thursday');
            break;
            case MARK_FRIDAY:
            weekDay = this.$t('strings.friday');
            break;
            case MARK_SATURDAY:
            weekDay = this.$t('strings.saturday');
            break;
            case MARK_SUNDAY:
            weekDay = this.$t('strings.sunday');
            break;
            default:
                break;
        }
        this.mDate =JSON.parse(result).date.month + this.$t('strings.month') + JSON.parse(result).date.day
        + this.$t('strings.day') + weekDay;
        mLog.showInfo(TAG, `getcurrentTime: ${this.mDate}`);
    }
}
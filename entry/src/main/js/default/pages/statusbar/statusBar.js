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

const TAG = 'statusBar';
const LOOP_TIME = 1500;
var mStatusCenter = new StatusCenter();

export default {
    props: ['statusHeight', 'statusWidth', "backgroundColor", "showClock"],
    data: {
        mCellularType: '',
        mTypeShow: '',
        mCellularImage: '',
        mBackgroundColor: '',
        mProgressWidth: '',
    },
    onInit() {
        mLog.showInfo(TAG, `onInit`);
        let that = this;
        setInterval(function () {
            that.getBatteryValue();
            that.getSignalImage();
        }, LOOP_TIME);
    },

    /**
     * Get signal icon Data
     */
    getSignalImage() {
        let signalStatus = mStatusCenter.setOnSignalListener();
        mLog.showInfo(TAG, `signalImage: ${signalStatus}`);
        this.mCellularType = JSON.parse(signalStatus).cellularType;
        if (this.mCellularType == '') {
            this.mTypeShow = false;
        } else {
            this.mTypeShow = true;
        }
        this.mCellularImage = JSON.parse(signalStatus).cellularImage;
    },

    /**
     * Get battery data
     */
    getBatteryValue() {
        let batteryValue = mStatusCenter.setOnBatteryListener();
        mLog.showInfo(TAG, `batteryValue: ${batteryValue}`);
        this.mBackgroundColor = JSON.parse(batteryValue).mBackgroundColor;
        this.mProgressWidth = JSON.parse(batteryValue).mProgressWidth;
    }
}

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
import mLog from '../../common/utils/Log.js';

const MAX_HEIGHT = "100%";
const MAX_WIDTH = "100%";
const TAG = 'index';
var mBatteryStatus = new BatteryStatus();
var mSignalStatus = new SignalStatus();

globalThis.$globalT;

export default {
    data: {
        statusHeight: MAX_HEIGHT,
        statusWidth: MAX_WIDTH,
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

    onDestroy() {
        mLog.showInfo(TAG, `onDestroy`);
    },
}
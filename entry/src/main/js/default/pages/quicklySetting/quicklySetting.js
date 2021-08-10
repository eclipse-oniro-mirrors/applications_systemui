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

import mLog from '../../common/utils/Log.js';

const TAG = 'quicklySetting';
const MAX_HEIGHT = '100%';
const MAX_WIDTH = '100%';
const MIN_HEIGHT = '0px';
const MIN_WIDTH = '0px';

export default {
    props:['mTime', 'mDate'],

    data: {
    },

    onInit() {
        mLog.showInfo(TAG, 'onInit');
    },

    /**
     * Set button click
     */
    settingClick() {
        mLog.showInfo(TAG, 'setting click and start ability setting');
        this.$emit('eventSet', {
            statusHeight: MAX_HEIGHT,
            statusWidth: MAX_WIDTH,
            notificationHeight: MIN_HEIGHT,
            notificationWidth: MIN_WIDTH,
            backgroundColor: this.$t('colors.statusBackground')
        });
    },
}

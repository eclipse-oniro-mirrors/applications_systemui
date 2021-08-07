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

const TAG = 'quicklySetting';
const MAX_HEIGHT = "100%";
const MAX_WIDTH = "100%";
const MIN_HEIGHT = "0px";
const MIN_WIDTH = "0px";
const REQUEST_CODE = 1;
const FLAGS = 2;
const SYNC_OPTION = 1;
const SETTINGS_BUNDLE_NAME = 'com.ohos.settings';
const SETTINGS_ABILITY_NAME = 'com.ohos.settings.MainAbility';

var mStatusCenter = new StatusCenter();

export default {
    data: {
        mTime:"",
        mDate:""
    },
    onInit() {
        mLog.showInfo(TAG, `onInit`)
        this.getDateTime();
    },

    /**
     * Set button click
     */
    settingClick(){
        mLog.showInfo(TAG, `setting click and start ability setting`);
        this.$emit('settingClick', {
            statusHeight : MAX_HEIGHT,
            statusWidth : MAX_WIDTH,
            notificationHeight : MIN_HEIGHT,
            notificationWidth : MIN_WIDTH,
            backgroundColor :this.$t('colors.statusBackground')
        });
        this.setWindowMin();
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

    /**
     * Minimize window
     */
    setWindowMin(){
        mStatusCenter.setWindowMin((result) =>{
            mLog.showInfo(TAG, `setWindowMin result: ${result}`);
        });
    },

    /**
     * Get display time
     */
    getDateTime(){
        mStatusCenter.setOnTimeListener((currentDate) => {
            this.mTime = JSON.parse(currentDate).time;
            this.mDate = JSON.parse(currentDate).date;
        });
    }
}

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

import featureAbility from '@ohos.ability.featureability';

import mLog from '../../common/utils/Log.js';

const TAG = 'SystemDialog_SystemDialogCenter';

export default class SystemDialogCenter {

    /**
     * Get permission information
     *
     * @param {Object} callBack - Callback function
     */
    getMessageWant(callBack) {
        mLog.showInfo(TAG, 'getMessageWant Start');
        featureAbility.getWant((err, data) => {
            let appArray = data;
            mLog.showInfo(TAG, ` getMessageWant callBack  ${JSON.stringify(appArray)}`);
            callBack(appArray);
        });
    }

    /**
     * Return of the authority information selected by the user
     *
     * @param {Object} AbilityResult - information selected by the user
     */
    finishResult(AbilityResult){
        if(Object.keys(AbilityResult) .length != 0){
            mLog.showInfo(TAG, 'finishResult Start');
            mLog.showInfo(TAG, ` finishResult parameter  ${JSON.stringify(AbilityResult)}`);
            featureAbility.finishWithResult(AbilityResult, (err, data) => {
                mLog.showInfo(TAG, 'finishResult finishWithResult callback');
                featureAbility.terminateAbility((err, data) => {
                    mLog.showInfo(TAG, 'finishResult terminateAbility callback');
                });
            });
        } else {
            mLog.showInfo(TAG, 'finishResult AbilityResult is a empty object');
        }
    }
}
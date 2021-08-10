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
import SystemDialogCenter from '../../center/systemDialogCenter/SystemDialogCenter.js';

var mSystemDialogCenter = new SystemDialogCenter();
const TAG = 'SystemDialog';

export default {
    data: {
        getData: '',
        workDataArray: [],
        useList: [],
        unUseList: []
    },
    onInit() {
        mLog.showInfo(TAG, ` onInitStart`);
    },
    onShow() {
        mLog.showInfo(TAG, ` onShowStart`);
        // get the requested permission data
        mSystemDialogCenter.getMessageWant(this.getMessage.bind(this));
    },

    /**
     * Get permission data
     * @param {Object} resultData  permission data Object
     *
     */
    getMessage(resultData) {
        if (Object.keys(resultData).length != 0) {
            this.getData = resultData;
            mLog.showInfo(TAG, ` getMessageWant result Data ${JSON.stringify(resultData)}`);
            // handle permission Data to show
            for (let item of resultData.parameters.OHOS_REQUEST_PERMISSIONS_LIST) {
                this.workDataArray.push(
                    {
                        permissions: item,
                        checked: false
                    }
                )
            }
            mLog.showInfo(TAG, ` getMessageWant work with data  ${JSON.stringify(this.workDataArray)}`);
        } else {
            mLog.showInfo(TAG, ` getMessageWant result Data is a empty object`);
        }
    },

    /**
     * Processing of permission selection or cancellation
     * @param {string} checked    Selected status
     * @param {string} permissions  Selected permissions
     */
    changeSwitch(checked, permissions) {
        mLog.showInfo(TAG, ` changeSwitch start`);
        mLog.showInfo(TAG, ` changeSwitch parameter checked: ${checked}  permissions: ${permissions}`);

        let indexNum;
        for (let i = 0; i < this.workDataArray.length; i++) {
            if (permissions == this.workDataArray[i].permissions) {
                indexNum = i;
            }
        }

        if (checked) {
            this.workDataArray[indexNum].checked = false;
        } else {
            this.workDataArray[indexNum].checked = true;
        }
        mLog.showInfo(TAG, ` changeSwitch End`);
    },

    /**
     * User confirmation
     */
    makeSure() {
        mLog.showInfo(TAG, ` makeSure Click`);
        for (let item of this.workDataArray) {
            if (item.checked) {
                this.useList.push(item.permissions);
            } else {
                this.unUseList.push(item.permissions);
            }
        }
        let want = {
            parameters: {
                OHOS_RESULT_PERMISSION_KEY: 1,
                OHOS_RESULT_PERMISSIONS_LIST: this.getData.parameters.OHOS_REQUEST_PERMISSIONS_LIST,
                OHOS_RESULT_PERMISSIONS_LIST_YES: this.useList,
                OHOS_RESULT_PERMISSIONS_LIST_NO: this.unUseList,
                OHOS_RESULT_CALLER_BUNDLERNAME: this.getData.parameters.OHOS_REQUEST_CALLER_BUNDLERNAME
            },
        };

        let AbilityResult = { resultCode: 1,want: want };

        mSystemDialogCenter.finishResult(AbilityResult);
    },

    /**
     * User canceled
     */
    cancelButton() {
        mLog.showInfo(TAG, ` cancelButton Click`);
        let want = {
            parameters: {
                OHOS_RESULT_PERMISSION_KEY: 1,
                OHOS_RESULT_PERMISSIONS_LIST: this.getData.parameters.OHOS_REQUEST_PERMISSIONS_LIST,
                OHOS_RESULT_CALLER_BUNDLERNAME: this.getData.parameters.OHOS_REQUEST_CALLER_BUNDLERNAME
            },
        };
        let AbilityResult = { resultCode: 0,want: want };
        mSystemDialogCenter.finishResult(AbilityResult);
    }
}

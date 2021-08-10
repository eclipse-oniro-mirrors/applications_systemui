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
 * Get the cellular and wifi status
 */

import Radio from '@ohos.telephony_radio';
import mLog from '../../common/utils/Log.js';
import mCheckEmpty from '../../common/utils/CheckEmptyUtils.js';

const TAG = 'signalStatus';
const EMPTY_LEVEL = 0;
const CELLULAR_NONE_IMAGE = 'common/image_xxhdpi/ic_statusbar_signal_null.png';
const CELLULAR_EMPTY_IMAGE = 'common/image_xxhdpi/ic_statusbar_signal_no.png';
const CELLULAR_MIN_IMAGE = 'common/image_xxhdpi/ic_cellular_signal_min.png';
const CELLULAR_LOW_IMAGE = 'common/image_xxhdpi/ic_cellular_signal_low.png';
const CELLULAR_HALF_IMAGE = 'common/image_xxhdpi/ic_statusbar_signal_half.png';
const CELLULAR_HIGH_IMAGE = 'common/image_xxhdpi/ic_cellular_signal_high.png';
const CELLULAR_FULL_IMAGE = 'common/image_xxhdpi/ic_statusbar_signal_full.png';

var mCellularStatus;
var mCellularImage;
var SignalListenerInterval;

export default class signalStatus {
    constructor() {
    }

    /**
     * Get the images of cellular and wifi need to be showed on status bar
     *
     * @param {Object} callback - Callback function
     */
    getStatusImage(callback) {
        let signalValue = {};
        this.getSignalMessage();
        signalValue.cellularImage = mCellularImage.image;
        signalValue.cellularType = mCellularImage.type;
        mLog.showInfo(TAG, `cellular type = ${signalValue.cellularType}, image = ${signalValue.cellularImage}`);
        callback(JSON.stringify(signalValue));
    }

    /**
     * Get signal value
     */
    getSignalMessage(){
        this.checkCellularStatus((result)=>{
            mCellularStatus = result;
            mCellularImage = this.updateCellularImage();
        });
    }

    /**
     * Update the image of cellular status
     *
     * @return {string} image used to show cellular status
     */
    updateCellularImage() {
        mLog.showInfo(TAG, `enter updateCellularImage ============`);
        let status = mCellularStatus;
        let type = status.signalType;
        let level = status.signalLevel;
        let typeString = '';
        let image = '';
        let imageResult = {};
        mLog.showInfo(TAG, `status = ${JSON.stringify(status)}`);
        if (type == 0) {
            image = CELLULAR_NONE_IMAGE;
        } else {
            switch (level) {
                case 0:
                    image = CELLULAR_EMPTY_IMAGE;
                    break;
                case 1:
                    image = CELLULAR_MIN_IMAGE;
                    break;
                case 2:
                    image = CELLULAR_LOW_IMAGE;
                    break;
                case 3:
                    image = CELLULAR_HALF_IMAGE;
                    break;
                case 4:
                    image = CELLULAR_HIGH_IMAGE;
                    break;
                case 5:
                    image = CELLULAR_FULL_IMAGE;
                    break;
                default:
                    break;
            }
            switch (type) {
                case 0:
                    typeString = '';
                    break;
                case 1:
                case 2:
                    typeString = '2G';
                    break;
                case 3:
                case 4:
                    typeString = '3G';
                    break;
                case 5:
                    typeString = '4G';
                    break;
                case 6:
                    typeString = '5G';
                    break;
                default:
                    typeString = '5G';
                    break;
            }
        }
        imageResult.type = typeString;
        imageResult.image = image;
        mLog.showInfo(TAG, `cellular result = ${JSON.stringify(imageResult)}`);
        return imageResult;
    }

    /**
     * Check the connection type and signal level of cellular network
     *
     * @return {object} the type and signal level of cellular network
     */
    checkCellularStatus(callback) {
        let cellularStatus;
        let slotId = 1;
        mLog.showInfo(TAG, `enter checkCellularStatus ============`);
        //         The interface of getting the cellular signal status is unavailable temporarily
        Radio.getSignalInformation(slotId, (err, value) => {
            if (err) {
                // Failed to call the interface，error is not null
                mLog.showError(TAG, `failed to getSimState because ${err.message}`);
                // When failed to call the interface, set the result as no signal
                let defaultValue = {}
                defaultValue.signalType = EMPTY_LEVEL;
                defaultValue.signalLevel = EMPTY_LEVEL;
                cellularStatus = defaultValue;
            } else {
                // Call interface succeed，error is null
                mLog.showInfo(TAG, `success to getSimState: ${value}`);
                // Since the value might be empty, set it as no signal by hand
                if (mCheckEmpty.isEmpty(value)) {
                    mLog.showError(TAG, `value from api is empty, set 0`)
                    value.signalType = EMPTY_LEVEL;
                    value.signalLevel = EMPTY_LEVEL;
                }
                cellularStatus = value;
            }
            callback(cellularStatus);
        });
    }
}
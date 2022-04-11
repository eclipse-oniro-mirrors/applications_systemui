/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
import Log from '../../../../../../../../common/src/main/ets/default/Log'
import Notification from '@ohos.notification';
import ConfigData, {DoNotDisturbType} from '../common/constants'
import TimeManager from '../../../../../../../../common/src/main/ets/default/TimeManager';

const TAG = 'NotificationManagenment-NoDisturbingModel';
const MK_DATE_SPLIT = '-';
const MK_NUM_FILL = '0';
const VALUE_NUM_FILL = 10;

export default class NoDisturbingModel {
  static getNoDisturbingDate(callback) {
    Notification.getDoNotDisturbDate((error, data) => {
      if (error.code != 0) {
        Log.showInfo(TAG, 'getNoDisturbingDate error:' + JSON.stringify(error));
      } else {
        Log.showInfo(TAG, 'getNoDisturbingDate data:' + JSON.stringify(data));
        let noDisturbingData = {}
        noDisturbingData['type'] = data.type
        if (data.type == DoNotDisturbType.TYPE_CLEARLY) {
          noDisturbingData['begin'] = this.formatDateTime(data.begin) ;
          noDisturbingData['end'] = this.formatDateTime(data.end) ;
        } else {
          noDisturbingData['begin'] = this.formatTime(data.begin) ;
          noDisturbingData['end'] = this.formatTime(data.end) ;
        }
        callback(noDisturbingData)
      }
    })
  }

  static setNoDisturbingDate(noDisturbingTime, callback) {
    let targetDate = {}
    targetDate['type'] = noDisturbingTime.type
    targetDate['begin'] = noDisturbingTime.begin
    targetDate['end'] = noDisturbingTime.end
    Log.showInfo(TAG, `Notification.setDoNotDisturbDate targetDate['type'] : ` + JSON.stringify(targetDate['type']));
    Log.showInfo(TAG, `Notification.setDoNotDisturbDate targetDate['begin'] : ` + JSON.stringify(targetDate['begin']));
    Log.showInfo(TAG, `Notification.setDoNotDisturbDate targetDate['end'] : ` + JSON.stringify(targetDate['end']));
    Notification.setDoNotDisturbDate(targetDate, callback)
  }
  static formatDate (data: Date): string {
    let result = data.getFullYear() + MK_DATE_SPLIT;
    let numTmp = data.getMonth() + 1;
    if (numTmp < VALUE_NUM_FILL) {
      result += MK_NUM_FILL;
    }
    result += (data.getMonth() + 1);
    result += MK_DATE_SPLIT;
    numTmp = data.getDate();
    if (numTmp < VALUE_NUM_FILL) {
      result += MK_NUM_FILL;
    }
    result += numTmp;
    return result;
  }
  static formatDateTime (data: Date): string {
    let result = this.formatDate(data);
    result += ' ' + TimeManager.formatTime(data);
    return result;
  }
  static formatTime (data: Date): string {
    return TimeManager.formatTime(data);
  }
 }


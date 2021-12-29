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
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import Notification from '@ohos.notification';
import DateAndTime from '../../../../../../../../common/src/main/ets/default/DateAndTimeUtil.ets';

const TAG = 'NotificationManagenment-NoDisturbingModel';

export default class NoDisturbingModel {
  static getNoDisturbingDate(callback) {
    //TODO:Interface in preparation
    //    Notification.getDoNotDisturbDate((error, data) => {
    //      if (error != undefined && error != null) {
    //        Log.showInfo(TAG, 'getNoDisturbingDate error:' + JSON.stringify(error));
    //      } else {
    //        Log.showInfo(TAG, 'getNoDisturbingDate data:' + JSON.stringify(data));
    //        let noDisturbingData = {}
    //        noDisturbingData['type'] = data.type
    //        noDisturbingData['begin'] = DateAndTime.concatTime(data.begin.getHours(), data.begin.getMinutes());
    //        noDisturbingData['end'] = DateAndTime.concatTime(data.end.getHours(), data.end.getMinutes());
    //        callback(noDisturbingData)
    //      }
    //    })
    //TODO: Temporary code.
    let noDisturbingData = {}
    noDisturbingData['type'] = 0
    noDisturbingData['begin'] = DateAndTime.concatTime(22, 0);
    noDisturbingData['end'] = DateAndTime.concatTime(7, 0)
    callback(noDisturbingData)
  }

  static setNoDisturbingDate(noDisturbingTime, callback) {
    //TODO:Interface in preparation
    //let targetDate : DoNotDisturbDate
    //targetDate.type = noDisturbingTime.type
    //targetDate.begin = noDisturbingTime.begin
    //targetDate.end = noDisturbingTime.end
    //Notification.setDoNotDisturbDate(targetDate, callback)
    //TODO: Temporary code.
    callback(null,null)
  }
}


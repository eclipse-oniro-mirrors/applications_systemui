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

import ConfigData from '../common/constants.ets';
import Log from '../../../../../../../common/src/main/ets/default/Log.ets';
import NoDisturbingModel from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/noDisturbingModel.ets';
import NoDisturbComponentViewModel from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/vm/noDisturbComponentViewModel.ets';

const TAG = 'NotificationManagement-NoDisturbViewModel'

export default class NoDisturbViewModel extends NoDisturbComponentViewModel {

  endTimeClue: string = ''

  setClues() {
    Log.showInfo(TAG, `setClues`)
    if (this.startTime > this.endTime) {
      this.endTimeClue = ConfigData.NEXT_DAY_NAME + this.endTime
    } else {
      this.endTimeClue = this.endTime
    }
    this.defaultStartTime = this.getDateByHHMI(this.startTime)
    this.defaultEndTime = this.getDateByHHMI(this.endTime)
  }

  setNoDisturbingDate() {
    let noDisturbingTime = {
      type: this.repeatMode, begin: this.defaultStartTime, end: this.defaultEndTime
    }
    NoDisturbingModel.setNoDisturbingDate(noDisturbingTime, () => {
      Log.showInfo(TAG, 'setNoDisturbingDate is success')
    })
  }

  onStartTimeAccept(data) {
    Log.showInfo(TAG, `onStartTimeAccept`)
    this.startTime = data
    this.setClues()
    this.setNoDisturbingDate()

  }

  onEndTimeAccept(data) {
    Log.showInfo(TAG, `onEndTimeAccept`)
    this.endTime = data
    this.setClues()
    this.setNoDisturbingDate()
  }

  onRepeatModeAccect(data) {
    Log.showInfo(TAG, `onRepeatModeAccect`)
    this.setNoDisturbingDate()
  }

  onCancel() {
    Log.showInfo(TAG, `onCancel`)
  }
}
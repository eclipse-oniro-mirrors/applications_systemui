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

import Log from '../../../../../../../../common/src/main/ets/default/Log.ets';
import NoDisturbingModel from '../model/noDisturbingModel.ets';
import ConfigData from '../common/constants.ets'

const TAG = 'ManagementComponent-NoDisturbComponentViewModel'

export default class NoDisturbComponentViewModel {
  defaultStartTime: Date= new Date()
  defaultEndTime: Date= new Date()
  startTime: string = ''
  endTime: string = ''
  repeatMode: number = 0
  prompt: string
  isEffective: boolean

  ViewModelInit(): void{
    Log.showInfo(TAG, 'ViewModelInit');
    this.getNoDisturbingDate.bind(this)()
    this.setClues.bind(this)()
  }

  getNoDisturbingDate() {
    Log.showInfo(TAG, 'getNoDisturbingDate');
    NoDisturbingModel.getNoDisturbingDate((data) => {
      Log.showInfo(TAG, 'getNoDisturbingDate data:' + JSON.stringify(data));
      this.repeatMode = data.type
      this.startTime = data.begin
      this.endTime = data.end
    })
  }

  setNoDisturbingDate() {

    if (!this.isEffective) {
      this.repeatMode = 0
    }

    let noDisturbingTime = {
      type: this.repeatMode, begin: this.defaultStartTime, end: this.defaultEndTime
    }
    NoDisturbingModel.setNoDisturbingDate(noDisturbingTime, () => {
      Log.showInfo(TAG, 'setNoDisturbingDate is success')
    })
  }

  setClues() {
    Log.showInfo(TAG, `setClues`)
    let repeadName
    if (this.repeatMode == 2) {
      this.isEffective = true
      repeadName = ConfigData.EVERY_DAY_NAME
    } else {
      this.isEffective = false
      repeadName = ''
    }

    if (this.startTime > this.endTime) {
      this.prompt = repeadName + this.startTime + ' - ' + ConfigData.NEXT_DAY_NAME + this.endTime
    } else {
      this.prompt = repeadName + this.startTime + ' - ' + this.endTime
    }
    this.defaultStartTime = this.getDateByHHMI(this.startTime)
    this.defaultEndTime = this.getDateByHHMI(this.endTime)
  }

  getDateByHHMI(selectDate: string): Date{
    Log.showInfo(TAG, `getDateByHHMI selectDate：` + selectDate)
    let tempDate: Date = new Date()
    let HHmiArr = selectDate.split(':')
    let hour = parseInt(HHmiArr[0])
    let minute = parseInt(HHmiArr[1])
    tempDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDay(),
      hour, minute, tempDate.getSeconds())
    return tempDate;
  }
}


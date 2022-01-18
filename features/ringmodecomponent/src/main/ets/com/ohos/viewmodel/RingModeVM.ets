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
import {AudioRingMode} from '../common/Constants.ets'
import RingModeService from '../model/RingModeService.ets';

export const RingModeComponentModeKey = "RingModeComponentMode";

const TAG = 'RingModeVM';

export class RingModeVM {
  mIsStart: boolean = false;
  mRingModeComponentMode: any;

  initViewModel() {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `initViewModel `)
    this.mIsStart = true;

    this.mRingModeComponentMode = AppStorage.SetAndLink(RingModeComponentModeKey, AudioRingMode.RINGER_MODE_NORMAL);

    RingModeService.registerListener({
      'updateRingerMode': this.updateRingerMode.bind(this)
    });
    RingModeService.startService();
  }

  updateRingerMode(mode) {
    Log.showInfo(TAG, `updateRingerMode, mode: ${JSON.stringify(mode)} `)
    this.mRingModeComponentMode.set(mode);
  }

  setRingerMode(mode) {
    Log.showInfo(TAG, `setRingerMode, mode: ${JSON.stringify(mode)} `)
    RingModeService.setRingerMode(mode);
  }
}

let ringModeVM = new RingModeVM();

export default ringModeVM as RingModeVM;
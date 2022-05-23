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

import audio from '@ohos.multimedia.audio';
import Log from '../../../../../../../../common/src/main/ets/default/Log';
import createOrGet from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import {getAudioManager} from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';

const TAG = 'RingModeModel';

export class RingModeService {
  mIsStart: boolean = false;
  mListener: any;
  mAudioManager: any;

  startService() {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `startService`);
    this.mIsStart = true;

    this.mAudioManager = getAudioManager();

    this.getRingerMode();

    this.mAudioManager.on('ringerModeChange', (data) => {
      Log.showInfo(TAG, `startService->ringerModeChange, data: ${JSON.stringify(data)}`);
      this.mListener?.updateRingerMode(data);
    });
  }

  stopService() {
    if (!this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `stopService`);
    this.mIsStart = false;

    this.mAudioManager = null;
  }

  registerListener(listener: {
    'updateRingerMode': Function
  }) {
    Log.showInfo(TAG, `registerListener, listener: ${listener}`);
    this.mListener = listener;
  }

  getRingerMode() {
    this.mAudioManager.getRingerMode((error, action) => {
      Log.showInfo(TAG, `getRingerMode, error: ${JSON.stringify(error)} action: ${JSON.stringify(action)}`);
      if (error) {
        return;
      }
      this.mListener?.updateRingerMode(action);
    });
  }

  setRingerMode(mode) {
    Log.showInfo(TAG, `setRingerMode, mode: ${JSON.stringify(mode)}`);
    this.mAudioManager.setRingerMode(mode, (err, data) => {
      Log.showInfo(TAG, `mAudioManager.setRingerMode`);
    })
  }
}

let sRingModeService = createOrGet(RingModeService, TAG);

export default sRingModeService as RingModeService;
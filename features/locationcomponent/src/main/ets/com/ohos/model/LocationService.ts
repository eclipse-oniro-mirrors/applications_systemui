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

import geolocation from '@ohos.geolocation';
import Log from '../../../../../../../../common/src/main/ets/default/Log';
import createOrGet from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';

const TAG = 'LocationModel';

export class LocationService {
  mIsStart: boolean = false;
  mListener: any;

  startService() {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `startService`);
    this.mIsStart = true;
    this.getServiceState();
    geolocation.on('locationServiceState', (state) => {
      Log.showInfo(TAG, `startService locationChange, state: ${JSON.stringify(state)}`);
      this.getServiceState();
    });
  }

  stopService() {
    if (!this.mIsStart) {
      return;
    };
    Log.showInfo(TAG, `stopService`);
    this.mIsStart = false;
    geolocation.off('locationServiceState', (state) => {
      Log.showInfo(TAG, `stopService locationChange, state: ${JSON.stringify(state)}`)
    });
  }

  registerListener(listener: {
    'updateServiceState': Function,
  }) {
    Log.showInfo(TAG, `registerListener, listener: ${listener}`);
    this.mListener = listener;
  }

  getServiceState() {
    Log.showDebug(TAG, `getServiceState`);
    geolocation.isLocationEnabled().then((data) => {
      Log.showInfo(TAG, `getServiceState isLocationEnabled, data: ${JSON.stringify(data)}`);
      this.mListener?.updateServiceState(data);
    });
  }

  enableLocation() {
    Log.showInfo(TAG, `enableLocation`);
    geolocation.enableLocation()
      .then((res) => Log.showInfo(TAG, `enableLocation, result: ${JSON.stringify(res)}`));
  }

  disableLocation() {
    Log.showInfo(TAG, `disableLocation`);
    geolocation.disableLocation()
      .then((res) => Log.showInfo(TAG, `disableLocation, result: ${JSON.stringify(res)}`));
  }
}

let sLocationService = createOrGet(LocationService, TAG);

export default sLocationService as LocationService;
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

import geolocation from '@ohos.geolocation';
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets';

const TAG = 'LocationModel';

export class LocationService {
  mIsStart: boolean = false;
  mListener: any;
  mLocationEventListener = geolocation?. LocationEventListener ? new (geolocation?.LocationEventListener)() :
    {
      on: (...args) => {
      },
      off: (...args) => {
      }
    };

  startService() {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `startService`)
    Log.showInfo(TAG, `LocationEventListener = ` + geolocation.LocationEventListener)
    this.mIsStart = true;
    this.getServiceState();
    this.mLocationEventListener.on('locationServiceState', (state) => {
      Log.showInfo(TAG, `startService locationChange, state: ${JSON.stringify(state)}`)
      this.mListener?.updateServiceState(state);
    });
  }

  stopService() {
    if (!this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `stopService`)
    this.mIsStart = false;
    this.mLocationEventListener.off('locationServiceState', (state) => {
      Log.showInfo(TAG, `stopService locationChange, state: ${JSON.stringify(state)}`)
    });
  }

  registerListener(listener: {
    'updateServiceState': Function,
  }) {
    Log.showInfo(TAG, `registerListener, listener: ${listener}`)
    this.mListener = listener;
  }

  getServiceState() {
    Log.showInfo(TAG, `getServiceState`)
    geolocation.isLocationEnabled().then((data) => {
      Log.showInfo(TAG, `getServiceState isLocationEnabled, data: ${JSON.stringify(data)}`)
      this.mListener?.updateServiceState(data);
    });
  }

  enableLocation() {
    Log.showInfo(TAG, `enableLocation`)
    geolocation.enableLocation()
      .then((res) => Log.showInfo(TAG, `enableLocation, result: ${JSON.stringify(res)}`));
  }

  disableLocation() {
    Log.showInfo(TAG, `disableLocation`)
    geolocation.disableLocation()
      .then((res) => Log.showInfo(TAG, `disableLocation, result: ${JSON.stringify(res)}`));
  }
}

let locationService = new LocationService();

export default locationService as LocationService;
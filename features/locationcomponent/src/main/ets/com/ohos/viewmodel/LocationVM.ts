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

import Log from '../../../../../../../../common/src/main/ets/default/Log';
import {FASlotName} from '../../../../../../../../common/src/main/ets/default/Constants';
import {TintContentInfo, getOrCreateTintContentInfo} from '../../../../../../../../common/src/main/ets/default/TintStateManager';
import createOrGet from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import {LocationData} from '../common/Constants';
import LocationService from '../model/LocationService';

const TAG = 'LocationVM';

export class LocationVM {
  mIsStart: boolean = false;
  mLocationData: LocationData = {
    ...new LocationData()
  }
  mTintContentInfo: TintContentInfo = getOrCreateTintContentInfo(FASlotName.LOCATION);

  constructor() {
    Log.showInfo(TAG, `constructor`);
  }

  initViewModel() {
    if (this.mIsStart) {
      return;
    };
    Log.showInfo(TAG, `initViewModel `);
    this.mIsStart = true;
    this.mLocationData = AppStorage.SetAndLink(TAG + '_LocationData', this.mLocationData).get();
    LocationService.registerListener(this);
    LocationService.startService();
  }

  getLocationData(): LocationData {
    Log.showDebug(TAG, `getLocationData`);
    return this.mLocationData;
  }

  updateServiceState(state) {
    Log.showInfo(TAG, `updateServiceState, state: ${state} `);
    this.mLocationData.isEnabled = state;
  }

  enableLocation() {
    Log.showInfo(TAG, `enableLocation`);
    LocationService.enableLocation();
  }

  disableLocation() {
    Log.showInfo(TAG, `disableLocation`);
    LocationService.disableLocation();
  }

  getTintContentInfo(): TintContentInfo {
    return this.mTintContentInfo;
  }
}

let sLocationVM = createOrGet(LocationVM, TAG);

export default sLocationVM as LocationVM;
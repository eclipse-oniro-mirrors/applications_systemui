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
import LocationService from '../model/LocationService.ets';

export const LocationServiceOpenStatusKey = "LocationServiceOpenStatus";

const TAG = 'LocationVM';

export class LocationVM {
  mIsStart: boolean = false;

  initViewModel() {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `initViewModel `)
    this.mIsStart = true;
    LocationService.registerListener(this);
    LocationService.startService();
  }

  updateServiceState(state) {
    Log.showInfo(TAG, `updateServiceState, state: ${state} `)
    AppStorage.SetOrCreate(LocationServiceOpenStatusKey, state);
  }

  enableLocation() {
    Log.showInfo(TAG, `enableLocation`)
    LocationService.enableLocation();
  }

  disableLocation() {
    Log.showInfo(TAG, `disableLocation`)
    LocationService.disableLocation();
  }
}

let locationVM = new LocationVM();

export default locationVM as LocationVM;
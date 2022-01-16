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

import bluetooth from '@ohos.bluetooth';
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets';
import BluetoothService from '../model/BluetoothService.ets';

export const BluetoothOpenStatusKey = "BluetoothOpenStatus";

const TAG = 'BluetoothVM';

export class BluetoothVM {
  mIsStart: boolean = false;
  mBluetoothOpenStatus: any;

  initViewModel() {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `initViewModel `)
    this.mIsStart = true;
    this.mBluetoothOpenStatus = AppStorage.SetAndLink(BluetoothOpenStatusKey, false);
    BluetoothService.startService();
    BluetoothService.registerListener(this);
  }

  updateState(state: boolean) {
    Log.showInfo(TAG, `updateState, state: ${state} this.mBluetoothOpenStatus ${this.mBluetoothOpenStatus}`)
    this.mBluetoothOpenStatus.set(state);
  }

  enableBluetooth(): boolean{
    return BluetoothService.enableBluetooth();
  }

  disableBluetooth(): boolean{
    return BluetoothService.disableBluetooth();
  }
}

let bluetoothVM = new BluetoothVM();

export default bluetoothVM as BluetoothVM;
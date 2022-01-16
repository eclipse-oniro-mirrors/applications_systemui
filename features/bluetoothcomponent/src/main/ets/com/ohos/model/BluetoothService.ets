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

const TAG = 'BluetoothModel';

function isBluetoothOpen(state) {
  Log.showInfo(TAG, `state change: ${state}`)
  return state == bluetooth.BluetoothState.STATE_ON || state == bluetooth.BluetoothState.STATE_BLE_ON;
}

export class BluetoothService {
  mIsStart: boolean = false;
  mListener: any;
  mIsBluetoothOpen: boolean = false;

  startService() {
    if (this.mIsStart) {
      return;
    }
    this.mIsStart = true;
    this.mIsBluetoothOpen = isBluetoothOpen(bluetooth.getState());
    bluetooth.on('stateChange', (state) => {
      this.mIsBluetoothOpen = isBluetoothOpen(state);
      Log.showInfo(TAG, `state change: ${this.mIsBluetoothOpen}`)
      // todo !bluetooth bug, this.mListener?.updateState(this.mIsBluetoothOpen);
    });
    Log.showInfo(TAG, `startService, mIsBluetoothOpen: ${this.mIsBluetoothOpen}`)
  }

  stopService() {
    if (!this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `stopService`)
    this.mIsStart = false;
    bluetooth.off('stateChange');
  }

  registerListener(listener: {
    'updateState': Function
  }) {
    Log.showInfo(TAG, `registerListener, listener: ${listener}`)
    this.mListener = listener;
    this.mListener.updateState(this.mIsBluetoothOpen)
  }

  getState(): boolean {
    return this.mIsBluetoothOpen;
  }

  enableBluetooth(): boolean{
    Log.showInfo(TAG, `enableBluetooth`)
    let result = bluetooth.enableBluetooth();
    Log.showInfo(TAG, `enableBluetooth, result: ${result}`)
    return result;
  }

  disableBluetooth(): boolean{
    Log.showInfo(TAG, `disableBluetooth`)
    let result = bluetooth.disableBluetooth();
    Log.showInfo(TAG, `disableBluetooth, result: ${result}`)
    return result;
  }
}

let bluetoothService = new BluetoothService();

export default bluetoothService as BluetoothService;
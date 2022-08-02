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

import nfcController from '@ohos.nfc.controller';
import { BusinessError } from 'basic';
import Log from '../../../../../../../../common/src/main/ets/default/Log';
import createOrGet from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import { NFCMode } from '../common/Constants';

const TAG = 'NFCModel';

export interface NFCModeStatusListener {
  updateNFCMode(status: NFCMode): void;
}

export class NFCModeService {
  mIsStart = false;
  mListeners = new Set<NFCModeStatusListener>();
  mNFCManager: any;

  startService(): void {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, 'startService');
    this.mIsStart = true;

    this.mNFCManager = nfcController

    this.getNFCMode();

    this.mNFCManager.on('nfcStateChange', (data: NFCMode) => {
      Log.showInfo(TAG, `startService->nfcStateChange, data: ${JSON.stringify(data)}`);
      this.mListeners.forEach(listener => listener.updateNFCMode(data));
    });
  }

  stopService(): void {
    if (!this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, 'stopService');
    this.mIsStart = false;

    this.mNFCManager = null;
  }

  registerListener(listener: NFCModeStatusListener): void {
    let res = this.mListeners.add(listener);
    Log.showInfo(TAG, `registser nfcMode Listener ${res}`);
  }

  unregisterListener(listener: NFCModeStatusListener): void {
    let res = this.mListeners.delete(listener);
    Log.showInfo(TAG, `unregistser nfcMode Listener ${res}`);
  }

  getNFCMode(): void {
       let action = this.mNFCManager.getNfcState();
       Log.showInfo(TAG, `getNFCMode${action}`);
      this.mListeners.forEach(listener => listener.updateNFCMode(action));
  }

  setNFCMode(mode: NFCMode): void {
    Log.showInfo(TAG, `setNFCMode, mode: ${JSON.stringify(mode)}`);
    switch (mode) {
      case NFCMode.NFC_MODE_OFF:
        this.mNFCManager.openNfc();
        Log.showInfo(TAG, `openNFC`);
        break;
      case NFCMode.NFC_MODE_ON:
        this.mNFCManager.closeNfc();
        Log.showInfo(TAG, `closeNFC`);
        break;
      default:
        break;
    }
  }
}

let sNFCModeService = createOrGet(NFCModeService, TAG);

export default sNFCModeService;
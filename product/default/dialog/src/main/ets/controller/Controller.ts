/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import window from '@ohos.window';
import rpc from '@ohos.rpc';
import Log from '../../../../../../../common/src/main/ets/default/Log';

const TAG = 'Dialog-ServiceExtensionAbility';

export interface IDialogParameters {
  bundleName?: string,
  abilityName?: string,
  parameters?: { [key: string]: any },
}

interface ISystemDialogData {
  windowName: string,
  parameters: IDialogParameters,
  remoteObject?: rpc.RemoteObject
}

class SystemDialogController {
  count: number = 0;
  private data: Map<string, ISystemDialogData> = new Map();
  private context;

  constructor(context) {
    this.context = context;
    Log.showInfo(TAG, `SystemDialogController constructor ${this.context}`);
  }

  getContext() {
    return this.context;
  }

  getData() {
    return this.data;
  }

  getRemoteObject(key: string) {
    Log.showInfo(TAG, `getRemoteObject start ${key}`);
    const { remoteObject } = this.data.get(key);

    Log.showDebug(TAG, `getRemoteObject end ${remoteObject}`);
    return remoteObject;
  }

  clearRemoteObject(key: string) {
    Log.showInfo(TAG, `clearRemoteObject start ${key}`);

    const current = this.data.get(key);
    if (current) {
      current.remoteObject = undefined;
    }

    Log.showDebug(TAG, `clearRemoteObject end ${key}`);
  }

  addDataByKey(key: string, v: ISystemDialogData) {
    Log.showInfo(TAG, `Controller-addDataByKey start ${key} ${v}`);
    if (this.data.get(key)) {
      Object.assign(this.data.get(key), v);
    } else {
      this.data.set(key, v);
    }
    Log.showDebug(TAG, `Controller-addDataByKey end ${key}`);
  }

  destroyWindow(key: string, needClear: boolean = true) {
    const current = this.data.get(key);

    if (!current) {
      Log.showInfo(TAG, `destroyWindow fail. key:${key} not exist`);
      return;
    }

    const { windowName } = current;
    Log.showInfo(TAG, `destroyWindow start ${key} ${windowName}`);

    if (windowName) {
      try {
        const win = window.findWindow(windowName);
        win.destroyWindow().then(() => {
          Log.showInfo(TAG, `destroyWindow ${key} ${windowName} succeed`);
        })
      } catch (e) {
        Log.showError(TAG, `destroyWindow ${key} ${windowName} failed, ${JSON.stringify(e)}`);
      }
    }

    if (!needClear) {
      Log.showDebug(TAG, `destroyWindow end. not need clear. ${key} ${windowName}`);
      return;
    }

    this.clearRemoteObject(key);

    this.data.delete(key);

    if (this.data.size === 0) {
      this.clear();
    }

    Log.showDebug(TAG, `destroyWindow end ${key} ${windowName}`);
  }

  destroyAllWindow() {
    Log.showInfo(TAG, `destroyAllWindow start ${this.data.size}`);
    [...this.data.keys()].forEach(key => {
      Log.showInfo(TAG, `destroyAllWindow forEach ${key}`);
      this.destroyWindow(key);
    })
    Log.showDebug(TAG, `destroyAllWindow end`);
  }

  clear() {
    Log.showInfo(TAG, `clear start`);
    this.data.clear();
    this.context?.terminateSelf();
    this.context = null;
    Log.showDebug(TAG, `clear end`);
  }
}

export default SystemDialogController;

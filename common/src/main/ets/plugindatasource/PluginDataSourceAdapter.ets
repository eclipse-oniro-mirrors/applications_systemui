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

import Log from '../default/Log.ets';
import worker from '@ohos.worker';
import Constants, {obtainMsg} from './common/Constants.ets';

const TAG = 'PluginDataSourceAdapter';
const WORKER_JS_URL = 'workers/PluginDataSourceWorker.js';

export default class PluginDataSourceAdapter {
  mWorker: any;
  mName: any;
  mListener: any;

  constructor(name: String) {
    Log.showInfo(TAG, `constructor, name: ${name}`)
    this.mName = name;
    this.mWorker = new worker.Worker(WORKER_JS_URL, {
      type: "classic", name: this.mName
    });

    this.mWorker.onmessage = this.onMessage.bind(this);
    this.mWorker.onmessageerror = this.onMessageError.bind(this);
    this.mWorker.onexit = this.onExit.bind(this);
    this.mWorker.onerror = this.onError.bind(this);
  }

  initDataSource(configs) {
    Log.showInfo(TAG, `initDataSource, configs: ${JSON.stringify(configs)}`)
    this.mWorker.postMessage(obtainMsg(Constants.INIT_CONFIG, configs));
  }

  loadData(userId) {
    Log.showInfo(TAG, `loadData`)
    this.mWorker.postMessage(obtainMsg(Constants.LOAD_DATA, userId));
  }

  clearAll() {
    Log.showInfo(TAG, `clearAll`)
    this.mWorker.postMessage(obtainMsg(Constants.CLEAR_ALL, {}));
  }

  onMessage(msg) {
    Log.showInfo(TAG, `onMessage, msg: ${JSON.stringify(msg)}`)
    let data = msg.data;
    switch (data.action) {
      case Constants.INIT_FINISH:
        this.onInitFinish();
        break;
      case Constants.ADD_ITEM:
        this.onItemAdd(data.data);
        break;
      case Constants.REMOVE_ITEM:
        this.onItemRemove(data.data);
        break;
      default:
        Log.showError(TAG, `unknown type: ${JSON.stringify(msg)}`)
    }
  }

  onInitFinish() {
    Log.showInfo(TAG, `onInitFinish`)
    this.mListener.initFinish();
  }

  onItemAdd(itemData) {
    Log.showInfo(TAG, `onItemAdd, itemData: ${JSON.stringify(itemData)}`)
    this.mListener.addItem(itemData);
  }

  onItemRemove(itemData) {
    Log.showInfo(TAG, `onItemRemove, itemData: ${JSON.stringify(itemData)}`)
    this.mListener.removeItem(itemData);
  }

  registerListener(listener: {
    'initFinish': Function,
    'addItem': Function,
    'removeItem': Function
  }) {
    Log.showInfo(TAG, `registerListener`)
    this.mListener = listener;
  }

  unregisterListener() {
    Log.showInfo(TAG, `mListener`)
    this.mListener = null;
  }

  onMessageError(event) {
    Log.showInfo(TAG, `mWorker.onmessageerror, event: ${event}`)
  };

  onExit(code) {
    Log.showInfo(TAG, `mWorker.onexit, code: ${code}`)
  };

  onError(err) {
    Log.showInfo(TAG, `mWorker.onerror, err: ${JSON.stringify(err)}`)
  };
}

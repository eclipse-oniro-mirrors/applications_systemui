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
import SourceLoaderFactory from './sourceloader/SourceLoaderFactory.ets';
import SourceLoader from './sourceloader/SourceLoader.ets';

const TAG = "PluginDataSourceManager";

export default class PluginDataSourceManager {
  mLoaders: Map<String, SourceLoader> = new Map();

  initDataSource(configs) {
    Log.showInfo(TAG, `initDataSource, configs: ${JSON.stringify(configs)}`);
    let factory = new SourceLoaderFactory({
      'add': this.onItemAdd.bind(this),
      'remove': this.onItemRemove.bind(this)
    });
    for (let pluginType in configs) {
      factory.getSourceLoader(pluginType, configs[pluginType], (sourceLoader) => {
        Log.showInfo(TAG, `getSourceLoader callback`);
        if (sourceLoader instanceof SourceLoader) {
          this.mLoaders.set(pluginType, sourceLoader);
          Log.showInfo(TAG, `getSourceLoader callback, plugin: ${pluginType} ${this.mLoaders.get(pluginType)}`);
        }
      })
    }
  }

  onItemAdd(itemData) {
    Log.showInfo(TAG, `onItemAdd, itemData: ${JSON.stringify(itemData)}`);
  }

  onItemRemove(itemData) {
    Log.showInfo(TAG, `onItemRemove, itemData: ${JSON.stringify(itemData)}`);
  }

  clearAll() {
    Log.showInfo(TAG, `clearAll`);
    this.mLoaders.forEach((sourceLoader) => sourceLoader.stopLoad());
    this.mLoaders.clear();
  }

  loadData() {
    Log.showInfo(TAG, `loadData`);
    this.mLoaders.forEach((sourceLoader) => {
      sourceLoader.loadData();
    });
  }
}
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

import Log from '../../default/Log.ets';
import DataAbilitySourceLoader from './DataAbilitySourceLoader.ets'
import MetaSourceLoader from './MetaSourceLoader.ets'
import PluginSourceLoader from './PluginSourceLoader.ets'

const TAG = "SourceLoaderFactory";

const classMap = new Map([
  ["MetaSource", MetaSourceLoader],
  ["PluginSourceLoader", PluginSourceLoader],
  ["DataAbilitySourceLoader", DataAbilitySourceLoader]
]);

export default class SourceLoaderFactory {
  mChannel: any;

  constructor(channel: {
    add: Function,
    remove: Function
  }) {
    Log.showInfo(TAG, `constructor, channel: ${channel}`)
    this.mChannel = channel;
  }

  getSourceLoader(pluginType, config, callback) {
    Log.showInfo(TAG, `getSourceLoader, pluginType: ${pluginType} config: ${JSON.stringify(config)}`)
    if (!classMap.has(pluginType)) {
      return;
    }
    callback(new (classMap.get(pluginType))(config, this.mChannel));
  }
}
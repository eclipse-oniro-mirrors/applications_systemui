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
import SourceLoader from './SourceLoader.ets';

const TAG = "PluginSourceLoader";

export default class PluginSourceLoader extends SourceLoader {
  constructor(config, channel) {
    super(channel);
    this.initSourceLoader(config);
  }

  initSourceLoader(config) {
    Log.showInfo(TAG, `init loader, config: ${JSON.stringify(config)}`)
    // todo 配置解析, config格式配置
    // todo 启动监听，数据转换为ItemComponentData，通过addItem/removewItem传输
  }

  stopLoad() {
    // todo 停止监听，清除数据
  }

  loadData() {
    // todo 重新获取一次数据
  }
}
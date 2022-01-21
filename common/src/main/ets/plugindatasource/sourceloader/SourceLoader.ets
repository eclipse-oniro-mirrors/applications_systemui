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
import {ItemComponentData} from '../common/Constants.ets';

const TAG = "SourceLoader";

export default abstract class SourceLoader {
  mChannel: any;

  constructor(channel) {
    Log.showInfo(TAG, `constructor, channel: ${channel}`)
    this.mChannel = channel;
  }

  abstract stopLoad(): void;

  abstract loadData(userId): void;

  addItem(itemData: ItemComponentData) {
    Log.showInfo(TAG, `addItem, itemData: ${JSON.stringify(itemData)}`)
    this.mChannel.add(itemData);
  }

  removeItem(itemData:ItemComponentData) {
    Log.showInfo(TAG, `remove, itemData: ${JSON.stringify(itemData)}`)
    this.mChannel.remove(itemData);
  }
}
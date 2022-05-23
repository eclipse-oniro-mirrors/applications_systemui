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

import Log from '../../../../../../common/src/main/ets/default/Log';
import {getAudioManager}from '../../../../../../common/src/main/ets/default/SingleInstanceHelper';

const SYSTEMUI_AUDIOVOLUMETYPE_MEDIA = 'settings.audio.media'
let TAG = 'Control-VolumeModel';
var mVolumeValue = AppStorage.SetAndLink('VolumeValue', 5);

export class VolumeModel {
  helper: any
  uri: string

  init(): void{
  }

  registerVolume() {
  }

  unRegisterVolume() {
  }

  setVolume(callback) {
    let value = parseInt(callback.value);
    Log.showInfo(TAG, `setVolume ${value}`);
    mVolumeValue.set(value);
  }

  getVolume() {
    Log.showInfo(TAG, 'getVolume');
  }

  getMaxVolume(callback, volumeType) {
    Log.showInfo(TAG, `getMaxVolume volumeType：${volumeType} `);
  }

  getMinVolume(callback, volumeType) {
    Log.showInfo(TAG, `getMaxVolume volumeType：${volumeType} `);
  }
}

let mVolumeModel = new VolumeModel();

export default mVolumeModel as VolumeModel;
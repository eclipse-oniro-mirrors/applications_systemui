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

import audio from '@ohos.multimedia.audio';
import Log from '../../../../../../common/src/main/ets/default/Log.ets';
import settings from '@ohos.settings';
import featureAbility from '@ohos.ability.featureAbility';

const SYSTEMUI_AUDIOVOLUMETYPE_MEDIA = 'settings.audio.media'
let TAG = 'Control-VolumeModel';
var mVolumeValue = AppStorage.SetAndLink('VolumeValue', 5);

export class VolumeModel {
    helper: any
    uri: string

    init(): void{
        Log.showInfo(TAG, 'init');
        this.uri = settings.getUriSync(SYSTEMUI_AUDIOVOLUMETYPE_MEDIA);
        Log.showInfo(TAG, 'settings geturi of audio.AudioVolumeType.MEDIA is ' + this.uri);
        this.helper = featureAbility.acquireDataAbilityHelper(this.uri);
        this.getVolume();
    }

    registerVolume() {
        this.helper.on("dataChange", this.uri, (err) => {
            let data = settings.getValueSync(this.helper, SYSTEMUI_AUDIOVOLUMETYPE_MEDIA, '5')
            Log.showInfo(TAG, `after audio.AudioVolumeType.MEDIA datachange settings getValue ${parseInt(data)}`);
            mVolumeValue.set(parseInt(data));
        })
    }

    unRegisterVolume() {
        this.helper.off("dataChange", this.uri, (err) => {
            Log.showInfo(TAG, `unregister audio.AudioVolumeType.MEDIA helper`);
        })
    }

    setVolume(callback){
        Log.showInfo(TAG, 'setVolume');
        let value = parseInt(callback.value);
        Log.showInfo(TAG, `setVolume ${value}`);
        mVolumeValue.set(value);
        Log.showInfo(TAG, `mVolumeValue setVolume ${value} end`);
        settings.setValueSync(this.helper, SYSTEMUI_AUDIOVOLUMETYPE_MEDIA, callback.value.toString());
        Log.showInfo(TAG, `settings setVolume ${callback.value} end`);
    }

    getVolume() {
        Log.showInfo(TAG, 'getVolume');
        let data = settings.getValueSync(this.helper, SYSTEMUI_AUDIOVOLUMETYPE_MEDIA, '5');
        Log.showInfo(TAG, `settings getVolume ${parseInt(data)}`);
        mVolumeValue.set(parseInt(data));
    }

    getMaxVolume(callback, volumeType) {
        Log.showInfo(TAG, `getMaxVolume volumeType：${volumeType} `);
        audio.getAudioManager().getMaxVolume(volumeType, (err, value) => {
            if (err) {
                Log.showInfo(TAG, `Failed to obtain the volume. ${err.message}`);
                return;
            }
            Log.showInfo(TAG, 'getMaxVolume Callback invoked to indicate that the volume is obtained.' + value);
            callback.maxValue = value;
        })
    }

    getMinVolume(callback, volumeType) {
        Log.showInfo(TAG, `getMaxVolume volumeType：${volumeType} `);
        audio.getAudioManager().getMinVolume(volumeType, (err, value) => {
            if (err) {
                Log.showInfo(TAG, `Failed to obtain the volume. ${err.message}`);
                return;
            }
            Log.showInfo(TAG, 'getMinVolume Callback invoked to indicate that the volume is obtained.' + value);
            callback.minValue = value;
        })
    }
}

let mVolumeModel = new VolumeModel();

export default mVolumeModel as VolumeModel;
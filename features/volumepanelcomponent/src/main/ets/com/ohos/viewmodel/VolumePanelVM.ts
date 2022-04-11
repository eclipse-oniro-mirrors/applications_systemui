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

import Log from '../../../../../../../../common/src/main/ets/default/Log';
import Constants from '../common/Constants'
import {AudioVolumeType, VolumeInfo} from '../common/Constants';
import VolumePanelService from '../model/VolumePanelService';
import VolumeWindowController from '../common/VolumeWindowController';

export const VolumePanelMaxVolumeKey = "VolumePanelMaxVolume";

export const VolumePanelMinVolumeKey = "VolumePanelMinVolume";

export const VolumePanelVolumeValueKey = "VolumePanelVolumeValue";

export const VolumePanelIsMuteKey = "VolumePanelIsMute";

const TAG = 'VolumePanelVM';

export class VolumePanelVM {
  mIsStart: boolean = false;
  mMaxVolume: any;
  mMinVolume: any;
  mVolumeValue: any;
  mIsMute: any;
  mAllVolumeTypes = [AudioVolumeType.VOICE_CALL, AudioVolumeType.RINGTONE, AudioVolumeType.MEDIA];
  mVolumeBaseMap = {};
  mCurrentAudioVolumeType: number = AudioVolumeType.MEDIA;
  mCurrentAudioVolume: number;
  mUpdatingAudioVolume: number;
  mVolumeBeforeMute: number;

  constructor() {
    Log.showInfo(TAG, `constructor`)
  }

  initViewModel() {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `initViewModel `)
    this.mIsStart = true;

    this.mMaxVolume = AppStorage.SetAndLink(VolumePanelMaxVolumeKey, Constants.DEFAULT_MAX_VOLUME);
    this.mMinVolume = AppStorage.SetAndLink(VolumePanelMinVolumeKey, Constants.DEFAULT_MIN_VOLUME);
    this.mVolumeValue = AppStorage.SetAndLink(VolumePanelVolumeValueKey, Constants.DEFAULT_MIN_VOLUME);
    this.mIsMute = AppStorage.SetAndLink(VolumePanelIsMuteKey, Constants.DEFAULT_MUTE_STATUS);
    this.mAllVolumeTypes.forEach((volumeType: AudioVolumeType) => {
      this.mVolumeBaseMap[volumeType] = {
        maxVolume: Constants.DEFAULT_MAX_VOLUME,
        minVolume: Constants.DEFAULT_MIN_VOLUME
      };
    });
    VolumePanelService.startService();
    VolumePanelService.registerListener(this);
    this.mAllVolumeTypes.forEach((volumeType: AudioVolumeType) => {
      VolumePanelService.getMaxVolume(volumeType, (volumeType, value) => this.updateMaxVolume(volumeType, value));
      VolumePanelService.getMinVolume(volumeType, (volumeType, value) => this.updateMinVolume(volumeType, value));
    });
    this.getInitVolumeInfo();
  }

  getInitVolumeInfo() {
    Log.showInfo(TAG, `getInitVolumeInfo`)
    this.getActiveVolumeType(JSON.parse(JSON.stringify(this.mAllVolumeTypes)), (activeVolumeType: AudioVolumeType) => {
      Log.showInfo(TAG, `getInitVolumeInfo, activeVolumeType: ${activeVolumeType}`)
      if (activeVolumeType == undefined) {
        activeVolumeType = AudioVolumeType.MEDIA;
      }
      this.mCurrentAudioVolumeType = activeVolumeType;
      VolumePanelService.getVolumeInfo(activeVolumeType);
    });
  }

  getActiveVolumeType(volumeTypes: number[], callback: Function) {
    Log.showInfo(TAG, `getActiveVolumeType, volumeTypes: ${JSON.stringify(volumeTypes)}`)
    if (volumeTypes.length == 0) {
      callback(undefined);
      return;
    }
    VolumePanelService.isActive(volumeTypes[0], (volumeType: AudioVolumeType, data: boolean) => {
      Log.showInfo(TAG, `getActiveVolumeType, volumeType: ${volumeType} data: ${data}`)
      if (data) {
        callback(volumeType);
      } else {
        volumeTypes.splice(0, 1);
        this.getActiveVolumeType(volumeTypes, callback);
      }
    });
  }

  updateMaxVolume(volumeType: AudioVolumeType, value: number) {
    Log.showInfo(TAG, `updateMaxVolume, volumeType: ${volumeType} value: ${value}`)
    this.mVolumeBaseMap[volumeType].maxVolume = value;
    Log.showInfo(TAG, `updateMaxVolume, mVolumeBaseMap: ${JSON.stringify(this.mVolumeBaseMap)}`)
  }

  updateMinVolume(volumeType: AudioVolumeType, value: number) {
    Log.showInfo(TAG, `updateMinVolume, volumeType: ${volumeType} value: ${value}`)
    this.mVolumeBaseMap[volumeType].minVolume = value;
    Log.showInfo(TAG, `updateMinVolume, mVolumeBaseMap: ${JSON.stringify(this.mVolumeBaseMap)}`)
  }

  updateVolumeInfo(volumeInfo: VolumeInfo) {
    Log.showInfo(TAG, `updateVolumeInfo, volumeInfo: ${JSON.stringify(volumeInfo)} `)
    Log.showInfo(TAG, `updateVolumeInfo, mCurrentAudioVolumeType: ${this.mCurrentAudioVolumeType} `)
    if (!volumeInfo.updateUi && volumeInfo.volumeType != this.mCurrentAudioVolumeType) {
      return;
    }
    let volumeType = volumeInfo.volumeType;
    let maxVolume = this.mVolumeBaseMap[volumeType].maxVolume;
    let minVolume = this.mVolumeBaseMap[volumeType].minVolume;
    this.mMaxVolume.set(maxVolume);
    this.mMinVolume.set(minVolume);
    Log.showInfo(TAG, `updateVolumeInfo, mMaxVolume: ${this.mMaxVolume.get()} `)
    Log.showInfo(TAG, `updateVolumeInfo, mMinVolume: ${this.mMinVolume.get()} `)

    this.mCurrentAudioVolume = volumeInfo.volume;
    this.mCurrentAudioVolumeType = volumeType;
    Log.showInfo(TAG, `updateVolumeInfo, mCurrentAudioVolume: ${this.mCurrentAudioVolume} `)
    Log.showInfo(TAG, `updateVolumeInfo, mCurrentAudioVolumeType: ${this.mCurrentAudioVolumeType} `)

    this.mVolumeBeforeMute = minVolume;
    this.mIsMute.set(volumeInfo.isMute);
    Log.showInfo(TAG, `updateVolumeInfo, mIsMute: ${this.mIsMute.get()} `)

    this.updateDisplayVolume(volumeInfo.isMute ? minVolume : volumeInfo.volume, maxVolume, minVolume);
  }

  updateDisplayVolume(volume: number, maxVolume: number, minVolume: number): void{
    Log.showInfo(TAG, `updateDisplayVolume, volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`)
    let displayVolume: number = maxVolume - volume + minVolume;
    this.mVolumeValue.set(displayVolume);
    Log.showInfo(TAG, `updateDisplayVolume, mVolumeValue: ${this.mVolumeValue.get()}`)
  }

  calcVolumeByDisplayVolume(displayVolume: number): number{
    Log.showInfo(TAG, `calcVolumeByDisplayVolume, displayVolume: ${displayVolume}`)
    let volume: number = this.mMaxVolume.get() - displayVolume + this.mMinVolume.get();
    Log.showInfo(TAG, `calcVolumeByDisplayVolume, volume: ${volume}`)
    return volume;
  }

  setVolume(displayVolume: number) {
    Log.showInfo(TAG, `setVolume, displayVolume: ${displayVolume} `)
    let volume: number = this.calcVolumeByDisplayVolume(displayVolume);
    if (this.mUpdatingAudioVolume != undefined && volume == this.mUpdatingAudioVolume) {
      return;
    }
    this.mUpdatingAudioVolume = volume;
    let isMute = volume == this.mMinVolume.get();
    if (isMute == this.mIsMute.get()) {
      isMute = undefined;
    }
    VolumePanelService.setVolumeAndMute(this.mCurrentAudioVolumeType, volume, isMute);
    VolumeWindowController.getInstance().updateVolumeInfo(null);
  }

  mute() {
    Log.showInfo(TAG, `mute, isMute: ${this.mIsMute.get()} mCurrentAudioVolume: ${this.mCurrentAudioVolume}`)
    this.mUpdatingAudioVolume = undefined;
    let isMute = this.mIsMute.get();
    isMute = !isMute;
    let maxVolume: number = this.mMaxVolume.get();
    let minVolume: number = this.mMinVolume.get();
    let volume = isMute ? minVolume : (minVolume == this.mVolumeBeforeMute ? (minVolume + 1) : this.mVolumeBeforeMute);
    let currentAudioVolume = this.mCurrentAudioVolume;
    let volumeType = this.mCurrentAudioVolumeType;
    VolumePanelService.setVolumeAndMute(volumeType, volume, isMute, () => {
      Log.showInfo(TAG, `mute, setVolumeAndMute callback`)
      if (volumeType == this.mCurrentAudioVolumeType && this.mIsMute.get()) {
        this.mVolumeBeforeMute = currentAudioVolume;
      }
    });
    VolumeWindowController.getInstance().updateVolumeInfo(null);
  }
}

let volumePanelVM = new VolumePanelVM();

export default volumePanelVM as VolumePanelVM;
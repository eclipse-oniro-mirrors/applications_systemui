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

import CapsuleModel from '../model/CapsuleModel.ets'
import FeatureAbility from '@ohos.ability.featureAbility';
import Log from '../../../../../../../common/src/main/ets/default/Log.ets'
import Rsm from '@ohos.resourceManager';

let sCapsuleViewModel;

const SEC_VAL = 1000;
const MIN_VAL = 60 * SEC_VAL;
const TAG = "CapsuleViewModel";

function fixInteger(num) {
  return (num >= 10) ? String(num) : '0' + num;
}

function parseTime(num) {
  return fixInteger(Math.floor(num / MIN_VAL)) + ":" + fixInteger(Math.floor((num % MIN_VAL) / SEC_VAL);
}

export const VIEW_MODEL_ID = "CapsuleViewModelVm";

export enum CallState {
  CALL_ACTIVE, //通话中*
  CALL_HOLDING, //通话保持
  CALL_DIALING, //拨号开始
  CALL_ALERTING, //正在呼出
  CALL_INCOMING, //来电*
  CALL_WAITING, //第三方来电*
  CALL_DISCONNECTED, //挂断完成 *
  CALL_DISCONNECTING, //正在挂断
  CALL_IDLE //空闲
}

export default class CapsuleViewModel {
  mText: string = "00:00";
  mStartTime: number = 0;
  mCallState: CallState = CallState.CALL_DISCONNECTED;
  mIsBackground: boolean = false;
  mWantBundleName: string = "";
  mWantAbilityName: string = "";
  mTimeMeter: any;
  mCallback: any;

  initViewModel() {
    this.mCallback = {
      "onStateChange": this.onStateChange.bind(this)
    }
    CapsuleModel.registerCallback(this.mCallback);
  }

  onStateChange(data) {
    Log.showInfo(TAG, `onStateChange, data: ${JSON.stringify(data)}`);
    this.mIsBackground = data.isBackground;
    this.mWantBundleName = data.wantBundleName;
    this.mWantAbilityName = data.wantAbilityName;
    if (data.callState == CallState.CALL_INCOMING || data.callState == CallState.CALL_WAITING) {
      this.mStartTime = 0;
      let id = JSON.parse(JSON.stringify($r("app.string.incoming_call"))).id;
      let resourceMgr = Rsm.getResourceManager('com.ohos.systemui');
      resourceMgr.then((result) => {
        result.getString(id).then((resource) => {
          this.mText = resource;
          Log.showInfo(TAG, 'getStringById resource : ' + resource);
        })
          .catch((err) => {
            Log.showInfo(TAG, 'getStringById err : ' + JSON.stringify(err));
          });
      });
    } else if (data.callState == CallState.CALL_ACTIVE) {
      clearTimeout(this.mTimeMeter);
      if (this.mCallState != CallState.CALL_ACTIVE) {
        this.mStartTime = new Date().valueOf();
      }
      this.mCallState = data.callState;

      let startTime;
      let commonTimeDiff = new Date().valueOf() - data.startTime;
      let localTimeDiff = new Date().valueOf() - this.mStartTime;
      if (commonTimeDiff < 0) {
        if (localTimeDiff < 0) {
          startTime = new Date().valueOf();
        } else {
          startTime = this.mStartTime;
        }
      } else {
        startTime = data.startTime;
      }

      this.startUpdateTime(startTime);
    } else if (data.callState == CallState.CALL_DISCONNECTED){
      clearTimeout(this.mTimeMeter);
      this.mStartTime = 0;
      this.mIsBackground = false;
      this.mText = "";
      Log.showInfo(TAG, `cannot show`);
    } else {
      this.mStartTime = 0;
      let id = JSON.parse(JSON.stringify($r("app.string.communicate_by_phone"))).id;
      let resourceMgr = Rsm.getResourceManager('com.ohos.systemui');
      resourceMgr.then((result) => {
        result.getString(id).then((resource) => {
          this.mText = resource;
          Log.showInfo(TAG, 'getStringById resource : ' + resource);
        })


          .catch((err) => {
            Log.showInfo(TAG, 'getStringById err : ' + JSON.stringify(err));
          });
      });
    }
    this.mCallState = data.callState;
  }

  startUpdateTime(startTime) {
    if (!this.mIsBackground || this.mCallState != CallState.CALL_ACTIVE) {
      return;
    }
    let val = new Date().valueOf() - startTime.valueOf();
    if (val < 0) {
      val = 0;
    }
    this.mText = parseTime(val);
    this.mTimeMeter = setTimeout(() => {
      this.startUpdateTime(startTime);
    }, 1000 - val % 1000);
  }

  onClickEvent() {
    if (this.mIsBackground) {
      this.mIsBackground = false;
    }
    Log.showInfo(TAG, `onClickEvent `);
    let result = FeatureAbility.startAbility({
      want: {
        bundleName: this.mWantBundleName,
        abilityName: this.mWantAbilityName
      }
    })
      .then(data =>
      Log.showInfo(TAG, `onClickEvent promise then: ${JSON.stringify(data)}`))
      .catch(error =>
      Log.showError(TAG, `onClickEvent promise catch: ${JSON.stringify(error)}`));
    Log.showInfo(TAG, `onClickEvent openAbility result: ${result}`);
  }

  static getInstance() {
    if (sCapsuleViewModel == null) {
      sCapsuleViewModel = new CapsuleViewModel();
      AppStorage.SetAndLink(VIEW_MODEL_ID, sCapsuleViewModel);
    }
    return sCapsuleViewModel;
  }
}
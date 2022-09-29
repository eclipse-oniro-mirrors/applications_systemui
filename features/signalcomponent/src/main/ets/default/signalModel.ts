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

import commonEvent from "@ohos.commonEvent";
import Radio from '@ohos.telephony.radio';
import Sim from '@ohos.telephony.sim';
import Observer from '@ohos.telephony.observer';
import Log from "../../../../../../common/src/main/ets/default/Log";
import Constants from './common/constants';

const TAG = 'SignalStatus-SignalModel';

let isInitObserver = false;
let commonEventData = null;

var mLevelLink;
var mTypeLink;
var mStateLink;

export class SignalModel {
  constructor() {
    mLevelLink = AppStorage.SetAndLink("cellularLevel", Constants.CELLULAR_NO_SIM_CARD);
    mTypeLink = AppStorage.SetAndLink("cellularType", Constants.RADIO_TECHNOLOGY_UNKNOWN);
    mStateLink = AppStorage.SetAndLink("networkState", Constants.NET_NULL);
    this.addSubscriberListener();
  }

  initSignalModel() {
    Log.showInfo(TAG, 'initSignalModel');
    this.checkCellularStatus();
  }

  /**
   * add mms app subscriber
   */
  async addSubscriberListener() {
    let events = [Constants.COMMON_EVENT_SPN_INFO_CHANGED];
    let commonEventSubscribeInfo = {
      events: events
    };
    commonEvent.createSubscriber(commonEventSubscribeInfo, this.createSubscriberCallBack.bind(this));
  }

  createSubscriberCallBack(err, data) {
    commonEventData = data;
    commonEvent.subscribe(commonEventData, this.subscriberCallBack.bind(this));
  }

  subscriberCallBack(err, data) {
    if (data.event === Constants.COMMON_EVENT_SPN_INFO_CHANGED) {
      if (data?.parameters?.CUR_PLMN) {
        Log.showInfo(TAG, `receive stateLink: ${data.parameters.CUR_PLMN}`);
        mStateLink.set(data.parameters.CUR_PLMN);
      } else {
        Log.showError(TAG, `get stateLink failed.`);
        mStateLink.set(Constants.NET_NULL);
      }
    }
  }

  uninitSignalModel() {
    Log.showInfo(TAG, 'uninitSignalModel');
    this.unInitObserver();
  }

  /**
     * Check the connection type and signal level of cellular network
     */
  checkCellularStatus() {
    let slotId = 0;
    Sim.hasSimCard(slotId, (err, value) => {
      if (value === true) {
        Radio.getNetworkState((err, value) => {
          if (err || !value) {
            mTypeLink.set(Constants.RADIO_TECHNOLOGY_UNKNOWN);
            mLevelLink.set(Constants.CELLULAR_NO_SIM_CARD);
          } else {
            // If there is no service, no signal is displayed.
            if (value.regState != Constants.REG_STATE_IN_SERVICE) {
              mTypeLink.set(Constants.RADIO_TECHNOLOGY_UNKNOWN);
              mLevelLink.set(Constants.CELLULAR_NO_SIM_CARD);
            } else {
              mTypeLink.set(value.cfgTech);
              Radio.getSignalInformation(slotId, (err, value) => {
                if (err || !value || !value.length) {
                  mLevelLink.set(Constants.CELLULAR_NO_SIM_CARD);
                } else {
                  mLevelLink.set(value[0].signalLevel);
                }
              });
            }
          }
        });
      } else {
        Log.showWarn(TAG, `hasSimCard failed to hasSimCard because`);
        mLevelLink.set(Constants.CELLULAR_NO_SIM_CARD);
        mTypeLink.set(Constants.RADIO_TECHNOLOGY_UNKNOWN);
        mStateLink.set(Constants.NET_NULL);
      }
      if (!isInitObserver) {
        this.initObserver();
      }
    });
  }

  /**
     * init the observer of the cellular and signal
     */
  initObserver() {
    Log.showInfo(TAG, 'initObserver');
    isInitObserver = true;
    Observer.on('signalInfoChange', (signalInfoChange) => {
      this.checkCellularStatus();
    });
    Observer.on('networkStateChange', (networkState) => {
      this.checkCellularStatus();
    });
    Observer.on('simStateChange', (simStateInfo) => {
      this.checkCellularStatus();
    });
  }

  /**
     * Uninit the observer of the cellular and signal
     */
  unInitObserver() {
    Log.showInfo(TAG, 'unInitObserver');
    Observer.off('signalInfoChange');
    Observer.off('networkStateChange');
    Observer.off('simStateChange');
    isInitObserver = false;
  }
}

let mSignalModel = new SignalModel();

export default mSignalModel as SignalModel;
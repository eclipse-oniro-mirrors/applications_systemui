/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import CommonEvent from '@ohos.commonEvent'
import connection from '@ohos.net.connection'
import { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import { CommonEventData } from 'commonEvent/commonEventData';

import createOrGet from '../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import type { AirplaneServiceListener } from '../common/Constants';
import { AIRPLANE_MODE_STATUS } from '../common/Constants';

const TAG = 'AirplaneModel';

const AIRPLANE_SUBSCRIBE_INFO = {
  events: [CommonEvent.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED]
};

class AirplaneService {
  mIsStart = false;
  mListener: AirplaneServiceListener;
  mSubscriber: CommonEventSubscriber;

  startService() {
    if (this.mIsStart) return;
    this.mIsStart = true;

    this.subscribe();
  }

  stopService() {
    if (!this.mIsStart) return;
    this.mIsStart = false;

    this.mListener = null;
    this.unsubscribe();
    this.unregisterListener();
  }

  async subscribe() {
    this.unsubscribe();

    this.mSubscriber = await CommonEvent.createSubscriber(AIRPLANE_SUBSCRIBE_INFO);
    CommonEvent.subscribe(this.mSubscriber, (err, data: CommonEventData) => {
      Log.showInfo(TAG, `subscribe cb -> err：${JSON.stringify(err || {})}  data：${JSON.stringify(data || {})}`);
      if (err && err.code !== 0) {
        Log.showInfo(TAG, `subscribe error ${JSON.stringify(err)}`);
        return;
      }
      if (data && data.event === CommonEvent.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED) {
        const status = String(data.code) === AIRPLANE_MODE_STATUS.ON;
        this.mListener?.updateState(status);
      }
    })
  }

  unsubscribe() {
    if (!this.mSubscriber) return;

    CommonEvent.unsubscribe(this.mSubscriber);
    this.mSubscriber = null;
  }

  registerListener(listener: AirplaneServiceListener) {
    this.mListener = listener;
  }

  unregisterListener() {
    this.mListener = null;
  }

  enableAirplaneMode() {
    Log.showInfo(TAG, 'open airplane');
    return connection.enableAirplaneMode();
  }

  disableAirplaneMode() {
    Log.showInfo(TAG, 'close airplane');
    return connection.disableAirplaneMode();
  }
}

const sAirplaneService = createOrGet(AirplaneService, TAG);

export default sAirplaneService;

/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { CommonEventSubscriber } from "commonEvent/commonEventSubscriber";
import createOrGet from "./SingleInstanceHelper";
import EventManager from "./event/EventManager";
import Log from "./Log";
import { obtainLocalEvent } from "./event/EventUtil";
import { debounce } from "./Decorators";
export const SCREEN_CHANGE_EVENT = "screenChangeEvent";

const TAG = "ScreenLockManager";
const SCREEN_COMMON_EVENT_INFO = {
  events: [commonEvent.Support.COMMON_EVENT_SCREEN_OFF, commonEvent.Support.COMMON_EVENT_SCREEN_ON],
};
const debounceTimeout = 500;

class ScreenLockManager {
  mSubscriber: CommonEventSubscriber | undefined;

  async init() {
    this.mSubscriber = await commonEvent.createSubscriber(SCREEN_COMMON_EVENT_INFO);
    commonEvent.subscribe(this.mSubscriber, (err, data) => {
      if (err.code != 0) {
        Log.showError(TAG, `Can't handle screen change, err: ${JSON.stringify(err)}`);
        return;
      }
      Log.showDebug(TAG, `screenChange, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
      switch (data.event) {
        case commonEvent.Support.COMMON_EVENT_SCREEN_OFF:
          this.notifyScreenEvent(false);
          break;
        case commonEvent.Support.COMMON_EVENT_SCREEN_ON:
          this.notifyScreenEvent(true);
          break;
        default:
          Log.showError(TAG, `unknow event`);
      }
    });
  }

  @debounce(debounceTimeout)
  notifyScreenEvent(isScreenOn: boolean) {
    EventManager.publish(obtainLocalEvent(SCREEN_CHANGE_EVENT, isScreenOn));
    Log.showDebug(TAG, `publish ${SCREEN_CHANGE_EVENT} screenState: ${isScreenOn}`);
  }
}

let sScreenLockManager = createOrGet(ScreenLockManager, TAG);
export default sScreenLockManager as ScreenLockManager;
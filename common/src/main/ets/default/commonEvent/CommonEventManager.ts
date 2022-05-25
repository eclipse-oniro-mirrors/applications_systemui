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
import { CommonEventData } from "commonEvent/commonEventData";
import EventManager from "../event/EventManager";
import Log from "../Log";
import { SCREEN_CHANGE_EVENT } from "../ScreenLockManager";

export type CommonEventManager = {
  subscriberCommonEvent: () => Promise<void>;
  unSubscriberCommonEvent: () => void;
  applyPolicy: (policys: Array<POLICY>) => void;
  release: () => void;
};

export enum POLICY {
  SCREEN_POLICY = "screenOnOffPolicy",
}

type ClearPolicy = () => void;
type InnerManager = { subscriberCommonEvent: () => void; unSubscriberCommonEvent: () => void };
const policyMap: { [key in POLICY]: (manager: InnerManager) => ClearPolicy } = {
  screenOnOffPolicy: ScreenPolicy,
};

export function getCommonEventManager(
  tag: string,
  subscribeInfos: { events: Array<string> },
  commonEventCallback: (data: CommonEventData) => void,
  subscribeStateChange?: (isSubscribe: boolean) => void
): CommonEventManager {
  const TAG = `CommonEvent_${tag}`;
  const SUBSCRIBE_INFOS = subscribeInfos;
  let unSubcribers: Array<() => void> = [];
  let policyClearCb: Map<POLICY, ClearPolicy> | undefined = undefined;

  async function subscriberCommonEvent() {
    Log.showDebug(TAG, "registerSubscriber start");
    let subscriber = await commonEvent.createSubscriber(SUBSCRIBE_INFOS);
    commonEvent.subscribe(subscriber, (err, data) => {
      if (err.code != 0) {
        Log.showError(TAG, `Can't handle common event, err: ${JSON.stringify(err)}`);
        return;
      }
      Log.showDebug(TAG, `handle common event: ${data.event}`);
      commonEventCallback(data);
    });
    unSubcribers.push(() => commonEvent.unsubscribe(subscriber));
    subscribeStateChange && subscribeStateChange(true);
    Log.showDebug(TAG, `registerSubscriber success, size: ${unSubcribers.length}`);
  }

  function unSubscriberCommonEvent() {
    Log.showDebug(TAG, `UnSubcribers size: ${unSubcribers.length}`);
    unSubcribers.forEach((unsubscribe) => unsubscribe());
    unSubcribers.length = 0;
    subscribeStateChange && subscribeStateChange(false);
  }

  function applyPolicy(policys: Array<POLICY>) {
    const innerManager = { subscriberCommonEvent, unSubscriberCommonEvent };
    policyClearCb = policyClearCb ?? new Map();
    policys.forEach((policy) => {
      if (policyClearCb) {
        !policyClearCb.has(policy) && policyClearCb.set(policy, policyMap[policy](innerManager));
        Log.showDebug(TAG, `apply policy: ${policy}`);
      }
    });
  }

  function release() {
    policyClearCb?.forEach((cb) => cb());
    policyClearCb?.clear();
    unSubscriberCommonEvent();
  }

  return { subscriberCommonEvent, unSubscriberCommonEvent, applyPolicy, release };
}

function ScreenPolicy(manager: InnerManager): ClearPolicy {
  return EventManager.subscribe(SCREEN_CHANGE_EVENT, (isScreenOn: boolean) => {
    isScreenOn ? manager.subscriberCommonEvent() : manager.unSubscriberCommonEvent();
  });
}

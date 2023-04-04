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

import ServiceExtensionContext from "application/ServiceExtensionContext";
import Log from "../Log";
import createOrGet from "../SingleInstanceHelper";
import { EventParser, START_ABILITY_EVENT, Event, LocalEvent } from "./EventUtil";
import { Callback, createEventBus, EventBus } from "./EventBus";
import { BusinessError } from 'basic';
import {PluginType} from "../../plugindatasource/common/Constants";
import {writeFaultLog, FaultID} from '../SysFaultLogger';

export type unsubscribe = () => void;
export type Events = string | string[];

const TAG = "EventManager";

class EventManager {
    mEventBus: EventBus<string>;
    eventParser: EventParser;
    mContext: ServiceExtensionContext | undefined;

    constructor() {
        this.mEventBus = createEventBus();
        this.eventParser = {
            local: this.publishLocalEvent,
            ability: this.startAbility,
            commonEvent: this.publishCommonEvent,
            remote: this.publishRemoteEvent,
        };
    }

    setContext(ctx: ServiceExtensionContext) {
        this.mContext = ctx;
    }

    publish(event: Event, pluginType?: PluginType): boolean {
        Log.showInfo(TAG, `PUBLISH : event: ${JSON.stringify(event)}`)
        return this.eventParser[event.target].call(this, event.data, pluginType);
    }

    subscribe(eventType: Events, callback: Callback): unsubscribe {
        return this.mEventBus.on(eventType, callback);
    }

    subscribeOnce(eventType: string, callback: Callback): unsubscribe {
        return this.mEventBus.once(eventType, callback);
    }

    private publishLocalEvent(data: LocalEvent): boolean {
        Log.showDebug(TAG, `publish localEvent type: ${data.eventName}`);
        if (data.eventName) {
            this.mEventBus.emit(data.eventName, data.args);
            return true;
        }
        return false;
    }

    private startAbility(data: { [key: string]: any }, pluginType?: PluginType): boolean {
        Log.showInfo(TAG, `start : data: ${JSON.stringify(data)}`)
        Log.showDebug(TAG, `start Ability: ${data.abilityName}`);
        if (data.bundleName && data.abilityName && this.mContext) {
            this.mEventBus.emit(START_ABILITY_EVENT, { abilityName: data.abilityName });
            this.mContext.startAbility({
                bundleName: data.bundleName,
                abilityName: data.abilityName,
                parameters: data.args??undefined
            }).then(() => {
                Log.showInfo(TAG, 'startAbility, then');
            }).catch((error: BusinessError) => {
                Log.showError(TAG, `startAbility, error: ${JSON.stringify(error)}`);
                if (pluginType == PluginType.META) {
                    writeFaultLog({CORE_SYSTEM: "com.ohos.systemui", TARGET_API:data.bundleName, FAULT_ID: FaultID.META_DIAGRAM_JUMP, MSG: "jump ability failure"})
                }
            });
            return true;
        }
        return false;
    }

    private publishRemoteEvent(data: { [key: string]: any }): boolean {
        // todo publish to remote device
        return false;
    }

    private publishCommonEvent(data: { [key: string]: any }): boolean {
        // todo publish commonEvent to other app
        return false;
    }
}

let sEventManager = createOrGet(EventManager, TAG);

export default sEventManager as EventManager;
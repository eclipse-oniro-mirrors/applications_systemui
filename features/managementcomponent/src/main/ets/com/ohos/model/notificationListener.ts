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
import Notification from '@ohos.notification';
import NotificationManager from '@ohos.notificationManager';
import NotificationSubscribe from '@ohos.notificationSubscribe';

const TAG = 'NotificationManagenment-NotificationListener';

interface EnableListener {
    bundle: string;
    onEnableChanged: { (value: boolean): void };
}

export interface BundleOption {
    bundle: string;
    uid?: number;
}

export class NotificationListener {
    private readonly listeners = new Set<EnableListener>();

    subscribeEnableChanged(): void {
        Log.showInfo(TAG, 'subscribeEnableChanged');
      NotificationSubscribe.subscribe({
            onEnabledNotificationChanged: this.handleEnabledNotificationChanged.bind(this)
        }, () => {
            Log.showInfo(TAG, 'subscribeEnableChanged finished');
        });
    }

    unsubscribeEnableChanged(): void {
        Log.showInfo(TAG, 'unsubscribeEnableChanged');
        this.unRegisterAll();
      NotificationSubscribe.unsubscribe({
            onEnabledNotificationChanged: this.handleEnabledNotificationChanged.bind(this)
        }, () => {
            Log.showInfo(TAG, 'unsubscribeEnableChanged finished');
        });
    }

    handleEnabledNotificationChanged(data: NotificationSubscribe.EnabledNotificationCallbackData): void {
        Log.showDebug(TAG, `handleEnabledNotificationChanged data:${JSON.stringify(data)} `);
        this.listeners.forEach((listener) => {
            if (listener.bundle == data.bundle) {
                listener.onEnableChanged(data.enable);
            } else {
                Log.showError(TAG, `handleEnabledNotificationChanged error`);
            }
        });
    }

    register(listener: EnableListener): void {
        this.listeners.add(listener);
        Log.showInfo(TAG, 'register finished');
    }

    unRegister(listener: EnableListener): void {
        this.listeners.delete(listener);
        Log.showInfo(TAG, 'unRegister finished');
    }

    unRegisterAll(): void {
        this.listeners.clear();
        Log.showInfo(TAG, 'unRegisterAll finished');
    }

    async isNotificationEnabled(bundleOption: BundleOption, callback?: (data) => void): Promise<boolean> {
        Log.showDebug(TAG, `isNotificationEnabled bundleOption:${JSON.stringify(bundleOption)} `);
        return new Promise((resolve, reject) => {
          NotificationManager.isNotificationEnabled(bundleOption, (err, data) => {
                Log.showInfo(TAG, `isNotificationEnabled callback data:${JSON.stringify(data)} err:${JSON.stringify(err)}`);
                if (!!data) {
                    if (callback) {
                        callback(data);
                    }
                    resolve(data);
                } else {
                    reject(err);
                }
            });
        });
    }

    enableNotification(bundleOption: BundleOption, data: boolean): void {
        Log.showDebug(TAG, `enableNotification bundleOption:${JSON.stringify(bundleOption)} data:${JSON.stringify(data)}`);
        let enableValue: boolean = data ? true : false;
        NotificationManager.setNotificationEnable(bundleOption, enableValue, (err, result) => {
            Log.showInfo(TAG, `enableNotification err:${JSON.stringify(err)} result:${JSON.stringify(result)}`);
        });
    }

    async isNotificationSlotEnabled(bundleOption: BundleOption, slotType: Notification.SlotType, callback?: (data) => void): Promise<boolean> {
        Log.showDebug(TAG, `isNotificationSlotEnabled bundleOption:${JSON.stringify(bundleOption)} `);
        return new Promise((resolve, reject) => {
            NotificationManager.isNotificationSlotEnabled(bundleOption, slotType, (err, data) => {
                Log.showInfo(TAG, `isNotificationSlotEnabled callback data:${JSON.stringify(data)} err:${JSON.stringify(err)}`);
                if (!!data) {
                    if (callback) {
                        callback(data);
                    }
                    resolve(data);
                } else {
                    reject(err);
                }
            });
        });
    }

    enableNotificationSlot(bundleOption: BundleOption, slotType: Notification.SlotType, data: boolean): void {
        Log.showDebug(TAG, `enableNotificationSlot bundleOption:${JSON.stringify(bundleOption)} data:${JSON.stringify(data)}`);
        let enableValue: boolean = data ? true : false;
        NotificationManager.setNotificationEnableSlot(bundleOption, slotType, enableValue, (err, result) => {
            Log.showInfo(TAG, `enableNotificationSlot err:${JSON.stringify(err)} result:${JSON.stringify(result)}`);
        });
    }

    notificationSlotSet(bundleOption: BundleOption, data: NotificationManager.NotificationSlot): void {
        Log.showDebug(TAG, `notificationSlotSet bundleOption:${JSON.stringify(bundleOption)} data:${JSON.stringify(data)}`);
        NotificationManager.setSlotByBundle(bundleOption, data, (err, result) => {
            Log.showInfo(TAG, `notificationSlotSet err:${JSON.stringify(err)} result:${JSON.stringify(result)}`);
        });
    }

    async isDistributedEnabled(): Promise<boolean> {
        Log.showInfo(TAG, 'isDistributedEnabled');
        return new Promise((resolve, reject) => {
            NotificationManager.isDistributedEnabled().then((data) => {
                Log.showInfo(TAG, `isDistributedEnabled data:${data ? 'true' : 'false'}`);
                resolve(data);
            }).catch((err) => {
                Log.showError(TAG, `isDistributedEnabled err:${JSON.stringify(err)}`);
                reject(err);
            });
        });
    }

    enableDistributed(data: boolean): void {
        Log.showDebug(TAG, `enableDistributed data:${JSON.stringify(data)}`);
        let enableValue: boolean = data ? true : false;
        NotificationManager.setDistributedEnable(enableValue, (err, result) => {
            Log.showInfo(TAG, `enableDistributed err:${JSON.stringify(err)} result:${JSON.stringify(result)}`);
        });
    }
}

let notificationListener = new NotificationListener();

export default notificationListener;
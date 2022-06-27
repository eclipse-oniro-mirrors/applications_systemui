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

import Log from '../../../../../../../../../common/src/main/ets/default/Log';
import DeviceManager from '@ohos.distributedHardware.deviceManager';
import DeviceInfo from '@ohos.deviceInfo';

const TAG = 'NotificationDistributionManager';

let distributionManager = null;

export default class NotificationDistributionManager {
  deviceManager = null;

  static getInstance(): any {
    if (distributionManager == null) {
      Log.showInfo(TAG, 'getInstance distributionManager new');
      distributionManager = new NotificationDistributionManager();
      distributionManager.initDeviceManager();
      return distributionManager;
    }
    Log.showInfo(TAG, 'getInstance return distributionManager');
    return distributionManager;
  }

  constructor() {
    Log.showInfo(TAG, 'constructor');
  }

  initDeviceManager(): void {
    Log.showInfo(TAG, 'initDeviceManager');
    DeviceManager.createDeviceManager('com.ohos.systemui', (err, data) => {
      Log.showInfo(TAG, `initDeviceManager createDeviceManager err:${JSON.stringify(err)} data:${JSON.stringify(data)}`);
      if (data) {
        this.deviceManager = data;
      }
    });
  }

  getTrustedDeviceDeviceName(deviceId: string): string {
    Log.showInfo(TAG, `getTrustedDeviceDeviceName deviceId:${deviceId}`);
    let deviceName = '';
    let deviceArr: any[] = this.getTrustedDeviceListSync();
    Log.showDebug(TAG, `getTrustedDeviceDeviceName deviceArr:${JSON.stringify(deviceArr)}`);
    if (deviceArr.length > 0) {
      for (let item of deviceArr) {
        if (item.deviceId == deviceId) {
          deviceName = item.deviceName;
          break;
        }
      }
    }
    return deviceName;
  }

  getTrustedDeviceListSync(): any[] {
    Log.showInfo(TAG, 'getTrustedDeviceListSync');
    return this.deviceManager.getTrustedDeviceListSync();
  }

  getLocalDeviceInfoSync(): any {
    Log.showInfo(TAG, 'getLocalDeviceInfoSync');
    return this.deviceManager.getLocalDeviceInfoSync();
  }

  release(): void {
    this.deviceManager.release();
  }
}

NotificationDistributionManager.getInstance();
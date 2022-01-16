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

import BundleMgr from '@ohos.bundle';
import Resmgr from '@ohos.resourceManager';
import Log from '../Log.ets';

const TAG = 'BRManager';

export default class BundleManager {
  static async getResourceManager(tag, bundleName, then?: Function) {
    Log.showInfo(TAG, `getResourceManager from: ${tag}`);
    if (!then) {
      return await Resmgr.getResourceManager(bundleName);
    }
    Resmgr.getResourceManager(bundleName).then(then);
  }

  static async getBundleInfo(tag, bundleName, getInfo, then?: Function) {
    Log.showInfo(TAG, `getBundleInfo from: ${tag}`);
    if (!then) {
      return await BundleMgr.getBundleInfo(bundleName, getInfo);
    }
    BundleMgr.getBundleInfo(bundleName, getInfo).then(then);
  }
}
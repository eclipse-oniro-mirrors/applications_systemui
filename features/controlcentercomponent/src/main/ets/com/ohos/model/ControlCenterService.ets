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

import Resmgr from '@ohos.resourceManager';
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import PluginDataSourceAdapter from '../../../../../../../../common/src/main/ets/plugindatasource/PluginDataSourceAdapter.ets';
import Constants from '../common/Constants.ets';

const TAG = 'ControlCenterModel';

let CONTROLCENTER_SOURCE_CONFIG = {
  "MetaSource": {
    "action": "com.ohos.systemui.action.TOGGLE",
    "permission": null,
    "filterIds": []
  },
  // "pluginSource": { "pluginUrl": "xxx/xxx/xx" }
}

export class ControlCenterService {
  mIsStart: boolean = false;
  mAdapter: PluginDataSourceAdapter;
  mListener: any;

  startService(filterIds: string[]) {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `start ControlCenterService.`)
    this.mIsStart = true;
    this.mAdapter = new PluginDataSourceAdapter(TAG);
    this.mAdapter.registerListener({
      'initFinish': this.loadData.bind(this),
      'addItem': this.onItemAdd.bind(this),
      'removeItem': this.onItemRemove.bind(this)
    });
    {
      CONTROLCENTER_SOURCE_CONFIG.MetaSource.filterIds = filterIds;
    }
    this.mAdapter.initDataSource(CONTROLCENTER_SOURCE_CONFIG);
  }

  stopService() {
    if (!this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `stop ControlCenterService.`)
    this.mIsStart = false;
    this?.mAdapter.unregisterListener();
    this?.mAdapter.clearAll();
  }

  loadData() {
    Log.showInfo(TAG, `loadData`)
    this.mAdapter.loadData();
  }

  registerListener(listener: {
    'addItem': Function,
    'removeItem': Function
  }) {
    Log.showInfo(TAG, `registerListener, listener: ${listener}`)
    this.mListener = listener;
  }

  onItemAdd(itemData) {
    Log.showInfo(TAG, `onItemAdd, itemData: ${JSON.stringify(itemData)}`)
    if (!CheckEmptyUtils.isEmpty(itemData.label) || !CheckEmptyUtils.isEmpty(itemData.iconUrl)) {
      if (!CheckEmptyUtils.isEmpty(itemData.label)) {
        itemData.label = decodeURIComponent(itemData.label);
      }
      this.mListener?.addItem(itemData);

    } else {
      Resmgr.getResourceManager(itemData.bundleName)
        .then(mgr => {
          mgr.getString(itemData.abilityLabelId, (error, value) => {
            Log.showInfo(TAG, `onItemAdd mgr.getString, error: ${JSON.stringify(error)} value: ${JSON.stringify(value)}`)
            if (error != null) {
              return;
            }
            itemData.label = value;
            mgr.getMediaBase64(itemData.abilityIconId, (error, value) => {
              Log.showInfo(TAG, `onItemAdd mgr.getMediaBase64, error: ${JSON.stringify(error)} value: ${JSON.stringify(value)}`)
              if (error != null) {
                return;
              }
              itemData.iconUrl = value;
              this.mListener?.addItem(itemData);
            });
          });
        })
        .catch(e => {
          Log.showInfo(TAG, `onItemAdd Resmgr.getResourceManager, e: ${JSON.stringify(e)}`)
        });
    }
  }

  onItemRemove(itemData) {
    Log.showInfo(TAG, `onItemRemove, itemData: ${JSON.stringify(itemData)}`)
    this.mListener?.removeItem(itemData);
  }
}

let controlCenterService = new ControlCenterService();

export default controlCenterService as ControlCenterService;
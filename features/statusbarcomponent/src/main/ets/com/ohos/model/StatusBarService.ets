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
import SwitchUserManager from '../../../../../../../../common/src/main/ets/default/SwitchUserManager.ets';
import CheckEmptyUtils from '../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import PluginDataSourceAdapter from '../../../../../../../../common/src/main/ets/plugindatasource/PluginDataSourceAdapter.ets';
import Constants from '../common/Constants.ets';

const TAG = 'StatusBarModel';

let STATUSBAR_SOURCE_CONFIG = {
  "MetaSource": {
    "action": "com.ohos.systemui.action.BAR_ICON",
    "permission": null,
    "filterIds": []
  },
  // "pluginSource": { "pluginUrl": "xxx/xxx/xx" }
}

export class StatusBarService {
  mIsStart: boolean = false;
  mAdapter: PluginDataSourceAdapter;
  mListener: any;
  mEmptyPosition: any;
  mMaxWidth: number;
  mMaxHeight: number;
  mStatusBarHeight: number;

  startService(filterIds: string[]) {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `start StatusBarService.`)
    this.mIsStart = true;
    this.mAdapter = new PluginDataSourceAdapter(TAG);
    this.mAdapter.registerListener({
      'initFinish': this.loadData.bind(this),
      'addItem': this.onItemAdd.bind(this),
      'removeItem': this.onItemRemove.bind(this)
    });
    SwitchUserManager.getInstance().registerListener(this);
    {
      STATUSBAR_SOURCE_CONFIG.MetaSource.filterIds = filterIds;
    }
    this.mAdapter.initDataSource(STATUSBAR_SOURCE_CONFIG);
  }

  stopService() {
    if (!this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `stop StatusBarService.`)
    this.mIsStart = false;
    this?.mAdapter.unregisterListener();
    this?.mAdapter.clearAll();
  }

  userChange(userInfo) {
    Log.showInfo(TAG, `userChange userInfo ` + userInfo);
    this.loadData(userInfo.userId);
  }

  loadData(userId) {
    Log.showInfo(TAG, `loadData`)
    if (userId === null || userId === undefined) {
      SwitchUserManager.getInstance().getCurrentUserInfo().then((userInfo) => {
        this.mAdapter.loadData(userInfo.userId);
      });
    } else {
      this.mAdapter.loadData(userId);
    }
  }

  registerListener(listener: {
    'addItem': Function,
    'removeItem': Function,
    'onEmptyAreaChange': Function
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

  initEmptyArea(emptyPosition: any, windowSize: any) {
    Log.showInfo(TAG, `initEmptyArea, emptyPosition: ${JSON.stringify(emptyPosition)} windowSize: ${JSON.stringify(windowSize)}`)
    this.mEmptyPosition = emptyPosition;
    this.mMaxWidth = windowSize.width;
    this.mMaxHeight = windowSize.height;
    this.mStatusBarHeight = windowSize.statusBarHeight;

    const defaultRotation = 0;
    let position: string = null;
    if (emptyPosition && (emptyPosition.x1 != emptyPosition.x2 || emptyPosition.y1 != emptyPosition.y2)) {
      position = this.calcEmptyAreaPosition(defaultRotation);
    }
    let res = { "position": position, "rotation": defaultRotation };
    Log.showInfo(TAG, `initEmptyArea, res: ${JSON.stringify(res)}`)
    return res;
  }

  calcEmptyAreaPosition(rotation: number): string{
    Log.showInfo(TAG, `calcEmptyAreaPosition, rotation: ${rotation}`)

    let statusBarLeftX1: number;
    let statusBarLeftY1: number;
    let statusBarLeftX2: number;
    let statusBarLeftY2: number;
    let statusBarRightX1: number;
    let statusBarRightY1: number;
    let statusBarRightX2: number;
    let statusBarRightY2: number;
    if (rotation == 0) {
      statusBarLeftX1 = 0;
      statusBarLeftY1 = 0;
      statusBarLeftX2 = this.mMaxWidth / 2;
      statusBarLeftY2 = this.mStatusBarHeight;
      statusBarRightX1 = this.mMaxWidth / 2;
      statusBarRightY1 = 0;
      statusBarRightX2 = this.mMaxWidth;
      statusBarRightY2 = this.mStatusBarHeight;
    } else if (rotation == 90) {
      statusBarLeftX1 = this.mMaxWidth - this.mStatusBarHeight;
      statusBarLeftY1 = 0;
      statusBarLeftX2 = this.mMaxWidth;
      statusBarLeftY2 = this.mMaxHeight / 2;
      statusBarRightX1 = this.mMaxWidth - this.mStatusBarHeight;
      statusBarRightY1 = this.mMaxHeight / 2;
      statusBarRightX2 = this.mMaxWidth;
      statusBarRightY2 = this.mMaxHeight;
    } else if (rotation == 180) {
      statusBarLeftX1 = this.mMaxWidth / 2;
      statusBarLeftY1 = this.mMaxHeight - this.mStatusBarHeight;
      statusBarLeftX2 = this.mMaxWidth;
      statusBarLeftY2 = this.mMaxHeight;
      statusBarRightX1 = 0;
      statusBarRightY1 = this.mMaxHeight - this.mStatusBarHeight;
      statusBarRightX2 = this.mMaxWidth / 2;
      statusBarRightY2 = this.mMaxHeight;
    } else if (rotation == 270) {
      statusBarLeftX1 = 0;
      statusBarLeftY1 = this.mMaxHeight / 2;
      statusBarLeftX2 = this.mStatusBarHeight;
      statusBarLeftY2 = this.mMaxHeight;
      statusBarRightX1 = 0;
      statusBarRightY1 = 0;
      statusBarRightX2 = this.mStatusBarHeight;
      statusBarRightY2 = this.mMaxHeight / 2;
    } else {
      return null;
    }
    Log.showInfo(TAG, `calcEmptyAreaPosition, leftxy: ${statusBarLeftX1} ${statusBarLeftY1} ${statusBarLeftX2} ${statusBarLeftY2}`)
    Log.showInfo(TAG, `calcEmptyAreaPosition, rightxy: ${statusBarRightX1} ${statusBarRightY1} ${statusBarRightX2} ${statusBarRightY2}`)

    let isGlandLeft = this.isEmptyAreaGlandStatusBar(statusBarLeftX1, statusBarLeftY1, statusBarLeftX2, statusBarLeftY2);
    let isGlandRight = this.isEmptyAreaGlandStatusBar(statusBarRightX1, statusBarRightY1, statusBarRightX2, statusBarRightY2);
    Log.showInfo(TAG, `calcEmptyAreaPosition, gland: ${isGlandLeft} ${isGlandRight}`)
    if (isGlandLeft && isGlandRight) {
      return Constants.EMPTY_AREA_POSITION_CENTER;
    } else if (isGlandLeft) {
      return Constants.EMPTY_AREA_POSITION_LEFT;
    } else if (isGlandRight) {
      return Constants.EMPTY_AREA_POSITION_RIGHT;
    } else {
      return null;
    }
  }

  isEmptyAreaGlandStatusBar(x1, y1, x2, y2): boolean{
    Log.showInfo(TAG, `isEmptyAreaGlandStatusBar, xy: ${x1} ${y1} ${x2} ${y2}`)
    let ex1 = this.mEmptyPosition.x1;
    let ey1 = this.mEmptyPosition.y1;
    let ex2 = this.mEmptyPosition.x2;
    let ey2 = this.mEmptyPosition.y2;

    if (ex1 >= x1 && ex1 <= x2 && ey1 >= y1 && ey1 <= y2) {
      return true;
    } else if (ex2 >= x1 && ex2 <= x2 && ey1 >= y1 && ey1 <= y2) {
      return true;
    } else if (ex1 >= x1 && ex1 <= x2 && ey2 >= y1 && ey2 <= y2) {
      return true;
    } else if (ex2 >= x1 && ex2 <= x2 && ey2 >= y1 && ey2 <= y2) {
      return true;
    }
    return false;
  }
}

let statusBarService = new StatusBarService();

export default statusBarService as StatusBarService;
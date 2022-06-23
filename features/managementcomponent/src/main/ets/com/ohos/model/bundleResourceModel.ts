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
import Log from '../../../../../../../../common/src/main/ets/default/Log'
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import Bundle from '@ohos.bundle';
import ResMgr from '@ohos.resourceManager';
import SwitchUserManager from '../../../../../../../../common/src/main/ets/default/SwitchUserManager'

const INDEX = 0;
const IS_INCLUDE_ABILITY_INFO = 0;

const TAG = 'NotificationManagenment-BundleResourceModel';

export default class BundleResourceModel {
  private mBundleInfoList: any[]= [];

  async getAllBundleInfos() {
    let userId =(await SwitchUserManager.getInstance().getCurrentUserInfo()).userId;
    Bundle.getAllBundleInfo(IS_INCLUDE_ABILITY_INFO, userId)
      .then((data) => {
        this.getIconItem(INDEX, data.length, data);
      });
    Log.showInfo(TAG, 'getAllBundleInfos end');
  }

  async getIconItem(index, count, data) {
    Log.showInfo(TAG, 'getIconItem data.length' + data.length);
    let imageValue = '';
    let label = '';
    let that = this;
    Log.showDebug(TAG, 'getIconItem data[index].name :' + data[index].name);
    try {
      let bundleContext = await AbilityManager.getContext().createBundleContext(data[index].name);
      let bundleResourceManager = await bundleContext.resourceManager;

      let appInfo = data[index].appInfo;
      if (appInfo.labelId > 0) {
        bundleResourceManager.getString(appInfo.labelId, (error, value) => {
          if (value != null) {
            Log.showDebug(TAG, 'getIconItem ResMgr.getResourceManager getString() value:' + value);
            label = value;
          } else {
            Log.showError(TAG, 'getIconItem ResMgr.getResourceManager getString() error:' + error);
          }
        });
      } else {
        label = appInfo.label;
      }
      Log.showDebug(TAG, 'getIconItem ResMgr.getResourceManager finish label:' + label);
      if (appInfo.iconId <= 0) {
        this.nextIconItem(index, count, data, this.mBundleInfoList, that)
        return
      }
      bundleResourceManager.getMediaBase64(appInfo.iconId, (error, value) => {
        if (error === undefined) {
          Log.showDebug(TAG, 'getIconItem ResMgr.getMediaBase64() value:' + value.length);
          if (value.length > 0) {
            imageValue = value;
          }
          this.mBundleInfoList.push({
            appIcon: imageValue,
            appTitle: label,
            appValue: '',
            appArrow: $r('app.media.ic_settings_arrow'),
            appSummary: data[index].versionName,
            appBundleName: data[index].name,
            appIconId: appInfo.iconId,
            appUri: 'pages/setEnable',
            appUid: data[index].uid,
            systemApp: appInfo.systemApp
          });
        }
        Log.showInfo(TAG, 'getIconItem ResMgr.getMediaBase64() end');
        this.nextIconItem(index, count, data, this.mBundleInfoList, that)
      });
    } catch (error) {
      Log.showError(TAG, `getMediaBase64 err:${JSON.stringify(error)}`);
    }
  }

  nextIconItem(index, count, data, bundleInfoList, that) {
    Log.showInfo(TAG, 'nextIconItem index:' + index + ' | count:' + count);
    if (count - 1 > index) {
      index = index + 1;
      that.getIconItem(index, count, data);
    } else {
      AppStorage.SetOrCreate('appManagementList', bundleInfoList);
    }
  }

  async getBundleInfo(bundleName, callback) {
    let mBundleInfo: any = {};
    let label = '';

    let userInfo = await SwitchUserManager.getInstance().getCurrentUserInfo();

    Bundle.getBundleInfo(bundleName, IS_INCLUDE_ABILITY_INFO, {
      userId: userInfo.userId
    }).then((data) => {
      Log.showInfo(TAG, `getBundleInfo bundleInfo:${JSON.stringify(data)}`);
      ResMgr.getResourceManager(data.name, (error, item) => {
        let appInfo = data.appInfo;
        if (parseInt(appInfo.labelId) > 0) {
          item.getString(parseInt(appInfo.labelId), (error, value) => {
            if (value != null) {
              Log.showDebug(TAG, `getBundleInfo getResourceManager getString() value: ` + value);
              mBundleInfo.appTitle = value
            } else {
              Log.showError(TAG, `getBundleInfo getResourceManager getString() error:${JSON.stringify(error)}`);
            }
          });
        }
        mBundleInfo.appTitle = appInfo.label;
        mBundleInfo.appValue = ''
        mBundleInfo.appArrow = $r('app.media.ic_settings_arrow')
        mBundleInfo.appSummary = data.versionName
        mBundleInfo.appBundleName = data.name
        mBundleInfo.appIconId = appInfo.iconId
        mBundleInfo.appUri = ''
        mBundleInfo.appUid = data.uid
        mBundleInfo.systemApp = appInfo.systemApp

        Log.showDebug(TAG, 'getBundleInfo getResourceManager label:' + label);
        if (parseInt(appInfo.iconId) > 0) {
          item.getMediaBase64(parseInt(appInfo.iconId), (error, imageValue) => {
            if (!!imageValue) {
              mBundleInfo.appIcon = imageValue
            }
            callback(mBundleInfo);
          });
        } else {
          callback(mBundleInfo);
        }

      });
    });
    Log.showInfo(TAG, 'getBundleInfo end');
  }
}


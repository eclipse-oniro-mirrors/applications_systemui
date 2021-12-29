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
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import Bundle from '@ohos.bundle';
import ResMgr from '@ohos.resourceManager';

const INDEX = 0;
const IS_INCLUDE_ABILITY_INFO = 0;

const TAG = 'NotificationManagenment-BundleResourceModel';

export default class BundleResourceModel {
  private mBundleInfoList: any[]= [];

  getAllBundleInfos() {
    Log.showInfo(TAG, 'getAllBundleInfos entry');
    Bundle.getAllBundleInfo(IS_INCLUDE_ABILITY_INFO)
      .then((data) => {
        this.getIconItem(INDEX, data.length, data);
      });
    Log.showInfo(TAG, 'getAllBundleInfos end');
  }

  getIconItem(index, count, data) {
    Log.showInfo(TAG, 'getIconItem data.length' + data.length);
    let imageValue = '';
    let label = '';
    let that = this;
    Log.showInfo(TAG, 'getIconItem data[index].name :' + data[index].name);
    try {
      ResMgr.getResourceManager(data[index].name, (error, item) => {
        let appInfo = data[index].appInfo;
        if (appInfo.labelId > 0) {
          item.getString(appInfo.labelId, (error, value) => {
            Log.showInfo(TAG, 'getIconItem ResMgr.getResourceManager  value.length:' + value.length);
            if (value != null) {
              Log.showInfo(TAG, 'getIconItem ResMgr.getResourceManager getString() value:' + value);
              label = value;
              Log.showInfo(TAG, 'getIconItem ResMgr.getResourceManager getString() label:' + label);
            } else {
              Log.showInfo(TAG, 'getIconItem ResMgr.getResourceManager getString() error:' + error);
            }
          });
        } else {
          Log.showInfo(TAG, 'getIconItem ResMgr.getResourceManager label:' + appInfo.label);
          label = appInfo.label;
        }
        Log.showInfo(TAG, 'getIconItem ResMgr.getResourceManager finish label:' + label);
        if (appInfo.iconId <= 0) {
          this.nextIconItem(index, count, data, this.mBundleInfoList, that)
          return
        }
        item.getMediaBase64(appInfo.iconId, (error, value) => {
          if (error === undefined) {
            Log.showInfo(TAG, 'getIconItem ResMgr.getMediaBase64() value:' + value.length);
            if (value.length > 0) {
              imageValue = value;
              Log.showInfo(TAG, 'getIconItem ResMgr.getMediaBase64() imageValue:' + imageValue);
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
            });
          }
          Log.showInfo(TAG, 'getIconItem ResMgr.getMediaBase64() end');
          this.nextIconItem(index, count, data, this.mBundleInfoList, that)
        });

      });
    } catch (error) {
      Log.showInfo(TAG, 'getIconItem catch error:' + error);
    }
    Log.showInfo(TAG, 'getIconItem end');
  }

  nextIconItem(index, count, data, bundleInfoList, that) {
    if (count - 1 > index) {
      Log.showInfo(TAG, 'nextIconItem if index:' + index + ' | count:' + count);
      index = index + 1;
      that.getIconItem(index, count, data);
    } else {
      Log.showInfo(TAG, 'nextIconItem else index:' + index + ' | count:' + count);
      AppStorage.SetOrCreate('appManagementList', bundleInfoList);
    }

  }
}


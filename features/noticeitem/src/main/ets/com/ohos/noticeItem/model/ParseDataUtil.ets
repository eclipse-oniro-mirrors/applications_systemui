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

import Notification from '@ohos.notification';
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import BundleManager from '../../../../../../../../../common/src/main/ets/default/abilitymanager/bundleManager.ets';
import NotificationManager from './NotificationManager.ets';
import Constants, {NotificationItemData} from '../common/constants.ets';
import {NotificationConfig} from './NotificationConfig.ets';

let mDate;
let mAppName;
let mEmptyArray;
const TAG = 'Notification_ParseDataUtil';
mDate = new Date();
mAppName = new Map();
mEmptyArray = [];
let appDataMap = new Map();

/**
 * parse data util class.
 */
export default class ParseDataUtil {
  static parseData(data, callback) {
    let request = data?.request;
    if (request == null || request == undefined) {
      Log.showInfo(TAG, 'consumeCallback request is empty');
      callback(Constants.ERROR_CALLBACK, undefined);
      return;
    }
    let slotLevel;
    try {
      slotLevel = data?.sortingMap?.sortings[request.hashCode]?.slot.level;
    } catch (e) {
      Log.showInfo(TAG, `slot level get error:  ${e.toString()}`);
    }
    let sound = '';
    try {
      sound = data?.sortingMap?.sortings[request.hashCode]?.slot.sound;
    } catch (e) {
      Log.showInfo(TAG, `sound  get error:  ${e.toString()}`);
    }
    let vibrationValues = [];
    try {
      vibrationValues = data?.sortingMap?.sortings[request.hashCode]?.slot.vibrationValues;
    } catch (e) {
      Log.showInfo(TAG, `vibrationValues get error:  ${e.toString()}`);
    }
    Log.showInfo(TAG, `want = ${JSON.stringify(request.wantAgent)}`);
    Log.showInfo(TAG, `actionButtons = ${JSON.stringify(request.actionButtons)}`);
    Log.showInfo(TAG, `largeIcon = ${request.largeIcon}`);
    ParseDataUtil.getAppData(request.creatorBundleName, (err, appMessage) => {
      let notificationItem: NotificationItemData = {
        id: request.id,
        hashcode: request.hashCode,
        contentType: request?.content?.contentType + '',
        timestamp: request.deliveryTime,
        time: ParseDataUtil.getStandardTime(request.deliveryTime),
        appName: appMessage.appName,
        want: request.wantAgent,
        bundleName: request.creatorBundleName,
        actionButtons: request.actionButtons,
        smallIcon: NotificationConfig.USE_NOTIFICATION_ICON ? (request?.smallIcon ?? appMessage.icon) : appMessage.icon,
        largeIcon: request.largeIcon,
        slotLevel: slotLevel,
        source: request.source,
        sound: sound? sound : '',
        vibrationValues: vibrationValues? vibrationValues : [],
        template: request?.template,
        isOngoing: request.isOngoing,
        isUnremovable: request.isUnremovable,
        isRemoveAllowed: request.isRemoveAllowed
      };
      Log.showInfo(TAG, `notificationItem construct over ====================`);
      switch (request?.content?.contentType) {
        case NotificationManager.TYPE_BASIC:
          Log.showInfo(TAG, `contentType NOTIFICATION_CONTENT_BASIC_TEXT ====================`);
          notificationItem.title = request.content.normal?.title ?? '';
          notificationItem.text = request.content.normal?.text ?? '';
          notificationItem.additionalText = request.content.normal?.additionalText ?? '';
          break;
        case NotificationManager.TYPE_LONG:
          Log.showInfo(TAG, `contentType NOTIFICATION_CONTENT_LONG_TEXT ====================`);
          notificationItem.title = request.content.longText?.title ?? '';
          notificationItem.text = request.content.longText?.text ?? '';
          notificationItem.additionalText = request.content.longText?.additionalText ?? '';
          notificationItem.briefText = request.content.longText?.briefText ?? '';
          notificationItem.expandedTitle = request.content.longText?.expandedTitle ?? '';
          notificationItem.longText = request.content.longText?.longText ?? '';
          break;
        case NotificationManager.TYPE_MULTI:
          Log.showInfo(TAG, `contentType NOTIFICATION_CONTENT_MULTILINE ====================`);
          notificationItem.title = request.content.multiLine?.title ?? '';
          notificationItem.text = request.content.multiLine?.text ?? '';
          notificationItem.additionalText = request.content.multiLine?.additionalText ?? '';
          notificationItem.briefText = request.content.multiLine?.briefText ?? '';
          notificationItem.longTitle = request.content.multiLine?.longTitle ?? '';
          notificationItem.lines = request.content.multiLine?.lines ?? mEmptyArray;
          Log.showInfo(TAG, `multilines: ${JSON.stringify(request.content.multiLine?.lines)}`)
          break;
        case NotificationManager.TYPE_PICTURE:
          Log.showInfo(TAG, `contentType NOTIFICATION_CONTENT_PICTURE ====================`);
          notificationItem.title = request.content.picture?.title ?? '';
          notificationItem.text = request.content.picture?.text ?? '';
          notificationItem.additionalText = request.content.picture?.additionalText ?? '';
          notificationItem.briefText = request.content.picture?.briefText ?? '';
          notificationItem.expandedTitle = request.content.picture?.expandedTitle ?? '';
          Log.showInfo(TAG, `picture value` + request.content.picture.picture);
          notificationItem.picture = request.content.picture?.picture ?? '';
          break;
        default:
          Log.showInfo(TAG, 'no match content type');
          break;
      }
      callback(Constants.SUCCESS_CALLBACK, notificationItem);
    })
  }

  /**
   * Get app data by bundleName.
   *
   * @param {string} bundleName - BundleName of the target app.
   * @return {object} appData
   */
  static getAppData(bundleName, callback) {
    Log.showInfo(TAG, 'getAppName start ====================');
    if (appDataMap.has(bundleName)) {
      callback(Constants.SUCCESS_CALLBACK, appDataMap.get(bundleName));
      return;
    }
    BundleManager.getBundleInfo(TAG, bundleName, 0, (data) => {
      Log.showInfo(TAG, `getBundleInfo` + JSON.stringify(data));
      let labelId = data.appInfo.labelId;
      let iconId = data.appInfo.iconId;
      let appName = '';
      BundleManager.getResourceManager(TAG, bundleName, (item) => {
        Log.showInfo(TAG, `BundleManager.getResourceManager ${BundleManager.getResourceManager}`);
        item.getString(labelId, (error, value) => {
          Log.showInfo(TAG, `getString` + JSON.stringify(value));
          if (value != null && value != undefined) {
            appName = value
          }
          item.getMediaBase64(iconId, (error, MediaValue) => {
            Log.showInfo(TAG, `getMediaBase64` + JSON.stringify(MediaValue));
            if (MediaValue != null) {
              let appMessage = {
                'appName': appName,
                'icon': MediaValue
              }
              Log.showInfo(TAG, `appDataMap set appInfo, appName = ` + JSON.stringify(appName));
              if (appName != null && appName != undefined && appName != '') {
                appDataMap.set(bundleName, appMessage);
              }
              Log.showInfo(TAG, `getAppData success, appMessage ` + JSON.stringify(appMessage));
              callback(Constants.SUCCESS_CALLBACK, appDataMap.get(bundleName));
            }
          });
        })
      })
    });
  }

  /**
   * Reformat the timestamp to hh:mm.
   *
   * @param {number} timestamp - Target timestamp.
   */
  static getStandardTime(timestamp) {
    Log.showInfo(TAG, 'getStandardTime start ====================');
    if (timestamp == 0 || timestamp == undefined || timestamp == null) {
      return '';
    }
    mDate.setTime(timestamp);
    let hoursNumber = mDate.getHours();
    let minutesNumber = mDate.getMinutes();
    let hours = hoursNumber < 10 ? '0' + hoursNumber : hoursNumber;
    let minutes = minutesNumber < 10 ? '0' + minutesNumber : minutesNumber;
    return hours + ':' + minutes;
  }
}

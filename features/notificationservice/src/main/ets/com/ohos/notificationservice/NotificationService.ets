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

import NotificationManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/notificationManager.ets';
import BundleManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/bundleManager.ets';
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import Constants,{NotificationItemData} from './common/constants.ets';
import {SlotLevel} from '@ohos.notification'
import Media from '@ohos.multimedia.media'

const TAG = 'NotificationService';

let mNotificationList;
let mSubscriber;
let mDate;
let mAppName;
let mEmptyArray;

/**
 * Responsible for notification binding and interaction between View and Model.
 */
export class NotificationService {
  media:any
  constructor() {
    let tempLink = AppStorage.SetAndLink('notificationList', [])
    mNotificationList = tempLink.get()
    Log.showInfo(TAG, `NotificationService constructor ${JSON.stringify(mNotificationList)}`)
    this.media=Media.createAudioPlayer()
    this.media.src='file://system/etc/Light.ogg'
  }

  initNotificationService() {
    Log.showInfo(TAG, 'initNotificationCenter')
    mDate = new Date();
    mAppName = new Map();
    mEmptyArray = [];
    if (mSubscriber == undefined || mSubscriber == null) {
      this.createNotificationCallback();
      Log.showInfo(TAG, `initNotificationCenter, if: ${JSON.stringify(mSubscriber)}`);
    }
    this.getAllActiveNotifications();
  }

  updateNotification() {
    Log.showInfo(TAG, `updateNotification  list: ${JSON.stringify(mNotificationList)}`);
    Log.showInfo(TAG, `updateNotification  len: ${mNotificationList.length}`);
    let listLink = AppStorage.Link('notificationList');
    listLink.set(mNotificationList);
    Log.showInfo(TAG, `updateNotification  list: ${JSON.stringify(listLink.get())}`);
  }

  /**
   * Call the method to receive notification events.
   */
  createNotificationCallback() {
    Log.showInfo(TAG, 'createNotificationCallback enter ====================');
    mSubscriber = {
      onConsume: this.consumeCallback.bind(this),
      onCancel: this.OnCancelCallback.bind(this)
    }
    Log.showInfo(TAG, `createNotificationCallback, ${JSON.stringify(mSubscriber)}`);
    Log.showInfo(TAG, `createNotificationCallback, ${JSON.stringify(mSubscriber.onConsume)}`);
    Log.showInfo(TAG, `createNotificationCallback, ${JSON.stringify(mSubscriber.onCancel)}`);
    NotificationManager.subscribeNotification(TAG, mSubscriber, this.subscribeCallback.bind(this));
    Log.showInfo(TAG, 'createNotificationCallback end ====================');
  }

  /**
     * Call the method before current process finished.
     */
  async unRegisterNotificationSubscriber() {
    if (mSubscriber != undefined && mSubscriber != null) {
      NotificationManager.unsubscribeNotification(TAG, mSubscriber);
    }
  }

  /**
   * The callback method that will be called after receiving a notification
   *
   * @param {Object} data - Callback data.
   */
  consumeCallback(data) {
    Log.showInfo(TAG, 'consumeCallback started');
    Log.showInfo(TAG, 'sortingMap' + JSON.stringify(data.sortingMap||{}))
    Log.showInfo(TAG, JSON.stringify(data));
    let request = data?.request;
    if (request == null || request == undefined) {
      Log.showInfo(TAG, 'consumeCallback request is empty');
      return;
    }
    let sortingMap = data?.sortingMap;
    if (sortingMap == null || sortingMap == undefined) {
      Log.showInfo(TAG, 'consumeCallback sortingMap is empty');
      return;
    }
    this.handleRequest(request,sortingMap,Constants.GET_NEW_NOTIFICATION);
  }

  parseRequest(request,appName,icon){
    Log.showInfo(TAG, `want = ${JSON.stringify(request.wantAgent)}`);
    Log.showInfo(TAG, `actionButtons = ${JSON.stringify(request.actionButtons)}`);
    Log.showInfo(TAG, `largeIcon = ${request.largeIcon}`);
    let notificationItem:NotificationItemData = {
      id: request.id,
      hashcode: request.hashCode,
      contentType: request?.content?.contentType + '',
      timestamp: request.deliveryTime,
      time: this.getStandardTime(request.deliveryTime),
      name: appName,
      want: request.wantAgent,
      bundleName: request.creatorBundleName,
      actionButtons: request.actionButtons,
      smallIcon: icon,
      largeIcon: request.largeIcon,
    };
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
      default:
        Log.showInfo(TAG, 'no match content type');
        break;
    }
    return notificationItem
  }

  handleRequest(request,sortingMap, processType) {
    Log.showInfo(TAG, `request : ${JSON.stringify(request)}`)
    Log.showInfo(TAG, `processType : ${processType}`)
    let contentType = request?.content?.contentType;
    if (contentType == null || contentType == undefined) {
      Log.showInfo(TAG, 'Request contentType is empty');
      return;
    }
    let slotLevel;
    try{
      slotLevel=sortingMap?.sortings[request.hashCode]?.slot.level;
    }catch(e){
      Log.showInfo(TAG, `slot level get error:  ${e.toString()}`);
    }
    Log.showInfo(TAG, `slotLevel = ${slotLevel}`);
    this.getAppName(request.creatorBundleName, (AppName) => {
      Log.showInfo(TAG, `notificationItem AppName = ${JSON.stringify(AppName)}`);
      let notificationItem:NotificationItemData = this.parseRequest(request,AppName.appName,AppName.icon)
      Log.showInfo(TAG, `notificationItem = ${JSON.stringify(notificationItem)}`);
      if(slotLevel===SlotLevel.LEVEL_HIGH){
        try{
          this.media.play()
        }catch(e){
          Log.showInfo(TAG, `notificationItem id：${notificationItem.id} alert error: ${e.toString()}`);
        }
      }
      switch (processType) {
        case Constants.GET_NEW_NOTIFICATION:
          this.removeNotificationItem(notificationItem['hashcode'], false);
          mNotificationList.unshift(notificationItem);
        //mNotificationList.sort(this.compare('timestamp'));
          this.updateNotification();
          break;
        case Constants.GET_EXIST_NOTIFICATION:
          mNotificationList.unshift(notificationItem);
          this.updateNotification();
          break;
        default:
          Log.showInfo(TAG, 'no match process type');
          break;
      }
    });
  }

  /**
   * Get app name with bundleName.
   *
   * @param {string} bundleName - BundleName of the target app.
   */
  getAppName(bundleName, callback) {
    Log.showInfo(TAG, 'getAppName start ====================');
    if (mAppName.has(bundleName)) {
      callback(mAppName.get(bundleName));
      Log.showInfo(TAG, 'HAS BUNDLENAME');
    } else {
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
                if (appName != null && appName != undefined && appName != '') {
                  mAppName.set(bundleName, appMessage);
                }
                callback(appMessage);
              }
            });
          })
        })
      });
      Log.showInfo(TAG, 'getAppName end ====================');
    }
  }

  /**
   * notification CancelCallback
   *
   * @param {Object} data - return data Message.
   */
  OnCancelCallback(data) {
    console.info("===>OnCancelCallback data : ==> " + `data:${JSON.stringify(data)}`);
    this.removeNotificationItem(data.request.hashCode, false);
  }

  onUpdateCallback(data) {
    Log.showInfo(TAG, `onUpdateCallback = ${JSON.stringify(data.request)}`);
  }

  /**
   * The callback will be called after registered callback.
   *
   * @param {Object} err - Error may occur.
   * @param {Object} data - Callback data.
   */
  subscribeCallback(err, data) {
    Log.showInfo(TAG, `subscribeCallback finished err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`)
  }

  /**
   * Reformat the timestamp to hh:mm.
   *
   * @param {number} timestamp - Target timestamp.
   */
  getStandardTime(timestamp) {
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

  /**
   * Compare method will be used when sorting a two-dimensional array.
   *
   * @param {string} property - Property in the object will be sorted.
   */
  compare(params) {
    return function (item1, item2) {
      var itemTime1 = item1[params];
      var itemTime2 = item2[params];
      return itemTime2 - itemTime1;
    }
  }

  /**
     * Remove all notifications.
     */
  removeAllNotifications() {
    mNotificationList = []
    this.updateNotification()
    NotificationManager.removeAll(TAG, (err, data) => {
      Log.showInfo(TAG, `removeAll , err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
    });
  }

  removeNotificationItem(hashCode, isDelSysConent) {
    Log.showInfo(TAG, `removeNotificationItem start, hashCode: ${hashCode}`);
    for (let i = 0, len = mNotificationList.length; i < len; i++) {
      if (mNotificationList[i].hashcode == hashCode) {
        Log.showInfo(TAG, `removeNotificationItem i = ${i}`);
        mNotificationList.splice(i, 1);
        //        mNotificationList.pop(i);
        break;
      }
    }
    this.updateNotification()
    if (isDelSysConent) {
      this.removeSysNotificationItem(hashCode);
    }
  }

  removeSysNotificationItem(hashCode) {
    NotificationManager.remove(TAG, hashCode, (err, data) => {
      Log.showInfo(TAG, `removeNotificationItem, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
    })
    Log.showInfo(TAG, `removeNotificationItem end, length: ${mNotificationList.length}`);
  }

  getAllActiveNotifications() {
    Log.showInfo(TAG, `getAllActiveNotifications`);
    NotificationManager.getAllActiveNotifications(TAG, (err, requestsArr) => {
      Log.showInfo(TAG, `getAllActiveNotifications err: ${JSON.stringify(err)}`);
      Log.showInfo(TAG, `getAllActiveNotifications requestsArr: ${JSON.stringify(requestsArr)}`);
      if (Array.isArray(requestsArr)) {
        for(let i = 0,len = requestsArr.length; i< len; i++) {
          this.handleRequest(requestsArr[i],null, Constants.GET_EXIST_NOTIFICATION);
        }
      } else {
        mNotificationList = [];
      }
    })
  }
}

let notificationService = new NotificationService();
export default notificationService as NotificationService;
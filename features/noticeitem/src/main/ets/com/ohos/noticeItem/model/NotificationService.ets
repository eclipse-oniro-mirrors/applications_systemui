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

import notification from '@ohos.notification';
import NotificationSubscriber from '@ohos.notificationSubscriber';
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import NotificationManager from './NotificationManager.ets';
import ParseDataUtil from './ParseDataUtil.ets';

const TAG = 'NotificationService';

let mSubscriber;
let listeners;

/**
 * notification service api
 */
export class NotificationService {
  constructor() {
    listeners = [];
    this.init();
  }

  init() {
    this.loadAllNotifications();
    this.subscribeNotification(this.getSubscriber());
  }

  public register(listener) {
    Log.showInfo(TAG, "register listener")
    listeners.push(listener);
  }

  public unRegister(listener) {
    Log.showInfo(TAG, "unRegister listener")
    let removedIndex = listeners.indexOf(listener);
    if (removedIndex == -1) {
      Log.showInfo(TAG, "unRegister listener, listener is not found");
      return;
    }
    listeners.splice(removedIndex, 1)
    Log.showInfo(TAG, "unRegister listener success");
  }


  public removeAll(){
    Log.showInfo(TAG, 'removeAll start');
    NotificationManager.removeAll(TAG, (data) => {
      Log.showInfo(TAG, `removeAll => data: ${JSON.stringify(data)}`);
    });
  }


  public remove(code: string) {
    NotificationManager.remove(TAG, code,(data) => {
      Log.showInfo(TAG, `removeNotificationItem ==> data: ${JSON.stringify(data)}`);
    })
  }

  public loadAllNotifications() {
    NotificationManager.getAllActiveNotifications(TAG, (err, requestsArr) => {
      Log.showInfo(TAG, `getAllActiveNotifications err: ${JSON.stringify(err)}`);
      Log.showInfo(TAG, `getAllActiveNotifications requestsArr: ${JSON.stringify(requestsArr)}`);
      if (Array.isArray(requestsArr)) {
        for(let i = 0,len = requestsArr.length; i< len; i++) {
          this.handleNotificationLoad(requestsArr[i]);
        }
      }
    })
  }

  getSubscriber() {
    if (mSubscriber == null || mSubscriber == undefined) {
      mSubscriber = {
        onConsume: this.handleNotificationAdd.bind(this),
        onCancel: this.handleNotificationCancel.bind(this),
      }
    }
    return mSubscriber;
  }

  handleNotificationAdd(data) {
    Log.showInfo(TAG, 'handleNotificationAdd started');
    Log.showInfo(TAG, 'sortingMap' + JSON.stringify(data.sortingMap||{}));
    Log.showInfo(TAG, JSON.stringify(data));
    ParseDataUtil.parseData(data, (err, record) => {
      Log.showInfo(TAG, `parseData after = ${JSON.stringify(record)}`);
      Log.showInfo(TAG, `listeners.length = ${JSON.stringify(data)}`);
      for(let i = 0,len = listeners.length; i< len; i++) {
        Log.showInfo(TAG, `notify listener ` + i);
        listeners[i].onNotificationConsume(record);
      }
    });
  }

  handleNotificationCancel(data) {
    console.info("===>handleNotificationCancel data : ==> " + `data:${JSON.stringify(data)}`);
    ParseDataUtil.parseData(data, (err, record) => {
      for(let i = 0,len = listeners.length; i< len; i++) {
        listeners[i].onNotificationCancel(record);
      }
    });
  }

  handleNotificationLoad(data) {
    console.info("===>handleNotificationLoad data : ==> " + `data:${JSON.stringify(data)}`);
    ParseDataUtil.parseData(data, (err, record) => {
      for(let i = 0,len = listeners.length; i< len; i++) {
        listeners[i].onNotificationLoad(record);
      }
    });
  }

  subscribeNotification(subscriber) {
    let callback = (err,data) => {
      Log.showInfo(TAG, `subscribeCallback finished err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`)
    };
    NotificationManager.subscribeNotification(TAG, subscriber, callback);
  }
}

let notificationService = new NotificationService();
export default notificationService as NotificationService;
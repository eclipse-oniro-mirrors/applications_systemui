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

//import { NotificationSubscriber } from './notification/notificationSubscriber';
import Notification from '@ohos.notification';
import PluginComponentManager from '@ohos.plugincomponent'
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';

const TAG = 'NotificationManager';
// Temporary path
const EXTERNAL_JSON_PATH = '/system/etc/NotificationTemplate/external.json'

export default class NotificationManager {
  static TYPE_BASIC: number = Notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
  static TYPE_LONG: number = Notification.ContentType.NOTIFICATION_CONTENT_LONG_TEXT;
  static TYPE_MULTI: number = Notification.ContentType.NOTIFICATION_CONTENT_MULTILINE;
  static TYPE_PICTURE: number = Notification.ContentType.NOTIFICATION_CONTENT_PICTURE;
  static NotificationTemplateMap = null;

  static subscribeNotification(tag, subscriber, asyncCallback) {
    Log.showInfo(TAG, `subscribeNotification from: ${tag}`);
    Notification.subscribe(subscriber, asyncCallback);
  }

  static unsubscribeNotification(tag, subscriber) {
    Log.showInfo(TAG, `subscribeNotification from: ${tag}`);
    Notification.unsubscribe(subscriber);
  }

  static removeAll(tag, callback) {
    Log.showInfo(TAG, `removeAll from: ${tag}`);
    Notification.removeAll(callback);
  }

  static remove(tag, hashCode, callback) {
    Log.showInfo(TAG, `remove from: ${tag}`);
    Notification.remove(hashCode, callback)
  }

  static getAllActiveNotifications(tag, callback) {
    Log.showInfo(TAG, `getAllActiveNotifications from: ${tag}`);
    Notification.getAllActiveNotifications(callback);
  }

  static initNotificationTemplateMap(tag) {
    Log.showInfo(TAG, `initNotificationTemplateMap from: ${tag}`);
    if (NotificationManager.NotificationTemplateMap === null) {
      NotificationManager.NotificationTemplateMap = new Map()
      NotificationManager.requestTemplate(tag, '', EXTERNAL_JSON_PATH);
    }
  }

  static request(tag, param, asyncCallback) {
    Log.showInfo(TAG, `request from: ${tag}`);
    PluginComponentManager.request(param, (err, data) => {
      asyncCallback(err, data);
    });
  }

  static push(tag, param, asyncCallback) {
    Log.showInfo(TAG, `push from: ${tag}`);
    PluginComponentManager.push(param, () => {
      asyncCallback();
    });
  }

  static requestListener(tag, asyncCallback) {
    Log.showInfo(TAG, `requestListener from: ${tag}`);
    PluginComponentManager.on('request', (source, name, data) => {
      asyncCallback(source, name, data);
    })
  }

  static pushListener(tag, asyncCallback) {
    Log.showInfo(TAG, `pushListener from: ${tag}`);
    PluginComponentManager.on('push', (source, template, data, extraData) => {
      asyncCallback(source, template, data, extraData);
    });
  }

  static requestTemplate(tag, templateName, templatePath) {
    Log.showInfo(TAG, `requestTemplate from: ${tag}`);

    let reqWant = {
      bundleName: '',
      abilityName: ''
    };
    let reqData = {}

    let requestParam = {
      want: reqWant,
      name: templateName,
      data: reqData,
      jsonPath: templatePath
    };

    NotificationManager.request(tag, requestParam, (err, data) => {
      Log.showInfo(TAG, `request finished err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`)
      Log.showInfo(TAG, `request finished templateData: ${templateName} data: ${JSON.stringify(data.componentTemplate)}`)
      if (data !== null && data !== undefined) {
        Log.showInfo(TAG, `request finished data.componentTemplate.source:${JSON.stringify(data.componentTemplate.source)}`)
        let templates = JSON.parse(data.componentTemplate.source);
        Log.showInfo(TAG, `request templates: ${JSON.stringify(templates)}`)
        for (let key in templates) {
          NotificationManager.NotificationTemplateMap.set(key, {
            "source": templates[key], "ability": ""
          });
        }
      }
      Log.showInfo(TAG, `request finished notificationTemplateMap: ${JSON.stringify(NotificationManager.NotificationTemplateMap)}`)
    });
  }
}
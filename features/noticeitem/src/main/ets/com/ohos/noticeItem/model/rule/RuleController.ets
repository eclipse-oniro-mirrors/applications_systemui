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

import {NotificationItemData} from '../../common/constants.ets'
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';

const TAG = 'RuleController';

export default class RuleController {


  /**
     * Check if this notification is allow show or not
     *
     * @param {notificationItemData} Data of the notification
     * @param {callback} Data of the type to show the notification
     */
  static getNotificationData(notificationItemData, callback) {
    if (typeof notificationItemData !== NotificationItemData) {
      Log.showInfo(TAG, "type is not NotificationItemData")
      callback(undefined)
      return
    }

    this.this.isAllowSendNotification(notificationItemData.name, 0, "", (isSuccess) => {
      if (!isSuccess) {
        Log.showInfo(TAG, "user is not allow this to send notification")
        callback(undefined)
        return
      }
      this.isTooMuchNotification((isSuccess) => {
        if (!isSuccess) {
          Log.showInfo(TAG, "There are too much notification")
          callback(undefined)
          return
        }
        this.isAppTooMuchNotification(notificationItemData.name, 0, (isSuccess) => {
          if (!isSuccess) {
            Log.showInfo(TAG, "There are too much notification")
            callback(undefined)
          }
          this.getNotificationDataByApp(notificationItemData.name, 0, "", (originData) => {
            this.updateNotificationDataBySense(originData, (finialData) => {
              callback(finalData)
            });
          });
        });
      });
    });
  }

  /**
     * Check if user allow the app send notification or not
     *
     * @param {name} Package name of the app
     * @param {uid} Uid of the app to distinguish twin app
     * @param {channelId} The channel id of the app which is used to send notification
     * @param {callback} The user allow the app send notification or not
     */
  private static isAllowSendNotification(name, uid, channelId, callback) {
    // TODO 权限管理
  }

  /**
   * Check there have been too much notification that there is no need to show another
   *
   *
   * @param {callback} Send too much notification or not
   */
  private static isTooMuchNotification(callback) {
    // TODO 通知总条数显示限制
  }

  /**
   * Check if the app send too much notification to can not show another from this app
   *
   *
   * @param {name} Package name of the app
   * @param {uid} Uid of the app to distinguish twin app
   * @param {callback} Send too much notification or not
   */
  private static isAppTooMuchNotification(name, uid, callback) {
    // TODO 单应用通知显示限制
  }

  /**
     * Get notification data of the notification channel
     *
     * @param {name} Package name of the app which send notification
     * @param {uid} Uid of the app which send notification to distinguish twin app
     * @param {channelId} The channel id of the app which is used to send notification
     * @param {callback} The type to show notification
     */
  private static getNotificationDataByApp(name, uid, channelId, callback) {
    // TODO 提醒方式
  }

  /**
   * Check the sense of the phone to update the show type
   *
   * @param {notificationData} The origin notification data
   * @param {callback} The finial notification data
   */
  private static updateNotificationDataBySense(notificationData, callback) {
    // TODO 场景管理
  }
}
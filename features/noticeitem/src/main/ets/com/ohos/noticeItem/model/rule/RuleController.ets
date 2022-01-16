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

import {NotificationItemData} from '../../common/constants.ets';
import Log from '../../../../../../../../../../common/src/main/ets/default/Log.ets';
import {SlotLevel} from '@ohos.notification';
import Notification from '@ohos.notification';
import CheckEmptyUtils from '../../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import Bundle from '@ohos.bundle';

const TAG = 'NotificationRuleController';

export class RuleController {
  /**
     * Check if this notification is allow show or not
     *
     * @param {notificationItemData} Data of the notification
     * @param {callback} Data of the type to show the notification
     */
  getNotificationData(notificationItemData: NotificationItemData, callback) {
    Log.showInfo(TAG, "getNotificationData start")
    Log.showInfo(TAG, `notificationItemData = ${JSON.stringify(notificationItemData)}`);

    this.isAllowSendNotification(notificationItemData, (isSuccess) => {
      if (!isSuccess) {
        Log.showInfo(TAG, "user is not allow this to send notification");
        callback(undefined);
        return;
      }
      this.getNotificationDataByApp(notificationItemData, (originalData) => {
        Log.showInfo(TAG, `originalData = ${JSON.stringify(originalData)}`);
        this.updateNotificationDataBySense(originalData, (finalData) => {
          Log.showInfo(TAG, `finalData = ${JSON.stringify(finalData)}`);
          callback(finalData);
        });
      });
    });
  }

  /**
     * Check if user allow the app send notification or not
     *
     * @param {notificationItemData} The origin notification data
     * @param {callback} The user allow the app send notification or not
     */
  isAllowSendNotification(notificationItemData, callback) {
    Log.showInfo(TAG, "isAllowSendNotification start");
    Bundle.getBundleInfo(notificationItemData.bundleName, 0)
      .then((data) => {
        Log.showInfo(TAG, `getBundleInfo : ${JSON.stringify(data)}`)
        Notification.isNotificationEnabled({ bundle: notificationItemData.bundleName, uid: data.uid })
          .then((flag) => {
            Log.showInfo(TAG, `Notification.isNotificationEnabled:` + flag)
            callback(flag);
          });
      });

  }

  /**
   * Check whether sound or vibration is allowed
   *
   * @param {notificationItemData} The origin notification data
   * @param {callback} whether sound or vibration is allowed
   */

  SoundOrVibrate(notificationItemData, callback) {
    Log.showInfo(TAG, "SoundOrVibrate start")
    let sound = false;
    let vibrationValues = false;
    if (!CheckEmptyUtils.checkStrIsEmpty(notificationItemData.sound)) {
      sound = true;
      Log.showInfo(TAG, `notificationItemData.sound is allowed = ${sound}`);
    }
    if (!CheckEmptyUtils.isEmptyArr(notificationItemData.vibrationValues)) {
      vibrationValues = true;
      Log.showInfo(TAG, `notificationItemData.vibrationValues is allowed = ${vibrationValues}`);
    }
    callback(sound, vibrationValues);
  }


  /**
     * Get notification data of the notification
     *
     * @param {notificationItemData} The origin notification data
     * @param {callback} The type to show notification
     */
  getNotificationDataByApp(notificationItemData, callback) {
    Log.showInfo(TAG, "getNotificationDataByApp start")
    let mNotificationItemData : NotificationItemData = notificationItemData;
    mNotificationItemData.ruleData = {
      isAllowBanner: false,
      isAllowSound: false,
      isAllowVibrationValues: false,
      isAllowStatusBarShow : false,
      isAllowNotificationListShow : false
    };
    Log.showInfo(TAG, `notificationItemData.slotLevel = ${notificationItemData.slotLevel}`);
    if (notificationItemData.slotLevel === SlotLevel.LEVEL_HIGH) {
      mNotificationItemData.ruleData.isAllowBanner = true;
      this.SoundOrVibrate(notificationItemData, (sound, vibrationValues) => {
        mNotificationItemData.ruleData.isAllowSound = sound;
        mNotificationItemData.ruleData.isAllowVibrationValues = vibrationValues;
      });
      mNotificationItemData.ruleData.isAllowStatusBarShow = true;
      mNotificationItemData.ruleData.isAllowNotificationListShow = true;

    } else if (notificationItemData.slotLevel === SlotLevel.LEVEL_DEFAULT) {
      this.SoundOrVibrate(notificationItemData, (sound, vibrationValues) => {
        mNotificationItemData.ruleData.isAllowSound = sound;
        mNotificationItemData.ruleData.isAllowVibrationValues = vibrationValues;
      });
      mNotificationItemData.ruleData.isAllowStatusBarShow = true;
      mNotificationItemData.ruleData.isAllowNotificationListShow = true;
    } else if (notificationItemData.slotLevel === SlotLevel.LEVEL_LOW ||
      notificationItemData.slotLevel === SlotLevel.LEVEL_MIN) {
      mNotificationItemData.ruleData.isAllowNotificationListShow = true;
    } else {
      mNotificationItemData.ruleData.isAllowNotificationListShow = false;
    }
    Log.showInfo(TAG, `mNotificationItemData.ruleData = ${JSON.stringify(mNotificationItemData.ruleData)}`);
    callback(mNotificationItemData);
  }



  /**
   * Check the sense of the phone to update the show type
   *
   * @param {notificationItemData} The origin notification data
   * @param {callback} The final notification data
   */
  updateNotificationDataBySense(notificationItemData, callback) {
    Log.showInfo(TAG, "updateNotificationDataBySense start")
    let mNotificationItemData = notificationItemData;
    // TODO Scenario Management
    callback(mNotificationItemData);
  }

}

let ruleController = new RuleController();

export default ruleController as RuleController;
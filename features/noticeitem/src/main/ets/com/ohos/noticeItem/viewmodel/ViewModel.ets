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

import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import media from '@ohos.multimedia.media';
import wantAgent from '@ohos.wantAgent';
import SourceType from '@ohos.notification'
import NotificationService from '../model/NotificationService.ets'
import NotificationWindowManager from '../model/NotificationWindowManager.ets';
import NotificationConfig from '../model/NotificationConfig.ets';
import CheckEmptyUtils from '../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import CommonUtil from '../common/CommonUtil.ets';
import Constants from '../common/constants.ets';

const TAG = 'NotificationViewModel';
const GROUP_THRESHOLD = 10;
/**
 * Notification ViewModel class.
 */
export class ViewModel {
  audioPlayer: any
  mNotificationList: any[];
  mAppNotificationCount: any;
  mCallback: any;
  mNotificationCtrl: any = {}

  constructor() {
    let tempLink = AppStorage.SetAndLink('notificationList', []);
    this.mNotificationList = tempLink.get();
    this.mAppNotificationCount = new Map();
    this.audioPlayer = media.createAudioPlayer();
    this.audioPlayer.src = 'file://system/etc/Light.ogg';
    this.registerCallback();
    this.loadFlowControlInfos()
  }

  registerCallback() {
    this.mCallback = {
      onNotificationConsume: this.onNotificationConsume.bind(this),
      onNotificationCancel: this.onNotificationCancel.bind(this),
      onNotificationLoad: this.onNotificationLoad.bind(this)
    }
    NotificationService.register(this.mCallback);
  }

  unregisterCallback() {
    NotificationService.unRegister(this.mCallback);
  }


  /**
   * notification CancelCallback
   *
   * @param {Object} data - return notificationItemData.
   */
  onNotificationConsume(notificationItemData) {
    Log.showInfo(TAG, `onNotificationConsume  ${JSON.stringify(notificationItemData)}`);
    //Verify the notifications can be displayed
    if (!this.isCanShow(notificationItemData.bundleName)) {
      //can not displayed
      return;
    }
    if (!this.mAppNotificationCount.has(notificationItemData.appName)) {
      this.mAppNotificationCount.set(notificationItemData.appName, 0);
    }
    this.mAppNotificationCount[notificationItemData.appName] += 1;
    if (this.mAppNotificationCount[notificationItemData.appName] >= GROUP_THRESHOLD) {
      this.groupNotification(notificationItemData, this.mAppNotificationCount[notificationItemData.appName]);
    } else {
      // Todo Sort Insert
      this.mNotificationList.unshift(notificationItemData);
      this.updateFlowControlInfos(notificationItemData.bundleName, true)
      this.updateNotification();
    }
    // Todo doAction(notificationItemData);
  }

  /**
   * notification CancelCallback
   */
  onNotificationCancel(notificationItemData) {
    Log.showInfo(TAG, `onNotificationCancel  ${JSON.stringify(notificationItemData)}`);
    if (this.mAppNotificationCount[notificationItemData.appName] >= GROUP_THRESHOLD) {
      //Group Notification Deletion Logic Processing
      return;
    }
    // Common Notification Deletion Logic Processing
    for (let i = 0, len = this.mNotificationList.length; i < len; i++) {
      if (this.mNotificationList[i].hashcode == notificationItemData.hashcode) {
        Log.showInfo(TAG, `removeNotificationItem i = ${i}`);
        this.mAppNotificationCount[notificationItemData.appName] -= 1;
        let removeItemArr = this.mNotificationList.splice(i, 1);
        Log.showInfo(TAG, `onNotificationCancel removeItemArr= ${JSON.stringify(removeItemArr)}`);
        if (!CheckEmptyUtils.isEmpty(removeItemArr)) {
          this.updateFlowControlInfos(removeItemArr[0].bundleName, false)
        }
        break;
      }
    }
  }

  onNotificationLoad() {

  }


  /**
   * notification CancelCallback
   *
   * @param {Object} data - return notificationItemData.
   */
  groupNotification(notificationItemData, num) {
    if (num == GROUP_THRESHOLD) {
      //Group Notification Conversion
    } else {
      //Group Notification Add
    }
  }

  updateNotification() {
    Log.showInfo(TAG, `updateNotification  list: ${JSON.stringify(this.mNotificationList)}`);
    Log.showInfo(TAG, `updateNotification  len: ${this.mNotificationList.length}`);
    this.sortNotification()
    let listLink = AppStorage.Link('notificationList');
    listLink.set(this.mNotificationList);
    Log.showInfo(TAG, `updateNotification  list: ${JSON.stringify(listLink.get())}`);
  }

  /**
   * Sort the notifications.
   */
  sortNotification() {
    Log.showInfo(TAG, `sortNotification`);
    if (this.mNotificationList == undefined || this.mNotificationList == null || this.mNotificationList.length < 1) {
      return
    }
    this.mNotificationList.sort((itemA, itemB) => {
      //long term notification come first
      if (itemA.source == SourceType.TYPE_CONTINUOUS && itemB.source != SourceType.TYPE_CONTINUOUS) {
        return -1
      }
      //long term notification come first
      if (itemA.source != SourceType.TYPE_CONTINUOUS && itemB.source == SourceType.TYPE_CONTINUOUS) {
        return 1
      }
      if ((itemA.source == SourceType.TYPE_CONTINUOUS && itemB.source == SourceType.TYPE_CONTINUOUS) ||
      (itemA.source != SourceType.TYPE_CONTINUOUS && itemB.source != SourceType.TYPE_CONTINUOUS)
      ) {
        return -1 * (itemA.timestamp - itemB.timestamp)
      }
    })
  }

  /**
   * Remove all notifications.
   */
  removeAllNotifications() {
    if (this.mNotificationList == undefined || this.mNotificationList == null || this.mNotificationList.length < 1) {
      this.mNotificationList = []
    } else {

      let index = this.mNotificationList.length
      while (index--) {
        Log.showInfo(TAG, `mNotificationList[${index}].source: ${this.mNotificationList[index].source}`);
        //Except the Long term notifications
        if (this.mNotificationList[index].source != SourceType.TYPE_CONTINUOUS) {
          Log.showInfo(TAG, `mNotificationList[${index}].hashcode: ${this.mNotificationList[index].hashcode}`);
          let hashCode = this.mNotificationList[index].hashcode
          this.removeSysNotificationItem(hashCode)
          let removeItemArr = this.mNotificationList.splice(index, 1)
          Log.showInfo(TAG, `removeAllNotifications removeItemArr= ${JSON.stringify(removeItemArr)}`);
          if (!CheckEmptyUtils.isEmpty(removeItemArr)) {
            this.updateFlowControlInfos(removeItemArr[0].bundleName, false)
          }
        }
      }
    }
    this.updateNotification()
  }

  removeNotificationItem(itemData, isDelSysConent) {
    Log.showInfo(TAG, `removeNotificationItem, hashcode: ${itemData.hashcode}`);
    for (let i = 0, len = this.mNotificationList.length; i < len; i++) {
      if (this.mNotificationList[i].hashcode == itemData.hashcode) {
        Log.showInfo(TAG, `removeNotificationItem i = ${i}`);
        this.mAppNotificationCount[itemData.appName] -= 1;
        let removeItemArr = this.mNotificationList.splice(i, 1);
        Log.showInfo(TAG, `removeNotificationItem removeItemArr= ${JSON.stringify(removeItemArr)}`);
        if (!CheckEmptyUtils.isEmpty(removeItemArr)) {
          this.updateFlowControlInfos(removeItemArr[0].bundleName, false)
        }
        break;
      }
    }
    this.updateNotification();
    if (isDelSysConent) {
      this.removeSysNotificationItem(itemData.hashcode);
    }
    AppStorage.Delete(Constants.KEY_INPUT + itemData.id);
  }

  removeSysNotificationItem(hashcode) {
    NotificationService.remove(hashcode);
  }

  clickItem(itemData, want?: any) {
    Log.showInfo(TAG, `clickItem itemId: ${itemData.id}, want: ${JSON.stringify(want)}`);
    NotificationWindowManager.hideNotificationWindow();
    CommonUtil.startWant((want) ? want : itemData.want);
    this.removeNotificationItem(itemData, true);
  }

  clickReply(inputKey, content, want) {
    Log.showInfo(TAG, `clickReply inputKey: ${inputKey}, content: ${content}, want: ${JSON.stringify(want)}`);
    let info = {
      code: 0,
      want: { key: inputKey, data: content },
      permission: '',
      extraInfo: {}
    }
    CommonUtil.startWant(want, info);
  }

  loadFlowControlInfos() {
    Log.showInfo(TAG, 'loadFlowControlInfos enter');
    let notificationConfig = NotificationConfig.readNotificationConfig('statusbar')
    Log.showInfo(TAG, 'NotificationConfig: ' + JSON.stringify(notificationConfig));
    if (CheckEmptyUtils.isEmpty(notificationConfig)) {
      Log.showInfo(TAG, 'NotificationConfig is no definition');
      Log.showInfo(TAG, 'loadFlowControlInfos end');
      return
    }

    this.mNotificationCtrl['currentTotal'] = 0;
    this.mNotificationCtrl['limitTotal'] = notificationConfig.limitTotal
    this.mNotificationCtrl['app'] = new Map();
    for (let item of notificationConfig.app) {
      let tmp = {
        'canShow': item.canShow,
        'currentNum': 0,
        'limit': item.limit
      }
      this.mNotificationCtrl['app'].set(item.bundleName, tmp);
    }
    Log.showInfo(TAG, 'mNotificationCtrl: ' + JSON.stringify(this.mNotificationCtrl));
    Log.showInfo(TAG, 'loadFlowControlInfos end');
  }

  isCanShow(bundleName: string): boolean {
    Log.showInfo(TAG, 'isCanShow');
    let result: boolean = true
    if (!CheckEmptyUtils.isEmpty(this.mNotificationCtrl)) {
      let currentTotal = this.mNotificationCtrl['currentTotal']
      let limitTotal = this.mNotificationCtrl['limitTotal']
      Log.showInfo(TAG, `isCanShow Total: currentTotal=${currentTotal},limitTotal=${limitTotal}`);
      if (currentTotal + 1 > limitTotal) {
        result = false
      } else if (this.mNotificationCtrl['app'].has(bundleName)) {
        let tmp = this.mNotificationCtrl['app'].get(bundleName)
        Log.showInfo(TAG, `isCanShow appTotal: canShow=${tmp['canShow']},tmp['currentNum']=${tmp['currentNum']}`);
        if (tmp['canShow'] === false || (tmp['currentNum'] + 1 > tmp['limit'])) {
          result = false
        }
      }
    }
    Log.showInfo(TAG, `isCanShow :${result}`);
    return result;
  }

  updateFlowControlInfos(bundleName: string, plusOrMinus: boolean): void {
    Log.showInfo(TAG, `updateFlowControlInfos`);
    if (!CheckEmptyUtils.isEmpty(this.mNotificationCtrl)) {
      if (this.mNotificationCtrl['app'].has(bundleName)) {
        let tmp = this.mNotificationCtrl['app'].get(bundleName)
        if (plusOrMinus) {
          tmp['currentNum'] += 1
        } else if (tmp['currentNum'] > 0) {
          tmp['currentNum'] -= 1
        }
        this.mNotificationCtrl['app'].set(bundleName, tmp)
      }

      if (plusOrMinus) {
        this.mNotificationCtrl['currentTotal'] += 1
      } else if (this.mNotificationCtrl['currentTotal'] > 0) {
        this.mNotificationCtrl['currentTotal'] -= 1
      }
    }

    Log.showInfo(TAG, `updateFlowControlInfos:${JSON.stringify(this.mNotificationCtrl)}`);
  }

}

let viewModel = new ViewModel();

export default viewModel as ViewModel;
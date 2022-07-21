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

import Log from '../../../../../../../common/src/main/ets/default/Log'
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilitymanager'
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/windowmanager'
import EventManager, {unsubscribe} from "../../../../../../../common/src/main/ets/default/event/eventmanager"
import BannerNotification from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeitem/view/item/bannernotificationitem'
import ViewModel from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeitem/viewmodel/viewmodel';
import NotificationConstants, { ScreenLockStatus } from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeitem/common/constants';

const TAG = 'NotificationPanel-BannerNotification'


@Entry
@Component
struct Index {
  @State distributedDeviceName: string = '';
  @State mBannerNoticeCnt: number = 0;
  @State mLastActionTime: number = 0;
  @State needExpand: boolean = true
  @State isExpand: boolean = false;
  @State pageData: any = {};

  mClearCallbacks: unsubscribe[]
  mDefaultBannerRect: any;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
    AbilityManager.setContextName(AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL,AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL);
    setAppBgColor('#00000000')
    this.mClearCallbacks = []
    this.mClearCallbacks.push(EventManager.subscribe('onBannerNoticeShow', () => this.onBannerNoticeShow()))
    this.mClearCallbacks.push(EventManager.subscribe('onBannerNoticeHide', () => this.onBannerNoticeHide()))
    Log.showDebug(TAG, `aboutToAppear End`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
    this.mClearCallbacks.forEach((mClearCallback: Function) => {
      mClearCallback()
      mClearCallback = undefined
    })
    this.mClearCallbacks = undefined
  }

  build() {
    Column() {
      Column() {
        if (this.mBannerNoticeCnt > 0) {
          BannerNotification({
            want: this.pageData,
            distributedDeviceName: $distributedDeviceName,
            mLastActionTime: $mLastActionTime,
            mBannerNoticeCnt: $mBannerNoticeCnt,
            needExpand: $needExpand,
            isExpand: $isExpand,
            onBannerNoticeHide: () => this.onBannerNoticeHide()
          })
        } else {
          Blank()
        }
      }
    }
    .width('100%')
    .height('100%')
    .clip(true)
  }

  onBannerNoticeShow() {
    Log.showDebug(TAG, `onBannerNoticeShow start`);
    let winInfoNotice = WindowManager.getWindowInfo(WindowType.NOTIFICATION_PANEL);
    let bannerDisabledFlg = false;
    let screenLockStatusInfo = AppStorage.Link('lockStatus');
    let screenLockStatus = ScreenLockStatus.Unlock;
    if (!!screenLockStatusInfo) {
      screenLockStatus = screenLockStatusInfo.get();
    }
    if (screenLockStatus == ScreenLockStatus.Locking) {
      bannerDisabledFlg = true;
    } else if (winInfoNotice) {
      if (winInfoNotice.visibility) {
        bannerDisabledFlg = true;
      }
    }
    WindowManager.hideWindow(WindowType.BANNER_NOTICE);
    if (bannerDisabledFlg) {
      Log.showDebug(TAG, `onBannerNoticeShow end`);
      return;
    }
    this.pageData = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_BANNER_NOTICE, 'itemData');
    ViewModel.getDistributedDeviceName(this.pageData).then((deviceName) => {
      this.distributedDeviceName = deviceName;
    })
    this.needExpand = this.checkItemNeedExpand()
    this.isExpand = false;
    this.mBannerNoticeCnt++;
    this.mLastActionTime = (new Date()).getTime();
    Log.showDebug(TAG, `onBannerNoticeShow count:` + this.mBannerNoticeCnt);
    Log.showDebug(TAG, `onBannerNoticeShow pageData:${JSON.stringify(this.pageData)}`);

    WindowManager.resetSizeWindow(WindowType.BANNER_NOTICE, this.mDefaultBannerRect);
    WindowManager.showWindow(WindowType.BANNER_NOTICE);
    Log.showDebug(TAG, `onBannerNoticeShow end`);
  }

  onBannerNoticeHide() {
    this.mBannerNoticeCnt = 0;
    WindowManager.resetSizeWindow(WindowType.BANNER_NOTICE, this.mDefaultBannerRect);
    WindowManager.hideWindow(WindowType.BANNER_NOTICE);
  }

  checkItemNeedExpand() {
    if (this.pageData.contentType === NotificationConstants.NOTIFICATION_TYPE_BASIC
    && (!(this.pageData.actionButtons?.length > 0))) {
      return false;
    } else {
      return true;
    }
  }

}

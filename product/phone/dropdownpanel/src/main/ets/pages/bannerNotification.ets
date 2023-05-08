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

import Log from '../../../../../../../common/src/main/ets/default/Log';
import {notificationData} from '../../../../../../../common/src/main/ets/plugindatasource/common/Constants'
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import WindowManager, { WindowType } from '../../../../../../../common/src/main/ets/default/WindowManager';
import EventManager, {unsubscribe} from "../../../../../../../common/src/main/ets/default/event/EventManager";
import BannerNotification from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/view/item/bannerNotificationItem';
import NotificationViewModel from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/viewmodel/NotificationViewModel';
import NotificationConstants, { ScreenLockStatus } from '../../../../../../../features/noticeitem/src/main/ets/com/ohos/noticeItem/common/constants';

const TAG = 'DropdownPanel-BannerNotification';
const TRANSLATE_SIZE = '382vp';
const ANIM_CONFIG = {
  duration: 250,
  tempo: 1.0,
  curve: Curve.Friction,
  delay: 0,
  iterations: 1,
  playMode: PlayMode.Normal,
}
const OPACITY_SHOW_ANIM_CONFIG = {
  duration: 200,
  tempo: 1.0,
  curve: Curve.Friction,
  delay: 0,
  iterations: 1,
  playMode: PlayMode.Normal,
}
const OPACITY_HIDE_ANIM_CONFIG = {
  duration: 200,
  tempo: 1.0,
  curve: Curve.Friction,
  delay: 50,
  iterations: 1,
  playMode: PlayMode.Normal,
}

@Entry
@Component
struct Index {
  @State distributedDeviceName: string = '';
  @State mBannerNoticeCnt: number = 0;
  @State mLastActionTime: number = 0;
  @State needExpand: boolean = true
  @State isExpand: boolean = false;
  @State pageData: notificationData = new notificationData();
  @State mOpacity: number = 0.0;
  @State mWidthSize: number = 0.8;
  @State mTranslate: string = TRANSLATE_SIZE;

  mClearCallbacks: unsubscribe[]
  mDefaultBannerRect: any;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
    AbilityManager.setContextName(AbilityManager.ABILITY_NAME_NOTIFICATION_PANEL,AbilityManager.ABILITY_NAME_DROPDOWN_PANEL);
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
    .opacity(this.mOpacity)
    .scale({
      x: this.mWidthSize,
      centerX: '100%'
    })
    .translate({x: this.mTranslate})
  }

  onBannerNoticeShow() {
    Log.showDebug(TAG, `onBannerNoticeShow start`);
    let windowInfoDrop = WindowManager.getWindowInfo(WindowType.DROPDOWN_PANEL);
    let bannerDisabledFlg = false;
//    let screenLockStatusInfo = AppStorage.Link('lockStatus');
//    let screenLockStatus = ScreenLockStatus.Unlock;
//    if (!!screenLockStatusInfo) {
//      screenLockStatus = screenLockStatusInfo.get();
//    }
//    if (screenLockStatus == ScreenLockStatus.Locking) {
//      bannerDisabledFlg = true;
//    } else
      if (windowInfoDrop) {
      if (windowInfoDrop.visibility) {
        bannerDisabledFlg = true;
      }
    }
    WindowManager.hideWindow(WindowType.BANNER_NOTICE);
    if (bannerDisabledFlg) {
      Log.showDebug(TAG, `onBannerNoticeShow end`);
      return;
    }
    this.pageData = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_BANNER_NOTICE, 'itemData');
    NotificationViewModel.getDistributedDeviceName(this.pageData).then((deviceName) => {
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
    this.showWindowAnim();
  }

  onBannerNoticeHide() {
    this.hideWindowAnim();
  }

  checkItemNeedExpand() {
    if (this.pageData.contentType === NotificationConstants.NOTIFICATION_TYPE_BASIC
    && (!(this.pageData.actionButtons?.length > 0))) {
      return false;
    } else {
      return true;
    }
  }

  _animateTo(config, callback) {
    animateTo(config, callback);
    setTimeout(config.onFinish, config.duration + config.delay);
  }

  showWindowAnim() {
    Log.showDebug(TAG, `show anim start`);
    this._animateTo({ ...ANIM_CONFIG, onFinish: () => {
      Log.showInfo(TAG, `show anim finish`);
    } }, () => {
      Log.showInfo(TAG, `do show anim`);
      this.mWidthSize = 1.0;
      this.mTranslate = '0vp';
    });
    this._animateTo({ ...OPACITY_SHOW_ANIM_CONFIG, onFinish: () => {
    } }, () => {
      this.mOpacity = 1.0;
    });
  }

  hideWindowAnim() {
    Log.showDebug(TAG, `hide  anim start`);
    this._animateTo({ ...ANIM_CONFIG, onFinish: () => {
      Log.showInfo(TAG, `hide anim finish`);
      this.mBannerNoticeCnt = 0;
      WindowManager.resetSizeWindow(WindowType.BANNER_NOTICE, this.mDefaultBannerRect);
      WindowManager.hideWindow(WindowType.BANNER_NOTICE);
    }
    }, () => {
      Log.showInfo(TAG, `do hide anim`);
      this.mWidthSize = 0.8;
      this.mTranslate = TRANSLATE_SIZE;
    });
    this._animateTo({ ...OPACITY_HIDE_ANIM_CONFIG, onFinish: () => {}
    }, () => {
      this.mOpacity = 0.0;
    });
  }
}

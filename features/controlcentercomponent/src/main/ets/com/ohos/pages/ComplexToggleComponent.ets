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

import Log from '../../../../../../../../common/src/main/ets/default/Log';
import EventManager from '../../../../../../../../common/src/main/ets/default/event/EventManager';
import iconTitleBase from '../../../../../../../../common/src/main/ets/template/iconTitleBase';
import Constants from '../common/Constants';

const TAG = 'ComplexToggleComponent';

@Component
export default struct ComplexToggleComponent {
  @Prop keyId: string;
  @State mItemData: any = {};
  @State mStatus: boolean = false;
  @State mDefaultTitle: string = '';

  aboutToAppear() {
    Log.showDebug(TAG, `aboutToAppear Start, keyId: ${this.keyId}`);
    this.linkItemData();
  }

  aboutToDisappear() {
    Log.showDebug(TAG, `aboutToDisappear`);
  }

  linkItemData() {
    Log.showInfo(TAG, `linkItemData, keyId: ${this.keyId}`);
    this.mItemData = AppStorage.Link('ControlCenter_' + this.keyId);
    Log.showInfo(TAG, `linkItemData, mItemData: ${this.keyId} ${this.mItemData.get().label} ${this.mItemData.get().iconUrl}`);
  }

  build() {
    Column() {
      iconTitleBase({
        useTitleStr: true,
        mTitle: $mDefaultTitle,
        mTitleStr: this.mItemData.get()
        .label,
        useIconStr: true,
        iconOffStr: this.mItemData.get()
        .iconUrl,
        iconOnStr: this.mItemData.get()
        .iconUrl,
        changeSwitch: $mStatus,
        mClickEvent: () => this.onIconItemClick(),
        mLongClickEvent: () => this.onIconItemLongPressGesture()
      })
    }.width('100%')
    .height('100%')
  }

  onIconItemClick() {
    Log.showInfo(TAG, `onIconItemClick`);
    if (this.mItemData.get()?.actionData?.clickAction) {
      EventManager.publish(this.mItemData.get().actionData.clickAction);
    }
  }

  onIconItemLongPressGesture() {
    Log.showInfo(TAG, `onIconItemLongPressGesture`);
    if (this.mItemData.get()?.actionData?.longClickAction) {
      EventManager.publish(this.mItemData.get().actionData.longClickAction);
    }
  }
}
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
import SimpleToggleBase from '../../../../../../../../common/src/main/ets/template/SimpleToggleBase';

const TAG = 'SimpleToggleComponent';

@Component
export default struct SimpleToggleComponent {
  private keyId: string;
  @State mItemData: any = {};
  private mEditMode: boolean = false;
  private mDragMode: boolean = false;
  @State mDefaultIcon: Resource = $r("app.media.icon");
  @State mDefaultChangeSwitch: boolean  = false;
  @State mDefaultLabel: string = '';

  aboutToAppear() {
    Log.showDebug(TAG, `aboutToAppear Start, keyId: ${this.keyId}, mEditMode: ${this.mEditMode} mDragMode: ${this.mDragMode}`);
    this.linkItemData();
  }

  aboutToDisappear() {
    Log.showDebug(TAG, `aboutToDisappear`);
  }

  linkItemData() {
    Log.showDebug(TAG, `linkItemData, keyId: ${this.keyId}`);
    this.mItemData = AppStorage.Link('ControlCenter_' + this.keyId);
    Log.showDebug(TAG, `linkItemData, mItemData: ${this.keyId} ${this.mItemData.get().label} ${this.mItemData.get().iconUrl}`);
  }

  build() {
    Column() {
      SimpleToggleBase({
        mToggleId: this.keyId,
        mIcon: $mDefaultIcon,
        mIconStr: this.mItemData.get().iconUrl,
        mUseIconStr: true,
        mChangeSwitch: this.mDefaultChangeSwitch,
        mLabel: $mDefaultLabel,
        mLabelStr: this.mItemData.get().label,
        mUseLabelStr: true,
        mEditMode: this.mEditMode,
        mDragMode: this.mDragMode,
        mClickEvent: () => this.onIconItemClick(),
        mLongClickEvent: () => this.onIconItemLongPressGesture()
      })
    }.width('100%')
    .height('100%')
  }

  onIconItemClick() {
    Log.showDebug(TAG, `onIconItemClick`);
    if (this.mItemData.get()?.actionData?.clickAction) {
      EventManager.publish(this.mItemData.get().actionData.clickAction);
    };
  }

  onIconItemLongPressGesture() {
    Log.showDebug(TAG, `onIconItemLongPressGesture`);
    if (this.mItemData.get()?.actionData?.longClickAction) {
      EventManager.publish(this.mItemData.get().actionData.longClickAction);
    };
  }
}
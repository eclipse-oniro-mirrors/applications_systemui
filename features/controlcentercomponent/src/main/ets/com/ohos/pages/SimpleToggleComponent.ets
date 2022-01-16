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

import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import FeatureAbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/featureAbilityManager.ets'
import WindowManager from '../../../../../../../../common/src/main/ets/default/WindowManager.ets'
import SimpleToggleBase from '../../../../../../../../common/src/main/ets/template/SimpleToggleBase.ets'

const TAG = 'SimpleToggleComponent'

@Component
export default struct SimpleToggleComponent {
  @Prop keyId: string
  @State mItemData: any = {}
  @StorageLink("showStatusBar") showStatusBar: boolean = false
  @Prop mShowLabel: boolean
  @Prop mEditMode: boolean
  private mWindowManager
  private mFeatureAbilityManager
  @State mDefaultIcon: Resource = $r("app.media.icon")
  @State mDefaultChangeSwitch: boolean  = false
  @State mDefaultLabel: string = ''

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start, keyId: ${this.keyId}`)
    Log.showInfo(TAG, `aboutToAppear Start, mShowLabel: ${this.mShowLabel} mEditMode: ${this.mEditMode}`)
    this.mWindowManager = new WindowManager()
    this.mFeatureAbilityManager = new FeatureAbilityManager()
    this.linkItemData()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  linkItemData() {
    Log.showInfo(TAG, `linkItemData, keyId: ${this.keyId}`)
    this.mItemData = AppStorage.Link(this.keyId)
    Log.showInfo(TAG, `linkItemData, mItemData: ${this.keyId} ${this.mItemData.get().label} ${
    this.mItemData.get()
    .iconUrl}`)
  }

  build() {
    SimpleToggleBase({
      mToggleId: this.keyId,
      mIcon: $mDefaultIcon,
      mIconStr: this.mItemData.get().iconUrl,
      mUseIconStr:true,
      mChangeSwitch: $mDefaultChangeSwitch,
      mLabel: $mDefaultLabel,
      mLabelStr: this.mItemData.get().label,
      mUseLabelStr: true,
      mShowLabel: this.mShowLabel,
      mEditMode: this.mEditMode,
      mClickEvent: this.onIconItemClick.bind(this),
      mLongClickEvent: this.onIconItemLongPressGesture.bind(this)
    })
  }

  onIconItemClick() {
    Log.showInfo(TAG, `onIconItemClick`)
    if (this.mItemData.get().actionData && this.mItemData.get().actionData.clickAction) {
      this.startAbility(this.mItemData.get().actionData.clickAction)
    }
  }

  onIconItemLongPressGesture() {
    Log.showInfo(TAG, `onIconItemLongPressGesture`)
    if (this.mItemData.get().actionData && this.mItemData.get().actionData.longClickAction) {
      this.startAbility(this.mItemData.get().actionData.longClickAction)
    }
  }

  startAbility(action) {
    Log.showInfo(TAG, `startAbility, action: ${action}`)
    let actionInfos = action.split('&')
    let wantParam = {
      parameters: {}
    }
    for (let actionInfoStr of actionInfos) {
      let actionInfo = actionInfoStr.split('=')
      if (actionInfo[0] == 'want') {
        wantParam['bundleName'] = actionInfo[1].split('/')[0]
        wantParam['abilityName'] = actionInfo[1].split('/')[1]
      } else {
        wantParam.parameters[actionInfo[0]] = actionInfo.length > 1 ? actionInfo[1] : actionInfo[0]
      }
    }
    Log.showInfo(TAG, `startAbility, want: ${JSON.stringify(wantParam)}`)

    this.showStatusBar = true
    this.mWindowManager.setWindowMin((result) => {
      this.mFeatureAbilityManager.openAbility(TAG, {
        want: wantParam
      })
    })
  }
}
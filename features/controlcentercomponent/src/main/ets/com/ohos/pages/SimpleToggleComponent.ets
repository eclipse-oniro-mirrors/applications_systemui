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
import FeatureAbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/featureAbilityManager.ets';
import WindowManager from '../../../../../../../../common/src/main/ets/default/WindowManager.ets'
import CheckEmptyUtils from '../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets'
import iconTitleBase from '../../../../../../../../common/src/main/ets/template/iconTitleBase.ets'
import UniformConfig from '../../../../../../../../common/src/main/ets/template/UniformConfig.ets'
import Constants from '../common/Constants.ets'

const TAG = 'SimpleToggleComponent'

@Component
export default struct SimpleToggleComponent {
  @Prop keyId: string
  @State mItemData: any = {}
  @Link showStatusBar: boolean
  private mWindowManager
  private mFeatureAbilityManager
  private mConfig = UniformConfig.config;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start, keyId: ${this.keyId}`)
    this.mItemData = AppStorage.Link(this.keyId)
    Log.showInfo(TAG, `aboutToAppear, mItemData: ${this.mItemData.get().iconUrl} ${this.mItemData.get().label}`)
    this.mWindowManager = new WindowManager();
    this.mFeatureAbilityManager = new FeatureAbilityManager();
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`)
    let deleteRs: boolean = AppStorage.Delete(this.keyId)
    Log.showInfo(TAG, `aboutToDisappear AppStorage.Delete, ${deleteRs} key: ${this.keyId}`)
  }

  build() {
    Column({ space: Constants.SIMPLE_TOGGLE_INSIDE_SPACE }) {
      Stack() {
        Flex()
          .backgroundColor(this.mConfig.iconOffBG)
          .clip(new Circle({ width: this.mConfig.circleWidth, height: this.mConfig.circleHeight }))
          .width(this.mConfig.circleWidth)
          .height(this.mConfig.circleHeight)
        Image(this.mItemData.get()
        .iconUrl)
          .size({ width: Constants.SIMPLE_TOGGLE_ICON_WIDTH, height: Constants.SIMPLE_TOGGLE_ICON_HEIGHT })
          .objectFit(ImageFit.Contain)
      }.onClick(this.onIconItemClick.bind(this))
      .gesture(LongPressGesture({ repeat: false }).onAction(this.onIconItemLongPressGesture.bind(this)))

      Text(this.mItemData.get()
      .label)
        .fontSize($r('app.float.icon_item_fontsize'))
    }
  }

  onIconItemClick(event: ClickEvent) {
    Log.showInfo(TAG, `onIconItemClick`)
    if (this.mItemData.get().actionData && this.mItemData.get().actionData.clickAction) {
      this.startAbility(this.mItemData.get().actionData.clickAction)
    }
  }

  onIconItemLongPressGesture(event: GestureEvent) {
    Log.showInfo(TAG, `onIconItemLongPressGesture, event: ${JSON.stringify(event)}`)
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

    this.showStatusBar = true;
    this.mWindowManager.setWindowMin((result) => {
      this.mFeatureAbilityManager.openAbility(TAG, {
        want: wantParam
      });
    });
  }
}
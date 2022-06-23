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

import Log from '../../../../../../../../common/src/main/ets/default/Log'
import {TintContentInfo} from '../../../../../../../../common/src/main/ets/default/TintStateManager'
import CheckEmptyUtils from '../../../../../../../../common/src/main/ets/default/CheckEmptyUtils'
import ViewModel from '../viewmodel/StatusBarVM'
import StyleConfigurationCommon from '../../../../../../../../common/src/main/ets/default/StyleConfiguration'
import StyleConfiguration from '../common/StyleConfiguration'

const TAG = 'MetaIconItemComponent'

@Component
export default struct MetaIconItemComponent {
  private keyId: string
  @State mItemData: any = {}
  @State mTintContentInfo: TintContentInfo = new TintContentInfo()
  @State style: any = StyleConfiguration.getIconItemComponentStyle()
  @State styleCommon: any = StyleConfigurationCommon.getCommonStyle()

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start, keyId: ${this.keyId}`);
    this.linkItemData()
    this.mTintContentInfo = ViewModel.getPluginTintContentInfo(this.keyId)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
  }

  linkItemData() {
    this.mItemData = AppStorage.Link('StatusBar_' + this.keyId);
    Log.showInfo(TAG, `linkItemData, mItemData: ${this.keyId} ${this.mItemData.get().label} ${
    this.mItemData.get()
    .iconUrl}`)
  }

  build() {
    Row() {
      if ((this.mItemData.get().isShowLabel && !CheckEmptyUtils.isEmpty(this.mItemData.get().label))
      || (this.mItemData.get().isShowIcon && !CheckEmptyUtils.isEmpty(this.mItemData.get().iconUrl))) {
        Row().width(this.style.stackPadding).height('100%')
      }
      if (this.mItemData.get().isShowLabel && !CheckEmptyUtils.isEmpty(this.mItemData.get().label)) {
        Text(this.mItemData.get()
        .label)
          .fontColor(this.mTintContentInfo.contentColor)
          .fontSize(this.styleCommon.statusBarFontSize)
          .textAlign(TextAlign.End)
      }
      if (this.mItemData.get().isShowLabel && !CheckEmptyUtils.isEmpty(this.mItemData.get().label)) {
        if (this.mItemData.get().isShowIcon && !CheckEmptyUtils.isEmpty(this.mItemData.get().iconUrl)) {
          Row() {
          }.height(1).width(this.style.componentSpace)
        }
      }
      if (this.mItemData.get().isShowIcon && !CheckEmptyUtils.isEmpty(this.mItemData.get().iconUrl)) {
        Image(this.mItemData.get()
        .iconUrl)
          .width(this.style.iconWidth)
          .height(this.style.iconHeight)
          .fillColor(this.mTintContentInfo.contentColor)
          .objectFit(ImageFit.Contain)
      }
      if ((this.mItemData.get().isShowLabel && !CheckEmptyUtils.isEmpty(this.mItemData.get().label))
      || (this.mItemData.get().isShowIcon && !CheckEmptyUtils.isEmpty(this.mItemData.get().iconUrl))) {
        Row().width(this.style.stackPadding).height('100%')
      }
    }.height('100%')
  }
}
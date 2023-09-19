/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import StyleConfigurationCommon, { CommonStyle } from '../../../../../../../common/src/main/ets/default/StyleConfiguration'
import { TintContentInfo } from '../../../../../../../common/src/main/ets/default/TintStateManager';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import StyleConfiguration, { StatusBarAirplaneComponentStyle } from '../common/StyleConfiguration'
import ViewModel from '../viewmodel/AirplaneVM'

const TAG = 'airplane-StatusBarIconItemAirplaneComponent';

@Component
export default struct StatusBarIconItemAirplaneComponent {
  @StorageLink('Airplane_Status') airplaneStatus: boolean = false;
  @State mTintContentInfo: TintContentInfo = ViewModel.getTintContentInfo();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: StatusBarAirplaneComponentStyle = StyleConfiguration.getStatusBarAirplaneComponentStyle();

  aboutToAppear() {
    ViewModel.startVM();
  }

  build() {
    Row() {
      if (this.airplaneStatus) {
        Row().width(this.styleCommon.statusBarMarginLeftRight).height('100%')
        Image($r("app.media.airplane"))
          .objectFit(ImageFit.Contain)
          .width(this.style.statusBarAirplaneWidth)
          .height(this.style.statusBarAirplaneHeight)
          .fillColor(this.mTintContentInfo.contentColor)
        Row().width(this.styleCommon.statusBarMarginLeftRight).height('100%')
      }
    }
    .height('100%')
    .opacity($r("app.float.icon_component_opacity"))
  }
}

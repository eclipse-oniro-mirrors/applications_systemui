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
import { TintContentInfo } from '../../../../../../../common/src/main/ets/default/TintStateManager'
import StyleConfiguration, { ClockComponentStyle } from '../common/StyleConfiguration'
import StyleConfigurationCommon, { CommonStyle
} from '../../../../../../../common/src/main/ets/default/StyleConfiguration'
import ViewModel from '../viewmodel/ClockVM'
import TimeManager, {
  TimeEventArgs,
  TIME_CHANGE_EVENT,
} from '../../../../../../../common/src/main/ets/default/TimeManager'
import EventManager, { unsubscribe } from '../../../../../../../common/src/main/ets/default/event/EventManager'

const TAG = 'ClockComponent-clockIcon';

@Component
export default struct ClockIcon {
  @State mTime: string = '16:01';
  @State mTintContentInfo: TintContentInfo = ViewModel.getTintContentInfo();
  @State style: ClockComponentStyle = StyleConfiguration.getClockComponentStyle();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  unSubscriber?: unsubscribe;

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear');
    this.unSubscriber = EventManager.subscribe(TIME_CHANGE_EVENT, (args: TimeEventArgs) => {
      this.mTime = TimeManager.formatTime(args.date);
    });
    this.mTime = TimeManager.formatTime(new Date());
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
    this.unSubscriber && this.unSubscriber();
    this.unSubscriber = undefined;
  }

  build() {
    Row() {
      Row().width(this.styleCommon.statusBarMarginLeftRight).height('100%')
      Text(this.mTime)
        .fontColor(this.mTintContentInfo.contentColor)
        .fontSize($r("sys.float.ohos_id_text_size_body2"))
        .width(this.style.statusBarClockMaxWidth)
        .textAlign(TextAlign.Center)
        .margin({ left: $r("app.float.mTime_text_margin_left") })
      Row().width(this.styleCommon.statusBarMarginLeftRight).height('100%')
    }.opacity($r("app.float.icon_component_opacity"))
  }
}
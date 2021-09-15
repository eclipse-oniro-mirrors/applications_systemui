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

import Constants from '../common/constants.ets'
//import featureAbility from '@ohos.ability.featureability';
import BatteryIcon from '../../../../../../../features/batterycomponent/src/main/ets/default/pages/batteryIcon.ets'
import ClockIcon from '../../../../../../../features/clockcomponent/src/main/ets/default/pages/clockIcon.ets'
import WifiIcon from '../../../../../../../features/wificomponent/src/main/ets/default/pages/wifiIcon.ets'
import SignalIcon from '../../../../../../../features/signalcomponent/src/main/ets/default/pages/signalIcon.ets'

@Component
export default struct Index {
  private leftGroupOrder : any
  private rightGroupOrder : any
  private notificationList : any

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        ForEach(this.leftGroupOrder, (item: string) => {
          if (item == Constants.WIFI) {
            WifiIcon()
          }
          if (item == Constants.SIGNAL) {
            SignalIcon()
          }
          if (item == Constants.CLOCK) {
            ClockIcon()
          }
          if (item == Constants.BATTERY) {
            BatteryIcon()
          }
        })
      }
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        ForEach(this.notificationList, (item: any) => {
          Image(item.icon).objectFit(ImageFit.ScaleDown).height('50%')
        })
      }
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        ForEach(this.rightGroupOrder, (item: string) => {
          if (item == Constants.WIFI) {
            WifiIcon()
          }
          if (item == Constants.SIGNAL) {
            SignalIcon()
          }
          if (item == Constants.CLOCK) {
            ClockIcon()
          }
          if (item == Constants.BATTERY) {
            BatteryIcon()
          }
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r("app.color.Colors.twogroup_layout_background"))
  }
}
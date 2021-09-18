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


import BatteryIcon from '../../../../../../../features/batterycomponent/src/main/ets/default/pages/batteryIcon.ets'
import ClockIcon from '../../../../../../../features/clockcomponent/src/main/ets/default/pages/clockIcon.ets'
import WifiIcon from '../../../../../../../features/wificomponent/src/main/ets/default/pages/wifiIcon.ets'
import SignalIcon from '../../../../../../../features/signalcomponent/src/main/ets/default/pages/signalIcon.ets'
import Constants from './common/constants.ets'

@Component
export default struct Index {
  private notificationList : any
  private ListLength : number
  @StorageLink('wifiStatus') wifiStatus : boolean = false

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          SignalIcon()
          WifiIcon()
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            ForEach(this.notificationList, (item: any) => {
              Column() {
                Image(item.icon).objectFit(ImageFit.ScaleDown).height('50%')
              }
              .width(45)
            })
            if(this.ListLength > (this.wifiStatus ? 3 : 4)) {
              Row() {
                Text('...')
                  .fontSize(20)
              }
            }
          }
          .width(this.wifiStatus ? 4*45+20-50 : 4*45+20)
        }
      }
      .width('65%')

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        BatteryIcon()
        ClockIcon()
      }
      .width('35%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.default_background'))
  }
}
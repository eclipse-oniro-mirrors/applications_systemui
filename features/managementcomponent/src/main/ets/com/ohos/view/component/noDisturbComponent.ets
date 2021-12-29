/**
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
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import ConfigData from '../../common/constants.ets';
import ViewModel from '../../vm/noDisturbComponentViewModel.ets'

const TAG = 'ManagementComponent-NoDisturbComponent';

@Component
export default struct NoDisturbComponent {
  @State mViewModel: ViewModel = new ViewModel()

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()
  }

  build() {
    Flex({ alignItems: ItemAlign.Center,justifyContent: FlexAlign.SpaceBetween }) {
      Row() {
        Column() {
          Text($r('app.string.noDisturb'))
            .fontSize($r('app.float.itemComp_titel_font'))
            .fontColor($r('app.color.itemComp_title_color'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
          Text(this.mViewModel.prompt)
            .fontSize($r('app.float.itemComp_value_font'))
            .fontColor($r('app.color.itemComp_font_color'))
            .textAlign(TextAlign.Start)
        }
        .padding({ left: $r('app.float.itemComp_padding_l') })
        .alignItems(HorizontalAlign.Start)
      }
      .flexShrink(1)
      .align(Alignment.Start)
      .alignItems(VerticalAlign.Center)

      Row() {
        Toggle({ type: ToggleType.Switch, isOn: this.mViewModel.isEffective })
          .align(Alignment.End)
          .width($r('app.float.toggle_comp_width'))
          .height($r('app.float.toggle_comp_height'))
          .onChange((data) => {
            Log.showInfo(TAG, `Toggle onChange param: data = ${data}`)
            this.mViewModel.setNoDisturbingDate.bind(this.mViewModel)()
          })
      }
      .flexShrink(0)
      .align(Alignment.End)
      .alignItems(VerticalAlign.Center)
      .padding({ right: $r('app.float.itemComp_padding_r') })
    }
    .width(ConfigData.WH_100_100)
    .height($r('app.float.itemComp_height'))
    .border({ width: $r('app.float.border_width'), color: Color.White,
      radius: $r('app.float.border_radius') })
    .backgroundColor(Color.White)
    .margin({
      left: $r('app.float.page_margin_l'),
      right: $r('app.float.page_margin_r'),
      bottom: $r('app.float.itemComp_margin_b')
    })
  }
}

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


import Log from '../../../../../../../../../../common/src/main/ets/default/Log.ets';
import ViewModel from '../../viewmodel/ViewModel.ets';

const TAG = 'NoticeItem-CustomItem';

@Component
export default struct CustomItem {
  private customItemData: any = {};
  private template: any = {};
  private templateData: any = {};
  @State isDebugMode: boolean = false;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
    this.template = ViewModel.getPluginTempLate(this.customItemData.template.name);
    this.templateData = this.customItemData.template.data;
    Log.showInfo(TAG, `template = ${JSON.stringify(this.template)}`)
    Log.showInfo(TAG, `templateData = ${JSON.stringify(this.templateData)}`)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        PluginComponent({
          template: this.template,
          data: this.templateData
        }).onComplete(() => {
          Log.showInfo(TAG, `Complete`)
        }).onError(({errcode, msg}) => {
          Log.showInfo(TAG, `Error code:${errcode} message:${msg}`)
        })
          .size({ width: 400, height: 130 })
      }
      .backgroundColor($r('app.color.notificationitem_background'))
      .opacity($r('app.float.item_opicaty'))
      .borderRadius($r('app.float.item_borderradius'))
      .margin({
        left: $r('app.float.item_marginleft'),
        right: $r('app.float.item_marginright'),
        top: $r('app.float.item_margintop')
      })
      .padding({
        left: $r('app.float.item_paddingleft'),
        right: $r('app.float.item_paddingright'),
        bottom: $r('app.float.item_paddingbottom')
      })

      if (this.isDebugMode) {
        Column() {
          Text("-- DEBUG --")
            .fontSize('32')
            .fontWeight(FontWeight.Bold)
            .fontColor(0xCCCCCC)
            .opacity(0.5)
        }.margin(10)
      }
    }
  }
}

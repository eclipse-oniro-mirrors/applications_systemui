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

import brightness from '@ohos.brightness';
import mBrightnessManager from '../brightnessManager.ets';
import Log from '../../../../../../../common/src/main/ets/default/Log.ets';

const TAG = 'Control-brightnessComponent'

@Component
export struct MyBrightness {
  @StorageLink('BrightnessValue') brightnessValue: number = 0;
  @State brightnessItem: any = {
    min: 0,
    max: 255,
    value: 0
  };

  aboutToAppear() {
    Log.showInfo(TAG, `Brightness  aboutToAppear ${JSON.stringify(this.brightnessItem)}`);
    mBrightnessManager.init();
    mBrightnessManager.registerBrightness();
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
    mBrightnessManager.unRegisterBrightness();
  }

  setBrightness(value) {
    Log.showInfo(TAG, `setBrightness = ${value}`);
    mBrightnessManager.setValue(value);
  }

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Column() {
        Text($r('app.string.brightness_text'))
          .fontSize($r('app.float.control_common_font_size'))
          .alignSelf(ItemAlign.Center)
      }
      .width('15%')
      .constraintSize({ maxWidth: $r("app.float.font_constraint_maxSize") })
      .padding({ left: $r('app.float.slider_text_padding_left') })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Slider({
          value: this.brightnessValue,
          min: this.brightnessItem.min,
          max: this.brightnessItem.max,
          step: 1,
          style: SliderStyle.INSET

        })
          .width('100%')
          .blockColor(Color.Blue)
          .trackColor(Color.Grey)
          .selectedColor(Color.Blue)
          .onChange((value: number) => {
            this.brightnessItem.value = value;
            this.setBrightness(this.brightnessItem);
          })
      }
      .width('85%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.brightness_bg_color'))
    .borderRadius($r('app.float.brightness_border_radius'))
  }
}
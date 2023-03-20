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

import brightness from '@ohos.brightness';
import mBrightnessManager from '../brightnessManager';
import StyleConfiguration, { BrightnessComponentStyle } from '../common/StyleConfiguration';
import Log from '../../../../../../../common/src/main/ets/default/Log';

const TAG = 'Control-brightnessComponent';

class brightnessItemData {
  min:number;
  max:number;
  value:number
}

@Component
export default struct MyBrightness {
  @StorageLink('BrightnessValue') brightnessValue: number = 0;
  @State style: BrightnessComponentStyle = StyleConfiguration.getBrightnessComponentStyle();
  @State brightnessItem: brightnessItemData = {
    min: mBrightnessManager.getMin(),
    max: mBrightnessManager.getMax(),
    value: mBrightnessManager.getDefault()
  };

  aboutToAppear() {
    Log.showDebug(TAG, `Brightness  aboutToAppear ${JSON.stringify(this.brightnessItem)}`);
  }

  aboutToDisappear() {
    Log.showDebug(TAG, 'aboutToDisappear');
  }

  build() {
    Row() {
      Image($r('app.media.ic_brightness_reduce'))
        .width(this.style.brightnessPlusWidth)
        .height('100%')
        .margin({left: this.style.marginLeft, right: this.style.componentGap})
        .size({ width: this.style.brightnessReduceWidth,
          height: this.style.brightnessReduceHeight })
        .fillColor(this.style.brightnessIconColor)
        .layoutWeight(0)

      Slider({
        value: this.brightnessValue,
        min: this.brightnessItem.min,
        max: this.brightnessItem.max,
        step: 1,
        style: SliderStyle.InSet

      })
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .trackThickness(this.style.sliderHeight)
        .blockColor(this.style.sliderBlockColor)
        .trackColor(this.style.sliderTrackColor)
        .selectedColor(this.style.sliderSelectedColor)
        .onChange((value: number, mode: SliderChangeMode) => {
          mBrightnessManager.setValue(value, mode);
        })

      Image($r('app.media.ic_brightness_plus'))
        .width(this.style.brightnessPlusWidth)
        .height('100%')
        .margin({left: this.style.componentGap, right: this.style.marginRight})
        .size({ width: this.style.brightnessPlusWidth,
          height: this.style.brightnessPlusHeight })
        .fillColor(this.style.brightnessIconColor)
        .layoutWeight(0)
    }.width('100%')
    .height(this.style.brightnessHeight)
  }
}
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

import CommonStyleManager from '../../../../../../../common/src/main/ets/default/CommonStyleManager';

const TAG = 'brightness-StyleConfiguration';

export class BrightnessComponentStyle {
  marginLeft: Length = $r('app.float.brightness_margin_left');
  marginRight: Length = $r('app.float.brightness_margin_right');
  componentGap: Length = $r('app.float.brightness_component_gap');
  brightnessIconColor: ResourceColor = $r('sys.color.ohos_id_color_secondary');
  brightnessReduceWidth: Length = $r('app.float.brightness_reduce_width');
  brightnessReduceHeight: Length = $r('app.float.brightness_reduce_height');
  brightnessPlusWidth: Length = $r('app.float.brightness_plus_width');
  brightnessPlusHeight: Length = $r('app.float.brightness_plus_height');
  brightnessHeight: Length = $r('app.float.brightness_height');
  sliderHeight: Length = $r('app.float.brightness_slider_height');
  sliderBlockColor: ResourceColor = $r('app.color.brightness_slider_block_color');
  sliderTrackColor: ResourceColor = $r('app.color.brightness_slider_track_color');
  sliderSelectedColor: ResourceColor = $r('app.color.brightness_slider_selected_color');
}

export default class StyleConfiguration {
  static getBrightnessComponentStyle(): BrightnessComponentStyle {
    const key: string = TAG + '-BrightnessComponent';
    return CommonStyleManager.getStyle(key, BrightnessComponentStyle);
  }
}
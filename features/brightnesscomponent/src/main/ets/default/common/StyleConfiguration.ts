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

import StyleManager from '../../../../../../../common/src/main/ets/default/StyleManager';

const TAG = 'brightness-StyleConfiguration';

export default class StyleConfiguration {
    static getBrightnessComponentStyle() {
        const key: string = TAG + "-BrightnessComponent";
        return StyleManager.getStyle(key, () => {
            return {
                marginLeft: $r('app.float.brightness_margin_left'),
                marginRight: $r('app.float.brightness_margin_right'),
                componentGap: $r('app.float.brightness_component_gap'),
                brightnessIconColor: $r("sys.color.ohos_id_color_secondary"),
                brightnessReduceWidth: $r('app.float.brightness_reduce_width'),
                brightnessReduceHeight: $r('app.float.brightness_reduce_height'),
                brightnessPlusWidth: $r('app.float.brightness_plus_width'),
                brightnessPlusHeight: $r('app.float.brightness_plus_height'),
                brightnessHeight: $r('app.float.brightness_height'),
                sliderHeight: $r('app.float.brightness_slider_height'),
                sliderBlockColor: $r('app.color.brightness_slider_block_color'),
                sliderTrackColor: $r('app.color.brightness_slider_track_color'),
                sliderSelectedColor: $r('app.color.brightness_slider_selected_color')
            };
        });
    }
}
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
import Constants from './Constants'

const TAG = 'battery-StyleConfiguration';

export default class StyleConfiguration {
    static getBatteryComponentStyle() {
        const key: string = TAG + "-BatteryComponent";
        return StyleManager.getStyle(key, () => {
            return {
                componentGap: $r('app.float.battery_component_gap')
            };
        });
    }

    static getBatteryPicStyle() {
        const key: string = TAG + "-BatteryPicComponent";
        return StyleManager.getStyle(key, () => {
            return {
                picGap: $r('app.float.battery_component_pic_gap'),
                picBodyWidth: $r('app.float.battery_component_pic_body_width'),
                picBodyHeight: $r('app.float.battery_component_pic_body_height'),
                picBodyPadding: $r('app.float.battery_component_pic_body_padding'),
                picBodyBorderWidth: $r('app.float.battery_component_pic_body_border_width'),
                picBorderRadius: $r('app.float.battery_component_pic_border_radius'),
                picHeadBorderRadius: $r('app.float.battery_component_pic_head_radius'),
                picChargingColor: $r('app.color.battery_component_pic_charging_color'),
                picLevelLowColor: $r('app.color.battery_component_pic_level_low_color'),
                picHeadWidth: $r('app.float.battery_component_pic_head_width'),
                picHeadHeight: $r('app.float.battery_component_pic_head_height'),
            };
        });
    }
}
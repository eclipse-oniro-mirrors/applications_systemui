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

import StyleManager from '../../../../../../../../common/src/main/ets/default/StyleManager'
import Constants from './Constants'

const TAG = 'capsule-StyleConfiguration';

export default class StyleConfiguration {
  static getStatusRingModeComponentStyle() {
    const key: string = TAG + "-StatusRingMode";
    return StyleManager.getStyle(key, () => {
      return {
        statusBarRingModeWidth: $r('app.float.status_bar_ring_mode_width'),
        statusBarRingModeHeight: $r('app.float.status_bar_ring_mode_height')
      };
    });
  }

  static getControlCenterRingModeComponentStyle() {
    const key: string = TAG + "-ControlCenterRingMode";
    return StyleManager.getStyle(key, () => {
      return {
        onBgColor: $r('app.color.control_center_complex_toggle_ring_mode_on_bg_color')
      };
    });
  }
}
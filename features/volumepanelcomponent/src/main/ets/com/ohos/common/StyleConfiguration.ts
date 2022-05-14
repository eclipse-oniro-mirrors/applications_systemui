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

import StyleManager from '../../../../../../../../common/src/main/ets/default/StyleManager';
import Constants from './Constants'

const TAG = 'volumepanel-StyleConfiguration';

export default class StyleConfiguration {
  static getVolumePanelComponentStyle() {
    const key: string = TAG + "-VolumePanelComponent";
    return StyleManager.getStyle(key, () => {
      return {
        volumePanelSliderMarginTop: $r('app.float.volume_panel_component_slider_margin_top'),
        volumePanSliderWidth: $r('app.float.volume_panel_component_slider_width'),
        volumePanSliderHeight: $r('app.float.volume_panel_component_slider_height'),
        volumePanelSliderMarginBottom: $r('app.float.volume_panel_component_slider_margin_bottom'),
        volumePanelMutBtnIconSize: $r('app.float.volume_panel_component_mute_btn_icon_size'),
        volumePanelMutBtnIconMarginBottom: $r('app.float.volume_panel_component_mute_btn_icon_margin_bottom'),
        volumePanelMuteBtnHeight: $r('app.float.volume_panel_component_mute_btn_height'),
        volumePanelSettingIconSize: $r('app.float.volume_panel_component_setting_icon_size'),
        volumePanelBackground: $r('app.color.panel_background'),
        volumePanelSliderBlockColor: $r('app.color.volume_slider_block_color'),
        volumePanelDividerHeight: $r('app.float.volume_panel_divider_height'),
        volumePanelBorderRadius: $r('app.float.volume_panel_border_radius'),
        volumeDividerWidth: $r('app.float.volume_divider_width'),
        volumeSliderTrackColor: $r('app.color.volume_slider_track_color'),
        volumeSelectedColor: $r('app.color.volume_slider_selected_color'),
        volumeButtonBackgroundColor: $r('app.color.volume_button_background_color'),
        volumePanelRingModeColor: $r('app.color.volume_ring_mode_color'),
        volumePanelDividerColor:$r('app.color.volume_divider_color'),
        volumePanelSettingColor: $r('sys.color.ohos_id_color_secondary'),
        volumePanelSettingButtonSize: $r('app.float.volume_panel_component_setting_btn_icon_size')

      };
    });
  }
}
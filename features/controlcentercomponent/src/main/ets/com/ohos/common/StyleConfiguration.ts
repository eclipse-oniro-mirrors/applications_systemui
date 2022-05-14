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

const TAG = 'ControlCenter-StyleConfiguration';

export default class StyleConfiguration {
    static getControlCenterComponentStyle() {
        const key: string = TAG + "-ControlCenterComponent";
        return StyleManager.getStyle(key, () => {
            return {
                marginLeft: $r('app.float.control_center_margin_left'),
                marginRight: $r('app.float.control_center_margin_right'),
                marginTop: $r('app.float.control_center_margin_top'),
                titleMarginBottom: $r('app.float.control_center_title_margin_bottom'),
                upTitleHeight: $r('app.float.control_center_title_height'),
                toggleAreaGap: $r('app.float.control_center_toggle_area_gap'),
                simpleToggleLayoutMarginTop: $r('app.float.control_center_simple_toggle_layout_margin_top'),
                simpleToggleLayoutMarginBottom: $r('app.float.control_center_simple_toggle_layout_margin_bottom'),
                brightnessMarginBottom: $r('app.float.control_center_brightness_margin_bottom'),
                componentBorderRadius: $r('app.float.control_center_component_border_radius'),
                componentBackgroundColor: $r('app.color.control_center_component_background')
            };
        });
    }

    static getControlCenterUpTitleStyle() {
        const key: string = TAG + "-ControlCenterUpTitle";
        return StyleManager.getStyle(key, () => {
            return {
                marginLeft: $r('app.float.control_center_title_margin_left'),
                marginRight: $r('app.float.control_center_title_margin_right'),
                fontSize: $r('app.float.control_center_title_font_size'),
                fontColor: $r("app.color.control_center_title_font_color"),
                titleImageColor: $r("app.color.control_center_title_image_color"),
                imageWidth: $r('app.float.control_center_title_icon_width'),
                imageHeight: $r('app.float.control_center_title_icon_height'),
                imageHoverWidth: $r('app.float.control_center_title_icon_hover_width'),
                imageHoverHeight: $r('app.float.control_center_title_icon_hover_height'),
                imageHoverRadius: $r('app.float.control_center_title_icon_hover_radius'),
                imageHoverColor: $r('app.color.control_center_title_icon_hover_color'),
                imageTransparentColor: $r('app.color.control_center_title_icon_transparent_color'),
                upTitleSpace: $r("app.float.control_center_title_space"),
            };
        });
    }

    static getControlCenterComplexToggleLayoutStyle() {
        const key: string = TAG + "-ControlCenterComplexToggleLayout";
        return StyleManager.getStyle(key, () => {
            return {
                columnGap: $r("app.float.control_center_complex_toggle_column_gap"),
                rowGap: Constants.COMPLEX_TOGGLE_GRID_ROW_GAP,
                rowHeight: Constants.COMPLEX_TOGGLE_GRID_ROW_HEIGHT
            };
        });
    }

    static getControlCenterSimpleToggleLayoutStyle() {
        const key: string = TAG + "-ControlCenterSimpleToggleLayout";
        return StyleManager.getStyle(key, () => {
            return {
                marginLeft: $r("app.float.control_center_simple_toggle_layout_margin_left"),
                marginRight: $r("app.float.control_center_simple_toggle_layout_margin_right"),
                columnGap: $r("app.float.control_center_simple_toggle_column_gap"),
                rowGap: Constants.SIMPLE_TOGGLE_GRID_ROW_GAP,
                rowHeight: Constants.SIMPLE_TOGGLE_GRID_ROW_HEIGHT
            };
        });
    }

    static getSimpleToggleLayoutEditComponentStyle() {
        const key: string = TAG + "-SimpleToggleLayoutEditComponent";
        return StyleManager.getStyle(key, () => {
            return {
                marginLeft: $r('app.float.simple_toggle_edit_margin_left'),
                marginRight: $r('app.float.simple_toggle_edit_margin_right'),
                marginTop: $r("app.float.simple_toggle_edit_margin_top"),
                titleHeight: $r("app.float.simple_toggle_edit_title_height"),
                titleMarginBottom: $r("app.float.simple_toggle_edit_title_margin_bottom"),
                upGridMarginTop: $r('app.float.simple_toggle_edit_up_grid_margin_top'),
                upGridMarginBottom: $r('app.float.simple_toggle_edit_up_grid_margin_bottom'),
                gridMarginLeft: $r("app.float.simple_toggle_edit_grid_margin_left"),
                gridMarginRight: $r("app.float.simple_toggle_edit_grid_margin_right"),
                msgMarginTop: $r('app.float.simple_toggle_edit_msg_margin_top'),
                msgMarginBottom: $r('app.float.simple_toggle_edit_msg_margin_bottom'),
                btnMarginTop: $r('app.float.simple_toggle_edit_btn_margin_top'),
                btnMarginBottom: $r('app.float.simple_toggle_edit_btn_margin_bottom'),
                borderRadius: $r('app.float.simple_toggle_edit_border_radius'),
                upAreaBgColor: $r("app.color.center_edit_up_area_bg_color"),
                downAreaBgColor: $r("app.color.center_edit_down_area_bg_color"),
                editBtnFontColor: $r("app.color.simple_toggle_edit_btn_font_color"),
                editBtnFontSize: $r("sys.float.ohos_id_text_size_button1"),
                editBtnBgColor: $r("app.color.simple_toggle_edit_btn_bg_color"),
                editBtnMarginLeft: $r('app.float.simple_toggle_edit_btn_margin_left'),
                editBtnMarginRight: $r('app.float.simple_toggle_edit_btn_margin_right'),
                editBtnHeight: $r('app.float.simple_toggle_edit_btn_height'),
                editBtnSpace: $r('app.float.simple_toggle_edit_btn_space')
            };
        });
    }

    static getSimpleToggleLayoutEditUpTitleStyle() {
        const key: string = TAG + "-SimpleToggleLayoutEditUpTitle";
        return StyleManager.getStyle(key, () => {
            return {
                marginLeft: $r('app.float.simple_toggle_edit_title_margin_left'),
                imageWidth: $r('app.float.simple_toggle_edit_title_icon_width'),
                imageHeight: $r('app.float.simple_toggle_edit_title_icon_height'),
                fontColor: $r('app.color.simple_toggle_edit_title_font_color'),
                editTitleSpace: $r('app.float.simple_toggle_edit_icon_width'),
                titleFontSize: $r('app.float.simple_toggle_edit_title_font_size')
            };
        });
    }

    static getSimpleToggleLayoutEditOptMsgStyle() {
        const key: string = TAG + "-SimpleToggleLayoutEditOptMsg";
        return StyleManager.getStyle(key, () => {
            return {
                fontSize: $r('app.float.simple_toggle_edit_opt_msg_font_size'),
                fontColor: $r('sys.color.ohos_id_color_text_secondary'),
                height: $r('app.float.simple_toggle_edit_opt_msg_height'),
                marginLeftRight: $r('app.float.simple_toggle_edit_opt_msg_margin_left_right'),
            };
        });
    }

    static getSimpleToggleLayoutEditGridStyle() {
        const key: string = TAG + "-SimpleToggleLayoutEditGrid";
        return StyleManager.getStyle(key, () => {
            return {
                columnGap: $r("app.float.simple_toggle_edit_grid_column_gap"),
                rowGap: Constants.SIMPLE_TOGGLE_GRID_ROW_GAP,
                rowHeight: Constants.SIMPLE_TOGGLE_GRID_ROW_HEIGHT,
                dragBgSize: $r("app.float.simple_toggle_edit_grid_drag_bg_size")
            };
        });
    }

    static getControlEditDialogStyle() {
        const key: string = TAG + "-ControlEditDialog";
        return StyleManager.getStyle(key, () => {
            return {
                editDialogHeight: $r("app.float.simple_toggle_edit_dialog_height"),
                editDialogWidth: $r("app.float.simple_toggle_edit_dialog_width"),
                editDialogFontSize: $r("app.float.simple_toggle_edit_dialog_font_size"),
                editDialogBtnMarginLF: $r("app.float.simple_toggle_edit_dialog_btn_margin_lf"),
                editDialogFontHeight: $r("app.float.simple_toggle_edit_dialog_font_height"),
                editDialogBtnMarginTop: $r("app.float.simple_toggle_edit_dialog_btn_margin_top"),
                editDialogButtonSize: $r("app.float.simple_toggle_edit_dialog_btn_font_size"),
                editDialogDividerHeight: $r("app.float.simple_toggle_edit_dialog_divider_height"),
                editDialogButtonHeight: $r("app.float.simple_toggle_edit_dialog_btn_height"),
                editDialogRadius: $r("app.float.simple_toggle_edit_dialog_radius"),
                editDialogBtnWidth: $r("app.float.simple_toggle_edit_dialog_btn_width"),
                editDialogColor: $r("app.color.center_edit_dialog_color"),
                editDialogBtnFontColor: $r("app.color.center_edit_dialog_btn_font_color"),
                editDialogBtnBgColor: $r("app.color.center_edit_dialog_btn_bg_color"),
                editDialogDividerColor: $r("sys.color.ohos_id_color_secondary"),
                editDialogFontMarginTop: $r("app.float.simple_toggle_edit_dialog_font_margin_top"),
                editDialogDividerWidth: $r("app.float.simple_toggle_edit_dialog_divider_width")
            };
        });
    }
}
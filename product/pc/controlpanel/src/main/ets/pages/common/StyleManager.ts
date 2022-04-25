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

import Log from '../../../../../../../../common/src/main/ets/default/log';
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/abilitymanager';
import CommonTemplateStyleConfiguration from '../../../../../../../../common/src/main/ets/template/common/styleconfiguration';
import ControlCenterStyleConfiguration from '../../../../../../../../features/controlcentercomponent/src/main/ets/com/ohos/common/styleconfiguration'
import BrightnessStyleConfiguration from '../../../../../../../../features/brightnesscomponent/src/main/ets/default/common/styleconfiguration'
import RingModeStyleConfiguration from '../../../../../../../../features/ringmodecomponent/src/main/ets/com/ohos/common/styleconfiguration'
import IndexStyleConfiguration from './styleconfiguration'

const TAG = 'ControlPanel-StyleManager';

export default class StyleManager {
    static STANDARD_DISPLAY_WIDTH: number = 1280;
    static STANDARD_DISPLAY_HEIGHT: number = 800;
    static maxWidth: number = StyleManager.STANDARD_DISPLAY_WIDTH;

    static setStyle() {
        Log.showInfo(TAG, `setStyle`)

        let dis = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_CONTROL_PANEL, 'dis');
        StyleManager.maxWidth = dis.width;

        // Index
        {
            let style: any = IndexStyleConfiguration.getIndexStyle();
            style.borderRadius = StyleManager.calcScaleSizePx(24);
        }

        // ControlCenter
        {
            let style: any = ControlCenterStyleConfiguration.getControlCenterComponentStyle();
            style.marginLeft = StyleManager.calcScaleSizePx(20);
            style.marginRight = StyleManager.calcScaleSizePx(20);
            style.marginTop = StyleManager.calcScaleSizePx(0);
            style.upTitleHeight = StyleManager.calcScaleSizePx(56);
            style.titleMarginBottom = StyleManager.calcScaleSizePx(0);
            style.toggleAreaGap = StyleManager.calcScaleSizePx(12);
            style.simpleToggleLayoutMarginTop = StyleManager.calcScaleSizePx(23);
            style.simpleToggleLayoutMarginBottom = StyleManager.calcScaleSizePx(0);
            style.brightnessMarginBottom = StyleManager.calcScaleSizePx(12);
            style.componentBorderRadius = StyleManager.calcScaleSizePx(24);
            style.componentBackgroundColor = '#99FFFFFF';
        }

        // ControlCenter-Title
        {
            let style: any = ControlCenterStyleConfiguration.getControlCenterUpTitleStyle();
            style.marginLeft = StyleManager.calcScaleSizePx(24);
            style.marginRight = StyleManager.calcScaleSizePx(21);
            style.fontSize = StyleManager.calcScaleSizePx(20);
            style.fontColor = '#000000';
            style.imageWidth = StyleManager.calcScaleSizePx(24);
            style.imageHeight = StyleManager.calcScaleSizePx(24);
            style.imageHoverWidth = StyleManager.calcScaleSizePx(32);
            style.imageHoverHeight = StyleManager.calcScaleSizePx(32);
            style.imageHoverRadius = StyleManager.calcScaleSizePx(8);
            style.imageHoverColor = 'rgba(0, 0, 0, 0.05)';
            style.imageTransparentColor = 'rgba(255, 255, 255, 0)';
            style.upTitleSpace = StyleManager.calcScaleSizePx(24);
            style.titleImageColor = '#ff182431';
        }

        // ControlCenter-ComplexToggleLayout
        {
            let style: any = ControlCenterStyleConfiguration.getControlCenterComplexToggleLayoutStyle();
            style.columnGap = StyleManager.calcScaleSizePx(12);
            style.rowGap = StyleManager.calcScaleSize(12);
            style.rowHeight = StyleManager.calcScaleSize(66);
        }

        // ControlCenter-SimpleToggleLayout
        {
            let style: any = ControlCenterStyleConfiguration.getControlCenterSimpleToggleLayoutStyle();
            style.marginLeft = StyleManager.calcScaleSizePx(11);
            style.marginRight = StyleManager.calcScaleSizePx(11);
            style.columnGap = StyleManager.calcScaleSizePx(0);
            style.rowGap = StyleManager.calcScaleSize(0);
            style.rowHeight = StyleManager.calcScaleSize(81);
        }

        // CommonTemplate-iconTitleBase
        {
            let style: any = CommonTemplateStyleConfiguration.getIconTitleBaseStyle();
            style.marginLeft = StyleManager.calcScaleSizePx(8);
            style.marginRight = StyleManager.calcScaleSizePx(4);
            style.componentGap = StyleManager.calcScaleSizePx(8);
            style.titleSize = StyleManager.calcScaleSizePx(12);
            style.titleColor = $r("sys.color.ohos_id_color_text_secondary"),
            style.borderRadius = StyleManager.calcScaleSizePx(24);
            style.backgroundColor = '#99FFFFFF';
            style.textMargin = StyleManager.calcScaleSizePx(8);
            style.textHoverHeight = StyleManager.calcScaleSizePx(26);
            style.textHoverWidth = StyleManager.calcScaleSizePx(68);
            style.textHoverRadius = StyleManager.calcScaleSizePx(4);
            style.hoverColor = 'rgba(0, 0, 0, 0.05)';
            style.transparentColor = 'rgba(255, 255, 255, 0)';
        }

        // CommonTemplate-iconComponent
        {
            let style: any = CommonTemplateStyleConfiguration.getIconComponentStyle();
            style.circleWidth = StyleManager.calcScaleSizePx(48);
            style.circleHeight = StyleManager.calcScaleSizePx(48);
            style.iconWidth = StyleManager.calcScaleSizePx(24);
            style.iconHeight = StyleManager.calcScaleSizePx(24);
            style.iconOffBG = '#1A000000';
            style.iconOnBG = '#FF007DFF';
            style.iconOnColor = '#FFFFFFFF';
            style.iconOffColor = $r("sys.color.ohos_id_color_secondary");
            style.hoverColor = 'rgba(0, 0, 0, 0.05)';
            style.transparentColor = 'rgba(255, 255, 255, 0)';
        }

        // CommonTemplate-simpleToggleBase
        {
            let style: any = CommonTemplateStyleConfiguration.getSimpleToggleBaseStyle();
            style.circleWidth = StyleManager.calcScaleSizePx(48);
            style.circleHeight = StyleManager.calcScaleSizePx(48);
            style.iconWidth = StyleManager.calcScaleSizePx(24);
            style.iconHeight = StyleManager.calcScaleSizePx(24);
            style.dragCircleWidth = StyleManager.calcScaleSizePx(60);
            style.dragCircleHeight = StyleManager.calcScaleSizePx(60);
            style.dragIconWidth = StyleManager.calcScaleSizePx(36);
            style.dragIconHeight = StyleManager.calcScaleSizePx(36);
            style.iconOffBG = '#1A000000';
            style.iconOnBG = '#FF007DFF';
            style.iconOnColor = '#FFFFFFFF';
            style.iconOffColor = $r("sys.color.ohos_id_color_secondary");
            style.componentGap = StyleManager.calcScaleSizePx(4);
            style.titleSize = StyleManager.calcScaleSizePx(12);
            style.titleColor = $r("sys.color.ohos_id_color_text_secondary");
            style.textHoverWidth = StyleManager.calcScaleSizePx(68);
            style.textHoverHeight = StyleManager.calcScaleSizePx(18);
            style.textHoverRadius = StyleManager.calcScaleSizePx(4);
            style.hoverColor = 'rgba(0, 0, 0, 0.05)';
            style.transparentColor = 'rgba(255, 255, 255, 0)';
        }

        // Brightness
        {
            let style: any = BrightnessStyleConfiguration.getBrightnessComponentStyle();
            style.marginLeft = StyleManager.calcScaleSizePx(12.5);
            style.marginRight = StyleManager.calcScaleSizePx(12.5);
            style.componentGap = StyleManager.calcScaleSizePx(8.5);
            style.brightnessIconColor = $r("sys.color.ohos_id_color_secondary");
            style.brightnessReduceWidth = StyleManager.calcScaleSizePx(22);
            style.brightnessReduceHeight = StyleManager.calcScaleSizePx(22);
            style.brightnessPlusWidth = StyleManager.calcScaleSizePx(22);
            style.brightnessPlusHeight = StyleManager.calcScaleSizePx(22);
            style.brightnessHeight = StyleManager.calcScaleSizePx(40);
            style.sliderHeight = px2vp(StyleManager.calcScaleSize(20)) + 'vp';
            style.sliderBlockColor = '#FFFFFFFF';
            style.sliderTrackColor = '#0D000000';
            style.sliderSelectedColor = '#FF007DFF';
        }

        // RingMode
        {
            let style: any = RingModeStyleConfiguration.getControlCenterRingModeComponentStyle();
            style.brightnessIconColor = '#FFFF9800';
        }

        // SimpleToggleLayoutEdit
        {
            let style: any = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditComponentStyle();
            style.marginLeft = StyleManager.calcScaleSizePx(0);
            style.marginRight = StyleManager.calcScaleSizePx(0);
            style.marginTop = StyleManager.calcScaleSizePx(0);
            style.titleHeight = StyleManager.calcScaleSizePx(56);
            style.titleMarginBottom = StyleManager.calcScaleSizePx(0);
            style.upGridMarginTop = StyleManager.calcScaleSizePx(4);
            style.upGridMarginBottom = StyleManager.calcScaleSizePx(20);
            style.gridMarginLeft = StyleManager.calcScaleSizePx(21);
            style.gridMarginRight = StyleManager.calcScaleSizePx(21);
            style.msgMarginTop = StyleManager.calcScaleSizePx(0);
            style.msgMarginBottom = StyleManager.calcScaleSizePx(4);
            style.btnMarginTop = StyleManager.calcScaleSizePx(4);
            style.btnMarginBottom = StyleManager.calcScaleSizePx(16);
            style.borderRadius = StyleManager.calcScaleSizePx(24);
            style.upAreaBgColor = '#00FFFFFF';
            style.downAreaBgColor = '#4DFFFFFF';
            style.editBtnFontColor = '#FF007DFF';
            style.editBtnFontSize = $r("sys.float.ohos_id_text_size_button1");
            style.editBtnBgColor = '#0D000000';
            style.editBtnMarginLeft = StyleManager.calcScaleSizePx(16);
            style.editBtnMarginRight = StyleManager.calcScaleSizePx(16);
            style.editBtnHeight = StyleManager.calcScaleSizePx(40);
            style.editBtnSpace = StyleManager.calcScaleSizePx(16);
        }

        // SimpleToggleLayoutEdit-title
        {
            let style: any = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditUpTitleStyle();
            style.marginLeft = StyleManager.calcScaleSizePx(24);
            style.imageWidth = StyleManager.calcScaleSizePx(20);
            style.imageHeight = StyleManager.calcScaleSizePx(20);
            style.fontColor = '#FF000000';
            style.editTitleSpace = StyleManager.calcScaleSizePx(18);
            style.titleFontSize = StyleManager.calcScaleSizePx(20);
        }

        // SimpleToggleLayoutEdit-msg
        {
            let style: any = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditOptMsgStyle();
            style.fontSize = StyleManager.calcScaleSizePx(12);
            style.fontColor = $r('sys.color.ohos_id_color_text_secondary');
            style.height = StyleManager.calcScaleSizePx(41);
            style.marginLeftRight = StyleManager.calcScaleSizePx(30);
        }

        // SimpleToggleLayoutEdit-grid
        {
            let style: any = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditGridStyle();
            style.columnGap = StyleManager.calcScaleSizePx(0);
            style.rowGap = StyleManager.calcScaleSize(0);
            style.rowHeight = StyleManager.calcScaleSize(80);
            style.dragBgSize = StyleManager.calcScaleSizePx(60);
        }

        // EditDialog
        {
            let style: any = ControlCenterStyleConfiguration.getControlEditDialogStyle();
            style.editDialogHeight = StyleManager.calcScaleSizePx(121);
            style.editDialogWidth = StyleManager.calcScaleSizePx(374);
            style.editDialogFontSize = StyleManager.calcScaleSizePx(18);
            style.editDialogBtnMarginLF = StyleManager.calcScaleSizePx(13);
            style.editDialogFontHeight = StyleManager.calcScaleSizePx(20);
            style.editDialogBtnMarginTop = StyleManager.calcScaleSizePx(20);
            style.editDialogButtonSize = StyleManager.calcScaleSizePx(18);
            style.editDialogDividerHeight = StyleManager.calcScaleSizePx(20);
            style.editDialogButtonHeight = StyleManager.calcScaleSizePx(30);
            style.editDialogRadius = StyleManager.calcScaleSizePx(20);
            style.editDialogBtnWidth = StyleManager.calcScaleSizePx(173);
            style.editDialogFontMarginTop = StyleManager.calcScaleSizePx(29);
            style.editDialogColor = '#FFFFFFFF';
            style.editDialogBtnFontColor = '#FF0000FF';
            style.editDialogBtnBgColor = '#00FFFFFF';
            style.editDialogDividerColor = $r("sys.color.ohos_id_color_secondary");
            style.editDialogDividerWidth = StyleManager.calcScaleSizePx(1);
            Log.showInfo(TAG, `getControlEditDialogStyle`)
        }

    }

    static number2px(n: number): string {
        return n.toString() + 'px';
    }

    static calcScaleSize(n: number): number {
        return n * StyleManager.maxWidth / StyleManager.STANDARD_DISPLAY_WIDTH;
    }

    static calcScaleSizePx(n: number): string {
        return StyleManager.number2px(StyleManager.calcScaleSize(n));
    }
}
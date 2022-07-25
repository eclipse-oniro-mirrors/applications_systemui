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
import BaseStyleManager from '../../../../../../../../common/src/main/ets/default/BaseStyleManager';
import Log from '../../../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/abilitymanager';
import CommonTemplateStyleConfiguration from '../../../../../../../../common/src/main/ets/template/common/styleconfiguration';
import ControlCenterStyleConfiguration from '../../../../../../../../features/controlcentercomponent/src/main/ets/com/ohos/common/styleconfiguration';
import BrightnessStyleConfiguration from '../../../../../../../../features/brightnesscomponent/src/main/ets/default/common/styleconfiguration';
import RingModeStyleConfiguration from '../../../../../../../../features/ringmodecomponent/src/main/ets/com/ohos/common/styleconfiguration';
import IndexStyleConfiguration from './styleconfiguration';

const TAG = 'ControlPanel-StyleManager';

export class StyleManager extends BaseStyleManager {
  static readonly ABILITY_PAGE_NAME_CONTROLPANEL = "ControlPanel-Index";

  constructor() {
    super(StyleManager.ABILITY_PAGE_NAME_CONTROLPANEL);
  }

  setStyle(): void{
    Log.showDebug(TAG, 'setStyle');

    this.setStandardWidth(BaseStyleManager.STANDARD_DISPLAY_WIDTH_NORMAL);
    let dis = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_CONTROL_PANEL, 'dis');
    this.setMaxWidth(dis.width);

    // Index
    this.setIndexStyle();
    // ControlCenter
    this.setControlCenterComponentStyle();
    // ControlCenter-Title
    this.setControlCenterUpTitleStyle();
    // ControlCenter-ComplexToggleLayout
    this.setControlCenterComplexToggleLayoutStyle();
    // ControlCenter-SimpleToggleLayout
    this.setControlCenterSimpleToggleLayoutStyle();
    // CommonTemplate-iconTitleBase
    this.setIconTitleBaseStyle();
    // CommonTemplate-iconComponent
    this.setIconComponentStyle();
    // CommonTemplate-simpleToggleBase
    this.setSimpleToggleBaseStyle();
    // Brightness
    this.setBrightnessComponentStyle();
    // RingMode
    this.setControlCenterRingModeComponentStyle();
    // SimpleToggleLayoutEdit
    this.setSimpleToggleLayoutEditComponentStyle();
    // SimpleToggleLayoutEdit-title
    this.setSimpleToggleLayoutEditUpTitleStyle();
    // SimpleToggleLayoutEdit-msg
    this.setSimpleToggleLayoutEditOptMsgStyle();
    // SimpleToggleLayoutEdit-grid
    this.setSimpleToggleLayoutEditGridStyle();
    // EditDialog
    this.setControlEditDialogStyle();
  }
  // Index
  private setIndexStyle(): void {
    let style = IndexStyleConfiguration.getIndexStyle();
    style.borderRadius = this.calcScaleSizePx(24);
  }
  // ControlCenter
  private setControlCenterComponentStyle(): void {
    let style = ControlCenterStyleConfiguration.getControlCenterComponentStyle();
    style.marginLeft = this.calcScaleSizePx(20);
    style.marginRight = this.calcScaleSizePx(20);
    style.marginTop = this.calcScaleSizePx(0);
    style.upTitleHeight = this.calcScaleSizePx(56);
    style.titleMarginBottom = this.calcScaleSizePx(0);
    style.toggleAreaGap = this.calcScaleSizePx(12);
    style.simpleToggleLayoutMarginTop = this.calcScaleSizePx(23);
    style.simpleToggleLayoutMarginBottom = this.calcScaleSizePx(0);
    style.brightnessMarginBottom = this.calcScaleSizePx(12);
    style.componentBorderRadius = this.calcScaleSizePx(24);
    style.componentBackgroundColor = '#99FFFFFF';
  }
  // ControlCenter-Title
  private setControlCenterUpTitleStyle(): void{
    let style = ControlCenterStyleConfiguration.getControlCenterUpTitleStyle();
    style.marginLeft = this.calcScaleSizePx(24);
    style.marginRight = this.calcScaleSizePx(21);
    style.fontSize = this.calcScaleSizePx(20);
    style.fontColor = '#000000';
    style.imageWidth = this.calcScaleSizePx(24);
    style.imageHeight = this.calcScaleSizePx(24);
    style.imageHoverWidth = this.calcScaleSizePx(32);
    style.imageHoverHeight = this.calcScaleSizePx(32);
    style.imageHoverRadius = this.calcScaleSizePx(8);
    style.imageHoverColor = 'rgba(0, 0, 0, 0.05)';
    style.imageTransparentColor = 'rgba(255, 255, 255, 0)';
    style.upTitleSpace = this.calcScaleSizePx(24);
    style.titleImageColor = '#ff182431';
  }
  // ControlCenter-ComplexToggleLayout
  private setControlCenterComplexToggleLayoutStyle(): void {
    let style = ControlCenterStyleConfiguration.getControlCenterComplexToggleLayoutStyle();
    style.columnGap = this.calcScaleSizePx(12);
    style.rowGap = this.calcScaleSize(12);
    style.rowHeight = this.calcScaleSize(66);
  }
  // ControlCenter-SimpleToggleLayout
  private setControlCenterSimpleToggleLayoutStyle(): void{
    let style = ControlCenterStyleConfiguration.getControlCenterSimpleToggleLayoutStyle();
    style.marginLeft = this.calcScaleSizePx(11);
    style.marginRight = this.calcScaleSizePx(11);
    style.columnGap = this.calcScaleSizePx(0);
    style.rowGap = this.calcScaleSize(0);
    style.rowHeight = this.calcScaleSize(81);
  }
  // CommonTemplate-iconTitleBase
  private setIconTitleBaseStyle(): void{
    let style = CommonTemplateStyleConfiguration.getIconTitleBaseStyle();
    style.marginLeft = this.calcScaleSizePx(8);
    style.marginRight = this.calcScaleSizePx(4);
    style.componentGap = this.calcScaleSizePx(8);
    style.titleSize = this.calcScaleSizePx(12);
    style.titleColor = $r('sys.color.ohos_id_color_text_secondary'),
    style.borderRadius = this.calcScaleSizePx(24);
    style.backgroundColor = '#99FFFFFF';
    style.textMargin = this.calcScaleSizePx(8);
    style.textHoverHeight = this.calcScaleSizePx(26);
    style.textHoverWidth = this.calcScaleSizePx(68);
    style.textHoverRadius = this.calcScaleSizePx(4);
    style.hoverColor = 'rgba(0, 0, 0, 0.05)';
    style.transparentColor = 'rgba(255, 255, 255, 0)';
  }
  // CommonTemplate-iconComponent
  private setIconComponentStyle(): void {
    let style = CommonTemplateStyleConfiguration.getIconComponentStyle();
    style.circleWidth = this.calcScaleSizePx(48);
    style.circleHeight = this.calcScaleSizePx(48);
    style.iconWidth = this.calcScaleSizePx(24);
    style.iconHeight = this.calcScaleSizePx(24);
    style.iconOffBG = '#1A000000';
    style.iconOnBG = '#FF007DFF';
    style.iconOnColor = '#FFFFFFFF';
    style.iconOffColor = $r('sys.color.ohos_id_color_secondary');
    style.hoverColor = 'rgba(0, 0, 0, 0.05)';
    style.transparentColor = 'rgba(255, 255, 255, 0)';
  }
  // CommonTemplate-simpleToggleBase
  private setSimpleToggleBaseStyle(): void {
    let style = CommonTemplateStyleConfiguration.getSimpleToggleBaseStyle();
    style.circleWidth = this.calcScaleSizePx(48);
    style.circleHeight = this.calcScaleSizePx(48);
    style.iconWidth = this.calcScaleSizePx(24);
    style.iconHeight = this.calcScaleSizePx(24);
    style.dragCircleWidth = this.calcScaleSizePx(60);
    style.dragCircleHeight = this.calcScaleSizePx(60);
    style.dragIconWidth = this.calcScaleSizePx(36);
    style.dragIconHeight = this.calcScaleSizePx(36);
    style.iconOffBG = '#1A000000';
    style.iconOnBG = '#FF007DFF';
    style.iconOnColor = '#FFFFFFFF';
    style.iconOffColor = $r('sys.color.ohos_id_color_secondary');
    style.componentGap = this.calcScaleSizePx(4);
    style.titleSize = this.calcScaleSizePx(12);
    style.titleColor = $r('sys.color.ohos_id_color_text_secondary');
    style.textHoverWidth = this.calcScaleSizePx(68);
    style.textHoverHeight = this.calcScaleSizePx(18);
    style.textHoverRadius = this.calcScaleSizePx(4);
    style.hoverColor = 'rgba(0, 0, 0, 0.05)';
    style.transparentColor = 'rgba(255, 255, 255, 0)';
  }
  // Brightness
  private setBrightnessComponentStyle(): void {
    let style = BrightnessStyleConfiguration.getBrightnessComponentStyle();
    style.marginLeft = this.calcScaleSizePx(12.5);
    style.marginRight = this.calcScaleSizePx(12.5);
    style.componentGap = this.calcScaleSizePx(8.5);
    style.brightnessIconColor = $r('sys.color.ohos_id_color_secondary');
    style.brightnessReduceWidth = this.calcScaleSizePx(22);
    style.brightnessReduceHeight = this.calcScaleSizePx(22);
    style.brightnessPlusWidth = this.calcScaleSizePx(22);
    style.brightnessPlusHeight = this.calcScaleSizePx(22);
    style.brightnessHeight = this.calcScaleSizePx(40);
    style.sliderHeight = px2vp(this.calcScaleSize(20)).toString() + 'vp';
    style.sliderBlockColor = '#FFFFFFFF';
    style.sliderTrackColor = '#0D000000';
    style.sliderSelectedColor = '#FF007DFF';
  }
  // RingMode
  private setControlCenterRingModeComponentStyle(): void {
    let style = RingModeStyleConfiguration.getControlCenterRingModeComponentStyle();
    style.onBgColor = '#FFFF9800';
  }
  // SimpleToggleLayoutEdit
  private setSimpleToggleLayoutEditComponentStyle(): void {
    let style = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditComponentStyle();
    style.marginLeft = this.calcScaleSizePx(0);
    style.marginRight = this.calcScaleSizePx(0);
    style.marginTop = this.calcScaleSizePx(0);
    style.titleHeight = this.calcScaleSizePx(56);
    style.titleMarginBottom = this.calcScaleSizePx(0);
    style.upGridMarginTop = this.calcScaleSizePx(4);
    style.upGridMarginBottom = this.calcScaleSizePx(20);
    style.gridMarginLeft = this.calcScaleSizePx(21);
    style.gridMarginRight = this.calcScaleSizePx(21);
    style.msgMarginTop = this.calcScaleSizePx(0);
    style.msgMarginBottom = this.calcScaleSizePx(4);
    style.btnMarginTop = this.calcScaleSizePx(4);
    style.btnMarginBottom = this.calcScaleSizePx(16);
    style.borderRadius = this.calcScaleSizePx(24);
    style.upAreaBgColor = '#00FFFFFF';
    style.downAreaBgColor = '#4DFFFFFF';
    style.editBtnFontColor = '#FF007DFF';
    style.editBtnFontSize = $r('sys.float.ohos_id_text_size_button1');
    style.editBtnBgColor = '#0D000000';
    style.editBtnMarginLeft = this.calcScaleSizePx(16);
    style.editBtnMarginRight = this.calcScaleSizePx(16);
    style.editBtnHeight = this.calcScaleSizePx(40);
    style.editBtnSpace = this.calcScaleSizePx(16);
  }
  // SimpleToggleLayoutEdit
  private setSimpleToggleLayoutEditUpTitleStyle(): void {
    let style = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditUpTitleStyle();
    style.marginLeft = this.calcScaleSizePx(24);
    style.imageWidth = this.calcScaleSizePx(20);
    style.imageHeight = this.calcScaleSizePx(20);
    style.fontColor = '#FF000000';
    style.editTitleSpace = this.calcScaleSizePx(18);
    style.titleFontSize = this.calcScaleSizePx(20);
  }
  // SimpleToggleLayoutEdit
  private setSimpleToggleLayoutEditOptMsgStyle(): void {
    let style = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditOptMsgStyle();
    style.fontSize = this.calcScaleSizePx(12);
    style.fontColor = $r('sys.color.ohos_id_color_text_secondary');
    style.height = this.calcScaleSizePx(41);
    style.marginLeftRight = this.calcScaleSizePx(30);
  }
  // SimpleToggleLayoutEdit-grid
  private setSimpleToggleLayoutEditGridStyle(): void {
    let style = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditGridStyle();
    style.columnGap = this.calcScaleSizePx(0);
    style.rowGap = this.calcScaleSize(0);
    style.rowHeight = this.calcScaleSize(80);
    style.dragBgSize = this.calcScaleSizePx(60);
  }
  // EditDialog
  private setControlEditDialogStyle(): void {
    let style = ControlCenterStyleConfiguration.getControlEditDialogStyle();
    style.editDialogHeight = this.calcScaleSizePx(121);
    style.editDialogWidth = this.calcScaleSizePx(374);
    style.editDialogFontSize = this.calcScaleSizePx(18);
    style.editDialogBtnMarginLF = this.calcScaleSizePx(13);
    style.editDialogFontHeight = this.calcScaleSizePx(20);
    style.editDialogBtnMarginTop = this.calcScaleSizePx(20);
    style.editDialogButtonSize = this.calcScaleSizePx(18);
    style.editDialogDividerHeight = this.calcScaleSizePx(20);
    style.editDialogButtonHeight = this.calcScaleSizePx(30);
    style.editDialogRadius = this.calcScaleSizePx(20);
    style.editDialogBtnWidth = this.calcScaleSizePx(173);
    style.editDialogFontMarginTop = this.calcScaleSizePx(29);
    style.editDialogColor = '#FFFFFFFF';
    style.editDialogBtnFontColor = '#FF0000FF';
    style.editDialogBtnBgColor = '#00FFFFFF';
    style.editDialogDividerColor = $r('sys.color.ohos_id_color_secondary');
    style.editDialogDividerWidth = this.calcScaleSizePx(1);
    Log.showDebug(TAG, 'getControlEditDialogStyle');
  }
}

let styleManager = new StyleManager();

export default styleManager;
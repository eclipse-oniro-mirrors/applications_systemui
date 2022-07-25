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

const TAG = 'DropdownPanel-StyleManager';

export class StyleManager extends BaseStyleManager {
  static readonly ABILITY_PAGE_NAME_DROPDOWNPANEL = "DropdownPanel-Index";

  constructor() {
    super(StyleManager.ABILITY_PAGE_NAME_DROPDOWNPANEL);
  }

  setStyle(): void {
    Log.showDebug(TAG, 'setStyle');

    this.setStandardWidth(BaseStyleManager.STANDARD_DISPLAY_WIDTH_SMALL);

    let rect = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_DROPDOWN_PANEL, 'rect');
    this.setMaxWidth(rect.width);

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
  // ControlCenter
  private setControlCenterComponentStyle(): void{
    let style = ControlCenterStyleConfiguration.getControlCenterComponentStyle();
    style.marginLeft = this.calcScaleSizePx(48);
    style.marginRight = this.calcScaleSizePx(48);
    style.marginTop = this.calcScaleSizePx(36);
    style.upTitleHeight = this.calcScaleSizePx(127);
    style.titleMarginBottom = this.calcScaleSizePx(0);
    style.toggleAreaGap = this.calcScaleSizePx(24);
    style.simpleToggleLayoutMarginTop = this.calcScaleSizePx(48);
    style.simpleToggleLayoutMarginBottom = this.calcScaleSizePx(20);
    style.brightnessMarginBottom = this.calcScaleSizePx(44);
    style.componentBorderRadius = this.calcScaleSizePx(48);
    style.componentBackgroundColor = '#99FFFFFF';
  }
  // ControlCenter-Title
  private setControlCenterUpTitleStyle(): void{
    let style = ControlCenterStyleConfiguration.getControlCenterUpTitleStyle();
    style.marginLeft = this.calcScaleSizePx(72);
    style.marginRight = this.calcScaleSizePx(72);
    style.fontSize = this.calcScaleSizePx(40);
    style.fontColor = '#FFFFFFFF';
    style.imageWidth = this.calcScaleSizePx(48);
    style.imageHeight = this.calcScaleSizePx(48);
    style.imageHoverWidth = this.calcScaleSizePx(64);
    style.imageHoverHeight = this.calcScaleSizePx(64);
    style.imageHoverRadius = this.calcScaleSizePx(16);
    style.imageHoverColor = 'rgba(0, 0, 0, 0.05)';
    style.imageTransparentColor = 'rgba(255, 255, 255, 0)';
    style.upTitleSpace = this.calcScaleSizePx(36);
    style.titleImageColor = '#FFFFFFFF';
  }
  // ControlCenter-ComplexToggleLayout
  private setControlCenterComplexToggleLayoutStyle(): void{
    let style = ControlCenterStyleConfiguration.getControlCenterComplexToggleLayoutStyle();
    style.columnGap = this.calcScaleSizePx(24);
    style.rowGap = this.calcScaleSize(24);
    style.rowHeight = this.calcScaleSize(132);
  }
  // ControlCenter-SimpleToggleLayout
  private setControlCenterSimpleToggleLayoutStyle(): void{
    let style = ControlCenterStyleConfiguration.getControlCenterSimpleToggleLayoutStyle();
    style.marginLeft = this.calcScaleSizePx(22);
    style.marginRight = this.calcScaleSizePx(22);
    style.columnGap = this.calcScaleSizePx(0);
    style.rowGap = this.calcScaleSize(0);
    style.rowHeight = this.calcScaleSize(162);
  }
  // CommonTemplate-iconTitleBase
  private setIconTitleBaseStyle(): void {
    let style = CommonTemplateStyleConfiguration.getIconTitleBaseStyle();
    style.marginLeft = this.calcScaleSizePx(24);
    style.marginRight = this.calcScaleSizePx(16);
    style.componentGap = this.calcScaleSizePx(8);
    style.titleSize = this.calcScaleSizePx(24);
    style.titleColor = $r('sys.color.ohos_id_color_text_primary');
    style.borderRadius = this.calcScaleSizePx(48);
    style.backgroundColor = '#99FFFFFF';
    style.textMargin = this.calcScaleSizePx(8);
    style.textHoverHeight = this.calcScaleSizePx(52);
    style.textHoverWidth = this.calcScaleSizePx(136);
    style.textHoverRadius = this.calcScaleSizePx(8);
    style.hoverColor = 'rgba(0, 0, 0, 0.05)';
    style.transparentColor = 'rgba(255, 255, 255, 0)';
  }
  // CommonTemplate-iconComponent
  private setIconComponentStyle(): void {
    let style = CommonTemplateStyleConfiguration.getIconComponentStyle();
    style.circleWidth = this.calcScaleSizePx(96);
    style.circleHeight = this.calcScaleSizePx(96);
    style.iconWidth = this.calcScaleSizePx(48);
    style.iconHeight = this.calcScaleSizePx(48);
    style.iconOffBG = '#1A182431';
    style.iconOnBG = '#FF007DFF';
    style.iconOnColor = '#FFFFFFFF';
    style.iconOffColor = $r('sys.color.ohos_id_color_secondary');
    style.hoverColor = 'rgba(0, 0, 0, 0.05)';
    style.transparentColor = 'rgba(255, 255, 255, 0)';
  }
  // CommonTemplate-simpleToggleBase
  private setSimpleToggleBaseStyle(): void{
    let style = CommonTemplateStyleConfiguration.getSimpleToggleBaseStyle();
    style.circleWidth = this.calcScaleSizePx(96);
    style.circleHeight = this.calcScaleSizePx(96);
    style.iconWidth = this.calcScaleSizePx(48);
    style.iconHeight = this.calcScaleSizePx(48);
    style.dragCircleWidth = this.calcScaleSizePx(120);
    style.dragCircleHeight = this.calcScaleSizePx(120);
    style.dragIconWidth = this.calcScaleSizePx(72);
    style.dragIconHeight = this.calcScaleSizePx(72);
    style.iconOffBG = '#1A182431';
    style.iconOnBG = '#FF007DFF';
    style.iconOnColor = '#FFFFFFFF';
    style.iconOffColor = $r('sys.color.ohos_id_color_secondary');
    style.componentGap = this.calcScaleSizePx(10);
    style.titleSize = this.calcScaleSizePx(24);
    style.titleColor = $r('sys.color.ohos_id_color_text_primary');
    style.textHoverWidth = this.calcScaleSizePx(136);
    style.textHoverHeight = this.calcScaleSizePx(36);
    style.textHoverRadius = this.calcScaleSizePx(8);
    style.hoverColor = 'rgba(0, 0, 0, 0.05)';
    style.transparentColor = 'rgba(255, 255, 255, 0)';
  }
  // Brightness
  private setBrightnessComponentStyle(): void{
    let style = BrightnessStyleConfiguration.getBrightnessComponentStyle();
    style.marginLeft = this.calcScaleSizePx(26);
    style.marginRight = this.calcScaleSizePx(26);
    style.componentGap = this.calcScaleSizePx(26);
    style.brightnessIconColor = $r('sys.color.ohos_id_color_secondary');
    style.brightnessReduceWidth = this.calcScaleSizePx(44);
    style.brightnessReduceHeight = this.calcScaleSizePx(44);
    style.brightnessPlusWidth = this.calcScaleSizePx(44);
    style.brightnessPlusHeight = this.calcScaleSizePx(44);
    style.brightnessHeight = this.calcScaleSizePx(44);
    style.sliderHeight = this.calcScaleSizePx(40);
    style.sliderBlockColor = '#FFFFFFFF';
    style.sliderTrackColor = '#1A182431';
    style.sliderSelectedColor = '#FF007DFF';
  }
  // RingMode
  private setControlCenterRingModeComponentStyle(): void{
    let style = RingModeStyleConfiguration.getControlCenterRingModeComponentStyle();
    style.onBgColor = '#FFFF9800';
  }
  // SimpleToggleLayoutEdit
  private setSimpleToggleLayoutEditComponentStyle(): void{
    let style = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditComponentStyle();
    style.marginLeft = this.calcScaleSizePx(48);
    style.marginRight = this.calcScaleSizePx(48);
    style.marginTop = this.calcScaleSizePx(33);
    style.titleHeight = this.calcScaleSizePx(127);
    style.titleMarginBottom = this.calcScaleSizePx(0);
    style.upGridMarginTop = this.calcScaleSizePx(48);
    style.upGridMarginBottom = this.calcScaleSizePx(24);
    style.gridMarginLeft = this.calcScaleSizePx(18.24);
    style.gridMarginRight = this.calcScaleSizePx(18.24);
    style.msgMarginTop = this.calcScaleSizePx(0);
    style.msgMarginBottom = this.calcScaleSizePx(0);
    style.btnMarginTop = this.calcScaleSizePx(24);
    style.btnMarginBottom = this.calcScaleSizePx(32);
    style.borderRadius = this.calcScaleSizePx(48);
    style.upAreaBgColor = '#99FFFFFF';
    style.downAreaBgColor = '#4DFFFFFF';
    style.editBtnFontColor = '#FF007DFF';
    style.editBtnFontSize = this.calcScaleSizePx(32);
    style.editBtnBgColor = '#0D000000';
    style.editBtnMarginLeft = this.calcScaleSizePx(32);
    style.editBtnMarginRight = this.calcScaleSizePx(32);
    style.editBtnHeight = this.calcScaleSizePx(80);
    style.editBtnSpace = this.calcScaleSizePx(32);
  }
  // SimpleToggleLayoutEdit-title
  private setSimpleToggleLayoutEditUpTitleStyle(): void{
    let style = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditUpTitleStyle();
    style.marginLeft = this.calcScaleSizePx(72);
    style.imageWidth = this.calcScaleSizePx(40);
    style.imageHeight = this.calcScaleSizePx(40);
    style.fontColor = '#FFFFFFFF';
    style.editTitleSpace = this.calcScaleSizePx(36);
    style.titleFontSize = this.calcScaleSizePx(40);
  }
  // SimpleToggleLayoutEdit-msg
  private setSimpleToggleLayoutEditOptMsgStyle(): void{
    let style = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditOptMsgStyle();
    style.fontSize = this.calcScaleSizePx(24);
    style.fontColor = $r('sys.color.ohos_id_color_text_secondary');
    style.height = this.calcScaleSizePx(98);
    style.marginLeftRight = this.calcScaleSizePx(44);
  }
  // SimpleToggleLayoutEdit-grid
  private setSimpleToggleLayoutEditGridStyle(): void{
    let style = ControlCenterStyleConfiguration.getSimpleToggleLayoutEditGridStyle();
    style.columnGap = this.calcScaleSizePx(0);
    style.rowGap = this.calcScaleSize(0);
    style.rowHeight = this.calcScaleSize(162);
    style.dragBgSize = this.calcScaleSizePx(120);
  }
  // EditDialog
  private setControlEditDialogStyle(): void {
    let style = ControlCenterStyleConfiguration.getControlEditDialogStyle();
    style.editDialogHeight = this.calcScaleSizePx(217);
    style.editDialogWidth = this.calcScaleSizePx(670);
    style.editDialogFontSize = this.calcScaleSizePx(30);
    style.editDialogBtnMarginLF = this.calcScaleSizePx(24);
    style.editDialogFontHeight = this.calcScaleSizePx(36);
    style.editDialogBtnMarginTop = this.calcScaleSizePx(36);
    style.editDialogButtonSize = this.calcScaleSizePx(30);
    style.editDialogDividerHeight = this.calcScaleSizePx(36);
    style.editDialogButtonHeight = this.calcScaleSizePx(54);
    style.editDialogRadius = this.calcScaleSizePx(36);
    style.editDialogBtnWidth = this.calcScaleSizePx(311);
    style.editDialogFontMarginTop = this.calcScaleSizePx(52);
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
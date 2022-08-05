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
import CommonStyleConfiguration from '../../../../../../../../common/src/main/ets/default/styleconfiguration';
import StatusBarStyleConfiguration from '../../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/styleconfiguration';
import BatteryStyleConfiguration from '../../../../../../../../features/batterycomponent/src/main/ets/default/common/styleconfiguration';
import ClockStyleConfiguration from '../../../../../../../../features/clockcomponent/src/main/ets/default/common/styleconfiguration';
import WifiStyleConfiguration from '../../../../../../../../features/wificomponent/src/main/ets/default/common/styleconfiguration';
import BluetoothStyleConfiguration from '../../../../../../../../features/bluetoothcomponent/src/main/ets/com/ohos/common/styleconfiguration';
import SignalStyleConfiguration from '../../../../../../../../features/signalcomponent/src/main/ets/default/common/styleconfiguration';
import CapsuleStyleConfiguration from '../../../../../../../../features/capsulecomponent/src/main/ets/default/common/styleconfiguration';
import LocationStyleConfiguration from '../../../../../../../../features/locationcomponent/src/main/ets/com/ohos/common/styleconfiguration';
import RingModeStyleConfiguration from '../../../../../../../../features/ringmodecomponent/src/main/ets/com/ohos/common/styleconfiguration';

const TAG = './styleconfigurationer';

export class StyleManager extends BaseStyleManager {
  static readonly ABILITY_PAGE_NAME_STATUSBAR = "StatusBar-Index";

  constructor() {
    super(StyleManager.ABILITY_PAGE_NAME_STATUSBAR);
  }

  setStyle(): void {
    Log.showDebug(TAG, 'setStyle');

    this.setStandardWidth(BaseStyleManager.STANDARD_DISPLAY_WIDTH_NORMAL);

    let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'config');
    this.setMaxWidth(config.maxWidth);

    this.setCommonStyle();
    this.setVerticalStatusBarItemLoadComponentStyle();
    this.setStatusBarNotificationIconStyle();
    this.setIconItemComponentStyle();
    this.setPluginIconItemComponentStyle();
    this.setClockComponentStyle();
    this.setBatteryComponentStyle();
    this.setBatteryPicStyle();
    this.setSignalComponentStyle();
    this.setStatusBarBluetoothComponentStyle();
    this.setStartsBarLocationComponentStyle();
    this.setStatusRingModeComponentStyle();
    this.setStartsBarWifiComponentStyle();
    this.setCapsuleComponentStyle();
  }
  // Common
  private setCommonStyle(): void {
    let style = CommonStyleConfiguration.getCommonStyle();
    style.statusBarFontSize = this.calcScaleSizePx(14);
    style.statusBarIconWidth = this.calcScaleSizePx(20);
    style.statusBarIconHeight = this.calcScaleSizePx(20);
    style.statusBarMarginLeftRight = $r("app.float.status_bar_margin_left_right");
  }

  // StatusBar-VerticalStatusBarItemLoadComponent
  private setVerticalStatusBarItemLoadComponentStyle(): void {
    let style = StatusBarStyleConfiguration.getVerticalStatusBarItemLoadComponentStyle();
    style.statusBarVerticalComponentHeight = this.calcScaleSize(64);
  }

  // StatusBar-NotificationIcon
  private setStatusBarNotificationIconStyle(): void {
    let style = StatusBarStyleConfiguration.getStatusBarNotificationIconStyle();
    style.iconWidth = this.calcScaleSizePx(16);
    style.iconHeight = this.calcScaleSizePx(16);
    style.iconSpace = this.calcScaleSizePx(6);
  }

  // StatusBar-IconComponent
  private setIconItemComponentStyle(): void {
    let style = StatusBarStyleConfiguration.getIconItemComponentStyle();
    style.stackHeight = this.calcScaleSizePx(8 * 2 + 18);
    style.stackPadding = this.calcScaleSizePx(8);
    style.stackBorderRadius = this.calcScaleSizePx(8);
    style.stackBgColorSelected = '#33000000';
    style.stackBgColorUnSelected = '#00000000';
    style.componentSpace = this.calcScaleSizePx(8);
    style.iconWidth = this.calcScaleSizePx(18);
    style.iconHeight = this.calcScaleSizePx(18);
    style.marginLeft = this.calcScaleSizePx(4);
    style.marginRight = this.calcScaleSizePx(4);
  }

  // StatusBar-PluginIconItemComponent
  private setPluginIconItemComponentStyle(): void {
    let style = StatusBarStyleConfiguration.getPluginIconItemComponentStyle();
    style.iconWidth = this.calcScaleSize(32);
  }

  // Clock
  private setClockComponentStyle(): void {
    let style = ClockStyleConfiguration.getClockComponentStyle();
    style.statusBarClockMaxWidth = this.calcScaleSizePx(37);
  }

  // Battery-Icon
  private setBatteryComponentStyle(): void {
    let style = BatteryStyleConfiguration.getBatteryComponentStyle();
    style.componentGap = this.calcScaleSizePx(6);
  }

  // Battery-Pic
  private setBatteryPicStyle(): void {
    let style = BatteryStyleConfiguration.getBatteryPicStyle();
    style.picGap = this.calcScaleSizePx(1);
    style.picBodyWidth = this.calcScaleSizePx(18.75);
    style.picBodyHeight = this.calcScaleSizePx(10.83);
    style.picBodyPadding = this.calcScaleSizePx(1);
    style.picBodyBorderWidth = this.calcScaleSizePx(1);
    style.picBorderRadius = this.calcScaleSizePx(2);
    style.picHeadBorderRadius = this.calcScaleSizePx(1);
    style.picChargingColor = '#00ff21';
    style.picLevelLowColor = '#ff0000';
    style.picHeadWidth = this.calcScaleSizePx(1.5);
    style.picHeadHeight = this.calcScaleSizePx(5);
  }

  // Signal-Icon
  private setSignalComponentStyle(): void {
    let style = SignalStyleConfiguration.getSignalComponentStyle();
    style.cellularImageWidth = this.calcScaleSizePx(25);
    style.cellularImageHeight = this.calcScaleSizePx(20);
    style.statusBarSignalTypeFontSize = this.calcScaleSizePx(7);
    style.statusBarSignalUnknownFontSize = this.calcScaleSizePx(12);
    style.signalTextMaxWeight = this.calcScaleSizePx(100);
    style.netSignalTextMaxWidth = this.calcScaleSizePx(18);
  }

  // Bluetooth -Icon
  private setStatusBarBluetoothComponentStyle(): void {
    let style = BluetoothStyleConfiguration.getStatusBarBluetoothComponentStyle();
    style.staticBarBluetoothWidth = this.calcScaleSizePx(18);
    style.staticBarBluetoothHeight = this.calcScaleSizePx(20);
  }

  // Location-Icon
  private setStartsBarLocationComponentStyle(): void {
    let style = LocationStyleConfiguration.getStartsBarLocationComponentStyle();
    style.statusBarLocationWidth = this.calcScaleSizePx(18);
    style.statusBarLocationHeight = this.calcScaleSizePx(20);
  }

  // RingMode-Icon
  private setStatusRingModeComponentStyle(): void {
    let style = RingModeStyleConfiguration.getStatusRingModeComponentStyle();
    style.statusBarRingModeWidth = this.calcScaleSizePx(20);
    style.statusBarRingModeHeight = this.calcScaleSizePx(20);
  }

  // Wifi-Icon
  private setStartsBarWifiComponentStyle(): void {
    let style = WifiStyleConfiguration.getStartsBarWifiComponentStyle();
    style.statusBarWifiWidth = this.calcScaleSizePx(20);
    style.statusBarWifiHeight = this.calcScaleSizePx(20);
  }

  // Capsule-Icon
  private setCapsuleComponentStyle(): void {
    let style = CapsuleStyleConfiguration.getCapsuleComponentStyle();
    style.greenCapsulePhoneWidth = this.calcScaleSizePx(15);
    style.greenCapsulePhoneHeight = this.calcScaleSizePx(15);
    style.greenCapsuleHeight = this.calcScaleSizePx(30);
    style.greenCapsuleTextColor = '#CCFFFFFF';
    style.greenCapsuleTextMarginLeftRight = this.calcScaleSizePx(10);
    style.greenCapsuleRadius = this.calcScaleSizePx(24);
    style.greenCapsuleBackgroundColor = '#64BB5C';
    style.maxLines = 1;
  }
}

let styleManager = new StyleManager();

export default styleManager;
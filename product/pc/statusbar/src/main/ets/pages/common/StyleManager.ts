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
import CommonStyleConfiguration from '../../../../../../../../common/src/main/ets/default/styleconfiguration';
import StatusBarStyleConfiguration from '../../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/styleconfiguration'
import BatteryStyleConfiguration from '../../../../../../../../features/batterycomponent/src/main/ets/default/common/styleconfiguration'
import ClockStyleConfiguration from '../../../../../../../../features/clockcomponent/src/main/ets/default/common/styleconfiguration'
import WifiStyleConfiguration from '../../../../../../../../features/wificomponent/src/main/ets/default/common/styleconfiguration'
import BluetoothStyleConfiguration from '../../../../../../../../features/bluetoothcomponent/src/main/ets/com/ohos/common/styleconfiguration'
import SignalStyleConfiguration from '../../../../../../../../features/signalcomponent/src/main/ets/default/common/styleconfiguration'
import CapsuleStyleConfiguration from '../../../../../../../../features/capsulecomponent/src/main/ets/default/common/styleconfiguration'
import LocationStyleConfiguration from '../../../../../../../../features/locationcomponent/src/main/ets/com/ohos/common/styleconfiguration'
import RingModeStyleConfiguration from '../../../../../../../../features/ringmodecomponent/src/main/ets/com/ohos/common/styleconfiguration'
import IndexStyleConfiguration from './styleconfiguration'

const TAG = './styleconfigurationer';

export default class StyleManager {
    static STANDARD_DISPLAY_WIDTH: number = 1280;
    static STANDARD_DISPLAY_HEIGHT: number = 800;
    static maxWidth: number = StyleManager.STANDARD_DISPLAY_WIDTH;

    static setStyle() {
        Log.showDebug(TAG, `setStyle`)

        let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'config');
        StyleManager.maxWidth = config.maxWidth;

        // Common
        {
            let style: any = CommonStyleConfiguration.getCommonStyle();
            style.statusBarFontSize = StyleManager.calcScaleSizePx(14);
            style.statusBarIconWidth = StyleManager.calcScaleSizePx(20);
            style.statusBarIconHeight = StyleManager.calcScaleSizePx(20);
            style.statusBarMarginLeftRight = StyleManager.calcScaleSizePx(10);
        }

        // StatusBar-VerticalStatusBarItemLoadComponent
        {
            let style: any = StatusBarStyleConfiguration.getVerticalStatusBarItemLoadComponentStyle();
            style.statusBarVerticalComponentHeight = StyleManager.calcScaleSize(64);
        }

        // StatusBar-NotificationIcon
        {
            let style: any = StatusBarStyleConfiguration.getStatusBarNotificationIconStyle();
            style.iconWidth = StyleManager.calcScaleSizePx(16);
            style.iconHeight = StyleManager.calcScaleSizePx(16);
            style.iconSpace = StyleManager.calcScaleSizePx(6);
        }

        // StatusBar-IconComponent
        {
            let style: any = StatusBarStyleConfiguration.getIconItemComponentStyle();
            style.stackHeight = StyleManager.calcScaleSizePx(8 * 2 + 18);
            style.stackPadding = StyleManager.calcScaleSizePx(8);
            style.stackBorderRadius = StyleManager.calcScaleSizePx(8);
            style.stackBgColorSelected = '#33000000';
            style.stackBgColorUnSelected = '#00000000';
            style.componentSpace = StyleManager.calcScaleSizePx(8);
            style.iconWidth = StyleManager.calcScaleSizePx(18);
            style.iconHeight = StyleManager.calcScaleSizePx(18);
            style.marginLeft = StyleManager.calcScaleSizePx(4);
            style.marginRight = StyleManager.calcScaleSizePx(4);
        }

        // Clock
        {
            let style: any = ClockStyleConfiguration.getClockComponentStyle();
            style.statusBarClockMaxWidth = StyleManager.calcScaleSizePx(37);
        }

        // Battery-Icon
        {
            let style: any = BatteryStyleConfiguration.getBatteryComponentStyle();
            style.componentGap = StyleManager.calcScaleSizePx(6);
        }

        // Battery-Pic
        {
            let style: any = BatteryStyleConfiguration.getBatteryPicStyle();
            style.picGap = StyleManager.calcScaleSizePx(1);
            style.picBodyWidth = StyleManager.calcScaleSizePx(18.75);
            style.picBodyHeight = StyleManager.calcScaleSizePx(10.83);
            style.picBodyPadding = StyleManager.calcScaleSizePx(1);
            style.picBodyBorderWidth = StyleManager.calcScaleSizePx(1);
            style.picBorderRadius = StyleManager.calcScaleSizePx(2);
            style.picHeadBorderRadius = StyleManager.calcScaleSizePx(1);
            style.picChargingColor = '#00ff21';
            style.picLevelLowColor = '#ff0000';
            style.picHeadWidth = StyleManager.calcScaleSizePx(1.5);
            style.picHeadHeight = StyleManager.calcScaleSizePx(5);
        }

        // Signal-Icon
        {
            let style: any = SignalStyleConfiguration.getSignalComponentStyle();
            style.cellularImageWidth = StyleManager.calcScaleSizePx(25);
            style.cellularImageHeight = StyleManager.calcScaleSizePx(20);
            style.statusBarSignalTypeFontSize = StyleManager.calcScaleSizePx(7);
            style.statusBarSignalUnknownFontSize = StyleManager.calcScaleSizePx(12);
            style.signalTextMaxWeight = StyleManager.calcScaleSizePx(100);
            style.netSignalTextMaxWidth = StyleManager.calcScaleSizePx(18);
        }

        // Bluetooth -Icon
        {
            let style: any = BluetoothStyleConfiguration.getStatusBarBluetoothComponentStyle();
            style.staticBarBluetoothWidth = StyleManager.calcScaleSizePx(18);
            style.staticBarBluetoothHeight = StyleManager.calcScaleSizePx(20);
        }

        // Location-Icon
        {
            let style: any = LocationStyleConfiguration.getStartsBarLocationComponentStyle();
            style.statusBarLocationWidth = StyleManager.calcScaleSizePx(18);
            style.statusBarLocationHeight = StyleManager.calcScaleSizePx(20);
        }

        // RingMode-Icon
        {
            let style: any = RingModeStyleConfiguration.getStatusRingModeComponentStyle();
            style.statusBarRingModeWidth = StyleManager.calcScaleSizePx(20);
            style.statusBarRingModeHeight = StyleManager.calcScaleSizePx(20);
        }

        // Wifi-Icon
        {
            let style: any = WifiStyleConfiguration.getStartsBarWifiComponentStyle();
            style.statusBarWifiWidth = StyleManager.calcScaleSizePx(20);
            style.statusBarWifiHeight = StyleManager.calcScaleSizePx(20);
        }

        // Capsule-Icon
        {
            let style: any = CapsuleStyleConfiguration.getCapsuleComponentStyle();
            style.greenCapsulePhoneWidth = StyleManager.calcScaleSizePx(15);
            style.greenCapsulePhoneHeight = StyleManager.calcScaleSizePx(15);
            style.greenCapsuleHeight = StyleManager.calcScaleSizePx(30);
            style.greenCapsuleTextColor = '#CCFFFFFF';
            style.greenCapsuleTextMarginLeftRight = StyleManager.calcScaleSizePx(10);
            style.greenCapsuleRadius = StyleManager.calcScaleSizePx(24);
            style.greenCapsuleBackgroundColor = '#64BB5C';
            style.maxLines = 1;
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
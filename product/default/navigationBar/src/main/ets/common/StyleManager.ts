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

import Log from '../../../../../../../common/src/main/ets/default/log';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilitymanager';
import StyleConfiguration from './styleconfiguration'

const TAG = 'StatusBar-StyleManager';

export default class StyleManager {
    static PAD_STANDARD_DISPLAY_WIDTH: number = 1280;
    static PAD_STANDARD_DISPLAY_HEIGHT: number = 800;
    static PHONE_STANDARD_DISPLAY_WIDTH: number = 720;
    static PHONE_STANDARD_DISPLAY_HEIGHT: number = 1280;
    static maxWidth: number = StyleManager.PAD_STANDARD_DISPLAY_WIDTH;
    static rumMode: string = 'pad';

    static setPadStyle() {
        Log.showDebug(TAG, `setPadStyle`)

        let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
        StyleManager.maxWidth = config.maxWidth;
        StyleManager.rumMode = 'pad'

        // keyButton
        {
            let style: any = StyleConfiguration.getKeyButtonStyle();
            style.buttonWidth = StyleManager.calcScaleSizePx(88);
            style.buttonHeight = StyleManager.calcScaleSizePx(44);
            style.buttonBorderRadius = StyleManager.calcScaleSizePx(22);
            style.buttonIconWidth = StyleManager.calcScaleSizePx(15);
            style.buttonIconHeight = StyleManager.calcScaleSizePx(15);
        }
    }

    static setPhoneStyle() {
        Log.showDebug(TAG, `setPhoneStyle`)

        let config = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
        StyleManager.maxWidth = config.maxWidth;
        StyleManager.rumMode = 'phone'

        // keyButton
        {
            let style: any = StyleConfiguration.getKeyButtonStyle();
            style.buttonWidth = StyleManager.calcScaleSizePx(144);
            style.buttonHeight = StyleManager.calcScaleSizePx(72);
            style.buttonBorderRadius = StyleManager.calcScaleSizePx(36);
            style.buttonIconWidth = StyleManager.calcScaleSizePx(24);
            style.buttonIconHeight = StyleManager.calcScaleSizePx(24);
        }
    }

    static number2px(n: number): string {
        return n.toString() + 'px';
    }

    static calcScaleSize(n: number): number {
        return n * StyleManager.maxWidth / (StyleManager.rumMode == 'pad' ? StyleManager.PAD_STANDARD_DISPLAY_WIDTH : StyleManager.PHONE_STANDARD_DISPLAY_WIDTH);
    }

    static calcScaleSizePx(n: number): string {
        return StyleManager.number2px(StyleManager.calcScaleSize(n));
    }
}
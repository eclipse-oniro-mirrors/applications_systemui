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

const TAG = 'NavigationBar-StyleConfiguration';

export default class StyleConfiguration {
    static getKeyButtonStyle() {
        const key: string = TAG + "-KeyButton";
        return StyleManager.getStyle(key, () => {
            return {
                buttonWidth: $r('app.float.navigation_bar_button_width'),
                buttonHeight: $r('app.float.navigation_bar_button_height'),
                buttonBorderRadius: $r('app.float.navigation_bar_button_radius'),
                buttonIconWidth: $r('app.float.navigation_bar_button_icon_width'),
                buttonIconHeight: $r('app.float.navigation_bar_button_icon_height'),
            };
        });
    }
}
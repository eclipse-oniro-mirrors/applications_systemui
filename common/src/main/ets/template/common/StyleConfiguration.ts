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

import StyleManager from '../../default/StyleManager';

const TAG = 'CommonTemplate-StyleConfiguration';

export default class StyleConfiguration {
    static getIconTitleBaseStyle() {
        const key: string = TAG + "-IconTitleBase";
        return StyleManager.getStyle(key, () => {
            return {
                marginLeft: '24vp',
                marginRight: '16vp',
                componentGap: '8vp',
                titleSize: '24vp',
                titleColor:$r("sys.color.ohos_id_color_text_secondary"),
                borderRadius: '48vp',
                backgroundColor: '#ffffff',
                textMargin: '8vp',
                textHoverHeight: '52vp',
                textHoverWidth: '136vp',
                textHoverRadius: '8vp',
                hoverColor: 'rgba(0, 0, 0, 0.05)',
                transparentColor: 'rgba(255, 255, 255, 0)',
            };
        });
    }

    static getIconComponentStyle() {
        const key: string = TAG + "-IconComponent";
        return StyleManager.getStyle(key, () => {
            return {
                circleWidth: '96vp',
                circleHeight: '96vp',
                iconWidth: '48vp',
                iconHeight: '48vp',
                iconOffBG: '#1A000000',
                iconOnBG: '#FF007DFF',
                iconOnColor: '#FFFFFFFF',
                iconOffColor: $r("sys.color.ohos_id_color_secondary"),
                hoverColor: 'rgba(0, 0, 0, 0.05)',
                transparentColor: 'rgba(255, 255, 255, 0)',
            };
        });
    }

    static getSimpleToggleBaseStyle() {
        const key: string = TAG + "-SimpleToggleBase";
        return StyleManager.getStyle(key, () => {
            return {
                circleWidth: '96vp',
                circleHeight: '96vp',
                iconWidth: '48vp',
                iconHeight: '48vp',
                dragCircleWidth: '120vp',
                dragCircleHeight: '120vp',
                dragIconWidth: '72vp',
                dragIconHeight: '72vp',
                iconOffBG: '#1A000000',
                iconOnBG: '#FF007DFF',
                iconOnColor: '#FFFFFFFF',
                iconOffColor: $r("sys.color.ohos_id_color_secondary"),
                componentGap: '10vp',
                titleSize: '24fp',
                titleColor: $r("sys.color.ohos_id_color_text_secondary"),
                textHoverWidth: '136vp',
                textHoverHeight: '36vp',
                textHoverRadius: '8vp',
                hoverColor: 'rgba(0, 0, 0, 0.05)',
                transparentColor: 'rgba(255, 255, 255, 0)',
            };
        });
    }
}
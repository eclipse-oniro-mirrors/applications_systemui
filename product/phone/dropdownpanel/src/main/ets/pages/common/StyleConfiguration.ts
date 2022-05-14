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

import StyleManager from '../../../../../../../../common/src/main/ets/default/stylemanager';
import Constants from './constants'

const TAG = 'DropdownPanel-StyleConfiguration';

export default class StyleConfiguration {
    static getControlStyle() {
        const key: string = TAG + "-Control";
        return StyleManager.getStyle(key, () => {
            return {
                statusBarHeight: $r("app.float.status_bar_height")
            };
        });
    }

    static getNotificationStyle() {
        const key: string = TAG + "-Notification";
        return StyleManager.getStyle(key, () => {
            return {
                statusBarHeight: $r("app.float.status_bar_height"),
                deleteAllImageWidth: $r("app.float.delete_all_image_width"),
                deleteAllImageHeight: $r("app.float.delete_all_image_height"),
                deleteAllImageBorderRadius: $r("app.float.delete_all_image_border_radius"),
                deleteAllImageOpacity: $r("app.float.delete_all_image_opacity"),
            };
        });
    }

    static getQuicklySettingStyle() {
        const key: string = TAG + "-QuicklySetting";
        return StyleManager.getStyle(key, () => {
            return {
                quicklySetTimeFontSize: $r("app.float.quickly_setting_time_font_size"),
                quicklySetTimeFontColor: $r('app.color.quickly_setting_time_font_color'),
                quicklyDateFontColor: $r('app.color.quickly_setting_date_font_color'),
                quicklyDateFontSize: $r("app.float.quickly_setting_date_font_size"),
                quicklySetTextFlexMarginLeft: $r("app.float.quickly_setting_text_flex_margin_left"),
                quicklySetImageWidth: $r("app.float.quickly_setting_image_width"),
                quicklySttImageHeight: $r("app.float.quickly_setting_image_height"),
                quicklySetImageMarginRight: $r("app.float.quickly_setting_image_margin_right"),
                quickLySettingBorderRadius: $r("app.float.quickly_setting_border_radius"),
                quickLySettingMarginLeft: $r("app.float.quickly_setting_margin_left"),
                quickLySettingMarginRight: $r("app.float.quickly_setting_margin_right"),
                quickSettingH: Constants.QUICKLY_SETTING_H,
            };
        });
    }

    static getDateItemStyle() {
        const key: string = TAG + "-DateItem";
        return StyleManager.getStyle(key, () => {
            return {
                quicklySetDateItemFontSize: $r("app.float.quickly_setting_date_font_size"),
                quicklySetDateItemFontColor: $r('app.color.quickly_setting_date_font_color'),
            };
        });
    }
}
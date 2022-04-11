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
import Constants from './Constants';

const TAG = 'statusBar-StyleConfiguration';

export default class StyleConfiguration {
    static getVerticalStatusBarItemLoadComponentStyle() {
        const key: string = TAG + "-VerticalStatusBarItemLoadComponent";
        return StyleManager.getStyle(key, () => {
            return {
                statusBarVerticalComponentHeight: vp2px(Constants.VERTICAL_COMPONENT_HEIGHT_VP),
            };
        });
    }

    static getStatusBarNotificationIconStyle() {
        const key: string = TAG + "-StatusBarNotificationIcon";
        return StyleManager.getStyle(key, () => {
            return {
                iconWidth: $r('app.float.status_bar_notification_icon_width'),
                iconHeight: $r('app.float.status_bar_notification_icon_height'),
                iconSpace: $r('app.float.status_bar_notification_icon_space'),
            };
        });
    }

    static getIconItemComponentStyle() {
        const key: string = TAG + "-IconItemComponent";
        return StyleManager.getStyle(key, () => {
            return {
                stackHeight: $r('app.float.status_bar_icon_item_stack_height'),
                stackPadding: $r('app.float.status_bar_icon_item_stack_padding'),
                stackBorderRadius: $r('app.float.status_bar_icon_item_stack_border_radius'),
                stackBgColorSelected: $r('app.color.status_bar_icon_item_stack_bg_color_selected'),
                stackBgColorUnSelected: $r('app.color.status_bar_icon_item_stack_bg_color_un_selected'),
                componentSpace: $r('app.float.status_bar_icon_item_component_space'),
                iconWidth: $r('app.float.status_bar_icon_item_icon_width'),
                iconHeight: $r('app.float.status_bar_icon_item_icon_height'),
                marginLeft: $r('app.float.status_bar_icon_item_margin_left'),
                marginRight: $r('app.float.status_bar_icon_item_margin_right'),
            };
        });
    }
}
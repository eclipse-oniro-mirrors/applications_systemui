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

import CommonStyleManager from '../../default/CommonStyleManager';

const TAG = 'CommonTemplate-StyleConfiguration';

export class IconTitleBaseStyle {
  marginLeft: Length = '24vp';
  marginRight: Length = '16vp';
  componentGap: Length = '8vp';
  titleSize: Length = '24vp';
  titleColor: ResourceColor = $r('sys.color.ohos_id_color_text_secondary');
  borderRadius: Length= '48vp';
  backgroundColor: ResourceColor= '#ffffff';
  textMargin: Length = '8vp';
  textHoverHeight: Length = '52vp';
  textHoverWidth: Length = '136vp';
  textHoverRadius: Length = '8vp';
  hoverColor: ResourceColor = 'rgba(0, 0, 0, 0.05)';
  transparentColor: ResourceColor = 'rgba(255, 255, 255, 0)';
}

export class IconComponentStyle {
  circleWidth: number | string = '96vp';
  circleHeight: number | string = '96vp';
  iconWidth: Length = '48vp';
  iconHeight: Length = '48vp';
  iconOffBG: ResourceColor = '#1A000000';
  iconOnBG: ResourceColor = '#FF007DFF';
  iconOnColor: ResourceColor = '#FFFFFFFF';
  iconOffColor: ResourceColor = $r('sys.color.ohos_id_color_secondary');
  hoverColor: ResourceColor = 'rgba(0, 0, 0, 0.05)';
  transparentColor: ResourceColor = 'rgba(255, 255, 255, 0)';
}

export class SimpleToggleBaseStyle {
  circleWidth: number | string = '96vp';
  circleHeight: number | string = '96vp';
  iconWidth: Length = '48vp';
  iconHeight: Length = '48vp';
  dragCircleWidth: number | string = '120vp';
  dragCircleHeight: number | string = '120vp';
  dragIconWidth: Length = '72vp';
  dragIconHeight: Length = '72vp';
  iconOffBG: ResourceColor = '#1A000000';
  iconOnBG: ResourceColor = '#FF007DFF';
  iconOnColor: ResourceColor = '#FFFFFFFF';
  iconOffColor: ResourceColor = $r('sys.color.ohos_id_color_secondary');
  componentGap: Length = '10vp';
  titleSize: Length = '24fp';
  titleColor: ResourceColor = $r('sys.color.ohos_id_color_text_secondary');
  textHoverWidth: number | string = '136vp';
  textHoverHeight: number | string = '36vp';
  textHoverRadius: number | string = '8vp';
  hoverColor: ResourceColor = 'rgba(0, 0, 0, 0.05)';
  transparentColor: ResourceColor = 'rgba(255, 255, 255, 0)';
}

export default class StyleConfiguration {
  static getIconTitleBaseStyle(): IconTitleBaseStyle {
    const key: string = TAG + '-IconTitleBase';
    return CommonStyleManager.getStyle(key, IconTitleBaseStyle);
  }

  static getIconComponentStyle(): IconComponentStyle {
    const key: string = TAG + '-IconComponent';
    return CommonStyleManager.getStyle(key, IconComponentStyle);
  }

  static getSimpleToggleBaseStyle(): SimpleToggleBaseStyle {
    const key: string = TAG + '-SimpleToggleBase';
    return CommonStyleManager.getStyle(key, SimpleToggleBaseStyle);
  }
}
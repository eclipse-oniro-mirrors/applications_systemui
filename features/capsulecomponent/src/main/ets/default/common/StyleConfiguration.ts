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

import StyleManager from '../../../../../../../common/src/main/ets/default/StyleManager';
import Constants from './Constants';

const TAG = 'capsule-StyleConfiguration';

export default class StyleConfiguration {
  static getCapsuleComponentStyle() {
    const key: string = TAG + "-CapsuleComponent";
    return StyleManager.getStyle(key, () => {
      return {
        greenCapsulePhoneWidth: $r('app.float.green_capsule_phone_width'),
        greenCapsulePhoneHeight: $r('app.float.green_capsule_phone_height'),
        greenCapsuleHeight: $r('app.float.green_capsule_height'),
        greenCapsuleTextColor: $r('app.color.green_capsule_text_color'),
        greenCapsuleTextMarginLeftRight: $r('app.float.green_capsule_text_left_right'),
        greenCapsuleRadius: $r('app.float.green_capsule_radius'),
        greenCapsuleBackgroundColor: $r('app.color.capsule_background_color'),
        maxLines:Constants.DEFAULT_MAX_LINES
      };
    });
  }

}
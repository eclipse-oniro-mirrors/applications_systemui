/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import Constants from '../common/constants.ets'
import CapsuleViewModel, {VIEW_MODEL_ID, CallState} from '../viewmodel/CapsuleViewModel.ets'
import Log from '../../../../../../../common/src/main/ets/default/Log.ets'

const TAG = "CapsuleIcon";

@Component
export default struct CapsuleIcon {
  @StorageLink(VIEW_MODEL_ID) mCapsuleViewModel: CapsuleViewModel = CapsuleViewModel.getInstance();
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0
  startX: number = 0
  startY: number = 0
  moveX: number = 0
  moveY: number = 0

  aboutToAppear() {
    this.mCapsuleViewModel.initViewModel();
    Log.showInfo(TAG, 'aboutToAppear, text: ' + this.mCapsuleViewModel.mText);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Row() {
      Image($r("app.media.ic_statusbar_phone"))
        .width($r("app.float.ic_statusbar_phone_width"))
        .height($r("app.float.ic_statusbar_phone_height"))
        .objectFit(ImageFit.Contain)
        .margin({ left: $r("app.float.green_capsule_margin") })
      Text(this.mCapsuleViewModel.mText)
        .fontSize($r("app.float.green_capsule_font_size"))
        .fontWeight(FontWeight.Regular)
        .fontColor($r('app.color.green_capsule_text_color'))
        .maxLines(Constants.DEFAULT_MAX_LINES)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({
          left: $r("app.float.green_capsule_text_margin"),
          right: $r("app.float.green_capsule_margin"),
          top: $r("app.float.green_capsule_text_margin"),
          bottom: $r("app.float.green_capsule_text_margin")
        })
    }
    .alignItems(VerticalAlign.Center)
    .margin({ left: $r("app.float.green_capsule_left_margin") })
    .height(Constants.STATIC_BAR_ICON_HEIGHT * this.StatusCoefficient)
    .backgroundColor($r('app.color.background_color'))
    .borderRadius($r('app.float.green_capsule_radius'))
    .visibility(this.mCapsuleViewModel.mIsBackground ? Visibility.Visible : Visibility.None)
    .onTouch(this.touchEvent.bind(this))
  }

  touchEvent(event: TouchEvent) {
    Log.showInfo(TAG, `touchEventtouchEventtouchEvent`)
    if (event.type == Constants.TOUCH_TYPE_DOWN) {
      this.startX = event.touches[0].screenX;
      this.startY = event.touches[0].screenY;
      this.moveX = 0;
      this.moveY = 0;
      Log.showInfo(TAG, `touchStart2=======startX: ${this.startX}, startY: ${this.startY}`);
    } else if (event.type == Constants.TOUCH_TYPE_MOVE) {
      this.moveX = event.touches[0].screenX - this.startX;
      this.moveY = event.touches[0].screenY - this.startY;
    } else if (event.type == Constants.TOUCH_TYPE_UP) {
      Log.showInfo(TAG, `touchEnd2, moveX: ${this.moveX}, moveY: ${this.moveY}`);
      if (this.moveX < 5 && this.moveX > -5 && this.moveY < 5 && this.moveY > -5) {
        event.stopPropagation();
        this.mCapsuleViewModel.onClickEvent();
        this.mCapsuleViewModel.mIsBackground = false;
      }
    }
  }
}
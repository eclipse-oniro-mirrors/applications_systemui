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

import keyCodeEvent from '../../../../../../../features/navigationservice/src/main/ets/com/ohos/navigationservice/KeyCodeEvent.ets';
import Log from '../../../../../../../common/src/main/ets/default/Log.ets';
import Constants from '../common/constants.ets'


const TAG = 'NavigationBar-KeyButton';

@Component
export default struct keyButton {

  private uri: any;
  @Prop keyCode: number;
  @State backGroundColor: any = $r('app.color.button_default_background');
  @StorageLink('NavCoefficient') NavCoefficient:number = 1.0
  @StorageLink("showNavHorizontal") showNavHorizontal: boolean = AppStorage.SetAndLink("showNavHorizontal", true).get();

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
  }

  aboutToDisappear(){
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Flex() {}
      .borderRadius($r('app.float.button_radius'))
      .width('100%')
      .height('100%')
      .backgroundColor(this.backGroundColor)
      Image(this.uri)
        .objectFit(ImageFit.Contain)
        .size({ width: Constants.IMAGE_WIDTH*this.NavCoefficient, height:Constants.IMAGE_HEIGHT*this.NavCoefficient  })
    }
    .onTouch(this.onKeyTouch.bind(this))
    .width(this.showNavHorizontal ? Constants.BUTTON_WIDTH*this.NavCoefficient : '100%')
    .height(this.showNavHorizontal ?  '100%' : Constants.BUTTON_WIDTH*this.NavCoefficient )
  }

  private onKeyTouch(event:TouchEvent) {
    Log.showInfo(TAG, `onKeyTouch event: ${ event }`)
    let eventType = event.type;
    switch(eventType) {
      case Constants.KEY_DOWN:
        this.backGroundColor =$r('app.color.button_click_background')
        break;
      case Constants.KEY_UP:
        this.backGroundColor = $r('app.color.button_default_background')
        break;
      default:
        break;
    }
    keyCodeEvent.sendKeyEvent(this.keyCode, eventType)
  }
}

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

import Three from './threeLayout.ets'
import Log from '../../../../../../../common/src/main/ets/default/Log.ets';
import HeightConfigUtils from '../../../../../../../common/src/main/ets/default/heightcofigUtils/HeightConfigUtils.ets';
import Constants from '../common/constants.ets'

const STORAGE_NAVIGATION_TYPE = 'navigationType'

let mConfigReader;
let mHeightConfigUtils;
const TAG = 'NavigationBar-Index';
@Entry
@Component
struct Index {
  @StorageLink('navigationLayoutConfig') mConfig: any = {}
  @StorageLink('NavMinH') NavMinH:number = 32

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
    mHeightConfigUtils = new HeightConfigUtils();
    let NavMinH = AppStorage.SetAndLink("NavMinH", 32);
    let NavCoefficient = AppStorage.SetAndLink("NavCoefficient", 1.0);
    NavMinH.set(mHeightConfigUtils.getNavMinH());
    NavCoefficient.set(mHeightConfigUtils.getNavHCoefficient());
  }
  aboutToDisappear(){
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Three();
    }
    .width('100%')
    .height('100%')
    .constraintSize({ minHeight: this.NavMinH })
    .backgroundColor($r('app.color.index_background'))
    .padding({ left: '18%', right: '18%' })
  }
}

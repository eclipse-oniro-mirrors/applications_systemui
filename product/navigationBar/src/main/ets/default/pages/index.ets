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

const STORAGE_NAVIGATION_TYPE = 'navigationType'

let mHeightConfigUtils;
const TAG = 'NavigationBar-Index';

@Entry
@Component
struct Index {
  @StorageLink('navigationLayoutConfig') mConfig: any = {}
  @StorageLink('minNavHeight') minNavHeight: number = 32
  @StorageLink("showNavHorizontal") showNavHorizontal: boolean = true

  onBackPress(): boolean {

    return true;
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`)
    let NavCoefficient = AppStorage.SetAndLink("NavCoefficient", 1.0);
    NavCoefficient.set(mHeightConfigUtils.getNavHCoefficient());
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Three();
    }
    .width('100%')
    .height('100%')
    .constraintSize({ minHeight: this.minNavHeight })
    .backgroundColor($r('app.color.index_background'))
    .padding(this.showNavHorizontal ? { left: '18%', right: '18%' } : { top: '18%', bottom: '18%' })
  }
}

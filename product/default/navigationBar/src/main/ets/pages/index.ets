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

import Three from './threeLayout'
import Log from '../../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import CommonStyleManager from '../../../../../../../common/src/main/ets/default/CommonStyleManager'
import NavigationBarViewModel from '../viewmodel/NavigationBarViewModel';
import {NavigationBarComponentData} from '../common/constants'
import StyleManager from '../common/StyleManager'
import configManager from '../../../../../../../features/navigationservice/src/main/ets/com/ohos/navigationservice/ConfigManager'

const TAG = 'NavigationBar-Index';
let mConfigManager = configManager

@Entry
@Component
struct Index {
  @StorageLink('navigationLayoutConfig') mConfig: object = {}
  @StorageLink('minNavHeight') minNavHeight: number = 32
  @StorageLink("showNavHorizontal") showNavHorizontal: boolean = true
  @State mNavigationBarComponentData: NavigationBarComponentData = new NavigationBarComponentData()

  onBackPress(): boolean {

    return true;
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config');
    AppStorage.SetOrCreate("showNavHorizontal", configInfo.showNavHorizontal);
    mConfigManager.initConfig();

    setAppBgColor('#00000000');
    CommonStyleManager.setAbilityPageName(TAG)
    if (configInfo.maxWidth > configInfo.maxHeight) { // Pad、PC Mode
      StyleManager.setPadStyle();
    } else { // Phone Mode
      StyleManager.setPhoneStyle();
    }

    let navigationBarViewModelInstance = NavigationBarViewModel.getInstance();
    navigationBarViewModelInstance.install();
    this.mNavigationBarComponentData = navigationBarViewModelInstance.getNavigationBarComponentData();
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`)
    NavigationBarViewModel.getInstance().uninstall()
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Three();
    }
    .width('100%')
    .height('100%')
    .constraintSize({ minHeight: this.minNavHeight + 'px' })
    .backgroundColor(this.mNavigationBarComponentData.backgroundColor)
    .padding(this.showNavHorizontal ? { left: '18%', right: '18%' } : { top: '18%', bottom: '18%' })
  }
}

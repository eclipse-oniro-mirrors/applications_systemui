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

import Log from '../../../../../../../common/src/main/ets/default/Log'
import CommonStyleManager from '../../../../../../../common/src/main/ets/default/CommonStyleManager'
import HeightConfigUtils from '../../../../../../../common/src/main/ets/default/heightcofigUtils/HeightConfigUtils'
import StatusBarComponent from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/pages/StatusBarComponent'
import StyleManager from './common/StyleManager'
import StatusbarConfig from './common/StatusbarConfig'
import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import StatusBarVM from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/viewmodel/StatusBarVM'
import {StatusBarData} from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/Constants'

const TAG = 'StatusBar-Index'

let mHeightConfigUtils;

@Entry
@Component
struct Index {
  @StorageLink('StatusMinH') StatusMinH: number = 24
  @StorageLink('StatusCoefficient') StatusCoefficient: number = 1.0

  onBackPress(): boolean {
    return true;
  }

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);

    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_STATUS_BAR, 'config')
    let statusBarData: StatusBarData = new StatusBarData();
    statusBarData.displayWidth = configInfo.maxWidth;
    statusBarData.displayHeight = configInfo.maxHeight;
    statusBarData.showHorizontal = configInfo.showHorizontal;
    statusBarData.ableToMaximize = configInfo.ableToMaximize;
    statusBarData.realWidth = configInfo.realWidth;
    statusBarData.realHeight = configInfo.realHeight;
    statusBarData.left = configInfo.xCoordinate;
    statusBarData.top = configInfo.yCoordinate;
    StatusBarVM.updateStatusBarData(statusBarData);

    setAppBgColor('#00000000');
    CommonStyleManager.setAbilityPageName(TAG);
    StyleManager.setStyle();

    mHeightConfigUtils = new HeightConfigUtils();
    let StatusMinH;
    let StatusCoefficient;

    StatusMinH = AppStorage.SetAndLink("StatusMinH", 24);
    StatusCoefficient = AppStorage.SetAndLink("StatusCoefficient", 1.0);
    StatusMinH.set(mHeightConfigUtils.getStatusMinH());
    StatusCoefficient.set(mHeightConfigUtils.getStatusCoefficient());

    let signalObserved = AppStorage.SetAndLink("signalObserved", false);
    signalObserved.set(false);

    Log.showDebug(TAG, `aboutToAppear, end`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        StatusBarComponent({
          mStatusBarComponentConfig: StatusbarConfig,
          moduleName: 'pc_statusbar'
        })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .constraintSize({ minHeight: this.StatusMinH + 'px' })
    .onAreaChange((e, e2) => {
      Log.showInfo(TAG, `onAreaChange, e: ${JSON.stringify(e)} e2: ${JSON.stringify(e2)}`);
    })
  }
}

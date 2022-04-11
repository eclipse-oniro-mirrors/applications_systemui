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

import AbilityManager from '../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import StatusBarVM from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/viewmodel/StatusBarVM'
import {StatusBarData} from '../../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/Constants'

export default {
  async onCreate() {
    console.info('SystemUI statusBar Application onCreate')
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
  },
  onDestroy() {
    console.info('SystemUI statusBar Application onDestroy')
  },
}

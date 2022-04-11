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
import configManager from '../../../../../../../features/navigationservice/src/main/ets/com/ohos/navigationservice/ConfigManager'

let mConfigManager = configManager

export default {
  async onCreate() {
    console.info('SystemUI navigationBar Application onCreate')
    let configInfo = AbilityManager.getAbilityData(AbilityManager.ABILITY_NAME_NAVIGATION_BAR, 'config')
    AppStorage.SetAndLink("showNavHorizontal", configInfo.showNavHorizontal)
    mConfigManager.initConfig()
  },
  onDestroy() {
    console.info('SystemUI navigationBar Application onDestroy')
  },
}
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
import ServiceExtension from '@ohos.app.ability.ServiceExtensionAbility';
import Want from '@ohos.application.Want';
import Log from '../../../../../../common/src/main/ets/default/Log';
import AbilityManager from '../../../../../../common/src/main/ets/default/abilitymanager/abilityManager';
import initSystemUi from '../../../../../../common/src/main/ets/default/InitSystemUi';

const TAG = 'SystemUI_ServiceExtAbility';

class ServiceExtAbility extends ServiceExtension {
  onCreate(want: Want): void {
    Log.showInfo(TAG, `onCreate, want: ${JSON.stringify(want)}`);
    initSystemUi(this.context);
    AbilityManager.setContext(AbilityManager.ABILITY_NAME_ENTRY, this.context);
  }

  onDestroy(): void {
    Log.showInfo(TAG, 'onDestroy');
  }
}

export default ServiceExtAbility;
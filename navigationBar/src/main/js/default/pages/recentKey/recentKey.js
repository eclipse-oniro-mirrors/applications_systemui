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

import feature_ability from '@ohos.feature_ability';

const BUNDLE_NAME = "com.ohos.launcher";
const ABILITY_NAME = "com.ohos.launcher.recents.MainAbility";
const REQUEST_CODE = 1;
const ABILITY_TYPE = "PageAbility";
const ACTION = "action1";
const ENTITIES = ["entity1"];
const FLAGS = 2;
const DEVICE_ID = "deviceId";
const SYNC_OPTION =1;

export default {
    recentClick() {
        // launcher support
        console.log('onRecentClick:');
        var result = feature_ability.startAbility({
            bundleName: BUNDLE_NAME,
            abilityName: ABILITY_NAME,
            requestCode: REQUEST_CODE,
            abilityType: ABILITY_TYPE,
            want: {
                action: ACTION,
                entities: ENTITIES,
                type: ABILITY_TYPE,
                flags: FLAGS,
                elementName: {
                    deviceId: DEVICE_ID,
                    bundleName: BUNDLE_NAME,
                    abilityName: ABILITY_NAME,
                },
            },
            syncOption: SYNC_OPTION,
        }).then(data =>
        console.log('promise::then : ' + data)).catch(error =>
        console.log('promise::catch : ' + error));
    },
}
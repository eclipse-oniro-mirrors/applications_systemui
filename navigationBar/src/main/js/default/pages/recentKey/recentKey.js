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

import FeatureAbility from '@ohos.ability.featureability';
import mLog from '../../common/utils/Log.js';

const TAG = 'recentKey';
const RECENT_BUNDLE_NAME = 'com.ohos.launcher';
const RECENT_ABILITY_NAME = 'com.ohos.launcher.recents.MainAbility';

export default {
    /**
     * User clicks the recent button
     * Trigger "Recent" event
     */
    recentClick() {
        mLog.showInfo(TAG, `recent click and start ability recent`);
        let result = FeatureAbility.startAbility({
            want: {
                bundleName: RECENT_BUNDLE_NAME,
                abilityName: RECENT_ABILITY_NAME,
            },
        }).then(data =>
        mLog.showInfo(TAG, `promise then: ${JSON.stringify(data)}`)).catch(error =>
        mLog.showError(TAG, `promise catch: ${JSON.stringify(error)}`));
        mLog.showInfo(TAG, `start ability ${result}`);
    }
}
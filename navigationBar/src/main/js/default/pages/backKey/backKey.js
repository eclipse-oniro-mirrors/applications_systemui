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

import input from '@ohos.injectEventHandler';

var mDelayTime = 100;

const KEYCODE = 2;
const KEY_DOWN_DURATION = 1;

export default {
    backClick() {
        console.info('=====================test_inject_event back');
        var res;
        res = input.injectEventSync({
            isPressed: true,
            keyCode: KEYCODE,
            keyDownDuration: KEY_DOWN_DURATION
        });
        console.info('=====================test_inject_event down res = ' + res);
        setTimeout(function () {
            res = input.injectEventSync({
                isPressed: false,
                keyCode: KEYCODE,
                keyDownDuration: KEY_DOWN_DURATION
            });
            console.info('=====================test_inject_event up res = ' + res);
        }, mDelayTime);
    },
}
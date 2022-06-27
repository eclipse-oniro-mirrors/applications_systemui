/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import EventManager from './event/EventManager';
import Log from './Log';
import ScreenLockManager from './ScreenLockManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import TimeManager from './TimeManager';

const TAG = 'initSystemui';

export default function initSystemUi(context: ServiceExtensionContext): void {
  EventManager.setContext(context);
  ScreenLockManager.init().then(() => {
  }).catch(err => {
  });
  TimeManager.init(context);
  Log.showDebug(TAG, `init done, ctx: ${context}`);
}

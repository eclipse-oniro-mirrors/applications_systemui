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
import WindowManager from '../../../../../../common/src/main/ets/default/WindowManager.ets'
import StatusBarConfiguration from '../../../../../../features/statusbarcomponent/src/main/ets/com/ohos/common/StatusBarConfiguration.ets';

export default {
  async onCreate() {
    console.info('SystemUI statusBar Application onCreate')
    let val = await StatusBarConfiguration.getConfiguration();
    let mWindowManager = new WindowManager();
    await mWindowManager.initWindowManager();
    await mWindowManager.initWindowMin(val.realWidth, val.realHeight, val.xCoordinate, val.yCoordinate)

  },
  onDestroy() {
    console.info('SystemUI statusBar Application onDestroy')
  },
}

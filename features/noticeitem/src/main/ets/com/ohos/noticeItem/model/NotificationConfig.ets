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

import ReadConfigUtil from '../../../../../../../../../common/src/main/ets/default/ReadConfigUtil.ets';
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';

const FILE_URI = '/data/accounts/account_0/applications/com.ohos.systemui'
+ '/com.ohos.systemui.statusbar/assets/{0}/resources/rawfile/notificationConfig.json'

const TAG = 'NotificationConfig'

export class NotificationConfig {
  static USE_NOTIFICATION_ICON = true;

  readNotificationConfig(deviceType: string): any{
    Log.showInfo(TAG, `readSlidingLength deviceType:${deviceType}`);
    let notificationConfig = ReadConfigUtil.ReadConfigFile(FILE_URI.replace('{0}', deviceType))
    return notificationConfig
  }
}

let notificationConfig = new NotificationConfig();

export default notificationConfig as NotificationConfig;
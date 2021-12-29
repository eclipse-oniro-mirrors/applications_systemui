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

import timeModel from '../timeModel.ets'
import Log from '../../../../../../../common/src/main/ets/default/Log.ets'
import featureAbility from '@ohos.ability.featureAbility'
import settings from '@ohos.settingsnapi';

const TAG = 'ClockComponent-clockIcon';

const LOOP_TIME = 20000;

@Component
export default struct ClockIcon {
  @StorageLink('time') mTime: string = '16:01'
  isUsing24hFormat: boolean

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear');
    timeModel.initTimeModel(this.isUsing24hFormat);
    var isOnChange: boolean = false;
    var timeInterval = setInterval(() => {
      if (isOnChange) {
        return;
      }
      Log.showInfo(TAG, 'setInterval')
      let urivar = settings.getUri('settings.time.format')
      Log.showInfo(TAG, 'urivar = ' + urivar)
      let helper = featureAbility.acquireDataAbilityHelper(urivar);
      Log.showInfo(TAG, ' helper = ' + helper)
      helper.on("dataChange", urivar, (err) => {
        if (err.code !== 0) {
          Log.showError(TAG, `failed to getAbilityWant because ${err.message}`);
          return;
        } else {
          let getRetValue = settings.getValue(helper, 'settings.time.format', '24')
          Log.showInfo(TAG, 'observer reveive notifychange on success format = ' + getRetValue)
          if (getRetValue === '12') {
            isOnChange = true;
            this.isUsing24hFormat = false;
          } else if (getRetValue === '24') {
            isOnChange = true;
            this.isUsing24hFormat = true;
          }
          timeModel.initTimeModel(this.isUsing24hFormat);
        }
        Log.showInfo(TAG, 'observer reveive notifychange on success data : ' + JSON.stringify(err))
      })
    }, LOOP_TIME);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear');
    timeModel.unInitTimeModel();
  }

  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(this.mTime)
        .fontColor($r('app.color.clock_text_color'))
        .fontSize($r('app.float.clock_fontsize'))
    }
    .width($r('app.float.clock_maxwidth'))
  }
}
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

import brightness from '@ohos.brightness';
import Log from '../../../../../../../../../../common/src/main/ets/default/Log.ets';
import commonEvent from '@ohos.commonevent';

const TAG = 'BrightnessManager';
const EVENT = 'BRIGHTNESS_VALUE_SYSTEM_UI';
let mCommonEventSubscribeInfo = {
  events: ['BRIGHTNESS_VALUE']
};
let curValue = 10;
let mCommonEventSubscriber =null;
var mAppStorage = AppStorage.GetOrCreate();
var mBrightnessValue = mAppStorage.setAndLink("BrightnessValue",0);

export class brightnessManager{

  registerBrightnessListener() {
    Log.showInfo(TAG, 'registerBrightnessListener status listener ===========');
    if(mCommonEventSubscriber == null){
      commonEvent.createSubscriber(
        mCommonEventSubscribeInfo,
        this.createBrightnessSubscriberCallBack.bind(this)
      );
    }
  }

  createBrightnessSubscriberCallBack(err, data) {
    Log.showInfo(TAG, `Subscriberregister createBrightnessSubscriberCallBack ${JSON.stringify(err)} ${JSON.stringify(data)}`);
    mCommonEventSubscriber = data;
    commonEvent.subscribe(mCommonEventSubscriber, this.BrightnessSubscriberCallBack.bind(this));
  }

  BrightnessSubscriberCallBack(err, data) {
    Log.showInfo(TAG,`Subscriberregister data == ${JSON.stringify(data)}`);
    Log.showInfo(TAG, `Subscriberregister err == ${JSON.stringify(err)}`);
    if (err.code == 0) {
      if(data.data == '-1'){
        this.sendEvent(mBrightnessValue.get());
      }else{
        mBrightnessValue.set(data.data);
      }
    }else{
      Log.showInfo(TAG,'Subscriberregister error when subscribing ========');
    }
  }

  unregisterWiFiStatusListener() {
    commonEvent.unsubscribe(mCommonEventSubscriber, () => {
      Log.showInfo(TAG, `Subscriberregister unregister Wifi Status Listener ===============`);
    });
  }

  setValue(callback) {
    let value = parseInt(callback.value);
    Log.showInfo(TAG, `setValue ${ value }`);
    mBrightnessValue.set(value);
    this.sendEvent(mBrightnessValue.get().toString());
    brightness.setValue(value);
    Log.showInfo(TAG, `setValue ${ value } end`);
  }

  sendEvent(value){
    Log.showInfo(TAG, `sendEvent ${ value }`);
    let commonEventPublishData = {
      bundleName: 'com.ohos.systemui',
      code:1,
      data: value
    }
    commonEvent.publish(EVENT,commonEventPublishData,(err,data)=> {
      console.log(`sendEvent err ${JSON.stringify(err)}`);
      console.log(`sendEvent data ${JSON.stringify(data)}`);
    });
  }
}

let mBrightnessManager = new brightnessManager();
export default mBrightnessManager as brightnessManager;
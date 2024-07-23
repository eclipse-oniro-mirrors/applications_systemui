/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import rpc from '@ohos.rpc';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import Constants from '../common/Constants';
import type { IDialogParameters } from '../controller/Controller';

const TAG = 'Dialog-Index';

const storage = LocalStorage.GetShared();

@Entry(storage)
@Component
struct Index {
  @LocalStorageProp('connectId') connectId: string = undefined;
  @LocalStorageProp('windowName') windowName: string = undefined;
  @LocalStorageProp('parameters') parameters: IDialogParameters = undefined;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear r ${this.connectId} ${this.windowName} ${JSON.stringify(this.parameters)}`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear ${this.connectId} ${this.windowName} ${JSON.stringify(this.parameters)}`)
  }

  onOk() {
    Log.showDebug(TAG, `onOk start`);

    const controller = globalThis[Constants.SYSTEM_DIALOG_CONTROLLER];
    const { remoteObject } = controller.getData().get(this.connectId);
    if (remoteObject) {
      Log.showDebug(TAG, `onOk ${remoteObject}`);

      let data = rpc.MessageSequence.create();
      let reply = rpc.MessageSequence.create();
      let option = new rpc.MessageOption();
      remoteObject.sendMessageRequest(1, data, reply, option)
        .then(
          (result) => Log.showDebug(TAG, `onOk success ${JSON.stringify(result)}`),
          (error) => {
            Log.showDebug(TAG, `onOk error ${JSON.stringify(error)}`);
            this.onClose();
          }
        ).finally(() => {
          data.reclaim();
          reply.reclaim();
        });
    }

    Log.showInfo(TAG, 'onOk end');
  }

  onClose() {
    Log.showDebug(TAG, `onClose start`);
    const controller = globalThis[Constants.SYSTEM_DIALOG_CONTROLLER];
    controller?.destroyWindow(this.connectId);
    Log.showInfo(TAG, `onClose end`);
  }

  build() {
    Row() {
      UIExtensionComponent(this.parameters)
        .width('100%')
        .height('100%')
        .backgroundColor('#00000000')
        .onRelease(code => {
          Log.showDebug(TAG, `onRelease${code} start`);
          this.onClose();
          Log.showDebug(TAG, `onRelease${code} end`);
        })
        .onError(code => {
          Log.showDebug(TAG, `onError${code} start`);
          this.onClose();
          Log.showDebug(TAG, `onError${code} end`);
        })
    }
    .width('100%')
    .height('100%')
  }
}

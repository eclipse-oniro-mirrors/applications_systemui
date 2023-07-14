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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import Want from '@ohos.app.ability.Want';
import display from '@ohos.display';
import window from '@ohos.window';
import rpc from '@ohos.rpc';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import Constants, { ServiceStubCode } from '../common/Constants';
import SystemDialogController from '../controller/Controller';
import type { IDialogParameters } from '../controller/Controller';

const TAG = 'Dialog-ServiceExtensionAbility';

const getConnectId = (...args) => {
  return args.join('-');
};

const REPLY_SUCCESS_CODE = 0;

class Stub extends rpc.RemoteObject {
  onRemoteRequest(code: number, data, reply, option) {
    const connectId = getConnectId(rpc.IPCSkeleton.getCallingPid(), rpc.IPCSkeleton.getCallingTokenId());
    Log.showInfo(TAG, `onRemoteRequest start ${connectId}`);

    if (code === ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT) {
      Log.showInfo(TAG, `onRemoteRequest code:${ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT} start ${connectId}`);
      const controller = globalThis[Constants.SYSTEM_DIALOG_CONTROLLER];
      const remoteObject = data.readRemoteObject();
      Log.showDebug(TAG, `onRemoteRequest code:${ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT} ${remoteObject}`);

      if (remoteObject) {
        controller.addDataByKey(connectId, { remoteObject });
        Log.showDebug(TAG, `onRemoteRequest code:${ServiceStubCode.COMMAND_SEND_REMOTE_OBJECT} end`);

        reply.writeInt(REPLY_SUCCESS_CODE);
        return true;
      }

      return false;
    }

    if (code === ServiceStubCode.COMMAND_START_DIALOG) {
      Log.showInfo(TAG, `onRemoteRequest code:${ServiceStubCode.COMMAND_START_DIALOG} ${connectId}`);
      const size = data.readInt();
      const parameters: { [key: string]: any } = {};

      for (let i = 0; i < size; i++) {
        const key = data.readString();
        const value = data.readString();
        parameters[key] = value;
      }

      if (parameters.parameters) {
        try {
          const parse = JSON.parse(parameters.parameters);
          if (typeof parse === 'object') {
            parameters.parameters = parse;
            Log.showDebug(TAG, `onRemoteRequest parameters ${parameters.parameters}`);
          }
        } catch {
          parameters.parameters = undefined;
        }
      }

      this.createWindow(connectId, parameters);

      reply.writeInt(REPLY_SUCCESS_CODE);
      return true;
    }

    return false;
  }

  async createWindow(connectId: string, parameters: IDialogParameters) {
    const controller = globalThis[Constants.SYSTEM_DIALOG_CONTROLLER];
    const current = controller.getData().get(connectId);
    if (current && current.windowName) {
      Log.showInfo(TAG, `createWindow <this same> connectId:${connectId}`);
      controller.destroyWindow(connectId, false);
    }

    const windowName = `SystemDialog${++controller.count}`;
    Log.showInfo(TAG, `createWindow <start> windowName:${windowName} connectId:${connectId} parameters:${JSON.stringify(parameters)}`);

    controller.addDataByKey(connectId, { windowName, parameters });

    const navigationBarRect = await display.getDefaultDisplay().then(dis => {
      return {
        left: 0,
        top: 0,
        width: dis.width,
        height: dis.height
      };
    });
    Log.showInfo(TAG, `createWindow <getDefaultDisplay> ${JSON.stringify(navigationBarRect)}`);
    const win = await window.createWindow({
      ctx: controller.getContext(),
      name: windowName,
      windowType: window.WindowType.TYPE_FLOAT
    });
    Log.showDebug(TAG, 'createWindow <window.createWindow>');

    const localStorage = new LocalStorage({ windowName, connectId, parameters });

    await win.moveWindowTo(navigationBarRect.left, navigationBarRect.top);
    await win.resize(navigationBarRect.width, navigationBarRect.height);
    await win.loadContent('pages/ExtIndex', localStorage);
    await win.setWindowBackgroundColor('#00000000');
    await win.showWindow();

    Log.showDebug(TAG, `createWindow end`);
  }
}

export default class DialogServiceExtAbility extends ServiceExtensionAbility {
  onCreate(want: Want) {
    Log.showInfo(TAG, 'onCreate');
    globalThis[Constants.SYSTEM_DIALOG_CONTROLLER] = new SystemDialogController(this.context);
  }

  onConnect() {
    Log.showInfo(TAG, 'onConnect');
    return new Stub('SystemDialog');
  }

  onDisconnect() {
    Log.showInfo(TAG, 'onDisconnect');
  }

  onDestroy() {
    const controller = globalThis[Constants.SYSTEM_DIALOG_CONTROLLER];
    controller.destroyAllWindow();
    globalThis[Constants.SYSTEM_DIALOG_CONTROLLER] = undefined;

    Log.showInfo(TAG, 'onDestroy end');
  }
}

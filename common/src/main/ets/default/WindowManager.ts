//@ts-nocheck
/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import Window from '@ohos.window';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import Log from './Log';
import EventManager from './event/EventManager';
import { obtainLocalEvent } from './event/EventUtil';
import { Rect } from './Constants';
import createOrGet from './SingleInstanceHelper';

export type WindowInfo = {
  visibility: boolean;
  rect: Rect;
};

export enum WindowType {
  STATUS_BAR = 'SystemUi_StatusBar',
  NAVIGATION_BAR = 'SystemUi_NavigationBar',
  DROPDOWN_PANEL = 'SystemUi_DropdownPanel',
  NOTIFICATION_PANEL = 'SystemUi_NotificationPanel',
  CONTROL_PANEL = 'SystemUi_ControlPanel',
  VOLUME_PANEL = 'SystemUi_VolumePanel',
  BANNER_NOTICE = 'SystemUi_BannerNotice',
  SPLIT_BAR = 'SystemUi_SplitBar',
  PRIVACY_INDICATOR = 'SystemUi_PrivacyIndicator'
}

export const WINDOW_SHOW_HIDE_EVENT = 'WindowShowHideEvent';

export const WINDOW_RESIZE_EVENT = 'WindowResizeEvent';

export const WINDOW_Destroy = 'WindowDestroy';

const TAG = "WindowManager";

const SYSTEM_WINDOW_TYPE_MAP: { [key in WindowType]: Window.WindowType } = {
  SystemUi_StatusBar: Window.WindowType.TYPE_STATUS_BAR,
  SystemUi_NavigationBar: Window.WindowType.TYPE_NAVIGATION_BAR,
  SystemUi_DropdownPanel: Window.WindowType.TYPE_PANEL,
  SystemUi_NotificationPanel: Window.WindowType.TYPE_VOLUME_OVERLAY,
  SystemUi_ControlPanel: Window.WindowType.TYPE_VOLUME_OVERLAY,
  SystemUi_VolumePanel: Window.WindowType.TYPE_VOLUME_OVERLAY,
  SystemUi_BannerNotice: Window.WindowType.TYPE_VOLUME_OVERLAY,
  SystemUi_SplitBar: 2101,
  SystemUi_PrivacyIndicator: Window.WindowType.TYPE_VOLUME_OVERLAY
};

const DEFAULT_WINDOW_INFO: WindowInfo = {
  visibility: false,
  rect: { left: 0, top: 0, width: 0, height: 0 },
};

/**
 * Manage window size changes.
 */
class WindowManager {
  mWindowInfos: Map<WindowType, WindowInfo> = new Map();

  async createWindow(context: ServiceExtensionContext, name: WindowType, rect: Rect, loadContent: string): Promise<Window.Window> {
    Log.showInfo(TAG, `createWindow name: ${name}, rect: ${JSON.stringify(rect)}, url: ${loadContent}`);
    let winHandle = await Window.create(context, name, SYSTEM_WINDOW_TYPE_MAP[name]);
    await winHandle.moveTo(rect.left, rect.top);
    await winHandle.resetSize(rect.width, rect.height);
    await winHandle.loadContent(loadContent);
    this.mWindowInfos.set(name, { visibility: false, rect });
    Log.showInfo(TAG, `create window[${name}] success.`);
    return winHandle;
  }

  async resetSizeWindow(name: WindowType, rect: Rect): Promise<void> {
    let window = await Window.find(name);
    await window.moveTo(rect.left, rect.top);
    await window.resetSize(rect.width, rect.height);
    this.mWindowInfos.set(name, { ...(this.mWindowInfos.get(name) ?? DEFAULT_WINDOW_INFO), rect });
    EventManager.publish(
    obtainLocalEvent(WINDOW_RESIZE_EVENT, {
      windowName: name,
      rect,
    })
    );
    Log.showInfo(TAG, `resize window[${name}] success, rect: ${JSON.stringify(rect)}.`);
  }

  async moveTo(name: WindowType, rect: Rect): Promise<void> {
    Log.showInfo(TAG, `moveTo window[${name}] success, rect: ${JSON.stringify(rect)}.`);
    let window = await Window.find(name);
    await window.moveTo(rect.left, rect.top);
  }

  async showWindow(name: WindowType): Promise<void> {
    let window = await Window.find(name);
    await window.show();
    this.mWindowInfos.set(name, { ...(this.mWindowInfos.get(name) ?? DEFAULT_WINDOW_INFO), visibility: true });
    EventManager.publish(
    obtainLocalEvent(WINDOW_SHOW_HIDE_EVENT, {
      windowName: name,
      isShow: true,
    })
    );
    Log.showInfo(TAG, `show window[${name}] success.`);
  }

  async hideWindow(name: WindowType): Promise<void> {
    let window = await Window.find(name);
    await window.hide();
    this.mWindowInfos.set(name, { ...(this.mWindowInfos.get(name) ?? DEFAULT_WINDOW_INFO), visibility: false });
    EventManager.publish(
    obtainLocalEvent(WINDOW_SHOW_HIDE_EVENT, {
      windowName: name,
      isShow: false,
    })
    );
    Log.showInfo(TAG, `hide window[${name}] success.`);
  }

  async destroyWindow(name: WindowType): Promise<void> {
    let window = await Window.find(name);
    await window.destroy()
    this.mWindowInfos.delete(name)
    EventManager.publish((
    obtainLocalEvent(WINDOW_Destroy, {
      windowName: name,
      isDestroy: true
    }

    )
    ))
  }

  getWindowInfo(name: WindowType): WindowInfo | undefined {
    return this.mWindowInfos.get(name);
  }

  async setWindowBgColor(name: WindowType, bgColor: string): void {
      let window = await Window.find(name)
      window.setWindowBackgroundColor(bgColor);

  }

  async setWindowTouchable(windowName: string, touchable: boolean): void {
    let window = await Window.find(windowName)
    window.setWindowTouchable(touchable);
  }

}

let sWindowManager = createOrGet(WindowManager, TAG);

export default sWindowManager;

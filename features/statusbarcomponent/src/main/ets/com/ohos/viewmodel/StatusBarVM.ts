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

import Log from '../../../../../../../../common/src/main/ets/default/Log';
import createOrGet from '../../../../../../../../common/src/main/ets/default/SingleInstanceHelper';
import WindowManager, {WindowType} from '../../../../../../../../common/src/main/ets/default/WindowManager';
import TintStateManager, {TintState, TintContentInfo, getOrCreateTintContentInfo
} from '../../../../../../../../common/src/main/ets/default/TintStateManager';
import {FASlotName, Rect} from '../../../../../../../../common/src/main/ets/default/Constants';
import Constants, {StatusBarData, StatusBarBackgroundData, StatusBarComponentGroupContentData, StatusBarComponentData
} from '../common/Constants';
import StatusBarService from '../model/StatusBarService';

export const StatusBarLayoutKey = "StatusBarLayout";

export const StatusBarEmptyWidthKey = "StatusBarEmptyWidth";

const TAG = 'StatusBarVM';

export class StatusBarVM {
  mIsStart: boolean = false;
  mStatusBarLayout: string[][] = [[], [], []];
  mStatusBarEmptyWidth: any;
  mUseCount = 0;
  mStatusBarEnable: boolean = true;
  mBackgroundDatas: StatusBarBackgroundData[];
  mStatusBarData: StatusBarData = { ...new StatusBarData() }
  mComponentAreaMap: Map<string, Rect> = new Map();
  mComponentGroupContentDatas: StatusBarComponentGroupContentData[] = [
    new StatusBarComponentGroupContentData(), new StatusBarComponentGroupContentData(), new StatusBarComponentGroupContentData()];
  mEmptyTintContentInfo: TintContentInfo = getOrCreateTintContentInfo(FASlotName.EMPTY);
  mNotificationTintContentInfo: TintContentInfo = getOrCreateTintContentInfo(FASlotName.NOTIFICATION);
  mUseInWindowName: WindowType = WindowType.STATUS_BAR;

  constructor() {
    Log.showInfo(TAG, `constructor`)
    this.mStatusBarData = AppStorage.SetAndLink(TAG + '_StatusBarData', this.mStatusBarData).get();
    StatusBarService.setStatusBarData(this.mStatusBarData);

    this.mStatusBarLayout = AppStorage.SetAndLink(StatusBarLayoutKey, this.mStatusBarLayout).get();
    this.mStatusBarEmptyWidth = AppStorage.SetAndLink(StatusBarEmptyWidthKey, 0);

    let defaultBackgroundDatas: StatusBarBackgroundData[] = [];
    defaultBackgroundDatas.push(new StatusBarBackgroundData());
    defaultBackgroundDatas.push(new StatusBarBackgroundData());
    defaultBackgroundDatas.push(new StatusBarBackgroundData());
    if (this.mStatusBarData.showHorizontal) {
      defaultBackgroundDatas[0].width = this.mStatusBarData.realWidth;
    } else {
      defaultBackgroundDatas[0].width = this.mStatusBarData.realHeight;
    }
    this.mBackgroundDatas = AppStorage.SetAndLink(TAG + '_BackgroundDatas', defaultBackgroundDatas).get();

    StatusBarService.registerListener(this);
  }

  install() {
    Log.showInfo(TAG, `install, useCount: ${this.mUseCount}`);
    if (!this.mUseCount) {
      TintStateManager.getInstance().registerListener('status', this);
    }
    this.mUseCount++;
  }

  uninstall() {
    Log.showInfo(TAG, `uninstall, useCount: ${this.mUseCount}`);
    this.mUseCount--;
    if (this.mUseCount) {
      TintStateManager.getInstance().unregisterListener('status');
    }
  }

  initViewModel(config) {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `initViewModel, config: ${JSON.stringify(config)}`)
    this.mIsStart = true;

    this.install();
    StatusBarService.startService(config);
  }

  setStatusBarLayout(layout: string[][]): void{
    Log.showInfo(TAG, `setStatusBarLayout, layout: ${JSON.stringify(layout)}`)
    for (let i = 0;i < layout.length; i++) {
      if (JSON.stringify(layout[i]) != JSON.stringify(this.mStatusBarLayout[i])) {
        this.mStatusBarLayout[i] = layout[i];
      }
    }
  }

  setStatusBarEmptyWidth(width: number): void{
    Log.showInfo(TAG, `setStatusBarEmptyWidth, width: ${width}`)
    this.mStatusBarEmptyWidth.set(width);
  }

  setItemData(id: string, itemData: StatusBarComponentData): void{
    Log.showInfo(TAG, `setItemData, id: ${id} itemData: ${JSON.stringify(itemData)}`)
    let storageKey: string = 'StatusBar_' + id;
    if (itemData) {
      AppStorage.SetOrCreate(storageKey, itemData);
    } else {
      let deleteRs: boolean = AppStorage.Delete(storageKey);
      Log.showInfo(TAG, `setItemData, AppStorage.Delete rs: ${deleteRs} `)
    }
  }

  onTintStateChange(tintState: TintState) {
    Log.showInfo(TAG, `onTintStateChange, tintState: ${JSON.stringify(tintState)}`)
    if (typeof (tintState.isEnable) == 'boolean') {
      this.setStatusBarEnable(tintState.isEnable);
    }
    if (tintState.backgroundColor) {
      this.changeBackground(tintState);
    }
    if (tintState.contentColor) {
      this.changeContent(tintState);
    }
  }

  setStatusBarEnable(isEnable: boolean) {
    Log.showInfo(TAG, `setStatusBarEnable, isEnable ${isEnable}`);
    if (this.mStatusBarEnable == isEnable) {
      return;
    }
    this.mStatusBarEnable = isEnable;
    this.mStatusBarEnable ? WindowManager.showWindow(WindowType.STATUS_BAR) : WindowManager.hideWindow(WindowType.STATUS_BAR);
  }

  changeBackground(tintState: TintState): void{
    Log.showInfo(TAG, `changeBackground, backgroundColor: ${tintState.backgroundColor} region: ${JSON.stringify(tintState.region)}`)
    let data = new StatusBarBackgroundData();
    data.backgroundColor = tintState.backgroundColor;
    if (this.mStatusBarData.showHorizontal) {
      if (!tintState.region) {
        data.width = this.mStatusBarData.realWidth;
        this.mBackgroundDatas[0] = data;
        this.mBackgroundDatas[1] = new StatusBarBackgroundData();
        this.mBackgroundDatas[2] = new StatusBarBackgroundData();
      } else {
        data.width = tintState.region.width;
        if (tintState.region.left == this.mStatusBarData.left) {
          this.mBackgroundDatas[0] = data;
        } else if ((tintState.region.left + tintState.region.width) == (this.mStatusBarData.left + this.mStatusBarData.realWidth)) {
          this.mBackgroundDatas[2] = data;
        } else {
          this.mBackgroundDatas[1] = data;
        }
      }
    } else {
      if (!tintState.region) {
        data.width = this.mStatusBarData.realHeight;
        this.mBackgroundDatas[0] = data;
        this.mBackgroundDatas[1] = new StatusBarBackgroundData();
        this.mBackgroundDatas[2] = new StatusBarBackgroundData();
      } else {
        data.width = tintState.region.height;
        if (tintState.region.top == this.mStatusBarData.top) {
          this.mBackgroundDatas[0] = data;
        } else if ((tintState.region.top + tintState.region.height) == (this.mStatusBarData.top + this.mStatusBarData.realHeight)) {
          this.mBackgroundDatas[2] = data;
        } else {
          this.mBackgroundDatas[1] = data;
        }
      }
    }
    Log.showInfo(TAG, `changeBackground, data: ${JSON.stringify(data)}`)
  }

  changeContent(tintState: TintState): void{
    Log.showInfo(TAG, `changeContent, contentColor: ${tintState.contentColor} region: ${JSON.stringify(tintState.region)}`)
    let data = new StatusBarComponentGroupContentData();
    data.contentColor = tintState.contentColor;
    if (this.mStatusBarData.showHorizontal) {
      if (!tintState.region) {
        data.width = this.mStatusBarData.realWidth;
        this.mComponentGroupContentDatas[0] = data;
        this.mComponentGroupContentDatas[1] = new StatusBarComponentGroupContentData();
        this.mComponentGroupContentDatas[2] = new StatusBarComponentGroupContentData();
      } else {
        data.width = tintState.region.width;
        if (tintState.region.left == this.mStatusBarData.left) {
          this.mComponentGroupContentDatas[0] = data;
        } else if ((tintState.region.left + tintState.region.width) == (this.mStatusBarData.left + this.mStatusBarData.realWidth)) {
          this.mComponentGroupContentDatas[2] = data;
        } else {
          this.mComponentGroupContentDatas[1] = data;
        }
      }
    } else {
      if (!tintState.region) {
        data.width = this.mStatusBarData.realHeight;
        this.mComponentGroupContentDatas[0] = data;
        this.mComponentGroupContentDatas[1] = new StatusBarComponentGroupContentData();
        this.mComponentGroupContentDatas[2] = new StatusBarComponentGroupContentData();
      } else {
        data.width = tintState.region.height;
        if (tintState.region.top == this.mStatusBarData.top) {
          this.mComponentGroupContentDatas[0] = data;
        } else if ((tintState.region.top + tintState.region.height) == (this.mStatusBarData.top + this.mStatusBarData.realHeight)) {
          this.mComponentGroupContentDatas[2] = data;
        } else {
          this.mComponentGroupContentDatas[1] = data;
        }
      }
    }
    Log.showInfo(TAG, `changeContent, data: ${JSON.stringify(data)}`)

    this.mComponentAreaMap.forEach((value: Rect, key: string) => {
      this.changeComponentContent(key, value);
    });
  }

  changeComponentContent(id: string, area: Rect): void{
    Log.showInfo(TAG, `changeComponentContent, id ${id} area: ${JSON.stringify(area)}`);
    if (this.mUseInWindowName != WindowType.STATUS_BAR) {
      this.setComponentContent(id, '#FFFFFFFF');
      return;
    }
    if ((this.mStatusBarData.showHorizontal && area.width == 0) || (!this.mStatusBarData.showHorizontal && area.height == 0)) {
      this.setComponentContent(id, '#FFFFFFFF');
      return;
    }
    let startPos = this.mStatusBarData.showHorizontal ? this.mStatusBarData.left : this.mStatusBarData.top;
    for (let group of this.mComponentGroupContentDatas) {
      if (group.width == 0) {
        continue;
      }
      let endPos = group.width + startPos;
      let componentStartPos: number;
      let componentEndPos: number;
      if (this.mStatusBarData.showHorizontal) {
        componentStartPos = area.left;
        componentEndPos = area.left + area.width;
      } else {
        componentStartPos = area.top;
        componentEndPos = area.top + area.height;
      }
      if (!(componentEndPos <= startPos) && !(componentStartPos >= endPos)) {
        this.setComponentContent(id, group.contentColor);
        break;
      }
      startPos = endPos;
    }
  }

  setComponentContent(id: string, contentColor: string): void{
    Log.showInfo(TAG, `setComponentContent, id ${id} contentColor: ${contentColor}`);
    getOrCreateTintContentInfo(id).contentColor = contentColor;
  }

  updateComponentArea(id: string, area: Area): void{
    Log.showInfo(TAG, `updateComponentArea, id ${id} area: ${JSON.stringify(area)}`);
    let areaInfo = {
      left: vp2px(area.globalPosition.x as number),
      top: vp2px(area.globalPosition.y as number),
      width: vp2px(area.width as number),
      height: vp2px(area.height as number)
    };
    this.mComponentAreaMap.set(id, areaInfo);
    this.changeComponentContent(id, areaInfo);
  }

  setUseInWindowName(name: WindowType): void {
    Log.showInfo(TAG, `setUseInWindowName, name ${name}`);
    this.mUseInWindowName = name;
    this.mComponentAreaMap.forEach((value: Rect, key: string) => {
      this.changeComponentContent(key, value);
    });
  }

  getStatusBarData(): StatusBarData {
    return this.mStatusBarData;
  }

  updateStatusBarData(data: StatusBarData): void{
    Log.showInfo(TAG, `updateStatusBarData, data: ${JSON.stringify(data)}`)
    for (let key in data) {
      this.mStatusBarData[key] = data[key];
    }
  }

  getEmptyTintContentInfo(): TintContentInfo{
    return this.mEmptyTintContentInfo;
  }

  getNotificationTintContentInfo(): TintContentInfo{
    return this.mNotificationTintContentInfo;
  }

  getPluginTintContentInfo(id: string): TintContentInfo{
    return getOrCreateTintContentInfo(id);
  }

  getBackgroundDatas(): StatusBarBackgroundData[]{
    return this.mBackgroundDatas;
  }
}

let sStatusBarVM = createOrGet(StatusBarVM, TAG);

export default sStatusBarVM as StatusBarVM;
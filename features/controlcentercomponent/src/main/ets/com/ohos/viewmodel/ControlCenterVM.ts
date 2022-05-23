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
import {ControlComponentData} from '../common/Constants';
import ControlCenterService from '../model/ControlCenterService';

export const ControlCenterComplexToggleLayoutKey = "ControlCenterComplexToggleLayout";

export const ControlCenterSimpleToggleLayoutKey = "ControlCenterSimpleToggleLayout";

const TAG = 'ControlCenterVM';

export class ControlCenterVM {
  mIsStart: boolean = false;
  mComplexToggleLayout: any;
  mSimpleToggleLayout: any;

  constructor() {
    Log.showInfo(TAG, `constructor`);
    this.mComplexToggleLayout = AppStorage.SetAndLink(ControlCenterComplexToggleLayoutKey, []);
    this.mSimpleToggleLayout = AppStorage.SetAndLink(ControlCenterSimpleToggleLayoutKey, []);
    ControlCenterService.registerListener(this);
  }

  initViewModel(config) {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `initViewModel, config: ${JSON.stringify(config)} `);
    this.mIsStart = true;

    ControlCenterService.startService(config);
  }

  setComplexToggleLayout(layout: string[]): void{
    Log.showDebug(TAG, `setComplexToggleLayout, layout: ${JSON.stringify(layout)}`);
    if (JSON.stringify(layout) != JSON.stringify(this.mComplexToggleLayout.get())) {
      this.mComplexToggleLayout.set(layout);
    }
    Log.showDebug(TAG, `setComplexToggleLayout, mComplexToggleLayout: ${JSON.stringify(this.mComplexToggleLayout.get())}`);
  }

  setSimpleToggleLayout(layout: string[]): void{
    Log.showDebug(TAG, `setSimpleToggleLayout, layout: ${JSON.stringify(layout)}`);
    if (JSON.stringify(layout) != JSON.stringify(this.mSimpleToggleLayout.get())) {
      this.mSimpleToggleLayout.set(layout);
    }
    Log.showDebug(TAG, `setSimpleToggleLayout, mSimpleToggleLayout: ${JSON.stringify(this.mSimpleToggleLayout.get())}`);
  }

  setItemData(id: string, itemData: ControlComponentData): void{
    Log.showDebug(TAG, `setItemData, id: ${id} itemData: ${JSON.stringify(itemData)}`);
    let storageKey: string = 'ControlCenter_' + id;
    if (itemData) {
      AppStorage.SetOrCreate(storageKey, itemData);
    } else {
      let deleteRs: boolean = AppStorage.Delete(storageKey);
      Log.showDebug(TAG, `setItemData, AppStorage.Delete rs: ${deleteRs} `);
    }
  }

  getDisplayingSimpleToggles(): string[]{
    let simpleToggles = this.mSimpleToggleLayout.get();
    Log.showDebug(TAG, `getDisplayingSimpleToggles, simpleToggles: ${JSON.stringify(simpleToggles)}`);
    return simpleToggles;
  }

  getHidingSimpleToggles(): string[] {
    Log.showDebug(TAG, `getHidingSimpleToggles`);
    return ControlCenterService.getHidingSimpleToggles();
  }

  getDefaultSimpleToggleLayout() {
    Log.showDebug(TAG, `getDefaultSimpleToggleLayout`);
    return ControlCenterService.getDefaultSimpleToggleLayout();
  }

  saveSimpleToggleLayout(layout: string[]): void{
    Log.showDebug(TAG, `saveSimpleToggleLayout, layout: ${JSON.stringify(layout)}`);
    ControlCenterService.saveSimpleToggleLayout(layout);
  }
}

let sControlCenterVM = createOrGet(ControlCenterVM, TAG);

export default sControlCenterVM as ControlCenterVM;
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

import Log from '../../../../../../../../common/src/main/ets/default/Log.ets';
import Constants from '../common/Constants.ets';
import ControlCenterService from '../model/ControlCenterService.ets';

export const ControlCenterComplexToggleLayoutKey = "ControlCenterComplexToggleLayout";

export const ControlCenterSimpleToggleLayoutKey = "ControlCenterSimpleToggleLayout";

const TAG = 'ControlCenterVM';

export class ControlCenterVM {
  mConfig: any;
  mIsStart: boolean = false;
  mComplexToggleLayoutTemplate: string[];
  mSimpleToggleLayoutTemplate: string[];
  mComplexToggleLayout: any;
  mSimpleToggleLayout: any;
  mAllSimpleToggles: string[] = [];

  initViewModel(config) {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `initViewModel, config: ${JSON.stringify(config)} `)
    this.mIsStart = true;
    this.mConfig = config;

    this.parseConfig(config);
    this.calcControlCenterLayout();

    ControlCenterService.registerListener({
      'addItem': this.onItemAdd.bind(this),
      'removeItem': this.onItemRemove.bind(this)
    });
    let filterIds: string[] = [];
    config.MetaToggles.forEach((metaToggle) => {
      filterIds.push(metaToggle.id)
    });
    ControlCenterService.startService(filterIds);
  }

  parseConfig(config) {
    Log.showInfo(TAG, `parseConfig, config: ${JSON.stringify(config)}`)

    this.mComplexToggleLayout = AppStorage.SetAndLink(ControlCenterComplexToggleLayoutKey, []);
    this.mSimpleToggleLayout = AppStorage.SetAndLink(ControlCenterSimpleToggleLayoutKey, []);
    Log.showInfo(TAG,
      `parseConfig, ComplexToggleLayout: ${JSON.stringify(this.mComplexToggleLayout.get())}`)
    Log.showInfo(TAG,
      `parseConfig, SimpleToggleLayout: ${JSON.stringify(this.mSimpleToggleLayout.get())}`)

    this.mComplexToggleLayoutTemplate = [];
    config.ComplexToggleLayout.forEach((name) => {
      this.mComplexToggleLayoutTemplate.push(name);
    });
    this.mSimpleToggleLayoutTemplate = [];
    config.TempDBSimpleToggleLayout.forEach((name) => {
      this.mSimpleToggleLayoutTemplate.push(name);
    });
    Log.showInfo(TAG,
      `parseConfig, ComplexToggleLayoutTemplate: ${JSON.stringify(this.mComplexToggleLayoutTemplate)}`)
    Log.showInfo(TAG,
      `parseConfig, SimpleToggleLayoutTemplate: ${JSON.stringify(this.mSimpleToggleLayoutTemplate)}`)

    config.LocalToggles.forEach((name) => {
      this.mAllSimpleToggles.push(name);
    });
    Log.showInfo(TAG, `parseConfig, allSimpleToggles: ${JSON.stringify(this.mAllSimpleToggles)}`)
  }

  onItemAdd(itemData) {
    Log.showInfo(TAG, `onItemAdd, itemData: ${JSON.stringify(itemData)}`)
    AppStorage.SetOrCreate(itemData.id, itemData);
    if (this.mAllSimpleToggles.indexOf(itemData.id) < 0) {
      this.mAllSimpleToggles.push(itemData.id);
      this.calcControlCenterLayout();
    }
    Log.showInfo(TAG, `onItemAdd, ComplexToggleLayout: ${JSON.stringify(this.mComplexToggleLayout.get())}`)
    Log.showInfo(TAG, `onItemAdd, SimpleToggleLayout: ${JSON.stringify(this.mSimpleToggleLayout.get())}`)
  }

  onItemRemove(itemData) {
    Log.showInfo(TAG, `onItemRemove, itemData: ${JSON.stringify(itemData)}`)
    if (this.mAllSimpleToggles.indexOf(itemData.id) >= 0) {
      this.mAllSimpleToggles.splice(this.mAllSimpleToggles.indexOf(itemData.id), 1);
      this.calcControlCenterLayout();
    }
    Log.showInfo(TAG, `onItemRemove, ComplexToggleLayout: ${JSON.stringify(this.mComplexToggleLayout.get())}`)
    Log.showInfo(TAG, `onItemRemove, SimpleToggleLayout: ${JSON.stringify(this.mSimpleToggleLayout.get())}`)
  }

  calcControlCenterLayout() {
    Log.showInfo(TAG, `calcControlCenterLayout`)

    let complexToggleLayout: string[] = [];
    this.mComplexToggleLayoutTemplate.forEach((name) => {
      if (this.mAllSimpleToggles.indexOf(name) >= 0) {
        complexToggleLayout.push(name);
      }
    });
    let simpleToggleLayout: string[] = [];
    this.mSimpleToggleLayoutTemplate.forEach((name) => {
      if (this.mAllSimpleToggles.indexOf(name) >= 0) {
        simpleToggleLayout.push(name);
      }
    });

    Log.showInfo(TAG, `calcControlCenterLayout, complexToggleLayout: ${JSON.stringify(complexToggleLayout)}`)
    Log.showInfo(TAG, `calcControlCenterLayout, simpleToggleLayout: ${JSON.stringify(simpleToggleLayout)}`)


    if (JSON.stringify(complexToggleLayout) != JSON.stringify(this.mComplexToggleLayout.get())) {
      this.mComplexToggleLayout.set(complexToggleLayout);
    }
    if (JSON.stringify(simpleToggleLayout) != JSON.stringify(this.mSimpleToggleLayout.get())) {
      this.mSimpleToggleLayout.set(simpleToggleLayout);
    }
    Log.showInfo(TAG, `calcControlCenterLayout, mComplexToggleLayout: ${JSON.stringify(this.mComplexToggleLayout.get())}`)
    Log.showInfo(TAG, `calcControlCenterLayout, mSimpleToggleLayout: ${JSON.stringify(this.mSimpleToggleLayout.get())}`)
  }
}

let controlCenterVM = new ControlCenterVM();

export default controlCenterVM as ControlCenterVM;
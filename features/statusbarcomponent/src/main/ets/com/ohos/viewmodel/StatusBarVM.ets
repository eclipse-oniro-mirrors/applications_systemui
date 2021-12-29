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
import StatusBarService from '../model/StatusBarService.ets';

export const StatusBarLayoutKey = "StatusBarLayout";

export const StatusBarEmptyWidthKey = "StatusBarEmptyWidth";

const TAG = 'StatusBarVM';

export class StatusBarVM {
  mConfig: any;
  mIsStart: boolean = false;
  mStatusBarLayoutGroupTemplate: any[] = [];
  mStatusBarLayout: any;
  mStatusBarEmptyWidth: any;

  initViewModel(config, windowSize) {
    if (this.mIsStart) {
      return;
    }
    Log.showInfo(TAG, `initViewModel, config: ${JSON.stringify(config)} windowSize: ${JSON.stringify(windowSize)}`)
    this.mIsStart = true;
    this.mConfig = config;

    StatusBarService.registerListener({
      'addItem': this.onItemAdd.bind(this),
      'removeItem': this.onItemRemove.bind(this),
      'onEmptyAreaChange': this.onEmptyAreaChange.bind(this)
    });

    let localSlotIds = this.parseConfig(config);

    let emptyAreaInfo = StatusBarService.initEmptyArea(config.emptyPosition, windowSize);
    Log.showInfo(TAG, `initViewModel initEmptyArea.callback, emptyAreaInfo: ${JSON.stringify(emptyAreaInfo)}`)
    if (emptyAreaInfo.position) {
      this.updateStatusBarLayoutGroupTemplateOnEmptyAreaChange(emptyAreaInfo.position);
      localSlotIds.push(Constants.EMPTY);
      this.calcStatusBarEmptyWidth(emptyAreaInfo.rotation);
    }

    this.calcStatusBarLayout(localSlotIds);

    let filterIds: string[] = [];
    for (let metaIconKey of config.metaIconKeys) {
      let includeFlg = false;
      for (let components of this.mStatusBarLayoutGroupTemplate) {
        if (components.indexOf(metaIconKey.metaIconId) >= 0) {
          includeFlg = true;
          break;
        }
      }
      if (includeFlg) {
        filterIds.push(metaIconKey.metaIconId);
      }
    }
    StatusBarService.startService(filterIds);
  }

  parseConfig(config) {
    Log.showInfo(TAG, `parseConfig, config: ${JSON.stringify(config)}`)

    this.mStatusBarLayout = AppStorage.SetAndLink(StatusBarLayoutKey, [[], [], []]);
    this.mStatusBarEmptyWidth = AppStorage.SetAndLink(
      StatusBarEmptyWidthKey, config.emptyPosition.x2 - config.emptyPosition.x1);
    Log.showInfo(TAG,
      `parseConfig, statusBarLayout: ${JSON.stringify(this.mStatusBarLayout.get())}`)
    Log.showInfo(TAG,
      `parseConfig, statusBarEmptyWidth: ${JSON.stringify(this.mStatusBarEmptyWidth.get())}`)

    const groupIds = [Constants.GROUP_ID_LEFT, Constants.GROUP_ID_CENTER, Constants.GROUP_ID_RIGHT];
    for (const groupId of groupIds) {
      for (const groupInfo of config.LayoutGroups) {
        if (groupId == groupInfo.id) {
          let components = [];
          for (let component of groupInfo.Components) {
            let componentId = component;
            for (let metaIconKey of config.metaIconKeys) {
              if (component == metaIconKey.layoutId) {
                componentId = metaIconKey.metaIconId;
                break;
              }
            }
            components.push(componentId);
          }
          this.mStatusBarLayoutGroupTemplate.push(components);
        }
      }
    }
    Log.showInfo(TAG,
      `parseConfig, statusBarLayoutGroupTemplate: ${JSON.stringify(this.mStatusBarLayoutGroupTemplate)}`)

    let localSlotIds = [];
    config.LocalSlots.forEach((name) => {
      localSlotIds.push(name);
    });
    Log.showInfo(TAG, `parseConfig, localSlotIds: ${JSON.stringify(localSlotIds)}`)
    return localSlotIds;
  }

  onItemAdd(itemData) {
    Log.showInfo(TAG, `onItemAdd, itemData: ${JSON.stringify(itemData)}`)
    AppStorage.SetOrCreate(itemData.id, itemData);
    let dispIds = this.getDispIds();
    if (dispIds.indexOf(itemData.id) < 0) {
      dispIds.push(itemData.id);
      this.calcStatusBarLayout(dispIds);
    }
    Log.showInfo(TAG, `onItemAdd, statusBarLayout: ${JSON.stringify(this.mStatusBarLayout.get())}`)
  }

  onItemRemove(itemData) {
    Log.showInfo(TAG, `onItemRemove, itemData: ${JSON.stringify(itemData)}`)
    let dispIds = this.getDispIds();
    if (dispIds.indexOf(itemData.id) >= 0) {
      dispIds.splice(dispIds.indexOf(itemData.id), 1);
      this.calcStatusBarLayout(dispIds);
    }
    Log.showInfo(TAG, `onItemRemove, statusBarLayout: ${JSON.stringify(this.mStatusBarLayout.get())}`)
  }

  onEmptyAreaChange(position: string, rotation: number) {
    Log.showInfo(TAG, `onEmptyAreaChange, position: ${position} rotation: ${rotation}`)

    this.updateStatusBarLayoutGroupTemplateOnEmptyAreaChange(position);

    let dispIds = this.getDispIds();
    if (dispIds.indexOf(Constants.EMPTY) >= 0) {
      dispIds.splice(dispIds.indexOf(Constants.EMPTY), 1);
    }
    if (position == Constants.EMPTY_AREA_POSITION_LEFT) {
      dispIds.push(Constants.EMPTY);
    } else if (position == Constants.EMPTY_AREA_POSITION_CENTER) {
      dispIds.push(Constants.EMPTY);
    } else if (position == Constants.EMPTY_AREA_POSITION_RIGHT) {
      dispIds.push(Constants.EMPTY);
    }
    Log.showInfo(TAG,
      `onEmptyAreaChange, dispIds: ${JSON.stringify(dispIds)}`)

    this.calcStatusBarEmptyWidth(rotation);

    this.calcStatusBarLayout(dispIds);
  }

  updateStatusBarLayoutGroupTemplateOnEmptyAreaChange(position: string) {
    Log.showInfo(TAG, `updateStatusBarLayoutGroupTemplateOnEmptyAreaChange, position: ${position}`)
    for (let i = 0;i < this.mStatusBarLayoutGroupTemplate.length; i++) {
      let componentsTemplate = this.mStatusBarLayoutGroupTemplate[i];
      let index = componentsTemplate.indexOf(Constants.EMPTY);
      if (index >= 0) {
        componentsTemplate.splice(index, 1);
        break;
      }
    }
    Log.showInfo(TAG, `updateStatusBarLayoutGroupTemplateOnEmptyAreaChange, ${JSON.stringify(this.mStatusBarLayoutGroupTemplate)}`)

    if (position == Constants.EMPTY_AREA_POSITION_LEFT) {
      this.mStatusBarLayoutGroupTemplate[0].splice(0, 0, Constants.EMPTY);
    } else if (position == Constants.EMPTY_AREA_POSITION_CENTER) {
      this.mStatusBarLayoutGroupTemplate[1].splice(0, 0, Constants.EMPTY);
    } else if (position == Constants.EMPTY_AREA_POSITION_RIGHT) {
      this.mStatusBarLayoutGroupTemplate[2].push(Constants.EMPTY);
    }
    Log.showInfo(TAG,
      `updateStatusBarLayoutGroupTemplateOnEmptyAreaChange, ${JSON.stringify(this.mStatusBarLayoutGroupTemplate)}`)
  }

  calcStatusBarEmptyWidth(rotation: number) {
    Log.showInfo(TAG, `calcStatusBarEmptyWidth, rotation: ${rotation}`)
    if (rotation == 0 || rotation == 180) {
      this.mStatusBarEmptyWidth.set(this.mConfig.emptyPosition.x2 - this.mConfig.emptyPosition.x1);
    } else {
      this.mStatusBarEmptyWidth.set(this.mConfig.emptyPosition.y2 - this.mConfig.emptyPosition.y1);
    }
    Log.showInfo(TAG,
      `calcStatusBarEmptyWidth, statusBarEmptyWidth: ${JSON.stringify(this.mStatusBarEmptyWidth.get())}`)
  }

  calcStatusBarLayout(dispIds: string[]) {
    Log.showInfo(TAG, `calcStatusBarLayout, dispIds: ${JSON.stringify(dispIds)}`)

    let statusBarLayout = [];
    for (let i = 0;i < this.mStatusBarLayoutGroupTemplate.length; i++) {
      let componentsTemplate = this.mStatusBarLayoutGroupTemplate[i];
      let components: string [] = [];
      for (let componentTemplate of componentsTemplate) {
        if (dispIds.indexOf(componentTemplate) >= 0) {
          components.push(componentTemplate);
        }
      }
      statusBarLayout.push(components);
    }
    Log.showInfo(TAG, `calcStatusBarLayout, statusBarLayout: ${JSON.stringify(statusBarLayout)}`)

    let statusBarLayoutCurrent = this.mStatusBarLayout.get();
    for (let i = 0;i < statusBarLayout.length; i++) {
      if (JSON.stringify(statusBarLayout[i]) != JSON.stringify(statusBarLayoutCurrent[i])) {
        statusBarLayoutCurrent[i] = statusBarLayout[i];
      }
    }
    Log.showInfo(TAG, `calcStatusBarLayout, statusBarLayoutCurrent: ${JSON.stringify(statusBarLayoutCurrent)}`)
  }

  getDispIds(): string[] {
    Log.showInfo(TAG, `getDispIds`)
    let dispIds: string[] = [];
    for (let ids of this.mStatusBarLayout.get()) {
      for (let id of ids) {
        dispIds.push(id);
      }
    }
    Log.showInfo(TAG, `getDispIds, dispIds: ${JSON.stringify(dispIds)}`)
    return dispIds;
  }
}

let statusBarVM = new StatusBarVM();

export default statusBarVM as StatusBarVM;
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

import bundleManager from "@ohos.bundle";
import commonEvent from '@ohos.commonEvent';
import Log from '../../default/Log.ets';
import CheckEmptyUtils from '../../default/CheckEmptyUtils.ets';
import SourceLoader from './SourceLoader.ets';
import Constants, {ItemComponentData, ActionData} from '../common/Constants.ets';

const TAG = "BaseMetaSourceLoader";

let mCommonEventSubscribeInfo = {
  events: [
    commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED,
    commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED,
    commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED
  ]
};

export default abstract class BaseMetaSourceLoader extends SourceLoader {
  mAction: string = null;
  mPermission: string = null;
  mFilterIds: string[] = null;
  mPluginType: number = null;
  mItemComponentDatas: ItemComponentData[] = [];
  mCommonEventSubscriber = null;
  mUserId: string = null;

  constructor(config, channel, pluginType) {
    super(channel);
    Log.showInfo(TAG, `constructor, config: ${JSON.stringify(config)} channel: ${channel} pluginType: ${pluginType}`)
    this.mPluginType = pluginType;
    this.initSourceLoader(config);
  }

  initSourceLoader(config) {
    Log.showInfo(TAG, `init loader, config: ${JSON.stringify(config)}`)

    this.mAction = config.action;
    this.mPermission = config.permission;
    this.mFilterIds = config.filterIds;

    Log.showInfo(TAG, `init loader, mCommonEventSubscribeInfo: ${JSON.stringify(mCommonEventSubscribeInfo)}`)
    commonEvent.createSubscriber(
      mCommonEventSubscribeInfo,
    this.createCommonEventSubscriberCallBack.bind(this)
    );
  }

  stopLoad() {
    Log.showInfo(TAG, `stop loader`)
    this.unRegisterCommonEventListener();
    this.removeAllItemComponentData();
  }

  loadData(userId) {
    Log.showInfo(TAG, `load loader userId = ` + userId)
    this.mUserId = userId;
    this.removeAllItemComponentData();
    this.addAbilityItemComponentData({
      "action": this.mAction
    });
  }

  createCommonEventSubscriberCallBack(err, data) {
    Log.showInfo(TAG, `createCommonEventSubscriberCallBack, err: ${JSON.stringify(err)}`);
    if (err.code != 0) {
      return;
    }

    this.mCommonEventSubscriber = data;
    commonEvent.subscribe(this.mCommonEventSubscriber, this.procCommonEventSubscriberCallBack.bind(this));
  }

  procCommonEventSubscriberCallBack(err, data) {
    Log.showInfo(TAG, `procCommonEventSubscriberCallBack, err: ${JSON.stringify(err)} data: ${JSON.stringify(data)}`);
    if (err.code != 0) {
      return;
    }

    let event = data.event;
    let bundleName = data.bundleName;
    if (event == commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED || event == commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED) {
      this.removeItemComponentData(bundleName);
    }
    if (event == commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED || event == commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED) {
      this.addAbilityItemComponentData({
        "bundleName": bundleName,
        "action": this.mAction
      });
    }
  }

  unRegisterCommonEventListener() {
    Log.showInfo(TAG, 'unRegisterCommonEventListener')
    commonEvent.unsubscribe(this.mCommonEventSubscriber, () => {
      Log.showInfo(TAG, 'unRegisterCommonEventListener unregister Listener ===============');
    });
  }

  removeAllItemComponentData(): void{
    Log.showInfo(TAG, `removeAllItemComponentData`);
    for (let itemComponentData of this.mItemComponentDatas) {
      this.removeItem(itemComponentData);
    }
    this.mItemComponentDatas = [];
  }

  addAbilityItemComponentData(want): void{
    Log.showInfo(TAG, `addAbilityItemComponentData, want: ${JSON.stringify(want)} BundleFlag: ${Constants.DEFAULT_BUNDLE_FLAG}this.mUserId:${this.mUserId}`);
    bundleManager.queryAbilityByWant(want, Constants.DEFAULT_BUNDLE_FLAG, this.mUserId ? this.mUserId : Constants.DEFAULT_USER_ID,
      (err, abilityInfos) => {
        Log.showInfo(TAG, `addAbilityItemComponentData queryAbilityByWant callback, want: ${JSON.stringify(want)} err: ${JSON.stringify(err)} abilityInfos: ${abilityInfos.length} ${JSON.stringify(abilityInfos)} `)
        if (err != 0) {
          return;
        }
        for (let abilityInfo of abilityInfos) {
          this.createItemComponentData(abilityInfo, (itemComponentData) => {
            this.addItemComponentData(itemComponentData);
          });
        }
        Log.showInfo(TAG, `addAbilityItemComponentData, mItemComponentDatas: ${JSON.stringify(this.mItemComponentDatas)} `)
      });
  }

  createItemComponentData(abilityInfo, callback: Function): void{
    Log.showInfo(TAG, `createItemComponentData, abilityInfo: ${JSON.stringify(abilityInfo)}`);

    let pluginData: any = null;
    Log.showInfo(TAG, `abilityInfo.metaData: ${JSON.stringify(abilityInfo.metaData)}`);
    if (abilityInfo.metaData) {
      for (let index in abilityInfo.metaData) {
        if (abilityInfo.metaData[index].name == this.mAction) {
          Log.showInfo(TAG, `customizeData.extra: ${abilityInfo.metaData[index].extra}`);
          pluginData = JSON.parse("{" + abilityInfo.metaData[index].extra + "}");
          break;
        }
      }
    }
    Log.showInfo(TAG, `createItemComponentData, pluginData: ${JSON.stringify(pluginData)}`);
    if (!pluginData && parseInt(pluginData.pluginType) != this.mPluginType) {
      return;
    }
    if (this.mFilterIds.indexOf(pluginData.id) < 0) {
      return;
    }

    let itemComponentData = new ItemComponentData();
    {
      itemComponentData.id = pluginData.id;
      itemComponentData.pluginType = this.mPluginType;
      itemComponentData.deviceId = null;
      itemComponentData.bundleName = abilityInfo.bundleName;
      itemComponentData.abilityName = abilityInfo.name;
      itemComponentData.abilityLabelId = abilityInfo.labelId;
      itemComponentData.abilityIconId = abilityInfo.iconId;
      if (!CheckEmptyUtils.isEmpty(pluginData.label)) {
        itemComponentData.label = encodeURIComponent(pluginData.label);
      }
      if (!CheckEmptyUtils.isEmpty(pluginData.icon)) {
        itemComponentData.iconUrl = pluginData.icon;
      }
      if (!CheckEmptyUtils.isEmpty(pluginData.template)) {
        itemComponentData.template = pluginData.template;
      }
      {
        let actionData = new ActionData();
        actionData.clickAction = pluginData.clickAction;
        actionData.longClickAction = pluginData.longClickAction;
        actionData.launchType = pluginData.launchType;
        actionData.pluginData = pluginData.pluginData;
        actionData.extra = pluginData.extra;
        itemComponentData.actionData = actionData;
      }
    }

    Log.showInfo(TAG, `createItemComponentData, itemComponentData: ${JSON.stringify(itemComponentData)}`);
    callback(itemComponentData);
  }

  addItemComponentData(itemComponentData): void {
    Log.showInfo(TAG, `addItemComponentData, itemComponentData: ${JSON.stringify(itemComponentData)} `);
    this.addItem(itemComponentData);
    this.mItemComponentDatas.push(itemComponentData);
  }

  removeItemComponentData(bundleName): void {
    Log.showInfo(TAG, `removeItemComponentData, bundleName: ${bundleName}`);
    let deleteIndexs = [];
    for (let i = 0;i < this.mItemComponentDatas.length; i++) {
      if (this.mItemComponentDatas[i].bundleName == bundleName) {
        deleteIndexs.push(i);
      }
    }
    Log.showInfo(TAG, `removeItemComponentData, deleteIndexs: ${JSON.stringify(deleteIndexs)}`);
    for (let i = (deleteIndexs.length - 1);i >= 0; i--) {
      let itemComponentData = this.mItemComponentDatas[deleteIndexs[i]];
      this.removeItem(itemComponentData);
      this.mItemComponentDatas.splice(deleteIndexs[i], 1);
    }
    Log.showInfo(TAG, `removeItemComponentData, mItemComponentDatas: ${JSON.stringify(this.mItemComponentDatas)}`);
  }
}
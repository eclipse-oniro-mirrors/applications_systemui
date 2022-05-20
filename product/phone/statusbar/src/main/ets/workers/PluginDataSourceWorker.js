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

import worker from "@ohos.worker";
import Log from "../../../../../../../common/src/main/ets/default/log";
import PluginDataSourceManager
from "../../../../../../../common/src/main/ets/plugindatasource/plugindatasourcemanager";
import Constants, { obtainMsg } from "../../../../../../../common/src/main/ets/plugindatasource/common/constants";

const parentPort = worker.parentPort;
const TAG = `${parentPort.name} Worker`;
Log.showInfo(TAG, `Start.`);

var sManager;

parentPort.onmessage = (msg) => {
    Log.showInfo(TAG, `onMessage, msg = ${JSON.stringify(msg)}`);
    let data = msg.data;
    switch (data.action) {
        case Constants.INIT_CONFIG:
            initConfig(data.data);
            break;
        case Constants.CLEAR_ALL:
            clearAll();
            break;
        case Constants.LOAD_DATA:
            loadData(data.data);
            break;
        default:
            Log.showError(TAG, `onMessage, unknown action type.`);
    }
};

function initConfig(config) {
    Log.showInfo(TAG, `initConfig, config = ${JSON.stringify(config)}`);
    sManager = new PluginDataSourceManager({
        onItemAdd: (itemData) => {
            Log.showInfo(TAG, `sManager.onItemAdd, itemData = ${JSON.stringify(itemData)}`);
            itemData.label && (itemData.label = encodeURIComponent(itemData.label));
            parentPort.postMessage(obtainMsg(Constants.ADD_ITEM, itemData));
        },
        onItemRemove: (itemData) => {
            Log.showInfo(TAG, `sManager.onItemRemove, itemData = ${JSON.stringify(itemData)}`);
            parentPort.postMessage(obtainMsg(Constants.REMOVE_ITEM, itemData));
        },
    });
    sManager.initDataSource(config);
    parentPort.postMessage(obtainMsg(Constants.INIT_FINISH, {}));
}

function clearAll() {
    Log.showInfo(TAG, `clearAll `);
    sManager?.clearAll();
}

function loadData(userId) {
    Log.showInfo(TAG, `loadData `);
    sManager?.loadData(userId);
}

parentPort.onclose = function () {
    Log.showInfo(TAG, `onclose`);
};

parentPort.onmessageerror = function () {
    Log.showInfo(TAG, `onmessageerror`);
};

parentPort.onerror = function (data) {
    Log.showInfo(
        TAG,
        `onerror, lineno = ${data.lineno}, msg = ${data.message}, filename = ${data.filename}, col = ${data.colno}`
    );
};
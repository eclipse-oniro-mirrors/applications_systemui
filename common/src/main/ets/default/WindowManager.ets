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

import Window from '@ohos.window';
import Log from './Log.ets';

const TAG = 'WindowManager';
const MAX_WIDTH = 480;
const MAX_HEIGHT = 893;
const MIN_HEIGHT = 67;

/**
 * Manage window size changes.
 */
export default class WindowManager {

  /**
     * Set the window to the maximum size.
     *
     * @param {Object} callback - Callback function.
     */
  setWindowMax(callback) {
    Log.showInfo(TAG, 'enter setWindowMax =================');
    Window.getTopWindow().then((windowData)=> {
      windowData.resetSize(MAX_WIDTH, MAX_HEIGHT).then((result)=> {
        Log.showInfo(TAG, result);
        callback(result);
      });
    });
  }

  /**
     * Set the window to the minimum size.
     *
     * @param {Object} callback - Callback function.
     */
  setWindowMin(callback) {
    Log.showInfo(TAG, 'enter setWindowMin =================');
    Window.getTopWindow().then((windowData)=> {
      windowData.resetSize(MAX_WIDTH, MIN_HEIGHT).then((result)=> {
        Log.showInfo(TAG, result);
        callback(result);
      });
    });
  }
}
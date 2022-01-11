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
import display from '@ohos.display'
import Log from './Log.ets';
import ResourceUtil from './ResourceUtil.ets';

const TAG = 'WindowManager';

var maxWidth;
var maxHeight;
var minHeight;

/**
 * Manage window size changes.
 */
export default class WindowManager {
  async initWindowManager() {
    Log.showInfo(TAG, 'initWindowManager');
    maxWidth = AppStorage.SetAndLink("maxWidth", 0);
    maxHeight = AppStorage.SetAndLink("maxHeight", 0);
    minHeight = AppStorage.SetAndLink("minHeight", 0);

    await display.getDefaultDisplay()
      .then(dis => {
        maxWidth.set(dis.width);
        maxHeight.set(dis.height);
        Log.showInfo(TAG, `initWindowManager maxWidth ${maxWidth.get()} maxHeight ${maxHeight.get()} minHeight ${minHeight.get()}`);
      })
  }

  /**
     * Set the window to the maximum size.
     *
     * @param {Object} callback - Callback function.
     */
  setWindowMax(callback) {
    Log.showInfo(TAG, 'enter setWindowMax =================');
    Window.getTopWindow()
      .then((windowData) => {
        Log.showInfo(TAG, 'enter setWindowMin maxWidth =================' + maxWidth.get() + " minHeight " + minHeight.get());
        windowData.resetSize(parseInt(maxWidth.get()), parseInt(maxHeight.get()))
          .then((result) => {
            Log.showInfo(TAG, result);
            callback(result);
          });

        windowData.moveTo(0, 0)
          .then((result) => {
            Log.showInfo(TAG, result);
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
    Window.getTopWindow()
      .then((windowData) => {
        Log.showInfo(TAG, 'enter setWindowMin maxWidth =================' + maxWidth.get() + " minHeight " + minHeight.get());
        windowData.resetSize(parseInt(maxWidth.get()), parseInt(minHeight.get()))
          .then((result) => {
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
  async initWindowMin(width, height, x, y) {
    AppStorage.Set("showStatusBar", true);
    Log.showInfo(TAG, 'enter initWindowMin =================');
    Log.showInfo(TAG, 'width:' + width + '   height:' + height + '   x:' + x + '   y:' + y);
    let abilityWindow = await Window.getTopWindow();
    await abilityWindow.moveTo(parseInt(x), parseInt(y));
    await abilityWindow.resetSize(parseInt(width), parseInt(height));
  }
}
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

import display from '@ohos.display'
import Log from '../../../../../../../../common/src/main/ets/default/Log'
import ResourceUtil from '../../../../../../../../common/src/main/ets/default/ResourceUtil'

const TAG = 'StatusBarConfiguration';

var statusbarPosition;
var directionStatus;
var shortSideLength = '0';

var maxWidth;
var maxHeight;
var minHeight;
var realWidth;
var realHeight;
var xCoordinate = 0;
var yCoordinate = 0;

enum Position {
  NOT_CONFIGURED,
  LEFT_POSITION,
  TOP_POSITION,
  RIGHT_POSITION,
  BOTTOM_POSITION
}

/**
 * Get window size.
 */
class StatusBarConfiguration {
  async initStatusBarConfiguration() {
    Log.showInfo(TAG, 'initWindowManager');
    minHeight = 0;

    let displayData = null;
    while (displayData == null) {
      await display.getDefaultDisplay()
        .then((res) => {
          displayData = res;
          maxWidth = res.width;
          maxHeight = res.height;
          Log.showInfo(TAG, `getDefaultDisplay maxWidth ${maxWidth} maxHeight ${maxHeight} minHeight ${minHeight}`);
        })
        .catch((err) => {
          Log.showError(TAG, `getDefaultDisplay err:${JSON.stringify(err)}`);
        });
      await new Promise((resolve) => setTimeout(resolve, 2000));
    }
  }

  async getDirectionAndPosition() {
    Log.showInfo(TAG, 'getDirectionAndPosition');
    directionStatus = await ResourceUtil.getConfiguration();
    if (directionStatus.direction == -1) {
      Log.showInfo(TAG, 'direction is -1');
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_landscape"))
      shortSideLength = await ResourceUtil.getString($r("app.string.status_bar_size_landscape"));
    } else if (directionStatus.direction == 1) {
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_landscape"))
      shortSideLength = await ResourceUtil.getString($r("app.string.status_bar_size_landscape"));
    } else {
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_portrait"))
      shortSideLength = await ResourceUtil.getString($r("app.string.status_bar_size_portrait"));
    }
    shortSideLength = parseInt(shortSideLength) + '';
    Log.showInfo(TAG, 'directionStatus = ' + directionStatus.direction + 'statusbarPosition = ' + statusbarPosition +
    'shortSideLength = ' + shortSideLength);
  }

/**
   * Get status bar configuration
   */
  public async getConfiguration() {
    await this.initStatusBarConfiguration();
    await this.getDirectionAndPosition();
    let showHorizontal = false;
    let ableToMaximize = false;
    if (statusbarPosition == Position.TOP_POSITION || statusbarPosition == Position.BOTTOM_POSITION) {
      Log.showInfo(TAG, `getConfiguration`);
      showHorizontal = true;
      minHeight = parseInt(shortSideLength);
      realWidth = maxWidth;
      realHeight = parseInt(shortSideLength);
      if (statusbarPosition == Position.BOTTOM_POSITION) {
        yCoordinate = parseInt(maxHeight) - parseInt(shortSideLength);
      }
      ableToMaximize = true;
    } else if (statusbarPosition == Position.LEFT_POSITION || statusbarPosition == Position.RIGHT_POSITION) {
      showHorizontal = false;
      ableToMaximize = false;
      minHeight = parseInt(shortSideLength);
      realWidth = parseInt(shortSideLength);
      realHeight = maxHeight;
      if (statusbarPosition == Position.RIGHT_POSITION) {
        xCoordinate = parseInt(maxWidth) - parseInt(shortSideLength);
      }
    } else {
      realWidth = 0;
      realHeight = 0;
    }
    Log.showInfo(TAG, `initWindowManager xCoordinate ${xCoordinate} yCoordinate ${yCoordinate} realWidth ${realWidth} realHeight ${realHeight}`);

    var configuration = {
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      minHeight: minHeight,
      showHorizontal: showHorizontal,
      ableToMaximize: ableToMaximize,
      realWidth: realWidth,
      realHeight: realHeight,
      xCoordinate: xCoordinate,
      yCoordinate: yCoordinate
    }
    return configuration;
  }
}

let statusBarConfiguration = new StatusBarConfiguration();

export default statusBarConfiguration;
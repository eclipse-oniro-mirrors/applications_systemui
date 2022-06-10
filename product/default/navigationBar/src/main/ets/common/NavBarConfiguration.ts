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

import display from '@ohos.display';
import Log from '../../../../../../../common/src/main/ets/default/log';
import ResourceUtil from '../../../../../../../common/src/main/ets/default/resourceutil';

const TAG = 'NavBarConfiguration';
var directionNav;
var navbarPosition;
var statusbarPosition;
var navShortSideLength = '0';
var statusShortSideLength = '0';

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
class NavBarConfiguration {
  async initNavBarConfiguration() {
    Log.showDebug(TAG, 'initNavBarConfiguration');
    minHeight = 0;

    await display.getDefaultDisplay()
      .then(dis => {
        Log.showInfo(TAG, `initNavBarConfiguration dis ${JSON.stringify(dis)}`);
        maxWidth = dis.width;
        maxHeight = dis.height;
        Log.showInfo(TAG, `initNavBarConfiguration maxWidth ${maxWidth} maxHeight ${maxHeight} minHeight ${minHeight}`);
      })
    .catch((err) => {
      Log.showError(TAG, 'getDefaultDisplay err: ' + err);
    });
  }

  async getDirectionAndPosition() {
    directionNav = await ResourceUtil.getConfiguration();
    if (directionNav.direction == -1) {
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_landscape"))
      navbarPosition = await ResourceUtil.getString($r("app.string.nav_bar_position_landscape"))

      statusShortSideLength = await ResourceUtil.getString($r("app.string.status_bar_size_landscape"));
      navShortSideLength = await ResourceUtil.getString($r("app.string.nav_bar_size_landscape"));
    } else if (directionNav.direction == 1) {
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_landscape"))
      navbarPosition = await ResourceUtil.getString($r("app.string.nav_bar_position_landscape"))

      statusShortSideLength = await ResourceUtil.getString($r("app.string.status_bar_size_landscape"));
      navShortSideLength = await ResourceUtil.getString($r("app.string.nav_bar_size_landscape"));
    } else {
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_portrait"))
      navbarPosition = await ResourceUtil.getString($r("app.string.nav_bar_position_portrait"))

      statusShortSideLength = await ResourceUtil.getString($r("app.string.status_bar_size_portrait"));
      navShortSideLength = await ResourceUtil.getString($r("app.string.nav_bar_size_portrait"));
    }
    statusShortSideLength = parseInt(statusShortSideLength) + '';
    navShortSideLength = parseInt(navShortSideLength) + '';
    Log.showDebug(TAG, 'statusShortSideLength = ' + statusShortSideLength + 'navShortSideLength = ' + navShortSideLength + 'directionnav = ' + directionNav.direction + 'statusbarPosition = ' + statusbarPosition + 'NavbarPosition = ' + navbarPosition);
  }

/**
   * Get nav bar configuration
   */
  public async getConfiguration() {
    await this.initNavBarConfiguration();

    await this.getDirectionAndPosition();

    let showNavHorizontal = false;
    if (navbarPosition == Position.TOP_POSITION || navbarPosition == Position.BOTTOM_POSITION) {
      showNavHorizontal = true;
      minHeight = parseInt(navShortSideLength);
      if (statusbarPosition == Position.LEFT_POSITION || statusbarPosition == Position.RIGHT_POSITION) {
        realWidth = parseInt(maxWidth) - parseInt(statusShortSideLength);
      } else {
        realWidth = maxWidth;
      }
      realHeight = parseInt(navShortSideLength);
      if (statusbarPosition == Position.LEFT_POSITION) {
        xCoordinate = parseInt(statusShortSideLength);
      } else {
        xCoordinate = 0;
      }
      if (navbarPosition == Position.BOTTOM_POSITION) {
        yCoordinate = parseInt(maxHeight) - parseInt(navShortSideLength);
        Log.showDebug(TAG, 'BOTTOM_POSITION = ' + yCoordinate);
      }
    } else if (navbarPosition == Position.LEFT_POSITION || navbarPosition == Position.RIGHT_POSITION) {
      showNavHorizontal = false;
      minHeight = parseInt(navShortSideLength);
      if (statusbarPosition == Position.TOP_POSITION || statusbarPosition == Position.BOTTOM_POSITION) {
        realHeight = parseInt(maxHeight) - parseInt(statusShortSideLength);
      } else {
        realHeight = maxHeight;
      }
      realWidth = parseInt(navShortSideLength);
      if (statusbarPosition == Position.TOP_POSITION) {
        yCoordinate = parseInt(statusShortSideLength);
      } else {
        yCoordinate = 0;
      }
      if (navbarPosition == Position.RIGHT_POSITION) {
        xCoordinate = parseInt(maxWidth) - parseInt(navShortSideLength);
      }
    } else {
      realWidth = 0;
      realHeight = 0;
    }
    Log.showDebug(TAG, `initWindowManager xCoordinate ${xCoordinate} yCoordinate ${yCoordinate}, realWidth ${realWidth} realHeight ${realHeight}`);
    var configuration = {
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      minHeight: minHeight,
      showNavHorizontal: showNavHorizontal,
      realWidth: realWidth,
      realHeight: realHeight,
      xCoordinate: xCoordinate,
      yCoordinate: yCoordinate
    }
    return configuration;
  }
}

let navBarConfiguration = new NavBarConfiguration();

export default navBarConfiguration;
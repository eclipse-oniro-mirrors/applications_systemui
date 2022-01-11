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

import display from '@ohos.display';
import Log from '../../../../../../../common/src/main/ets/default/Log.ets';
import ResourceUtil from '../../../../../../../common/src/main/ets/default/ResourceUtil.ets';

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
    Log.showInfo(TAG, 'initNavBarConfiguration');
    minHeight = AppStorage.SetAndLink("minNavHeight", 0);

    await display.getDefaultDisplay()
      .then(dis => {
        maxWidth = dis.width;
        maxHeight = dis.height;
        Log.showInfo(TAG, `initNavBarConfiguration maxWidth ${maxWidth} maxHeight ${maxHeight} minHeight ${minHeight.get()}`);
      })
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
    statusShortSideLength = vp2px(parseInt(statusShortSideLength)) + '';
    navShortSideLength = vp2px(parseInt(navShortSideLength)) + '';
    Log.showInfo(TAG, 'statusShortSideLength = ' + statusShortSideLength);
    Log.showInfo(TAG, 'navShortSideLength = ' + navShortSideLength);
    Log.showInfo(TAG, 'directionnav = ' + directionNav.direction);
    Log.showInfo(TAG, 'statusbarPosition = ' + statusbarPosition);
    Log.showInfo(TAG, 'NavbarPosition = ' + navbarPosition);
  }

/**
   * Get nav bar configuration
   */
  public async getConfiguration() {
    await this.initNavBarConfiguration();

    await this.getDirectionAndPosition();

    if (navbarPosition == Position.TOP_POSITION || navbarPosition == Position.BOTTOM_POSITION) {
      AppStorage.Set("showNavHorizontal", true);
      minHeight.set(parseInt(navShortSideLength));
      Log.showInfo(TAG, 'TOP_POSITION = ' + 2);
      if (statusbarPosition == Position.LEFT_POSITION || statusbarPosition == Position.RIGHT_POSITION) {
        realWidth = parseInt(maxWidth) - parseInt(statusShortSideLength);
      } else {
        realWidth = maxWidth;
      }
      Log.showInfo(TAG, 'TOP_POSITION = ' + 3);
      realHeight = parseInt(navShortSideLength);
      Log.showInfo(TAG, 'TOP_POSITION = ' + 4);
      if (statusbarPosition == Position.LEFT_POSITION) {
        xCoordinate = parseInt(statusShortSideLength);
      } else {
        xCoordinate = 0;
      }
      Log.showInfo(TAG, 'TOP_POSITION = ' + 5);
      if (navbarPosition == Position.BOTTOM_POSITION) {
        yCoordinate = parseInt(maxHeight) - parseInt(navShortSideLength);
        Log.showInfo(TAG, 'BOTTOM_POSITION = ' + yCoordinate);
      }
    } else if (navbarPosition == Position.LEFT_POSITION || navbarPosition == Position.RIGHT_POSITION) {
      AppStorage.Set("showNavHorizontal", false);
      minHeight.set(parseInt(navShortSideLength));
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
    Log.showInfo(TAG, `initWindowManager xCoordinate ${xCoordinate} yCoordinate ${yCoordinate}`);
    Log.showInfo(TAG, `initWindowManager realWidth ${realWidth} realHeight ${realHeight}`);
    var configuration = {
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
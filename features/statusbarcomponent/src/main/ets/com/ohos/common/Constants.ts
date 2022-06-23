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

import {Event} from "../../../../../../../../common/src/main/ets/default/event/EventUtil";
import {ItemComponentData, ActionData}
from "../../../../../../../../common/src/main/ets/plugindatasource/common/Constants";

export default class Constants {
  static EMPTY_AREA_POSITION_LEFT = 'left';
  static EMPTY_AREA_POSITION_CENTER = 'center';
  static EMPTY_AREA_POSITION_RIGHT = 'right';
  static GROUP_ID_LEFT = 1;
  static GROUP_ID_CENTER = 2;
  static GROUP_ID_RIGHT = 3;
  static VERTICAL_COMPONENT_HEIGHT_VP = 58;
  static readonly PLUGIN_COMPONENT_ICON_WIDTH = 32;
  static readonly PLUGIN_COMPONENT_OWNER_WANT_KEY = 'StatusBar_PluginComponentOwnerWant';
}

export type StatusBarComponentData = ItemComponentData & {
  isShowLabel: boolean;
  isShowIcon: boolean;
  canSelect: boolean;
  relationWindowId: string;
  actionData?: ActionData & {
    selectedClickAction?: Event;
  };
};

export class StatusBarData {
  displayWidth: number;
  displayHeight: number;
  showHorizontal: boolean;
  ableToMaximize: boolean;
  realWidth: number;
  realHeight: number;
  left: number;
  top: number;
}

export class StatusBarBackgroundData {
  backgroundColor: string = "#FFFF0000";
  width: number = 0;
}

export class StatusBarComponentGroupContentData {
  contentColor: string = "#FFFFFFFF";
  width: number = 0;
}

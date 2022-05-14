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

import {ItemComponentData} from "../../../../../../../../common/src/main/ets/plugindatasource/common/Constants";

export default class Constants {
  static TOUCHTYPE_DOWN = 0;
  static TOUCHTYPE_UP = 1;
  static TOUCHTYPE_MOVE = 2;
  static TOGGLE_TYPE_COMPLEX = "complex";
  static TOGGLE_TYPE_SIMPLE = "simple";
  static COMPLEX_TOGGLE_GRID_ROW_HEIGHT = vp2px(132);
  static COMPLEX_TOGGLE_GRID_ROW_GAP = vp2px(24);
  static SIMPLE_TOGGLE_GRID_ROW_HEIGHT = vp2px(162);
  static SIMPLE_TOGGLE_GRID_ROW_GAP = vp2px(0);
  static DEFAULT_SIMPLE_TOGGLE_COLUMN_COUNT = 4;
  static SIMPLE_TOGGLE_LAYOUT_MAX_TOGGLE_COUNT = 12;
  static SIMPLE_TOGGLE_LAYOUT_MIN_TOGGLE_COUNT = 1;
}

export type ControlComponentData = ItemComponentData & {
  toggleType: string;
}
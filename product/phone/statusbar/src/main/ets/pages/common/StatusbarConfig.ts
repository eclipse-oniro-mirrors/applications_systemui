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
import {FASlotName} from '../../../../../../../../common/src/main/ets/default/constants';

type LayoutGroup = {
  id: number;
  Components: Array<string>;
};
type pluginIconData = {
  id: string;
  bundleName: string;
  abilityName: string;
};
type DropdownRange = {
  startPosition: number;
  endPosition: number;
};
type Config = {
  LayoutGroups: Array<LayoutGroup>;
  LocalSlots: Array<string>;
  MetaSlots: Array<pluginIconData>;
  emptyPosition: {
    x1: number;
    x2: number;
    y1: number;
    y2: number
  };
  dropdownRanges: {
    notification: DropdownRange;
    control: DropdownRange
  }
};

const StatusbarConfig: Config = {
  LayoutGroups: [
    {
      id: 1,
      Components: [
        FASlotName.SIGNAL,
        FASlotName.WIFI,
        FASlotName.CAPSULE,
        FASlotName.NOTIFICATION,
      ],
    },
    {
      id: 2,
      Components: [],
    },
    {
      id: 3,
      Components: [
        "testid",
        FASlotName.LOCATION,
        FASlotName.BLUETOOTH,
        FASlotName.RING_MODE,
        FASlotName.BATTERY,
        FASlotName.CLOCK,
      ],
    },
  ],
  LocalSlots: [
    FASlotName.BATTERY,
    FASlotName.BLUETOOTH,
    FASlotName.CAPSULE,
    FASlotName.CLOCK,
    FASlotName.LOCATION,
    FASlotName.NOTIFICATION,
    FASlotName.RING_MODE,
    FASlotName.SIGNAL,
    FASlotName.WIFI,
  ],
  MetaSlots: [
    {
      id: "testid",
      bundleName: "com.example.test_app_id",
      abilityName: "com.example.test_app_id.MainAbility",
    },
  ],
  emptyPosition: {
    x1: 0,
    y1: 0,
    x2: 0,
    y2: 0,
  },
  dropdownRanges: {
    notification: {
      startPosition: 0,
      endPosition: 0.5
    },
    control: {
      startPosition: 0.5,
      endPosition: 1
    },
  }
};

export default StatusbarConfig;
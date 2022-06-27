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

export default class Constants {
  static readonly NETWORK_TYPE_UNKNOWN = 0;
  static readonly NETWORK_TYPE_GSM = 1;
  static readonly NETWORK_TYPE_CDMA = 2;
  static readonly NETWORK_TYPE_W_CDMA = 3;
  static readonly NETWORK_TYPE_TDS_CDMA = 4;
  static readonly NETWORK_TYPE_LTE = 5;
  static readonly NETWORK_TYPE_NR = 6;

  static readonly CELLULAR_SIGNAL_NO = 0;
  static readonly CELLULAR_SIGNAL_MIN = 1;
  static readonly CELLULAR_SIGNAL_LOW = 2;
  static readonly CELLULAR_SIGNAL_HALF = 3;
  static readonly CELLULAR_SIGNAL_HIGH = 4;
  static readonly CELLULAR_SIGNAL_FULL = 5;
  static readonly CELLULAR_NO_SIM_CARD = -1;

  static readonly NET_NULL = 'NULL';
}

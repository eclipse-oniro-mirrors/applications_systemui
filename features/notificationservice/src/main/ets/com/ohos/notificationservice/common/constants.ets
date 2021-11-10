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
export default class Constants {
  static GET_NEW_NOTIFICATION: number = 0;
  static GET_EXIST_NOTIFICATION: number = 1;
}

export interface NotificationItemData{
  id:string;
  hashcode:string;
  contentType:string;
  timestamp:string;
  time:string;
  name:string;
  want:any;
  actionButtons:any[];
  bundleName:string;
  smallIcon?:Resource|string;
  largeIcon?:Resource|string;
  title?:string;
  text?:string;
  additionalText?:string;
  briefText?:string;
  expandedTitle?:string;
  longText?:string;
  lines?:any[];
  longTitle?:string;
}
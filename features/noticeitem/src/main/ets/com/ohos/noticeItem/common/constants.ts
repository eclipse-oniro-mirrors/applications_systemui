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
  static NOTIFICATION_TYPE_BASIC: string = '0';
  static NOTIFICATION_TYPE_LONG: string = '1';
  static NOTIFICATION_TYPE_PICTURE: string = '2';
  static NOTIFICATION_TYPE_MULTILINE: string = '4';
  static NOTIFICATION_TYPE_SOCIAL: string = '3';
  static NOTIFICATION_TYPE_MEDIA: string = '5';
  static NOTIFICATION_TYPE_NONE: number = 0;
  static NOTIFICATION_TYPE_OPEN: number = 1;
  static NOTIFICATION_TYPE_CLOSE: number = 2;
  static TEXT_MAX_LENGTH: number = 21;
  static TEXT_EXPANDED_MAX_LENGTH: number = 13;
  static TOUCH_TYPE_DOWN: number = 0;
  static TOUCH_TYPE_UP: number = 1;
  static TOUCH_TYPE_MOVE: number = 2;
  static HIDDEN_TRANSLATE_X: number = 150;
  static DISPLAY_TRANSLATE_X: number = -150;
  static REMOVE_TRANSLATE_X: number = 150;
  static DEFAULT_MAX_LINES: number= 1;
  static SINGLE_LINE: number= 1;
  static EXPENDED_MAX_LINES: number= 8;
  static CONTENT_LINE_HEIGHT: number = 20;
  static SETTING_CONT_HEIGHT = '40vp';
  static SETTING_DIALOG_WITH = '330vp';
  static SETTING_CONTENT_WITH = '100%'
  static SETTING_DIALOG_HEIGHT = '192vp';
  static SETTING_DIALOG_WIDTH = '362vp';
  static CONFIRM_DIALOG_HEIGHT = '146vp';
  static CONFIRM_DIALOG_WITH = '280';
  static CONFIRM_BUTTON_WITH = '140';
  static QUICKLY_SETTING_H = 83;
  static ERROR_CALLBACK: number = 0;
  static SUCCESS_CALLBACK: number = 1;
  static KEY_INPUT: string = 'inputAction';
  static FULL_CONTAINER_WIDTH = '100%'
}

export class NotificationLayout {
  static ACTION_HEIGHT = 48;
  static ACTION_MARGIN = 12;
  static INPUT_IMAGE_SIZE = 24;
  static INPUT_TEXT_HEIGHT = 40;
  static INPUT_LAYOUT_HEIGHT = 82;
  static NOTIFICATION_PIC_SIZE = 40;
  static ICON_SIZE = 24;
  static TEXT_LINE_HEIGHT = 20;
  static BUTTON_SIZE = 40;
  static ICON_MARGIN = 12;
  static SCROLL_THRESHOLD = 10;
  static TITLE_IMAGE_SIZE = 16;
  static TITLE_HEIGHT = 40;
  static ITEM_MARGIN = 12;
  static EXPAND_PADDING_BOTTOM = 20;
}

export class InputActionButtonData {
  isSending: boolean = false;
  content: string = '';
}

interface RuleData {
  isAllowBanner?: boolean;
  isAllowSound?: boolean;
  isAllowVibrationValues?: boolean;
  isAllowStatusBarShow?: boolean;
  isAllowNotificationListShow?: boolean;
}

export interface NotificationItemData {
  id: string;
  hashcode: string;
  userId: number;
  uid: number;
  contentType: string;
  timestamp: number;
  time: string;
  appName: string;
  want: any;
  actionButtons: any[];
  bundleName: string;
  smallIcon?: PixelMap | string;
  largeIcon?: PixelMap | string;
  picture?: PixelMap;
  title?: string;
  text?: string;
  additionalText?: string;
  briefText?: string;
  expandedTitle?: string;
  longText?: string;
  lines?: any[];
  longTitle?: string;
  slotLevel?: any;
  source?: number;
  versionName?: string;
  sound?: string;
  vibrationValues?: Array<number>;
  notificationFlags?: any;
  ruleData?: RuleData;
  template?: any;
  isOngoing?: boolean;
  isUnremovable?: boolean;
  isRemoveAllowed?: boolean;
  distributedOption?: any;
  deviceId?: string;
  groupName?: string;
  tapDismissed?: boolean;
}

export interface NotificationServiceListener {
  onNotificationConsume?: (data: NotificationItemData) => void;
  onNotificationLoad?: (data: NotificationItemData) => void;
  onNotificationCancel?: (data: NotificationItemData) => void;
}

export enum ScreenLockStatus {
  Locking = 1,
  Unlock = 2
}

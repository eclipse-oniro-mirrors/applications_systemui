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
import Log from "./Log";

const TAG = "Base-StyleManager";

export default class BaseStyleManager {
  // standard display width
  static readonly STANDARD_DISPLAY_WIDTH_LARGE: number = 2560;
  static readonly STANDARD_DISPLAY_WIDTH_NORMAL: number = 1280;
  static readonly STANDARD_DISPLAY_WIDTH_SMALL: number = 720;

  mAbilityPageName = "";
  maxWidth: number = BaseStyleManager.STANDARD_DISPLAY_WIDTH_NORMAL;
  standardWidth: number = BaseStyleManager.STANDARD_DISPLAY_WIDTH_NORMAL;

  constructor(name: string) {
    Log.showInfo(TAG, `constructor, name: ${name}`);
    this.mAbilityPageName = name;
  }

  setAbilityPageName(name: string): void {
    Log.showInfo(TAG, `setAbilityPageName, name: ${name}`);
    this.mAbilityPageName = name;
  }

  setMaxWidth(width: number): void {
    Log.showInfo(TAG, `setMaxWidth, width: ${width}`);
    this.maxWidth = width;
  }

  setStandardWidth(width: number): void {
    Log.showInfo(TAG, `setStandardWidth, width: ${width}`);
    this.standardWidth = width;
  }

  getStyle<T>(key: string, defaultStyle: { new(): T }): T {
    let newKey = this.mAbilityPageName + "-" + key;
    if (!AppStorage.Has(newKey)) {
      AppStorage.SetOrCreate(newKey, new defaultStyle());
      Log.showInfo(TAG, `Create storageKey of ${newKey}`);
    }
    return AppStorage.Get(newKey) as T;
  }

  number2px(n: number): string {
    return n.toString() + "px";
  }

  calcScaleSize(n: number): number {
    return n * this.maxWidth / this.standardWidth;
  }

  calcScaleSizePx(n: number): string {
    return this.number2px(this.calcScaleSize(n));
  }
}
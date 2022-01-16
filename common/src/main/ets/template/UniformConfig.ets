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

export default class UniformConfig {

  static config = {
    iconOnBG: "#0A59F7",
    iconOffBG:  "#F5F5F5",
    iconOnColor: "#FFFFFF",
    iconOffColor: "#404345",
    baseColor: "#CCFFFFFF",
    circleWidth: '80px',
    circleHeight: '80px',
    iconWidth: '50px',
    iconHeight: '50px',
    titleSize: '20px',
    baseBorderRadius: 15,
    simpleToggleTitleSize: '18px'
  }

  static initParams(params?) {
    console.log('----initParams(params)----ing');
    UniformConfig.config = params || {
                              iconOnBG: "#0A59F7",
                              iconOffBG: "#F5F5F5",
                              iconOnColor: "#FFFFFF",
                              iconOffColor: "#404345",
                              baseColor: "#CCFFFFFF",
                              circleWidth: '80px',
                              circleHeight: '80px',
                              iconWidth: '50px',
                              iconHeight: '50px',
                              titleSize: '20px',
                              baseBorderRadius: 15,
                              simpleToggleTitleSize: '18px'
                            }
    console.log('----initParams(params)----finish');
  }
}

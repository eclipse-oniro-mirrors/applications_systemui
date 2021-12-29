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

import {UpTitle} from './UpTitle.ets'
import AirPlaneComponent from "../../../../../../../airplanecomponent/src/main/ets/default/pages/airplaneComponent.ets"
import WifiComponent from '../../../../../../../wificomponent/src/main/ets/default/pages/wifiComponent.ets'
import {MyBrightness} from '../../../../../../../brightnesscomponent/src/main/ets/default/pages/brightnessComponent.ets'
import {MyVol} from '../../../../../../../volumecomponent/src/main/ets/default/pages/volumeComponent.ets'
import Log from '../../../../../../../../common/src/main/ets/default/Log.ets'
import UniformConfig from '../../../../../../../../common/src/main/ets/template/UniformConfig.ets'
import Constants from '../common/Constants.ets'
import ViewModel from '../viewmodel/ControlCenterVM.ets'
import ComplexToggleComponent from './ComplexToggleComponent.ets'
import SimpleToggleComponent from './SimpleToggleComponent.ets'

const TAG = 'Control-ControlCenter'
const TAG_ControlCenterComplexToggleLayout = 'Control-ControlCenterComplexToggleLayout'
const TAG_ControlCenterSimpleToggleLayout = 'Control-TAG_ControlCenterSimpleToggleLayout'

var mUniform;

@Component
export default struct ControlCenterComponent {
  @State mControlCenterComponentConfig: any = {}
  @Link showStatusBar: boolean
  componentUniform = {
    iconOnBG: "#0A59F7",
    iconOffBG: "#F5F5F5",
    baseColor: "#CCFFFFFF",
    circleWidth: 80,
    circleHeight: 80,
    iconWidth: 50,
    iconHeight: 50,
    titleSize: 20,
    iconTitleMargin: 10,
    baseBorderRadius: 15,
  }

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear')
    // 初始化自定义组件样式
    mUniform = UniformConfig.initParams(this.componentUniform)

    console.log(`------${JSON.stringify(mUniform)}`);

    Log.showInfo(TAG, `aboutToAppear, mControlCenterComponentConfig: ${JSON.stringify(this.mControlCenterComponentConfig)}`)
    ViewModel.initViewModel(this.mControlCenterComponentConfig)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear ')
  }

  build() {
    Column() {
      Column() {
        UpTitle({ showStatusBar: $showStatusBar })
      }
      .width('100%')
      .height($r('app.float.up_title_height'))
      .margin({ top: $r('app.float.center_item_margin_top'),
        left: $r('app.float.center_item_margin_left'),
        right: $r('app.float.center_item_margin_right') })

      ControlCenterComplexToggleLayout({ showStatusBar: $showStatusBar })
      ControlCenterSimpleToggleLayout({ showStatusBar: $showStatusBar })
      Column() {
        MyBrightness()
      }
      .width('100%')
      .height($r('app.float.vol_height'))
      .margin({ top: $r('app.float.center_item_margin_top'),
        left: $r('app.float.center_item_margin_left'),
        right: $r('app.float.center_item_margin_right') })

      Flex() {
        MyVol()
      }
      .width('100%')
      .height($r('app.float.vol_height'))
      .margin({ top: $r('app.float.center_item_margin_top'),
        left: $r('app.float.center_item_margin_left'),
        right: $r('app.float.center_item_margin_right') })
    }
    .width('100%')
  }
}

@Component
struct ControlCenterComplexToggleLayout {
  @StorageLink('ControlCenterComplexToggleLayout') mComplexToggleLayout: string[] = []
  @Link showStatusBar: boolean

  aboutToAppear() {
    Log.showInfo(TAG_ControlCenterComplexToggleLayout, `aboutToAppear Start`)
    Log.showInfo(TAG_ControlCenterComplexToggleLayout, `aboutToAppear, mComplexToggleLayout: ${this.mComplexToggleLayout} `)
  }

  aboutToDisappear() {
    Log.showInfo(TAG_ControlCenterComplexToggleLayout, `aboutToDisAppear`)
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      wrap: FlexWrap.Wrap,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Start,
      alignContent: FlexAlign.Start
    }) {
      ForEach(this.mComplexToggleLayout, (componentName: string) => {
        Row() {
          if (componentName == Constants.WIFI) {
            WifiComponent()
          } else if (componentName == Constants.AIR_PLANE) {
            AirPlaneComponent()
          } else {
            ComplexToggleComponent({
              keyId: componentName,
              showStatusBar: $showStatusBar
            })
          }
        }
        .width('48%')
        .height(Constants.COMPLEX_TOGGLE_HEIGHT)
        .margin({ top: Constants.COMPLEX_TOGGLE_UP_DOWN_SPACE })
      }, (componentName: string) => componentName)
    }
    .width('100%')
    .height((Math.ceil(this.mComplexToggleLayout.length / 2) * (Constants.COMPLEX_TOGGLE_HEIGHT + Constants.COMPLEX_TOGGLE_UP_DOWN_SPACE)).toString())
    .margin({
      left: $r('app.float.center_item_margin_left'),
      right: $r('app.float.center_item_margin_right')
    })
  }
}

@Component
struct ControlCenterSimpleToggleLayout {
  @StorageLink('ControlCenterSimpleToggleLayout') mSimpleToggleLayout: string[] = []
  @Link showStatusBar: boolean

  aboutToAppear() {
    Log.showInfo(TAG_ControlCenterSimpleToggleLayout, `aboutToAppear Start`)
    Log.showInfo(TAG_ControlCenterSimpleToggleLayout, `aboutToAppear, mSimpleToggleLayout: ${this.mSimpleToggleLayout} `)
  }

  aboutToDisappear() {
    Log.showInfo(TAG_ControlCenterSimpleToggleLayout, `aboutToDisAppear`)
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      wrap: FlexWrap.Wrap,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
      alignContent: FlexAlign.Start
    }) {
      ForEach(this.mSimpleToggleLayout, (componentName: string) => {
        Column() {
          SimpleToggleComponent({
            keyId: componentName,
            showStatusBar: $showStatusBar
          })
        }
        .width('25%')
        .height(Constants.SIMPLE_TOGGLE_HEIGHT)
        .margin({ top: Constants.SIMPLE_TOGGLE_UP_DOWN_SPACE })
      }, (componentName: string) => componentName)
    }
    .width('100%')
    .height((Math.ceil(this.mSimpleToggleLayout.length / 4) * (Constants.SIMPLE_TOGGLE_HEIGHT + Constants.SIMPLE_TOGGLE_UP_DOWN_SPACE)).toString())
    .margin({
      left: $r('app.float.center_item_margin_left'),
      right: $r('app.float.center_item_margin_right')
    })
  }
}
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

import Log from '../../../../../../../../common/src/main/ets/default/Log'
import AbilityManager from '../../../../../../../../common/src/main/ets/default/abilitymanager/abilityManager'
import StyleConfiguration from '../common/StyleConfiguration'
import Constants from '../common/Constants'
import ViewModel from '../viewmodel/VolumePanelVM'
import VolumeWindowController from '../common/VolumeWindowController'

const TAG = 'VolumePanel-VolumePanelComponent'

@Component
export default struct VolumePanelComponent {
  @StorageLink('VolumePanelMaxVolume') VolumePanelMaxVolume: number = Constants.DEFAULT_MAX_VOLUME
  @StorageLink('VolumePanelMinVolume') VolumePanelMinVolume: number = Constants.DEFAULT_MIN_VOLUME
  @StorageLink('VolumePanelVolumeValue') VolumePanelVolumeValue: number = Constants.DEFAULT_MIN_VOLUME
  @StorageLink('VolumePanelIsMute') VolumePanelIsMute: boolean = Constants.DEFAULT_MUTE_STATUS
  @State style: any = StyleConfiguration.getVolumePanelComponentStyle()

  aboutToAppear() {
    Log.showInfo(TAG, 'aboutToAppear')
    ViewModel.initViewModel()
  }

  aboutToDisappear() {
    Log.showInfo(TAG, 'aboutToDisappear')
  }

  build() {
    Column() {
      Column().width('100%').height(this.style.volumePanelSliderMarginTop)
      Column() {
        Slider({
          value: this.VolumePanelVolumeValue,
          min: this.VolumePanelMinVolume,
          max: this.VolumePanelMaxVolume,
          step: 1,
          style: SliderStyle.OutSet,
          direction: Axis.Vertical,
          reverse: true
        })
          .trackThickness(this.style.volumePanSliderWidth)
          .blockColor(this.style.volumePanelSliderBlockColor)
          .trackColor($r('sys.color.ohos_id_color_component_normal'))
          .selectedColor(this.style.volumeSelectedColor)
          .onChange(this.onVolumeChange.bind(this))
      }
      .flexGrow(1)
      .flexShrink(1)

      Column()
        .width('100%')
        .height(this.style.volumePanelSliderMarginBottom)
      Column() {
        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Column() {
            Image(this.getVolumeIcon(this.VolumePanelIsMute, this.VolumePanelVolumeValue, this.VolumePanelMaxVolume, this.VolumePanelMinVolume))
              .width(this.style.volumePanelMutBtnIconSize)
              .height(this.style.volumePanelMutBtnIconSize)
              .fillColor($r('sys.color.ohos_id_color_activated'))
            Column()
              .width('100%')
              .height(this.style.volumePanelMutBtnIconMarginBottom)
          }
        }
        .width('100%')
        .height('100%')
        .backgroundColor(this.style.volumeButtonBackgroundColor)
        .onClick(this.onMuteBtnClick.bind(this))
      }
      .width('100%')
      .height(this.style.volumePanelMuteBtnHeight)

      Column() {
        Divider()
          .vertical(false)
          .strokeWidth(this.style.volumePanelDividerHeight)
          .color($r('sys.color.ohos_id_color_fourth'))
          .lineCap(LineCapStyle.Square)
      }
      .width(this.style.volumeDividerWidth)
      .height(this.style.volumePanelDividerHeight)

      Column() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Column() {
            Column()
              .width('100%')
              .height(this.style.volumePanelMutBtnIconMarginBottom)
            Image($r('app.media.ic_public_settings'))
              .width(this.style.volumePanelSettingIconSize)
              .height(this.style.volumePanelSettingIconSize)
              .fillColor(this.style.volumePanelSettingColor)
            Column()
              .width('100%')
              .height(this.style.volumePanelMutBtnIconMarginBottom)
          }
        }
        .width('100%')
        .height('100%')
        .backgroundColor(this.style.volumeButtonBackgroundColor)
        .onClick(this.onSettingsBtnClick.bind(this))
      }
      .width('100%')
      .height(this.style.volumePanelSettingButtonSize)
    }
    .width('100%')
    .height('100%')
    .borderRadius(this.style.volumePanelBorderRadius)
    .backgroundColor(this.style.volumePanelBackground)
  }

  getVolumeIcon(isMute, volume, maxVolume, minVolume) {
    Log.showInfo(TAG, `getVolumeIcon, isMute: ${isMute} volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`)
    let icon
    if (isMute) {
      icon = $r('app.media.ic_public_mute')
    } else {
      if (volume >= (((maxVolume - minVolume) / 3) * 2 + minVolume)) {
        icon = $r('app.media.ic_public_sound_03')
      } else if (volume >= ((maxVolume - minVolume) / 3 + minVolume)) {
        icon = $r('app.media.ic_public_sound_02')
      } else if (volume == minVolume) {
        icon = $r('app.media.ic_public_sound_04')
      } else {
        icon = $r('app.media.ic_public_sound_01')
      }
    }
    return icon
  }

  onVolumeChange(value: number, mode: SliderChangeMode) {
    Log.showInfo(TAG, `onVolumeChange, value: ${value} mode: ${mode}`)
    ViewModel.setVolume(value)
  }

  onMuteBtnClick(event: ClickEvent) {
    Log.showInfo(TAG, `onMuteBtnClick`)
    ViewModel.mute()
  }

  onSettingsBtnClick(event: ClickEvent) {
    Log.showInfo(TAG, `onSettingsBtnClick`)
    AbilityManager.startAbility({
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility',
    });
    VolumeWindowController.getInstance().setWindowState(false);
  }
}
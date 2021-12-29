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

import Log from '../../../../../../../common/src/main/ets/default/Log.ets';
import HeadComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headComponent.ets';
import ConfigData from '../common/constants.ets';
import Router from '@system.router'
import DateAndTime from '../../../../../../../common/src/main/ets/default/DateAndTimeUtil.ets';
import ItemComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/itemComponent.ets';
import ViewModel from '../vm/noDisturbViewModel.ets'

const TAG = 'NotificationManagement-NoDisturb';

@Entry
@Component
export default struct NoDisturb {
  @State mViewModel: ViewModel = new ViewModel()
  startTimeDialogController: CustomDialogController = new CustomDialogController({
    builder: TimeDialog({
      action: this.mViewModel.onStartTimeAccept.bind(this.mViewModel),
      title: $r('app.string.startTime'),
      defaultDate: this.mViewModel.defaultStartTime
    }),
    cancel: this.mViewModel.onCancel.bind(this.mViewModel),
    autoCancel: false,
    offset: { dx: 0, dy: 200 }
  });
  endTimeDialogController: CustomDialogController = new CustomDialogController({
    builder: TimeDialog({
      action: this.mViewModel.onEndTimeAccept.bind(this.mViewModel),
      title: $r('app.string.endTime'),
      defaultDate: this.mViewModel.defaultEndTime
    }),
    cancel: this.mViewModel.onCancel.bind(this.mViewModel),
    autoCancel: false,
    offset: { dx: 0, dy: 200 }
  });
  repeatDialogController: CustomDialogController = new CustomDialogController({
    builder: RepeatModeDialog({
      action: this.mViewModel.onRepeatModeAccect.bind(this.mViewModel),
      title: $r('app.string.repeat'),
      selectMode: this.mViewModel.repeatMode
    }),
    cancel: this.mViewModel.onCancel.bind(this.mViewModel),
    autoCancel: false,
    offset: { dx: 0, dy: 200 }
  });

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
      HeadComponent({ headName: $r('app.string.noDisturb'), isActive: true })

      Row() {
        ItemComponent({
          title: $r('app.string.repeat'),
          value: $r('app.string.daily'),
          arrow: $r('app.media.ic_settings_arrow')
        })
      }.onClick(() => {
        this.repeatDialogController.open()
      }).margin({ left: $r('app.float.page_margin_l'), right: $r('app.float.page_margin_r') })


      Row() {
        ItemComponent({
          title: $r('app.string.startTime'),
          value: this.mViewModel.startTime,
          arrow: $r('app.media.ic_settings_arrow')
        })
      }.onClick(() => {
        this.startTimeDialogController.open()
      }).margin({ left: $r('app.float.page_margin_l'), right: $r('app.float.page_margin_r') })

      Row() {
        ItemComponent({
          title: $r('app.string.endTime'),
          value: this.mViewModel.endTimeClue,
          arrow: $r('app.media.ic_settings_arrow')
        })
      }.onClick(() => {
        this.endTimeDialogController.open()
      }).margin({ left: $r('app.float.page_margin_l'), right: $r('app.float.page_margin_r') })
    }.backgroundColor($r('app.color.background_color'))
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.ViewModelInit()

  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
    Router.back();
  }
}

/**
 * select time dialog
 */
@CustomDialog
struct TimeDialog {
  public controller: CustomDialogController
  public action: (data) => void
  private selectedTime: string
  private title: string= ''
  private defaultDate: Date= new Date()

  build() {
    Column() {
      Column() {
        Text(this.title)
          .height($r('app.float.dialog_title_height'))
          .margin({ left: $r('app.float.dialog_title_margin_l') })
          .width(ConfigData.WH_100_100)
          .fontSize($r('app.float.dialog_title_font'))
          .fontWeight(FontWeight.Bold)
        DatePicker({ selected: this.defaultDate, type: DatePickerType.Time })
          .useMilitaryTime(true)
          .onChange((date: DatePickerResult) => {
            this.selectedTime = DateAndTime.concatTime(date.hour, date.minute);
          })
          .width(ConfigData.WH_100_100)
          .height($r('app.float.timeDialog_datePicker_height'))
      }

      Row() {
        Column() {
          Text($r('app.string.cancel'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor(Color.Blue)

        }.onClick(() => {
          this.controller.close();
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100);
        Divider()
          .vertical(true)
          .color($r('app.color.divider_color'))
          .strokeWidth(1)
          .height($r('app.float.divider_height'))
        Column() {
          Text($r('app.string.confirm'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor(Color.Blue)

        }.onClick(() => {
          Log.showInfo(TAG, `confirm button of TimeDialog on click`)
          this.controller.close();
          this.action(this.selectedTime);
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100)
      }
      .width(ConfigData.WH_100_100)
      .height($r('app.float.dialog_button_height'))
    }
    .height($r('app.float.timeDialog_height'))
    .width(ConfigData.WH_100_100)
  }
}

/**
 * select repeat Mode dialog
 */
@CustomDialog
struct RepeatModeDialog {
  public controller: CustomDialogController
  public action: (data) => void
  private title: string= ''
  private selectMode: number= 2  //TODO
  @State isNo: boolean = true

  build() {
    Column({ space: 30 }) {
      Column() {
        Text(this.title)
          .height($r('app.float.dialog_title_height'))
          .margin({ left: $r('app.float.dialog_title_margin_l') })
          .width(ConfigData.WH_100_100)
          .fontSize($r('app.float.dialog_title_font'))
          .fontWeight(FontWeight.Bold)
        Row() {
          Text($r('app.string.daily'))
            .fontSize($r('app.float.repeatDialog_cont_font'))
            .fontColor(Color.Black)
            .width(ConfigData.WH_70_100)
            .textAlign(TextAlign.Start)
            .align(Alignment.Start)
          Toggle({ type: ToggleType.Checkbox, isOn: this.isNo })
            .align(Alignment.End)
            .width($r('app.float.toggle_check_width'))
            .height($r('app.float.toggle_check_width'))
            .onChange((data) => {
              //TODO
              this.selectMode = 2
              this.isNo = true
            })
        }
      }

      Row() {
        Column() {
          Text($r('app.string.cancel'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor(Color.Blue)

        }.onClick(() => {
          this.controller.close();
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100);
        Divider()
          .vertical(true)
          .color($r('app.color.divider_color'))
          .strokeWidth(1)
          .height($r('app.float.divider_height'))
        Column() {
          Text($r('app.string.confirm'))
            .fontSize($r('app.float.dialog_button_font'))
            .fontColor(Color.Blue)

        }.onClick(() => {
          Log.showInfo(TAG, `confirm button of TimeDialog on click`)
          this.controller.close();
          this.action(this.selectMode);
        })
        .alignItems(HorizontalAlign.Center)
        .width(ConfigData.WH_50_100)
      }
      .width(ConfigData.WH_100_100)
      .height($r('app.float.dialog_button_height'))
    }
    .height($r('app.float.repeatDialog_height'))
    .width(ConfigData.WH_100_100)
  }
}

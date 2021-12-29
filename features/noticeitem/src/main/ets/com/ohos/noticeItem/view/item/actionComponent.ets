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

import Log from '../../../../../../../../../../common/src/main/ets/default/Log.ets';
import CheckEmptyUtils from '../../../../../../../../../../common/src/main/ets/default/CheckEmptyUtils.ets';
import ViewModel from '../../viewmodel/ViewModel.ets';
import Constants, {InputActionButtonData} from '../../common/constants.ets';

const TAG = 'NoticeItem-ActionComponent';

@Component
export default struct ActionComponent {
  @State showInputText: boolean = false;
  @State placeholder: string = '';
  @State inputData: any = undefined;
  @State inputActionData: InputActionButtonData = new InputActionButtonData();
  private itemData: any = undefined;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
    let actionData = AppStorage.Get(Constants.KEY_INPUT + this.itemData.id);
    this.inputActionData = (actionData instanceof InputActionButtonData) ? actionData : this.inputActionData;
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`);
  }

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
      if (CheckEmptyUtils.isEmpty(this.inputData) && !this.inputActionData.isSending) {
        ForEach(this.itemData.actionButtons, (item: any) => {
          ActionButton({
            content: item.title,
            clickEvent: () => {
              if (CheckEmptyUtils.isEmpty(item.userInput)) {
                ViewModel.clickItem(this.itemData, item.wantAgent);
              } else {
                this.inputData = { inputKey: item.userInput.inputKey, wantAgent: item.wantAgent };
              }
            }
          })
        })
      } else {
        TextInput({ placeholder: this.placeholder, text: this.inputActionData.content })
          .type(InputType.Normal)
          .borderRadius(12)
          .caretColor(Color.Green)
          .backgroundColor(Color.White)
          .enterKeyType(EnterKeyType.Send)
          .height($r("app.float.action_button_height"))
          .enabled(this.inputActionData.isSending ? false : true)
          .width('80%')
          .margin({ right: $r("app.float.action_button_padding") })
        ActionButton({
          content: this.inputActionData.isSending ? $r('app.string.Sending') : $r('app.string.enter'),
          clickable: !this.inputActionData.isSending,
          clickEvent: () => {
            ViewModel.clickReply(this.inputData?.inputKey, this.placeholder, this.inputData?.wantAgent);
            this.inputActionData = {
              isSending: true,
              content: this.placeholder
            };
            AppStorage.SetOrCreate(Constants.KEY_INPUT + this.itemData.id, this.inputActionData);
          }
        })
      }
    }.margin({ top: 10 })
  }
}

@Component
struct ActionButton {
  @State backgroundColor: Resource = $r("app.color.transparent");
  @Prop content: string;
  clickable: boolean = true;
  clickEvent: Function = () => {
  };

  aboutToAppear() {
    Log.showInfo(TAG, `ActionButton ${this.content} aboutToAppear Start`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `ActionButton ${this.content} aboutToDisAppear`);
  }

  build() {
    Text(this.content)
      .fontSize(20)
      .height($r("app.float.action_button_height"))
      .borderRadius(4)
      .fontColor($r("app.color.action_button_color"))
      .padding({ left: $r("app.float.action_button_padding"), right: $r("app.float.action_button_padding") })
      .backgroundColor(this.backgroundColor)
      .onTouch((event: TouchEvent) => {
        if (!this.clickable) {
          return;
        }
        if (event.type == TouchType.Down) {
          this.backgroundColor = $r("app.color.action_button_click_color");
        } else if (event.type == TouchType.Up) {
          this.backgroundColor = $r("app.color.transparent");
        }
      })
      .onClick(() => {
        if (!this.clickable) {
          return;
        }
        this.clickEvent();
      })
  }
}
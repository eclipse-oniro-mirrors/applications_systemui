/**
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
import ConfigData from '../../common/constants.ets';
import Log from '../../../../../../../../../common/src/main/ets/default/Log.ets';
import SlotItemComponent from './slotItemComponent.ets';
import Notification from '@ohos.notification';
import Router from '@system.router'

const TAG = 'ManagementComponent-SlotLstComponent';

@Component
export default
struct SlotLstComponent {
  private appBundleName:string ='';
  private appUid:number =0;

  @State slotLst: any[] = [];

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        Row(){
          Text($r('app.string.slotType'))
            .fontSize($r('app.float.slotComp_font'))
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)
            .width(ConfigData.WH_100_100)
            .maxLines(ConfigData.MAX_LINES_1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ left: $r('app.float.page_margin_l'), right: $r('app.float.page_margin_r') });
        }.align(Alignment.Start);
        Row(){
          List() {
            ForEach(this.slotLst, (item) => {
              ListItem() {
                SlotItemComponent({slotType: item.slotType})
              }
              .onClick(() => {
                Log.showInfo(TAG, `onClick`)
              })
              //          .height($r('app.float.wh_value_70'));
            });
          }.divider({
            strokeWidth: 1,
            color: $r('app.color.divider_color'),
            startMargin: $r('app.float.divider_margin_l'),
            endMargin: $r('app.float.divider_margin_r')
          }).width(ConfigData.WH_100_100)
          .margin({ top: $r('app.float.slotComp_margin_t') })
          .visibility(Visibility.Visible)
        }.align(Alignment.Start);
      }
    }
    .margin({ left: $r('app.float.page_margin_l') })
    .width(ConfigData.WH_100_100);
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    Log.showInfo(TAG,`aboutToAppear Notification.getSlotsByBundle  bundle:`+ 'bundle:'+ this.appBundleName + 'uid'+this.appUid)
    Notification.getSlotsByBundle({bundle:this.appBundleName,uid:this.appUid},(err,data)=>{
      if (err.code!==0){
        Log.showInfo(TAG,`aboutToAppear Notification.getSlotsByBundle  err:`+JSON.stringify(err))
        this.slotLst.push({
          slotType: 0
        });
        return
      }
      Log.showInfo(TAG,`aboutToAppear Notification.getSlotsByBundle  data:`+JSON.stringify(data))
      data.forEach((val, idx, array) => {
        Log.showInfo(TAG,`aboutToAppear Notification.getSlotsByBundle  data.forEach:`+JSON.stringify(val))
        this.slotLst.push({
          slotType: val.type
        });
       })
    })
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
    Router.back();
  }
}
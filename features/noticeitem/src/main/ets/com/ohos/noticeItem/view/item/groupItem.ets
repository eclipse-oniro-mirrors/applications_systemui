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

import Log from '../../../../../../../../../../common/src/main/ets/default/Log';
import Constants, { NotificationLayout as Layout } from '../../common/constants';
import NotificationItem from './notificationItem'
import titleItem from './titleItem';
import IconListComponent, { getIconListSize } from './iconListComponent';
import ScrollbarManager from '../../common/ScrollbarManager';

const TAG = 'NoticeItem-GroupItem';

@Component
export default struct GroupItem {
  @Consume('notificationUpdate') updateFlag: number;
  @State distributedDeviceName: string = ''
  @State @Watch('expandChange') toExpand: boolean = false;
  private groupData: any[] = []
  private mScroller: Scroller = new Scroller();
  @State mIconAlpha: number = 0;
  @State @Watch('scrollEdge') mEdgeEnd: boolean = false;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisAppear`);
  }

  expandChange() {
    this.updateFlag++;
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Scroll(this.mScroller) {
        Row() {
          Column() {
            Row() {
              titleItem({
                notificationSmallIcon: this.groupData[0].smallIcon,
                notificationName: this.groupData[0].appName,
                notificationTime: this.groupData[0].time,
                isExpand: $toExpand,
                needExpand: true,
                distributedDeviceName: this.distributedDeviceName,
                clickTitleAction: () => null
              })
            }
            .flexShrink(0)
            .backgroundColor($r('app.color.notificationitem_background'))
            .width(Constants.FULL_CONTAINER_WIDTH)

            if (this.toExpand) {
              Row().height($r("app.float.notice_divider")).width('100%').flexShrink(0)
            }
            Column() {
              ContentList({ groupData: this.groupData, toExpand: this.toExpand })
            }
            .flexShrink(1)
            .width(Constants.FULL_CONTAINER_WIDTH)
            .enabled(!this.mEdgeEnd)
          }
          .borderRadius($r("sys.float.ohos_id_corner_radius_default_l"))
          .clip(true)

          Row() {
            IconListComponent({ iconAlpha: this.mIconAlpha, itemData: this.groupData[0], isGroup: true })
          }.width(getIconListSize())
        }.alignItems(VerticalAlign.Top)
      }
      .borderRadius($r("sys.float.ohos_id_corner_radius_default_l"))
      .clip(true)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.On)
      .onScroll(() => {
        this.mIconAlpha += 0.1;
        this.mIconAlpha = this.mScroller.currentOffset().xOffset * 1.0 / getIconListSize();
      })
      .onScrollEnd(() => {
        this.mEdgeEnd = (this.mEdgeEnd &&
        this.mScroller.currentOffset().xOffset > (getIconListSize() - Layout.SCROLL_THRESHOLD))
        || (!this.mEdgeEnd && this.mScroller.currentOffset().xOffset > Layout.SCROLL_THRESHOLD)
        ScrollbarManager.restoreOtherScroll(this.mScroller);
      })
    }
    .width(Constants.FULL_CONTAINER_WIDTH)
  }

  scrollEdge() {
    this.mScroller.scrollEdge(this.mEdgeEnd ? Edge.End : Edge.Start)
  }
}

@Component
struct ContentList {
  @State @Watch('remainderChange') groupData: any[] = []
  @Prop toExpand: boolean
  @State remainderNum: number= 0

  aboutToAppear() {
    this.remainderNum = this.groupData.length - 2;
    Log.showInfo(TAG, `aboutToAppear remainderNum:${this.remainderNum}`);
  }

  build() {
    Column() {
      if (!this.toExpand) {
        Column() {
          Row({ space: 5 }) {
            Text(this.groupData[0].title)
              .maxLines(Constants.SINGLE_LINE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor($r("sys.color.ohos_fa_text_primary"))
              .fontSize($r("sys.float.ohos_id_text_size_body2"))
              .fontWeight(FontWeight.Medium)
              .lineHeight(Layout.TEXT_LINE_HEIGHT)
            Text(this.groupData[0].text)
              .maxLines(Constants.SINGLE_LINE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor($r("sys.color.ohos_fa_text_secondary"))
              .fontSize($r("sys.float.ohos_id_text_size_body2"))
              .fontWeight(FontWeight.Regular)
              .lineHeight(Layout.TEXT_LINE_HEIGHT)
            Blank()
              .margin({ left: Layout.ITEM_MARGIN, right: Layout.ITEM_MARGIN })
          }.width(Constants.FULL_CONTAINER_WIDTH)
          .margin({ left: Layout.ITEM_MARGIN, right: Layout.ITEM_MARGIN })

          Row({ space: 5 }) {
            Text(this.groupData[1].title)
              .maxLines(Constants.SINGLE_LINE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor($r("sys.color.ohos_fa_text_primary"))
              .fontSize($r("sys.float.ohos_id_text_size_body2"))
              .fontWeight(FontWeight.Medium)
              .lineHeight(Layout.TEXT_LINE_HEIGHT)
            Text(this.groupData[1].text)
              .maxLines(Constants.SINGLE_LINE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor($r("sys.color.ohos_fa_text_secondary"))
              .fontSize($r("sys.float.ohos_id_text_size_body2"))
              .fontWeight(FontWeight.Regular)
              .lineHeight(Layout.TEXT_LINE_HEIGHT)
            Blank()
            Text('+' + this.remainderNum)
              .maxLines(Constants.SINGLE_LINE)
              .textOverflow({ overflow: TextOverflow.None })
              .fontColor($r("sys.color.ohos_fa_text_secondary"))
              .fontSize($r("sys.float.ohos_id_text_size_body2"))
              .visibility((this.remainderNum > 0) ? Visibility.Visible : Visibility.Hidden)
              .margin({ left: Layout.ITEM_MARGIN, right: Layout.ITEM_MARGIN })
          }
          .width(Constants.FULL_CONTAINER_WIDTH)
          .margin({ left: Layout.ITEM_MARGIN, right: Layout.ITEM_MARGIN })

          Blank()
            .height(Layout.ITEM_MARGIN)
        }.width(Constants.FULL_CONTAINER_WIDTH)
        .backgroundColor($r('app.color.notificationitem_background'))
        .alignItems(HorizontalAlign.Start)

      } else {
        List() {
          ForEach(this.groupData, (item: any) => {
            ListItem() {
              NotificationItem({ itemData: item, isSubItem: true })
            }
          }, (item: any) => `${item.hashcode}_${item.timestamp}_subitem`)
        }
        .divider({
          strokeWidth: 1,
          color: $r('app.color.device_divider_color')
        })
        .align(Alignment.Top)
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width(Constants.FULL_CONTAINER_WIDTH)
  }

  remainderChange() {
    this.remainderNum = this.groupData.length - 2;
    Log.showInfo(TAG, `remainderChange remainderNum:${this.remainderNum}`);
  }
}

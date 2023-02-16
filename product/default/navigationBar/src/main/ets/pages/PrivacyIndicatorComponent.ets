/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

import { ViewModel } from '../viewmodel/ViewModel';
import IndicatorStyle, { IndicatorType } from '../common/IndicatorConfig';

@Entry
@Component
export default struct PrivacyIndicatorComponent {
  private mViewModel: ViewModel;
  @State mBackgroundColor: Resource = $r("app.color.transparent");

  aboutToAppear(): void {
    this.mViewModel = new ViewModel();
    this.mViewModel.setCallback((type) => {
      if (type == IndicatorType.TYPE_ORANGE) {
        this.mBackgroundColor = $r("app.color.indicator_color_orange");
      } else if (type == IndicatorType.TYPE_GREEN) {
        this.mBackgroundColor = $r("app.color.indicator_color_green");
      } else if (type == IndicatorType.TYPE_BLUE) {
        this.mBackgroundColor = $r("app.color.indicator_color_blue");
      } else {
        // 不显示
        this.mBackgroundColor = $r("app.color.transparent");
      }
    });
    this.mViewModel.registerPrivacyStateListener();
  }

  aboutToDisappear(): void {
    if (this.mViewModel != null) {
      this.mViewModel.unregisterPrivacyStateListener();
    }
  }

  build() {
    Row() {
      Text()
        .width(IndicatorStyle.indicatorSize)
        .height(IndicatorStyle.indicatorSize)
        .borderRadius(IndicatorStyle.indicatorBorderRadius)
        .backgroundColor(this.mBackgroundColor)
        .margin({ top: IndicatorStyle.indicatorTopMargin, right: IndicatorStyle.indicatorRightMargin });
    }
    .width('100%')
    .justifyContent(FlexAlign.End)
    .alignItems(VerticalAlign.Top)
  }
}
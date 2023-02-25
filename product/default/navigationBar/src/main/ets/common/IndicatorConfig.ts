/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

export default class IndicatorStyle {
  /**
   * 圆点尺寸
   */
  static readonly indicatorSize = '5.5vp';

  /**
   * 圆点圆角半径
   */
  static readonly indicatorBorderRadius = '3vp';

  /**
   * 圆点距离顶部尺寸
   */
  static readonly indicatorTopMargin = '3.5vp';

  /**
   * 圆点距离右侧尺寸
   */
  static readonly indicatorRightMargin = '37.5vp';
}

/**
 * 颜色类型
 */
export class IndicatorType {
  /**
   * 默认不显示
   */
  static readonly TYPE_NONE = 0;

  /**
   * 相机：橙色
   * 浅色：#ED6F21
   * 深色：#DB6B42
   */
  static readonly TYPE_ORANGE = 1;

  /**
   * 麦克风：绿色
   * 浅色：#64BB5C
   * 深色：#5BA854
   */
  static readonly TYPE_GREEN = 2;

  /**
   * 位置：蓝色
   * 浅色：#0A59F7
   * 深色：#317AF7
   */
  static readonly TYPE_BLUE = 3;
}

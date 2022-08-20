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
import Constants, {NotificationLayout as Layout} from '../../common/constants';
import FocusCallBack from '../../model/SwipeLayoutUtils';

const TAG = 'SwipeLayout';

@Component
export default struct SwipeLayout {
  angelCalFlag: boolean = false;
  responseSwipeEvent: boolean = false;
  surfaceWidth: number = -1;//通过获取当前控件宽度而获得
  rightThreshold: number = 0;//通过bottom控件的总宽度计算得出
  startX: number = 0;
  startY: number = 0;
  lastTouchX: number = 0;
  rateSurface: number = 1/1.3;//跟手
  rateDelete: number = 1/6;//右侧删除图标移动比例


  //需要配置项
  id: string = 'id default';//需要配置
  bottomLeftWidth: number = 0;//需要配置
  bottomRightWidth: number = 0;//需要配置
  leftThreshold: number = 0;//需要配置
  bottomHeight: number = 92;//需要配置，与外层的其他图标控件的高度保持一致
  deleteButtonCallback: any;// 需要配置
  @BuilderParam SurfaceComponent?: () => void;//需要配置
  @BuilderParam BottomLeftComponent?: () => void;//需要配置。根据UX设计，删除图标时固定的，其他图标要可配置，故这里采用由上层控件传入要配置的图标
  registerEventCapture: (id: string) => boolean = null;//需要配置 注入父组件的事件捕获逻辑

  //页面位置position坐标、透明度、宽高等状态变量
  @State overallX: number = 0;
  @State surfaceX: number = 0;
  @State bottomLeftX: number = 0;
  @State deleteCenterX: number = 0;
  @State rotateAngel: number = 0;
  @State scale: number = 1;
  @State surfaceOpacity: number = 1;
  @State bottomLeftOpacity: number = 0;//透明度默认值为0
  @State bottomRightOpacity: number = 0;//透明度默认值为0
  @State bottomLeftWidthMoving: number = 0;

  initState(): void{
    this.rightThreshold= this.surfaceWidth - this.bottomLeftWidth -this.bottomRightWidth;
    this.bottomLeftWidthMoving = this.bottomLeftWidth;
    this.surfaceX = 0;
    this.bottomLeftX = 0 + this.surfaceWidth;
    this.deleteCenterX = 0 + this.surfaceWidth + this.bottomLeftWidth + Layout.BUTTON_SIZE/2;
    this.surfaceOpacity = 1;;
    this.bottomLeftOpacity = 1;;
    this.bottomRightOpacity = 1;;
    this.responseSwipeEvent = false;
    return;
  }

  loseFocusCallback(){
    animateTo({
      duration: 200,
      curve: Curve.Friction,
      onFinish: () => {
      },
    }, () => {
      this.initState();
    })
  }

  deleteAnimation(){
    animateTo({
      duration: 250,
      curve: Curve.Friction,
      onFinish: () => {
        this.deleteButtonCallback();
      },
    }, () => {
      this.overallX = - this.surfaceWidth - this.surfaceX;
      this.surfaceOpacity = 0;
      this.bottomLeftOpacity = 0;
      this.bottomRightOpacity = 0;
    })
  }

  aboutToAppear(){
    Log.showInfo(TAG, `aboutToAppear`);
  }

  aboutToDisappear(){
    Log.showInfo(TAG, `aboutToDisappear`);
    FocusCallBack.deleteCallback(this.id);
  }

  build(){
    Row(){
      Row() {
        //Surface Component
        Row() {
          this.SurfaceComponent()
        }
        .zIndex(1)
        .width('100%')
        .position({ x: this.surfaceX })
        .opacity(this.surfaceOpacity)

        //Bottom Left Component
        Row() {
          this.BottomLeftComponent()
        }
        .justifyContent(FlexAlign.Center)
        .width(this.bottomLeftWidthMoving)
        .opacity(this.bottomLeftOpacity)
        .position({ x: this.bottomLeftX })
        .zIndex(0)

        Row(){
          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image($r("app.media.ic_public_delete_filled"))
              .objectFit(ImageFit.Contain)
              .fillColor($r("sys.color.ohos_id_color_primary_contrary"))
              .width(Layout.ICON_SIZE)
              .height(Layout.ICON_SIZE)
              .rotate({
                x: 0,
                y: 0,
                z: 1,
                centerX: '50%',
                centerY: '50%',
                angle: this.rotateAngel
              })
          }
          .backgroundColor($r("app.color.button_background"))
          .zIndex(1)
          .onClick(() => this.deleteAnimation())
          .width(Layout.BUTTON_SIZE)
          .height(Layout.BUTTON_SIZE)
          .scale({
            x: this.scale,
            y: this.scale,
            z: 1,
            centerX: '50%',
            centerY: '50%'
          })
        }
        .opacity(this.bottomRightOpacity)
        .width(Layout.BUTTON_SIZE)
        .height(this.bottomHeight)
        .clip(false)
        .markAnchor({ x: Layout.BUTTON_SIZE/2})
        .position({ x: this.deleteCenterX })
      }
      .width('100%')
      .position({ x: this.overallX })
    }
    .width('100%')
    .onTouch( (touchEvent: TouchEvent) => {
      if(this.registerEventCapture != null && this.registerEventCapture(this.id)){
        return;//表示询问过父组件后，如果该事件由父组件消费， 则本组件不会继续执行以后的逻辑。 如果上层的各级父组件都不消费，那么就由本组件消费
      }
      if (touchEvent.type == TouchType.Down) {
        if(this.surfaceWidth == -1){
          this.surfaceWidth = Number(touchEvent.target.area.width)//获取父组件的宽度,然后对滑动动效中所用的尺寸数据进行初始化
          this.initState()
        }
        this.responseSwipeEvent = false;//初始化标记，是否响应滑动事件
        this.angelCalFlag = false;//初始化角度判断的标记
        this.startX = touchEvent.touches[0].screenX;//记录下手指落下时的坐标
        this.startY = touchEvent.touches[0].screenY;
        this.lastTouchX = touchEvent.touches[0].screenX;//上一次move的坐标，用于计算增量
        if (!AppStorage.Has('swipelayout')) {
          AppStorage.SetOrCreate('swipelayout', this.id);//通过加appstorage的校验，可以防止嵌套使用时父组件由于阻止冒泡事件失效而触发滑动
        }
      } else if (touchEvent.type == TouchType.Move) {
        if (AppStorage.Get('swipelayout') != this.id){//只有匹配的id才允许被滑动，防止嵌套使用时父组件由于阻止冒泡事件失效而触发滑动
          return;
        }
        //如果有子组件被touch，那么父组件开头的就返回
        if(this.angelCalFlag == false){
          this.responseSwipeEvent = (Math.abs(touchEvent.touches[0].screenX - this.startX) > Math.abs(touchEvent.touches[0].screenY - this.startY));//如果x方向移动较多（这里取四十五度为分界），那么就认为响应左滑
          this.angelCalFlag = true; //改变角度标志位， 表示角度已经判断过了，之后无需重复判断

          FocusCallBack.setCallback(this.id, this.loseFocusCallback.bind(this));//将上一次滑动的控件弹回
        }
        if(this.responseSwipeEvent == false) {
          return;
        }
        //走到这里，角度判断过了，响应左滑也判断过了，那么先阻塞滑动事件传递，只让自己消费
        touchEvent.stopPropagation();//bug：这里阻塞事件传递的逻辑没有用，父组件还是会收到，故用storage配合组件id判断子组件是否被滑动

        //计算跟手距离
        let followHand = this.rateSurface * (touchEvent.touches[0].screenX - this.lastTouchX);//根据跟手系数计算出的surface应该改移动的距离，为增量距离
        this.surfaceX = this.surfaceX + followHand;
        this.bottomLeftX = this.bottomLeftX + followHand;

        //是否整体进入屏幕
        if(this.bottomLeftX > this.rightThreshold){//1、在右侧阈值的右侧,即底层的图标尚未完全进入屏幕   ----|左侧阈值|-------|右侧阈值| --here--
          this.rotateAngel = 0;
          this.scale = 1;
          this.deleteCenterX = this.bottomLeftX + this.bottomLeftWidth + Layout.BUTTON_SIZE/2;
        } else if (this.bottomLeftX > this.leftThreshold && this.bottomLeftX < this.rightThreshold) {//2、在左侧和右侧阈值的内，需要对边界值做处理  ----|左侧阈值|----here---|右侧阈值| ----
          if(this.bottomLeftOpacity == 0){//如果是在左侧阈值，且向右滑动，那么就需要显示其余按钮
            animateTo({
              duration: 200,
              curve: Curve.Friction,
              onFinish: () => {
              },
            }, () => {
              this.bottomLeftOpacity = 1;
              this.bottomLeftWidthMoving = (this.rightThreshold - this.bottomLeftX) * (1 - this.rateDelete) + this.bottomLeftWidth;
              this.deleteCenterX = this.bottomLeftX + this.bottomLeftWidthMoving + Layout.BUTTON_SIZE/2;
              this.rotateAngel = 12 - 12 * (this.bottomLeftX - this.leftThreshold)/(this.rightThreshold - this.leftThreshold);
              this.scale = 1.05 - 0.05 * (this.bottomLeftX - this.leftThreshold)/(this.rightThreshold - this.leftThreshold);
            })
          } else {//在非突变处，那么就跟手
            this.bottomLeftWidthMoving = (this.rightThreshold - this.bottomLeftX) * (1 - this.rateDelete) + this.bottomLeftWidth;
            this.deleteCenterX = this.bottomLeftX + this.bottomLeftWidthMoving + Layout.BUTTON_SIZE/2;
            this.rotateAngel = 12 - 12 * (this.bottomLeftX - this.leftThreshold)/(this.rightThreshold - this.leftThreshold);
            this.scale = 1.05 - 0.05 * (this.bottomLeftX - this.leftThreshold)/(this.rightThreshold - this.leftThreshold);
          }

        } else {//3. 小于最左边的阈值   --here--|左侧阈值|-------|右侧阈值| ----
          if (this.bottomLeftOpacity == 1){// 如果是在向左滑动，那么就需要隐藏掉其余按钮
            animateTo({
              duration: 200,
              curve: Curve.Friction,
              onFinish: () => {
              },
            }, () => {
              this.bottomLeftOpacity = 0;
              this.deleteCenterX = (this.bottomLeftX + this.surfaceWidth)/2;
              this.rotateAngel = 17;
              this.scale = 1.2;
            })
          } else {
            this.deleteCenterX = (this.bottomLeftX + this.surfaceWidth)/2;
          }
        }

        this.lastTouchX = touchEvent.touches[0].screenX;

      } else if (touchEvent.type == TouchType.Up) {
        AppStorage.Delete('swipelayout');//删除该字段,这样group会有左滑的机会
        if(this.responseSwipeEvent == false) {
          return;
        }
        if(this.bottomLeftX > this.rightThreshold){//在阈值2右侧,尚未完全进入屏幕
          FocusCallBack.deleteCallback(this.id)
          animateTo({
            duration: 200,
            curve: Curve.Friction,
            onFinish: () => {
            },
          }, () => {
            this.surfaceX = 0;
            this.bottomLeftX = 0 + this.surfaceWidth;
            this.deleteCenterX = 0 + this.surfaceWidth + this.bottomLeftWidth + Layout.BUTTON_SIZE/2;// 垃圾桶控件左侧x坐标
          })
        } else if (this.bottomLeftX > this.leftThreshold && this.bottomLeftX < this.rightThreshold) {
          animateTo({
            duration: 300,
            curve: Curve.Friction,
            onFinish: () => {
            },
          }, () => {
            this.bottomLeftOpacity = 1;
            this.bottomLeftX = this.rightThreshold;
            this.deleteCenterX = this.bottomLeftX + this.bottomLeftWidth + Layout.BUTTON_SIZE/2;
            this.surfaceX = this.bottomLeftX - this.surfaceWidth;
            this.bottomLeftWidthMoving = this.bottomLeftWidth;
            this.rotateAngel = 0;
          })
        } else  {
          this.deleteButtonCallback();
        }
      }
    })
  }
}
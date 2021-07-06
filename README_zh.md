# SystemUI<a name="ZH-CN_TOPIC_0000001103330836"></a>

-   [简介](#section11660541593)
    -   [架构图](#section125101832114213)

-   [目录](#section161941989596)
-   [相关仓](#section1371113476307)

## 简介<a name="section11660541593"></a>

SystemUI应用是OpenHarmony中预置的系统应用，为用户提供系统相关信息展示及交互界面，包括系统状态、系统提示、系统提醒等，例如系统时间、电量信息。

### 架构图<a name="section125101832114213"></a>

![](figures/zh-cn_image_0000001103686480.png)

## 目录<a name="section161941989596"></a>

```
/applications/standard/systemui
├── figures                     # 架构图目录
├── entry                       # 主entry模块目录
│   └── src
│       ├── main
│           ├── js              # js代码目录
│           ├── resources       # 资源配置文件存放目录
│           └── config.json     # 全局配置文件
├── navigationBar               # 系统导航模块目录
│   └── src
│       ├── main
│           ├── js              # js代码目录
│           ├── resources       # 资源配置文件存放目录
│           └── config.json     # 全局配置文件
├── signature                   # 证书文件目录
├── LICENSE                     # 许可文件
```

## 相关仓<a name="section1371113476307"></a>

系统应用

**applications\_systemui**


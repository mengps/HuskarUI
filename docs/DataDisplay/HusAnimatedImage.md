[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusAnimatedImage 动态图片


可预览的动态图片。

* **模块 { HuskarUI.Basic }**

* **继承自 { AnimatedImage }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
previewEnabled | bool | true| 是否启用预览
hovered | bool(readonly) | - | 鼠标是否悬浮
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
fallback | url | '' | 加载失败时显示的图像占位符
placeholder | url | '' | 加载时显示的图像占位符
items | array | [] | 预览图片源

<br/>

### {items}支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
url | url | 必选 | 图片源

<br/>

## 代码演示

### 示例 1 - 基本用法

基本用法与 [HusImage](./HusImage.md) 一致。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSwitch {
        id: previewEnabledSwitch
        checkedText: 'Enable'
        uncheckedText: 'Disable'
        checked: true
    }

    HusAnimatedImage {
        width: 200
        height: width
        source: 'https://gw.alipayobjects.com/zos/rmsportal/LyTPSGknLUlxiVdwMWyu.gif'
        previewEnabled: previewEnabledSwitch.checked
    }
}
```


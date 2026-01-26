[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusScrollBar 滚动条


滚动条是一个交互式栏，用于滚动某个区域或视图到特定位置。

* **模块 { HuskarUI.Basic }**

* **继承自 { ScrollBar }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述 |
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画
minimumHandleSize | int | 24 | 滑块的最小大小
colorBar | color | - | 把手颜色
colorBg | color | - | 背景颜色
colorIcon | color | - | 图标颜色(即箭头颜色)

<br/>

## 代码演示

### 示例 1

使用方法和 `ScrollBar` 一致。

```qml
import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

Item {
    Flickable {
        width: 200
        height: 200
        contentWidth: 400
        contentHeight: 400
        ScrollBar.vertical: HusScrollBar { }
        ScrollBar.horizontal: HusScrollBar { }
        clip: true

        HusIconText {
            iconSize: 400
            iconSource: HusIcon.BugOutlined
        }
    }
}
```


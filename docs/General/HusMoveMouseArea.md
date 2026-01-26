[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusMoveMouseArea 移动鼠标区域


提供对任意 Item 进行鼠标移动操作的区域。

* **模块 { HuskarUI.Basic }**

* **继承自 { MouseArea }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
target | var | undefined | 要移动的目标
minimumX | real | -Number.MAX_VALUE | 可移动的最小x坐标
maximumX | real | Number.MAX_VALUE | 可移动的最大x坐标
minimumY | real | -Number.MAX_VALUE | 可移动的最小y坐标
maximumY | real | Number.MAX_VALUE | 可移动的最大y坐标

<br/>

## 代码演示

### 示例 1

通过 `target` 设置要移动的目标。

```qml
import QtQuick
import HuskarUI.Basic

Rectangle {
    color: 'transparent'
    border.color: HusTheme.Primary.colorTextQuaternary
    width: 400
    height: 400
    clip: true

    Rectangle {
        width: 100
        height: 100
        color: 'red'

        HusMoveMouseArea {
            anchors.fill: parent
            target: parent
            preventStealing: true
        }
    }
}
```


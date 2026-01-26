[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusResizeMouseArea 改变大小鼠标区域


提供对任意 Item 进行鼠标改变大小操作的区域。

* **模块 { HuskarUI.Basic }**

* **继承自 { Item }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
target | var | undefined | 要移动的目标
preventStealing | bool | false | 鼠标事件不可被盗取
areaMarginSize | int | 8 | 改变大小区域的边缘大小
resizable | bool | true | 是否可改变大小
minimumWidth | real | 0 | 可改变的最小宽度
maximumWidth | real | Number.MAX_VALUE | 可改变的最大宽度
minimumHeight | real | 0 | 可改变的最小高度
maximumHeight | real | Number.MAX_VALUE |可改变的最小高度
movable | bool | false | 可移动的最小x坐标
minimumX | real | -Number.MAX_VALUE | 可移动的最小x坐标
maximumX | real | Number.MAX_VALUE | 可移动的最大x坐标
minimumY | real | -Number.MAX_VALUE | 可移动的最小y坐标
maximumY | real | Number.MAX_VALUE | 可移动的最大y坐标

<br/>

## 代码演示

### 示例 1

通过 `target` 设置要改变大小的目标。

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

        HusResizeMouseArea {
            anchors.fill: parent
            target: parent
            movable: true
            preventStealing: true
            minimumWidth: 50
            minimumHeight: 50
        }
    }
}
```


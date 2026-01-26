[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusCheckerBoard 棋盘格 


显示一个双色棋盘格。

* **模块 { HuskarUI.Basic }**

* **继承自 { Item }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
rows | int | 0 | 行数
columns | int | 0 | 列数
colorWhite | color | 'transparent' | 白格子颜色
colorBlack | color | - | 黑格子颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角

<br/>

<br/>

## 代码演示

### 示例 1 - 基本用法

最简单的用法。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusCheckerBoard {
        width: 400
        height: 400
        rows: 16
        columns: 16
        colorWhite: 'white'
        colorBlack: 'black'
    }
}
```


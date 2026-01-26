[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusText 文本


提供统一字体和颜色的文本(替代Text)。

* **模块 { HuskarUI.Basic }**

* **继承自 { Text }**

* **继承自 { [HusIconText](./HusIconText.md) }**


<br/>

### 支持的代理：

- 无


<br/>

## 代码演示

### 示例 1

使用方法等同于 `Text`

```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 15

    HusText {
        text: qsTr('HusText文本')
    }
}
```


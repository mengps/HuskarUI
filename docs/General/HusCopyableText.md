[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusCopyableText 可复制文本


在需要可复制的文本时使用(替代Text)。

* **模块 { HuskarUI.Basic }**

* **继承自 { TextEdit }**


<br/>

### 支持的代理：

- 无


<br/>

## 代码演示

### 示例 1

使用方法等同于 `TextEdit`

```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 15

    HusCopyableText {
        text: qsTr('可以复制我')
    }
}
```


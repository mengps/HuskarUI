[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusCaptionButton 标题按钮


一般用于窗口标题栏的按钮。

* **模块 { HuskarUI.Basic }**

* **继承自 { [HusIconButton](./HusIconButton.md) }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
isError | bool | false | 是否为警示按钮
noDisabledState | bool | false | 无禁用状态(即被禁用时不会更改颜色)

<br/>

## 代码演示

### 示例 1

通过 `isError` 属性设置为警示按钮，例如关闭按钮。

```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 15

    HusCaptionButton {
        iconSource: HusIcon.CloseOutlined
    }

    HusCaptionButton {
        isError: true
        iconSource: HusIcon.CloseOutlined
    }

    HusCaptionButton {
        text: qsTr('关闭')
        colorText: colorIcon
        iconSource: HusIcon.CloseOutlined
    }
}
```


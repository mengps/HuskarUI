[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusLabel 文本标签


扩展了HusText(文本)的功能, 并自带背景和圆角。

* **模块 { HuskarUI.Basic }**

* **继承自 { Label }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
borderWidth | real | 1 | 边框宽度
colorText | color | - | 文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
radiusBg | [HusRadius](./HusRadius.md) | - | 背景圆角

<br/>

## 代码演示

### 示例 1

使用方法等同于 `Label`

```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    Row {
        HusText {
            anchors.verticalCenter: parent.verticalCenter
            text: 'Radius:   '
        }
        HusSlider {
            id: radiusSlider
            width: 150
            height: 30
            min: 0
            max: 30
            value: 0
        }
    }

    HusSwitch {
        id: enabledSwitch
        checked: true
        text: 'Enabeld: '
    }

    HusLabel {
        padding: 20
        enabled: enabledSwitch.checked
        text: qsTr('HusLabel文本')
        radiusBg.all: radiusSlider.currentValue
    }
}
```


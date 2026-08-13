[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusFrame 框架


逻辑控件组的视觉框架。

* **模块 { HuskarUI.Basic }**

* **继承自 { Frame }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
colorBg | color | - | 背景颜色
radiusBg | [HusRadius](./HusRadius.md) | - | 背景圆角
borderBg | [HusBorder](./HusBorder.md) | - | 背景边框

<br/>

## 代码演示

### 示例 1

使用方法等同于 `Frame`

```qml
import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Column {
    spacing: 15

    HusFrame {
        padding: 20

        HusSpace {
            anchors.fill: parent
            layout: 'ColumnLayout'
            spacing: 10

            HusCheckBox { text: 'E-mail '}
            HusCheckBox { text: 'Calendar' }
            HusCheckBox { text: 'Contacts' }
        }
    }

    HusFrame {
        padding: 20

        HusSpace {
            anchors.fill: parent
            layout: 'ColumnLayout'

            HusCard {
                Layout.fillWidth: true
                title: 'Card title'
                extraDelegate: HusButton { type: HusButton.Type_Link; text: 'More' }
                bodyDescription: 'Card content\nCard content\nCard content'
            }
            HusSpace {
                Layout.fillWidth: true
                layout: 'RowLayout'

                HusInput { text: 'https://github.com/mengps/HuskarUI' }
                HusButton { Layout.preferredWidth: 80; type: HusButton.Type_Primary; text: 'Submit' }
            }
            HusSpace {
                Layout.fillWidth: true
                layout: 'RowLayout'

                HusInput { text: 'https://github.com/mengps/HuskarUI' }
                HusIconButton { Layout.preferredWidth: 80; iconSource: HusIcon.CopyOutlined }
            }
        }
    }
}
```


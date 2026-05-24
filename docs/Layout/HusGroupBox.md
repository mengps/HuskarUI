[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusGroupBox 分组框 


在一个有标题的视觉框架内将一组逻辑控件布局在一起。

* **模块 { HuskarUI.Basic }**

* **继承自 { GroupBox }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
borderWidth | real | 1 | 边框线宽
colorTitle | color | - | 标题颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角
sizeHint | string | 'normal' | 尺寸提示

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

    HusCheckBox {
        id: enabledCheckBox
        text: 'Enabled'
        checked: true
    }

    HusRadioBlock {
        id: sizeHintRadio
        initCheckedIndex: 1
        model: [
            { label: 'Small', value: 'small' },
            { label: 'Normal', value: 'normal' },
            { label: 'Large', value: 'large' },
        ]
    }

    HusGroupBox {
        padding: 20 * sizeRatio
        title: 'GroupBox'
        enabled: enabledCheckBox.checked
        sizeHint: sizeHintRadio.currentCheckedValue

        HusSpace {
            layout: 'ColumnLayout'
            spacing: 10

            HusCheckBox { text: 'E-mail '; sizeHint: sizeHintRadio.currentCheckedValue }
            HusCheckBox { text: 'Calendar'; sizeHint: sizeHintRadio.currentCheckedValue }
            HusCheckBox { text: 'Contacts'; sizeHint: sizeHintRadio.currentCheckedValue }
        }
    }
}
```

---

### 示例 2

自定义 `label`。

```qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import HuskarUI.Basic

Column {
    spacing: 15

    HusGroupBox {
        padding: 20
        title: 'CheckGroup'
        label: HusCheckBox {
            id: parentBox
            x: parent.leftPadding
            text: parent.title
            checkState: childGroup.checkState
        }

        ButtonGroup {
            id: childGroup
            exclusive: false
            checkState: parentBox.checkState
        }

        HusSpace {
            layout: 'ColumnLayout'
            spacing: 10

            HusCheckBox { ButtonGroup.group: childGroup; text: 'E-mail ' }
            HusCheckBox { ButtonGroup.group: childGroup; text: 'Calendar' }
            HusCheckBox { ButtonGroup.group: childGroup; text: 'Contacts' }
        }
    }
}
```


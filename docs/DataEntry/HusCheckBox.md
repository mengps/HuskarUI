[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusCheckBox 多选框 


收集用户的多项选择。

* **模块 { HuskarUI.Basic }**

* **继承自 { CheckBox }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
indicatorSize | int | 18 | 指示器大小
elide | enum | Text.ElideNone | 设置文本的elide属性(参考Text文档)
colorText | color | - | 文本颜色
colorIndicator | color | - | 指示器颜色
colorIndicatorBorder | color | - | 指示器边框颜色
radiusIndicator | [HusRadius](../General/HusRadius.md) | - | 指示器圆角
contentDescription | string | '' | 内容描述(提高可用性)

<br/>

## 代码演示

### 示例 1

最简单的用法。

通过 `enabled` 设置是否启用。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    HusRadioBlock {
        id: sizeHintRadio
        initCheckedIndex: 1
        model: [
            { label: 'Small', value: 'small' },
            { label: 'Normal', value: 'normal' },
            { label: 'Large', value: 'large' },
        ]
    }

    Row {
        spacing: 10

        HusCheckBox {
            text: qsTr('Checkbox')
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusCheckBox {
            text: qsTr('Disabled')
            enabled: false
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusCheckBox {
            text: qsTr('Disabled')
            checkState: Qt.PartiallyChecked
            enabled: false
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusCheckBox {
            text: qsTr('Disabled')
            checkState: Qt.Checked
            enabled: false
            sizeHint: sizeHintRadio.currentCheckedValue
        }
    }
}
```

---

### 示例 2

使用 `ButtonGroup(QtQuick原生组件)` 来实现全选效果，具体可参考 `CheckBox` 文档。


```qml
import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

Column {
    spacing: 10

    ButtonGroup {
        id: childGroup
        exclusive: false
        checkState: parentBox.checkState
    }

    HusCheckBox {
        id: parentBox
        text: qsTr('Parent')
        checkState: childGroup.checkState
    }

    HusCheckBox {
        checked: true
        text: qsTr('Child 1')
        leftPadding: indicator.width
        ButtonGroup.group: childGroup
    }

    HusCheckBox {
        text: qsTr('Child 2')
        leftPadding: indicator.width
        ButtonGroup.group: childGroup
    }

    HusCheckBox {
        text: qsTr('More...')
        leftPadding: indicator.width
        ButtonGroup.group: childGroup

        HusInput {
            width: 110
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            visible: parent.checked
            placeholderText: qsTr('Please input')
        }
    }
}
```


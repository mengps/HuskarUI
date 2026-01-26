[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusRadio 单选框 


用于在多个备选项中选中单个状态。

* **模块 { HuskarUI.Basic }**

* **继承自 { RadioButton }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
hoverCursorShape | enum | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
colorText | color | - | 文本颜色
colorIndicator | color | - | 指示器颜色
colorIndicatorBorder | color | - | 指示器边框颜色
radiusIndicator | [HusRadius](../General/HusRadius.md) | 8 | 指示器圆角
contentDescription | string | '' | 内容描述(提高可用性)

<br/>

## 代码演示

### 示例 1

最简单的用法。

通过 `enabled` 设置是否启用。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusRadio {
        text: qsTr('Radio')
    }

    HusRadio {
        text: qsTr('Disabled')
        enabled: false
    }
}
```

---

### 示例 2

使用 `ButtonGroup(QtQuick原生组件)` 来实现一组互斥的 HusRadio 配合使用。


```qml
import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

Row {
    height: 50
    anchors.top: parent.top
    anchors.topMargin: 20
    spacing: 10

    ButtonGroup { id: radioGroup }

    HusRadio {
        text: qsTr('LineChart')
        ButtonGroup.group: radioGroup

        HusIconText {
            anchors.bottom: parent.top
            anchors.bottomMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            iconSize: 24
            iconSource: HusIcon.LineChartOutlined
        }
    }

    HusRadio {
        text: qsTr('DotChart')
        ButtonGroup.group: radioGroup

        HusIconText {
            anchors.bottom: parent.top
            anchors.bottomMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            iconSize: 24
            iconSource: HusIcon.DotChartOutlined
        }
    }

    HusRadio {
        text: qsTr('BarChart')
        ButtonGroup.group: radioGroup

        HusIconText {
            anchors.bottom: parent.top
            anchors.bottomMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            iconSize: 24
            iconSource: HusIcon.BarChartOutlined
        }
    }

    HusRadio {
        text: qsTr('PieChart')
        ButtonGroup.group: radioGroup

        HusIconText {
            anchors.bottom: parent.top
            anchors.bottomMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            iconSize: 24
            iconSource: HusIcon.PieChartOutlined
        }
    }
}
```

---

### 示例 3

垂直的 HusRadio，配合更多输入框选项。


```qml
import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

Column {
    spacing: 10

    ButtonGroup { id: radioGroup2 }

    HusRadio {
        text: qsTr('Option A')
        ButtonGroup.group: radioGroup2
    }

    HusRadio {
        text: qsTr('Option B')
        ButtonGroup.group: radioGroup2
    }

    HusRadio {
        text: qsTr('Option C')
        ButtonGroup.group: radioGroup2
    }

    HusRadio {
        text: qsTr('More...')
        ButtonGroup.group: radioGroup2

        HusInput {
            visible: parent.checked
            placeholderText: qsTr('Please input')
            width: 110
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
        }
    }
}
```


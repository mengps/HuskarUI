[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusButton 按钮


按钮用于开始一个即时操作。

* **模块 { HuskarUI.Basic }**

* **继承自 { Button }**

* **继承此 { [HusIconButton](./HusIconButton.md) }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
active | bool | down丨checked | 是否处于激活状态
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
type | enum | HusButton.Type_Default | 按钮类型(来自 HusButton)
shape | enum | HusButton.Shape_Default | 按钮形状(来自 HusButton)
colorText | color | - | 文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
radiusBg | [HusRadius](./HusRadius.md) | - | 背景圆角
sizeHint | string | 'normal' | 尺寸提示
contentDescription | string | '' | 内容描述(提高可用性)

<br/>

## 代码演示

### 示例 1

通过 `sizeHint` 属性设置尺寸。

通过 `type` 属性改变按钮类型，支持的类型：

- 默认按钮{ HusButton.Type_Default }

- 线框按钮{ HusButton.Type_Outlined }

- 虚线按钮{ HusButton.Type_Dashed }

- 主要按钮{ HusButton.Type_Primary }

- 填充按钮{ HusButton.Type_Filled }

- 文本按钮{ HusButton.Type_Text }

- 链接按钮{ HusButton.Type_Link }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

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
        spacing: 15

        HusButton {
            text: qsTr('默认')
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusButton {
            text: qsTr('线框')
            type: HusButton.Type_Outlined
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusButton {
            text: qsTr('虚线')
            type: HusButton.Type_Dashed
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusButton {
            text: qsTr('主要')
            type: HusButton.Type_Primary
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusButton {
            text: qsTr('填充')
            type: HusButton.Type_Filled
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusButton {
            text: qsTr('文本')
            type: HusButton.Type_Text
            sizeHint: sizeHintRadio.currentCheckedValue
        }

        HusButton {
            text: qsTr('链接')
            type: HusButton.Type_Link
            sizeHint: sizeHintRadio.currentCheckedValue
        }
    }
}
```

---

### 示例 2

通过 `enabled` 属性启用或禁用按钮，禁用的按钮不会响应任何交互。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 15

    HusButton {
        text: qsTr('默认')
        enabled: false
    }

    HusButton {
        text: qsTr('线框')
        type: HusButton.Type_Outlined
        enabled: false
    }

    HusButton {
        text: qsTr('主要')
        type: HusButton.Type_Primary
        enabled: false
    }

    HusButton {
        text: qsTr('填充')
        type: HusButton.Type_Filled
        enabled: false
    }

    HusButton {
        text: qsTr('文本')
        type: HusButton.Type_Text
        enabled: false
    }

    HusButton {
        text: qsTr('链接')
        type: HusButton.Type_Link
        enabled: false
    }
}
```

---

### 示例 3

通过 `shape` 属性改变按钮形状，支持的形状：

- 默认形状{ HusButton.Shape_Default }

- 圆形{ HusButton.Shape_Circle }

```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 15

    HusButton {
        text: qsTr('A')
        shape: HusButton.Shape_Circle
    }

    HusButton {
        text: qsTr('A')
        type: HusButton.Type_Outlined
        shape: HusButton.Shape_Circle
    }

    HusButton {
        text: qsTr('A')
        type: HusButton.Type_Primary
        shape: HusButton.Shape_Circle
    }

    HusButton {
        text: qsTr('A')
        type: HusButton.Type_Filled
        shape: HusButton.Shape_Circle
    }

    HusButton {
        text: qsTr('A')
        type: HusButton.Type_Text
        shape: HusButton.Shape_Circle
    }
}
```


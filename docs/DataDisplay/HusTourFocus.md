[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusTourFocus 漫游焦点


聚焦于某个功能的焦点。

* **模块 { HuskarUI.Basic }**

* **继承自 { Popup }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
penetrationEvent | bool | false | 是否可穿透事件
maskClosable | bool | true | 点击蒙层是否允许关闭
target | Item | - | 焦点目标
overlayColor | color | - | 覆盖层颜色
focusMargin | int | 5 | 焦点边距
focusRadius | int | 2 | 焦点圆角

<br/>

## 代码演示

### 示例 1 - 基本

通过 `target` 属性设置焦点目标。

通过 `overlayColor` 属性设置覆盖层颜色。

通过 `focusMargin` 属性设置焦点边距。

通过 `focusRadius` 属性设置焦点圆角。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusButton {
        text: qsTr('漫游焦点')
        type: HusButton.Type_Primary
        onClicked: {
            tourFocus.open();
        }

        HusTourFocus {
            id: tourFocus
            target: tourFocus1
        }
    }

    Row {
        spacing: 10

        HusButton {
            id: tourFocus1
            text: qsTr('漫游焦点1')
            type: HusButton.Type_Outlined
        }
    }
}
```

---

### 示例 2 - 聚焦组件可交互

通过 `penetrationEvent` 属性设置是否可穿透事件。


```qml
import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

Column {
    spacing: 10

    HusButton {
        text: qsTr('穿透焦点')
        type: HusButton.Type_Primary
        onClicked: {
            tourFocus2.open();
        }

        HusTourFocus {
            id: tourFocus2
            target: tourFocusGrid
            penetrationEvent: true
            focusMargin: marginSlider.currentValue
            focusRadius: radiusSlider.currentValue
            closePolicy: Popup.CloseOnEscape
        }
    }

    Grid {
        id: tourFocusGrid
        spacing: 10
        columns: 2
        verticalItemAlignment: Grid.AlignVCenter

        HusText {
            text: 'Margin: '
        }

        HusSlider {
            id: marginSlider
            width: 200
            height: 30
            min: 0
            max: 20
            value: 5
            handleToolTipDelegate: HusToolTip {
                visible: handleHovered || handlePressed
                text: marginSlider.currentValue.toFixed(0)
            }
        }

        HusText {
            text: 'Radius: '
        }

        HusSlider {
            id: radiusSlider
            width: 200
            height: 30
            min: 0
            max: 20
            handleToolTipDelegate: HusToolTip {
                visible: handleHovered || handlePressed
                text: radiusSlider.currentValue.toFixed(0)
            }
        }

        HusButton {
            text: qsTr('漫游焦点1')
            type: HusButton.Type_Outlined
        }

        HusButton {
            text: qsTr('关闭')
            type: HusButton.Type_Outlined
            onClicked: tourFocus2.close();
        }
    }
}
```


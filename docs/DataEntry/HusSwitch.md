[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusSwitch 开关


使用开关切换两种状态之间。

* **模块 { HuskarUI.Basic }**

* **继承自 { Switch }**


<br/>

### 支持的代理：

- **handleDelgate: Component** 开关把手代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
hoverCursorShape | enum | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
loading | bool | false | 是否在加载中
checkedText | string | '' | 选中文本
uncheckedText | string | '' | 未选中文本
checkedIconSource | int丨string | 0丨'' | 选中图标(来自 HusIcon)或图标链接
uncheckedIconSource | int丨string | 0丨'' | 未选中图标(来自 HusIcon)或图标链接
iconSize | int | - | 选中/未选中图标大小
textFont | font | - | 文本字体
colorText | color | - | 文本颜色
colorHandle | color | - | 把手颜色
colorBg | color | - | 背景颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景半径
contentDescription | string | '' | 内容描述(提高可用性)

<br/>

## 代码演示

### 示例 1

最简单的用法。

```qml
import QtQuick
import HuskarUI.Basic

Row {
    HusSwitch { }
}
```

---

### 示例 2

Switch 失效状态，由 `enabled` 属性控制。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    HusSwitch {
        id: switch1
        enabled: false
    }

    HusButton {
        text: qsTr('切换 enabled')
        type: HusButton.Type_Primary
        onClicked: switch1.enabled = !switch1.enabled;
    }
}
```

---

### 示例 3

Switch 支持两种文本：

`checkedText` 属性设置选中文本

`uncheckedText` 属性设置未选中文本

或者：

`checkedIconSource` 属性设置选中图标

`uncheckedIconSource` 属性设置未选中图标

**注意**：如果两种同时设置了，则显示为图标。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    HusSwitch {
        checkedText: qsTr('开启')
        uncheckedText: qsTr('关闭')
    }

    HusSwitch {
        checkedIconSource: HusIcon.CheckOutlined
        uncheckedIconSource: HusIcon.CloseOutlined
    }
}
```

---

### 示例 4

通过 `loading` 属性设置开关显示加载动画。

可以让 `enabled` 绑定 `loading` 实现加载完成才启用。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    HusSwitch {
        loading: true
        checked: true
    }

    HusSwitch {
        loading: true
        checked: true
        enabled: !loading
    }

    HusSwitch {
        loading: true
    }
}
```

---

### 示例 5

通过 `handleDelegate` 属性定义开关把手的代理。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    HusSwitch {
        id: switch2
        radiusBg.all: 2
        handleDelegate: Rectangle {
            radius: 2
            color: switch2.colorHandle
        }
    }
}
```


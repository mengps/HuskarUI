[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusColorPicker 颜色选择器 


用于选择颜色。

* **模块 { HuskarUI.Basic }**

* **继承自 { AbstractButton }**


<br/>

### 支持的代理：

- **textDelegate: Component** 文本代理

- **titleDelegate: Component** 弹窗标题代理

- **footerDelegate: Component** 弹窗页脚代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
active | bool | - | 是否处于激活状态
value | color(readonly) | '' | 当前的颜色值(autoChange为false时等于changeValue)
defaultValue | color | '#fff' | 默认颜色值
autoChange | bool | true | 是否自动更新当前颜色值
changeValue | color | defaultValue | 更改的颜色值
showText | bool | false | 是否显示文本
textFormatter | function(color): string | - | 文本格式化器
title | string | '' | 弹窗标题
alphaEnabled | bool | true | 透明度是否启用
open | bool | false | 弹窗是否打开
format | string | 'hex' | 颜色格式
presets | list | [] | 预设颜色列表
presetsOrientation | enum | Qt.Vertical | 预设颜色视图的方向(来自 Qt.*)
presetsLayoutDirection | enum | Qt.LeftToRight | 预设颜色视图的布局方向(来自 Qt.*)
titleFont | font | - | 标题字体
inputFont | font | - | 输入框文本字体
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorText | color | - | 文本颜色
colorTitle | color | - | 标题颜色
colorInput | color | - | 输入框文本颜色
colorPresetIcon | color | - | 预设视图图标颜色
colorPresetText | color | - | 预设视图文本颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 触发器背景圆角
radiusTriggerBg | [HusRadius](../General/HusRadius.md) | - | 触发器圆角
radiusPopupBg | [HusRadius](../General/HusRadius.md) | - | 弹窗背景圆角
popup | [HusPopup](../General/HusPopup.md) | - | 访问内部弹窗
panel | [HusColorPickerPanel](./HusColorPickerPanel.md) | - | 访问内部颜色选择面板

<br/>

### `presets` 支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | string | 必选 | 标签
colors | list | 必选 | 颜色列表
expanded | bool | 可选 | 默认是否展开

<br/>

### 支持的函数：

- `toHexString(color: color): string` 将 `color` 转为16进制字符串

- `toHsvString(color: color): string` 将 `color` 转为hsv/hsva字符串

- `toRgbString(color: color): string` 将 `color` 转为rgb/rgba字符串


<br/>

### 支持的信号：

- `change(color: color)` 颜色改变时发出

  - `color` 当前的颜色


<br/>

## 代码演示

### 示例 1 - 基本使用

最简单的用法。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusColorPicker {
        defaultValue: '#1677ff'
    }
}
```

---

### 示例 2 - 禁用透明度

通过 `alphaEnabled` 属性设置是否启用透明度。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusCheckBox {
        id: alphaCheckBox
        checked: true
        text: qsTr('Enabled Alpha')
    }

    HusColorPicker {
        defaultValue: '#1677ff'
        alphaEnabled: alphaCheckBox.checked
    }
}
```

---

### 示例 3 - 自定义文本

通过 `showText` 属性设置是否显示触发器文本。

通过 `textFormatter` 属性设置触发器文本格式化器，它是形如：`function(color: color): string { }` 的函数。

通过 `textDelegate` 属性自定义触发器文本代理。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusColorPicker {
        defaultValue: '#1677ff'
        showText: true
    }

    HusColorPicker {
        defaultValue: '#1677ff'
        showText: true
        textFormatter: color => `Custom Text (\${String(color).toUpperCase()})`
    }

    HusColorPicker {
        id: customTextPicker
        defaultValue: '#1677ff'
        showText: true
        textDelegate: HusIconText {
            iconSource: customTextPicker.open ? HusIcon.UpOutlined : HusIcon.DownOutlined
            verticalAlignment: HusIconText.AlignVCenter
        }
    }
}
```

---

### 示例 4 - 自定义标题

通过 `title` 属性设置是否显示弹出面板的标题。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusColorPicker {
        defaultValue: '#1677ff'
        showText: true
        title: 'color picker'
    }
}
```

---

### 示例 5 - 受控模式

通过 `autoChange` 属性设置自动更新值。

为否时 `value` 值为 `changeValue`，此时可手动设置 `changeValue` 来更新 `value`。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusColorPicker {
        id: noAutoChangePicker
        defaultValue: '#1677ff'
        showText: true
        autoChange: false
        onChange: color => selectColor = color;
        popup.closePolicy: HusPopup.NoAutoClose
        property color selectColor: value
        footerDelegate: Item {
            height: 45

            HusDivider {
                width: parent.width - 24
                height: 1
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                spacing: 20
                anchors.centerIn: parent

                HusButton {
                    text: qsTr('Accept')
                    onClicked: {
                        noAutoChangePicker.changeValue = noAutoChangePicker.selectColor;
                        noAutoChangePicker.open = false;
                    }
                }

                HusButton {
                    text: qsTr('Cancel')
                    onClicked: {
                        noAutoChangePicker.changeValue = noAutoChangePicker.value;
                        noAutoChangePicker.defaultValue = noAutoChangePicker.value;
                        noAutoChangePicker.open = false;
                    }
                }
            }
        }
    }
}
```

---

### 示例 6 - 预设颜色

通过 `presets` 属性设置预设颜色数组，数组对象支持的属性：

- { label: 标签 }

- { colors: 颜色列表 }

- { expanded: 默认是否展开 }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusColorPicker {
        defaultValue: '#1677ff'
        presets: [
            { label: 'primary', colors: HusThemeFunctions.genColor(HusColorGenerator.Preset_Blue) },
            { label: 'red', colors: HusThemeFunctions.genColor(HusColorGenerator.Preset_Red), expanded: false },
            { label: 'green', colors: HusThemeFunctions.genColor(HusColorGenerator.Preset_Green) },
        ]
    }
}
```

---

### 示例 7 - 预设颜色视图的方向和布局

通过 `presetsOrientation` 属性设置预设颜色视图的方向。

通过 `presetsLayoutDirection` 属性设置预设颜色视图的布局方向。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusRadioBlock {
        id: orientatioRadio
        initCheckedIndex: 0
        model: [
            { label: 'Horizontal', value: Qt.Horizontal },
            { label: 'Vertical', value: Qt.Vertical },
        ]
    }

    HusRadioBlock {
        id: layoutDirectionRadio
        initCheckedIndex: 0
        model: [
            { label: 'LeftToRight', value: Qt.LeftToRight },
            { label: 'RightToLeft', value: Qt.RightToLeft },
        ]
    }

    HusColorPicker {
        defaultValue: '#1677ff'
        presets: [
            { label: 'primary', colors: HusThemeFunctions.genColor(HusColorGenerator.Preset_Blue) },
            { label: 'red', colors: HusThemeFunctions.genColor(HusColorGenerator.Preset_Red), expanded: false },
            { label: 'green', colors: HusThemeFunctions.genColor(HusColorGenerator.Preset_Green) },
        ]
        presetsOrientation: orientatioRadio.currentCheckedValue
        presetsLayoutDirection: layoutDirectionRadio.currentCheckedValue
    }
}
```


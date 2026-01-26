[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusColorPickerPanel 颜色选择器面板 


用于选择颜色。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **titleDelegate: Component** 弹窗标题代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
active | bool | - | 是否处于激活状态
value | color | '' | 当前的颜色值(autoChange为false时等于changeValue)
defaultValue | color | '#fff' | 默认颜色值
autoChange | bool | true | 默认颜色值
changeValue | color | defaultValue | 更改的颜色值
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
colorTitle | color | - | 标题颜色
colorInput | color | - | 输入框文本颜色
colorPresetIcon | color | - | 预设视图图标颜色
colorPresetText | color | - | 预设视图文本颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角

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

### 示例 1 - 基本用法

基本用法在 [HusColorPicker](./HusColorPicker.md) 中已有示例。


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

    HusColorPickerPanel {
        title: 'color picker panel'
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


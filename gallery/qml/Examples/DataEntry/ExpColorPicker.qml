import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusColorPicker 颜色选择器 \n
用于选择颜色。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **textDelegate: Component** 文本代理\n
- **titleDelegate: Component** 弹窗标题代理\n
- **footerDelegate: Component** 弹窗页脚代理\n
\n<br/>
\n### 支持的属性：\n
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
radiusTriggerBg | [HusRadius](internal://HusRadius) | - | 触发器背景圆角
radiusPopupBg | [HusRadius](internal://HusRadius) | - | 弹窗背景圆角
popup | [HusPopup](internal://HusPopup) | - | 访问内部弹窗
panel | [HusColorPickerPanel](internal://HusColorPickerPanel) | - | 访问内部颜色选择面板
\n<br/>
\n### \`presets\` 支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | string | 必选 | 标签
colors | list | 必选 | 颜色列表
expanded | bool | 可选 | 默认是否展开
\n<br/>
\n### 支持的函数：\n
- \`toHexString(color: color): string\` 将 \`color\` 转为16进制字符串\n
- \`toHsvString(color: color): string\` 将 \`color\` 转为hsv/hsva字符串\n
- \`toRgbString(color: color): string\` 将 \`color\` 转为rgb/rgba字符串\n
\n<br/>
\n### 支持的信号：\n
- \`change(color: color)\` 颜色改变时发出\n
  - \`color\` 当前的颜色\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要弹出式的自定义颜色选择的时候使用。\n
                       `)
        }

        ThemeToken {
            source: 'HusColorPicker'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本使用')
            desc: qsTr(`
最简单的用法。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusColorPicker {
                        defaultValue: '#1677ff'
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusColorPicker {
                    defaultValue: '#1677ff'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('禁用透明度')
            desc: qsTr(`
通过 \`alphaEnabled\` 属性设置是否启用透明度。\n
                       `)
            code: `
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
            `
            exampleDelegate: Column {
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
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义文本')
            desc: qsTr(`
通过 \`showText\` 属性设置是否显示触发器文本。\n
通过 \`textFormatter\` 属性设置触发器文本格式化器，它是形如：\`function(color: color): string { }\` 的函数。\n
通过 \`textDelegate\` 属性自定义触发器文本代理。\n
                       `)
            code: `
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
                        textFormatter: color => \`Custom Text (\${String(color).toUpperCase()})\`
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
            `
            exampleDelegate: Column {
                spacing: 10

                HusColorPicker {
                    defaultValue: '#1677ff'
                    showText: true
                }

                HusColorPicker {
                    defaultValue: '#1677ff'
                    showText: true
                    textFormatter: color => `Custom Text (${String(color).toUpperCase()})`
                }

                HusColorPicker {
                    id: customTextPicker
                    defaultValue: '#1677ff'
                    showText: true
                    textDelegate: HusIconText {
                        rightPadding: 2
                        iconSource: customTextPicker.open ? HusIcon.UpOutlined : HusIcon.DownOutlined
                        verticalAlignment: HusIconText.AlignVCenter
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义标题')
            desc: qsTr(`
通过 \`title\` 属性设置是否显示弹出面板的标题。\n
                       `)
            code: `
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
            `
            exampleDelegate: Column {
                spacing: 10

                HusColorPicker {
                    defaultValue: '#1677ff'
                    showText: true
                    title: 'color picker'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('受控模式')
            desc: qsTr(`
通过 \`autoChange\` 属性设置自动更新值。\n
为否时 \`value\` 值为 \`changeValue\`，此时可手动设置 \`changeValue\` 来更新 \`value\`。\n
                       `)
            code: `
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
            `
            exampleDelegate: Column {
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
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('预设颜色')
            desc: qsTr(`
通过 \`presets\` 属性设置预设颜色数组，数组对象支持的属性：\n
- { label: 标签 }\n
- { colors: 颜色列表 }\n
- { expanded: 默认是否展开 }\n
                       `)
            code: `
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
            `
            exampleDelegate: Column {
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
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('预设颜色视图的方向和布局')
            desc: qsTr(`
通过 \`presetsOrientation\` 属性设置预设颜色视图的方向。\n
通过 \`presetsLayoutDirection\` 属性设置预设颜色视图的布局方向。\n
                       `)
            code: `
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
            `
            exampleDelegate: Column {
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
        }
    }
}

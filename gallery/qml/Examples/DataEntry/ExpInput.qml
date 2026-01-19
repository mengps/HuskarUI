import QtQuick
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

        DocDescription {
            desc: qsTr(`
# HusInput 输入框 \n
通过鼠标或键盘输入内容，是最基础的表单域的包装。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { TextField }**\n
* **继承此 { [HusDateTimePicker](internal://HusDateTimePicker), [HusAutoComplete](internal://HusAutoComplete) }**\n
\n<br/>
\n### 支持的代理：\n
- **iconDelegate: Component** 图标代理\n
- **clearIconDelegate: Component** 清除图标代理\n
- **bgDelegate: Component** 背景代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
active | bool | - | 是否处于激活状态
iconSource | int丨string | 0丨'' | 图标源(来自 HusIcon)或图标链接
iconSize | int | - | 图标大小
iconPosition | enum | HusInput.Position_Left | 图标位置(来自 HusInput)
clearEnabled | bool丨'active' | false | 是否启用清除按钮(active-仅当激活状态下可见)
clearIconSource | int丨string | HusIcon.CloseCircleFilled | 清除图标源(来自 HusIcon)或图标链接
clearIconSize | int | - | 清除图标大小
clearIconPosition | enum | HusInput.Position_Right | 清除图标位置(来自 HusInput)
leftIconPadding | int(readonly) | - | 图标在左边时的填充
rightIconPadding | int(readonly) | - | 图标在右边时的填充
leftClearIconPadding | int(readonly) | - | 清除图标在左边时的填充
rightClearIconPadding | int(readonly) | - | 清除图标在右边时的填充
colorIcon | color | - | 图标颜色
colorText | color | - | 文本颜色
colorBorder | color | - | 边框颜色
colorBg | color | - | 背景颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
sizeHint | string | 'normal' | 尺寸提示
contentDescription | string | '' | 内容描述(提高可用性)
\n<br/>
\n### 支持的信号：\n
- \`clickClear()\` 点击清除图标时发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要用户输入表单域内容时。\n
- 提供组合型输入框，带搜索的输入框，还可以进行大小选择。\n
                       `)
        }

        ThemeToken {
            source: 'HusInput'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusInput.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`iconSource\` 属性设置图标源，为 0 则不显示。\n
通过 \`iconSize\` 设置清除图标大小。\n
通过 \`iconPosition\` 属性改变图标位置，支持的位置：\n
- 图标在输入框左边(默认){ HusInput.Position_Left }\n
- 图标在输入框右边{ HusInput.Position_Right }\n
通过 \`clearEnabled\` 设置是否启用清除按钮。\n
通过 \`clearIconSource\` 设置清除图标，为 0 则不显示。\n
通过 \`clearIconSize\` 设置清除图标大小。\n
通过 \`clearIconPosition\` 设置清除图标的位置，支持的位置：\n
- 清除图标在输入框左边(默认){ HusInput.Position_Left }\n
- 清除图标在输入框右边{ HusInput.Position_Right }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusInput {
                        width: 150
                        placeholderText: 'Basic Usage'
                    }

                    HusInput {
                        width: 150
                        placeholderText: 'Clear Active'
                        clearEnabled: 'active'
                    }

                    HusInput {
                        width: 150
                        iconPosition: HusInput.Position_Left
                        iconSource: HusIcon.UserOutlined
                        placeholderText: 'Username'
                    }

                    HusInput {
                        width: 150
                        iconPosition: HusInput.Position_Right
                        iconSource: HusIcon.UserOutlined
                        placeholderText: 'Username'
                    }

                    HusInput {
                        width: 150
                        iconPosition: HusInput.Position_Left
                        iconSource: HusIcon.UserOutlined
                        clearEnabled: true
                        clearIconPosition: HusInput.Position_Left
                        placeholderText: 'Username'
                    }

                    HusInput {
                        width: 150
                        iconPosition: HusInput.Position_Right
                        iconSource: HusIcon.UserOutlined
                        clearEnabled: true
                        clearIconPosition: HusInput.Position_Right
                        placeholderText: 'Username'
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusInput {
                    width: 150
                    placeholderText: 'Basic Usage'
                }

                HusInput {
                    width: 150
                    placeholderText: 'Clear Active'
                    clearEnabled: 'active'
                }

                HusInput {
                    width: 150
                    iconPosition: HusInput.Position_Left
                    iconSource: HusIcon.UserOutlined
                    placeholderText: 'Username'
                }

                HusInput {
                    width: 150
                    iconPosition: HusInput.Position_Right
                    iconSource: HusIcon.UserOutlined
                    placeholderText: 'Username'
                }

                HusInput {
                    width: 150
                    iconPosition: HusInput.Position_Left
                    iconSource: HusIcon.UserOutlined
                    clearEnabled: true
                    clearIconPosition: HusInput.Position_Left
                    placeholderText: 'Username'
                }

                HusInput {
                    width: 150
                    iconPosition: HusInput.Position_Right
                    iconSource: HusIcon.UserOutlined
                    clearEnabled: true
                    clearIconPosition: HusInput.Position_Right
                    placeholderText: 'Username'
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`sizeHint\` 属性设置尺寸。\n
通过 \`echoMode\` 属性实现密码框。\n
                       `)
            code: `
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

                    HusInput {
                        width: 150
                        iconPosition: HusInput.Position_Left
                        iconSource: HusIcon.UserOutlined
                        placeholderText: 'Username'
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }

                    HusInput {
                        id: passwordInput
                        width: 150
                        iconPosition: HusInput.Position_Right
                        iconSource: echoMode === HusInput.Password ? HusIcon.EyeInvisibleOutlined :
                                                                     HusIcon.EyeOutlined
                        iconDelegate: HusIconButton {
                            padding: 0
                            rightPadding: 10 * passwordInput.sizeRatio
                            effectEnabled: false
                            type: HusButton.Type_Link
                            iconSize: passwordInput.iconSize
                            iconSource: passwordInput.iconSource
                            onClicked: {
                                if (passwordInput.echoMode === HusInput.Password) {
                                    passwordInput.echoMode = HusInput.Normal;
                                } else {
                                    passwordInput.echoMode = HusInput.Password;
                                }
                            }
                        }
                        placeholderText: 'Password'
                        sizeHint: sizeHintRadio.currentCheckedValue
                    }
                }
            `
            exampleDelegate: Column {
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

                HusInput {
                    width: 150
                    iconPosition: HusInput.Position_Left
                    iconSource: HusIcon.UserOutlined
                    placeholderText: 'Username'
                    sizeHint: sizeHintRadio.currentCheckedValue
                }

                HusInput {
                    id: passwordInput
                    width: 150
                    iconPosition: HusInput.Position_Right
                    iconSource: echoMode === HusInput.Password ? HusIcon.EyeInvisibleOutlined :
                                                                 HusIcon.EyeOutlined
                    iconDelegate: HusIconButton {
                        padding: 0
                        rightPadding: 10 * passwordInput.sizeRatio
                        effectEnabled: false
                        type: HusButton.Type_Link
                        iconSize: passwordInput.iconSize
                        iconSource: passwordInput.iconSource
                        onClicked: {
                            if (passwordInput.echoMode === HusInput.Password) {
                                passwordInput.echoMode = HusInput.Normal;
                            } else {
                                passwordInput.echoMode = HusInput.Password;
                            }
                        }
                    }
                    placeholderText: 'Password'
                    sizeHint: sizeHintRadio.currentCheckedValue
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
组合其他组件。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    HusInput {
                        id: input
                        width: 250
                        text: 'Combine input and button'
                        radiusBg.topRight: 0
                        radiusBg.bottomRight: 0
                    }

                    HusButton {
                        type: HusButton.Type_Primary
                        text: 'Submit'
                        radiusBg.all: input.radiusBg.all
                        radiusBg.topLeft: 0
                        radiusBg.bottomLeft: 0
                    }
                }
            `
            exampleDelegate: Row {
                HusInput {
                    id: input
                    width: 250
                    text: 'Combine input and button'
                    radiusBg.topRight: 0
                    radiusBg.bottomRight: 0
                }

                HusButton {
                    type: HusButton.Type_Primary
                    text: 'Submit'
                    radiusBg.all: input.radiusBg.all
                    radiusBg.topLeft: 0
                    radiusBg.bottomLeft: 0
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    HusScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        DocDescription {
            desc: qsTr(`
# HusGroupBox 分组框 \n
在一个有标题的视觉框架内将一组逻辑控件布局在一起。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { GroupBox }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
borderWidth | real | 1 | 边框线宽
colorTitle | color | - | 标题颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
sizeHint | string | 'normal' | 尺寸提示
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在用户把一个有标题的视觉框架内将一组逻辑控件布局在一起时使用。\n
                       `)
        }

        ThemeToken {
            source: ''
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusGroupBox.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最简单的用法。\n
                       `)
            code: `
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
            `
            exampleDelegate: Column {
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
        }


        CodeBox {
            width: parent.width
            desc: qsTr(`
自定义 \`label\`。
                       `)
            code: `
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
            `
            exampleDelegate: Column {
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
        }
    }
}

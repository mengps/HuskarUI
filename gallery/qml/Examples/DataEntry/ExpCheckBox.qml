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

        DocDescription {
            desc: qsTr(`
# HusCheckBox 多选框 \n
收集用户的多项选择。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { CheckBox }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
indicatorSize | int | 18 | 指示器大小
colorText | color | - | 文本颜色
colorIndicator | color | - | 指示器颜色
colorIndicatorBorder | color | - | 指示器边框颜色
radiusIndicator | [HusRadius](internal://HusRadius) | - | 指示器圆角
contentDescription | string | '' | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 在一组可选项中进行多项选择时。\n
- 单独使用可以表示两种状态之间的切换，和 [HusSwitch](internal://HusSwitch) 类似。\n
  区别在于切换 [HusSwitch](internal://HusSwitch) 会直接触发状态改变，而 HusCheckBox 一般用于状态标记，需要和提交操作配合。\n
                       `)
        }

        ThemeToken {
            source: 'HusCheckBox'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusCheckBox.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
最简单的用法。\n
通过 \`enabled\` 设置是否启用。\n
                       `)
            code: `
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
            `
            exampleDelegate: Column {
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
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用 \`ButtonGroup(QtQuick原生组件)\` 来实现全选效果，具体可参考 \`CheckBox\` 文档。\n
                       `)
            code: `
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
            `
            exampleDelegate: Column {
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
        }
    }
}

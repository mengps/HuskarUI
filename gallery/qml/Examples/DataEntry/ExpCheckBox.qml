import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelCheckBox 多选框 \n
收集用户的多项选择。\n
* **继承自 { CheckButton }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
effectEnabled | bool | 是否开启点击效果(默认true)
indicatorSize | int | 指示器大小
colorText | color | 文本颜色
colorIndicator | color | 指示器颜色
colorIndicatorBorder | color | 指示器边框颜色
contentDescription | string | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 在一组可选项中进行多项选择时。\n
- 单独使用可以表示两种状态之间的切换，和 [DelSwitch](internal://DelSwitch) 类似。区别在于切换 [DelSwitch](internal://DelSwitch) 会直接触发状态改变，而 DelCheckBox 一般用于状态标记，需要和提交操作配合。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
最简单的用法。\n
通过 \`enabled\` 设置是否启用。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelCheckBox {
                        text: qsTr("Checkbox")
                    }

                    DelCheckBox {
                        text: qsTr("Disabled")
                        enabled: false
                    }

                    DelCheckBox {
                        text: qsTr("Disabled")
                        checkState: Qt.PartiallyChecked
                        enabled: false
                    }

                    DelCheckBox {
                        text: qsTr("Disabled")
                        checkState: Qt.Checked
                        enabled: false
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelCheckBox {
                    text: qsTr("Checkbox")
                }

                DelCheckBox {
                    text: qsTr("Disabled")
                    enabled: false
                }

                DelCheckBox {
                    text: qsTr("Disabled")
                    checkState: Qt.PartiallyChecked
                    enabled: false
                }

                DelCheckBox {
                    text: qsTr("Disabled")
                    checkState: Qt.Checked
                    enabled: false
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
                import DelegateUI

                Column {
                    spacing: 10

                    ButtonGroup {
                        id: childGroup
                        exclusive: false
                        checkState: parentBox.checkState
                    }

                    DelCheckBox {
                        id: parentBox
                        text: qsTr("Parent")
                        checkState: childGroup.checkState
                    }

                    DelCheckBox {
                        checked: true
                        text: qsTr("Child 1")
                        leftPadding: indicator.width
                        ButtonGroup.group: childGroup
                    }

                    DelCheckBox {
                        text: qsTr("Child 2")
                        leftPadding: indicator.width
                        ButtonGroup.group: childGroup
                    }

                    DelCheckBox {
                        text: qsTr("More...")
                        leftPadding: indicator.width
                        ButtonGroup.group: childGroup

                        DelInput {
                            width: 110
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            visible: parent.checked
                            placeholderText: qsTr("Please input")
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

                DelCheckBox {
                    id: parentBox
                    text: qsTr("Parent")
                    checkState: childGroup.checkState
                }

                DelCheckBox {
                    checked: true
                    text: qsTr("Child 1")
                    leftPadding: indicator.width
                    ButtonGroup.group: childGroup
                }

                DelCheckBox {
                    text: qsTr("Child 2")
                    leftPadding: indicator.width
                    ButtonGroup.group: childGroup
                }

                DelCheckBox {
                    text: qsTr("More...")
                    leftPadding: indicator.width
                    ButtonGroup.group: childGroup

                    DelInput {
                        width: 110
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        visible: parent.checked
                        placeholderText: qsTr("Please input")
                    }
                }
            }
        }
    }
}

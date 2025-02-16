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
## DelRadio 单选框 \n
用于在多个备选项中选中单个状态。\n
* **继承自 { RadioButton }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
effectEnabled | bool | 是否开启点击效果(默认true)
colorText | color | 文本颜色
colorIndicator | color | 指示器颜色
colorIndicatorBorder | color | 指示器边框颜色
radiusIndicator | int | 指示器半径
contentDescription | string | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 用于在多个备选项中选中单个状态。\n
- 和 [DelSelect](internal://DelSelect) 的区别是，DelRadio 所有选项默认可见，方便用户在比较中选择，因此选项不宜过多。\n
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

                    DelRadio {
                        text: qsTr("Radio")
                    }

                    DelRadio {
                        text: qsTr("Disabled")
                        enabled: false
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelRadio {
                    text: qsTr("Radio")
                }

                DelRadio {
                    text: qsTr("Disabled")
                    enabled: false
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用 \`ButtonGroup(QtQuick原生组件)\` 来实现一组互斥的 DelRadio 配合使用。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Controls.Basic
                import DelegateUI

                Row {
                    height: 50
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    spacing: 10

                    ButtonGroup { id: radioGroup }

                    DelRadio {
                        text: qsTr("LineChart")
                        ButtonGroup.group: radioGroup

                        DelIconText {
                            anchors.bottom: parent.top
                            anchors.bottomMargin: 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            iconSize: 24
                            iconSource: DelIcon.LineChartOutlined
                        }
                    }

                    DelRadio {
                        text: qsTr("DotChart")
                        ButtonGroup.group: radioGroup

                        DelIconText {
                            anchors.bottom: parent.top
                            anchors.bottomMargin: 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            iconSize: 24
                            iconSource: DelIcon.DotChartOutlined
                        }
                    }

                    DelRadio {
                        text: qsTr("BarChart")
                        ButtonGroup.group: radioGroup

                        DelIconText {
                            anchors.bottom: parent.top
                            anchors.bottomMargin: 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            iconSize: 24
                            iconSource: DelIcon.BarChartOutlined
                        }
                    }

                    DelRadio {
                        text: qsTr("PieChart")
                        ButtonGroup.group: radioGroup

                        DelIconText {
                            anchors.bottom: parent.top
                            anchors.bottomMargin: 2
                            anchors.horizontalCenter: parent.horizontalCenter
                            iconSize: 24
                            iconSource: DelIcon.PieChartOutlined
                        }
                    }
                }
            `
            exampleDelegate: Row {
                height: 50
                anchors.top: parent.top
                anchors.topMargin: 20
                spacing: 10

                ButtonGroup { id: radioGroup }

                DelRadio {
                    text: qsTr("LineChart")
                    ButtonGroup.group: radioGroup

                    DelIconText {
                        anchors.bottom: parent.top
                        anchors.bottomMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        iconSize: 24
                        iconSource: DelIcon.LineChartOutlined
                    }
                }

                DelRadio {
                    text: qsTr("DotChart")
                    ButtonGroup.group: radioGroup

                    DelIconText {
                        anchors.bottom: parent.top
                        anchors.bottomMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        iconSize: 24
                        iconSource: DelIcon.DotChartOutlined
                    }
                }

                DelRadio {
                    text: qsTr("BarChart")
                    ButtonGroup.group: radioGroup

                    DelIconText {
                        anchors.bottom: parent.top
                        anchors.bottomMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        iconSize: 24
                        iconSource: DelIcon.BarChartOutlined
                    }
                }

                DelRadio {
                    text: qsTr("PieChart")
                    ButtonGroup.group: radioGroup

                    DelIconText {
                        anchors.bottom: parent.top
                        anchors.bottomMargin: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        iconSize: 24
                        iconSource: DelIcon.PieChartOutlined
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
垂直的 DelRadio，配合更多输入框选项。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Controls.Basic
                import DelegateUI

                Column {
                    spacing: 10

                    ButtonGroup { id: radioGroup2 }

                    DelRadio {
                        text: qsTr("Option A")
                        ButtonGroup.group: radioGroup2
                    }

                    DelRadio {
                        text: qsTr("Option B")
                        ButtonGroup.group: radioGroup2
                    }

                    DelRadio {
                        text: qsTr("Option C")
                        ButtonGroup.group: radioGroup2
                    }

                    DelRadio {
                        text: qsTr("More...")
                        ButtonGroup.group: radioGroup2

                        DelInput {
                            visible: parent.checked
                            placeholderText: qsTr("Please input")
                            width: 110
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                ButtonGroup { id: radioGroup2 }

                DelRadio {
                    text: qsTr("Option A")
                    ButtonGroup.group: radioGroup2
                }

                DelRadio {
                    text: qsTr("Option B")
                    ButtonGroup.group: radioGroup2
                }

                DelRadio {
                    text: qsTr("Option C")
                    ButtonGroup.group: radioGroup2
                }

                DelRadio {
                    text: qsTr("More...")
                    ButtonGroup.group: radioGroup2

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

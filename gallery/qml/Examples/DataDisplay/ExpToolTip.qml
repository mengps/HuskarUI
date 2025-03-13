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
## DelToolTip 文字提示 \n
单的文字提示气泡框。\n
* **继承自 { ToolTip }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
arrowVisible | bool | 是否显示箭头(默认false)
position | int | 文字提示的位置(来自 DelToolTip)
colorText | color | 文本颜色
colorBg | color | 背景颜色
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
鼠标移入则显示提示，移出消失，气泡浮层不承载复杂文本和操作。\n
可用来代替系统默认的 \`title\` 提示，提供一个 \`按钮/文字/操作\` 的文案解释。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`arrowVisible\` 属性设置是否显示箭头 \n
通过 \`position\` 属性设置文字提示的位置，支持的位置：\n
- 文字提示在项目上方(默认){ DelToolTip.Position_Top }\n
- 文字提示在项目下方{ DelToolTip.Position_Bottom }\n
- 文字提示在项目左方{ DelToolTip.Position_Left }\n
- 文字提示在项目右方{ DelToolTip.Position_Right }\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    GridLayout {
                        width: 400
                        rows: 3
                        columns: 3

                        DelButton {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.columnSpan: 3
                            text: qsTr("上方")

                            DelToolTip {
                                visible: parent.hovered
                                arrowVisible: true
                                text: qsTr("上方文字提示")
                            }
                        }

                        DelButton {
                            Layout.alignment: Qt.AlignLeft
                            text: qsTr("左方")

                            DelToolTip {
                                visible: parent.hovered
                                arrowVisible: true
                                text: qsTr("左方文字提示")
                                position: DelToolTip.Position_Left
                            }
                        }

                        DelButton {
                            Layout.alignment: Qt.AlignCenter
                            text: qsTr("箭头中心")

                            DelToolTip {
                                x: 0
                                visible: parent.hovered
                                arrowVisible: true
                                text: qsTr("箭头中心会自动指向 parent 的中心")
                                position: DelToolTip.Position_Top
                            }
                        }
                        DelButton {
                            Layout.alignment: Qt.AlignRight
                            text: qsTr("右方")

                            DelToolTip {
                                visible: parent.hovered
                                arrowVisible: true
                                text: qsTr("右方文字提示")
                                position: DelToolTip.Position_Right
                            }
                        }

                        DelButton {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.columnSpan: 3
                            text: qsTr("下方")

                            DelToolTip {
                                visible: parent.hovered
                                arrowVisible: true
                                text: qsTr("下方文字提示")
                                position: DelToolTip.Position_Bottom
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                GridLayout {
                    width: 400
                    rows: 3
                    columns: 3

                    DelButton {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.columnSpan: 3
                        text: qsTr("上方")

                        DelToolTip {
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr("上方文字提示")
                        }
                    }

                    DelButton {
                        Layout.alignment: Qt.AlignLeft
                        text: qsTr("左方")

                        DelToolTip {
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr("左方文字提示")
                            position: DelToolTip.Position_Left
                        }
                    }

                    DelButton {
                        Layout.alignment: Qt.AlignCenter
                        text: qsTr("箭头中心")

                        DelToolTip {
                            x: 0
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr("箭头中心会自动指向 parent 的中心")
                            position: DelToolTip.Position_Top
                        }
                    }
                    DelButton {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("右方")

                        DelToolTip {
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr("右方文字提示")
                            position: DelToolTip.Position_Right
                        }
                    }

                    DelButton {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.columnSpan: 3
                        text: qsTr("下方")

                        DelToolTip {
                            visible: parent.hovered
                            arrowVisible: true
                            text: qsTr("下方文字提示")
                            position: DelToolTip.Position_Bottom
                        }
                    }
                }
            }
        }
    }
}

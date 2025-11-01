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
# HusToolTip 文字提示 \n
单的文字提示气泡框。\n
* **继承自 { ToolTip }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
showArrow | bool | false | 是否显示箭头
position | enum | HusToolTip.Position_Top | 文字提示的位置(来自 HusToolTip)
colorText | color | - | 文本颜色
colorBg | color | - | 背景颜色
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
鼠标移入则显示提示，移出消失，气泡浮层不承载复杂文本和操作。\n
可用来代替系统默认的 \`title\` 提示，提供一个 \`按钮/文字/操作\` 的文案解释。\n
                       `)
        }

        ThemeToken {
            source: 'HusToolTip'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`showArrow\` 属性设置是否显示箭头 \n
通过 \`position\` 属性设置文字提示的位置，支持的位置：\n
- 文字提示在项目上方(默认){ HusToolTip.Position_Top }\n
- 文字提示在项目下方{ HusToolTip.Position_Bottom }\n
- 文字提示在项目左方{ HusToolTip.Position_Left }\n
- 文字提示在项目右方{ HusToolTip.Position_Right }\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    GridLayout {
                        width: 400
                        rows: 3
                        columns: 3

                        HusButton {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.columnSpan: 3
                            text: qsTr('上方')

                            HusToolTip {
                                visible: parent.hovered
                                showArrow: true
                                text: qsTr('上方文字提示')
                            }
                        }

                        HusButton {
                            Layout.alignment: Qt.AlignLeft
                            text: qsTr('左方')

                            HusToolTip {
                                visible: parent.hovered
                                showArrow: true
                                text: qsTr('左方文字提示')
                                position: HusToolTip.Position_Left
                            }
                        }

                        HusButton {
                            Layout.alignment: Qt.AlignCenter
                            text: qsTr('箭头中心')

                            HusToolTip {
                                x: 0
                                visible: parent.hovered
                                showArrow: true
                                text: qsTr('箭头中心会自动指向 parent 的中心')
                                position: HusToolTip.Position_Top
                            }
                        }

                        HusButton {
                            Layout.alignment: Qt.AlignRight
                            text: qsTr('右方')

                            HusToolTip {
                                visible: parent.hovered
                                showArrow: true
                                text: qsTr('右方文字提示')
                                position: HusToolTip.Position_Right
                            }
                        }

                        HusButton {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.columnSpan: 3
                            text: qsTr('下方')

                            HusToolTip {
                                visible: parent.hovered
                                showArrow: true
                                text: qsTr('下方文字提示')
                                position: HusToolTip.Position_Bottom
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

                    HusButton {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.columnSpan: 3
                        text: qsTr('上方')

                        HusToolTip {
                            visible: parent.hovered
                            showArrow: true
                            text: qsTr('上方文字提示')
                        }
                    }

                    HusButton {
                        Layout.alignment: Qt.AlignLeft
                        text: qsTr('左方')

                        HusToolTip {
                            visible: parent.hovered
                            showArrow: true
                            text: qsTr('左方文字提示')
                            position: HusToolTip.Position_Left
                        }
                    }

                    HusButton {
                        Layout.alignment: Qt.AlignCenter
                        text: qsTr('箭头中心')

                        HusToolTip {
                            x: 0
                            visible: parent.hovered
                            showArrow: true
                            text: qsTr('箭头中心会自动指向 parent 的中心')
                            position: HusToolTip.Position_Top
                        }
                    }

                    HusButton {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr('右方')

                        HusToolTip {
                            visible: parent.hovered
                            showArrow: true
                            text: qsTr('右方文字提示')
                            position: HusToolTip.Position_Right
                        }
                    }

                    HusButton {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.columnSpan: 3
                        text: qsTr('下方')

                        HusToolTip {
                            visible: parent.hovered
                            showArrow: true
                            text: qsTr('下方文字提示')
                            position: HusToolTip.Position_Bottom
                        }
                    }
                }
            }
        }
    }
}

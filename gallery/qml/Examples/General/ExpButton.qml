import QtQuick
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
## DelButton 按钮\n
按钮用于开始一个即时操作。\n
* **继承自 { Button }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
effectEnabled | bool | 是否开启点击效果(默认true)
type | int | 按钮类型(来自 DelButton)
shape | int | 按钮形状(来自 DelButton)
radiusBg | int | 背景半径
colorText | color | 文本颜色
colorBg | color | 背景颜色
colorBorder | color | 边框颜色
contentDescription | string | 内容描述(提高可用性)
                       `)
        }

        Text {
            width: parent.width - 20
            height: implicitHeight - 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("代码演示")
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySizeHeading3
            }
            color: DelTheme.Primary.colorTextBase
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`type\` 属性改变按钮类型，支持的类型：\n
- 默认按钮{ DelButton.Type_Default }\n
- 线框按钮{ DelButton.Type_Outlined }\n
- 主要按钮{ DelButton.Type_Primary }\n
- 填充按钮{ DelButton.Type_Filled }\n
- 文本按钮{ DelButton.Type_Text }
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelButton {
                        text: qsTr("默认")
                    }

                    DelButton {
                        text: qsTr("线框")
                        type: DelButton.Type_Outlined
                    }

                    DelButton {
                        text: qsTr("主要")
                        type: DelButton.Type_Primary
                    }

                    DelButton {
                        text: qsTr("填充")
                        type: DelButton.Type_Filled
                    }

                    DelButton {
                        text: qsTr("文本")
                        type: DelButton.Type_Text
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelButton {
                    text: qsTr("默认")
                }

                DelButton {
                    text: qsTr("线框")
                    type: DelButton.Type_Outlined
                }

                DelButton {
                    text: qsTr("主要")
                    type: DelButton.Type_Primary
                }

                DelButton {
                    text: qsTr("填充")
                    type: DelButton.Type_Filled
                }

                DelButton {
                    text: qsTr("文本")
                    type: DelButton.Type_Text
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`enabled\` 属性启用或禁用按钮，禁用的按钮不会响应任何交互。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelButton {
                        text: qsTr("默认")
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("线框")
                        type: DelButton.Type_Outlined
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("主要")
                        type: DelButton.Type_Primary
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("填充")
                        type: DelButton.Type_Filled
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("文本")
                        type: DelButton.Type_Text
                        enabled: false
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelButton {
                    text: qsTr("默认")
                    enabled: false
                }

                DelButton {
                    text: qsTr("线框")
                    type: DelButton.Type_Outlined
                    enabled: false
                }

                DelButton {
                    text: qsTr("主要")
                    type: DelButton.Type_Primary
                    enabled: false
                }

                DelButton {
                    text: qsTr("填充")
                    type: DelButton.Type_Filled
                    enabled: false
                }

                DelButton {
                    text: qsTr("文本")
                    type: DelButton.Type_Text
                    enabled: false
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`shape\` 属性改变按钮形状，支持的形状：\n
- 默认形状{ DelButton.Shape_Default }\n
- 圆形{ DelButton.Shape_Circle }
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelButton {
                        text: qsTr("A")
                        shape: DelButton.Shape_Circle
                    }

                    DelButton {
                        text: qsTr("A")
                        type: DelButton.Type_Outlined
                        shape: DelButton.Shape_Circle
                    }

                    DelButton {
                        text: qsTr("A")
                        type: DelButton.Type_Primary
                        shape: DelButton.Shape_Circle
                    }

                    DelButton {
                        text: qsTr("A")
                        type: DelButton.Type_Filled
                        shape: DelButton.Shape_Circle
                    }

                    DelButton {
                        text: qsTr("A")
                        type: DelButton.Type_Text
                        shape: DelButton.Shape_Circle
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelButton {
                    text: qsTr("A")
                    shape: DelButton.Shape_Circle
                }

                DelButton {
                    text: qsTr("A")
                    type: DelButton.Type_Outlined
                    shape: DelButton.Shape_Circle
                }

                DelButton {
                    text: qsTr("A")
                    type: DelButton.Type_Primary
                    shape: DelButton.Shape_Circle
                }

                DelButton {
                    text: qsTr("A")
                    type: DelButton.Type_Filled
                    shape: DelButton.Shape_Circle
                }

                DelButton {
                    text: qsTr("A")
                    type: DelButton.Type_Text
                    shape: DelButton.Shape_Circle
                }
            }
        }
    }
}

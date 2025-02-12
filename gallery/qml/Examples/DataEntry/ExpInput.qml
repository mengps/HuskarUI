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
## DelInput 输入框 \n
通过鼠标或键盘输入内容，是最基础的表单域的包装。\n
* **继承自 { TextField }**\n
支持的代理：\n
- **iconDelegate: Component** 图标代理\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
active(readonly) | bool | 是否处于激活状态
iconSource | int | 图标源(来自 DelIcon)
iconSize | int | 图标大小
iconPosition | int | 图标位置(来自 DelInput)
colorIcon | color | 图标颜色
colorText | color | 文本颜色
colorBorder | color | 边框颜色
colorBg | color | 背景颜色
radiusBg | int | 背景半径
contentDescription | string | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 需要用户输入表单域内容时。\n
- 提供组合型输入框，带搜索的输入框，还可以进行大小选择。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`iconSource\` 属性设置图标源\n
通过 \`iconPosition\` 属性改变图标位置，支持的位置：\n
- 图标在输入框左边(默认){ DelInput.Position_Left }\n
- 图标在输入框右边{ DelInput.Position_Right }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelInput {
                        width: 120
                        placeholderText: qsTr("Basic usage")
                    }

                    DelInput {
                        width: 120
                        iconPosition: DelInput.Position_Left
                        iconSource: DelIcon.UserOutlined
                        placeholderText: qsTr("Username")
                    }

                    DelInput {
                        width: 120
                        iconPosition: DelInput.Position_Right
                        iconSource: DelIcon.UserOutlined
                        placeholderText: qsTr("Username")
                    }
                }

            `
            exampleDelegate: Row {
                spacing: 10

                DelInput {
                    width: 120
                    placeholderText: qsTr("Basic usage")
                }

                DelInput {
                    width: 120
                    iconPosition: DelInput.Position_Left
                    iconSource: DelIcon.UserOutlined
                    placeholderText: qsTr("Username")
                }

                DelInput {
                    width: 120
                    iconPosition: DelInput.Position_Right
                    iconSource: DelIcon.UserOutlined
                    placeholderText: qsTr("Username")
                }
            }
        }
    }
}

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
## DelOTPInput 一次性口令输入框 \n
用于接收和验证一次性口令的输入框组合，通常用于验证码或密码。\n
* **继承自 { Item }**\n
支持的代理：\n
 - **dividerDelegate: Component** 分隔器代理\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
length | int | 口令长度(即输入项数)
characterLength | int | 输入项的字符长度
currentIndex | int | 当前输入项索引
currentInput | int | 当前所有项输入文本和
itemWidth | int | 输入项宽度
itemHeight | int | 输入项高度
itemSpacing | int | 输入项间隔
itemValidator | Validator | 输入项的验证器
itemInputMethodHints | int | 输入项的输入法提示(例如: Qt.ImhHiddenText)
itemPassword | bool | 输入项是否为密码(显示为: itemPasswordCharacter)
itemPasswordCharacter | string | 输入项的密码字符(itemPassword为true时启用)
formatter | Function | 格式化器(将为每一项调用)
colorItemText | color | 输入项文本颜色
colorItemBorder | color | 输入项边框颜色
colorItemBorderActive | color | 输入项边框激活时颜色
colorItemBg | color | 输入项背景颜色
radiusBg | int | 输入项背景半径
\n支持的函数：\n
- \`getInput()\` 获取所有项输入文本和\n
支持的信号：\n
- \`finished(input: string)\` 最后一个项输入完成时发出\n
  - \`input\` 所有项输入文本和\n
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
通过 \`length\` 属性设置输入元素数量\n
通过 \`enabled\` 属性设置是否启用\n
通过 \`itemValidator\` 属性设置验证器\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelOTPInput {
                        length: 6
                    }

                    DelOTPInput {
                        length: 6
                        enabled: false
                    }

                    DelOTPInput {
                        length: 6
                        itemValidator: RegularExpressionValidator { regularExpression: /[a-zA-Z]?/ }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelOTPInput {
                    length: 6
                }

                DelOTPInput {
                    length: 6
                    enabled: false
                }

                DelOTPInput {
                    length: 6
                    itemValidator: RegularExpressionValidator { regularExpression: /[a-zA-Z]?/ }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`formatter\` 属性设置输入项的格式化器\n
格式化器是形如：\`function(text: string): string { }\` 的函数\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelOTPInput {
                        length: 6
                        itemValidator: RegularExpressionValidator { regularExpression: /[a-zA-Z]?/ }
                        formatter: (text) => text.toUpperCase();
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelOTPInput {
                    length: 6
                    itemValidator: RegularExpressionValidator { regularExpression: /[a-zA-Z]?/ }
                    formatter: (text) => text.toUpperCase();
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`itemPassword\` 属性设置输入项是否为密码\n
通过 \`itemPasswordCharacter\` 属性设置密码字符\n
通过 \`currentInput\` 属性获取当前所有项输入文本和\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelOTPInput {
                        id: password
                        length: 6
                        itemPassword: true
                        itemPasswordCharacter: "●"
                        itemValidator: RegularExpressionValidator { regularExpression: /[0-9a-zA-Z]?/ }
                    }

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("当前输入: ") + password.currentInput
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelOTPInput {
                    id: password
                    length: 6
                    itemPassword: true
                    itemPasswordCharacter: "●"
                    itemValidator: RegularExpressionValidator { regularExpression: /[0-9a-zA-Z]?/ }
                }

                DelCopyableText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("当前输入: ") + password.currentInput
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`characterLength\` 属性设置输入项的字符长度，通常用于激活码\n
通过 \`dividerDelegate\` 属性设置分隔器代理(用于分隔输入项)\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelOTPInput {
                        id: activationCodeInput
                        length: 4
                        characterLength: 4
                        itemWidth: 80
                        itemSpacing: 5
                        itemValidator: RegularExpressionValidator { regularExpression: /[0-9a-zA-Z]{1,4}/ }
                        formatter: (text) => text.toUpperCase();
                        dividerDelegate: Item {
                            width: 12
                            height: activationCodeInput.itemHeight

                            Rectangle {
                                width: 12
                                height: 1
                                color: DelTheme.Primary.colorTextBase
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("当前输入: ") + activationCodeInput.currentInput
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelOTPInput {
                    id: activationCodeInput
                    length: 4
                    characterLength: 4
                    itemWidth: 80
                    itemSpacing: 5
                    itemValidator: RegularExpressionValidator { regularExpression: /[0-9a-zA-Z]{1,4}/ }
                    formatter: (text) => text.toUpperCase();
                    dividerDelegate: Item {
                        width: 12
                        height: activationCodeInput.itemHeight

                        Rectangle {
                            width: 12
                            height: 1
                            color: DelTheme.Primary.colorTextBase
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                DelCopyableText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("当前输入: ") + activationCodeInput.currentInput
                }
            }
        }
    }
}

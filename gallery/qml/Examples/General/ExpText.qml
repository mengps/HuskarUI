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
## DelCopyableText 可复制文本\n
提供统一字体和颜色的文本(替代Text)。\n
* **继承自 { Text }**\n
支持的代理：\n
- 无\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
需要统一字体和颜色的文本时建议使用。
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Text\`
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelText {
                        text: qsTr("DelText文本")
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelText {
                    text: qsTr("DelText文本")
                }
            }
        }
    }
}

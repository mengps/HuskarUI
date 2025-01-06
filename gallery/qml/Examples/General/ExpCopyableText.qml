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
在需要可复制的文本时使用(替代Text)。\n
* **继承自 { TextEdit }**\n
支持的代理：\n
- 无\n
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
使用方法等同于 \`TextEdit\`
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelCopyableText {
                        text: qsTr("可以复制我")
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelCopyableText {
                    text: qsTr("可以复制我")
                }
            }
        }
    }
}

import QtQuick
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
# HusCopyableText 可复制文本\n
在需要可复制的文本时使用(替代Text)。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { TextEdit }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
Qml中普通文本(Text)无法复制，因此在需要可复制的文本时建议使用。
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusCopyableText.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`TextEdit\`
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 15

                    HusCopyableText {
                        text: qsTr('可以复制我')
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                HusCopyableText {
                    text: qsTr('可以复制我')
                }
            }
        }
    }
}

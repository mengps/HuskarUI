import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width
        spacing: 30

        Description {
            desc: qsTr(`
## DelCaptionButton 标题按钮\n
一般用于窗口标题栏的按钮。\n
* **继承自 { DelIconButton }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
isError | bool | 是否为警示按钮
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
通过 \`isError\` 属性设置为警示按钮，例如关闭按钮。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelCaptionButton {
                        iconSource: DelIcon.CloseOutlined
                    }

                    DelCaptionButton {
                        isError: true
                        iconSource: DelIcon.CloseOutlined
                    }

                    DelCaptionButton {
                        text: qsTr("关闭")
                        colorText: colorIcon
                        iconSource: DelIcon.CloseOutlined
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelCaptionButton {
                    iconSource: DelIcon.CloseOutlined
                }

                DelCaptionButton {
                    isError: true
                    iconSource: DelIcon.CloseOutlined
                }

                DelCaptionButton {
                    text: qsTr("关闭")
                    colorText: colorIcon
                    iconSource: DelIcon.CloseOutlined
                }
            }
        }
    }
}

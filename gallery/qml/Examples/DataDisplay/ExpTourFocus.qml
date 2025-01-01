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
## DelTourFocus 漫游焦点\n
聚焦于某个功能的焦点。\n
* **继承自 { Popup }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
target | Item | 焦点目标
overlayColor | color | 覆盖层颜色
focusMargin | int | 焦点边距
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
通过 \`target\` 属性设置焦点目标\n
通过 \`overlayColor\` 属性设置覆盖层颜色\n
通过 \`focusMargin\` 属性设置焦点边距\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelButton {
                        text: qsTr("漫游焦点")
                        type: DelButtonType.Type_Primary
                        onClicked: {
                            tourFocus.open();
                        }

                        DelTourFocus {
                            id: tourFocus
                            target: tourFocus1
                        }
                    }

                    Row {
                        spacing: 10

                        DelButton {
                            id: tourFocus1
                            text: qsTr("漫游焦点1")
                            type: DelButtonType.Type_Outlined
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelButton {
                    text: qsTr("漫游焦点")
                    type: DelButtonType.Type_Primary
                    onClicked: {
                        tourFocus.open();
                    }

                    DelTourFocus {
                        id: tourFocus
                        target: tourFocus1
                    }
                }

                Row {
                    spacing: 10

                    DelButton {
                        id: tourFocus1
                        text: qsTr("漫游焦点1")
                        type: DelButtonType.Type_Outlined
                    }
                }
            }
        }
    }
}

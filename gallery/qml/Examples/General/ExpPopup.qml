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
            id: description
            desc: qsTr(`
## DelPopup 弹窗\n
自带跟随主题切换的背景和阴影, 用来替代内置 Popup。\n
* **继承自 { Popup }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
movable | bool | 是否可移动(默认false)
resizable | bool | 是否可改变大小(默认false)
minimumX | real | 可移动的最小X坐标(movable为true生效)
maximumX | real | 可移动的最大X坐标(movable为true生效)
minimumY | real | 可移动的最小Y坐标(movable为true生效)
maximumY | real | 可移动的最大Y坐标(movable为true生效)
minimumWidth | real | 可改变的最小宽度(resizable为true生效)
maximumWidth | real | 可改变的最小宽度(resizable为true生效)
minimumHeight | real | 可改变的最小高度(resizable为true生效)
maximumHeight | real | 可改变的最小高度(resizable为true生效)
colorShadow | color | 阴影颜色
colorBg | color | 背景颜色
radiusBg | real | 背景圆角半径
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
需要一个弹出式窗口时使用。
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Popup\` \n
通过 \`movable\` 设置为可移动 \n
通过 \`resizable\` 设置为可改变大小 \n
                       `)
            code: `
                import QtQuick
                import QtQuick.Controls.Basic
                import DelegateUI

                Item {
                    height: 50

                    DelButton {
                        text: (popup.opened ? qsTr("隐藏") : qsTr("显示"))
                        type: DelButton.Type_Primary
                        onClicked: {
                            if (popup.opened)
                                popup.close();
                            else
                                popup.open();
                        }
                    }

                    DelPopup {
                        id: popup
                        x: (parent.width - width) * 0.5
                        y: (parent.height - height) * 0.5
                        width: 400
                        height: 300
                        parent: Overlay.overlay
                        closePolicy: DelPopup.NoAutoClose
                        movable: true
                        resizable: true
                        minimumX: 0
                        maximumX: parent.width - width
                        minimumY: 0
                        maximumY: parent.height - height
                        minimumWidth: 400
                        minimumHeight: 300
                        contentItem: Item {
                            DelCaptionButton {
                                anchors.right: parent.right
                                radiusBg: popup.radiusBg * 0.5
                                colorText: colorIcon
                                iconSource: DelIcon.CloseOutlined
                                onClicked: popup.close();
                            }
                        }
                    }
                }
            `
            exampleDelegate: Item {
                height: 50

                DelButton {
                    text: (popup.opened ? qsTr("隐藏") : qsTr("显示"))
                    type: DelButton.Type_Primary
                    onClicked: {
                        if (popup.opened)
                            popup.close();
                        else
                            popup.open();
                    }
                }

                DelPopup {
                    id: popup
                    x: (parent.width - width) * 0.5
                    y: (parent.height - height) * 0.5
                    width: 400
                    height: 300
                    parent: Overlay.overlay
                    closePolicy: DelPopup.NoAutoClose
                    movable: true
                    resizable: true
                    minimumX: 0
                    maximumX: parent.width - width
                    minimumY: 0
                    maximumY: parent.height - height
                    minimumWidth: 400
                    minimumHeight: 300
                    contentItem: Item {
                        DelCaptionButton {
                            anchors.right: parent.right
                            radiusBg: popup.radiusBg * 0.5
                            colorText: colorIcon
                            iconSource: DelIcon.CloseOutlined
                            onClicked: popup.close();
                        }
                    }
                }
            }
        }
    }
}

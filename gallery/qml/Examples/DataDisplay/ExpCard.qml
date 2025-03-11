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
## DelCard 卡片 \n
通用卡片容器。\n
* **继承自 { Rectangle }**\n
支持的代理：\n
- **titleDelegate: Component** 卡片标题代理\n
- **extraDelegate: Component** 卡片右上角操作代理\n
- **coverDelegate: Component** 卡片封面代理\n
- **bodyDeleagte: Component** 卡片主体代理\n
- **actionDeleagte: Component** 卡片动作代理\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
title | string | 标题文本
titleFont | font | 标题字体
coverSource | url | 封面图片链接
coverFillMode | enum | 封面图片填充模式(来自 Image)
bodyAvatarSize | int | 内容字体
bodyAvatarIcon | int | 主体部分头像图标(来自 DelIcon)
bodyAvatarSource | url | 主体部分头像链接
bodyAvatarText | string | 主体部分头像文本
bodyTitle | string | 主体部分标题文本
bodyTitleFont | font | 主体部分标题字体
bodyDescription | string | 主体部分描述文本
bodyDescriptionFont | font | 主体部分描述字体
colorTitle | color | 标题文本颜色
colorBodyAvatar | color | 主体部分头像颜色
colorBodyAvatarBg | color | 主体部分头像背景颜色
colorBodyTitle | color | 主体部分标题颜色
colorBodyDescription | color | 主体部分描述颜色
\n **注意** \`[bodyAvatarIcon/bodyAvatarSource/bodyAvatarText]\`只需提供一种即可
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
最基础的卡片容器，可承载文字、列表、图片、段落。
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("典型卡片")
            desc: qsTr(`
包含标题、内容、操作区域。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelCard {
                        title: qsTr("Card title")
                        extraDelegate: DelButton { type: DelButton.Type_Link; text: qsTr("More") }
                        bodyDescription: qsTr("Card content\\nCard content\\nCard content")
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelCard {
                    title: qsTr("Card title")
                    extraDelegate: DelButton { type: DelButton.Type_Link; text: qsTr("More") }
                    bodyDescription: qsTr("Card content\nCard content\nCard content")
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("整体结构")
            desc: qsTr(`
通过代理可自由定制卡片内容: \n
- **titleDelegate: Component** 卡片标题代理\n
- **extraDelegate: Component** 卡片右上角操作代理\n
- **coverDelegate: Component** 卡片封面代理\n
- **bodyDeleagte: Component** 卡片主体代理\n
- **actionDeleagte: Component** 卡片动作代理\n
将代理设置为 \`Item {}\` 可以隐藏该部分。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import DelegateUI

                Row {
                    width: parent.width

                    DelCard {
                        id: card
                        title: qsTr("Card title")
                        extraDelegate: DelButton { type: DelButton.Type_Link; text: qsTr("More") }
                        coverSource: "https://gw.alipayobjects.com/zos/rmsportal/JiqGstEfoWAOHiTxclqi.png"
                        bodyAvatarIcon: DelIcon.AccountBookOutlined
                        bodyTitle: "Card Meta title"
                        bodyDescription: "This is the description"
                        actionDeleagte: Item {
                            height: 45

                            DelDivider {
                                width: parent.width
                                height: 1
                            }

                            RowLayout {
                                width: parent.width
                                height: parent.height

                                Item {
                                    Layout.preferredWidth: parent.width / 3
                                    Layout.fillHeight: true

                                    DelIconText {
                                        anchors.centerIn: parent
                                        iconSource: DelIcon.SettingOutlined
                                        iconSize: 16
                                    }
                                }

                                Item {
                                    Layout.preferredWidth: parent.width / 3
                                    Layout.fillHeight: true

                                    DelDivider {
                                        width: 1
                                        height: parent.height * 0.5
                                        anchors.verticalCenter: parent.verticalCenter
                                        orientation: Qt.Vertical
                                    }

                                    DelIconText {
                                        anchors.centerIn: parent
                                        iconSource: DelIcon.EditOutlined
                                        iconSize: 16
                                    }
                                }

                                Item {
                                    Layout.preferredWidth: parent.width / 3
                                    Layout.fillHeight: true

                                    DelDivider {
                                        width: 1
                                        height: parent.height * 0.5
                                        anchors.verticalCenter: parent.verticalCenter
                                        orientation: Qt.Vertical
                                    }

                                    DelIconText {
                                        anchors.centerIn: parent
                                        iconSource: DelIcon.EllipsisOutlined
                                        iconSize: 16
                                    }
                                }
                            }
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 40

                DelCard {
                    id: card
                    title: qsTr("Card title")
                    extraDelegate: DelButton { type: DelButton.Type_Link; text: qsTr("More") }
                    coverSource: "https://gw.alipayobjects.com/zos/rmsportal/JiqGstEfoWAOHiTxclqi.png"
                    bodyAvatarIcon: DelIcon.AccountBookOutlined
                    bodyTitle: qsTr("Card Meta title")
                    bodyDescription: qsTr("This is the description")
                    actionDeleagte: Item {
                        height: 45

                        DelDivider {
                            width: parent.width
                            height: 1
                        }

                        RowLayout {
                            width: parent.width
                            height: parent.height

                            Item {
                                Layout.preferredWidth: parent.width / 3
                                Layout.fillHeight: true

                                DelIconText {
                                    anchors.centerIn: parent
                                    iconSource: DelIcon.SettingOutlined
                                    iconSize: 16
                                }
                            }

                            Item {
                                Layout.preferredWidth: parent.width / 3
                                Layout.fillHeight: true

                                DelDivider {
                                    width: 1
                                    height: parent.height * 0.5
                                    anchors.verticalCenter: parent.verticalCenter
                                    orientation: Qt.Vertical
                                }

                                DelIconText {
                                    anchors.centerIn: parent
                                    iconSource: DelIcon.EditOutlined
                                    iconSize: 16
                                }
                            }

                            Item {
                                Layout.preferredWidth: parent.width / 3
                                Layout.fillHeight: true

                                DelDivider {
                                    width: 1
                                    height: parent.height * 0.5
                                    anchors.verticalCenter: parent.verticalCenter
                                    orientation: Qt.Vertical
                                }

                                DelIconText {
                                    anchors.centerIn: parent
                                    iconSource: DelIcon.EllipsisOutlined
                                    iconSize: 16
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: focusRect
                        width: 0
                        height: 0
                        color: "transparent"
                        border.width: 2
                        border.color: "red"

                        Behavior on x { NumberAnimation { duration: DelTheme.Primary.durationMid } }
                        Behavior on y { NumberAnimation { duration: DelTheme.Primary.durationMid } }
                        Behavior on width { NumberAnimation { duration: DelTheme.Primary.durationMid } }
                        Behavior on height { NumberAnimation { duration: DelTheme.Primary.durationMid } }
                    }
                }

                component Area: Rectangle {
                    width: 300
                    height: 60
                    color: hovered ? DelThemeFunctions.alpha(DelTheme.Primary.colorTextBase, 0.1) : DelTheme.Primary.colorBgBase
                    border.color: DelThemeFunctions.alpha(DelTheme.Primary.colorTextBase, 0.1)

                    property alias text: areaText.text
                    property alias hovered: hoverHandler.hovered

                    function setArea(x, y, w, h) {
                        if (hovered) {
                            focusRect.x = x;
                            focusRect.y = y;
                            focusRect.width = w;
                            focusRect.height = h;
                        }
                    }

                    Text {
                        id: areaText
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 30
                        color: DelTheme.Primary.colorTextBase
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                    }

                    HoverHandler { id: hoverHandler }
                }

                Column {
                    spacing: -1
                    Area {
                        text: qsTr("titleDelegate\n设置卡片标题区域代理")
                        onHoveredChanged: {
                            setArea(0, 0, 210, 60);
                        }
                    }
                    Area {
                        text: qsTr("extraDelegate\n设置卡片右上角操作区域代理")
                        onHoveredChanged: {
                            setArea(210, 0, 90, 60);
                        }
                    }
                    Area {
                        text: qsTr("coverDelegate\n设置卡片封面区域代理")
                        onHoveredChanged: {
                            setArea(0, 60, card.width, 180);
                        }
                    }
                    Area {
                        text: qsTr("bodyDelegate\n设置卡片主体区域代理")
                        onHoveredChanged: {
                            setArea(0, 240, card.width, 100);
                        }
                    }
                    Area {
                        text: qsTr("actionDeleagte\n设置卡片动作区域代理")
                        onHoveredChanged: {
                            setArea(0, 340, card.width, 45);
                        }
                    }
                }
            }
        }
    }
}

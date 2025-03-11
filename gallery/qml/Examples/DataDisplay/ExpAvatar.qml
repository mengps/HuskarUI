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
## DelAvatar 头像 \n
用来代表用户或事物，支持图片、图标或字符展示。\n
* **继承自 { Item }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
size | int | 头像大小
iconSource | int | 头像图标(来自 DelIcon)
imageSource | url | 头像图像
imageMipmap | bool | 是否开启层级映射(默认 false)
textSource | string | 头像文本
textFont | font | 文本字体(文本头像时生效)
textSize | enum | 文本大小模式(来自 DelAvatar)
textGap | int | 文本距离两侧单位像素(文本头像时生效)
colorBg | color | 背景颜色
colorIcon | color | 图标颜色(图标头像时生效)
colorText | color |文本颜色(文本头像时生效)
radiusBg | int | 背景半径
\n **注意** \`[iconSource/imageSource/textSource]\`只需提供一种即可
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
当用户需要头像时使用。
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("基本")
            desc: qsTr(`
通过 \`size\` 属性设置大小。\n
通过 \`radiusBg\` 属性设置圆角大小(默认为size一半, 即圆形)。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    Row {
                        spacing: 10

                        DelAvatar {
                            size: 100
                            iconSource: DelIcon.UserOutlined
                        }

                        DelAvatar {
                            size: 80
                            iconSource: DelIcon.UserOutlined
                        }

                        DelAvatar {
                            size: 60
                            iconSource: DelIcon.UserOutlined
                        }

                        DelAvatar {
                            size: 40
                            iconSource: DelIcon.UserOutlined
                        }

                        DelAvatar {
                            size: 20
                            iconSource: DelIcon.UserOutlined
                        }
                    }

                    Row {
                        spacing: 10

                        DelAvatar {
                            size: 100
                            iconSource: DelIcon.UserOutlined
                            radiusBg: 6
                        }

                        DelAvatar {
                            size: 80
                            iconSource: DelIcon.UserOutlined
                            radiusBg: 6
                        }

                        DelAvatar {
                            size: 60
                            iconSource: DelIcon.UserOutlined
                            radiusBg: 6
                        }

                        DelAvatar {
                            size: 40
                            iconSource: DelIcon.UserOutlined
                            radiusBg: 6
                        }

                        DelAvatar {
                            size: 20
                            iconSource: DelIcon.UserOutlined
                            radiusBg: 6
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    DelAvatar {
                        size: 100
                        iconSource: DelIcon.UserOutlined
                    }

                    DelAvatar {
                        size: 80
                        iconSource: DelIcon.UserOutlined
                    }

                    DelAvatar {
                        size: 60
                        iconSource: DelIcon.UserOutlined
                    }

                    DelAvatar {
                        size: 40
                        iconSource: DelIcon.UserOutlined
                    }

                    DelAvatar {
                        size: 20
                        iconSource: DelIcon.UserOutlined
                    }
                }

                Row {
                    spacing: 10

                    DelAvatar {
                        size: 100
                        iconSource: DelIcon.UserOutlined
                        radiusBg: 6
                    }

                    DelAvatar {
                        size: 80
                        iconSource: DelIcon.UserOutlined
                        radiusBg: 6
                    }

                    DelAvatar {
                        size: 60
                        iconSource: DelIcon.UserOutlined
                        radiusBg: 6
                    }

                    DelAvatar {
                        size: 40
                        iconSource: DelIcon.UserOutlined
                        radiusBg: 6
                    }

                    DelAvatar {
                        size: 20
                        iconSource: DelIcon.UserOutlined
                        radiusBg: 6
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("类型")
            desc: qsTr(`
支持三种类型：图片、图标以及字符型头像。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelAvatar {
                        anchors.verticalCenter: parent.verticalCenter
                        iconSource: DelIcon.UserOutlined
                    }

                    DelAvatar {
                        anchors.verticalCenter: parent.verticalCenter
                        textSource: "U"
                    }

                    DelAvatar {
                        anchors.verticalCenter: parent.verticalCenter
                        textSource: "USER"
                    }

                    DelAvatar {
                        anchors.verticalCenter: parent.verticalCenter
                        imageSource: "https://avatars.githubusercontent.com/u/33405710?v=4"
                    }

                    DelAvatar {
                        anchors.verticalCenter: parent.verticalCenter
                        textSource: "U"
                        colorText: "#F56A00"
                        colorBg: "#FDE3CF"
                    }

                    DelAvatar {
                        anchors.verticalCenter: parent.verticalCenter
                        iconSource: DelIcon.UserOutlined
                        colorBg: "#87D068"
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelAvatar {
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: DelIcon.UserOutlined
                }

                DelAvatar {
                    anchors.verticalCenter: parent.verticalCenter
                    textSource: "U"
                }

                DelAvatar {
                    anchors.verticalCenter: parent.verticalCenter
                    textSource: "USER"
                }

                DelAvatar {
                    anchors.verticalCenter: parent.verticalCenter
                    imageSource: "https://avatars.githubusercontent.com/u/33405710?v=4"
                }

                DelAvatar {
                    anchors.verticalCenter: parent.verticalCenter
                    textSource: "U"
                    colorText: "#F56A00"
                    colorBg: "#FDE3CF"
                }

                DelAvatar {
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: DelIcon.UserOutlined
                    colorBg: "#87D068"
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("自动调整字符型头像大小")
            desc: qsTr(`
通过 \`textSize\` 属性设置文本大小调整模式，支持的大小：\n
- 固定大小(默认) { DelAvatar.Size_Fixed }\n
- 自动计算大小 { DelAvatar.Size_Auto }\n
通过 \`textGap\` 属性设置字符距离左右两侧边界单位像素。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelAvatar {
                        anchors.verticalCenter: parent.verticalCenter
                        size: 40
                        textSource: changeButton.userList[changeButton.index]
                        colorBg: changeButton.colorList[changeButton.index]
                        textSize: DelAvatar.Size_Fixed
                    }

                    DelAvatar {
                        anchors.verticalCenter: parent.verticalCenter
                        size: 40
                        textSource: changeButton.userList[changeButton.index]
                        colorBg: changeButton.colorList[changeButton.index]
                        textSize: DelAvatar.Size_Auto
                    }

                    DelButton {
                        id: changeButton
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("ChangeUser")
                        onClicked: {
                            index = (index + 1) % 4;
                        }
                        property int index: 0
                        property var userList: ['U', 'Lucy', 'Tom', 'Edward']
                        property var colorList: ['#f56a00', '#7265e6', '#ffbf00', '#00a2ae']
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelAvatar {
                    anchors.verticalCenter: parent.verticalCenter
                    size: 40
                    textSource: changeButton.userList[changeButton.index]
                    colorBg: changeButton.colorList[changeButton.index]
                    textSize: DelAvatar.Size_Fixed
                }

                DelAvatar {
                    anchors.verticalCenter: parent.verticalCenter
                    size: 40
                    textSource: changeButton.userList[changeButton.index]
                    colorBg: changeButton.colorList[changeButton.index]
                    textSize: DelAvatar.Size_Auto
                }

                DelButton {
                    id: changeButton
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("ChangeUser")
                    onClicked: {
                        index = (index + 1) % 4;
                    }
                    property int index: 0
                    property var userList: ['U', 'Lucy', 'Tom', 'Edward']
                    property var colorList: ['#f56a00', '#7265e6', '#ffbf00', '#00a2ae']
                }
            }
        }
    }
}

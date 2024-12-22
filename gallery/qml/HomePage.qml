import QtQuick
import Qt5Compat.GraphicalEffects
import DelegateUI

Flickable {
    contentHeight: column.height + 20

    component Card: Item {
        width: 300
        height: 200
        scale: hovered ? 1.01 : 1

        property bool hovered: false
        property alias icon: __icon
        property alias title: __title
        property alias desc: __desc

        Behavior on scale { NumberAnimation { duration: DelTheme.Primary.durationFast } }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true;
            onExited: parent.hovered = false;
            onClicked: {
                Qt.openUrlExternally("https://github.com/mengps/DelegateUI")
            }
        }

        DropShadow {
            anchors.fill: __rect
            radius: 8
            color: DelTheme.Primary.colorTextBase
            source: __rect
            opacity: parent.hovered ? 0.5 : 0.2

            Behavior on color { ColorAnimation { duration: DelTheme.Primary.durationMid } }
            Behavior on opacity { NumberAnimation { duration: DelTheme.Primary.durationMid } }
        }

        Rectangle {
            id: __rect
            anchors.fill: parent
            color: DelTheme.Primary.colorBgBase
            radius: 6
            border.color: DelThemeFunctions.alpha(DelTheme.Primary.colorTextBase, 0.2)

            Behavior on color { ColorAnimation { duration: DelTheme.Primary.durationMid } }
        }

        Column {
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 10
            spacing: 10

            DelIconText {
                id: __icon
                anchors.horizontalCenter: parent.horizontalCenter
                iconSize: 60
            }

            Text {
                id: __title
                anchors.horizontalCenter: parent.horizontalCenter
                font {
                    family: DelTheme.Primary.fontPrimaryFamily
                    pixelSize: DelTheme.Primary.fontPrimarySize
                }
                color: DelTheme.Primary.colorTextBase
            }

            Text {
                id: __desc
                width: parent.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
                font {
                    family: DelTheme.Primary.fontPrimaryFamily
                    pixelSize: DelTheme.Primary.fontPrimarySize
                }
                color: DelTheme.Primary.colorTextBase
                wrapMode: Text.WrapAnywhere
            }
        }

        DelIconText {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            iconSize: 20
            iconSource: DelIcon.LinkOutlined
        }
    }

    Column {
        id: column
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 30

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Item {
                width: DelTheme.Primary.fontPrimarySize + 36
                height: width
                anchors.verticalCenter: parent.verticalCenter

                DelIconText {
                    id: delegateuiIcon1
                    iconSize: parent.width
                    colorIcon: "#C44545"
                    font.bold: true
                    iconSource: DelIcon.DelegateUIPath1
                }

                DelIconText {
                    iconSize: parent.width
                    colorIcon: "#C44545"
                    font.bold: true
                    iconSource: DelIcon.DelegateUIPath2
                }

                DropShadow {
                    anchors.fill: delegateuiIcon1
                    radius: 4
                    horizontalOffset: 4
                    verticalOffset: 4
                    color: delegateuiIcon1.colorIcon
                    source: delegateuiIcon1
                    opacity: 0.3

                    Behavior on color { ColorAnimation { duration: DelTheme.Primary.durationMid } }
                    Behavior on opacity { NumberAnimation { duration: DelTheme.Primary.durationMid } }
                }
            }

            Item {
                width: delegateuiTitle.width
                height: delegateuiTitle.height
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: delegateuiTitle
                    text: qsTr("DelegateUI")
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize + 32
                    }
                    color: DelTheme.Primary.colorTextBase
                }

                DropShadow {
                    anchors.fill: delegateuiTitle
                    radius: 4
                    horizontalOffset: 4
                    verticalOffset: 4
                    color: delegateuiTitle.color
                    source: delegateuiTitle
                    opacity: 0.3

                    Behavior on color { ColorAnimation { duration: DelTheme.Primary.durationMid } }
                    Behavior on opacity { NumberAnimation { duration: DelTheme.Primary.durationMid } }
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("助力开发者「更灵活」地搭建出「更美」的产品，让用户「快乐工作」～")
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySize
            }
            color: DelTheme.Primary.colorTextBase
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Card {
                icon.iconSource: DelIcon.GithubOutlined
                title.text: qsTr("DelegateUI Github")
                desc.text: qsTr("DelegateUI 是遵循「Ant Design」设计体系的一个 Qml UI 库，用于构建由「Qt Quick」驱动的用户界面。")
            }
        }
    }
}

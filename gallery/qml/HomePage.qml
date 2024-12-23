import QtQuick
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import DelegateUI

Rectangle {
    color: "#80000000"

    ShaderEffect {
        anchors.fill: parent
        vertexShader: "qrc:/Gallery/shaders/effect1.vert.qsb"
        fragmentShader: "qrc:/Gallery/shaders/effect1.frag.qsb"
        opacity: 0.5

        property vector3d iResolution: Qt.vector3d(width, height, 0)
        property real iTime: 0

        Timer {
            running: true
            repeat: true
            interval: 10
            onTriggered: parent.iTime += 0.01;
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: column.height + 20
        ScrollBar.vertical: DelScrollBar { }

        component Card: Item {
            width: 300
            height: 200
            scale: hovered ? 1.01 : 1

            property bool hovered: false
            property alias icon: __icon
            property alias title: __title
            property alias desc: __desc
            property alias linkIcon: __linkIcon
            property string link: ""

            Behavior on scale { NumberAnimation { duration: DelTheme.Primary.durationFast } }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true;
                onExited: parent.hovered = false;
                onClicked: {
                    Qt.openUrlExternally(link);
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
                color: DelThemeFunctions.alpha(DelTheme.Primary.colorBgBase, 0.8)
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
                id: __linkIcon
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                iconSize: 20
                iconSource: DelIcon.LinkOutlined
            }
        }

        component MyText: Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font {
                family: DelTheme.Primary.fontPrimaryFamily
            }
            color: DelTheme.Primary.colorTextBase
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
                    width: DelTheme.Primary.fontPrimarySize + 42
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

                    MyText {
                        id: delegateuiTitle
                        text: qsTr("DelegateUI")
                        font.pixelSize: DelTheme.Primary.fontPrimarySize + 42
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

            MyText {
                text: qsTr("助力开发者「更灵活」地搭建出「更美」的产品，让用户「快乐工作」～")
                font.pixelSize: DelTheme.Primary.fontPrimarySize
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                Card {
                    icon.iconSource: DelIcon.GithubOutlined
                    title.text: qsTr("DelegateUI Github")
                    desc.text: qsTr("DelegateUI 是遵循「Ant Design」设计体系的一个 Qml UI 库，用于构建由「Qt Quick」驱动的用户界面。")
                    link: "https://github.com/mengps/DelegateUI"
                }
            }

            MyText {
                text: qsTr("定制主题，随心所欲")
                font.pixelSize: DelTheme.Primary.fontPrimarySize + 16
                font.bold: true
            }

            MyText {
                text: qsTr("DelegateUI 支持全局/组件的样式定制，内置多种接口让你定制主题更简单")
                font.pixelSize: DelTheme.Primary.fontPrimarySize
            }

            Card {
                anchors.horizontalCenter: parent.horizontalCenter
                icon.iconSource: DelIcon.SkinOutlined
                title.text: qsTr("DelegateUI-ThemeDesigner")
                desc.text: qsTr("DelegateUI-ThemeDesigner 是专为「DelegateUI」打造的主题设计工具。")
                link: "https://github.com/mengps/DelegateUI-ThemeDesigner"
            }

            MyText {
                text: qsTr("组件丰富，选用自如")
                font.pixelSize: DelTheme.Primary.fontPrimarySize + 16
                font.bold: true
            }

            MyText {
                text: qsTr("DelegateUI 提供大量实用组件满足你的需求，基于代理的方式实现灵活定制与拓展")
                font.pixelSize: DelTheme.Primary.fontPrimarySize
            }
        }
    }
}


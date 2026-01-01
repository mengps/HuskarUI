import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Effects
import HuskarUI.Basic

Rectangle {
    color: '#80000000'

    ShaderEffect {
        anchors.fill: parent
        vertexShader: 'qrc:/Gallery/shaders/effect1.vert.qsb'
        fragmentShader: 'qrc:/Gallery/shaders/effect1.frag.qsb'
        opacity: 0.5

        property vector3d iResolution: Qt.vector3d(width, height, 0)
        property real iTime: 0

        Timer {
            running: true
            repeat: true
            interval: 16
            onTriggered: parent.iTime += 0.01;
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: column.height + 20
        ScrollBar.vertical: HusScrollBar { }

        component DropShadow: MultiEffect {
            anchors.fill: __rect
            source: __rect
            shadowEnabled: true
            shadowBlur: 0.8
            shadowColor: color
            shadowScale: 1.02
            autoPaddingEnabled: true
            property color color
        }

        component Card: MouseArea {
            id: __cardComp
            width: 300
            height: 200
            scale: hovered ? 1.01 : 1
            hoverEnabled: true
            onEntered: hovered = true;
            onExited: hovered = false;
            onClicked: {
                if (__cardComp.link.length != 0)
                    Qt.openUrlExternally(link);
            }

            property bool hovered: false
            property alias icon: __icon
            property alias title: __title
            property alias desc: __desc
            property alias linkIcon: __linkIcon
            property string link: ''
            property string tagState: ''

            Behavior on scale { NumberAnimation { duration: HusTheme.Primary.durationFast } }

            DropShadow {
                anchors.fill: __rect
                color: HusTheme.Primary.colorTextBase
                source: __rect
                opacity: parent.hovered ? 0.8 : 0.4

                Behavior on color { ColorAnimation { duration: HusTheme.Primary.durationMid } }
                Behavior on opacity { NumberAnimation { duration: HusTheme.Primary.durationMid } }
            }

            Rectangle {
                id: __rect
                anchors.fill: parent
                color: HusThemeFunctions.alpha(HusTheme.Primary.colorBgBase, 0.8)
                radius: 6
                border.color: HusThemeFunctions.alpha(HusTheme.Primary.colorTextBase, 0.2)

                Behavior on color { ColorAnimation { duration: HusTheme.Primary.durationMid } }
            }

            ColumnLayout {
                width: parent.width
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                spacing: 10

                HusIconText {
                    id: __icon
                    Layout.preferredWidth: width
                    Layout.preferredHeight: empty ? 0 : height
                    Layout.alignment: Qt.AlignHCenter
                    iconSize: 60
                }

                HusText {
                    id: __title
                    Layout.preferredWidth: parent.width - 10
                    Layout.preferredHeight: height
                    Layout.alignment: Qt.AlignHCenter
                    font {
                        family: HusTheme.Primary.fontPrimaryFamily
                        pixelSize: HusTheme.Primary.fontPrimarySizeHeading4
                        bold: true
                    }
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAnywhere
                }

                Flickable {
                    Layout.preferredWidth: parent.width - 50
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter
                    contentHeight: __desc.contentHeight
                    ScrollBar.vertical: HusScrollBar { }
                    clip: true
                    interactive: false

                    HusText {
                        id: __desc
                        width: parent.width - 10
                        font {
                            family: HusTheme.Primary.fontPrimaryFamily
                            pixelSize: HusTheme.Primary.fontPrimarySize
                        }
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }

            DropShadow {
                anchors.fill: __new
                shadowHorizontalOffset: 4
                shadowVerticalOffset: 4
                color: __new.color
                source: __new
                opacity: 0.6
                visible: __new.visible
            }

            Rectangle {
                id: __new
                width: __row.width + 12
                height: __row.height + 6
                anchors.right: parent.right
                anchors.rightMargin: -width * 0.2
                anchors.top: parent.top
                anchors.topMargin: 5
                radius: 2
                visible: __cardComp.tagState != ''
                color: {
                    if (__cardComp.tagState == 'New')
                        return HusTheme.Primary.colorError;
                    else if (__cardComp.tagState == 'Update')
                        HusTheme.Primary.colorSuccess;
                    else
                        return 'transparent';
                }

                Row {
                    id: __row
                    anchors.centerIn: parent

                    HusIconText {
                        anchors.verticalCenter: parent.verticalCenter
                        iconSize: HusTheme.Primary.fontPrimarySize
                        iconSource: HusIcon.FireFilled
                        color: 'white'
                    }

                    HusText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: __cardComp.tagState.toUpperCase()
                        font {
                            family: HusTheme.Primary.fontPrimaryFamily
                            pixelSize: HusTheme.Primary.fontPrimarySize
                        }
                        color: 'white'
                    }
                }
            }

            HusIconText {
                id: __linkIcon
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 10
                iconSize: 20
                iconSource: HusIcon.LinkOutlined
            }
        }

        component MyText: HusText {
            anchors.horizontalCenter: parent.horizontalCenter
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
                    width: HusTheme.Primary.fontPrimarySize + 42
                    height: width
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        id: huskaruiIcon
                        width: parent.width
                        height: width
                        anchors.centerIn: parent
                        source: 'qrc:/Gallery/images/huskarui_new_square.svg'
                    }
                }

                Item {
                    width: huskaruiTitle.width
                    height: huskaruiTitle.height
                    anchors.verticalCenter: parent.verticalCenter

                    MyText {
                        id: huskaruiTitle
                        text: HusApp.libName()
                        font.pixelSize: HusTheme.Primary.fontPrimarySize + 42
                    }

                    DropShadow {
                        anchors.fill: huskaruiTitle
                        shadowHorizontalOffset: 4
                        shadowVerticalOffset: 4
                        color: huskaruiTitle.color
                        source: huskaruiTitle
                        opacity: 0.6

                        Behavior on color { ColorAnimation { duration: HusTheme.Primary.durationMid } }
                        Behavior on opacity { NumberAnimation { duration: HusTheme.Primary.durationMid } }
                    }
                }
            }

            MyText {
                text: qsTr('助力开发者「更灵活」地搭建出「更美」的产品，让用户「快乐工作」～')
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                Card {
                    icon.iconSource: HusIcon.GithubOutlined
                    title.text: qsTr(`${HusApp.libName()} Github`)
                    desc.text: qsTr(`${HusApp.libName()} 是遵循「Ant Design」设计体系的一个 Qml UI 库，用于构建由「Qt Quick」驱动的用户界面。`)
                    link: `https://github.com/mengps/${HusApp.libName()}`
                }
            }

            MyText {
                text: qsTr('定制主题，随心所欲')
                font.pixelSize: HusTheme.Primary.fontPrimarySize + 16
                font.bold: true
            }

            MyText {
                text: qsTr(`${HusApp.libName()} 支持全局/组件的样式定制，内置多种接口让你定制主题更简单`)
            }

            Card {
                anchors.horizontalCenter: parent.horizontalCenter
                icon.iconSource: HusIcon.SkinOutlined
                title.text: qsTr('HuskarUI-ThemeDesigner')
                desc.text: qsTr('HuskarUI-ThemeDesigner 是专为「HuskarUI」打造的主题设计工具。')
                link: 'https://github.com/mengps/HuskarUI-ThemeDesigner'
            }

            MyText {
                text: qsTr('组件丰富，选用自如')
                font.pixelSize: HusTheme.Primary.fontPrimarySize + 16
                font.bold: true
            }

            MyText {
                text: qsTr(`${HusApp.libName()} 提供大量实用组件满足你的需求，基于代理的方式实现灵活定制与拓展`)
            }

            ListView {
                id: galleryView
                width: parent.width
                height: 200
                orientation: Qt.Horizontal
                spacing: -80
                model: galleryGlobal.updates
                delegate: Item {
                    id: __rootItem
                    z: index
                    width: __card.hovered ? 390 : 250
                    height: galleryView.height - 30

                    required property int index
                    required property string tagState
                    required property string name
                    required property string desc

                    property bool preventFlicker: false

                    Behavior on width { NumberAnimation { duration: HusTheme.Primary.durationMid } }

                    MouseArea {
                        id: hoverArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                        
                        onEntered: {
                            if (!__card.hovered) {
                                __card.hovered = true;
                                preventFlicker = true;
                                flickerTimer.restart();
                            }
                        }
                        
                        onExited: {
                            if (!__card.containsMouse) {
                                __card.hovered = false;
                            }
                        }
                    }
                    
                    Timer {
                        id: flickerTimer
                        interval: HusTheme.Primary.durationMid * 1.5
                        onTriggered: {
                            __rootItem.preventFlicker = false;
                        }
                    }
                    
                    Connections {
                        target: __card
                        function onContainsMouseChanged() {
                            if (__card.containsMouse) {
                                __card.hovered = true;
                            }
                        }
                    }

                    Card {
                        id: __card
                        width: 250
                        height: parent.height
                        anchors.centerIn: parent
                        tagState: __rootItem.tagState
                        title.text: __rootItem.name
                        desc.text: __rootItem.desc
                        transform: Rotation {
                            origin.x: __rootItem.width * 0.5
                            origin.y: __rootItem.height * 0.5
                            axis {
                                x: 0
                                y: 1
                                z: 0
                            }
                            angle: __card.hovered ? 0 : 45

                            Behavior on angle { NumberAnimation { duration: HusTheme.Primary.durationMid } }
                        }
                        onClicked: {
                            galleryMenu.gotoMenu(__rootItem.name);
                        }
                    }
                }

                ScrollBar.horizontal: HusScrollBar { }
            }
        }
    }
}


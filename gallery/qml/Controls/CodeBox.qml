import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import HuskarUI.Basic

Rectangle {
    id: root

    width: parent.width
    height: column.height + 40
    radius: 5
    color: 'transparent'
    border.color: HusTheme.Primary.colorFillPrimary
    clip: true

    property alias expTitle: expDivider.title
    property alias descTitle: descDivider.title
    property alias desc: descTextLoader.text
    property bool async: true
    property Component exampleDelegate: Item { }
    property alias code: codeText.text

    HusMessage {
        id: message
        z: 999
        parent: galleryWindow.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        showCloseButton: true
    }

    Column {
        id: column
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 10

        HusDivider {
            id: expDivider
            width: parent.width
            height: 25
            visible: false
            title: qsTr('示例')
        }

        Loader {
            width: parent.width
            asynchronous: root.async
            sourceComponent: exampleDelegate
        }

        HusDivider {
            id: descDivider
            width: parent.width
            height: 25
            title: qsTr('说明')
        }

        MouseArea {
            id: descMouseArea
            width: parent.width
            height: descTextLoader.height
            hoverEnabled: true

            Loader{
                id: descTextLoader
                width: parent.width
                asynchronous: true
                sourceComponent: HusCopyableText {
                    textFormat: Text.MarkdownText
                    wrapMode: Text.WordWrap
                    text: descTextLoader.text
                    onLinkActivated:
                        (link) => {
                            if (link.startsWith('internal://'))
                                galleryMenu.gotoMenu(link.slice(11));
                            else
                                Qt.openUrlExternally(link);
                        }
                    onHoveredLinkChanged: {
                        if (hoveredLink === '') {
                            linkTooltip.visible = false;
                        } else {
                            linkTooltip.text = hoveredLink;
                            linkTooltip.x = descMouseArea.mouseX;
                            linkTooltip.y = descMouseArea.mouseY;
                            linkTooltip.visible = true;
                        }
                    }
                }
                property string text: ''
            }

            HusToolTip {
                id: linkTooltip
            }
        }

        HusDivider {
            width: parent.width
            height: 30
            title: qsTr('代码')
            titleAlign: HusDivider.Align_Center
            titleDelegate: Row {
                spacing: 10
                HusIconButton {
                    padding: 4
                    topPadding: 4
                    bottomPadding: 4
                    onClicked: {
                        codeText.expanded = !codeText.expanded;
                    }
                    contentItem: Item {
                        implicitWidth: HusTheme.Primary.fontPrimarySizeHeading4
                        implicitHeight: implicitWidth
                        Row {
                            height: parent.implicitHeight
                            anchors.horizontalCenter: parent.horizontalCenter
                            HusIconText {
                                anchors.verticalCenter: parent.verticalCenter
                                iconSize: HusTheme.Primary.fontPrimarySize - 4
                                iconSource: HusIcon.LeftOutlined
                            }
                            HusIconText {
                                anchors.verticalCenter: parent.verticalCenter
                                iconSize: HusTheme.Primary.fontPrimarySize - 4
                                iconSource: HusIcon.RightOutlined
                            }
                        }

                        HusIconText {
                            anchors.centerIn: parent
                            iconSize: HusTheme.Primary.fontPrimarySize - 2
                            iconSource: HusIcon.MinusOutlined
                            rotation: -80
                            opacity: codeText.expanded ? 1 : 0
                            Behavior on opacity { NumberAnimation { duration: HusTheme.Primary.durationMid } }
                        }
                    }

                    HusToolTip {
                        showArrow: false
                        visible: parent ? parent.hovered : false
                        text: codeText.expanded ? qsTr('收起代码') : qsTr('展开代码')
                    }
                }
                HusIconButton {
                    padding: 4
                    topPadding: 4
                    bottomPadding: 4
                    iconSize: HusTheme.Primary.fontPrimarySizeHeading4
                    iconSource: HusIcon.CodeOutlined
                    onClicked: {
                        const component = Qt.createComponent('CodeRunner.qml');
                        if (component.status === Component.Ready) {
                            let win = component.createObject(root);
                            win.createQmlObject(code);
                        }
                    }
                    HusToolTip {
                        showArrow: false
                        visible: parent ? parent.hovered : false
                        text: qsTr('运行代码')
                    }
                }
                HusIconButton {
                    padding: 4
                    topPadding: 4
                    bottomPadding: 4
                    iconSize: HusTheme.Primary.fontPrimarySizeHeading4
                    iconSource: HusIcon.CopyOutlined
                    onClicked: {
                        HusApi.setClipbordText(codeText.text);
                        message.success(qsTr('代码复制成功'))
                    }
                    HusToolTip {
                        showArrow: false
                        visible: parent ? parent.hovered : false
                        text: qsTr('复制代码')
                    }
                }
            }
        }

        HusCopyableText {
            id: codeText
            clip: true
            width: parent.width
            height: expanded ? implicitHeight : 0
            wrapMode: Text.WordWrap
            property bool expanded: false

            Behavior on height { NumberAnimation { duration: HusTheme.Primary.durationMid } }
        }
    }
}

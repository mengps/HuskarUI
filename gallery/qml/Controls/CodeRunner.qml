import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

HusWindow {
    id: root

    width: 900
    height: 600
    title: qsTr('代码运行器')
    captionBar.closeCallback:
        () => {
            root.destroy();
        }
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/huskarui_icon.svg'
        }
    }
    Component.onCompleted: {
        if (Qt.platform.os === 'windows') {
            if (setSpecialEffect(HusWindow.Win_DwmBlur)) return;
        } else if (Qt.platform.os === 'osx') {
            if (setSpecialEffect(HusWindow.Mac_BlurEffect)) return;
        }
        HusApi.setWindowStaysOnTopHint(root, true);
    }

    property var created: undefined

    function createQmlObject(code) {
        codeEdit.text = code;
        updateCode();
    }

    function updateCode() {
        try {
            errorEdit.clear();
            if (created)
                created.destroy();
            created = Qt.createQmlObject(codeEdit.text, runnerBlock);
            created.parent = runnerBlock;
            created.width = Qt.binding(() => runnerBlock.width);
        } catch (error) {
            errorEdit.text = error.message;
        }
    }

    HusDivider {
        id: divider
        width: parent.width
        height: 1
        anchors.top: captionBar.bottom
    }

    Item {
        id: content
        width: parent.width
        anchors.top: divider.bottom
        anchors.bottom: parent.bottom

        Item {
            id: codeBlock
            width: parent.width * 0.4
            height: parent.height

            ScrollView {
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: divider1.top
                ScrollBar.vertical: HusScrollBar { }
                ScrollBar.horizontal: HusScrollBar { }

                HusCopyableText {
                    id: codeEdit
                    readOnly: false
                    wrapMode: Text.WrapAnywhere
                }
            }

            HusDivider {
                id: divider1
                width: parent.width
                height: 10
                anchors.bottom: errorView.top
                title: qsTr('错误')
            }

            ScrollView {
                id: errorView
                width: parent.width
                height: 100
                anchors.bottom: parent.bottom

                TextArea {
                    id: errorEdit
                    readOnly: true
                    selectByKeyboard: true
                    selectByMouse: true
                    font {
                        family: HusTheme.Primary.fontPrimaryFamily
                        pixelSize: HusTheme.Primary.fontPrimarySize
                    }
                    color: HusTheme.Primary.colorError
                    wrapMode: Text.WordWrap
                }
            }
        }

        HusDivider {
            id: divider2
            width: 10
            height: parent.height
            anchors.left: codeBlock.right
            orientation: Qt.Vertical
            titleAlign: HusDivider.Align_Center
            titleDelegate: HusIconButton {
                padding: 5
                iconSize: HusTheme.Primary.fontPrimarySizeHeading4
                iconSource: HusIcon.PlayCircleOutlined
                onClicked: {
                    root.updateCode();
                }
                HusToolTip {
                    visible: parent.hovered
                    text: qsTr('运行')
                }
            }
        }

        Item {
            id: runnerBlock
            anchors.left: divider2.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5
        }
    }
}

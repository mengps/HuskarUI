import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

DelWindow {
    id: root

    width: 800
    height: 600
    title: qsTr("代码运行器")
    captionBar.closeCallback:
        ()=> {
            root.destroy();
        }
    captionBar.winIconDelegate: Item {
        DelIconText {
            iconSize: 22
            colorIcon: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath1
        }
        DelIconText {
            iconSize: 22
            colorIcon: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath2
        }
    }
    Component.onCompleted: {
        setSpecialEffect(DelWindowSpecialEffect.Mica);
        DelApi.setWindowStaysOnTopHint(root, true);
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
        } catch (error) {
            errorEdit.text = error.message;
        }
    }

    DelDivider {
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
            width: parent.width * 0.5
            height: parent.height

            ScrollView {
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: divider1.top

                TextArea {
                    id: codeEdit
                    selectByKeyboard: true
                    selectByMouse: true
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                    color: DelTheme.Primary.colorTextBase
                    wrapMode: Text.WrapAnywhere
                }
            }

            DelDivider {
                id: divider1
                width: parent.width
                height: 10
                anchors.bottom: errorView.top
                title: qsTr("错误")
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
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                    color: DelTheme.Primary.colorError
                    wrapMode: Text.WordWrap
                }
            }
        }

        DelDivider {
            id: divider2
            width: 10
            height: parent.height
            anchors.left: codeBlock.right
            orientation: Qt.Vertical
            titleAlign: DelDividerType.Center
            titleDelegate: DelIconButton {
                padding: 5
                iconSize: DelTheme.Primary.fontPrimarySizeHeading4
                iconSource: DelIcon.PlayCircleOutlined
                onClicked: {
                    root.updateCode();
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

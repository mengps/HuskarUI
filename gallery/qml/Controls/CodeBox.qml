import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import DelegateUI

Rectangle {
    id: root

    width: parent.width
    height: column.height + 40
    radius: 5
    color: "transparent"
    border.color: DelThemeFunctions.alpha(DelTheme.Primary.colorTextBase, 0.2)

    property alias expTitle: expDivider.title
    property alias descTitle: descDivider.title
    property alias desc: descText.text
    property Component exampleDelegate: Item { }
    property alias code: codeText.text

    Column {
        id: column
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        spacing: 10

        DelDivider {
            id: expDivider
            width: parent.width
            height: 25
            visible: false
            title: qsTr("示例")
        }

        Loader {
            width: parent.width
            sourceComponent: exampleDelegate
        }

        DelDivider {
            id: descDivider
            width: parent.width
            height: 25
            title: qsTr("说明")
        }

        DelCopyableText {
            id: descText
            width: parent.width
            textFormat: Text.MarkdownText
            wrapMode: Text.WrapAnywhere
        }

        DelDivider {
            width: parent.width
            height: 30
            title: qsTr("代码")
            titleAlign: DelDividerType.Center
            titleDelegate: Row {
                spacing: 10
                DelIconButton {
                    padding: 5
                    iconSize: DelTheme.Primary.fontPrimarySizeHeading4
                    iconSource: DelIcon.ColumnHeightOutlined
                    onClicked: {
                        codeText.expanded = !codeText.expanded;
                    }
                    DelToolTip {
                        arrowVisible: false
                        visible: parent.hovered
                        text: codeText.expanded ? qsTr("收起代码") : qsTr("展开代码")
                    }
                }
                DelIconButton {
                    padding: 5
                    iconSize: DelTheme.Primary.fontPrimarySizeHeading4
                    iconSource: DelIcon.CodeOutlined
                    onClicked: {
                        const component = Qt.createComponent("CodeRunner.qml");
                        if (component.status === Component.Ready) {
                            let win = component.createObject(root);
                            win.createQmlObject(code);
                        }
                    }
                    DelToolTip {
                        arrowVisible: false
                        visible: parent.hovered
                        text: qsTr("运行代码")
                    }
                }
            }
        }

        DelCopyableText {
            id: codeText
            clip: true
            width: parent.width
            height: expanded ? implicitHeight : 0
            wrapMode: Text.WrapAnywhere
            property bool expanded: false

            Behavior on height { NumberAnimation { duration: DelTheme.Primary.durationMid } }
        }
    }
}

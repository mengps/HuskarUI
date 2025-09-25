import QtQuick
import HuskarUI.Basic

Item {
    id: root

    width: parent.width
    height: column.height

    property alias title: titleText.text
    property alias desc: descText.text

    Column {
        id: column
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15

        HusText {
            id: titleText
            width: parent.width
            visible: text.length !== 0
            font {
                pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                weight: Font.DemiBold
            }
        }

        HusText {
            id: descText
            width: parent.width
            lineHeight: 1.2
            visible: text.length !== 0
            textFormat: Text.MarkdownText
            onLinkActivated:
                (link) => {
                    if (link.startsWith('internal://')) {
                        galleryMenu.gotoMenu(link.slice(11));
                    } else {
                        Qt.openUrlExternally(link);
                    }
                }
            onLinkHovered:
                (link) => {
                    shapeMouse.cursorShape = link !== '' ? Qt.PointingHandCursor : Qt.ArrowCursor;
                }

            MouseArea {
                id: shapeMouse
                anchors.fill: parent
                z: parent.z - 2
                propagateComposedEvents: true
                onClicked:
                    (mouse) => {
                        mouse.accepted = false;
                    }
            }
        }
    }
}

import QtQuick
import DelegateUI

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

        DelText {
            id: titleText
            width: parent.width
            visible: text.length !== 0
            font {
                pixelSize: DelTheme.Primary.fontPrimarySizeHeading3
                weight: Font.DemiBold
            }
        }

        DelText {
            id: descText
            width: parent.width
            lineHeight: 1.1
            visible: text.length !== 0
            textFormat: Text.MarkdownText
            onLinkActivated:
                (link) => {
                    if (link.startsWith('internal://'))
                        galleryMenu.gotoMenu(link.slice(11));
                    else
                        Qt.openUrlExternally(link);
                }
        }
    }
}

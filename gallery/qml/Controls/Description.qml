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

        Text {
            id: titleText
            width: parent.width
            visible: text.length !== 0
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySizeHeading3
                weight: Font.DemiBold
            }
            color: DelTheme.Primary.colorTextBase
        }

        Text {
            id: descText
            width: parent.width
            lineHeight: 1.1
            visible: text.length !== 0
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySize
            }
            color: DelTheme.Primary.colorTextBase
            textFormat: Text.MarkdownText
            wrapMode: Text.WrapAnywhere
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

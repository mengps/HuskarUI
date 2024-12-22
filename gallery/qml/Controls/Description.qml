import QtQuick
import DelegateUI

Item {
    id: root

    width: parent.width
    height: column.height

    property alias desc: descText.text

    Column {
        id: column
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Text {
            id: descText
            width: parent.width
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySize
            }
            color: DelTheme.Primary.colorTextBase
            textFormat: Text.MarkdownText
            wrapMode: Text.WrapAnywhere
        }
    }
}

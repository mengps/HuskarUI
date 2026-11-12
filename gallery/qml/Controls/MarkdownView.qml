import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

Flickable {
    id: root

    property string markdown: ''

    contentWidth: width
    contentHeight: markdownText.implicitHeight + 40
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    ScrollBar.vertical: HusScrollBar { }

    onMarkdownChanged: contentY = 0;

    HusText {
        id: markdownText
        x: 24
        y: 20
        width: root.width - 48
        textFormat: Text.MarkdownText
        text: root.markdown
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        color: HusTheme.Primary.colorTextBase
        lineHeight: 1.3
        onLinkActivated: (link) => Qt.openUrlExternally(link);
    }
}

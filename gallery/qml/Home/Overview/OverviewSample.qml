import QtQuick

QtObject {
    required property string key
    required property Component content
    property size normalSize: Qt.size(288, 136)
    property size compactSize: Qt.size(248, 126)
}

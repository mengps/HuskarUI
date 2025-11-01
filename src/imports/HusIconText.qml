import QtQuick
import HuskarUI.Basic

HusText {
    id: control

    readonly property bool empty: iconSource === 0 || iconSource === ''
    property var iconSource: 0 ?? ''
    property alias iconSize: control.font.pixelSize
    property alias colorIcon: control.color
    property string contentDescription: text

    objectName: '__HusIconText__'
    width: __iconLoader.active ? (__iconLoader.implicitWidth + leftPadding + rightPadding): implicitWidth
    height: __iconLoader.active ? (__iconLoader.implicitHeight + topPadding + bottomPadding) : implicitHeight
    text: __iconLoader.active ? '' : String.fromCharCode(iconSource)
    font.family: 'HuskarUI-Icons'
    font.pixelSize: parseInt(HusTheme.HusIconText.fontSize)
    color: HusTheme.HusIconText.colorText

    Loader {
        id: __iconLoader
        anchors.centerIn: parent
        active: typeof iconSource == 'string' && iconSource !== ''
        sourceComponent: Image {
            source: control.iconSource
            width: control.iconSize
            height: control.iconSize
            sourceSize: Qt.size(width, height)
        }
    }

    Accessible.role: Accessible.Graphic
    Accessible.name: control.text
    Accessible.description: control.contentDescription
}

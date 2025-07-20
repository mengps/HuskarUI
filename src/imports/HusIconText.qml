import QtQuick
import HuskarUI.Basic

HusText {
    id: control

    property int iconSource: 0
    property alias iconSize: control.font.pixelSize
    property alias colorIcon: control.color
    property string contentDescription: text

    objectName: '__HusIconText__'
    text: String.fromCharCode(iconSource)
    font.family: 'HuskarUI-Icons'
    font.pixelSize: HusTheme.HusIconText.fontSize
    color: HusTheme.HusIconText.colorText

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text
    Accessible.description: control.contentDescription
}

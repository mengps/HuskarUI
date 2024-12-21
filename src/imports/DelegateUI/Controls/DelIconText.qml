import QtQuick
import DelegateUI

Text {
    id: control

    property int iconSource: 0
    property alias iconSize: control.font.pixelSize
    property alias iconColor: control.color
    property string contentDescription: text

    text: String.fromCharCode(iconSource)
    font.family: __loader.name
    font.pixelSize: DelTheme.DelIconText.fontSize
    color: DelTheme.DelIconText.colorText

    FontLoader {
        id: __loader
        source: "qrc:/DelegateUI/resources/font/DelegateUI-Icons.ttf"
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text
    Accessible.description: control.contentDescription
}

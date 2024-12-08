import QtQuick
import DelegateUI

Text {
    property int iconSource: 0

    text: String.fromCharCode(iconSource)
    font.family: __loader.name
    font.pixelSize: DelTheme.DelIconText.fontSize
    color: DelTheme.DelIconText.colorText

    FontLoader {
        id: __loader
        source: "qrc:/DelegateUI/resources/font/delfont.ttf"
    }
}

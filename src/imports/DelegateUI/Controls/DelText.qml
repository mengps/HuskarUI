import QtQuick
import DelegateUI

Text {
    id: control

    renderType: DelTheme.textRenderType
    color: DelTheme.Primary.colorTextBase
    font {
        family: DelTheme.Primary.fontPrimaryFamily
        pixelSize: DelTheme.Primary.fontPrimarySize
    }
}

import QtQuick
import HuskarUI.Basic

Text {
    id: control

    objectName: '__HusText__'
    renderType: HusTheme.textRenderType
    color: HusTheme.Primary.colorTextBase
    font {
        family: HusTheme.Primary.fontPrimaryFamily
        pixelSize: parseInt(HusTheme.Primary.fontPrimarySize)
    }
}

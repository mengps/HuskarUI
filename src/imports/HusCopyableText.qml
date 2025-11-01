import QtQuick
import HuskarUI.Basic

TextEdit {
    id: control

    objectName: '__HusCopyableText__'
    readOnly: true
    renderType: HusTheme.textRenderType
    color: HusTheme.HusCopyableText.colorText
    selectByMouse: true
    selectByKeyboard: true
    selectedTextColor: HusTheme.HusCopyableText.colorTextSelected
    selectionColor: HusTheme.HusCopyableText.colorSelection
    font {
        family: HusTheme.HusCopyableText.fontFamily
        pixelSize: parseInt(HusTheme.HusCopyableText.fontSize)
    }
}

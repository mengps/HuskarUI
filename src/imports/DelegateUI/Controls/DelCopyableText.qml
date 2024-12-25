import QtQuick
import DelegateUI

TextEdit {
    id: control

    readOnly: true
    color: DelTheme.DelCopyableText.colorText
    selectByMouse: true
    selectByKeyboard: true
    selectedTextColor: DelTheme.DelCopyableText.colorSelectedText
    selectionColor: DelTheme.DelCopyableText.colorSelection
    font {
        family: DelTheme.DelCopyableText.fontFamily
        pixelSize: DelTheme.DelCopyableText.fontSize
    }
}

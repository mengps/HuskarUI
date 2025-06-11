import QtQuick
import DelegateUI

DelIconButton {
    id: control

    property bool isError: false

    leftPadding: 12
    rightPadding: 12
    radiusBg: 0
    hoverCursorShape: Qt.ArrowCursor
    type: DelButton.Type_Text
    iconSize: DelTheme.DelCaptionButton.fontSize
    effectEnabled: false
    colorIcon: {
        if (enabled) {
            return checked ? DelTheme.DelCaptionButton.colorIconChecked :
                             DelTheme.DelCaptionButton.colorIcon;
        } else {
            return DelTheme.DelCaptionButton.colorIconDisabled;
        }
    }
    colorBg: {
        if (enabled) {
            if (isError) {
                return control.down ? DelTheme.DelCaptionButton.colorErrorBgActive:
                                      control.hovered ? DelTheme.DelCaptionButton.colorErrorBgHover :
                                                        DelTheme.DelCaptionButton.colorErrorBg;
            } else {
                return control.down ? DelTheme.DelCaptionButton.colorBgActive:
                                      control.hovered ? DelTheme.DelCaptionButton.colorBgHover :
                                                        DelTheme.DelCaptionButton.colorBg;
            }
        } else {
            return DelTheme.DelCaptionButton.colorBgDisabled;
        }
    }
}

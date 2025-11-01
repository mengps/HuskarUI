import QtQuick
import HuskarUI.Basic

HusIconButton {
    id: control

    property bool isError: false
    property bool noDisabledState: false

    objectName: '__HusCaptionButton__'
    leftPadding: 12 * sizeRatio
    rightPadding: 12 * sizeRatio
    radiusBg.all: 0
    hoverCursorShape: Qt.ArrowCursor
    type: HusButton.Type_Text
    iconSize: parseInt(HusTheme.HusCaptionButton.fontSize)
    effectEnabled: false
    colorIcon: {
        if (enabled || noDisabledState) {
            return checked ? HusTheme.HusCaptionButton.colorIconChecked :
                             HusTheme.HusCaptionButton.colorIcon;
        } else {
            return HusTheme.HusCaptionButton.colorIconDisabled;
        }
    }
    colorBg: {
        if (enabled || noDisabledState) {
            if (isError) {
                return control.down ? HusTheme.HusCaptionButton.colorErrorBgActive:
                                      control.hovered ? HusTheme.HusCaptionButton.colorErrorBgHover :
                                                        HusTheme.HusCaptionButton.colorErrorBg;
            } else {
                return control.down ? HusTheme.HusCaptionButton.colorBgActive:
                                      control.hovered ? HusTheme.HusCaptionButton.colorBgHover :
                                                        HusTheme.HusCaptionButton.colorBg;
            }
        } else {
            return HusTheme.HusCaptionButton.colorBgDisabled;
        }
    }
}

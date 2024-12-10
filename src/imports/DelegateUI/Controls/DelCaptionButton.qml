import QtQuick
import DelegateUI

DelIconButton {
    id: control

    property bool isError: false

    width: 40
    height: 30
    radiusBg: 0
    type: DelButtonType.Type_Text
    iconSize: DelTheme.DelCaptionButton.fontSize
    effectEnabled: false
    colorIcon: {
        if (enabled) {
            return checked ? DelTheme.DelCaptionButton.colorIconChecked :
                             DelTheme.DelCaptionButton.colorIcon;
        } else {
            return DelTheme.Primary.colorPrimaryTextDisabled;
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
            return DelTheme.Primary.colorPrimaryContainerBgDisabled;
        }
    }
}

import QtQuick
import DelegateUI

DelButton {
    id: control

    property int iconSource: 0
    property int iconSize: DelTheme.DelButton.fontSize
    property int iconSpacing: 5
    property int iconPosition: DelButtonType.Position_Start
    property color colorIcon: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default:
                return control.down ? DelTheme.DelButton.colorIconActive :
                                      control.hovered ? DelTheme.DelButton.colorIconHover :
                                                        DelTheme.Primary.colorTextBase;
            case DelButtonType.Type_Outlined:
                return control.down ? DelTheme.DelButton.colorIconActive :
                                      control.hovered ? DelTheme.DelButton.colorIconHover :
                                                        DelTheme.DelButton.colorIcon;
            case DelButtonType.Type_Primary: return "white";
            case DelButtonType.Type_Filled: return DelTheme.DelButton.colorIcon;
            default: return DelTheme.DelButton.colorIcon;
            }
        } else {
            return DelTheme.Primary.colorPrimaryTextDisabled;
        }
    }
    contentItem: Row {
        spacing: control.iconSpacing
        layoutDirection: control.iconPosition === DelButtonType.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

        DelIconText {
            height: parent.height
            color: control.colorIcon
            iconSource: control.iconSource
            iconSize: control.iconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
        }

        Text {
            text: control.text
            font: control.font
            lineHeight: DelTheme.DelButton.fontLineHeight
            color: control.colorText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
        }
    }
}

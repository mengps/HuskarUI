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
                                                        DelTheme.DelButton.colorTextBase;
            case DelButtonType.Type_Outlined:
                return control.down ? DelTheme.DelButton.colorIconActive :
                                      control.hovered ? DelTheme.DelButton.colorIconHover :
                                                        DelTheme.DelButton.colorIcon;
            case DelButtonType.Type_Primary: return "white";
            case DelButtonType.Type_Filled: return DelTheme.DelButton.colorIcon;
            default: return DelTheme.DelButton.colorIcon;
            }
        } else {
            return DelTheme.DelButton.coloTextDisabled;
        }
    }
    contentItem: Item {
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)
        implicitWidth: __row.implicitWidth

        Row {
            id: __row
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.iconSpacing
            layoutDirection: control.iconPosition === DelButtonType.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

            DelIconText {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                color: control.colorIcon
                iconSource: control.iconSource
                verticalAlignment: Text.AlignVCenter

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }

            Text {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: control.text
                font: control.font
                lineHeight: DelTheme.DelButton.fontLineHeight
                color: control.colorText
                elide: Text.ElideRight

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }
        }
    }
}

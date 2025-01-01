import QtQuick
import DelegateUI

DelButton {
    id: control

    property int iconSource: 0
    property int iconSize: DelTheme.DelButton.fontSize
    property int iconSpacing: 5
    property int iconPosition: DelButtonType.Position_Start
    property color colorIcon: colorText
    contentItem: Item {
        implicitWidth: __row.implicitWidth
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

        Row {
            id: __row
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.iconSpacing
            layoutDirection: control.iconPosition === DelButtonType.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

            DelIconText {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                color: control.colorIcon
                iconSize: control.iconSize
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

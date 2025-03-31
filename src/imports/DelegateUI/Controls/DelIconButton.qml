import QtQuick
import DelegateUI

DelButton {
    id: control

    enum IconPosition {
        Position_Start = 0,
        Position_End = 1
    }

    property bool loading: false
    property int iconSource: 0
    property int iconSize: DelTheme.DelButton.fontSize
    property int iconSpacing: 5
    property int iconPosition: DelIconButton.Position_Start
    property color colorIcon: colorText

    contentItem: Item {
        implicitWidth: __row.implicitWidth
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

        Row {
            id: __row
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.iconSpacing
            layoutDirection: control.iconPosition === DelIconButton.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

            DelIconText {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                color: control.colorIcon
                iconSize: control.iconSize
                iconSource: control.loading ? DelIcon.LoadingOutlined : control.iconSource
                verticalAlignment: Text.AlignVCenter

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

                NumberAnimation on rotation {
                    running: control.loading
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1000
                }
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

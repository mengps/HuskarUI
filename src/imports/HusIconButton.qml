import QtQuick
import HuskarUI.Basic

HusButton {
    id: control

    enum IconPosition {
        Position_Start = 0,
        Position_End = 1
    }

    property bool loading: false
    property var iconSource: 0 ?? ''
    property int iconSize: HusTheme.HusButton.fontSize
    property int iconSpacing: 5
    property int iconPosition: HusIconButton.Position_Start
    property color colorIcon: colorText

    objectName: '__HusIconButton__'
    contentItem: Item {
        implicitWidth: __row.implicitWidth
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

        Row {
            id: __row
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.iconSpacing
            layoutDirection: control.iconPosition === HusIconButton.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

            HusIconText {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                color: control.colorIcon
                iconSize: control.iconSize
                iconSource: control.loading ? HusIcon.LoadingOutlined : control.iconSource
                verticalAlignment: Text.AlignVCenter

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

                NumberAnimation on rotation {
                    running: control.loading
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1000
                }
            }

            HusText {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: control.text
                font: control.font
                lineHeight: HusTheme.HusButton.fontLineHeight
                color: control.colorText
                elide: Text.ElideRight

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            }
        }
    }
}

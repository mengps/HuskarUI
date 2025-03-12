import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Switch {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool loading: false
    property string checkedText: ""
    property string uncheckedText: ""
    property int checkedIconSource: 0
    property int uncheckedIconSource: 0
    property string contentDescription: ""
    property int radiusBg: __bg.height * 0.5
    property color colorHandle: DelTheme.DelSwitch.colorHandle
    property color colorBg: {
        if (!enabled)
            return checked ? DelTheme.DelSwitch.colorCheckedBgDisabled : DelTheme.DelSwitch.colorBgDisabled;

        if (checked)
            return control.down ? DelTheme.DelSwitch.colorCheckedBgActive :
                                  control.hovered ? DelTheme.DelSwitch.colorCheckedBgHover :
                                                    DelTheme.DelSwitch.colorCheckedBg;
        else
            return control.down ? DelTheme.DelSwitch.colorBgActive :
                                  control.hovered ? DelTheme.DelSwitch.colorBgHover :
                                                    DelTheme.DelSwitch.colorBg;
    }
    property Component handleDelegate: Rectangle {
        radius: height * 0.5
        color: control.colorHandle

        DelIconText {
            anchors.centerIn: parent
            iconSize: parent.height - 4
            iconSource: DelIcon.LoadingOutlined
            colorIcon: control.colorBg
            visible: control.loading
            transformOrigin: Item.Center

            NumberAnimation on rotation {
                running: control.loading
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }
    }

    width: implicitIndicatorWidth + leftPadding + rightPadding
    height: implicitIndicatorHeight + topPadding + bottomPadding
    font {
        family: DelTheme.DelSwitch.fontFamily
        pixelSize: DelTheme.DelSwitch.fontSize - 2
    }
    indicator: Item {
        implicitWidth: __bg.width
        implicitHeight: __bg.height

        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.radius
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: "transparent"
            border.width: 0
            border.color: control.enabled ? DelTheme.DelSwitch.colorBgHover : "transparent"
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: "width"; from: __bg.width + 3; to: __bg.width + 8;
                    duration: DelTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: "height"; from: __bg.height + 3; to: __bg.height + 8;
                    duration: DelTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: "opacity"; from: 0.2; to: 0;
                    duration: DelTheme.Primary.durationSlow
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled && control.effectEnabled) {
                        __effect.border.width = 8;
                        __animation.restart();
                    }
                }
            }
        }
        Rectangle {
            id: __bg
            width: Math.max(Math.max(checkedWidth, uncheckedWidth) + __handle.width, height * 2)
            height: hasText ? Math.max(checkedHeight, uncheckedHeight, 22) : 22
            anchors.centerIn: parent
            radius: control.radiusBg
            color: control.colorBg
            clip: true

            property bool hasText: control.checkedIconSource !== 0 || control.uncheckedIconSource !== 0  ||
                                   control.checkedText.length !== 0 || control.uncheckedText.length !== 0
            property real checkedWidth: control.checkedIconSource == 0 ? __checkedText.width + 6 : __checkedIcon.width + 6
            property real uncheckedWidth: control.checkedIconSource == 0 ? __uncheckedText.width + 6 : __uncheckedIcon.width + 6
            property real checkedHeight: control.checkedIconSource == 0 ? __checkedText.height + 4 : __checkedIcon.height + 4
            property real uncheckedHeight: control.checkedIconSource == 0 ? __uncheckedText.height + 4 : __uncheckedIcon.height + 4

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }

            Text {
                id: __checkedText
                width: text.length === 0 ? 0 : Math.max(implicitWidth + 8, __uncheckedText.implicitWidth + 8)
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: __handle.left
                font: control.font
                text: control.checkedText
                color: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: !__checkedIcon.visible
            }

            Text {
                id: __uncheckedText
                width: text.length === 0 ? 0 : Math.max(implicitWidth + 8, __checkedText.implicitWidth + 8)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: __handle.right
                font: control.font
                text: control.uncheckedText
                color: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: !__uncheckedIcon.visible
            }

            DelIconText {
                id: __checkedIcon
                width: text.length === 0 ? 0 : implicitWidth + 8
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: __handle.left
                iconSize: control.font.pixelSize
                iconSource: control.checkedIconSource
                colorIcon: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: iconSource != 0
            }

            DelIconText {
                id: __uncheckedIcon
                width: text.length === 0 ? 0 : implicitWidth + 8
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: __handle.right
                iconSize: control.font.pixelSize
                iconSource: control.uncheckedIconSource
                colorIcon: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: iconSource != 0
            }

            Loader {
                id: __handle
                x: control.checked ? (parent.width - width - 2) : 2
                width: height
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: handleDelegate

                Behavior on x { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }
            }
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.checked ? control.checkedText : control.uncheckedText
    Accessible.description: control.contentDescription
    Accessible.onToggleAction: control.toggle();
}

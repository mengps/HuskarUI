import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.RadioButton {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property int radiusIndicator: 8
    property color colorText: enabled ? DelTheme.DelRadio.colorText : DelTheme.DelRadio.colorTextDisabled
    property color colorIndicator: enabled ?
                                       checked ? DelTheme.DelRadio.colorIndicatorChecked :
                                                 DelTheme.DelRadio.colorIndicator : DelTheme.DelRadio.colorIndicatorDisabled
    property color colorIndicatorBorder: (enabled && (hovered || checked)) ? DelTheme.DelRadio.colorIndicatorBorderChecked :
                                                                             DelTheme.DelRadio.colorIndicatorBorder
    property string contentDescription: ""

    font {
        family: DelTheme.DelRadio.fontFamily
        pixelSize: DelTheme.DelRadio.fontSize
    }

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight, implicitIndicatorHeight) + topPadding + bottomPadding
    spacing: 8
    indicator: Item {
        x: control.leftPadding
        implicitWidth: __bg.width
        implicitHeight: __bg.height
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: width * 0.5
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: "transparent"
            border.width: 0
            border.color: control.enabled ? DelTheme.DelRadio.colorEffectBg : "transparent"
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
            width: control.radiusIndicator * 2
            height: width
            anchors.centerIn: parent
            radius: height * 0.5
            color: control.colorIndicator
            border.color: control.colorIndicatorBorder
            border.width: control.checked ? 0 : 1

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

            Rectangle {
                width: control.checked ? control.radiusIndicator - 2 : 0
                height: width
                anchors.centerIn: parent
                radius: width * 0.5

                Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }
            }
        }
    }
    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
    background: Item { }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}

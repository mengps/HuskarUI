import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.RadioButton {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property color colorText: enabled ? HusTheme.HusRadio.colorText : HusTheme.HusRadio.colorTextDisabled
    property color colorIndicator: enabled ?
                                       checked ? HusTheme.HusRadio.colorIndicatorChecked :
                                                 HusTheme.HusRadio.colorIndicator : HusTheme.HusRadio.colorIndicatorDisabled
    property color colorIndicatorBorder: (enabled && (hovered || checked)) ? HusTheme.HusRadio.colorIndicatorBorderChecked :
                                                                             HusTheme.HusRadio.colorIndicatorBorder
    property HusRadius radiusIndicator: HusRadius { all: HusTheme.HusRadio.radiusIndicator }
    property string contentDescription: ''

    objectName: '__HusRadio__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight, implicitIndicatorHeight) + topPadding + bottomPadding
    font {
        family: HusTheme.HusRadio.fontFamily
        pixelSize: parseInt(HusTheme.HusRadio.fontSize)
    }
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
            color: 'transparent'
            border.width: 0
            border.color: control.enabled ? HusTheme.HusRadio.colorEffectBg : 'transparent'
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'opacity'; from: 0.2; to: 0;
                    duration: HusTheme.Primary.durationSlow
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
            width: control.radiusIndicator.all * 2
            height: width
            anchors.centerIn: parent
            radius: height * 0.5
            color: control.colorIndicator
            border.color: control.colorIndicatorBorder
            border.width: control.checked ? 0 : 1

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

            Rectangle {
                width: control.checked ? control.radiusIndicator.all - 2 : 0
                height: width
                anchors.centerIn: parent
                radius: width * 0.5

                Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
            }
        }
    }
    contentItem: HusText {
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

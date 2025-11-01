import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.Switch {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool loading: false
    property string checkedText: ''
    property string uncheckedText: ''
    property var checkedIconSource: 0 ?? ''
    property var uncheckedIconSource: 0 ?? ''
    property color colorHandle: HusTheme.HusSwitch.colorHandle
    property color colorBg: {
        if (!enabled)
            return checked ? HusTheme.HusSwitch.colorBgCheckedDisabled : HusTheme.HusSwitch.colorBgDisabled;

        if (checked)
            return control.down ? HusTheme.HusSwitch.colorBgCheckedActive :
                                  control.hovered ? HusTheme.HusSwitch.colorBgCheckedHover :
                                                    HusTheme.HusSwitch.colorBgChecked;
        else
            return control.down ? HusTheme.HusSwitch.colorBgActive :
                                  control.hovered ? HusTheme.HusSwitch.colorBgHover :
                                                    HusTheme.HusSwitch.colorBg;
    }
    property HusRadius radiusBg: HusRadius { all: control.implicitIndicatorHeight * 0.5 }
    property string contentDescription: ''
    property Component handleDelegate: Rectangle {
        radius: height * 0.5
        color: control.colorHandle

        HusIconText {
            anchors.centerIn: parent
            iconSize: parent.height - 4
            iconSource: HusIcon.LoadingOutlined
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

    objectName: '__HusSwitch__'
    width: implicitIndicatorWidth + leftPadding + rightPadding
    height: implicitIndicatorHeight + topPadding + bottomPadding
    font {
        family: HusTheme.HusSwitch.fontFamily
        pixelSize: parseInt(HusTheme.HusSwitch.fontSize) - 2
    }
    indicator: Item {
        implicitWidth: __bg.width
        implicitHeight: __bg.height

        HusRectangleInternal {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.radius
            topLeftRadius: __bg.topLeftRadius
            topRightRadius: __bg.topRightRadius
            bottomLeftRadius: __bg.bottomLeftRadius
            bottomRightRadius: __bg.bottomRightRadius
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: 'transparent'
            border.width: 0
            border.color: control.enabled ? HusTheme.HusSwitch.colorBgHover : 'transparent'
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

        HusRectangleInternal {
            id: __bg
            width: Math.max(Math.max(checkedWidth, uncheckedWidth) + __handle.width, height * 2)
            height: hasContent ? Math.max(checkedHeight, uncheckedHeight, 22) : 22
            anchors.centerIn: parent
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg
            clip: true

            property bool hasCheckedIcon: control.checkedIconSource !== 0 && control.checkedIconSource !== ''
            property bool hasUncheckedIcon: control.uncheckedIconSource !== 0 && control.uncheckedIconSource !== ''
            property bool hasContent: hasCheckedIcon || hasUncheckedIcon ||
                                      control.checkedText.length !== 0 || control.uncheckedText.length !== 0
            property real checkedWidth: !hasCheckedIcon ? __checkedText.width + 6 :  __checkedIcon.width + 6
            property real uncheckedWidth: !hasUncheckedIcon ? __uncheckedText.width + 6 : __uncheckedIcon.width + 6
            property real checkedHeight: !hasCheckedIcon ? __checkedText.height + 4 : __checkedIcon.height + 4
            property real uncheckedHeight: !hasUncheckedIcon ? __uncheckedText.height + 4 : __uncheckedIcon.height + 4

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

            HusText {
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

            HusText {
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

            HusIconText {
                id: __checkedIcon
                leftPadding: 4
                rightPadding: 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: __handle.left
                iconSize: control.font.pixelSize
                iconSource: control.checkedIconSource
                colorIcon: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: !empty
            }

            HusIconText {
                id: __uncheckedIcon
                leftPadding: 4
                rightPadding: 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: __handle.right
                iconSize: control.font.pixelSize
                iconSource: control.uncheckedIconSource
                colorIcon: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: !empty
            }

            Loader {
                id: __handle
                x: control.checked ? (parent.width - (control.pressed ? height + 6 : height) - 2) : 2
                width: control.pressed ? height + 6 : height
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: handleDelegate

                Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
                Behavior on x { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
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

import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Button {
    id: control

    property bool animationEnabled: true //不绑定 DelTheme.animationEnabled
    property int type: DelButtonType.Type_Default
    property int shape: DelButtonType.Shape_Default
    property int iconSource: 0
    property int radiusBg: DelTheme.DelIconButton.radiusBg
    property color colorIcon: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default:
                return control.down ? DelTheme.DelIconButton.colorIconActive :
                                      control.hovered ? DelTheme.DelIconButton.colorIconHover :
                                                        DelTheme.DelIconButton.colorIcon
            case DelButtonType.Type_Primary: return "white";
            default: return DelTheme.DelIconButton.colorIcon;
            }
        } else {
            return DelTheme.Primary.colorPrimaryTextDisabled;
        }
    }
    property color colorBg: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default:
                return control.down ? DelTheme.DelIconButton.colorBgActive :
                                      control.hovered ? DelTheme.DelIconButton.colorBgHover :
                                                        DelTheme.DelIconButton.colorBg;
            case DelButtonType.Type_Primary:
                return control.down ? DelTheme.Primary.colorPrimaryContainerBgActive:
                                      control.hovered ? DelTheme.Primary.colorPrimaryContainerBgHover :
                                                        DelTheme.Primary.colorPrimaryContainerBg;
            default: return DelTheme.DelIconButton.colorBg;
            }
        } else {
            return DelTheme.Primary.colorPrimaryContainerBgDisabled;
        }
    }
    property color colorBorder: enabled ? (control.down ? DelTheme.DelIconButton.colorBorderActive :
                                                          control.hovered ? DelTheme.DelIconButton.colorBorderHover :
                                                                            DelTheme.DelIconButton.colorBorder) :
                                          DelTheme.DelIconButton.colorBorder
    property string contentDescription: ""

    width: implicitContentWidth + leftPadding + rightPadding
    height: implicitContentHeight + topPadding + bottomPadding
    topPadding: 8
    bottomPadding: 8
    font.pixelSize: DelTheme.DelIconButton.fontSize
    contentItem: DelIconText {
        iconSource: control.iconSource
        color: control.colorIcon
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font {
            pixelSize: control.font.pixelSize
            bold: control.font.bold
            italic: control.font.italic
            underline: control.font.underline
        }

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    }
    background: Item {
        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.radius
            anchors.centerIn: parent
            color: "transparent"
            border.width: control.down || control.hovered ? 12 : 0
            border.color: control.enabled ? DelTheme.DelIconButton.colorBorderHover : "transparent"
            opacity: 0.6

            ParallelAnimation {
                id: __animation
                NumberAnimation {
                    target: __effect; property: "width"; from: __bg.width; to: __bg.width + 12;
                    duration: DelTheme.Primary.durationMid
                }
                NumberAnimation {
                    target: __effect; property: "height"; from: __bg.height; to: __bg.height + 12;
                    duration: DelTheme.Primary.durationMid
                }
                NumberAnimation {
                    target: __effect; property: "opacity"; from: 0.6; to: 0;
                    duration: DelTheme.Primary.durationMid
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled)
                        __animation.restart();
                }
            }
        }
        Rectangle {
            id: __bg
            width: control.pressed ? realWidth - 1 : realWidth
            height: control.pressed ? realHeight - 1 : realHeight
            anchors.centerIn: parent
            radius: control.shape == DelButtonType.Shape_Default ? control.radiusBg : height * 0.5
            color: control.colorBg
            border.color: control.colorBorder

            property real realWidth: control.shape == DelButtonType.Shape_Default ? parent.width : parent.height
            property real realHeight: control.shape == DelButtonType.Shape_Default ? parent.height : parent.height

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked();
}

import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Button {
    id: control

    enum ButtonType {
        Type_Default = 0,
        Type_Primary = 1
    }

    enum ButtonShape {
        Shape_Default = 0,
        Shape_Circle = 1
    }

    property bool animationEnabled: true //不绑定 DelTheme.animationEnabled
    property int type: DelButton.Type_Default
    property int shape: DelButton.Shape_Default
    property color colorText: {
        if (enabled) {
            switch(control.type)
            {
            case DelButton.Type_Default:
                return control.down ? DelTheme.DelButton.colorTextActive :
                                      control.hovered ? DelTheme.DelButton.colorTextHover :
                                                        DelTheme.DelButton.colorText
            case DelButton.Type_Primary: return "white";
            default: return DelTheme.DelButton.colorText;
            }
        } else {
            return DelTheme.Primary.colorPrimaryTextDisabled;
        }
    }
    property color colorBg: {
        if (enabled) {
            switch(control.type)
            {
            case DelButton.Type_Default:
                return control.down ? DelTheme.DelButton.colorBgActive :
                                      control.hovered ? DelTheme.DelButton.colorBgHover :
                                                        DelTheme.DelButton.colorBg;
            case DelButton.Type_Primary:
                return control.down ? DelTheme.Primary.colorPrimaryContainerBgActive:
                                      control.hovered ? DelTheme.Primary.colorPrimaryContainerBgHover :
                                                        DelTheme.Primary.colorPrimaryContainerBg;
            default: return DelTheme.DelButton.colorBg;
            }
        } else {
            return DelTheme.Primary.colorPrimaryContainerBgDisabled;
        }
    }
    property color colorBorder: enabled ? (control.down ? DelTheme.DelButton.colorBorderActive :
                                                          control.hovered ? DelTheme.DelButton.colorBorderHover :
                                                                            DelTheme.DelButton.colorBorder) :
                                          DelTheme.DelButton.colorBorder
    property string contentDescription: text

    width: implicitContentWidth + leftPadding + rightPadding
    height: implicitContentHeight + topPadding + bottomPadding
    padding: 10
    topPadding: 8
    bottomPadding: 8
    font {
        family: DelTheme.DelButton.fontFamily
        pixelSize: DelTheme.DelButton.fontSize
    }
    contentItem: Text {
        text: control.text
        font: control.font
        lineHeight: DelTheme.DelButton.fontLineHeight
        color: control.colorText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    }
    background: Item {
        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: control.shape == DelButton.Shape_Default ? DelTheme.DelButton.radiusBg : height * 0.5
            anchors.centerIn: parent
            color: "transparent"
            border.width: 12
            border.color: control.enabled ? DelTheme.DelButton.colorBorderHover : "transparent"
            opacity: 0.7

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
                    target: __effect; property: "opacity"; from: 0.7; to: 0;
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
            radius: control.shape == DelButton.Shape_Default ? DelTheme.DelButton.radiusBg : height * 0.5
            color: control.colorBg
            border.color: control.colorBorder

            property real realWidth: control.shape == DelButton.Shape_Default ? parent.width : parent.height
            property real realHeight: control.shape == DelButton.Shape_Default ? parent.height : parent.height

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked();
}

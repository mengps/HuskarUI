import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Button {
    id: control

    property bool animationEnabled: true //不绑定 DelTheme.animationEnabled
    property int type: DelButtonType.Type_Outlined
    property int shape: DelButtonType.Shape_Default
    property int radiusBg: DelTheme.DelButton.radiusBg
    property color colorText: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Outlined:
                return control.down ? DelTheme.DelButton.colorTextActive :
                                      control.hovered ? DelTheme.DelButton.colorTextHover :
                                                        DelTheme.DelButton.colorText;
            case DelButtonType.Type_Primary: return "white";
            case DelButtonType.Type_Filled: return DelTheme.DelButton.colorText;
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
            case DelButtonType.Type_Outlined:
                return control.down ? DelTheme.DelButton.colorBgActive :
                                      control.hovered ? DelTheme.DelButton.colorBgHover :
                                                        DelTheme.DelButton.colorBg;
            case DelButtonType.Type_Primary:
                return control.down ? DelTheme.Primary.colorPrimaryContainerBgActive:
                                      control.hovered ? DelTheme.Primary.colorPrimaryContainerBgHover :
                                                        DelTheme.Primary.colorPrimaryContainerBg;
            case DelButtonType.Type_Filled:
                if (DelTheme.isDark) {
                    return control.down ? DelTheme.DelButton.colorFillBgActive:
                                          control.hovered ? DelTheme.DelButton.colorFillBgHover :
                                                            DelTheme.DelButton.colorFillBg;
                } else {
                    return control.down ? DelTheme.Primary.colorPrimaryBgActive:
                                          control.hovered ? DelTheme.Primary.colorPrimaryBgHover :
                                                            DelTheme.Primary.colorPrimaryBg;
                }
            case DelButtonType.Type_Text:
                if (DelTheme.isDark) {
                    return control.down ? DelTheme.DelButton.colorFillBgHover:
                                          control.hovered ? DelTheme.DelButton.colorFillBg :
                                                            DelTheme.DelButton.colorBg;
                } else {
                    return control.down ? DelTheme.Primary.colorPrimaryBgHover:
                                          control.hovered ? DelTheme.Primary.colorPrimaryBg :
                                                            DelTheme.DelButton.colorBg;
                }
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
            radius: __bg.radius
            anchors.centerIn: parent
            color: "transparent"
            border.width: 0
            border.color: control.enabled ? DelTheme.DelButton.colorBorderHover : "transparent"
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
                    if (control.animationEnabled) {
                        __effect.border.width = 8;
                        __animation.restart();
                    }
                }
            }
        }
        Rectangle {
            id: __bg
            width: realWidth
            height: realHeight
            anchors.centerIn: parent
            radius: control.shape == DelButtonType.Shape_Default ? control.radiusBg : height * 0.5
            color: control.colorBg
            border.width: (control.type == DelButtonType.Type_Filled || control.type == DelButtonType.Type_Text) ? 0 : 1
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

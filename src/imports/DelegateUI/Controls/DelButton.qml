import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Button {
    id: control

    enum Type {
        Type_Default = 0,
        Type_Outlined = 1,
        Type_Primary = 2,
        Type_Filled = 3,
        Type_Text = 4,
        Type_Link = 5
    }

    enum Shape {
        Shape_Default = 0,
        Shape_Circle = 1
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property int type: DelButton.Type_Default
    property int shape: DelButton.Shape_Default
    property int radiusBg: DelTheme.DelButton.radiusBg
    property color colorText: {
        if (enabled) {
            switch(control.type)
            {
            case DelButton.Type_Default:
                return control.down ? DelTheme.DelButton.colorTextActive :
                                      control.hovered ? DelTheme.DelButton.colorTextHover :
                                                        DelTheme.DelButton.colorTextDefault;
            case DelButton.Type_Outlined:
                return control.down ? DelTheme.DelButton.colorTextActive :
                                      control.hovered ? DelTheme.DelButton.colorTextHover :
                                                        DelTheme.DelButton.colorText;
            case DelButton.Type_Primary: return "white";
            case DelButton.Type_Filled:
            case DelButton.Type_Text:
            case DelButton.Type_Link:
                return control.down ? DelTheme.DelButton.colorTextActive :
                                      control.hovered ? DelTheme.DelButton.colorTextHover :
                                                        DelTheme.DelButton.colorText;
            default: return DelTheme.DelButton.colorText;
            }
        } else {
            return DelTheme.DelButton.colorTextDisabled;
        }
    }
    property color colorBg: {
        if (type == DelButton.Type_Link) return "transparent";
        if (enabled) {
            switch(control.type)
            {
            case DelButton.Type_Default:
            case DelButton.Type_Outlined:
                return control.down ? DelTheme.DelButton.colorBgActive :
                                      control.hovered ? DelTheme.DelButton.colorBgHover :
                                                        DelTheme.DelButton.colorBg;
            case DelButton.Type_Primary:
                return control.down ? DelTheme.DelButton.colorPrimaryBgActive:
                                      control.hovered ? DelTheme.DelButton.colorPrimaryBgHover :
                                                        DelTheme.DelButton.colorPrimaryBg;
            case DelButton.Type_Filled:
                if (DelTheme.isDark) {
                    return control.down ? DelTheme.DelButton.colorFillBgDarkActive:
                                          control.hovered ? DelTheme.DelButton.colorFillBgDarkHover :
                                                            DelTheme.DelButton.colorFillBgDark;
                } else {
                    return control.down ? DelTheme.DelButton.colorFillBgActive:
                                          control.hovered ? DelTheme.DelButton.colorFillBgHover :
                                                            DelTheme.DelButton.colorFillBg;
                }
            case DelButton.Type_Text:
                if (DelTheme.isDark) {
                    return control.down ? DelTheme.DelButton.colorFillBgDarkActive:
                                          control.hovered ? DelTheme.DelButton.colorFillBgDarkHover :
                                                            DelTheme.DelButton.colorTextBg;
                } else {
                    return control.down ? DelTheme.DelButton.colorTextBgActive:
                                          control.hovered ? DelTheme.DelButton.colorTextBgHover :
                                                            DelTheme.DelButton.colorTextBg;
                }
            default: return DelTheme.DelButton.colorBg;
            }
        } else {
            return DelTheme.DelButton.colorBgDisabled;
        }
    }
    property color colorBorder: {
        if (type == DelButton.Type_Link) return "transparent";
        if (enabled) {
            switch(control.type)
            {
            case DelButton.Type_Default:
                return control.down ? DelTheme.DelButton.colorBorderActive :
                                      control.hovered ? DelTheme.DelButton.colorBorderHover :
                                                        DelTheme.DelButton.colorDefaultBorder;
            default:
                return control.down ? DelTheme.DelButton.colorBorderActive :
                                      control.hovered ? DelTheme.DelButton.colorBorderHover :
                                                        DelTheme.DelButton.colorBorder;
            }
        } else {
            return DelTheme.DelButton.colorBorder;
        }
    }
    property string contentDescription: text

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    padding: 15
    topPadding: 5
    bottomPadding: 5
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
            visible: control.effectEnabled && control.type != DelButton.Type_Link
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
                    if (control.animationEnabled && control.effectEnabled) {
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
            radius: control.shape == DelButton.Shape_Default ? control.radiusBg : height * 0.5
            color: control.colorBg
            border.width: (control.type == DelButton.Type_Filled || control.type == DelButton.Type_Text) ? 0 : 1
            border.color: control.enabled ? control.colorBorder : "transparent"

            property real realWidth: control.shape == DelButton.Shape_Default ? parent.width : parent.height
            property real realHeight: control.shape == DelButton.Shape_Default ? parent.height : parent.height

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}

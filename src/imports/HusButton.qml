import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

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

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property int type: HusButton.Type_Default
    property int shape: HusButton.Shape_Default
    property int radiusBg: HusTheme.HusButton.radiusBg
    property color colorText: {
        if (enabled) {
            switch(control.type)
            {
            case HusButton.Type_Default:
                return control.down ? HusTheme.HusButton.colorTextActive :
                                      control.hovered ? HusTheme.HusButton.colorTextHover :
                                                        HusTheme.HusButton.colorTextDefault;
            case HusButton.Type_Outlined:
                return control.down ? HusTheme.HusButton.colorTextActive :
                                      control.hovered ? HusTheme.HusButton.colorTextHover :
                                                        HusTheme.HusButton.colorText;
            case HusButton.Type_Primary: return 'white';
            case HusButton.Type_Filled:
            case HusButton.Type_Text:
            case HusButton.Type_Link:
                return control.down ? HusTheme.HusButton.colorTextActive :
                                      control.hovered ? HusTheme.HusButton.colorTextHover :
                                                        HusTheme.HusButton.colorText;
            default: return HusTheme.HusButton.colorText;
            }
        } else {
            return HusTheme.HusButton.colorTextDisabled;
        }
    }
    property color colorBg: {
        if (type == HusButton.Type_Link) return 'transparent';
        if (enabled) {
            switch(control.type)
            {
            case HusButton.Type_Default:
            case HusButton.Type_Outlined:
                return control.down ? HusTheme.HusButton.colorBgActive :
                                      control.hovered ? HusTheme.HusButton.colorBgHover :
                                                        HusTheme.HusButton.colorBg;
            case HusButton.Type_Primary:
                return control.down ? HusTheme.HusButton.colorPrimaryBgActive:
                                      control.hovered ? HusTheme.HusButton.colorPrimaryBgHover :
                                                        HusTheme.HusButton.colorPrimaryBg;
            case HusButton.Type_Filled:
                if (HusTheme.isDark) {
                    return control.down ? HusTheme.HusButton.colorFillBgDarkActive:
                                          control.hovered ? HusTheme.HusButton.colorFillBgDarkHover :
                                                            HusTheme.HusButton.colorFillBgDark;
                } else {
                    return control.down ? HusTheme.HusButton.colorFillBgActive:
                                          control.hovered ? HusTheme.HusButton.colorFillBgHover :
                                                            HusTheme.HusButton.colorFillBg;
                }
            case HusButton.Type_Text:
                if (HusTheme.isDark) {
                    return control.down ? HusTheme.HusButton.colorFillBgDarkActive:
                                          control.hovered ? HusTheme.HusButton.colorFillBgDarkHover :
                                                            HusTheme.HusButton.colorTextBg;
                } else {
                    return control.down ? HusTheme.HusButton.colorTextBgActive:
                                          control.hovered ? HusTheme.HusButton.colorTextBgHover :
                                                            HusTheme.HusButton.colorTextBg;
                }
            default: return HusTheme.HusButton.colorBg;
            }
        } else {
            return HusTheme.HusButton.colorBgDisabled;
        }
    }
    property color colorBorder: {
        if (type == HusButton.Type_Link) return 'transparent';
        if (enabled) {
            switch(control.type)
            {
            case HusButton.Type_Default:
                return control.down ? HusTheme.HusButton.colorBorderActive :
                                      control.hovered ? HusTheme.HusButton.colorBorderHover :
                                                        HusTheme.HusButton.colorDefaultBorder;
            default:
                return control.down ? HusTheme.HusButton.colorBorderActive :
                                      control.hovered ? HusTheme.HusButton.colorBorderHover :
                                                        HusTheme.HusButton.colorBorder;
            }
        } else {
            return HusTheme.HusButton.colorBorderDisabled;
        }
    }
    property string contentDescription: text

    objectName: '__HusButton__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    padding: 15
    topPadding: 6
    bottomPadding: 6
    font {
        family: HusTheme.HusButton.fontFamily
        pixelSize: HusTheme.HusButton.fontSize
    }
    contentItem: Text {
        text: control.text
        font: control.font
        lineHeight: HusTheme.HusButton.fontLineHeight
        color: control.colorText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    }
    background: Item {
        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.radius
            anchors.centerIn: parent
            visible: control.effectEnabled && control.type != HusButton.Type_Link
            color: 'transparent'
            border.width: 0
            border.color: control.enabled ? HusTheme.HusButton.colorBorderHover : 'transparent'
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
            width: realWidth
            height: realHeight
            anchors.centerIn: parent
            radius: control.shape == HusButton.Shape_Default ? control.radiusBg : height * 0.5
            color: control.colorBg
            border.width: (control.type == HusButton.Type_Filled || control.type == HusButton.Type_Text) ? 0 : 1
            border.color: control.enabled ? control.colorBorder : 'transparent'

            property real realWidth: control.shape == HusButton.Shape_Default ? parent.width : parent.height
            property real realHeight: control.shape == HusButton.Shape_Default ? parent.height : parent.height

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
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

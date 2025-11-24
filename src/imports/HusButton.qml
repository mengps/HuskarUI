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
    property color colorText: {
        if (enabled) {
            switch(control.type)
            {
            case HusButton.Type_Default:
                return control.down ? themeSource.colorTextActive :
                                      control.hovered ? themeSource.colorTextHover :
                                                        themeSource.colorTextDefault;
            case HusButton.Type_Outlined:
                return control.down ? themeSource.colorTextActive :
                                      control.hovered ? themeSource.colorTextHover :
                                                        themeSource.colorText;
            case HusButton.Type_Primary: return 'white';
            case HusButton.Type_Filled:
            case HusButton.Type_Text:
            case HusButton.Type_Link:
                return control.down ? themeSource.colorTextActive :
                                      control.hovered ? themeSource.colorTextHover :
                                                        themeSource.colorText;
            default: return themeSource.colorText;
            }
        } else {
            return themeSource.colorTextDisabled;
        }
    }
    property color colorBg: {
        if (type == HusButton.Type_Link) return 'transparent';
        if (enabled) {
            switch(control.type)
            {
            case HusButton.Type_Default:
            case HusButton.Type_Outlined:
                return control.down ? themeSource.colorBgActive :
                                      control.hovered ? themeSource.colorBgHover :
                                                        themeSource.colorBg;
            case HusButton.Type_Primary:
                return control.down ? control.themeSource.colorPrimaryBgActive:
                                      control.hovered ? themeSource.colorPrimaryBgHover :
                                                        themeSource.colorPrimaryBg;
            case HusButton.Type_Filled:
                if (HusTheme.isDark) {
                    return control.down ? themeSource.colorFillBgDarkActive:
                                          control.hovered ? themeSource.colorFillBgDarkHover :
                                                            themeSource.colorFillBgDark;
                } else {
                    return control.down ? themeSource.colorFillBgActive:
                                          control.hovered ? themeSource.colorFillBgHover :
                                                            themeSource.colorFillBg;
                }
            case HusButton.Type_Text:
                if (HusTheme.isDark) {
                    return control.down ? themeSource.colorFillBgDarkActive:
                                          control.hovered ? themeSource.colorFillBgDarkHover :
                                                            themeSource.colorTextBg;
                } else {
                    return control.down ? themeSource.colorTextBgActive:
                                          control.hovered ? themeSource.colorTextBgHover :
                                                            themeSource.colorTextBg;
                }
            default: return themeSource.colorBg;
            }
        } else {
            return themeSource.colorBgDisabled;
        }
    }
    property color colorBorder: {
        if (type == HusButton.Type_Link) return 'transparent';
        if (enabled) {
            switch(control.type)
            {
            case HusButton.Type_Default:
                return control.down ? themeSource.colorBorderActive :
                                      control.hovered ? themeSource.colorBorderHover :
                                                        themeSource.colorDefaultBorder;
            default:
                return control.down ? themeSource.colorBorderActive :
                                      control.hovered ? themeSource.colorBorderHover :
                                                        themeSource.colorBorder;
            }
        } else {
            return themeSource.colorBorderDisabled;
        }
    }
    property HusRadius radiusBg: HusRadius { all: control.themeSource.radiusBg }
    property string sizeHint: 'normal'
    property real sizeRatio: HusTheme.sizeHint[sizeHint]
    property string contentDescription: text
    property var themeSource: HusTheme.HusButton

    objectName: '__HusButton__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    padding: 15 * control.sizeRatio
    topPadding: 6 * control.sizeRatio
    bottomPadding: 6 * control.sizeRatio
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
    }
    contentItem: Text {
        text: control.text
        font: control.font
        lineHeight: control.themeSource.fontLineHeight
        color: control.colorText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    }
    background: Item {
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
            visible: control.effectEnabled && control.type != HusButton.Type_Link
            color: 'transparent'
            border.width: 0
            border.color: control.enabled ? control.themeSource.colorBorderHover : 'transparent'
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
            width: realWidth
            height: realHeight
            anchors.centerIn: parent
            radius: control.radiusBg?.all ?? 0
            topLeftRadius: control.shape == HusButton.Shape_Default ? control.radiusBg?.topLeft ?? 0 : height * 0.5
            topRightRadius: control.shape == HusButton.Shape_Default ? control.radiusBg?.topRight ?? 0 : height * 0.5
            bottomLeftRadius: control.shape == HusButton.Shape_Default ? control.radiusBg?.bottomLeft ?? 0 : height * 0.5
            bottomRightRadius: control.shape == HusButton.Shape_Default ? control.radiusBg?.bottomRight ?? 0 : height * 0.5
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

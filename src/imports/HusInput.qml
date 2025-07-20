import QtQuick
import QtQuick.Controls.Basic as T
import HuskarUI.Basic

T.TextField {
    id: control

    enum IconPosition {
        Position_Left = 0,
        Position_Right = 1
    }

    property bool animationEnabled: HusTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property int iconSource: 0
    property int iconSize: HusTheme.HusInput.fontIconSize
    property int iconPosition: HusInput.Position_Left
    property color colorIcon: colorText
    property color colorText: enabled ? HusTheme.HusInput.colorText : HusTheme.HusInput.colorTextDisabled
    property color colorBorder: enabled ?
                                    active ? HusTheme.HusInput.colorBorderHover :
                                              HusTheme.HusInput.colorBorder : HusTheme.HusInput.colorBorderDisabled
    property color colorBg: enabled ? HusTheme.HusInput.colorBg : HusTheme.HusInput.colorBgDisabled
    property int radiusBg: HusTheme.HusInput.radiusBg
    property string contentDescription: ''

    property Component iconDelegate: HusIconText {
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.colorIcon
    }

    objectName: '__HusInput__'
    focus: true
    padding: 6
    leftPadding: 10 + ((iconSource != 0 && iconPosition == HusInput.Position_Left) ? iconSize : 0)
    rightPadding: 10 + ((iconSource != 0 && iconPosition == HusInput.Position_Right) ? iconSize : 0)
    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding
    color: colorText
    placeholderTextColor: enabled ? HusTheme.HusInput.colorPlaceholderText : HusTheme.HusInput.colorPlaceholderTextDisabled
    selectedTextColor: HusTheme.HusInput.colorSelectedText
    selectionColor: HusTheme.HusInput.colorSelection
    font {
        family: HusTheme.HusInput.fontFamily
        pixelSize: HusTheme.HusInput.fontSize
    }
    background: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    Loader {
        anchors.left: iconPosition == HusInput.Position_Left ? parent.left : undefined
        anchors.right: iconPosition == HusInput.Position_Right ? parent.right : undefined
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        active: control.iconSize != 0
        sourceComponent: iconDelegate
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: true
    Accessible.description: control.contentDescription
}

import QtQuick
import QtQuick.Controls.Basic as T
import DelegateUI

T.TextField {
    id: control

    enum IconPosition {
        Position_Left = 0,
        Position_Right = 1
    }

    property bool animationEnabled: DelTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property int iconSource: 0
    property int iconSize: DelTheme.DelInput.fontIconSize
    property int iconPosition: DelInput.Position_Left
    property color colorIcon: colorText
    property color colorText: enabled ? DelTheme.DelInput.colorText : DelTheme.DelInput.colorTextDisabled
    property color colorBorder: enabled ?
                                    active ? DelTheme.DelInput.colorBorderHover :
                                              DelTheme.DelInput.colorBorder : DelTheme.DelInput.colorBorderDisabled
    property color colorBg: enabled ? DelTheme.DelInput.colorBg : DelTheme.DelInput.colorBgDisabled
    property int radiusBg: 6
    property string contentDescription: ""

    property Component iconDelegate: DelIconText {
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.colorIcon
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

    objectName: "__DelInput__"
    focus: true
    padding: 5
    leftPadding: 10 + ((iconSource != 0 && iconPosition == DelInput.Position_Left) ? iconSize : 0)
    rightPadding: 10 + ((iconSource != 0 && iconPosition == DelInput.Position_Right) ? iconSize : 0)
    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding
    color: colorText
    placeholderTextColor: enabled ? DelTheme.DelInput.colorPlaceholderText : DelTheme.DelInput.colorPlaceholderTextDisabled
    selectedTextColor: DelTheme.DelInput.colorSelectedText
    selectionColor: DelTheme.DelInput.colorSelection
    font {
        family: DelTheme.DelInput.fontFamily
        pixelSize: DelTheme.DelInput.fontSize
    }
    background: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg

        Loader {
            anchors.left: iconPosition == DelInput.Position_Left ? parent.left : undefined
            anchors.right: iconPosition == DelInput.Position_Right ? parent.right : undefined
            anchors.margins: 5
            anchors.verticalCenter: parent.verticalCenter
            active: control.iconSize != 0
            sourceComponent: iconDelegate
        }
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: true
    Accessible.description: control.contentDescription
}

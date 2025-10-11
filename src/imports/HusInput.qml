import QtQuick
import QtQuick.Controls.Basic as T
import HuskarUI.Basic

T.TextField {
    id: control

    enum IconPosition {
        Position_Left = 0,
        Position_Right = 1
    }

    signal clickClear()

    property bool animationEnabled: HusTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property var iconSource: 0 ?? ''
    property int iconSize: themeSource.fontIconSize
    property int iconPosition: HusInput.Position_Left
    property var clearEnabled: false
    property var clearIconSource: HusIcon.CloseCircleFilled ?? ''
    property int clearIconSize: themeSource.fontClearIconSize
    property int clearIconPosition: HusInput.Position_Right
    readonly property int leftIconPadding: iconPosition === HusInput.Position_Left ? __private.iconSize : 0
    readonly property int rightIconPadding: iconPosition === HusInput.Position_Right ? __private.iconSize : 0
    readonly property int leftClearIconPadding: {
        if (clearIconPosition === HusInput.Position_Left) {
            return leftIconPadding > 0 ? (__private.clearIconSize + 5) : __private.clearIconSize;
        } else {
            return 0;
        }
    }
    readonly property int rightClearIconPadding: {
        if (clearIconPosition === HusInput.Position_Right) {
            return rightIconPadding > 0 ? (__private.clearIconSize + 5) : __private.clearIconSize;
        } else {
            return 0;
        }
    }
    property color colorIcon: enabled ? control.themeSource.colorIcon : control.themeSource.colorIconDisabled
    property color colorText: enabled ? themeSource.colorText : themeSource.colorTextDisabled
    property color colorBorder: enabled ?
                                    active ? themeSource.colorBorderHover :
                                             themeSource.colorBorder : themeSource.colorBorderDisabled
    property color colorBg: enabled ? themeSource.colorBg : themeSource.colorBgDisabled
    property int radiusBg: themeSource.radiusBg
    property string contentDescription: ''
    property var themeSource: HusTheme.HusInput

    property Component iconDelegate: HusIconText {
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.colorIcon
    }
    property Component clearIconDelegate: HusIconText {
        iconSource: control.length > 0 ? control.clearIconSource : 0
        iconSize: control.clearIconSize
        colorIcon: {
            if (control.enabled) {
                return __tapHandler.pressed ? control.themeSource.colorClearIconActive :
                                              __hoverHandler.hovered ? control.themeSource.colorClearIconHover :
                                                                       control.themeSource.colorClearIcon;
            } else {
                return control.themeSource.colorClearIconDisabled;
            }
        }

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

        HoverHandler {
            id: __hoverHandler
            enabled: (control.clearEnabled === 'active' || control.clearEnabled === true) && !control.readOnly
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            id: __tapHandler
            enabled: (control.clearEnabled === 'active' || control.clearEnabled === true) && !control.readOnly
            onTapped: {
                control.clear();
                control.clickClear();
            }
        }
    }
    property Component bgDelegate: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg
    }

    objectName: '__HusInput__'
    focus: true
    padding: 6
    leftPadding: 10 + leftIconPadding + leftClearIconPadding
    rightPadding: 10 + rightIconPadding + rightClearIconPadding
    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding
    color: colorText
    placeholderTextColor: enabled ? themeSource.colorPlaceholderText : themeSource.colorPlaceholderTextDisabled
    selectedTextColor: themeSource.colorTextSelected
    selectionColor: themeSource.colorSelection
    font {
        family: themeSource.fontFamily
        pixelSize: themeSource.fontSize
    }
    background: Loader {
        sourceComponent: control.bgDelegate
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    QtObject {
        id: __private
        property int iconSize: __iconLoader.active ? __iconLoader.width : 0
        property int clearIconSize: __clearIconLoader.active ? __clearIconLoader.width : 0
    }

    Loader {
        id: __iconLoader
        active: control.iconSource !== 0 && control.iconSource !== ''
        anchors.left: control.iconPosition === HusInput.Position_Left ? parent.left : undefined
        anchors.right: control.iconPosition === HusInput.Position_Right ? parent.right : undefined
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: control.iconDelegate
    }

    Loader {
        id: __clearIconLoader
        active: control.enabled && !control.readOnly && control.clearIconSource !== 0 && control.clearIconSource !== '' && (control.clearEnabled === true || (control.clearEnabled === 'active' && control.active))
        anchors.left: {
            if (control.clearIconPosition === HusInput.Position_Left) {
                return __iconLoader.active && control.iconPosition === HusInput.Position_Left ? __iconLoader.right : parent.left;
            } else {
                return undefined;
            }
        }
        anchors.right: {
            if (control.clearIconPosition === HusInput.Position_Right) {
                return __iconLoader.active && control.iconPosition === HusInput.Position_Right ? __iconLoader.left : parent.right;
            } else {
                return undefined;
            }
        }
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: control.clearIconDelegate
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: control.readOnly
    Accessible.description: control.contentDescription
}

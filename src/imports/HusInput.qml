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
    property bool darkMode: HusTheme.isDark
    readonly property bool active: hovered || activeFocus
    property var iconSource: 0 ?? ''
    property int iconSize: parseInt(themeSource.fontSizeIcon) * sizeRatio
    property int iconPosition: HusInput.Position_Left
    property var clearEnabled: false ?? ''
    property var clearIconSource: HusIcon.CloseCircleFilled ?? ''
    property int clearIconSize: parseInt(themeSource.fontSizeClearIcon) * sizeRatio
    property int clearIconPosition: HusInput.Position_Right
    readonly property int leftIconPadding: iconPosition === HusInput.Position_Left ? __private.iconSize : 0
    readonly property int rightIconPadding: iconPosition === HusInput.Position_Right ? __private.iconSize : 0
    readonly property int leftClearIconPadding: clearIconPosition === HusInput.Position_Left ? __private.clearIconSize : 0
    readonly property int rightClearIconPadding: clearIconPosition === HusInput.Position_Right ? __private.clearIconSize : 0
    property color colorIcon: enabled ? control.themeSource.colorIcon : control.themeSource.colorIconDisabled
    property color colorText: enabled ? themeSource.colorText : themeSource.colorTextDisabled
    property color colorBorder: enabled ?
                                    active ? themeSource.colorBorderHover :
                                             themeSource.colorBorder : themeSource.colorBorderDisabled
    property color colorBg: enabled ? themeSource.colorBg : themeSource.colorBgDisabled
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property string sizeHint: 'normal'
    property real sizeRatio: HusTheme.sizeHint[sizeHint]
    property string contentDescription: ''
    property var themeSource: HusTheme.HusInput

    property Component iconDelegate: HusIconText {
        leftPadding: control.iconPosition === HusInput.Position_Left ? 10 * sizeRatio: 0
        rightPadding: control.iconPosition === HusInput.Position_Right ? 10 * sizeRatio: 0
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.colorIcon
    }
    property Component clearIconDelegate: HusIconText {
        leftPadding: control.clearIconPosition === HusInput.Position_Left ? (control.leftIconPadding > 0 ? 5 : 10) * sizeRatio : 0
        rightPadding: control.clearIconPosition === HusInput.Position_Right ? (control.rightIconPadding > 0 ? 5 : 10) * sizeRatio : 0
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
    property Component bgDelegate: HusRectangleInternal {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    objectName: '__HusInput__'
    focus: true
    padding: 6 * sizeRatio
    leftPadding: (__private.leftHasIcons ? 5 : 10) * sizeRatio + leftIconPadding + leftClearIconPadding
    rightPadding: (__private.rightHasIcons ? 5 : 10) * sizeRatio + rightIconPadding + rightClearIconPadding
    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding
    color: colorText
    placeholderTextColor: enabled ? themeSource.colorPlaceholderText : themeSource.colorPlaceholderTextDisabled
    selectedTextColor: themeSource.colorTextSelected
    selectionColor: themeSource.colorSelection
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize) * sizeRatio
    }
    background: Loader {
        sourceComponent: control.bgDelegate
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    QtObject {
        id: __private
        property bool leftHasIcons: control.leftIconPadding + control.leftClearIconPadding > 0
        property bool rightHasIcons: control.rightIconPadding + control.rightClearIconPadding > 0
        property int iconSize: __iconLoader.active ? __iconLoader.width : 0
        property int clearIconSize: __clearIconLoader.active ? __clearIconLoader.width : 0
    }

    Loader {
        id: __iconLoader
        active: control.iconSource !== 0 && control.iconSource !== ''
        anchors.left: control.iconPosition === HusInput.Position_Left ? parent.left : undefined
        anchors.right: control.iconPosition === HusInput.Position_Right ? parent.right : undefined
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: control.iconDelegate
    }

    Loader {
        id: __clearIconLoader
        active: control.enabled && !control.readOnly && control.clearIconSource !== 0 && control.clearIconSource !== ''
                && (control.clearEnabled === true || (control.clearEnabled === 'active' && control.active))
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
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: control.clearIconDelegate
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: control.readOnly
    Accessible.description: control.contentDescription
}

import QtQuick
import HuskarUI.Basic

HusPopup {
    id: control

    signal clickMenu(deep: int, key: string, keyPath: var, data: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property var initModel: []
    property bool tooltipVisible: false
    property int defaultMenuIconSize: HusTheme.HusMenu.fontSize
    property int defaultMenuIconSpacing: 8
    property int defaultMenuWidth: 140
    property int defaultMenuHeight: 30
    property int defaultMenuSpacing: 4
    property int subMenuOffset: -4
    property HusRadius radiusMenuBg: HusRadius { all: HusTheme.Primary.radiusPrimary }

    function open() {
        visible = true;
        if (parent && parent instanceof Item) {
            const pos = parent.mapToItem(null, x, y);
            if ((pos.x + implicitWidth + 6) > __private.window.width) {
                x = parent.mapFromItem(null, __private.window.width - 6, 0).x - implicitWidth;
            }
            if ((pos.y + implicitHeight + 6) > __private.window.height) {
                y = parent.mapFromItem(null, 0, __private.window.height - 6).y - implicitHeight;
            }
        }
    }

    objectName: '__HusContextMenu__'
    implicitWidth: defaultMenuWidth
    implicitHeight: implicitContentHeight
    enter: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 0.0
            to: 1.0
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'height'
            from: 0
            to: control.implicitHeight
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 1.0
            to: 0.0
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'height'
            to: 0
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    contentItem: HusMenu {
        radiusMenuBg: control.radiusMenuBg
        radiusPopupBg: control.radiusBg
        initModel: control.initModel
        tooltipVisible: control.tooltipVisible
        popupMode: true
        popupWidth: control.defaultMenuWidth
        popupOffset: control.subMenuOffset
        defaultMenuIconSize: control.defaultMenuIconSize
        defaultMenuIconSpacing: control.defaultMenuIconSpacing
        defaultMenuWidth: control.defaultMenuWidth
        defaultMenuHeight: control.defaultMenuHeight
        defaultMenuSpacing: control.defaultMenuSpacing
        onClickMenu:
            (deep, key, keyPath, data) => {
                control.clickMenu(deep, key, keyPath, data);
                if (!data.hasOwnProperty('menuChildren')) {
                    close();
                }
            }
        menuIconDelegate: HusIconText {
            color: !menuButton.isGroup && menuButton.enabled ? HusTheme.HusMenu.colorText : HusTheme.HusMenu.colorTextDisabled
            iconSize: menuButton.iconSize
            iconSource: menuButton.iconSource
            verticalAlignment: Text.AlignVCenter

            Behavior on x {
                enabled: control.animationEnabled
                NumberAnimation { easing.type: Easing.OutCubic; duration: HusTheme.Primary.durationMid }
            }
            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
        }
        menuLabelDelegate: HusText {
            text: menuButton.text
            font: menuButton.font
            color: !menuButton.isGroup && menuButton.enabled ? HusTheme.HusMenu.colorText : HusTheme.HusMenu.colorTextDisabled
            elide: Text.ElideRight

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
        }
        menuContentDelegate: Item {
            id: __menuContentItem

            property var __menuButton: menuButton
            property var model: menuButton.model
            property bool isGroup: menuButton.isGroup
            property bool hovered: menuButton.hovered

            Loader {
                id: __iconLoader
                x: menuButton.iconStart
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: menuButton.iconDelegate
                property var model: __menuButton.model
                property alias menuButton: __menuContentItem.__menuButton
            }

            Loader {
                id: __labelLoader
                anchors.left: __iconLoader.right
                anchors.leftMargin: menuButton.iconSpacing
                anchors.right: menuButton.expandedVisible ? __expandedIcon.left : parent.right
                anchors.rightMargin: menuButton.iconSpacing
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: menuButton.labelDelegate
                property var model: __menuButton.model
                property alias menuButton: __menuContentItem.__menuButton
            }

            HusIconText {
                id: __expandedIcon
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: menuButton.expandedVisible
                iconSource: HusIcon.RightOutlined
                colorIcon: !isGroup && menuButton.enabled ? HusTheme.HusMenu.colorText : HusTheme.HusMenu.colorTextDisabled

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            }
        }
        menuBackgroundDelegate: HusRectangleInternal {
            radius: control.radiusMenuBg.all
            topLeftRadius: control.radiusMenuBg.topLeft
            topRightRadius: control.radiusMenuBg.topRight
            bottomLeftRadius: control.radiusMenuBg.bottomLeft
            bottomRightRadius: control.radiusMenuBg.bottomRight
            color: {
                if (enabled) {
                    if (menuButton.isGroup) return HusTheme.HusMenu.colorBgDisabled;
                    else if (menuButton.pressed) return HusTheme.HusMenu.colorBgActive;
                    else if (menuButton.hovered) return HusTheme.HusMenu.colorBgHover;
                    else return HusTheme.HusMenu.colorBg;
                } else {
                    return HusTheme.HusMenu.colorBgDisabled;
                }
            }
            border.color: menuButton.colorBorder
            border.width: 1

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
        }
    }

    Item {
        id: __private
        property var window: Window.window
    }
}

import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

HusPopup {
    id: control

    signal clickMenu(deep: int, key: string, keyPath: var, data: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property var initModel: []
    property bool showToolTip: false
    property int defaultMenuIconSize: parseInt(HusTheme.HusMenu.fontSize)
    property int defaultMenuIconSpacing: 8
    property int defaultMenuWidth: 140
    property int defaultMenuTopPadding: 5
    property int defaultMenuBottomPadding: 5
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
            easing.type: Easing.OutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 1.0
            to: 0
            easing.type: Easing.InQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    contentItem: HusMenu {
        implicitHeight: implicitMenuHeight
        radiusMenuBg: control.radiusMenuBg
        radiusPopupBg: control.radiusBg
        initModel: control.initModel
        showToolTip: control.showToolTip
        popupMode: true
        popupWidth: control.defaultMenuWidth
        popupOffset: control.subMenuOffset
        defaultMenuIconSize: control.defaultMenuIconSize
        defaultMenuIconSpacing: control.defaultMenuIconSpacing
        defaultMenuWidth: control.defaultMenuWidth
        defaultMenuTopPadding: control.defaultMenuTopPadding
        defaultMenuBottomPadding: control.defaultMenuBottomPadding
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
            implicitHeight: __rowLayout.implicitHeight
            property var __menuButton: menuButton
            property var model: menuButton.model
            property bool isGroup: menuButton.isGroup

            RowLayout {
                id: __rowLayout
                visible: !__menuContentItem.isVertical
                anchors.left: parent.left
                anchors.right: menuButton.expandedVisible ? __expandedIcon.left : parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: menuButton.iconSpacing

                Loader {
                    sourceComponent: menuButton.iconDelegate
                    property var model: __menuButton.model
                    property alias menuButton: __menuContentItem.__menuButton
                }

                Loader {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    sourceComponent: menuButton.labelDelegate
                    property var model: __menuButton.model
                    property alias menuButton: __menuContentItem.__menuButton
                }
            }

            HusIconText {
                id: __expandedIcon
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: menuButton.showExpanded
                iconSource: HusIcon.RightOutlined
                colorIcon: !isGroup && menuButton.enabled ? HusTheme.HusMenu.colorText : HusTheme.HusMenu.colorTextDisabled

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
            }
        }
        menuBgDelegate: HusRectangleInternal {
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

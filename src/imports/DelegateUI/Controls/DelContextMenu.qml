import QtQuick
import DelegateUI

DelPopup {
    id: control

    implicitWidth: defaultMenuWidth
    implicitHeight: implicitContentHeight

    signal clickMenu(deep: int, menuKey: string, menuData: var)

    property bool animationEnabled: DelTheme.animationEnabled
    property var initModel: []
    property bool tooltipVisible: false
    property int defaultMenuIconSize: DelTheme.DelMenu.fontSize
    property int defaultMenuIconSpacing: 8
    property int defaultMenuWidth: 140
    property int defaultMenuHeight: 30
    property int defaultMenuSpacing: 4
    property int subMenuOffset: -4
    property int radiusBg: 6

    enter: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 0.0
            to: 1.0
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'height'
            from: 0
            to: control.implicitHeight
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: 'opacity'
            from: 1.0
            to: 0.0
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'height'
            to: 0
            easing.type: Easing.InOutQuad
            duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
        }
    }
    contentItem: DelMenu {
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
            (deep, menuKey, menuData) => {
                control.clickMenu(deep, menuKey, menuData);
                control.close();
            }
        menuIconDelegate: DelIconText {
            color: !menuButton.isGroup && menuButton.enabled ? DelTheme.DelMenu.colorText : DelTheme.DelMenu.colorTextDisabled
            iconSize: menuButton.iconSize
            iconSource: menuButton.iconSource
            verticalAlignment: Text.AlignVCenter

            Behavior on x {
                enabled: control.animationEnabled
                NumberAnimation { easing.type: Easing.OutCubic; duration: DelTheme.Primary.durationMid }
            }
            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
        }
        menuLabelDelegate: DelText {
            text: menuButton.text
            font: menuButton.font
            color: !menuButton.isGroup && menuButton.enabled ? DelTheme.DelMenu.colorText : DelTheme.DelMenu.colorTextDisabled
            elide: Text.ElideRight

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
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

            DelIconText {
                id: __expandedIcon
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: menuButton.expandedVisible
                iconSource: DelIcon.RightOutlined
                colorIcon: !isGroup && menuButton.enabled ? DelTheme.DelMenu.colorText : DelTheme.DelMenu.colorTextDisabled

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }
        }
        menuBackgroundDelegate: Rectangle {
            radius: control.radiusBg
            color: {
                if (enabled) {
                    if (menuButton.isGroup) return DelTheme.DelMenu.colorBgDisabled;
                    else if (menuButton.pressed) return DelTheme.DelMenu.colorBgActive;
                    else if (menuButton.hovered) return DelTheme.DelMenu.colorBgHover;
                    else return DelTheme.DelMenu.colorBg;
                } else {
                    return DelTheme.DelMenu.colorBgDisabled;
                }
            }
            border.color: menuButton.colorBorder
            border.width: 1

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
        }
    }
}

import QtQuick
import DelegateUI

Item {
    id: control

    width: menuDefaultWidth

    signal clickMenu(int deep, var data);
    property bool animationEnabled: DelTheme.animationEnabled
    property int menuDefaultIconSize: DelTheme.DelMenu.fontSize
    property int menuDefaultIconSpacing: 5
    property int menuDefaultIconPosition: DelButtonType.Position_Start
    property int menuDefaultWidth: 300
    property int menuDefaultHieght: 40
    property int menuDefaultSpacing: 5

    property var model: []
    property Component menuDelegate: Item {
        id: __rootItem
        width: ListView.view.width
        height: __layout.height

        property var view: ListView.view
        property string menuTitle: modelData.title || ""
        property int menuHeight: modelData.height || control.menuDefaultHieght
        property int menuIconSize: modelData.iconSize || menuDefaultIconSize
        property int menuIconSource: modelData.iconSource || 0
        property int menuIconSpacing: modelData.iconSpacing || menuDefaultIconSpacing
        property var menuChildren: modelData.menuChildren || []

        property var parentMenu: view.menuDeep === 0 ? null : view.parentMenu
        property int menuChildrenLength: menuChildren.length
        property bool isCurrent: __private.selectedItem === __rootItem || isCurrentParent
        property bool isCurrentParent: false

        /*! 清除当前菜单的根菜单 */
        function findRootMenu() {
            let parent = parentMenu;
            while (parent !== null) {
                if (parent.parentMenu === null)
                    return parent;
                parent = parent.parentMenu;
            }
            /*! 根菜单返回自身 */
            return __rootItem;
        }
        /*! 清除当前菜单的所有子菜单 */
        function clearIsCurrentParent() {
            isCurrentParent = false;
            for (let i = 0; i < childrenListView.count; i++) {
                let item = childrenListView.itemAtIndex(i);
                if (item)
                    item.clearIsCurrentParent()
            }
        }
        /*! 选中当前菜单的所有父菜单 */
        function selectedCurrentParentMenu() {
            for (let i = 0; i < listView.count; i++) {
                let item = listView.itemAtIndex(i);
                if (item)
                    item.clearIsCurrentParent();
            }
            let parent = parentMenu;
            while (parent !== null) {
                parent.isCurrentParent = true;
                if (parent.parentMenu === null)
                    return;
                parent = parent.parentMenu;
            }
        }

        Item {
            id: __layout
            width: parent.width
            height: __menuButton.height + childrenListView.height

            MenuButton {
                id: __menuButton
                anchors.left: parent.left
                anchors.right: parent.right
                height: menuHeight
                text: menuTitle
                checkable: true
                iconSize: menuIconSize
                iconSource: menuIconSource
                iconSpacing: menuIconSpacing
                expandedVisible: __rootItem.menuChildrenLength > 0
                isCurrent: __rootItem.isCurrent
                onClicked: {
                    if (__rootItem.menuChildrenLength == 0) {
                        control.clickMenu(__rootItem.view.menuDeep, modelData);
                        __private.selectedItem = __rootItem;
                        __rootItem.selectedCurrentParentMenu();
                    }
                }
            }

            ListView {
                id: childrenListView
                height: __menuButton.expanded ? (contentHeight + (count === 0 ? 0 : control.menuDefaultSpacing)) : 0
                anchors.top: __menuButton.bottom
                anchors.topMargin: control.menuDefaultSpacing
                anchors.left: parent.left
                anchors.leftMargin: __menuButton.iconSize * menuDeep
                anchors.right: parent.right
                spacing: control.menuDefaultSpacing
                model: __rootItem.menuChildren
                delegate: menuDelegate
                clip: true
                /* 子ListView从父ListView的深度累加可实现自动计算 */
                property int menuDeep: __rootItem.view.menuDeep + 1
                property var parentMenu: __rootItem

                Behavior on height {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: DelTheme.Primary.durationFast }
                }
            }
        }
    }

    component MenuButton: DelButton {
        id: __menuButtonImpl
        property int iconSource: 0
        property int iconSize: DelTheme.DelMenu.fontSize
        property int iconSpacing: 5
        property bool expanded: false
        property bool expandedVisible: false
        property bool isCurrent: false
        onClicked: {
            if (expandedVisible)
                expanded = !expanded;
        }
        effectEnabled: false
        colorBorder: "transparent"
        colorText: {
            if (enabled) {
                return __menuButtonImpl.isCurrent ? DelTheme.DelMenu.colorTextActive :
                                                    DelTheme.DelMenu.colorText;
            } else {
                return DelTheme.DelMenu.colorTextDisabled;
            }
        }
        colorBg: {
            if (enabled) {
                if (__menuButtonImpl.isCurrent)
                    return DelTheme.DelMenu.colorBgActive;
                else if (__menuButtonImpl.hovered) {
                    return DelTheme.DelMenu.colorBgHover;
                } else {
                    return DelTheme.DelMenu.colorBg;
                }
            } else {
                return DelTheme.DelMenu.colorBgDisabled;
            }
        }
        contentItem: Item {
            DelIconText {
                id: __icon
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: __menuButtonImpl.colorText
                iconSize: __menuButtonImpl.iconSize
                iconSource: __menuButtonImpl.iconSource
                verticalAlignment: Text.AlignVCenter

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }

            Text {
                id: __text
                anchors.left: __icon.right
                anchors.leftMargin: __menuButtonImpl.iconSpacing
                anchors.right: __expandedIcon.left
                anchors.rightMargin: __menuButtonImpl.iconSpacing
                anchors.verticalCenter: parent.verticalCenter
                text: __menuButtonImpl.text
                font: __menuButtonImpl.font
                color: __menuButtonImpl.colorText
                elide: Text.ElideRight

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }

            DelIconText {
                id: __expandedIcon
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                visible: __menuButtonImpl.expandedVisible
                iconSource: __menuButtonImpl.expanded ? DelIcon.UpOutlined : DelIcon.DownOutlined
                iconColor: __menuButtonImpl.colorText

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }
        }
    }

    QtObject {
        id: __private
        property var selectedItem: null
    }

    Rectangle {
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: DelTheme.DelMenu.colorEdge
    }

    ListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 5
        boundsBehavior: Flickable.StopAtBounds
        spacing: control.menuDefaultSpacing
        model: control.model
        delegate: menuDelegate
        property int menuDeep: 0
    }
}

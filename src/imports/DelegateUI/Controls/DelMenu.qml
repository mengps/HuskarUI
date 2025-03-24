import QtQuick
import QtQuick.Templates as T
import DelegateUI

Item {
    id: control

    width: compactMode ? compactWidth : defaultMenuWidth
    clip: true

    signal clickMenu(deep: int, menuKey: string, menuData: var)

    property bool animationEnabled: DelTheme.animationEnabled
    property string contentDescription: ""
    property bool showEdge: false
    property bool compactMode: false
    property int compactWidth: 50
    property bool popupMode: false
    property int popupWidth: 200
    property int popupMaxHeight: control.height
    property int defaultMenuIconSize: DelTheme.DelMenu.fontSize
    property int defaultMenuIconSpacing: 8
    property int defaultMenuWidth: 300
    property int defaultMenuHeight: 40
    property int defaultMenuSpacing: 4
    property var defaultSelectedKey: []
    property var initModel: []
    property Component menuDelegate: Item {
        id: __rootItem
        width: ListView.view.width
        height: {
            switch (menuType) {
            case "item":
            case "group":
                return __layout.height;
            case "divider":
                return __dividerLoader.height;
            default:
                return __layout.height;
            }
        }
        clip: true
        Component.onCompleted: {
            if (menuType == "item" || menuType == "group") {
                layerPopup = __private.createPopupList(view.menuDeep);
                for (let i = 0; i < menuChildren.length; i++) {
                    __childrenListView.model.push(menuChildren[i]);
                }
                if (control.defaultSelectedKey.length != 0) {
                    if (control.defaultSelectedKey.indexOf(menuKey) != -1) {
                        __rootItem.expandParent();
                        __menuButton.clicked();
                    }
                }
            }
        }

        required property var modelData
        property alias model: __rootItem.modelData
        property var view: ListView.view
        property string menuKey: model.key || ""
        property string menuType: model.type || "item"
        property bool menuEnabled: model.enabled === undefined ? true : model.enabled
        property string menuLabel: model.label || ""
        property int menuHeight: model.height || defaultMenuHeight
        property int menuIconSize: model.iconSize || defaultMenuIconSize
        property int menuIconSource: model.iconSource || 0
        property int menuIconSpacing: model.iconSpacing || defaultMenuIconSpacing
        property var menuChildren: model.menuChildren || []
        property int menuChildrenLength: menuChildren ? menuChildren.length : 0

        property var parentMenu: view.menuDeep === 0 ? null : view.parentMenu
        property bool isCurrent: __private.selectedItem === __rootItem || isCurrentParent
        property bool isCurrentParent: false
        property var layerPopup: null

        function expandMenu() {
            if (__menuButton.expandedVisible)
                __menuButton.expanded = true;
        }

        /*! 查找当前菜单的根菜单 */
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
        /*! 展开当前菜单的所有父菜单 */
        function expandParent() {
            let parent = parentMenu;
            while (parent !== null) {
                if (parent.parentMenu === null) {
                    parent.expandMenu();
                    return;
                }
                parent.expandMenu();
                parent = parent.parentMenu;
            }
        }
        /*! 清除当前菜单的所有子菜单 */
        function clearIsCurrentParent() {
            isCurrentParent = false;
            for (let i = 0; i < __childrenListView.count; i++) {
                let item = __childrenListView.itemAtIndex(i);
                if (item)
                    item.clearIsCurrentParent();
            }
        }
        /*! 选中当前菜单的所有父菜单 */
        function selectedCurrentParentMenu() {
            for (let i = 0; i < __listView.count; i++) {
                let item = __listView.itemAtIndex(i);
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

        Connections {
            target: __private
            function onGotoMenu(key) {
                if (__rootItem.menuKey !== "" && __rootItem.menuKey === key) {
                    __rootItem.expandParent();
                    __menuButton.clicked();
                }
            }
        }

        Loader {
            id: __dividerLoader
            height: 5
            width: parent.width
            active: __rootItem.menuType == "divider"
            sourceComponent: DelDivider { }
        }

        Item {
            id: __layout
            width: parent.width
            height: __menuButton.height + ((control.compactMode || control.popupMode) ? 0 : __childrenListView.height)
            visible: menuType == "item" || menuType == "group"

            MenuButton {
                id: __menuButton
                width: parent.width
                height: __rootItem.menuHeight
                enabled: __rootItem.menuEnabled
                text: (control.compactMode && __rootItem.view.menuDeep === 0) ? "" : __rootItem.menuLabel
                checkable: true
                iconSize: __rootItem.menuIconSize
                iconSource: __rootItem.menuIconSource
                iconSpacing: __rootItem.menuIconSpacing
                iconStart: (control.compactMode && __rootItem.view.menuDeep === 0) ? (parent.width - width) * 0.5 : 0
                expandedVisible: {
                    if (__rootItem.menuType == "group" ||
                            (control.compactMode && __rootItem.view.menuDeep === 0))
                        return false;
                    else
                        return __rootItem.menuChildrenLength > 0
                }
                isCurrent: __rootItem.isCurrent
                isGroup: __rootItem.menuType == "group"
                onClicked: {
                    if (__rootItem.menuChildrenLength == 0) {
                        control.clickMenu(__rootItem.view.menuDeep, __rootItem.menuKey, model);
                        __private.selectedItem = __rootItem;
                        __rootItem.selectedCurrentParentMenu();
                        if (control.compactMode || control.popupMode)
                            __rootItem.layerPopup.closeWithParent();
                    } else {
                        if (control.compactMode || control.popupMode) {
                            const h = __rootItem.layerPopup.topPadding +
                                    __rootItem.layerPopup.bottomPadding +
                                    __childrenListView.realHeight + 6;
                            const pos = mapToItem(null, 0, 0);
                            const pos2 = mapToItem(control, 0, 0);
                            if ((pos.y + h) > __private.window.height) {
                                __rootItem.layerPopup.y = Math.max(0, pos2.y - ((pos.y + h) - __private.window.height));
                            } else {
                                __rootItem.layerPopup.y = pos2.y;
                            }
                            __rootItem.layerPopup.current = __childrenListView;
                            __rootItem.layerPopup.open();
                        }
                    }
                }

                DelToolTip {
                    position: DelToolTip.Position_Right
                    text: __rootItem.menuLabel
                    visible: {
                        if (control.compactMode || control.popupMode)
                            return (__rootItem.layerPopup && !__rootItem.layerPopup.opened) ? parent.hovered : false;
                        else
                            return false;
                    }
                }
            }

            ListView {
                id: __childrenListView
                visible: __rootItem.menuEnabled
                parent: {
                    if (__rootItem.layerPopup && __rootItem.layerPopup.current === __childrenListView)
                        return __rootItem.layerPopup.contentItem;
                    else
                        return __layout;
                }
                height: {
                    if (__rootItem.menuType == "group" || __menuButton.expanded)
                        return realHeight;
                    else if (parent != __layout)
                        return parent.height;
                    else
                        return 0;
                }
                anchors.top: parent ? (parent == __layout ? __menuButton.bottom : parent.top) : undefined
                anchors.topMargin: parent == __layout ? control.defaultMenuSpacing : 0
                anchors.left: parent ? parent.left : undefined
                anchors.leftMargin: (control.compactMode || control.popupMode) ? 0 : __menuButton.iconSize * menuDeep
                anchors.right: parent ? parent.right : undefined
                spacing: control.defaultMenuSpacing
                boundsBehavior: Flickable.StopAtBounds
                interactive: __childrenListView.visible
                model: []
                delegate: menuDelegate
                onContentHeightChanged: cacheBuffer = contentHeight;
                T.ScrollBar.vertical: DelScrollBar {
                    id: childrenScrollBar
                    visible: (control.compactMode || control.popupMode) && childrenScrollBar.size !== 1
                }
                clip: true
                /* 子 ListView 从父 ListView 的深度累加可实现自动计算 */
                property int menuDeep: __rootItem.view.menuDeep + 1
                property var parentMenu: __rootItem
                property int realHeight: (contentHeight + ((count === 0 || control.compactMode) ? 0 : control.defaultMenuSpacing))

                Behavior on height {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: DelTheme.Primary.durationFast }
                }

                Connections {
                    target: control
                    function onCompactModeChanged() {
                        if (__rootItem.layerPopup) {
                            __rootItem.layerPopup.current = null;
                            __rootItem.layerPopup.close();
                        }
                    }
                    function onPopupModeChanged() {
                        if (__rootItem.layerPopup) {
                            __rootItem.layerPopup.current = null;
                            __rootItem.layerPopup.close();
                        }
                    }
                }
            }
        }
    }

    onInitModelChanged: {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    function gotoMenu(key) {
        __private.gotoMenu(key);
    }

    function get(index) {
        if (index >= 0 && index < __listView.model.length) {
            return __listView.model[index];
        }
        return undefined;
    }

    function set(index, object) {
        if (index >= 0 && index < __listView.model.length) {
            __listView.model[index] = object;
            __listView.modelChanged();
        }
    }

    function setProperty(index, propertyName, value) {
        if (index >= 0 && index < __listView.model.length) {
            __listView.model[index][propertyName] = value;
            __listView.modelChanged();
        }
    }

    function move(from, to, count = 1) {
        if (from >= 0 && from < __listView.model.length && to >= 0 && to < __listView.model.length) {
            const objects = __listView.model.splice(from, count);
            __listView.model.splice(to, 0, ...objects);
            __listView.modelChanged();
        }
    }

    function insert(index, object) {
        __listView.model.splice(index, 0, object);
        __listView.modelChanged();
    }

    function append(object) {
        __listView.model.push(object);
        __listView.modelChanged();
    }

    function remove(index, count = 1) {
        if (index >= 0 && index < __listView.model.length) {
            __listView.model.splice(index, count);
            __listView.modelChanged();
        }
    }

    function clear() {
        __listView.model = [];
    }

    component MenuButton: DelButton {
        id: __menuButtonImpl
        property int iconSource: 0
        property int iconSize: DelTheme.DelMenu.fontSize
        property int iconSpacing: 5
        property int iconStart: 0
        property bool expanded: false
        property bool expandedVisible: false
        property bool isCurrent: false
        property bool isGroup: false
        onClicked: {
            if (expandedVisible)
                expanded = !expanded;
        }
        hoverCursorShape: (isGroup && !control.compactMode) ? Qt.ArrowCursor : Qt.PointingHandCursor
        effectEnabled: false
        colorBorder: "transparent"
        colorText: {
            if (enabled) {
                if (isGroup) {
                    return (isCurrent && control.compactMode) ? DelTheme.DelMenu.colorTextActive : DelTheme.DelMenu.colorTextDisabled;
                } else {
                    return isCurrent ? DelTheme.DelMenu.colorTextActive : DelTheme.DelMenu.colorText;
                }
            } else {
                return DelTheme.DelMenu.colorTextDisabled;
            }
        }
        colorBg: {
            if (enabled) {
                if (isGroup)
                    return (isCurrent && control.compactMode) ? DelTheme.DelMenu.colorBgActive : DelTheme.DelMenu.colorBgDisabled;
                else if (isCurrent)
                    return DelTheme.DelMenu.colorBgActive;
                else if (hovered) {
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
                x: __menuButtonImpl.iconStart
                anchors.verticalCenter: parent.verticalCenter
                color: __menuButtonImpl.colorText
                iconSize: __menuButtonImpl.iconSize
                iconSource: __menuButtonImpl.iconSource
                verticalAlignment: Text.AlignVCenter

                Behavior on x {
                    enabled: control.animationEnabled
                    NumberAnimation { easing.type: Easing.OutCubic; duration: DelTheme.Primary.durationMid }
                }
                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }

            Text {
                id: __text
                anchors.left: __icon.right
                anchors.leftMargin: __menuButtonImpl.iconSpacing
                anchors.right: __menuButtonImpl.expandedVisible ? __expandedIcon.left : parent.right
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
                anchors.verticalCenter: parent.verticalCenter
                visible: __menuButtonImpl.expandedVisible
                iconSource: (control.compactMode || control.popupMode) ? DelIcon.RightOutlined : DelIcon.DownOutlined
                colorIcon: __menuButtonImpl.colorText
                transform: Rotation {
                    origin {
                        x: __expandedIcon.width * 0.5
                        y: __expandedIcon.height * 0.5
                    }
                    axis {
                        x: 1
                        y: 0
                        z: 0
                    }
                    angle: (control.compactMode || control.popupMode) ? 0 : (__menuButtonImpl.expanded ? 180 : 0)
                    Behavior on angle { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }
                }
                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }
        }
    }

    Behavior on width {
        enabled: control.animationEnabled
        NumberAnimation {
            easing.type: Easing.OutCubic
            duration: DelTheme.Primary.durationMid
        }
    }

    Item {
        id: __private
        signal gotoMenu(key: string)
        property var window: Window.window
        property var selectedItem: null
        property var popupList: []
        function createPopupList(deep) {
            /*! 为每一层创建一个弹窗 */
            if (popupList[deep] === undefined) {
                let parentPopup = deep > 0 ? popupList[deep - 1] : null;
                popupList[deep] = __popupComponent.createObject(control, { parentPopup: parentPopup });
            }
            return popupList[deep];
        }
    }

    Loader {
        width: 1
        height: parent.height
        anchors.right: parent.right
        active: control.showEdge
        sourceComponent: Rectangle {
            color: DelTheme.DelMenu.colorEdge
        }
    }

    MouseArea {
        anchors.fill: parent
        onWheel: (wheel) => wheel.accepted = true;
    }

    Component {
        id: __popupComponent

        DelPopup {
            width: control.popupWidth
            height: current ? Math.min(control.popupMaxHeight, current.realHeight + topPadding + bottomPadding) : 0
            padding: 5
            onAboutToShow: {
                let toX = control.width + 4;
                if (parentPopup) {
                    toX += parentPopup.width + 4;
                }
                x = toX;
            }
            property var current: null
            property var parentPopup: null
            function closeWithParent() {
                close();
                let p = parentPopup;
                while (p) {
                    p.close();
                    p = p.parentPopup;
                }
            }
        }
    }

    ListView {
        id: __listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 5
        boundsBehavior: Flickable.StopAtBounds
        spacing: control.defaultMenuSpacing
        model: []
        delegate: menuDelegate
        onContentHeightChanged: cacheBuffer = contentHeight;
        T.ScrollBar.vertical: DelScrollBar {
            anchors.rightMargin: -8
            policy: control.compactMode ? DelScrollBar.AsNeeded : DelScrollBar.AlwaysOn
        }
        property int menuDeep: 0
    }

    Accessible.role: Accessible.Tree
    Accessible.description: control.contentDescription
}

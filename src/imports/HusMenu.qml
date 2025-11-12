import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

Item {
    id: control

    enum CompactMode {
        Mode_Relaxed = 0,
        Mode_Standard = 1,
        Mode_Compact = 2
    }

    signal clickMenu(deep: int, key: string, keyPath: var, data: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property bool showEdge: false
    property bool showToolTip: false
    property int compactMode: HusMenu.Mode_Relaxed
    property int compactWidth: {
        switch (compactMode) {
        case HusMenu.Mode_Relaxed: return 0;
        case HusMenu.Mode_Standard: return 80;
        case HusMenu.Mode_Compact: return 52;
        }
    }
    property bool popupMode: false
    property int popupWidth: 200
    property int popupOffset: 4
    property int popupMaxHeight: control.height
    property int defaultMenuIconSize: parseInt(HusTheme.HusMenu.fontSize)
    property int defaultMenuIconSpacing: 8
    property int defaultMenuWidth: 300
    property int defaultMenuTopPadding: 10
    property int defaultMenuBottomPadding: 10
    property int defaultMenuSpacing: 4
    property var defaultSelectedKey: []
    property var initModel: []
    property alias scrollBar: __menuScrollBar
    property HusRadius radiusMenuBg: HusRadius { all: HusTheme.HusMenu.radiusMenuBg }
    property HusRadius radiusPopupBg: HusRadius { all: HusTheme.HusMenu.radiusPopupBg }
    readonly property real implicitMenuHeight: __listView.contentHeight + __listView.anchors.topMargin + __listView.anchors.bottomMargin
    property string contentDescription: ''

    property Component menuIconDelegate: HusIconText {
        color: menuButton.colorText
        iconSize: menuButton.iconSize
        iconSource: menuButton.iconSource
        verticalAlignment: Text.AlignVCenter

        Behavior on x {
            enabled: control.animationEnabled
            NumberAnimation { easing.type: Easing.OutCubic; duration: HusTheme.Primary.durationMid }
        }
        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    }
    property Component menuLabelDelegate: HusText {
        text: menuButton.text
        font: menuButton.font
        color: menuButton.colorText
        elide: Text.ElideRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    }
    property Component menuBgDelegate: HusRectangleInternal {
        radius: control.radiusMenuBg.all
        topLeftRadius: control.radiusMenuBg.topLeft
        topRightRadius: control.radiusMenuBg.topRight
        bottomLeftRadius: control.radiusMenuBg.bottomLeft
        bottomRightRadius: control.radiusMenuBg.bottomRight
        color: menuButton.colorBg

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
        Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    }
    property Component menuContentDelegate: Item {
        id: __menuContentItem

        property var __menuButton: menuButton
        property bool isVertical: control.compactMode === HusMenu.Mode_Standard && menuButton.menuDeep === 0

        implicitHeight: isVertical ? __columnLayout.implicitHeight : __rowLayout.implicitHeight

        ColumnLayout {
            id: __columnLayout
            visible: __menuContentItem.isVertical
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: menuButton.iconSpacing

            Loader {
                active: __menuContentItem.isVertical
                visible: active
                Layout.alignment: Qt.AlignHCenter
                sourceComponent: menuButton.iconDelegate
                property var model: __menuButton.model
                property alias menuButton: __menuContentItem.__menuButton
            }

            Loader {
                active: __menuContentItem.isVertical
                visible: active
                Layout.alignment: Qt.AlignHCenter
                sourceComponent: menuButton.labelDelegate
                property var model: __menuButton.model
                property alias menuButton: __menuContentItem.__menuButton
            }
        }

        RowLayout {
            id: __rowLayout
            visible: !__menuContentItem.isVertical
            anchors.left: parent.left
            anchors.right: menuButton.expandedVisible ? __expandedIcon.left : parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: menuButton.iconSpacing

            Loader {
                active: !__menuContentItem.isVertical
                visible: active
                sourceComponent: menuButton.iconDelegate
                property var model: __menuButton.model
                property alias menuButton: __menuContentItem.__menuButton
            }

            Loader {
                active: !__menuContentItem.isVertical
                visible: active
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
            iconSource: (control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode) ? HusIcon.RightOutlined : HusIcon.DownOutlined
            colorIcon: menuButton.colorText
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
                angle: (control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode) ? 0 : (menuButton.expanded ? 180 : 0)
                Behavior on angle { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
            }
            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
        }
    }

    objectName: '__HusMenu__'
    implicitWidth: compactMode !== HusMenu.Mode_Relaxed ? compactWidth : defaultMenuWidth
    implicitHeight: __listView.contentHeight + __listView.anchors.topMargin + __listView.anchors.bottomMargin
    clip: true
    onInitModelChanged: {
        __listView.model = initModel;
    }

    function gotoMenu(key) {
        __private.gotoMenuKey = key;
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

    /*
    function getData(key) {
        const findItemFunc = list => {
            for (const item of list) {
                if (item.hasOwnProperty('key') && item.key === key) {
                    return item;
                } else {
                    if (item.hasOwnProperty('menuChildren')) {
                        const data = findItemFunc(item.menuChildren);
                        if (data !== undefined) {
                            return data;
                        }
                    }
                }
            }
            return undefined;
        }

        return findItemFunc(__listView.model);
    }
    */

    function setData(key, data) {
        const setItemFunc = list => {
            for (let i = 0; i < list.length; i++) {
                let item = list[i];
                if (item.hasOwnProperty('key') && item.key === key) {
                    list[i] = data;
                    return true;
                } else {
                    if (item.hasOwnProperty('menuChildren')) {
                        if (setItemFunc(item.menuChildren)) {
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        if (setItemFunc(__listView.model)) {
            __private.setData(key, data);
        }
    }

    function setDataProperty(key, propertyName, value) {
        const setItemFunc = list => {
            for (let i = 0; i < list.length; i++) {
                let item = list[i];
                if (item.hasOwnProperty('key') && item.key === key) {
                    list[i][propertyName] = value;
                    return true;
                } else {
                    if (item.hasOwnProperty('menuChildren')) {
                        if (setItemFunc(item.menuChildren)) {
                            return true;
                        }
                    }
                }
            }
            return false;
        }
        if (setItemFunc(__listView.model)) {
            __private.setDataProperty(key, propertyName, value);
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
        __private.gotoMenuKey = '';
        __listView.model = [];
    }

    component MenuButton: HusButton {
        id: __menuButtonImpl

        property var iconSource: 0 ?? ''
        property int iconSize: parseInt(HusTheme.HusMenu.fontSize)
        property int iconSpacing: 5
        property bool expanded: false
        property bool showExpanded: false
        property bool isCurrent: false
        property bool isGroup: false
        property var model: undefined
        property int menuDeep: -1
        property var iconDelegate: null
        property var labelDelegate: null
        property var contentDelegate: null
        property var bgDelegate: null

        onClicked: {
            if (showExpanded)
                expanded = !expanded;
        }
        hoverCursorShape: (isGroup && !control.compactMode !== HusMenu.Mode_Relaxed) ? Qt.ArrowCursor : Qt.PointingHandCursor
        animationEnabled: control.animationEnabled
        effectEnabled: false
        colorBorder: 'transparent'
        colorText: {
            if (enabled) {
                if (isGroup) {
                    return (isCurrent && control.compactMode !== HusMenu.Mode_Relaxed) ? HusTheme.HusMenu.colorTextActive :
                                                                                         HusTheme.HusMenu.colorTextDisabled;
                } else {
                    return isCurrent ? HusTheme.HusMenu.colorTextActive : HusTheme.HusMenu.colorText;
                }
            } else {
                return HusTheme.HusMenu.colorTextDisabled;
            }
        }
        colorBg: {
            if (enabled) {
                if (isGroup)
                    return (isCurrent && control.compactMode !== HusMenu.Mode_Relaxed) ? HusTheme.HusMenu.colorBgActive :
                                                                                         HusTheme.HusMenu.colorBgDisabled;
                else if (isCurrent)
                    return HusTheme.HusMenu.colorBgActive;
                else if (hovered) {
                    return HusTheme.HusMenu.colorBgHover;
                } else {
                    return HusTheme.HusMenu.colorBg;
                }
            } else {
                return HusTheme.HusMenu.colorBgDisabled;
            }
        }
        contentItem: Loader {
            sourceComponent: __menuButtonImpl.contentDelegate
            property alias model: __menuButtonImpl.model
            property alias menuButton: __menuButtonImpl
        }
        background: Loader {
            sourceComponent: __menuButtonImpl.bgDelegate
            property alias model: __menuButtonImpl.model
            property alias menuButton: __menuButtonImpl
        }
    }

    Behavior on width {
        enabled: control.animationEnabled
        NumberAnimation {
            easing.type: Easing.OutCubic
            duration: HusTheme.Primary.durationMid
        }
    }

    Behavior on implicitWidth {
        enabled: control.animationEnabled
        NumberAnimation {
            easing.type: Easing.OutCubic
            duration: HusTheme.Primary.durationMid
        }
    }

    Component {
        id: __menuDelegate

        Item {
            id: __rootItem
            width: ListView.view.width
            height: {
                switch (menuType) {
                case 'item':
                case 'group':
                    return __layout.height;
                case 'divider':
                    return __dividerLoader.height;
                default:
                    return __layout.height;
                }
            }
            clip: true
            Component.onCompleted: {
                if (menuType == 'item' || menuType == 'group') {
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
                if (__rootItem.menuKey !== '' && __rootItem.menuKey === __private.gotoMenuKey) {
                    __rootItem.expandParent();
                    __menuButton.clicked();
                }
            }

            required property var modelData
            property alias model: __rootItem.modelData
            property var view: ListView.view
            property string menuKey: model.key || ''
            property string menuType: model.type || 'item'
            property bool menuEnabled: model.enabled === undefined ? true : model.enabled
            property string menuLabel: model.label || ''
            property string menuShortLabel: model.shortLabel || menuLabel
            property int menuIconSize: model.iconSize || control.defaultMenuIconSize
            property var menuIconSource: model.iconSource || 0
            property int menuIconSpacing: model.iconSpacing || defaultMenuIconSpacing
            property var menuChildren: model.menuChildren || []
            property int menuChildrenLength: menuChildren ? menuChildren.length : 0
            property var menuIconDelegate: model.hasOwnProperty('iconDelegate') ? model.iconDelegate : control.menuIconDelegate
            property var menuLabelDelegate: model.hasOwnProperty('labelDelegate') ? model.labelDelegate : control.menuLabelDelegate
            property var menuContentDelegate: model.hasOwnProperty('contentDelegate') ? model.contentDelegate : control.menuContentDelegate
            property var menuBgDelegate: model.hasOwnProperty('bgDelegate') ? model.bgDelegate : control.menuBgDelegate
            property var parentMenu: view.menuDeep === 0 ? null : view.parentMenu
            property var keyPath: parentMenu ? [...parentMenu.keyPath, menuKey] : [menuKey]
            property bool isCurrent: __private.selectedItem === __rootItem || isCurrentParent
            property bool isCurrentParent: false
            property var layerPopup: null

            function clickMenu() {
                control.clickMenu(view.menuDeep, menuKey, keyPath, model);
            }

            function expandMenu() {
                if (__menuButton.showExpanded) {
                    __menuButton.expanded = true;
                }
                __rootItem.clickMenu();
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
                enabled: __rootItem.menuKey !== ''
                ignoreUnknownSignals: true

                function onGotoMenu(key) {
                    if (__rootItem.menuKey === key) {
                        __rootItem.expandParent();
                        __menuButton.clicked();
                    }
                }

                function onSetData(key, data) {
                    if (__rootItem.menuKey === key) {
                        __rootItem.model = data;
                        __rootItem.modelChanged();
                    }
                }

                function onSetDataProperty(key, propertyName, value) {
                    if (__rootItem.menuKey === key) {
                        __rootItem.model[propertyName] = value;
                        __rootItem.modelChanged();
                    }
                }
            }

            Loader {
                id: __dividerLoader
                height: 5
                width: parent.width
                active: __rootItem.menuType == 'divider'
                sourceComponent: HusDivider {
                    animationEnabled: control.animationEnabled
                }
            }

            Rectangle {
                id: __layout
                width: parent.width
                height: control.defaultMenuSpacing + __menuButton.height
                        + ((control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode) ? 0 : __childrenListView.height)
                anchors.top: parent.top
                color: (__rootItem.view.menuDeep === 0 ||
                        control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode) ? 'transparent' : HusTheme.HusMenu.colorChildBg
                visible: __rootItem.menuType == 'item' || __rootItem.menuType == 'group'

                MenuButton {
                    id: __menuButton
                    implicitWidth: parent.width
                    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                             implicitContentHeight + topPadding + bottomPadding) + control.defaultMenuSpacing
                    anchors.top: parent.top
                    anchors.topMargin: control.defaultMenuSpacing
                    topPadding: control.defaultMenuTopPadding
                    bottomPadding: control.defaultMenuBottomPadding
                    leftPadding: 12 + (control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode ? 0 : iconSize * __rootItem.view.menuDeep)
                    enabled: __rootItem.menuEnabled
                    radiusBg: control.radiusMenuBg
                    text: {
                        switch (control.compactMode) {
                        case HusMenu.Mode_Relaxed: return __rootItem.menuLabel;
                        case HusMenu.Mode_Standard: return __rootItem.view.menuDeep === 0 ? __rootItem.menuShortLabel : __rootItem.menuLabel;
                        case HusMenu.Mode_Compact: return __rootItem.view.menuDeep === 0 ? '' : __rootItem.menuLabel;
                        }
                    }
                    checkable: true
                    iconSize: __rootItem.menuIconSize
                    iconSource: __rootItem.menuIconSource
                    iconSpacing: __rootItem.menuIconSpacing
                    showExpanded: {
                        if (__rootItem.menuType == 'group' ||
                                (control.compactMode !== HusMenu.Mode_Relaxed && __rootItem.view.menuDeep === 0))
                            return false;
                        else
                            return __rootItem.menuChildrenLength > 0;
                    }
                    isCurrent: __rootItem.isCurrent
                    isGroup: __rootItem.menuType === 'group'
                    model: __rootItem.model
                    menuDeep: __rootItem.view.menuDeep
                    iconDelegate: __rootItem.menuIconDelegate
                    labelDelegate: __rootItem.menuLabelDelegate
                    contentDelegate: __rootItem.menuContentDelegate
                    bgDelegate: __rootItem.menuBgDelegate
                    onClicked: {
                        __rootItem.clickMenu();
                        if (__rootItem.menuChildrenLength == 0) {
                            __private.selectedItem = __rootItem;
                            __rootItem.selectedCurrentParentMenu();
                            if (control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode)
                                __rootItem.layerPopup.closeWithParent();
                        } else {
                            if (control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode) {
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

                    HusToolTip {
                        visible: control.showToolTip ? parent.hovered : false
                        animationEnabled: control.animationEnabled
                        position: control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode ? HusToolTip.Position_Right :
                                                                                                      HusToolTip.Position_Bottom
                        text: __rootItem.menuLabel
                        delay: 500
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
                        if (__rootItem.menuType == 'group' || __menuButton.expanded)
                            return realHeight;
                        else if (parent != __layout)
                            return parent.height;
                        else
                            return 0;
                    }
                    anchors.top: parent ? (parent == __layout ? __menuButton.bottom : parent.top) : undefined
                    anchors.left: parent ? parent.left : undefined
                    anchors.right: parent ? parent.right : undefined
                    boundsBehavior: Flickable.StopAtBounds
                    interactive: __childrenListView.visible
                    model: []
                    delegate: __menuDelegate
                    onContentHeightChanged: cacheBuffer = contentHeight;
                    T.ScrollBar.vertical: HusScrollBar {
                        id: childrenScrollBar
                        visible: (control.compactMode !== HusMenu.Mode_Relaxed || control.popupMode) && childrenScrollBar.size !== 1
                        animationEnabled: control.animationEnabled
                    }
                    clip: true
                    /* 子 ListView 从父 ListView 的深度累加可实现自动计算 */
                    property int menuDeep: __rootItem.view.menuDeep + 1
                    property var parentMenu: __rootItem
                    property int realHeight: contentHeight

                    Behavior on height {
                        enabled: control.animationEnabled
                        NumberAnimation { duration: HusTheme.Primary.durationFast }
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
    }

    Item {
        id: __private

        signal gotoMenu(key: string)
        signal setData(key: string, data: var)
        signal setDataProperty(key: string, propertyName: string, value: var)

        property string gotoMenuKey: ''
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
            color: HusTheme.HusMenu.colorEdge
        }
    }

    MouseArea {
        anchors.fill: parent
        onWheel: (wheel) => wheel.accepted = true;
    }

    Component {
        id: __popupComponent

        HusPopup {
            width: control.popupWidth
            height: current ? Math.min(control.popupMaxHeight, current.realHeight + topPadding + bottomPadding) : 0
            padding: 5
            animationEnabled: control.animationEnabled
            radiusBg: control.radiusPopupBg
            contentItem: Item { clip: true }
            onAboutToShow: {
                let toX = control.width + control.popupOffset;
                if (parentPopup) {
                    toX += parentPopup.width + control.popupOffset;
                }
                const pos = mapToItem(null, toX, 0);
                if (pos.x + width > __private.window.width) {
                    if (parentPopup) {
                        x = parentPopup.x - parentPopup.width - control.popupOffset;
                    } else {
                        x = -width - control.popupOffset;
                    }
                } else {
                    x = toX;
                }
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
        model: []
        delegate: __menuDelegate
        onContentHeightChanged: cacheBuffer = contentHeight;
        T.ScrollBar.vertical: HusScrollBar {
            id: __menuScrollBar
            anchors.rightMargin: -8
            policy: T.ScrollBar.AsNeeded
            animationEnabled: control.animationEnabled
        }
        property int menuDeep: 0
    }

    Accessible.role: Accessible.Tree
    Accessible.description: control.contentDescription
}

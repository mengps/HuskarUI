/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

import QtQuick

import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

T.Control {
    id: control
    clip: true

    enum TabPosition
    {
        Position_Top = 0,
        Position_Bottom = 1,
        Position_Left = 2,
        Position_Right = 3
    }

    enum TabType
    {
        Type_Default = 0,
        Type_Card = 1,
        Type_CardEditable = 2
    }

    enum TabSize
    {
        Size_Auto = 0,
        Size_Fixed = 1
    }

    enum TabAlign
    {
        Align_Center = 0,
        Align_Left = 1,
        Align_Right = 2
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property var initModel: []
    property alias count: __tabModel.count
    property alias currentIndex: __tabView.currentIndex
    property int tabType: HusTabView.Type_Default
    property int tabSize: HusTabView.Size_Auto
    property int tabPosition: HusTabView.Position_Top
    property int tabAlign: HusTabView.Align_Center
    property bool tabAddable: false
    property bool tabCentered: false
    property bool tabCardMovable: true
    property int defaultTabWidth: 80
    property int defaultTabHeight: parseInt(themeSource.fontSize) + 16
    property alias defaultTabSpacing: control.spacing
    property int defaultTabIconSpacing: 2
    property int defaultTabLeftPadding: 8
    property int defaultTabRightPadding: 8
    property int defaultHighlightWidth: __private.isHorizontal ? 30 : 20
    property var addTabCallback:
        () => {
            append({ title: `New Tab ${__tabView.count + 1}` });
            positionViewAtEnd();
        }
    property var closeTabCallback:
        (index, data) => {
            remove(index);
        }
    property color colorTabCardBg: themeSource.colorTabCardBg
    property color colorTabCardBgActive: themeSource.colorTabCardBgActive
    property color colorTabCardBorder: themeSource.colorTabCardBorder
    property color colorTabCardBorderActive: themeSource.colorTabCardBorderActive
    property HusRadius radiusTabBg: HusRadius { all: themeSource.radiusTabBg }
    property var themeSource: HusTheme.HusTabView

    property Component addButtonDelegate: HusCaptionButton {
        id: __addButton
        animationEnabled: control.animationEnabled
        iconSize: parseInt(control.themeSource.fontSize)
        iconSource: HusIcon.PlusOutlined
        colorIcon: control.themeSource.colorTabCloseHover
        hoverCursorShape: Qt.PointingHandCursor
        radiusBg.all: control.themeSource.radiusButton
        onClicked: addTabCallback();
    }
    property Component tabDelegate: tabType == HusTabView.Type_Default ? __defaultTabDelegate : __cardTabDelegate
    property Component contentDelegate: Item { }
    property Component highlightDelegate: Item {
        Loader {
            id: __highlight
            width: __private.isHorizontal ? defaultHighlightWidth : 2
            height: __private.isHorizontal ? 2 : defaultHighlightWidth
            anchors {
                bottom: control.tabPosition == HusTabView.Position_Top ? parent.bottom : undefined
                right: control.tabPosition == HusTabView.Position_Left ? parent.right : undefined
            }
            state: __content.state
            states: [
                State {
                    name: 'top'
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: parent.bottom
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'bottom'
                    AnchorChanges {
                        target: __highlight
                        anchors.top: parent.top
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'left'
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: parent.right
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: parent.verticalCenter
                    }
                },
                State {
                    name: 'right'
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: parent.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            ]
            active: control.tabType === HusTabView.Type_Default
            sourceComponent: Rectangle {
                color: HusTheme.isDark ? control.themeSource.colorHightlightDark : control.themeSource.colorHightlight
            }
        }
    }

    function setCurrentIndex(index: int) {
        currentIndex = index;
    }

    function flick(xVelocity: real, yVelocity: real) {
        __tabView.flick(xVelocity, yVelocity);
    }

    function positionViewAtBeginning() {
        __tabView.positionViewAtBeginning();
    }

    function positionViewAtIndex(index: int, mode: int) {
        __tabView.positionViewAtIndex(index, mode);
    }

    function positionViewAtEnd() {
        __tabView.positionViewAtEnd();
    }

    function get(index: int): var {
        return __tabModel.get(index);
    }

    function set(index: int, object: var) {
        /*! 默认为true */
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.set(index, object);
    }

    function setProperty(index: int, propertyName: string, value: var) {
        __tabModel.setProperty(index, propertyName, value);
    }

    function move(from: int, to: int, count = 1) {
        __tabModel.move(from, to, count);
    }

    function insert(index: int, object: var) {
        /*! 默认为true */
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.insert(index, object);
    }

    function append(object: var) {
        /*! 默认为true */
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.append(object);
    }

    function remove(index: int, count = 1) {
        __tabModel.remove(index, count);
    }

    function clear() {
        __tabModel.clear();
    }

    onInitModelChanged: {
        clear();
        /**
         * [Warning]
         * ListModel 的静态角色类型下, 如果某一条数据了单独的内容代理, 就必须同时为其他数据设置默认代理,
         * 所以我们这里需要进行两遍遍历, (另一种方式是设置 dynamicRoles, 但会大幅降低性能)
         */
        const hasContentDelegate = initModel.some(item => 'contentDelegate' in item);
        for (const object of initModel) {
            if (hasContentDelegate && !object.hasOwnProperty('contentDelegate')) {
                object.contentDelegate = control.contentDelegate;
            }
            append(object);
        }
    }

    objectName: '__HusTabView__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    spacing: 2
    contentItem: Item {
        id: __contentItem

        MouseArea {
            anchors.fill: __tabView
            onWheel:
                wheel => {
                    if (__private.isHorizontal)
                    __tabView.flick(wheel.angleDelta.y * 6.5, 0);
                    else
                    __tabView.flick(0, wheel.angleDelta.y * 6.5);
                }
        }

        ListView {
            id: __tabView
            width: {
                if (__private.isHorizontal) {
                    const maxWidth = __contentItem.width - (__addButtonLoader.width + 5) * (control.tabCentered ? 2 : 1);
                    return (control.tabCentered ? Math.min(contentWidth, maxWidth) : maxWidth);
                } else {
                    return __private.tabMaxWidth;
                }
            }
            height: {
                if (__private.isHorizontal) {
                    return defaultTabHeight;
                } else {
                    const maxHeight = __contentItem.height - (__addButtonLoader.height + 5) * (control.tabCentered ? 2 : 1);
                    return (control.tabCentered ? Math.min(contentHeight, maxHeight) : maxHeight)
                }
            }
            clip: true
            onContentWidthChanged: if (__private.isHorizontal) cacheBuffer = contentWidth;
            onContentHeightChanged: if (!__private.isHorizontal) cacheBuffer = contentHeight;
            spacing: defaultTabSpacing
            move: Transition {
                NumberAnimation { properties: 'x,y'; duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 }
            }
            model: ListModel { id: __tabModel }
            delegate: tabDelegate
            highlight: highlightDelegate
            highlightMoveDuration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            orientation: __private.isHorizontal ? Qt.Horizontal : Qt.Vertical
            boundsBehavior: Flickable.StopAtBounds
            state: control.tabCentered ? (__content.state + 'Center') : __content.state
            states: [
                State {
                    name: 'top'
                    AnchorChanges {
                        target: __tabView
                        anchors.top: __contentItem.top
                        anchors.bottom: undefined
                        anchors.left: __contentItem.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'topCenter'
                    AnchorChanges {
                        target: __tabView
                        anchors.top: __contentItem.top
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: __contentItem.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'bottom'
                    AnchorChanges {
                        target: __tabView
                        anchors.top: undefined
                        anchors.bottom: __contentItem.bottom
                        anchors.left: __contentItem.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'bottomCenter'
                    AnchorChanges {
                        target: __tabView
                        anchors.top: undefined
                        anchors.bottom: __contentItem.bottom
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: __contentItem.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'left'
                    AnchorChanges {
                        target: __tabView
                        anchors.top: __contentItem.top
                        anchors.bottom: undefined
                        anchors.left: __contentItem.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'leftCenter'
                    AnchorChanges {
                        target: __tabView
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: __contentItem.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: __contentItem.verticalCenter
                    }
                },
                State {
                    name: 'right'
                    AnchorChanges {
                        target: __tabView
                        anchors.top: __contentItem.top
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: __contentItem.right
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: 'rightCenter'
                    AnchorChanges {
                        target: __tabView
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: __contentItem.right
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: __contentItem.verticalCenter
                    }
                }
            ]
        }

        Loader {
            id: __addButtonLoader
            active: control.tabAddable
            x: {
                switch (tabPosition) {
                case HusTabView.Position_Top:
                case HusTabView.Position_Bottom:
                    return Math.min(__tabView.x + __tabView.contentWidth + 5, __contentItem.width - width);
                case HusTabView.Position_Left:
                    return Math.max(0, __tabView.width - width);
                case HusTabView.Position_Right:
                    return Math.max(0, __tabView.x);
                }
            }
            y: {
                switch (tabPosition) {
                case HusTabView.Position_Top:
                    return Math.max(0, __tabView.y + __tabView.height - height);
                case HusTabView.Position_Bottom:
                    return __tabView.y;
                case HusTabView.Position_Left:
                case HusTabView.Position_Right:
                    return Math.min(__tabView.y + __tabView.contentHeight + 5, __contentItem.height - height);
                }
            }
            z: 10
            sourceComponent: addButtonDelegate
        }

        Item {
            id: __content
            state: {
                switch (tabPosition) {
                case HusTabView.Position_Top: return 'top';
                case HusTabView.Position_Bottom: return 'bottom';
                case HusTabView.Position_Left: return 'left';
                case HusTabView.Position_Right: return 'right';
                }
            }
            states: [
                State {
                    name: 'top'
                    AnchorChanges {
                        target: __content
                        anchors.top: __tabView.bottom
                        anchors.bottom: __contentItem.bottom
                        anchors.left: __contentItem.left
                        anchors.right: __contentItem.right
                    }
                },
                State {
                    name: 'bottom'
                    AnchorChanges {
                        target: __content
                        anchors.top: __contentItem.top
                        anchors.bottom: __tabView.top
                        anchors.left: __contentItem.left
                        anchors.right: __contentItem.right
                    }
                },
                State {
                    name: 'left'
                    AnchorChanges {
                        target: __content
                        anchors.top: __contentItem.top
                        anchors.bottom: __contentItem.bottom
                        anchors.left: __tabView.right
                        anchors.right: __contentItem.right
                    }
                },
                State {
                    name: 'right'
                    AnchorChanges {
                        target: __content
                        anchors.top: __contentItem.top
                        anchors.bottom: __contentItem.bottom
                        anchors.left: __contentItem.left
                        anchors.right: __tabView.left
                    }
                }
            ]

            Repeater {
                model: __tabModel
                delegate: Loader {
                    id: __contentLoader
                    anchors.fill: parent
                    sourceComponent: model.contentDelegate ?? control.contentDelegate
                    visible: __tabView.currentIndex === index
                    required property int index
                    required property var model
                }
            }
        }
    }

    Component {
        id: __defaultTabDelegate

        HusIconButton {
            id: __tabItem
            width: (!__private.isHorizontal && control.tabSize == HusTabView.Size_Auto) ? Math.max(__private.tabMaxWidth, tabWidth) : tabWidth
            height: tabHeight
            leftPadding: control.defaultTabLeftPadding
            rightPadding: control.defaultTabRightPadding
            iconSize: tabIconSize
            iconSource: tabIcon
            text: tabTitle
            animationEnabled: control.animationEnabled
            effectEnabled: false
            colorBg: 'transparent'
            colorBorder: 'transparent'
            colorText: {
                if (isCurrent) {
                    return HusTheme.isDark ? control.themeSource.colorHightlightDark : control.themeSource.colorHightlight;
                } else {
                    return down ? control.themeSource.colorTabActive :
                                  hovered ? control.themeSource.colorTabHover :
                                            control.themeSource.colorTab;
                }
            }
            font {
                family: control.themeSource.fontFamily
                pixelSize: parseInt(control.themeSource.fontSize)
            }
            contentItem: Item {
                implicitWidth: control.tabSize == HusTabView.Size_Auto ? (__text.width + calcIconWidth) : __tabItem.tabFixedWidth
                implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

                property int calcIconWidth: __icon.empty ? 0 : (__icon.implicitWidth + __tabItem.tabIconSpacing)

                HusIconText {
                    id: __icon
                    width: empty ? 0 : implicitWidth
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: __tabItem.colorIcon
                    iconSize: __tabItem.iconSize
                    iconSource: __tabItem.iconSource
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }

                HusText {
                    id: __text
                    width: control.tabSize === HusTabView.Size_Auto ? implicitWidth :
                                                                      Math.max(0, __tabItem.tabFixedWidth - parent.calcIconWidth)
                    anchors.left: __icon.right
                    anchors.leftMargin: __icon.empty ? 0 : __tabItem.tabIconSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    text: __tabItem.text
                    font: __tabItem.font
                    color: __tabItem.colorText
                    elide: Text.ElideRight
                    horizontalAlignment: {
                        switch (control.tabAlign) {
                        case HusTabView.Align_Left: return Text.AlignLeft;
                        case HusTabView.Align_Right: return Text.AlignRight;
                        default: return Text.AlignHCenter;
                        }
                    }

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
            }
            onTabWidthChanged: {
                if (index == 0)
                    __private.tabMaxWidth = 0;
                __private.tabMaxWidth = Math.max(__private.tabMaxWidth, __tabItem.tabWidth);
            }
            onClicked: __tabView.currentIndex = index;

            required property int index
            required property var model
            property bool isCurrent: __tabView.currentIndex === index
            property string tabKey: model.key || ''
            property var tabIcon: model.iconSource || 0
            property int tabIconSize: model.iconSize || parseInt(control.themeSource.fontSize)
            property int tabIconSpacing: model.iconSpacing || control.defaultTabIconSpacing
            property string tabTitle: model.title || ''
            property int tabFixedWidth: model.tabWidth || control.defaultTabWidth
            property int tabWidth: control.tabSize == HusTabView.Size_Auto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                             implicitContentWidth
            property int tabHeight: model.tabHeight || control.defaultTabHeight
        }
    }

    Component {
        id: __cardTabDelegate

        Item {
            id: __tabContainer
            width: __tabItem.width
            height: __tabItem.height

            required property int index
            required property var model
            property alias tabItem: __tabItem
            property bool isCurrent: __tabView.currentIndex === index
            property string tabKey: model.key || ''
            property var tabIcon: model.iconSource || 0
            property int tabIconSize: model.iconSize || parseInt(control.themeSource.fontSize)
            property int tabIconSpacing: model.iconSpacing || control.defaultTabIconSpacing
            property string tabTitle: model.title || ''
            property int tabFixedWidth: model.tabWidth || control.defaultTabWidth
            property int tabWidth: __tabItem.calcWidth
            property int tabHeight: model.tabHeight || control.defaultTabHeight

            property bool tabEditable: model.editable && control.tabType == HusTabView.Type_CardEditable

            onTabWidthChanged: {
                if (__private.needResetTabMaxWidth) {
                    __private.needResetTabMaxWidth = false;
                    __private.tabMaxWidth = 0;
                }
                __private.tabMaxWidth = Math.max(__private.tabMaxWidth, __tabItem.calcWidth);
            }

            HusRectangleInternal {
                id: __tabItem
                z: __dragHandler.drag.active ? 1 : 0
                width: (!__private.isHorizontal && control.tabSize == HusTabView.Size_Auto) ? __private.tabMaxWidth : calcWidth
                height: __tabContainer.tabHeight
                color: isCurrent ? control.colorTabCardBgActive : control.colorTabCardBg
                border.color: isCurrent ? control.colorTabCardBorderActive : control.colorTabCardBorder
                topLeftRadius: control.tabPosition == HusTabView.Position_Top ||
                               control.tabPosition == HusTabView.Position_Left ? control.radiusTabBg.topLeft : 0
                topRightRadius: control.tabPosition == HusTabView.Position_Top ||
                                control.tabPosition == HusTabView.Position_Right ? control.radiusTabBg.topRight : 0
                bottomLeftRadius: control.tabPosition == HusTabView.Position_Bottom ||
                                  control.tabPosition == HusTabView.Position_Left ? control.radiusTabBg.bottomLeft : 0
                bottomRightRadius: control.tabPosition == HusTabView.Position_Bottom ||
                                   control.tabPosition == HusTabView.Position_Right ? control.radiusTabBg.bottomRight : 0

                property bool down: false
                property bool hovered: false
                property int calcIconWidth: __icon.empty ? 0 : (__icon.implicitWidth + __tabContainer.tabIconSpacing)
                property int calcCloseWidth: __close.visible ? (__close.implicitWidth + __tabContainer.tabIconSpacing + control.defaultTabRightPadding) : 0
                property real calcWidth: control.tabSize == HusTabView.Size_Auto ? (__text.width + calcIconWidth + calcCloseWidth)
                                                                                 : __tabContainer.tabFixedWidth
                property real calcHeight: Math.max(__icon.implicitHeight, __text.implicitHeight, __close.height)
                property color colorText: {
                    if (isCurrent) {
                        return HusTheme.isDark ? control.themeSource.colorHightlightDark : control.themeSource.colorHightlight;
                    } else {
                        return down ? control.themeSource.colorTabActive :
                                      hovered ? control.themeSource.colorTabHover :
                                                control.themeSource.colorTab;
                    }
                }

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

                MouseArea {
                    id: __dragHandler
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    drag.target: control.tabCardMovable ? __tabItem : null
                    drag.axis: __private.isHorizontal ? Drag.XAxis : Drag.YAxis
                    onEntered: __tabItem.hovered = true;
                    onExited: __tabItem.hovered = false;
                    onClicked: __tabView.currentIndex = index;
                    onPressed:
                        (mouse) => {
                            __tabView.currentIndex = index;
                            __tabItem.down = true;

                            if (control.tabCardMovable) {
                                const pos = __tabView.mapFromItem(__tabContainer, 0, 0);
                                __tabItem.parent = __tabView;
                                __tabItem.x = pos.x;
                                __tabItem.y = pos.y;
                            }
                        }
                    onPositionChanged: move();
                    onReleased: {
                        __keepMovingTimer.stop();
                        __tabItem.down = false;
                        __tabItem.parent = __tabContainer;
                        __tabItem.x = __tabItem.y = 0;
                        __tabView.forceLayout();
                    }

                    function move() {
                        if (pressed && control.tabCardMovable) {
                            if (!__keepMovingTimer.running)
                                __keepMovingTimer.restart();
                            const pos = __tabView.mapFromItem(__tabItem, width * 0.5, height * 0.5);
                            const item = __tabView.itemAt(pos.x + __tabView.contentX + 1, pos.y + __tabView.contentY + 1);
                            if (item) {
                                if (item.index !== __tabContainer.index) {
                                    __tabModel.move(item.index, __tabContainer.index, 1);
                                }
                            }
                        }
                    }

                    Timer {
                        id: __keepMovingTimer
                        repeat: true
                        interval: 100
                        onTriggered: __dragHandler.move();
                    }
                }

                HusIconText {
                    id: __icon
                    leftPadding: empty ? 0 : control.defaultTabLeftPadding
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: __tabItem.colorText
                    iconSize: __tabContainer.tabIconSize
                    iconSource: __tabContainer.tabIcon
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }

                HusText {
                    id: __text
                    width: control.tabSize === HusTabView.Size_Auto ? implicitWidth :
                                                                      Math.max(0, __tabContainer.tabFixedWidth
                                                                               - __tabItem.calcIconWidth - __tabItem.calcCloseWidth)
                    leftPadding: __icon.empty ? control.defaultTabLeftPadding : 0
                    rightPadding: __close.visible ? 0 : control.defaultTabRightPadding
                    anchors.left: __icon.right
                    anchors.leftMargin: __icon.empty ? 0 : __tabContainer.tabIconSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    text: tabTitle
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: parseInt(control.themeSource.fontSize)
                    }
                    horizontalAlignment: {
                        switch (control.tabAlign) {
                        case HusTabView.Align_Left: return Text.AlignLeft;
                        case HusTabView.Align_Right: return Text.AlignRight;
                        default: return Text.AlignHCenter;
                        }
                    }
                    color: __tabItem.colorText
                    elide: Text.ElideRight

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }

                HusCaptionButton {
                    id: __close
                    visible: __tabContainer.tabEditable
                    enabled: visible
                    implicitWidth: visible ? (implicitContentWidth + leftPadding + rightPadding) : 0
                    topPadding: 0
                    bottomPadding: 0
                    leftPadding: 2
                    rightPadding: 2
                    anchors.right: parent.right
                    anchors.rightMargin: control.defaultTabRightPadding
                    anchors.verticalCenter: parent.verticalCenter
                    animationEnabled: control.animationEnabled
                    hoverCursorShape: Qt.PointingHandCursor
                    iconSize: tabIconSize
                    iconSource: HusIcon.CloseOutlined
                    colorIcon: hovered ? control.themeSource.colorTabCloseHover : control.themeSource.colorTabClose
                    onClicked: {
                        control.closeTabCallback(__tabContainer.index, __tabContainer.model);
                    }

                    HoverHandler {
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }

    Connections {
        target: control
        function onTabTypeChanged() {
            __private.needResetTabMaxWidth = true;
        }
        function onTabSizeChanged() {
            __private.needResetTabMaxWidth = true;
        }
    }

    QtObject {
        id: __private
        property bool isHorizontal: control.tabPosition == HusTabView.Position_Top ||
                                    control.tabPosition == HusTabView.Position_Bottom
        property int tabMaxWidth: 0
        property bool needResetTabMaxWidth: false
    }
}

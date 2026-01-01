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
import QtQuick.Templates as T
import HuskarUI.Basic

T.Control {
    id: control

    signal click(index: int, data: var)
    signal clickMenu(deep: int, key: string, keyPath: var, data: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property var initModel: []
    readonly property int count: __listModel.count
    property string separator: '/'
    property alias titleFont: control.font
    property int defaultIconSize: themeSource.fontSize + 2
    property int defaultMenuWidth: 120
    property HusRadius radiusItemBg: HusRadius { all: themeSource.radiusItemBg }
    property var themeSource: HusTheme.HusBreadcrumb

    property Component itemDelegate: HusRectangleInternal {
        id: __itemDelegate

        implicitWidth: __itemRow.implicitWidth + 8
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight) + 4
        radius: control.radiusItemBg.all
        topLeftRadius: control.radiusItemBg.topLeft
        topRightRadius: control.radiusItemBg.topRight
        bottomLeftRadius: control.radiusItemBg.bottomLeft
        bottomRightRadius: control.radiusItemBg.bottomRight

        color: isCurrent || !__hoverHandler.hovered ? control.themeSource.colorBgLast :
                                                      control.themeSource.colorBg;

        property int __index: index
        property var menu: model.menu ?? {}
        property var menuItem: menu.items ?? []

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        Row {
            id: __itemRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            HusIconText {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                color: isCurrent || __hoverHandler.hovered ? control.themeSource.colorIconLast :
                                                             control.themeSource.colorIcon;
                iconSize: model.iconSize
                iconSource: model.loading ? HusIcon.LoadingOutlined : model.iconSource
                verticalAlignment: Text.AlignVCenter

                NumberAnimation on rotation {
                    running: model.loading
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1000
                }

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            }

            HusCopyableText {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: model.title
                font: control.titleFont
                enabled: isCurrent
                color: __icon.color

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            }

            Loader {
                anchors.verticalCenter: parent.verticalCenter
                active: __itemDelegate.menuItem.length > 0
                sourceComponent: HusIconText {
                    color: isCurrent || __hoverHandler.hovered ? control.themeSource.colorIconLast :
                                                                 control.themeSource.colorIcon;
                    iconSource: HusIcon.DownOutlined
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
            }
        }

        HoverHandler {
            id: __hoverHandler
            cursorShape: !isCurrent ? Qt.PointingHandCursor : Qt.ArrowCursor
            onHoveredChanged: {
                if (hovered) __private.hover(index);
            }
        }

        TapHandler {
            id: __tapHandler
            enabled: !isCurrent
            onTapped: control.click(index, model);
        }

        Loader {
            active: __itemDelegate.menuItem.length > 0
            sourceComponent: HusContextMenu {
                id: __menu
                parent: __itemDelegate
                showToolTip: true
                initModel: __itemDelegate.menuItem
                defaultMenuWidth: __itemDelegate.menu.width ?? control.defaultMenuWidth
                closePolicy: HusPopup.NoAutoClose | HusPopup.CloseOnPressOutsideParent | HusPopup.CloseOnEscape
                onHoveredChanged: {
                    if (hovered) {
                        x = (parent.width - implicitWidth) * 0.5;
                        y = parent.height + 2;
                        open();
                    }
                }
                onClickMenu: (deep, key, keyPath, data) => control.clickMenu(deep, key, keyPath, data);
                Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
                property bool hovered: __hoverHandler.hovered

                Connections {
                    target: __private
                    function onHover(index) {
                        if (__itemDelegate.__index !== index && __menu.opened) {
                            __menu.close();
                        }
                    }
                }
            }
        }
    }
    property Component separatorDelegate: HusText {
        text: model.separator ?? ''
        color: control.themeSource.colorIcon
    }

    function get(index: int) {
        return __listModel.get(index);
    }

    function set(index: int, object: var) {
        __listModel.set(index, __private.initObject(object));
    }

    function setProperty(index: int, propertyName: string, value: var) {
        __listModel.setProperty(index, propertyName, value);
    }

    function move(from: int, to: int, count = 1) {
        __listModel.move(from, to, count);
    }

    function insert(index: int, object: var) {
        __listModel.insert(index, __private.initObject(object));
    }

    function append(object: var) {
        __listModel.append(__private.initObject(object));
    }

    function remove(index: int, count = 1) {
        __listModel.remove(index, count);
    }

    function clear() {
        __listModel.clear();
    }

    function reset() {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    function getPath() {
        let path = '';
        for (let i = 0; i < __listModel.count; i++) {
            path += __listModel.get(i).title + ((i + 1 != count) ? __listModel.get(i).separator : '');
        }
        return path;
    }

    onInitModelChanged: reset();

    objectName: '__HusBreadcrumb__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 0
    spacing: 4
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    contentItem: ListView{
        id: __listView
        implicitHeight: 30
        orientation: ListView.Horizontal
        model: ListModel { id: __listModel }
        clip: true
        spacing: control.spacing
        boundsBehavior: ListView.StopAtBounds
        add: Transition {
            NumberAnimation {
                properties: 'opacity'
                from: 0
                to: 1
                duration: control.animationEnabled ? HusTheme.Primary.durationFast : 0
            }
        }
        remove: Transition {
            NumberAnimation {
                properties: 'opacity'
                from: 1
                to: 0
                duration: control.animationEnabled ? HusTheme.Primary.durationFast : 0
            }
        }
        delegate: Item {
            id: __rootItem
            width: __row.implicitWidth
            height: __listView.height

            required property int index
            required property var model
            property bool isCurrent: (index + 1) === __listModel.count

            Row {
                id: __row
                height: parent.height
                spacing: control.spacing

                Loader {
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: model.itemDelegate
                    property alias index: __rootItem.index
                    property alias model: __rootItem.model
                    property alias isCurrent: __rootItem.isCurrent
                }

                Loader {
                    anchors.verticalCenter: parent.verticalCenter
                    active: index + 1 !== __listModel.count
                    sourceComponent: model.separatorDelegate
                    property alias index: __rootItem.index
                    property alias model: __rootItem.model
                    property alias isCurrent: __rootItem.isCurrent
                }
            }
        }
    }

    QtObject {
        id: __private

        signal hover(index: int)

        function initObject(object: var): var {
            if (!object.hasOwnProperty('title')) object.title = '';

            if (!object.hasOwnProperty('iconSource')) object.iconSource = 0;
            if (!object.hasOwnProperty('iconUrl')) object.iconUrl = '';
            if (!object.hasOwnProperty('iconSize')) object.iconSize = control.defaultIconSize;
            if (!object.hasOwnProperty('loading')) object.loading = false;

            if (!object.hasOwnProperty('separator')) object.separator = control.separator;
            if (!object.hasOwnProperty('itemDelegate')) object.itemDelegate = control.itemDelegate;
            if (!object.hasOwnProperty('separatorDelegate')) object.separatorDelegate = control.separatorDelegate;

            if (!object.hasOwnProperty('menu')) object.menu = {};

            return object;
        }
    }
}

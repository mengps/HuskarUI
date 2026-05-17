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

HusSelect {
    id: control

    signal search(input: string)
    signal select(option: var)
    signal deselect(option: var)

    property var options: []
    property var filterOption: (input, option) => true
    property alias text: __input.text
    property string prefix: ''
    property string suffix: ''
    property bool genDefaultKey: true
    property var defaultSelectedKeys: []
    property var selectedKeys: []
    property alias searchEnabled: control.editable
    readonly property alias tagCount: __tagListModel.count
    property int maxTagCount: -1
    property int tagSpacing: 5 * sizeRatio
    property real itemWidth: 120 * sizeRatio
    property real itemHeight: 30 * sizeRatio
    property real defaultPopupWidth: width
    property color colorTagText: enabled ? themeSource.colorTagText :
                                           themeSource.colorTagTextDisabled
    property color colorTagBg: themeSource.colorTagBg
    property HusRadius radiusTagBg: HusRadius { all: themeSource.radiusTagBg }

    property Component prefixDelegate: HusText {
        font: control.font
        text: control.prefix
        color: control.themeSource.colorText
    }
    property Component suffixDelegate: HusText {
        font: control.font
        text: control.suffix
        color: control.themeSource.colorText
    }
    property Component tagDelegate: HusRectangleInternal {
        id: __tag

        required property int index
        required property var tagData

        implicitWidth: __row.implicitWidth + 16 * control.sizeRatio
        implicitHeight: Math.max(__text.implicitHeight, __closeIcon.implicitHeight) + 4 * control.sizeRatio
        radius: control.radiusTagBg.all
        topLeftRadius: control.radiusTagBg.topLeft
        topRightRadius: control.radiusTagBg.topRight
        bottomLeftRadius: control.radiusTagBg.bottomLeft
        bottomRightRadius: control.radiusTagBg.bottomRight
        color: control.colorTagBg

        MouseArea {
            anchors.fill: parent
        }

        Row {
            id: __row
            anchors.centerIn: parent
            spacing: 5 * control.sizeRatio

            HusText {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: __tag.tagData.label
                font: control.font
                color: control.colorTagText

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            }

            HusIconText {
                id: __closeIcon
                anchors.verticalCenter: parent.verticalCenter
                colorIcon: __hoverHander.hovered ? control.themeSource.colorTagCloseHover : control.themeSource.colorTagClose
                iconSize: (parseInt(control.themeSource.fontSize) - 2) * control.sizeRatio
                iconSource: HusIcon.CloseOutlined
                verticalAlignment: Text.AlignVCenter

                Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

                HoverHandler {
                    id: __hoverHander
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: __tapHander
                    onTapped: {
                        control.removeTagAtIndex(__tag.index);
                    }
                }
            }
        }
    }

    function findKey(key: string): var {
        return __private.findKey(key);
    }

    function filter() {
        model = options.filter(option => filterOption(text, option) === true);
    }

    function insertTag(index: int, key: string) {
        const data = findKey(key);
        if (data !== undefined) {
            __private.insert(index, key, data);
        }
    }

    function appendTag(key: string) {
        const data = findKey(key);
        if (data !== undefined) {
            __private.append(key, data);
        }
    }

    function removeTagAtKey(key: string) {
        __private.remove(key);
    }

    function removeTagAtIndex(index: int) {
        if (index >= 0 && index < __tagListModel.count) {
            __private.removeAtIndex(index);
        }
    }

    function clearTag() {
        __private.clear();
    }

    function clearInput() {
        __input.clear();
        __input.textEdited();
    }

    function openPopup() {
        if (!__popup.opened)
            __popup.open();
    }

    function closePopup() {
        __popup.close();
    }

    onOptionsChanged: {
        if (genDefaultKey) {
            options.forEach(
                        (item, index) => {
                            if (!item.hasOwnProperty('key')) {
                                item.key = item.label;
                            }
                        });
        }
        if (defaultSelectedKeys.length > 0) {
            const keysSet = new Set;
            defaultSelectedKeys.forEach(key => keysSet.add(key));
            options.forEach(
                        item => {
                            if (item.key && keysSet.has(item.key)) {
                                __private.append(item.key, item, false);
                                keysSet.delete(item.key);
                            }
                        });
        }
        filter();
    }
    onFilterOptionChanged: {
        filter();
    }

    Behavior on colorTagText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorTagBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    objectName: '__HusMultiCheckBox__'
    themeSource: HusTheme.HusMultiCheckBox
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize) * sizeRatio
    }
    active: hovered || visualFocus || __input.hovered || __input.activeFocus
    editable: true
    topPadding: 4 * sizeRatio
    bottomPadding: 4 * sizeRatio
    leftPadding: 2 * sizeRatio
    clearEnabled: false
    contentItem: Item {
        implicitHeight: Math.max(__flow.implicitHeight, 22 * control.sizeRatio)

        Loader {
            id: __prefixLoader
            anchors.left: parent.left
            anchors.leftMargin: 5 * control.sizeRatio
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.prefixDelegate
        }

        Loader {
            id: __suffixLoader
            anchors.right: parent.right
            anchors.rightMargin: 5 * control.sizeRatio
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.suffixDelegate
        }

        HusInput {
            id: __input
            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: __flow.left
            anchors.leftMargin: 2 * control.sizeRatio
            anchors.right: __flow.right
            background: Item { }
            animationEnabled: control.animationEnabled
            sizeRatio: control.sizeRatio
            colorText: control.themeSource.colorText
            placeholderTextColor: control.themeSource.colorTextDisabled
            placeholderText: (__tagListModel.count > 0 || length > 0) ? '' : control.placeholderText
            font: control.font
            readOnly: !control.searchEnabled
            onTextEdited: {
                control.search(text);
                control.filter();
                if (control.model.length > 0)
                    control.openPopup();
                else
                    control.closePopup();
            }
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Backspace) {
                    if (length === 0 && __tagListModel.count > 0) {
                        control.removeTagAtIndex(__tagListModel.count - 1);
                    }
                }
            }

            TapHandler {
                onTapped: {
                    if (control.popup.opened) {
                        control.popup.close();
                    } else {
                        control.popup.open();
                    }
                }
            }
        }

        Flow {
            id: __flow
            anchors.left: __prefixLoader.right
            anchors.leftMargin: 4 * control.sizeRatio
            anchors.right: __suffixLoader.left
            anchors.rightMargin: 4 * control.sizeRatio
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.tagSpacing
            onPositioningComplete: {
                const item = __tagRepeater.itemAt(__tagListModel.count - 1);
                __input.leftPadding = item ? (item.x + item.width + 5 * control.sizeRatio) : 0;
                __input.topPadding = item ? item.y : 0;
            }

            Repeater {
                id: __tagRepeater
                model: ListModel { id: __tagListModel }
                delegate: control.tagDelegate
            }
        }
    }
    popup: HusPopup {
        id: __popup
        x: (control.width - width) * 0.5
        y: control.height + 2
        implicitWidth: implicitContentWidth + leftPadding + rightPadding
        implicitHeight: implicitContentHeight + topPadding + bottomPadding
        leftPadding: 4 * control.sizeRatio
        rightPadding: 4 * control.sizeRatio
        topPadding: 6 * control.sizeRatio
        bottomPadding: 6 * control.sizeRatio
        animationEnabled: control.animationEnabled
        radiusBg: control.radiusPopupBg
        colorBg: HusTheme.isDark ? control.themeSource.colorPopupBgDark : control.themeSource.colorPopupBg
        transformOrigin: isTop ? Item.Bottom : Item.Top
        enter: Transition {
            NumberAnimation {
                property: 'scale'
                from: 0.9
                to: 1.0
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
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
                property: 'scale'
                from: 1.0
                to: 0.9
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0.0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        contentItem: GridView {
            id: __popupGridView
            implicitWidth: control.defaultPopupWidth
            implicitHeight: Math.min(control.defaultPopupMaxHeight, contentHeight)
            clip: true
            model: control.popup.visible ? control.model : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            cellWidth: control.itemWidth
            cellHeight: control.itemHeight
            delegate: HusCheckBox {
                id: __popupDelegate

                required property var model
                required property int index
                readonly property string key: model.key
                readonly property bool selected: __private.selectedKeysMap.has(key)

                width: __popupGridView.cellWidth
                height: __popupGridView.cellHeight
                leftPadding: 8 * control.sizeRatio
                rightPadding: 8 * control.sizeRatio
                topPadding: 5 * control.sizeRatio
                bottomPadding: 5 * control.sizeRatio
                checked: selected
                enabled: (model.enabled ?? true) && ((!selected && control.maxTagCount >= 0) ? (__tagListModel.count < control.maxTagCount) : true)
                text: __popupDelegate.model[control.textRole]
                colorText: __popupDelegate.enabled ? control.themeSource.colorItemText :
                                                     control.themeSource.colorItemTextDisabled
                font {
                    family: control.themeSource.fontFamily
                    pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
                    weight: selected ? Font.DemiBold : Font.Normal
                }
                elide: Text.ElideRight
                onClicked: {
                    control.currentIndex = index;
                    const data = __popupDelegate.model.modelData;
                    const key = data.key;
                    if (__private.contains(key)) {
                        __private.remove(key);
                    } else {
                        __private.append(key, data);
                    }
                }

                HoverHandler {
                    cursorShape: control.hoverCursorShape
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.showToolTip
                    sourceComponent: control.toolTipDelegate
                    property alias index: __popupDelegate.index
                    property alias model: __popupDelegate.model
                    property alias hovered: __popupDelegate.hovered
                    property alias pressed: __popupDelegate.pressed
                }
            }
            T.ScrollBar.vertical: HusScrollBar {
                animationEnabled: control.animationEnabled
            }
        }
        property bool isTop: (y + height * 0.5) < control.height * 0.5
    }

    QtObject {
        id: __private

        property var selectedKeysMap: new Map

        function contains(key: string) {
            return selectedKeysMap.has(key);
        }

        function clear() {
            selectedKeysMap.forEach((value, key) => control.deselect(value));
            __tagListModel.clear();
            selectedKeysMap.clear();
            selectedKeysMapChanged();
        }

        function insert(index: int, key: string, data: var, emit = true) {
            if (!selectedKeysMap.has(key)) {
                __tagListModel.insert(index, { '__related__': key, 'tagData': data });
                selectedKeysMap.set(key, data);
                selectedKeysMapChanged();
                if (emit) {
                    control.select(data);
                }
            }
        }

        function append(key: string, data: var, emit = true) {
            if (!selectedKeysMap.has(key)) {
                __tagListModel.append({ '__related__': key, 'tagData': data });
                selectedKeysMap.set(key, data);
                selectedKeysMapChanged();
                if (emit) {
                    control.select(data);
                }
            }
        }

        function remove(key: string, emit = true) {
            for (let i = 0; i < __tagListModel.count; i++) {
                if (__tagListModel.get(i).__related__ === key) {
                    const relatedKey = __tagListModel.get(i).__related__;
                    const data = selectedKeysMap.get(relatedKey);
                    __tagListModel.remove(i);
                    selectedKeysMap.delete(relatedKey);
                    selectedKeysMapChanged();
                    if (emit) {
                        control.deselect(data);
                    }
                    break;
                }
            }
        }

        function removeAtIndex(index: int, emit = true) {
            const relatedKey = __tagListModel.get(index).__related__;
            const data = selectedKeysMap.get(relatedKey);
            __tagListModel.remove(index);
            selectedKeysMap.delete(relatedKey);
            selectedKeysMapChanged();
            if (emit) {
                control.deselect(data);
            }
        }

        function findKey(key: string): var {
            const index = control.options.findIndex(item => item.key === key);
            if (index === -1) {
                return undefined;
            } else {
                return control.options[index];
            }
        }

        function updateSelectedKeys() {
            control.selectedKeys = [...selectedKeysMap.keys()];
        }

        onSelectedKeysMapChanged: updateSelectedKeys();
    }
}

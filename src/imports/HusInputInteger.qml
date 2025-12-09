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

T.SpinBox {
    id: control

    signal beforeActivated(index: int, var data)
    signal afterActivated(index: int, var data)

    property bool animationEnabled: HusTheme.animationEnabled
    property alias clearEnabled: __input.clearEnabled
    property alias clearIconSource: __input.clearIconSource
    property alias clearIconSize: __input.clearIconSize
    property alias clearIconPosition: __input.clearIconPosition
    property alias readOnly: __input.readOnly
    property bool showHandler: true
    property bool alwaysShowHandler: false
    property bool useWheel: false
    property bool useKeyboard: true
    property alias min: control.from
    property alias max: control.to
    property alias step: control.stepSize
    property string prefix: ''
    property string suffix: ''
    property var upIcon: HusIcon.UpOutlined || ''
    property var downIcon: HusIcon.DownOutlined || ''
    property font labelFont: Qt.font({
                                         family: 'HuskarUI-Icons',
                                         pixelSize: parseInt(themeSource.fontSize)
                                     })
    property var beforeLabel: '' || []
    property var afterLabel: '' || []
    property int initBeforeLabelIndex: 0
    property int initAfterLabelIndex: 0
    property string currentBeforeLabel: ''
    property string currentAfterLabel: ''
    property var formatter: (value, locale) => value.toLocaleString(locale, 'f', 0)
    property var parser: (text, locale) => Number.fromLocaleString(locale, text)
    property int defaultHandlerWidth: 24
    property alias colorText: __input.colorText
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property var themeSource: HusTheme.HusInput

    property alias input: __input

    property Component beforeDelegate: HusRectangleInternal {
        enabled: control.enabled
        width: Math.max(30, __beforeCompLoader.implicitWidth + 10)
        topLeftRadius: control.radiusBg.topLeft
        bottomLeftRadius: control.radiusBg.bottomLeft
        color: enabled ? control.themeSource.colorLabelBg : control.themeSource.colorLabelBgDisabled
        border.color: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        Loader {
            id: __beforeCompLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.beforeLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: true
        }
    }
    property Component afterDelegate: HusRectangleInternal {
        enabled: control.enabled
        width: Math.max(30, __afterCompLoader.implicitWidth + 10)
        topRightRadius: control.radiusBg.topRight
        bottomRightRadius: control.radiusBg.bottomRight
        color: enabled ? control.themeSource.colorLabelBg : control.themeSource.colorLabelBgDisabled
        border.color: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        Loader {
            id: __afterCompLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.afterLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: false
        }
    }
    property Component handlerDelegate: Item {
        id: __handlerRoot
        clip: true
        enabled: control.enabled
        width: enabled && (__input.hovered || control.alwaysShowHandler) ? control.defaultHandlerWidth : 0

        property real halfHeight: height * 0.5
        property real hoverHeight: height * 0.6
        property real noHoverHeight: height * 0.4
        property color colorBorder: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled

        Behavior on width {
            enabled: control.animationEnabled;
            NumberAnimation {
                easing.type: Easing.OutCubic
                duration: HusTheme.Primary.durationMid
            }
        }

        HusIconButton {
            id: __upButton
            width: parent.width
            height: hovered ? parent.hoverHeight :
                              __downButton.hovered ? parent.noHoverHeight : parent.halfHeight
            padding: 0
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? control.themeSource.colorBorderHover :
                                     control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
            iconSize: parseInt(control.themeSource.fontSize) - 4
            iconSource: control.upIcon
            hoverCursorShape: control.value >= control.max ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: HusRectangleInternal {
                topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
                color: 'transparent'
                border.color: __handlerRoot.colorBorder
            }
            onClicked: {
                control.increase();
                control.valueModified();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        }

        HusIconButton {
            id: __downButton
            width: parent.width
            height: (hovered ? parent.hoverHeight :
                               __upButton.hovered ? parent.noHoverHeight : parent.halfHeight) + 1
            anchors.top: __upButton.bottom
            anchors.topMargin: -1
            padding: 0
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? control.themeSource.colorBorderHover :
                                     control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
            iconSize: parseInt(control.themeSource.fontSize) - 4
            iconSource: control.downIcon
            hoverCursorShape: control.value <= control.min ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: HusRectangleInternal {
                bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
                color: 'transparent'
                border.color: __handlerRoot.colorBorder
            }
            onClicked: {
                control.decrease();
                control.valueModified();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        }
    }

    function getFullText() {
        return __input.text;
    }

    function select(start: int, end: int) {
        __input.select(start, end);
    }

    function selectAll(start: int, end: int) {
        __input.selectAll(start, end);
    }

    function selectWord(start: int, end: int) {
        __input.selectWord(start, end);
    }

    function clear() {
        __input.clear();
        control.valueChanged();
    }

    function copy() {
        __input.copy();
    }

    function cut() {
        __input.cut();
        control.valueChanged();
    }

    function paste() {
        __input.paste();
        control.valueChanged();
    }

    function redo() {
        __input.redo();
        control.valueChanged();
    }

    function undo() {
        __input.undo();
        control.valueChanged();
    }

    objectName: '__HusInputNumber__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    leftPadding: __beforeLoader.active ? (__beforeLoader.implicitWidth - 1) : 0
    rightPadding: __afterLoader.active ? (__afterLoader.implicitWidth - 1) : 0
    editable: true
    live: true
    min: -2147483648
    max: 2147483647
    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }
    valueFromText: parser
    textFromValue: formatter
    contentItem: HusInput {
        id: __input
        enabled: control.enabled
        readOnly: !control.editable
        animationEnabled: control.animationEnabled
        leftPadding: (__prefixLoader.active ? __prefixLoader.implicitWidth : (leftClearIconPadding > 0 ? 5 : 10))
                     + leftIconPadding + leftClearIconPadding
        rightPadding: (__suffixLoader.active ? __suffixLoader.implicitWidth : (rightClearIconPadding > 0 ? 5 : 10))
                      + (rightClearIconPadding > 0 ? 0 : __handlerLoader.implicitWidth)
                      + rightIconPadding + rightClearIconPadding
        text: control.displayText
        validator: control.validator
        inputMethodHints: control.inputMethodHints
        background: HusRectangleInternal {
            color: __input.colorBg
            topLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.topLeft : 0
            topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
            bottomLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.bottomLeft : 0
            bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
        }
        clearIconDelegate: HusIconText {
            iconSource: control.clearIconSource
            iconSize: control.clearIconSize
            leftPadding: control.clearIconPosition === HusInput.Position_Left ? (control.leftIconPadding > 0 ? 5 : 10) * __input.sizeRatio : 0
            rightPadding: control.clearIconPosition === HusInput.Position_Right ?
                              ((control.rightIconPadding > 0 ? 5 : 10) * __input.sizeRatio + __handlerLoader.implicitWidth) : 0
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
                    control.valueModified();
                }
            }
        }
        onTextEdited: modified = true;

        property bool modified: false

        Keys.onUpPressed: {
            if (control.enabled && control.useKeyboard) {
                control.increase();
                control.valueModified();
            }
        }
        Keys.onDownPressed: {
            if (control.enabled && control.useKeyboard) {
                control.decrease();
                control.valueModified();
            }
        }

        WheelHandler {
            enabled: control.enabled && control.useWheel
            onWheel: function(wheel) {
                if (wheel.angleDelta.y > 0) {
                    control.increase();
                    control.valueModified();
                } else {
                    control.decrease();
                    control.valueModified();
                }
            }
        }

        Loader {
            id: __prefixLoader
            height: parent.height
            active: control.prefix != ''
            sourceComponent: HusText {
                leftPadding: 10
                rightPadding: 5
                text: control.prefix
                color: __input.colorText
                verticalAlignment: Text.AlignVCenter
            }
        }

        Loader {
            id: __suffixLoader
            height: parent.height
            anchors.right: __handlerLoader.left
            active: control.suffix != ''
            sourceComponent: HusText {
                leftPadding: 5
                rightPadding: 10
                text: control.suffix
                color: __input.colorText
                verticalAlignment: Text.AlignVCenter
            }
        }

        Loader {
            id: __handlerLoader
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            active: control.showHandler && !__input.readOnly
            sourceComponent: control.handlerDelegate
        }

        HusRectangleInternal {
            anchors.fill: parent
            color: 'transparent'
            border.color: __input.colorBorder
            topLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.topLeft : 0
            bottomLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.bottomLeft : 0
            topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
            bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
        }
    }
    background: Item { }

    onValueChanged: {
        if (__input.modified) {
            __input.modified = false;
            control.valueModified();
        }
    }
    onPrefixChanged: valueChanged();
    onSuffixChanged: valueChanged();
    onCurrentAfterLabelChanged: valueChanged();
    onCurrentBeforeLabelChanged: valueChanged();
    Component.onCompleted: valueChanged();

    Loader {
        id: __beforeLoader
        height: parent.height
        anchors.left: parent.left
        active: control.beforeLabel?.length !== 0
        sourceComponent: control.beforeDelegate
    }

    Loader {
        id: __afterLoader
        height: parent.height
        anchors.right: parent.right
        active: control.afterLabel?.length !== 0
        sourceComponent: control.afterDelegate
    }

    Component {
        id: __selectComp

        HusSelect {
            id: __afterText
            rightPadding: 4
            animationEnabled: control.animationEnabled
            colorBg: 'transparent'
            colorBorder: 'transparent'
            clearEnabled: false
            model: isBefore ? control.beforeLabel : control.afterLabel
            currentIndex: isBefore ? control.initBeforeLabelIndex : control.initAfterLabelIndex
            onActivated:
                (index) => {
                    if (isBefore) {
                        control.beforeActivated(index, valueAt(index));
                    } else {
                        control.afterActivated(index, valueAt(index));
                    }
                }
            onCurrentTextChanged: {
                if (isBefore)
                    control.currentBeforeLabel = currentText;
                else
                    control.currentAfterLabel = currentText;
            }
        }
    }

    Component {
        id: __labelComp

        HusText {
            text: isBefore ? control.beforeLabel : control.afterLabel
            color: __input.colorText
            font: control.labelFont
            Component.onCompleted: {
                if (isBefore)
                    control.currentBeforeLabel = control.beforeLabel;
                else
                    control.currentAfterLabel = control.afterLabel;
            }
        }
    }
}

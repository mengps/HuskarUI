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
import QtQuick.Layouts
import HuskarUI.Basic

T.Control {
    id: control

    signal valueModified()
    signal beforeActivated(index: int, var data)
    signal afterActivated(index: int, var data)

    property bool animationEnabled: HusTheme.animationEnabled
    property bool active: hovered || activeFocus
    property int type: HusInput.Type_Outlined
    property bool showShadow: false
    property alias clearEnabled: __input.clearEnabled
    property alias clearIconSource: __input.clearIconSource
    property alias clearIconSize: __input.clearIconSize
    property alias clearIconPosition: __input.clearIconPosition
    property alias readOnly: __input.readOnly
    property bool showHandler: true
    property bool alwaysShowHandler: false
    property bool useWheel: false
    property bool useKeyboard: true
    property real value: 0
    property real min: Number.MIN_SAFE_INTEGER
    property real max: Number.MAX_SAFE_INTEGER
    property real step: 1
    property int precision: 0
    property var validator: DoubleValidator {
        locale: control.locale.name
        bottom: Math.min(control.min, control.max)
        top: Math.max(control.min, control.max)
    }
    property string prefix: ''
    property string suffix: ''
    property var upIcon: HusIcon.UpOutlined || ''
    property var downIcon: HusIcon.DownOutlined || ''
    property alias inputFont: control.font
    property font labelFont: Qt.font({
                                         family: 'HuskarUI-Icons',
                                         pixelSize: parseInt(themeSource.fontSize) * sizeRatio
                                     })
    property var beforeLabel: '' || []
    property var afterLabel: '' || []
    property int initBeforeLabelIndex: 0
    property int initAfterLabelIndex: 0
    property string currentBeforeLabel: ''
    property string currentAfterLabel: ''
    property var formatter: (value, locale) => value.toLocaleString(locale, 'f', precision)
    property var parser: (text, locale) => HusApi.clamp(Number.fromLocaleString(locale, text), min, max)
    property int defaultHandlerWidth: 22
    property alias colorText: __input.colorText
    property alias colorBg: __input.colorBg
    property color colorShadow: enabled ? themeSource.colorShadow : 'transparent'
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property string sizeHint: 'normal'
    property real sizeRatio: HusTheme.sizeHint[sizeHint]
    property var themeSource: HusTheme.HusInput

    property alias input: __input

    property Component beforeDelegate: HusRectangleInternal {
        width: Math.max(30 * control.sizeRatio, __beforeCompLoader.implicitWidth + 10 * control.sizeRatio)
        topLeftRadius: control.radiusBg.topLeft
        bottomLeftRadius: control.radiusBg.bottomLeft
        color: control.colorBg
        border.color: enabled ? control.themeSource.colorBorder :
                                control.themeSource.colorBorderDisabled

        Loader {
            id: __beforeCompLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.beforeLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: true
        }
    }
    property Component afterDelegate: HusRectangleInternal {
        width: Math.max(30 * control.sizeRatio, __afterCompLoader.implicitWidth + 10 * control.sizeRatio)
        topRightRadius: control.radiusBg.topRight
        bottomRightRadius: control.radiusBg.bottomRight
        color: control.colorBg
        border.color: enabled ? control.themeSource.colorBorder :
                                control.themeSource.colorBorderDisabled

        Loader {
            id: __afterCompLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.afterLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: false
        }
    }
    property Component handlerDelegate: HusRectangleInternal {
        id: __handlerRoot
        clip: true
        width: enabled && (control.hovered || control.alwaysShowHandler) ? control.defaultHandlerWidth : 0
        radius: 0
        topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
        bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
        color: control.colorBg

        property real halfHeight: height * 0.5
        property real hoverHeight: height * 0.6
        property real noHoverHeight: height * 0.4
        property color colorBorder: enabled ? control.themeSource.colorBorder :
                                              control.themeSource.colorBorderDisabled
        property color colorHandlerBg: 'transparent'

        Behavior on width {
            enabled: control.animationEnabled;
            NumberAnimation {
                easing.type: Easing.OutCubic
                duration: HusTheme.Primary.durationMid
            }
        }

        HusIconButton {
            id: __upButton
            padding: 0
            width: parent.width
            height: hovered ? parent.hoverHeight :
                              __downButton.hovered ? parent.noHoverHeight : parent.halfHeight
            animationEnabled: control.animationEnabled
            sizeRatio: control.sizeRatio
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? control.themeSource.colorBorderHover :
                                     control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
            iconSize: parseInt(control.themeSource.fontSize) - 4
            iconSource: control.upIcon
            hoverCursorShape: control.value >= control.max ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: null
            onClicked: {
                control.increase();
                control.valueModified();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        }

        HusIconButton {
            id: __downButton
            padding: 0
            width: parent.width
            height: (hovered ? parent.hoverHeight :
                               __upButton.hovered ? parent.noHoverHeight : parent.halfHeight) + 1
            anchors.top: __upButton.bottom
            anchors.topMargin: -1
            animationEnabled: control.animationEnabled
            sizeRatio: control.sizeRatio
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? control.themeSource.colorBorderHover :
                                     control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
            iconSize: parseInt(control.themeSource.fontSize) - 4
            iconSource: control.downIcon
            hoverCursorShape: control.value <= control.min ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: null
            onClicked: {
                control.decrease();
                control.valueModified();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        }

        Rectangle {
            width: 1
            height: parent.height
            anchors.left: parent.left
            color: __handlerRoot.colorBorder
        }

        Rectangle {
            width: parent.width
            height: 1
            anchors.top: __upButton.bottom
            color: __handlerRoot.colorBorder
        }
    }

    function getFullText(): string {
        return __input.text;
    }

    function increase() {
        value = value + step > max ? max : value + step;
    }

    function decrease() {
        value = value - step < min ? min : value - step;
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

    onValueChanged: __input.text = formatter(value, control.locale);
    onPrefixChanged: valueChanged();
    onSuffixChanged: valueChanged();
    onCurrentAfterLabelChanged: valueChanged();
    onCurrentBeforeLabelChanged: valueChanged();
    Component.onCompleted: valueChanged();

    objectName: '__HusInputNumber__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize) * sizeRatio
    }
    contentItem: RowLayout {
        id: __row
        spacing: 0

        Loader {
            Layout.rightMargin: -1
            Layout.fillHeight: true
            active: control.beforeLabel?.length !== 0
            sourceComponent: control.beforeDelegate
        }

        HusInput {
            id: __input
            z: 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            leftPadding: (__prefixLoader.active ? __prefixLoader.implicitWidth : (leftClearIconPadding > 0 ? 5 : 10))
                         + leftIconPadding + leftClearIconPadding
            rightPadding: (__suffixLoader.active ? __suffixLoader.implicitWidth : (rightClearIconPadding > 0 ? 5 : 10))
                          + rightIconPadding + rightClearIconPadding
            animationEnabled: control.animationEnabled
            sizeRatio: control.sizeRatio
            themeSource: control.themeSource
            type: control.type
            showShadow: control.showShadow
            validator: control.validator
            font: control.font
            radiusBg.all: control.radiusBg.all
            radiusBg.topLeft: control.beforeLabel?.length === 0 ? control.radiusBg.topLeft : 0
            radiusBg.topRight: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
            radiusBg.bottomLeft: control.beforeLabel?.length === 0 ? control.radiusBg.bottomLeft : 0
            radiusBg.bottomRight: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
            clearIconDelegate: HusIconText {
                iconSource: control.clearIconSource
                iconSize: control.clearIconSize
                leftPadding: control.clearIconPosition === HusInput.Position_Left ? (control.leftIconPadding > 0 ? 5 : 10) * control.sizeRatio : 0
                rightPadding: control.clearIconPosition === HusInput.Position_Right ?
                                  ((control.rightIconPadding > 0 ? 5 : 10) * control.sizeRatio + __handlerLoader.implicitWidth) : 0
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
            onActiveFocusChanged: {
                if (!activeFocus) editingFinished();
            }
            onEditingFinished: {
                if (length === 0) return;
                let v = control.parser(text, control.locale);
                text = control.formatter(v, control.locale);
                control.value = v;
                control.valueModified();
            }

            Keys.onReturnPressed: {
                editingFinished();
            }
            Keys.onEnterPressed: {
                editingFinished();
            }
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
                active: control.prefix !== ''
                sourceComponent: HusText {
                    leftPadding: 10 * control.sizeRatio
                    rightPadding: 5 * control.sizeRatio
                    text: control.prefix
                    color: __input.colorText
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Loader {
                id: __suffixLoader
                height: parent.height
                anchors.right: __handlerLoader.left
                active: control.suffix !== ''
                sourceComponent: HusText {
                    leftPadding: 5 * control.sizeRatio
                    rightPadding: 10 * control.sizeRatio
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
                anchors.margins: 1
                active: control.showHandler && !__input.readOnly
                sourceComponent: control.handlerDelegate
            }
        }

        Loader {
            Layout.leftMargin: -1
            Layout.fillHeight: true
            active: control.afterLabel?.length !== 0
            sourceComponent: control.afterDelegate
        }
    }

    Component {
        id: __selectComp

        HusSelect {
            id: __afterText
            animationEnabled: control.animationEnabled
            sizeRatio: control.sizeRatio
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

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

    signal finished(input: string)

    property bool animationEnabled: HusTheme.animationEnabled
    property int type: HusInput.Type_Outlined
    property bool showShadow: false
    property int length: 6
    property int characterLength: 1
    property int currentIndex: 0
    property string currentInput: ''
    property int itemWidth: 45 * sizeRatio
    property int itemHeight: 32 * sizeRatio
    property alias itemSpacing: control.spacing
    property var itemValidator: IntValidator { top: 9; bottom: 0 }
    property int itemInputMethodHints: Qt.ImhHiddenText
    property bool itemPassword: false
    property string itemPasswordCharacter: ''
    property var formatter: (text) => text
    property color colorItemText: enabled ? themeSource.colorText : themeSource.colorTextDisabled
    property color colorItemBorder: enabled ? themeSource.colorBorder : themeSource.colorBorderDisabled
    property color colorItemBorderActive: enabled ? themeSource.colorBorderHover : themeSource.colorBorderDisabled
    property color colorItemBg: enabled ? themeSource.colorBg : themeSource.colorBgDisabled
    property color colorShadow: enabled ? themeSource.colorShadow : 'transparent'
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property string sizeHint: 'normal'
    property real sizeRatio: HusTheme.sizeHint[sizeHint]
    property var themeSource: HusTheme.HusInput

    property Component dividerDelegate: Item { }

    function setInput(inputs) {
        for (let i = 0; i < inputs.length; i++) {
            setInputAtIndex(i, input);
        }
    }

    function setInputAtIndex(index, input) {
        const item = __repeater.itemAt(index << 1);
        if (item) {
            currentIndex = index;
            item.item.text = formatter(input);
        }
    }

    function getInput() {
        let input = '';
        for (let i = 0; i < __repeater.count; i++) {
            const item = __repeater.itemAt(i);
            if (item && item.index % 2 == 0) {
                input += item.item.text;
            }
        }
        return input;
    }

    function getInputAtIndex(index) {
        const item = __repeater.itemAt(index << 1);
        if (item) {
            return item.item.text;
        }
        return '';
    }

    onCurrentIndexChanged: {
        const item = __repeater.itemAt(currentIndex << 1);
        if (item && item.index % 2 == 0)
            item.item.selectThis();
    }

    objectName: '__HusOTPInput__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize) * sizeRatio
    }
    spacing: 8 * sizeRatio
    contentItem: Row {
        id: __row
        spacing: control.spacing

        Repeater {
            id: __repeater
            model: control.length * 2 - 1
            delegate: Loader {
                sourceComponent: index % 2 == 0 ? __inputDelegate : dividerDelegate
                required property int index
            }
        }
    }

    Component {
        id: __inputDelegate

        HusInput {
            id: __rootItem
            width: control.itemWidth
            height: control.itemHeight
            verticalAlignment: HusInput.AlignVCenter
            horizontalAlignment: HusInput.AlignHCenter
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            sizeRatio: control.sizeRatio
            themeSource: control.themeSource
            showShadow: control.showShadow
            font: control.font
            colorText: control.colorItemText
            colorBorder: active ? control.colorItemBorderActive : control.colorItemBorder
            colorBg: control.colorItemBg
            colorShadow: control.colorShadow
            radiusBg: control.radiusBg
            validator: control.itemValidator
            inputMethodHints: control.itemInputMethodHints
            echoMode: control.itemPassword ? HusInput.Password : HusInput.Normal
            passwordCharacter: control.itemPasswordCharacter
            onReleased: __timer.restart();
            onTextEdited: {
                text = control.formatter(text);
                const isFull = length >= control.characterLength;
                if (isFull) selectAll();

                if (isBackspace) isBackspace = false;

                const input = control.getInput();
                control.currentInput = input;

                if (isFull) {
                    if (control.currentIndex < (control.length - 1))
                        control.currentIndex++;
                    else
                        control.finished(input);
                }
            }

            property int __index: index
            property bool isBackspace: false

            function selectThis() {
                forceActiveFocus();
                selectAll();
            }

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Backspace) {
                    clear();
                    const input = control.getInput();
                    control.currentInput = input;
                    isBackspace = true;
                    if (control.currentIndex != 0)
                        control.currentIndex--;
                } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                    if (control.currentIndex < (control.length - 1))
                        control.currentIndex++;
                    else
                        control.finished(control.getInput());
                }
            }

            Timer {
                id: __timer
                interval: 100
                onTriggered: {
                    control.currentIndex = __rootItem.__index >> 1;
                    __rootItem.selectAll();
                }
            }
        }
    }
}

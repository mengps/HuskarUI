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
import QtQuick.Controls.Basic as T
import HuskarUI.Basic

T.Control {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool active: __textArea.hovered || __textArea.activeFocus
    property bool resizable: false
    property int minResizeHeight: 30
    property bool autoSize: false
    property int minRows: -1
    property int maxRows: -1
    readonly property alias lineCount: __textArea.lineCount
    property alias length: __textArea.length
    property int maxLength: -1
    property alias readOnly: __textArea.readOnly
    property alias textFormat: __textArea.textFormat
    property alias text: __textArea.text
    property alias placeholderText: __textArea.placeholderText
    property alias colorText: __textArea.color
    property alias colorPlaceholderText: __textArea.placeholderTextColor
    property alias colorSelectedText: __textArea.selectedTextColor
    property alias colorSelection: __textArea.selectionColor
    property color colorBorder: enabled ?
                                    active ? themeSource.colorBorderHover :
                                             themeSource.colorBorder : themeSource.colorBorderDisabled
    property color colorBg: enabled ? themeSource.colorBg : themeSource.colorBgDisabled
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusTextArea

    property alias textArea: __textArea
    property alias verScrollBar: __vScrollBar
    property alias horScrollBar: __hScrollBar

    property Component bgDelegate: HusRectangleInternal {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    function scrollToBeginning() {
        __textArea.cursorPosition = 0;
    }

    function scrollToEnd() {
        __textArea.cursorPosition = __textArea.length;
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorPlaceholderText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorSelectedText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    onTextChanged: __private.removeExcess();
    onMaxLengthChanged: __private.removeExcess();

    objectName: '__HusTextArea__'
    topPadding: 6
    bottomPadding: 6
    leftPadding: 10
    rightPadding: 10
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    wheelEnabled: autoSize ? (minRows > 0 && maxRows > 0) : (__vScrollBar.visible || __vScrollBar.active)
    contentItem: Item {
        implicitHeight: {
            if (control.autoSize) {
                if (control.minRows > 0 && control.maxRows > 0) {
                    if (control.lineCount < control.minRows)
                        return __private.minHeight + __textArea.topPadding + __textArea.bottomPadding;
                    else if (lineCount > maxRows) {
                        return __private.maxHeight + __textArea.topPadding + __textArea.bottomPadding;
                    } else {
                        return control.lineCount * __private.lineHeight + __textArea.topPadding + __textArea.bottomPadding;
                    }
                } else {
                    return __textArea.implicitHeight;
                }
            } else {
                return control.minResizeHeight;
            }
        }

        Behavior on implicitHeight { enabled: control.animationEnabled && !__resize.pressed; NumberAnimation { duration: HusTheme.Primary.durationMid } }

        T.ScrollView {
            id: __scrollView
            focus: true
            anchors.fill: parent
            T.ScrollBar.vertical: __vScrollBar
            T.ScrollBar.horizontal: __hScrollBar
            Component.onCompleted: {
                contentItem.boundsBehavior = Flickable.StopAtBounds;
            }

            T.TextArea {
                id: __textArea
                focus: true
                topPadding: 0
                bottomPadding: 0
                leftPadding: 0
                rightPadding: 0
                wrapMode: T.TextArea.WrapAnywhere
                renderType: HusTheme.textRenderType
                color: control.themeSource.colorText
                selectByMouse: true
                selectByKeyboard: true
                placeholderTextColor: control.themeSource.colorPlaceholderText
                selectedTextColor: control.themeSource.colorTextSelected
                selectionColor: control.themeSource.colorSelection
                font: control.font
            }
        }
    }
    background: Loader {
        sourceComponent: control.bgDelegate
    }

    HusIconText {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 1
        iconSource: HusIcon.MinusOutlined
        rotation: -45
        visible: control.resizable
        enabled: visible

        HusIconText {
            y: 4
            iconSource: HusIcon.MinusOutlined
            scale: 0.5
        }

        MouseArea {
            id: __resize
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
            onEntered: cursorShape = Qt.SizeVerCursor;
            onExited: cursorShape = Qt.ArrowCursor;
            onPressed:
                mouse => {
                    startY =  mouseY;
                    mouse.accepted = true;
                }
            onReleased: mouse => mouse.accepted = true;
            onPositionChanged:
                mouse => {
                    if (pressed) {
                        const offsetY = mouse.y - startY;
                        control.height = Math.max(control.height + offsetY, control.minResizeHeight);
                        mouse.accepted = true;
                    }
                }
            property int startY: 0
        }
    }

    HusScrollBar {
        id: __vScrollBar
        orientation: Qt.Vertical
        policy: T.ScrollBar.AlwaysOn
        animationEnabled: control.animationEnabled
    }

    HusScrollBar {
        id: __hScrollBar
        orientation: Qt.Horizontal
        policy: T.ScrollBar.AlwaysOn
        animationEnabled: control.animationEnabled
    }

    QtObject {
        id: __private

        property real minHeight: lineHeight * control.minRows
        property real maxHeight: lineHeight * control.maxRows
        property real lineHeight: __textArea.contentHeight / __textArea.lineCount

        function removeExcess() {
            if (control.maxLength > 0 && control.length > control.maxLength) {
                __textArea.remove(control.maxLength, control.length);
            }
        }
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: control.readOnly
    Accessible.description: control.contentDescription
}

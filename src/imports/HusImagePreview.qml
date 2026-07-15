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

HusPopup {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled

    property alias scaleMin: __panel.scaleMin
    property alias scaleMax: __panel.scaleMax
    property alias scaleStep: __panel.scaleStep

    readonly property alias currentScale: __panel.scale
    readonly property alias currentRotation: __panel.rotation

    property alias items: __panel.items
    property alias currentIndex: __panel.currentIndex
    readonly property alias count: __panel.count

    property alias sourceDelegate: __panel.sourceDelegate
    property Component closeDelegate: HusIconButton {
        topPadding: 10
        bottomPadding: 10
        animationEnabled: control.animationEnabled
        effectEnabled: false
        iconSource: HusIcon.CloseOutlined
        iconSize: 20
        shape: HusButton.Shape_Circle
        type: HusButton.Type_Default
        colorIcon: control.themeSource.colorButtonTextHover
        colorBg: hovered ? control.themeSource.colorButtonBgHover : control.themeSource.colorButtonBg
        borderBg.color: colorBg
        onClicked: control.close();
    }
    property alias prevDelegate: __panel.sourceDelegate
    property alias nextDelegate: __panel.nextDelegate
    property alias indicatorDelegate: __panel.indicatorDelegate
    property alias operationDelegate: __panel.operationDelegate

    property alias panel: __panel

    function get(index: int): var {
        return __panel.get(index);
    }

    function set(index: int, object: var) {
        __panel.set(index, object);
    }

    function setProperty(index: int, propertyName: string, value: var) {
        __panel.setProperty(index, propertyName, value);
    }

    function move(from: int, to: int, count = 1) {
        __panel.move(from, to, count);
    }

    function insert(index: int, object: var) {
        __panel.insert(index, object);
    }

    function append(object: var) {
        __panel.append(object);
    }

    function remove(index: int, count = 1) {
        __panel.remove(index, count);
    }

    function clear() {
        __panel.clear();
    }

    function zoomIn() {
        __panel.zoomIn();
    }

    function zoomOut() {
        __panel.zoomOut();
    }

    function flipX() {
        __panel.flipX();
    }

    function flipY() {
        __panel.flipY();
    }

    function rotate(angle: real) {
        __panel.rotate(angle);
    }

    function toCenter() {
        __panel.toCenter();
    }

    function resetTransform() {
        __panel.resetTransform();
    }

    function incrementCurrentIndex() {
        __panel.incrementCurrentIndex();
    }

    function decrementCurrentIndex() {
        __panel.decrementCurrentIndex();
    }

    objectName: '__HusImagePreview__'
    themeSource: HusTheme.HusImagePreview
    width: parent.width
    height: parent.height
    closePolicy: T.Popup.NoAutoClose
    parent: T.Overlay.overlay
    modal: true
    focus: true
    onAboutToShow: {
        control.resetTransform();
        __private.visible = true;
        __panel.forceActiveFocus();
    }
    onAboutToHide: {
        __private.visible = false;
    }
    contentItem: HusImagePreviewPanel {
        id: __panel
        animationEnabled: control.animationEnabled
        themeSource: control.themeSource
        minViewHeight: height - 200
        onClicked:
            inImage => {
                if (!inImage) {
                    control.close();
                }
            }
        onDoubleClicked:
            inImage => {
                if (currentScale > 1.0) {
                    currentScale = 1.0;
                    toCenter();
                } else {
                    zoomIn();
                }
            }

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Left) {
                decrementCurrentIndex();
            } else if (event.key === Qt.Key_Right) {
                incrementCurrentIndex();
            } else if (event.key === Qt.Key_Escape) {
                control.close();
            }
        }

        Loader {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 30
            sourceComponent: control.closeDelegate
        }
    }
    background: Item { }

    QtObject {
        id: __private

        property bool visible: false
    }
}

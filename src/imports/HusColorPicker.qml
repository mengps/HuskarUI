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

T.AbstractButton {
    id: control

    signal change(color: color)

    property bool animationEnabled: HusTheme.animationEnabled
    property bool active: hovered || visualFocus || open
    readonly property alias value: __colorPickerPanel.value
    property alias defaultValue: __colorPickerPanel.defaultValue
    property alias autoChange: __colorPickerPanel.autoChange
    property alias changeValue: __colorPickerPanel.changeValue
    property bool showText: false
    property var textFormatter:
        color => {
            switch (format.toLowerCase()) {
                case 'hex': return toHexString(color);
                case 'hsv': return toHsvString(color);
                case 'rgb': return toRgbString(color);
            }
        }
    property alias title: __colorPickerPanel.title
    property alias alphaEnabled: __colorPickerPanel.alphaEnabled
    property alias open: __popup.visible
    property alias format: __colorPickerPanel.format
    property alias presets: __colorPickerPanel.presets
    property alias presetsOrientation: __colorPickerPanel.presetsOrientation
    property alias presetsLayoutDirection: __colorPickerPanel.presetsLayoutDirection
    property alias titleFont: __colorPickerPanel.titleFont
    property alias inputFont: __colorPickerPanel.inputFont
    property alias colorBg: __colorPickerPanel.colorBg
    property alias colorBorder: __colorPickerPanel.colorBorder
    property color colorText: enabled ? themeSource.colorText : themeSource.colorTextDisabled
    property alias colorInput: __colorPickerPanel.colorInput
    property alias colorTitle: __colorPickerPanel.colorTitle
    property alias colorPresetIcon: __colorPickerPanel.colorPresetIcon
    property alias colorPresetText: __colorPickerPanel.colorPresetText
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property HusRadius radiusTriggerBg: HusRadius { all: themeSource.radiusTriggerBg }
    property HusRadius radiusPopupBg: HusRadius { all: themeSource.radiusPopupBg }

    property string sizeHint: 'normal'
    property real sizeRatio: HusTheme.sizeHint[sizeHint]
    property var themeSource: HusTheme.HusColorPicker

    property alias popup: __popup
    property alias panel: __colorPickerPanel

    property Component textDelegate: HusText {
        padding: 4
        text: control.textFormatter(control.value)
        color: control.colorText
        font: control.font
        verticalAlignment: Text.AlignVCenter
    }
    property alias titleDelegate: __colorPickerPanel.titleDelegate
    property Component footerDelegate: Item { }

    function toHexString(color: color): string {
        return __colorPickerPanel.toHexString(color);
    }

    function toHsvString(color: color): string {
        return __colorPickerPanel.toHsvString(color);
    }

    function toRgbString(color: color): string {
        return __colorPickerPanel.toRgbString(color);
    }

    objectName: '__HusColorPicker__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 4
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    contentItem: RowLayout {
        spacing: 4

        Item {
            Layout.preferredWidth: 24 * control.sizeRatio
            Layout.preferredHeight: 24 * control.sizeRatio

            HusCheckerBoard {
                anchors.fill: parent
                rows: 4
                columns: 4
                radiusBg: control.radiusTriggerBg
            }

            HusRectangleInternal {
                anchors.fill: parent
                radius: control.radiusTriggerBg.all
                topLeftRadius: control.radiusTriggerBg.topLeft
                topRightRadius: control.radiusTriggerBg.topRight
                bottomLeftRadius: control.radiusTriggerBg.bottomLeft
                bottomRightRadius: control.radiusTriggerBg.bottomRight
                color: control.value
                border.color: control.themeSource.colorBorder
            }
        }

        Loader {
            Layout.preferredHeight: 24 * control.sizeRatio
            active: control.showText
            visible: active
            sourceComponent: control.textDelegate
        }
    }
    background: HusRectangleInternal {
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
        color: control.colorBg
        border.color: control.colorBorder
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    TapHandler {
        onTapped: __popup.visible = !__popup.visible;
    }

    HusPopup {
        id: __popup
        y: parent.height + 6
        padding: 0
        animationEnabled: control.animationEnabled
        radiusBg: control.radiusPopupBg
        closePolicy: T.Popup.NoAutoClose | T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
        transformOrigin: {
            if (isTop)
                return isLeft ? Item.BottomRight : Item.BottomLeft;
            else
                return isLeft ? Item.TopRight : Item.TopLeft;
        }
        enter: Transition {
            NumberAnimation {
                property: 'scale'
                from: 0.5
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
                to: 0.5
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
        contentItem: Column {
            HusColorPickerPanel {
                id: __colorPickerPanel
                animationEnabled: control.animationEnabled
                themeSource: control.themeSource
                active: control.active
                locale: control.locale
                background: Item { }
                onChange: color => control.change(color);
            }
            Loader {
                width: parent.width
                sourceComponent: control.footerDelegate
            }
        }
        property real xCenter: x + width * 0.5
        property real yCenter: y + height * 0.5
        property bool isLeft: xCenter < control.width * 0.5
        property bool isTop: yCenter < control.height * 0.5
    }
}

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

    signal change(color: color)

    property bool animationEnabled: HusTheme.animationEnabled
    property bool active: hovered || visualFocus
    readonly property color value: autoChange ? __private.value : changeValue
    property color defaultValue: '#fff'
    property bool autoChange: true
    property color changeValue: defaultValue
    property string title: ''
    property bool alphaEnabled: true
    property string format: 'hex'
    property var presets: []
    property int presetsOrientation: Qt.Vertical
    property int presetsLayoutDirection: Qt.LeftToRight
    property alias titleFont: control.font
    property font inputFont: Qt.font({
                                         family: control.themeSource.fontFamilyInput,
                                         pixelSize: parseInt(control.themeSource.fontSizeInput) - 2
                                     })
    property color colorBg: themeSource.colorBg
    property color colorBorder: enabled ?
                                    active ? themeSource.colorBorderHover :
                                             themeSource.colorBorder : themeSource.colorBorderDisabled
    property color colorTitle: themeSource.colorTitle
    property color colorInput: themeSource.colorInput
    property color colorPresetIcon: themeSource.colorPresetIcon
    property color colorPresetText: themeSource.colorPresetText
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }

    property var themeSource: HusTheme.HusColorPicker

    property Component titleDelegate: HusText {
        text: control.title
        color: control.colorTitle
        font: control.titleFont
    }

    function toHexString(color: color): string {
        if (control.alphaEnabled) {
            const noAlpha = Qt.rgba(color.r, color.g, color.b, 1);
            const colorStr = String(noAlpha).toUpperCase();
            const a =  Math.round(color.a * 100);
            return a >= 100 ? `${colorStr}` : `${colorStr},${a}%`;
        } else{
            return String(color).toUpperCase();
        }
    }

    function toHsvString(color: color): string {
        const h = Math.round(color.hsvHue * 359);
        const s = Math.round(color.hsvSaturation * 100);
        const v = Math.round(color.hsvValue * 100);
        if (control.alphaEnabled) {
            const a =  Math.round(color.a * 100);
            return a >= 100 ? `hsv(${h}, ${s}%, ${v}%)` : `hsva(${h}, ${s}%, ${v}%, ${color.a.toFixed(2)})`;
        } else {
            return `hsv(${h}, ${s}%, ${v}%)`;
        }
    }

    function toRgbString(color: color): string {
        const r = Math.round(color.r * 255);
        const g = Math.round(color.g * 255);
        const b = Math.round(color.b * 255);
        if (control.alphaEnabled) {
            const a =  Math.round(color.a * 100);
            return a >= 100 ? `rgb(${r}, ${g}, ${b})` : `rgba(${r}, ${g}, ${b}, ${color.a.toFixed(2)})`;
        } else {
            return `rgb(${r}, ${g}, ${b})`;
        }
    }

    objectName: '__HusColorPickerPanel__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 12
    font {
        family: control.themeSource.fontFamilyTitle
        pixelSize: parseInt(control.themeSource.fontSizeTitle)
    }
    onDefaultValueChanged: __private.updateHSV(defaultValue);
    contentItem: Loader {
        sourceComponent: control.presetsOrientation === Qt.Horizontal ? __horLayout : __verLayout
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

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    component PickerView: ColumnLayout {
        spacing: 12

        Loader {
            Layout.fillWidth: true
            active: control.title !== ''
            visible: active
            sourceComponent: control.titleDelegate
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 160

            Rectangle {
                anchors.fill: parent
                color: Qt.hsva(__private.h, 1, 1, 1)
                radius: 6
            }

            Rectangle {
                anchors.fill: parent
                radius: 6
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: '#ffffffff' }
                    GradientStop { position: 1.0; color: '#00ffffff' }
                }
            }

            Rectangle {
                anchors.fill: parent
                radius: 6
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: '#00000000' }
                    GradientStop { position: 1.0; color: '#ff000000' }
                }
            }

            Rectangle {
                x: __private.s * parent.width - radius
                y: (1 - __private.v) * parent.height - radius
                width: 16
                height: width
                radius: width * 0.5
                border.width: 2
                border.color: HusTheme.isDark ? 'black' : 'white'
                color: 'transparent'
            }

            MouseArea {
                anchors.fill: parent
                preventStealing: true
                cursorShape: Qt.PointingHandCursor
                onPressed: mouse => handleMouse(mouse);
                onPositionChanged: mouse => handleMouse(mouse);

                function handleMouse(mouse) {
                    __private.s = Math.max(0, Math.min(1, mouse.x / width));
                    __private.v = 1 - Math.max(0, Math.min(1, mouse.y / height));
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            spacing: 10

            Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 4

                Item {
                    id: __hueSlider
                    width: parent.width
                    height: 12

                    Rectangle {
                        width: parent.width
                        height: 7
                        anchors.verticalCenter: parent.verticalCenter
                        radius: height * 0.5
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.00; color: '#ff0000' }
                            GradientStop { position: 0.17; color: '#ffff00' }
                            GradientStop { position: 0.33; color: '#00ff00' }
                            GradientStop { position: 0.50; color: '#00ffff' }
                            GradientStop { position: 0.67; color: '#0000ff' }
                            GradientStop { position: 0.83; color: '#ff00ff' }
                            GradientStop { position: 1.00; color: '#ff0000' }
                        }
                    }

                    Rectangle {
                        x: __private.h * (parent.width) - radius
                        width: 14
                        height: width
                        anchors.verticalCenter: parent.verticalCenter
                        radius: width * 0.5
                        color: HusTheme.isDark ? 'black' : 'white'
                        border.color: control.themeSource.colorBorderHover
                        border.width: 1

                        Rectangle {
                            width: parent.width - 6
                            height: width
                            anchors.centerIn: parent
                            radius: width * 0.5
                            color: Qt.hsva(__private.h, 1, 1, 1)
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true
                        cursorShape: Qt.PointingHandCursor
                        onPressed: mouse => handleMouse(mouse);
                        onPositionChanged: mouse => handleMouse(mouse);

                        function handleMouse(mouse) {
                            __private.h = Math.max(0, Math.min(1, mouse.x / width));
                        }
                    }
                }

                Loader {
                    width: parent.width
                    height: 12
                    active: control.alphaEnabled
                    visible: active
                    sourceComponent: Item {

                        HusCheckerBoard {
                            width: parent.width
                            height: 7
                            anchors.verticalCenter: parent.verticalCenter
                            rows: 2
                            columns: 36
                            radiusBg.all: height * 0.5
                        }

                        Rectangle {
                            width: parent.width
                            height: 7
                            anchors.verticalCenter: parent.verticalCenter
                            radius: height * 0.5
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop {
                                    position: 0
                                    color: Qt.hsva(__private.h, __private.s, __private.v, 0)
                                }
                                GradientStop {
                                    position: 1
                                    color: Qt.hsva(__private.h, __private.s, __private.v, 1)
                                }
                            }
                        }

                        Rectangle {
                            x: __private.a * (parent.width) - radius
                            width: 14
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            radius: width * 0.5
                            color: 'transparent'
                            border.color: control.themeSource.colorBorderHover
                            border.width: 1

                            Rectangle {
                                width: parent.width - 2
                                height: width
                                anchors.centerIn: parent
                                radius: width * 0.5
                                color: 'transparent'
                                border.color: HusTheme.isDark ? 'black' : 'white'
                                border.width: 2
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            preventStealing: true
                            cursorShape: Qt.PointingHandCursor
                            onPressed: mouse => handleMouse(mouse);
                            onPositionChanged: mouse => handleMouse(mouse);

                            function handleMouse(mouse) {
                                __private.a = Math.max(0, Math.min(1, mouse.x / width));
                                __private.updateInput();
                            }
                        }
                    }
                }
            }

            Item {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24

                HusCheckerBoard {
                    anchors.fill: parent
                    rows: 4
                    columns: 4
                    radiusBg.all: 4
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: __private.value
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            HusSelect {
                Layout.preferredWidth: 60
                Layout.leftMargin: -5
                Layout.rightMargin: -5
                leftPadding: 0
                rightPadding: 0
                animationEnabled: control.animationEnabled
                font: control.inputFont
                clearEnabled: false
                valueRole: 'label'
                background: Item { }
                model: [
                    { label: 'HEX' },
                    { label: 'HSV' },
                    { label: 'RGB' },
                ]
                onActivated: {
                    control.format = String(currentValue).toLowerCase();
                }
                Component.onCompleted: {
                    currentIndex = model.findIndex(o => o.label.toLowerCase() === control.format);
                }
            }

            Loader {
                Layout.fillWidth: true
                active: control.format === 'hex'
                visible: active
                sourceComponent: HusInput {
                    padding: 4
                    topPadding: 4
                    bottomPadding: 4
                    animationEnabled: control.animationEnabled
                    iconSource: 1
                    iconDelegate: HusText {
                        leftPadding: 12
                        text: '#'
                        color: control.colorPresetIcon
                    }
                    font: control.inputFont
                    text: __private.toHex(__private.value)
                    validator: RegularExpressionValidator { regularExpression: /[0-9a-fA-F]{6}/ }
                    maximumLength: 6
                    inputMethodHints: Qt.ImhHiddenText
                    onTextEdited: {
                        if (length === 6) {
                            const color = Qt.color('#' + text);
                            color.a = __private.a;
                            __private.updateHSV(color);
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                active: control.format === 'hsv'
                visible: active
                sourceComponent: Row {
                    spacing: 4
                    Component.onCompleted: __private.valueChanged();

                    HusInputInteger {
                        id: __hInput
                        width: 50
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 359
                        font: control.inputFont
                        inputMethodHints: Qt.ImhHiddenText
                        onValueModified: __private.h = value / 359;
                    }

                    HusInputInteger {
                        id: __sInput
                        width: 50
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 100
                        font: control.inputFont
                        formatter: (value) => value + '%'
                        parser: (text) => text.replace('%', '')
                        inputMethodHints: Qt.ImhHiddenText
                        onValueModified: __private.s = value * 0.01;
                    }

                    HusInputInteger {
                        id: __vInput
                        width: 50
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 100
                        font: control.inputFont
                        formatter: (value) => value + '%'
                        parser: (text) => text.replace('%', '')
                        inputMethodHints: Qt.ImhHiddenText
                        onValueModified: __private.v = value * 0.01;
                    }

                    Connections {
                        target: __private
                        function onValueChanged() {
                            __hInput.value = Math.round(__private.h * 359);
                            __sInput.value = Math.round(__private.s * 100);
                            __vInput.value = Math.round(__private.v * 100);
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                active: control.format === 'rgb'
                visible: active
                sourceComponent: Row {
                    spacing: 4
                    Component.onCompleted: __private.valueChanged();

                    function updateRGB() {
                        const color = Qt.rgba(__rInput.value / 255,
                                              __gInput.value / 255,
                                              __bInput.value / 255,
                                              __private.a);
                        __private.updateHSV(color);
                    }

                    HusInputInteger {
                        id: __rInput
                        width: 50
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 255
                        font: control.inputFont
                        inputMethodHints: Qt.ImhHiddenText
                        onValueModified: parent.updateRGB();
                    }

                    HusInputInteger {
                        id: __gInput
                        width: 50
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 255
                        font: control.inputFont
                        inputMethodHints: Qt.ImhHiddenText
                        onValueModified: parent.updateRGB();
                    }

                    HusInputInteger {
                        id: __bInput
                        width: 50
                        input.padding: 2
                        input.topPadding: 4
                        input.bottomPadding: 4
                        animationEnabled: control.animationEnabled
                        useWheel: true
                        useKeyboard: true
                        min: 0
                        max: 255
                        font: control.inputFont
                        inputMethodHints: Qt.ImhHiddenText
                        onValueModified: parent.updateRGB();
                    }

                    Connections {
                        target: __private
                        function onValueChanged() {
                            __rInput.value = Math.round(__private.value.r * 255);
                            __gInput.value = Math.round(__private.value.g * 255);
                            __bInput.value = Math.round(__private.value.b * 255);
                        }
                    }
                }
            }

            Loader {
                Layout.preferredWidth: 60
                active: control.alphaEnabled
                visible: active
                sourceComponent: HusInputInteger {
                    id: __alphaInput
                    input.padding: 4
                    input.topPadding: 4
                    input.bottomPadding: 4
                    animationEnabled: control.animationEnabled
                    useWheel: true
                    useKeyboard: true
                    min: 0
                    max: 100
                    font: control.inputFont
                    formatter: (value) => value + '%'
                    parser: (text) => text.replace('%', '')
                    inputMethodHints: Qt.ImhHiddenText
                    onValueModified: __private.a = value * 0.01;
                    Component.onCompleted: __private.updateInput();

                    Connections {
                        target: __private
                        function onUpdateInput() {
                            __alphaInput.value = Math.round(__private.a * 100);
                        }
                    }
                }
            }
        }
    }

    component PresetView: Column {
        spacing: 10

        Repeater {
            model: control.presets
            delegate: Column {
                id: __presetRootItem
                width: parent.width
                spacing: 10

                property bool expanded: modelData?.expanded ?? true

                Item {
                    width: parent.width
                    height: 20

                    RowLayout {
                        anchors.fill: parent
                        spacing: 12

                        HusIconText {
                            iconSource: HusIcon.RightOutlined
                            colorIcon: control.colorPresetIcon
                            rotation: __presetRootItem.expanded ? 90 : 0

                            Behavior on rotation {
                                enabled: control.animationEnabled
                                RotationAnimation {
                                    duration: HusTheme.Primary.durationFast
                                }
                            }
                        }

                        HusText {
                            Layout.fillWidth: true
                            text: modelData.label
                            color: control.colorPresetText
                            elide: Text.ElideRight
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            __presetRootItem.expanded = !__presetRootItem.expanded;
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: __presetRootItem.expanded ? __presetColorFlow.implicitHeight : 0
                    clip: true

                    Behavior on height {
                        enabled: control.animationEnabled
                        NumberAnimation {
                            duration: HusTheme.Primary.durationFast
                        }
                    }

                    Flow {
                        id: __presetColorFlow
                        width: parent.width
                        spacing: 6

                        Repeater {
                            model: modelData.colors

                            Rectangle {
                                width: 24
                                height: 24
                                radius: 6
                                color: modelData

                                HusIconText {
                                    anchors.centerIn: parent
                                    iconSource: HusIcon.CheckOutlined
                                    iconSize: 18
                                    colorIcon: parent.color.hslLightness > 0.5 ? 'black' : 'white'
                                    scale: visible ? 1 : 0
                                    visible: String(__private.value) === String(modelData)
                                    transformOrigin: Item.Bottom

                                    Behavior on scale {
                                        enabled: control.animationEnabled
                                        NumberAnimation {
                                            easing.type: Easing.OutBack
                                            duration: HusTheme.Primary.durationSlow
                                        }
                                    }

                                    Behavior on opacity {
                                        enabled: control.animationEnabled
                                        NumberAnimation {
                                            duration: HusTheme.Primary.durationMid
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        __private.updateHSV(Qt.color(modelData));
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: __horLayout

        RowLayout {
            layoutDirection: control.presetsLayoutDirection
            spacing: 12

            Loader {
                Layout.preferredWidth: 280
                Layout.alignment: Qt.AlignTop
                visible: active
                sourceComponent: PickerView { }
            }

            Loader {
                Layout.preferredWidth: 1
                Layout.fillHeight: true
                active: control.presets.length > 0
                visible: active
                sourceComponent: HusDivider {
                    animationEnabled: control.animationEnabled
                    orientation: Qt.Vertical
                }
            }

            Loader {
                Layout.preferredWidth: 280
                Layout.alignment: Qt.AlignTop
                active: control.presets.length > 0
                visible: active
                sourceComponent: PresetView { }
            }
        }
    }

    Component {
        id: __verLayout

        ColumnLayout {
            layoutDirection: control.presetsLayoutDirection
            spacing: 12

            Loader {
                Layout.preferredWidth: 280
                visible: active
                sourceComponent: PickerView { }
            }

            Loader {
                Layout.preferredWidth: 280
                Layout.preferredHeight: 1
                active: control.presets.length > 0
                visible: active
                sourceComponent: HusDivider {
                    animationEnabled: control.animationEnabled
                }
            }

            Loader {
                Layout.preferredWidth: 280
                active: control.presets.length > 0
                visible: active
                sourceComponent: PresetView { }
            }
        }
    }

    QtObject {
        id: __private

        signal updateInput()

        property real h: 0 // Hue (0-1)
        property real s: 1 // Saturation (0-1)
        property real v: 1 // Value (0-1)
        property real a: 1 // Alpha (0-1)

        property color value: Qt.hsva(h, s, v, alphaEnabled ? a : 1)

        onValueChanged: control.change(value);

        function updateHSV(color) {
            if (color.valid) {
                h = Math.max(0, color.hsvHue);
                s = Math.max(0, color.hsvSaturation);
                v = Math.max(0, color.hsvValue);
                if (control.alphaEnabled) {
                    a = color.a;
                }
                updateInput();
            }
        }

        function floatToHex(value) {
            return Math.round(value).toString(16).padStart(2, '0').toUpperCase();
        }

        function toHex(color) {
            const hexRed = floatToHex(color.r * 255);
            const hexGreen = floatToHex(color.g * 255);
            const hexBlue = floatToHex(color.b * 255);
            return hexRed + hexGreen + hexBlue;
        }
    }
}

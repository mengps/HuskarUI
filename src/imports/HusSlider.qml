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

    enum SnapMode
    {
        NoSnap = 0,
        SnapAlways = 1,
        SnapOnRelease = 2
    }

    signal firstMoved()
    signal firstReleased()
    signal secondMoved()
    signal secondReleased()

    property bool animationEnabled: HusTheme.animationEnabled
    property int hoverCursorShape: Qt.PointingHandCursor
    property real min: 0
    property real max: 100
    property real stepSize: 0.0
    property var value: range ? [0, 0] : 0
    readonly property var currentValue: {
        if (__sliderLoader.item) {
            return range ? [__sliderLoader.item.first.value, __sliderLoader.item.second.value] : __sliderLoader.item.value;
        } else {
            return value;
        }
    }
    property bool range: false
    property int snapMode: HusSlider.NoSnap
    property int orientation: Qt.Horizontal
    property color colorBg: (enabled && hovered) ? themeSource.colorBgHover : themeSource.colorBg
    property color colorHandle: themeSource.colorHandle
    property color colorTrack: {
        if (!enabled) return themeSource.colorTrackDisabled;

        if (HusTheme.isDark)
            return hovered ? themeSource.colorTrackHoverDark : themeSource.colorTrackDark;
        else
            return hovered ? themeSource.colorTrackHover : themeSource.colorTrack;
    }
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusSlider

    property Component handleToolTipDelegate: Item { }
    property Component handleDelegate: Rectangle {
        id: __handleItem
        x: {
            if (control.orientation == Qt.Horizontal) {
                return slider.leftPadding + visualPosition * (slider.availableWidth - width);
            } else {
                return slider.topPadding + (slider.availableWidth - width) * 0.5;
            }
        }
        y: {
            if (control.orientation == Qt.Horizontal) {
                return slider.topPadding + (slider.availableHeight - height) * 0.5;
            } else {
                return slider.leftPadding + visualPosition * (slider.availableHeight - height);
            }
        }
        implicitWidth: active ? 18 : 14
        implicitHeight: active ? 18 : 14
        radius: height * 0.5
        color: control.colorHandle
        border.color: {
            if (control.enabled) {
                if (HusTheme.isDark)
                    return active ? control.themeSource.colorHandleBorderHoverDark : control.themeSource.colorHandleBorderDark;
                else
                    return active ? control.themeSource.colorHandleBorderHover : control.themeSource.colorHandleBorder;
            } else {
                return control.themeSource.colorHandleBorderDisabled;
            }
        }
        border.width: active ? 4 : 2

        property bool down: pressed
        property bool active: __hoverHandler.hovered || down

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        Behavior on border.width { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
        Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        HoverHandler {
            id: __hoverHandler
            enabled: control.enabled
            cursorShape: control.hoverCursorShape
        }

        Loader {
            sourceComponent: handleToolTipDelegate
            onLoaded: item.parent = __handleItem;
            property alias handleHovered: __hoverHandler.hovered
            property alias handlePressed: __handleItem.down
        }
    }
    property Component bgDelegate: Item {
        HusRectangleInternal {
            width: control.orientation == Qt.Horizontal ? parent.width : 4
            height: control.orientation == Qt.Horizontal ? 4 : parent.height
            anchors.horizontalCenter: control.orientation == Qt.Horizontal ? undefined : parent.horizontalCenter
            anchors.verticalCenter: control.orientation == Qt.Horizontal ? parent.verticalCenter : undefined
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

            Rectangle {
                x: {
                    if (control.orientation == Qt.Horizontal)
                        return range ? (slider.first.visualPosition * parent.width) : 0;
                    else
                        return 0;
                }
                y: {
                    if (control.orientation == Qt.Horizontal)
                        return 0;
                    else
                        return range ? (slider.second.visualPosition * parent.height) : slider.visualPosition * parent.height;
                }
                width: {
                    if (control.orientation == Qt.Horizontal)
                        return range ? (slider.second.visualPosition * parent.width - x) : slider.visualPosition * parent.width;
                    else
                        return parent.width;
                }
                height: {
                    if (control.orientation == Qt.Horizontal)
                        return parent.height;
                    else
                        return range ? (slider.first.visualPosition * parent.height - y) : ((1.0 - slider.visualPosition) * parent.height);
                }
                color: colorTrack
                radius: parent.radius

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            }
        }
    }

    function decrease(first = true) {
        if (__sliderLoader.item) {
            if (range) {
                if (first)
                    __sliderLoader.item.first.decrease();
                else
                    __sliderLoader.item.second.decrease();
            } else {
                __sliderLoader.item.decrease();
            }
        }
    }

    function increase(first = true) {
        if (range) {
            if (first)
                __sliderLoader.item.first.increase();
            else
                __sliderLoader.item.second.increase();
        } else {
            __sliderLoader.item.decrease();
        }
    }

    onValueChanged: __private.fromValueUpdate();

    objectName: '__HusSlider__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    contentItem: Loader {
        id: __sliderLoader
        sourceComponent: control.range ? __rangeSliderComponent : __sliderComponent
        onLoaded: __private.fromValueUpdate();
    }

    QtObject {
        id: __private

        function fromValueUpdate() {
            if (__sliderLoader.item) {
                if (range) {
                    __sliderLoader.item.setValues(...value);
                } else {
                    __sliderLoader.item.value = value;
                }
            }
        }
    }

    Component {
        id: __sliderComponent

        T.Slider {
            id: __slider
            from: min
            to: max
            stepSize: control.stepSize
            orientation: control.orientation
            snapMode: {
                switch (control.snapMode) {
                case HusSlider.SnapAlways: return T.Slider.SnapAlways;
                case HusSlider.SnapOnRelease: return T.Slider.SnapOnRelease;
                default: return T.Slider.NoSnap;
                }
            }
            handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __slider
                property alias visualPosition: __slider.visualPosition
                property alias pressed: __slider.pressed
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __slider
                property alias visualPosition: __slider.visualPosition
            }
            onMoved: control.firstMoved();
            onPressedChanged: {
                if (!pressed)
                    control.firstReleased();
            }
        }
    }

    Component {
        id: __rangeSliderComponent

        T.RangeSlider {
            id: __rangeSlider
            from: min
            to: max
            stepSize: control.stepSize
            snapMode: {
                switch (control.snapMode) {
                case HusSlider.SnapAlways: return T.RangeSlider.SnapAlways;
                case HusSlider.SnapOnRelease: return T.RangeSlider.SnapOnRelease;
                default: return T.RangeSlider.NoSnap;
                }
            }
            orientation: control.orientation
            first.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __rangeSlider
                property alias visualPosition: __rangeSlider.first.visualPosition
                property alias pressed: __rangeSlider.first.pressed
            }
            first.onMoved: control.firstMoved();
            first.onPressedChanged: {
                if (!first.pressed)
                    control.firstReleased();
            }
            second.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __rangeSlider
                property alias visualPosition: __rangeSlider.second.visualPosition
                property alias pressed: __rangeSlider.second.pressed
            }
            second.onMoved: control.secondMoved();
            second.onPressedChanged: {
                if (!second.pressed)
                    control.secondReleased();
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __rangeSlider
            }
        }
    }

    Accessible.role: Accessible.Slider
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
    Accessible.onIncreaseAction: increase();
    Accessible.onDecreaseAction: decrease();
}

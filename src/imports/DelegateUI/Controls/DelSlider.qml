import QtQuick
import QtQuick.Templates as T
import DelegateUI

Item {
    id: control

    signal firstMoved();
    signal firstReleased();
    signal secondMoved();
    signal secondReleased();

    property bool animationEnabled: DelTheme.animationEnabled
    property real min: 0
    property real max: 100
    property real stepSize: 0.0
    property var value: range ? 0 : [0, 0]
    readonly property var currentValue: {
        if (__sliderLoader.item) {
            return range ? [__sliderLoader.item.first.value, __sliderLoader.item.second.value] : __sliderLoader.item.value;
        } else {
            return 0;
        }
    }
    property bool range: false
    property bool hovered: __sliderLoader.item ? __sliderLoader.item.hovered : false
    property int snapMode: DelSliderType.NoSnap
    property int orientation: Qt.Horizontal
    property int radiusBg: 6
    property color colorBg: (enabled && hovered) ? DelTheme.DelSlider.colorBgHover : DelTheme.DelSlider.colorBg
    property color colorHandle: DelTheme.DelSlider.colorHandle
    property color colorTrack: {
        if (!enabled) return DelTheme.DelSlider.colorTrackDisabled;

        if (DelTheme.isDark)
            return hovered ? DelTheme.DelSlider.colorTrackHoverDark : DelTheme.DelSlider.colorTrackDark;
        else
            return hovered ? DelTheme.DelSlider.colorTrackHover : DelTheme.DelSlider.colorTrack;
    }
    property Component handleDelegate: Rectangle {
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
            if (DelTheme.isDark)
                return active ? DelTheme.DelSlider.colorHandleBorderHoverDark : DelTheme.DelSlider.colorHandleBorderDark;
            else
                return active ? DelTheme.DelSlider.colorHandleBorderHover : DelTheme.DelSlider.colorHandleBorder;
        }
        border.width: active ? 4 : 2

        property bool active: __hoverHandler.hovered || pressed

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
        Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
        Behavior on border.width { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
        Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

        HoverHandler {
            id: __hoverHandler
            acceptedDevices: PointerDevice.AllDevices
        }
    }
    property Component bgDelegate: Item {
        Rectangle {
            width: control.orientation == Qt.Horizontal ? parent.width : 4
            height: control.orientation == Qt.Horizontal ? 4 : parent.height
            anchors.horizontalCenter: control.orientation == Qt.Horizontal ? undefined : parent.horizontalCenter
            anchors.verticalCenter: control.orientation == Qt.Horizontal ? parent.verticalCenter : undefined
            radius: control.radiusBg
            color: control.colorBg

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

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

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
            }
        }
    }
    property string contentDescription: ""

    onValueChanged: __fromValueUpdate();

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
    function __fromValueUpdate() {
        if (__sliderLoader.item) {
            if (range) {
                __sliderLoader.item.setValues(...value);
            } else {
                __sliderLoader.item.value = value;
            }
        }
    }

    Component {
        id: __sliderComponent

        T.Slider {
            id: __control
            from: min
            to: max
            stepSize: control.stepSize
            orientation: control.orientation
            snapMode: {
                switch (control.snapMode) {
                case DelSliderType.SnapAlways: return T.Slider.SnapAlways;
                case DelSliderType.SnapOnRelease: return T.Slider.SnapOnRelease;
                default: return T.Slider.NoSnap;
                }
            }
            handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.visualPosition
                property alias pressed: __control.pressed
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __control
                property alias visualPosition: __control.visualPosition
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
            id: __control
            from: min
            to: max
            stepSize: control.stepSize
            snapMode: {
                switch (control.snapMode) {
                case DelSliderType.SnapAlways: return T.RangeSlider.SnapAlways;
                case DelSliderType.SnapOnRelease: return T.RangeSlider.SnapOnRelease;
                default: return T.RangeSlider.NoSnap;
                }
            }
            orientation: control.orientation
            first.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.first.visualPosition
                property alias pressed: __control.first.pressed
            }
            first.onMoved: control.firstMoved();
            first.onPressedChanged: {
                if (!first.pressed)
                    control.firstReleased();
            }
            second.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.second.visualPosition
                property alias pressed: __control.second.pressed
            }
            second.onMoved: control.secondMoved();
            second.onPressedChanged: {
                if (!second.pressed)
                    control.secondReleased();
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __control
            }
        }
    }

    Loader {
        id: __sliderLoader
        anchors.fill: parent
        sourceComponent: control.range ? __rangeSliderComponent : __sliderComponent
        onLoaded: __fromValueUpdate();
    }

    Accessible.role: Accessible.Slider
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
    Accessible.onIncreaseAction: increase();
    Accessible.onDecreaseAction: decrease();
}

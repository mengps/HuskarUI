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

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

T.Control {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property real spinSize: 20 * control.sizeRatio
    property real indicatorSize: Math.max(0, (control.spinSize - 2) * 0.5)
    property int indicatorItemCount: 4
    property bool spinning: true
    property int delay: 0
    property bool fullscreen: false
    property string tip: ''
    property var percent: undefined
    property color colorTip: control.fullscreen ? 'white' : themeSource.colorTip
    property color colorIndicator: control.fullscreen ? 'white' : themeSource.colorIndicator
    property color colorProgressBar: control.fullscreen ? 'white' : themeSource.colorProgressBar
    property color colorProgressTrack: themeSource.colorProgressTrack
    property color colorContentMask: themeSource.colorContentMask
    property color colorFullscreenMask: themeSource.colorFullscreenMask
    property string sizeHint: 'normal'
    property real sizeRatio: {
        switch (sizeHint) {
        case 'small': return 0.7;
        case 'large': return 1.6;
        default: return 1.0;
        }
    }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusSpin

    property Component contentDelegate: null
    property Component indicatorDelegate: __defaultIndicator
    property Component indicatorItemDelegate: Rectangle {
        id: __dot

        readonly property int __index: (parent as SpinDotLoader)?.index ?? 0

        width: control.indicatorSize
        height: width
        radius: width * 0.5
        color: control.colorIndicator
        scale: 0.75
        opacity: 0.3

        SequentialAnimation {
            running: control.animationEnabled && __indicatorLoader.visible
            onStopped: __dot.opacity = 0.3;

            PauseAnimation { duration: __dot.__index * 400 }
            SequentialAnimation {
                loops: Animation.Infinite
                OpacityAnimator { target: __dot; from: 0.3; to: 1; duration: 1000 }
                OpacityAnimator { target: __dot; from: 1; to: 0.3; duration: 1000 }
            }
        }
    }
    property Component tipDelegate: HusText {
        text: control.tip
        font: control.font
        color: control.colorTip
    }

    objectName: '__HusSpin__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    padding: 0
    spacing: 12
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }

    onSpinningChanged: {
        if (!spinning)
            __delayTimer.elapsed = false;
    }

    QtObject {
        id: __private

        readonly property bool showIndicator: control.spinning && (control.delay <= 0 || __delayTimer.elapsed)
        readonly property real progress: {
            const percent = control.percent;
            if (percent === 'auto')
                return __autoProgress.value;
            if (typeof percent === 'number' && !Number.isNaN(percent))
                return Math.max(0, Math.min(percent, 100));
            return 0;
        }
    }

    component SpinDotLoader: Loader {
        required property int index
        readonly property real itemSize: control.indicatorSize
        readonly property real __offset: (control.spinSize - itemSize) * 0.5
        readonly property bool __fourDots: control.indicatorItemCount === 4
        readonly property real __angle: 2 * Math.PI * index / control.indicatorItemCount -
                                       (__fourDots ? 3 * Math.PI / 4 : 0)
        readonly property real __radius: __offset * (__fourDots ? Math.SQRT2 : 1)

        x: __offset + __radius * Math.cos(__angle)
        y: __offset + __radius * Math.sin(__angle)
        sourceComponent: control.indicatorItemDelegate
    }

    Component {
        id: __defaultIndicator

        Repeater {
            model: control.indicatorItemCount
            delegate: SpinDotLoader { }
        }
    }

    Timer {
        id: __delayTimer

        property bool elapsed: false
        interval: Math.max(0, control.delay)
        running: control.spinning && control.delay > 0 && !elapsed
        onTriggered: elapsed = true
    }

    Timer {
        id: __autoProgress

        property real value: 0
        readonly property bool autoMode: __private.showIndicator && control.visible && control.percent === 'auto'

        interval: 200
        repeat: true
        running: autoMode && value <= 96
        onAutoModeChanged: value = 0
        onTriggered: {
            const remaining = 100 - value;
            if (value <= 30)
                value += remaining * 0.05;
            else if (value <= 70)
                value += remaining * 0.03;
            else
                value += remaining * 0.01;
        }
    }

    contentItem: Item {
        id: __body

        implicitWidth: __contentLoader.active ? __contentLoader.implicitWidth :
                       __section.parent === __body && __section.visible ? __section.implicitWidth : 0
        implicitHeight: __contentLoader.active ? __contentLoader.implicitHeight :
                        __section.parent === __body && __section.visible ? __section.implicitHeight : 0

        Loader {
            id: __contentLoader

            anchors.fill: parent
            active: control.contentDelegate !== null
            sourceComponent: control.contentDelegate
            enabled: !__private.showIndicator || control.fullscreen
            opacity: enabled ? 1 : 0.5

            Behavior on opacity {
                enabled: control.animationEnabled
                NumberAnimation { duration: HusTheme.Primary.durationSlow }
            }
        }

        Rectangle {
            anchors.fill: parent
            visible: opacity > 0
            color: control.colorContentMask
            opacity: __contentLoader.active && !__contentLoader.enabled ? 1 : 0

            Behavior on opacity {
                enabled: control.animationEnabled
                NumberAnimation { duration: HusTheme.Primary.durationSlow }
            }
        }
    }

    T.Popup {
        id: __fullscreenPopup

        parent: T.Overlay.overlay
        visible: control.fullscreen && control.visible && __private.showIndicator && parent !== null
        modal: true
        focus: true
        closePolicy: T.Popup.NoAutoClose
        width: parent ? parent.width : 0
        height: parent ? parent.height : 0
        background: Rectangle { color: control.colorFullscreenMask }
        contentItem: Item { }

        enter: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 0
                to: 1
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 1
                to: 0
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
    }

    ColumnLayout {
        id: __section

        parent: control.fullscreen ? __fullscreenPopup.contentItem : __body
        anchors.centerIn: parent
        spacing: control.spacing
        visible: __private.showIndicator && control.visible
        z: 1

        Item {
            id: __spinner

            Layout.preferredWidth: control.spinSize
            Layout.preferredHeight: control.spinSize
            Layout.alignment: Qt.AlignHCenter

            property real progressMix: __private.progress > 0 ? 1 : 0

            Behavior on progressMix {
                enabled: control.animationEnabled
                NumberAnimation {
                    duration: HusTheme.Primary.durationSlow
                    easing.type: Easing.InOutQuad
                }
            }

            Loader {
                id: __indicatorLoader

                anchors.fill: parent
                sourceComponent: control.indicatorDelegate
                visible: opacity > 0
                opacity: 1 - __spinner.progressMix
                scale: 1 - 0.7 * __spinner.progressMix
                rotation: initialRotation

                readonly property real initialRotation:
                    control.indicatorDelegate === __defaultIndicator && control.indicatorItemCount === 4 ? 45 : 0

                RotationAnimator on rotation {
                    running: control.animationEnabled && __indicatorLoader.visible
                    from: __indicatorLoader.initialRotation
                    to: from + 360
                    duration: 1200
                    loops: Animation.Infinite
                }
            }

            HusProgress {
                anchors.fill: parent
                // 补偿 HusProgress 圆环的内缩，保持指示器外径。
                anchors.margins: -barThickness * 0.5
                visible: opacity > 0
                opacity: __spinner.progressMix
                scale: 0.3 + 0.7 * __spinner.progressMix
                type: HusProgress.Type_Circle
                animationEnabled: control.animationEnabled
                percent: __private.progress
                barThickness: __spinner.width * 0.2
                showInfo: false
                colorBar: control.colorProgressBar
                colorTrack: control.colorProgressTrack
            }
        }

        Loader {
            Layout.alignment: Qt.AlignHCenter
            active: __section.visible && control.tip !== ''
            visible: active
            sourceComponent: control.tipDelegate
        }
    }

    Accessible.role: Accessible.Indicator
    Accessible.name: control.tip
    Accessible.description: control.contentDescription
}

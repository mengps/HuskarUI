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
import QtQuick.Effects
import HuskarUI.Basic

T.Control {
    id: control

    /* 结束 */
    signal done(int value)

    property bool animationEnabled: HusTheme.animationEnabled
    property int hoverCursorShape: Qt.PointingHandCursor
    property int count: 5
    property real initValue: 0
    property real value: 0
    property int iconSize: 24
    property bool showToolTip: false
    property alias toolTipFont: control.font
    property list<string> toolTipTexts: []
    /* 允许半星 */
    property bool allowHalf: false
    property var fillIcon: HusIcon.StarFilled || ''
    property var emptyIcon: HusIcon.StarFilled || ''
    property var halfIcon: HusIcon.StarFilled || ''
    property color colorFill: themeSource.colorFill
    property color colorEmpty: themeSource.colorEmpty
    property color colorHalf: themeSource.colorHalf
    property color colorToolTipShadow: themeSource.colorToolTipShadow
    property color colorToolTipText: themeSource.colorToolTipText
    property color colorToolTipBg: HusTheme.isDark ? themeSource.colorToolTipBgDark : themeSource.colorToolTipBg
    property var themeSource: HusTheme.HusRate

    property Component fillDelegate: HusIconText {
        colorIcon: control.colorFill
        iconSource: control.fillIcon
        iconSize: control.iconSize
        
        Behavior on opacity {
            enabled: control.animationEnabled
            NumberAnimation { duration: HusTheme.Primary.durationFast }
        }
    }
    property Component emptyDelegate: HusIconText {
        colorIcon: control.colorEmpty
        iconSource: control.emptyIcon
        iconSize: control.iconSize
        
        Behavior on opacity {
            enabled: control.animationEnabled
            NumberAnimation { duration: HusTheme.Primary.durationFast }
        }
    }
    property Component halfDelegate: HusIconText {
        colorIcon: control.colorEmpty
        iconSource: control.emptyIcon
        iconSize: control.iconSize
        
        Behavior on opacity {
            enabled: control.animationEnabled
            NumberAnimation { duration: HusTheme.Primary.durationFast }
        }

        HusIconText {
            id: __source
            colorIcon: control.colorHalf
            iconSource: control.halfIcon
            iconSize: control.iconSize
            layer.enabled: true
            layer.effect: halfRateHelper
            
            Behavior on opacity {
                enabled: control.animationEnabled
                NumberAnimation { duration: HusTheme.Primary.durationFast }
            }
            
            Behavior on width {
                enabled: control.animationEnabled
                NumberAnimation { duration: HusTheme.Primary.durationFast }
            }
        }
    }
    property Component toolTipDelegate: Item {
        width: 12
        height: 6
        opacity: hovered ? 1 : 0

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }

        HusShadow {
            anchors.fill: __item
            source: __item
            shadowColor: control.colorToolTipShadow
        }

        Item {
            id: __item
            width: __toolTipBg.width
            height: __arrow.height + __toolTipBg.height - 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            Rectangle {
                id: __toolTipBg
                width: __toolTipText.implicitWidth + 14
                height: __toolTipText.implicitHeight + 12
                anchors.bottom: __arrow.top
                anchors.bottomMargin: -1
                anchors.horizontalCenter: parent.horizontalCenter
                color: control.colorToolTipBg
                radius: control.themeSource.radiusToolTipBg

                HusText {
                    id: __toolTipText
                    color: control.colorToolTipText
                    text: control.toolTipTexts[index]
                    font: control.toolTipFont
                    anchors.centerIn: parent
                }
            }

            Canvas {
                id: __arrow
                width: 12
                height: 6
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onColorBgChanged: requestPaint();
                onPaint: {
                    const ctx = getContext('2d');
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width, 0);
                    ctx.lineTo(width * 0.5, height);
                    ctx.closePath();
                    ctx.fillStyle = colorBg;
                    ctx.fill();
                }
                property color colorBg: control.colorToolTipBg
            }
        }
    }

    property Component halfRateHelper: ShaderEffect {
        fragmentShader: 'qrc:/HuskarUI/shaders/husrate.frag.qsb'
    }

    onInitValueChanged: {
        __private.doneValue = value = initValue;
    }

    objectName: '__HusRate__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    spacing: 4
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    contentItem: MouseArea {
        implicitWidth: __row.implicitWidth
        implicitHeight: __row.implicitHeight
        hoverEnabled: true
        enabled: control.enabled
        onExited: {
            control.value = __private.doneValue;
        }

        Row {
            id: __row
            spacing: control.spacing

            Repeater {
                id: __repeater

                property int fillCount: Math.floor(control.value)
                property int emptyStartIndex: Math.round(control.value)
                property bool hasHalf: control.allowHalf && control.value - fillCount > 0

                Behavior on fillCount {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: HusTheme.Primary.durationFast }
                }

                Behavior on emptyStartIndex {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: HusTheme.Primary.durationFast }
                }

                model: control.count
                delegate: MouseArea {
                    id: __rootItem
                    width: control.iconSize
                    height: control.iconSize
                    hoverEnabled: true
                    cursorShape: hovered ? control.hoverCursorShape : Qt.ArrowCursor
                    enabled: control.enabled
                    onEntered: {
                        hovered = true;
                        if (control.animationEnabled) {
                            __scaleAnim.start();
                        }
                    }
                    onExited: hovered = false;
                    onClicked:
                        mouse => {
                            const newValue = getCurrentValue(mouse, index);
                            if (__private.doneValue === newValue) {
                                __private.doneValue = control.value = 0;
                            } else {
                                __private.doneValue = control.value = newValue;
                            }
                            control.done(__private.doneValue);
                        }
                    onPositionChanged:
                        mouse => {
                            const newValue = getCurrentValue(mouse, index);
                            /*! 只有当评分值变化时才触发动画 */
                            if (newValue !== control.value) {
                                control.value = newValue;
                                if (control.animationEnabled && !__scaleAnim.running) {
                                    __scaleAnim.start();
                                }
                            }
                        }
                    required property int index
                    property bool hovered: false

                    function getCurrentValue(mouse, index) {
                        if (control.allowHalf) {
                            if (mouse.x > (width * 0.5)) {
                                return index + 1;
                            } else {
                                return index + 0.5;
                            }
                        } else {
                            return index + 1;
                        }
                    }

                    SequentialAnimation {
                        id: __scaleAnim
                        NumberAnimation {
                            target: __rootItemContainer
                            property: 'scale'
                            from: 1.0
                            to: 1.15
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: __rootItemContainer
                            property: 'scale'
                            from: 1.15
                            to: 1.0
                            duration: 100
                            easing.type: Easing.OutBounce
                        }
                    }

                    Item {
                        id: __rootItemContainer
                        width: parent.width
                        height: parent.height

                        Loader {
                            id: fillLoader
                            anchors.fill: parent
                            active: true
                            opacity: index < __repeater.fillCount ? 1.0 : 0.0
                            sourceComponent: control.fillDelegate
                            property int index: __rootItem.index
                            property bool hovered: __rootItem.hovered

                            Behavior on opacity {
                                enabled: control.animationEnabled
                                NumberAnimation { duration: HusTheme.Primary.durationFast }
                            }
                        }

                        Loader {
                            id: halfLoader
                            anchors.fill: parent
                            active: control.allowHalf
                            opacity: __repeater.hasHalf && index === (__repeater.emptyStartIndex - 1) ? 1.0 : 0.0
                            sourceComponent: control.halfDelegate
                            property int index: __rootItem.index
                            property bool hovered: __rootItem.hovered

                            Behavior on opacity {
                                enabled: control.animationEnabled && __private.supportsHalfAnimation
                                NumberAnimation { duration: HusTheme.Primary.durationFast }
                            }
                        }

                        Loader {
                            id: emptyLoader
                            anchors.fill: parent
                            active: true
                            opacity: index >= __repeater.emptyStartIndex ? 1.0 : 0.0
                            sourceComponent: control.emptyDelegate
                            property int index: __rootItem.index
                            property bool hovered: __rootItem.hovered

                            Behavior on opacity {
                                enabled: control.animationEnabled
                                NumberAnimation { duration: HusTheme.Primary.durationFast }
                            }
                        }
                    }

                    Loader {
                        x: (parent.width - width) * 0.5
                        y: -height - 4
                        z: 10
                        active: control.showToolTip
                        sourceComponent: control.toolTipDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }
                }
            }
        }
    }

    QtObject {
        id: __private
        property real doneValue: 0
        /* 是否支持半星动画 */
        property bool supportsHalfAnimation: control.allowHalf &&
                                             ((fillIcon === HusIcon.StarFilled && emptyIcon === HusIcon.StarFilled) || halfIcon !== emptyIcon)
    }
}

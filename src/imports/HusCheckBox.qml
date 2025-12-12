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

T.CheckBox {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property int indicatorSize: 18
    property color colorText: enabled ? themeSource.colorText : themeSource.colorTextDisabled
    property color colorIndicator: {
        if (enabled) {
            return (checkState !== Qt.Unchecked) ? hovered ? themeSource.colorIndicatorCheckedHover :
                                                             themeSource.colorIndicatorChecked : themeSource.colorIndicator
        } else {
            return themeSource.colorIndicatorDisabled;
        }
    }
    property color colorIndicatorBorder: enabled ?
                                             (hovered || checked) ? themeSource.colorIndicatorBorderChecked :
                                                                    themeSource.colorIndicatorBorder : themeSource.colorIndicatorDisabled
    property HusRadius radiusIndicator: HusRadius { all: themeSource.radiusIndicator }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusCheckBox

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorIndicator { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorIndicatorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    objectName: '__HusCheckBox__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight, implicitIndicatorHeight) + topPadding + bottomPadding
    font.family: themeSource.fontFamily
    font.pixelSize: parseInt(themeSource.fontSize)
    spacing: 6
    indicator: Item {
        x: control.leftPadding
        implicitWidth: __bg.width
        implicitHeight: __bg.height
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.radius
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: 'transparent'
            border.width: 0
            border.color: control.enabled ? control.themeSource.colorEffectBg : 'transparent'
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: 'width'; from: __bg.width + 2; to: __bg.width + 10;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'height'; from: __bg.height + 2; to: __bg.height + 10;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'opacity'; from: 0.1; to: 0;
                    duration: HusTheme.Primary.durationSlow
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled && control.effectEnabled) {
                        __effect.border.width = 6;
                        __animation.restart();
                    }
                }
            }
        }

        HusRectangleInternal {
            id: __bg
            width: control.indicatorSize
            height: control.indicatorSize
            radius: control.radiusIndicator.all
            topLeftRadius: control.radiusIndicator.topLeft
            topRightRadius: control.radiusIndicator.topRight
            bottomLeftRadius: control.radiusIndicator.bottomLeft
            bottomRightRadius: control.radiusIndicator.bottomRight
            color: 'transparent'
            border.color: control.colorIndicatorBorder
            border.width: 1
            anchors.centerIn: parent

            /*! 勾选背景 */
            HusRectangleInternal {
                id: __checkedBg
                anchors.fill: parent
                color: control.colorIndicator
                visible: opacity !== 0
                opacity: control.checkState === Qt.Checked ? 1.0 : 0.0
                radius: parent.radius - 1
                topLeftRadius: Math.max(0, parent.topLeftRadius - 1)
                topRightRadius: Math.max(0, parent.topRightRadius - 1)
                bottomLeftRadius: Math.max(0, parent.bottomLeftRadius - 1)
                bottomRightRadius: Math.max(0, parent.bottomRightRadius - 1)

                Behavior on opacity {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: HusTheme.Primary.durationFast }
                }
            }

            /*! 勾选标记 */
            Item {
                id: __checkMarkContainer
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: parent.height * 0.6
                visible: opacity !== 0
                scale: control.checkState === Qt.Checked ? 1.1 : 0.2
                opacity: control.checkState === Qt.Checked ? 1.0 : 0.0

                Behavior on scale {
                    enabled: control.animationEnabled
                    NumberAnimation { easing.overshoot: 2.5; easing.type: Easing.OutBack; duration: HusTheme.Primary.durationSlow }
                }

                Behavior on opacity {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: HusTheme.Primary.durationFast }
                }

                Canvas {
                    id: __checkMark
                    anchors.fill: parent
                    visible: control.checkState === Qt.Checked

                    property real animationProgress: control.animationEnabled ? 0 : 1
                    property real lineWidth: 2
                    property color checkColor: control.enabled ? '#fff' : control.themeSource.colorIndicatorDisabled

                    onAnimationProgressChanged: requestPaint();

                    onPaint: {
                        let ctx = getContext('2d');
                        ctx.clearRect(0, 0, width, height);

                        ctx.lineWidth = lineWidth;
                        ctx.strokeStyle = checkColor;
                        ctx.fillStyle = 'transparent';
                        ctx.lineCap = 'round';
                        ctx.lineJoin = 'round';

                        const startX = width * 0.2;
                        const midPointX = width * 0.4;
                        const endX = width * 0.8;
                        const midPointY = height * 0.75;
                        const startY = height * 0.5;
                        const endY = height * 0.2;

                        ctx.beginPath();

                        if (animationProgress > 0) {
                            ctx.moveTo(startX, startY);
                            if (animationProgress < 0.5) {
                                const currentX = startX + (midPointX - startX) * (animationProgress * 2);
                                const currentY = startY + (midPointY - startY) * (animationProgress * 2);
                                ctx.lineTo(currentX, currentY);
                            } else {
                                const t = (animationProgress - 0.5) * 2;
                                const currentX = midPointX + (endX - midPointX) * t;
                                const currentY = midPointY + (endY - midPointY) * t;
                                ctx.lineTo(midPointX, midPointY);
                                ctx.lineTo(currentX, currentY);
                            }
                        }

                        ctx.stroke();
                    }

                    SequentialAnimation {
                        id: __checkMarkAnimation
                        running: control.checkState === Qt.Checked && control.animationEnabled

                        NumberAnimation {
                            target: __checkMark
                            property: 'animationProgress'
                            from: 0
                            to: 1
                            duration: HusTheme.Primary.durationSlow
                            easing.type: Easing.OutCubic
                        }

                        onStarted: {
                            __checkMark.visible = true;
                            __checkMark.requestPaint();
                        }

                        onRunningChanged: {
                            if (!running && control.checkState !== Qt.Checked) {
                                __checkMark.animationProgress = 0;
                                __checkMark.visible = false;
                            }
                            __checkMark.requestPaint();
                        }
                    }
                }
            }

            /*! 部分选择状态 */
            Rectangle {
                id: __partialCheckMark
                x: (parent.width - width) / 2
                y: (parent.height - height) / 2
                width: parent.width * 0.5
                height: parent.height * 0.5
                color: control.colorIndicator
                visible: control.checkState === Qt.PartiallyChecked
                radius: parent.radius * 0.5

                Behavior on opacity {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: HusTheme.Primary.durationFast }
                }
            }
        }
    }
    contentItem: HusText {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing

        Behavior on opacity {
            enabled: control.animationEnabled
            NumberAnimation { duration: HusTheme.Primary.durationMid }
        }
    }
    background: Item { }

    onCheckStateChanged: {
        if (control.checkState === Qt.Unchecked) {
            __checkMark.animationProgress = 0;
            __checkMark.visible = false;
            __checkMark.requestPaint();
        } else if (control.checkState === Qt.Checked && !control.animationEnabled) {
            /*! 不开启动画时立即显示完整勾选标记 */
            __checkMark.animationProgress = 1;
            __checkMark.visible = true;
            __checkMark.requestPaint();
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}

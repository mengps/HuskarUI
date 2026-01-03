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

T.RadioButton {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property color colorText: enabled ? HusTheme.HusRadio.colorText : HusTheme.HusRadio.colorTextDisabled
    property color colorIndicator: enabled ?
                                       checked ? HusTheme.HusRadio.colorIndicatorChecked :
                                                 HusTheme.HusRadio.colorIndicator : HusTheme.HusRadio.colorIndicatorDisabled
    property color colorIndicatorBorder: (enabled && (hovered || checked)) ? HusTheme.HusRadio.colorIndicatorBorderChecked :
                                                                             HusTheme.HusRadio.colorIndicatorBorder
    property HusRadius radiusIndicator: HusRadius { all: HusTheme.HusRadio.radiusIndicator }
    property string contentDescription: ''

    objectName: '__HusRadio__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight, implicitIndicatorHeight) + topPadding + bottomPadding
    font {
        family: HusTheme.HusRadio.fontFamily
        pixelSize: parseInt(HusTheme.HusRadio.fontSize)
    }
    spacing: 8
    indicator: Item {
        x: control.leftPadding
        implicitWidth: __bg.width
        implicitHeight: __bg.height
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: width * 0.5
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: 'transparent'
            border.width: 0
            border.color: control.enabled ? HusTheme.HusRadio.colorEffectBg : 'transparent'
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'opacity'; from: 0.2; to: 0;
                    duration: HusTheme.Primary.durationSlow
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled && control.effectEnabled) {
                        __effect.border.width = 8;
                        __animation.restart();
                    }
                }
            }
        }

        Rectangle {
            id: __bg
            width: control.radiusIndicator.all * 2
            height: width
            anchors.centerIn: parent
            radius: height * 0.5
            color: control.colorIndicator
            border.color: control.colorIndicatorBorder
            border.width: control.checked ? 0 : 1

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

            Rectangle {
                width: control.checked ? control.radiusIndicator.all - 2 : 0
                height: width
                anchors.centerIn: parent
                radius: width * 0.5

                Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
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
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}

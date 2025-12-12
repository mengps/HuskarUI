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

T.Popup {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool movable: false
    property bool resizable: false
    property real minimumX: Number.NaN
    property real maximumX: Number.NaN
    property real minimumY: Number.NaN
    property real maximumY: Number.NaN
    property real minimumWidth: 0
    property real maximumWidth: Number.NaN
    property real minimumHeight: 0
    property real maximumHeight: Number.NaN
    property color colorShadow: themeSource.colorShadow
    property color colorBg: HusTheme.isDark ? themeSource.colorBgDark : themeSource.colorBg
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property var themeSource: HusTheme.HusPopup

    objectName: '__HusPopup__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    enter: Transition {
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
            property: 'opacity'
            from: 1.0
            to: 0
            easing.type: Easing.InQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    background: Item {
        HusShadow {
            anchors.fill: __popupRect
            source: __popupRect
            shadowColor: control.colorShadow
        }
        HusRectangleInternal {
            id: __popupRect
            anchors.fill: parent
            color: control.colorBg
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
        }
        Loader {
            active: control.movable || control.resizable
            sourceComponent: HusResizeMouseArea {
                anchors.fill: parent
                target: control
                movable: control.movable
                resizable: control.resizable
                minimumX: control.minimumX
                maximumX: control.maximumX
                minimumY: control.minimumY
                maximumY: control.maximumY
                minimumWidth: control.minimumWidth
                maximumWidth: control.maximumWidth
                minimumHeight: control.minimumHeight
                maximumHeight: control.maximumHeight
            }
        }
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
}

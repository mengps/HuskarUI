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
import HuskarUI.Basic

Item {
    id: control

    property alias sourceItem: __source.sourceItem
    property alias sourceRect: __source.sourceRect
    property real refraction: 0.026
    property real bevelDepth: 0.119
    property real bevelWidth: 0.057
    property real frost: 0.0
    property bool animated: true
    property real specularIntensity: 1.0
    property real tiltX: 0.0
    property real tiltY: 0.0
    property real magnify: 1.0
    property HusRadius radiusBg: HusRadius { all: 0 }

    objectName: '__HusLiquidGlass__'

    readonly property real __srcScale: {
        const magnifyPad = Math.max(1.0 / Math.max(control.magnify, 0.001), 1.0);
        const refrPad = 1.0 + 2.0 * (control.refraction + control.bevelDepth);
        return Math.max(magnifyPad, refrPad, 1.1);
    }

    ShaderEffectSource {
        id: __source
        anchors.fill: parent
        visible: false
        sourceRect: Qt.rect(
            control.x - control.width * (control.__srcScale - 1.0) * 0.5,
            control.y - control.height * (control.__srcScale - 1.0) * 0.5,
            control.width * control.__srcScale,
            control.height * control.__srcScale
        )
    }

    ShaderEffect {
        id: __shaderEffect
        anchors.fill: parent

        property variant source: __source
        property vector2d resolution: Qt.vector2d(control.width, control.height)
        property real refraction: control.refraction
        property real bevelDepth: control.bevelDepth
        property real bevelWidth: control.bevelWidth
        property real frost: control.frost
        property real radius: control.radiusBg.all
        property real specularIntensity: control.specularIntensity
        property real tiltX: control.tiltX
        property real tiltY: control.tiltY
        property real magnify: control.magnify
        property real iTime: 0.0

        NumberAnimation on iTime {
            running: control.animated && control.specularIntensity > 0.0
            loops: Animation.Infinite
            from: 0
            to: 360000      // 360000 seconds = 100 hours
            duration: 360000000  // real-time: 1 unit = 1 second
        }

        vertexShader: 'qrc:/HuskarUI/shaders/husliquidglass.vert.qsb'
        fragmentShader: 'qrc:/HuskarUI/shaders/husliquidglass.frag.qsb'
    }
}

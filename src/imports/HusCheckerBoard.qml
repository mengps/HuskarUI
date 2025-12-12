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
import QtQuick.Effects
import HuskarUI.Basic

Item {
    id: control

    property alias rows: __checkerGrid.rows
    property alias columns: __checkerGrid.columns
    property color colorWhite: 'transparent'
    property color colorBlack: HusTheme.Primary.colorFillSecondary
    property HusRadius radiusBg: HusRadius { all: 0 }

    HusRectangleInternal {
        id: __mask
        anchors.fill: parent
        radius: parent.radiusBg.all
        topLeftRadius: parent.radiusBg.topLeft
        topRightRadius: parent.radiusBg.topRight
        bottomLeftRadius: parent.radiusBg.bottomLeft
        bottomRightRadius: parent.radiusBg.bottomRight
        layer.enabled: true
        visible: false
    }

    Grid {
        id: __checkerGrid
        anchors.fill: parent
        layer.enabled: true
        visible: false

        property real cellWidth: width / columns
        property real cellHeight: height / rows

        Repeater {
            model: parent.rows * parent.columns

            Rectangle {
                width: __checkerGrid.cellWidth
                height: __checkerGrid.cellHeight
                color: (rowIndex + colIndex) % 2 === 0 ? control.colorWhite : control.colorBlack
                required property int index
                property int rowIndex: Math.floor(index / __checkerGrid.columns)
                property int colIndex: index % __checkerGrid.columns
            }
        }
    }

    MultiEffect {
        anchors.fill: __checkerGrid
        maskEnabled: true
        maskSource: __mask
        source: __checkerGrid
    }
}

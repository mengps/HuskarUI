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

    enum TextSize {
        Size_Fixed = 0,
        Size_Auto = 1
    }

    property int size: 30
    property var iconSource: 0 ?? ''

    property string imageSource: ''
    property bool imageMipmap: false

    property string textSource: ''
    property alias textFont: control.font
    property int textSize: HusAvatar.Size_Fixed
    property int textGap: 4

    property color colorBg: HusTheme.Primary.colorTextQuaternary
    property color colorIcon: 'white'
    property color colorText: 'white'
    property HusRadius radiusBg: HusRadius { all: control.width * 0.5 }

    objectName: '__HusAvatar__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    font {
        family: HusTheme.Primary.fontPrimaryFamily
        pixelSize: control.size * 0.5
    }
    contentItem: Loader {
        sourceComponent: {
            if (control.iconSource !== 0 && control.iconSource !== '')
                return __iconImpl;
            else if (control.imageSource != '')
                return __imageImpl;
            else
                return __textImpl;
        }
    }

    Component {
        id: __iconImpl

        HusRectangleInternal {
            implicitWidth: control.size
            implicitHeight: control.size
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg

            HusIconText {
                id: __iconSource
                anchors.centerIn: parent
                iconSource: control.iconSource
                iconSize: control.size * 0.7
                colorIcon: control.colorIcon
            }
        }
    }

    Component {
        id: __imageImpl

        HusRectangleInternal {
            implicitWidth: control.size
            implicitHeight: control.size
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg

            HusRectangleInternal {
                id: __mask
                anchors.fill: parent
                radius: parent.radius
                topLeftRadius: parent.topLeftRadius
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                layer.enabled: true
                visible: false
            }

            Image {
                id: __imageSource
                anchors.fill: parent
                mipmap: control.imageMipmap
                source: control.imageSource
                sourceSize: Qt.size(width, height)
                layer.enabled: true
                visible: false
            }

            MultiEffect {
                anchors.fill: __imageSource
                maskEnabled: true
                maskSource: __mask
                source: __imageSource
            }
        }
    }

    Component {
        id: __textImpl

        HusRectangleInternal {
            id: __bg
            implicitWidth: Math.max(control.size, __textSource.implicitWidth + control.textGap * 2);
            implicitHeight: implicitWidth
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg
            Component.onCompleted: calcBestSize();

            function calcBestSize() {
                if (control.textSize == HusAvatar.Size_Fixed) {
                    __textSource.font.pixelSize = control.size * 0.5;
                } else {
                    let bestSize = control.size * 0.5;
                    __fontMetrics.font.pixelSize = bestSize;
                    while ((__fontMetrics.advanceWidth(control.textSource) + control.textGap * 2 > control.size)) {
                        bestSize -= 1;
                        __fontMetrics.font.pixelSize = bestSize;
                        if (bestSize <= 1) break;
                    }
                    __textSource.font.pixelSize = bestSize;
                }
            }

            FontMetrics {
                id: __fontMetrics
                font.family: __textSource.font.family
            }

            HusText {
                id: __textSource
                anchors.centerIn: parent
                color: control.colorText
                text: control.textSource
                smooth: true
                font: control.textFont

                Connections {
                    target: control
                    function onTextSourceChanged() {
                        __bg.calcBestSize();
                    }
                }
            }
        }
    }
}

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
import QtQuick.Shapes
import HuskarUI.Basic

Item {
    id: control

    enum Align
    {
        Align_Left = 0,
        Align_Center = 1,
        Align_Right = 2
    }

    enum Style
    {
        SolidLine = 0,
        DashLine = 1
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property string title: ''
    property font titleFont: Qt.font({
                                         family: themeSource.fontFamily,
                                         pixelSize: parseInt(themeSource.fontSize)
                                     })
    property int titleAlign: HusDivider.Align_Left
    property int titlePadding: 20
    property int lineStyle: HusDivider.SolidLine
    property real lineWidth: 1
    property list<real> dashPattern: [4, 2]
    property int orientation: Qt.Horizontal
    property color colorText: themeSource.colorText
    property color colorSplit: themeSource.colorSplit
    property var themeSource: HusTheme.HusDivider

    property Component titleDelegate: HusText {
        text: control.title
        font: control.titleFont
        color: control.colorText
    }
    property Component splitDelegate: Shape {
        id: __shape

        property real lineX: __titleLoader.x + __titleLoader.implicitWidth * 0.5
        property real lineY: __titleLoader.y + __titleLoader.implicitHeight * 0.5

        ShapePath {
            strokeStyle: control.lineStyle === HusDivider.SolidLine ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorSplit
            strokeWidth: control.lineWidth
            dashPattern: control.dashPattern
            fillColor: 'transparent'
            startX: control.orientation === Qt.Horizontal ? 0 : __shape.lineX
            startY: control.orientation === Qt.Horizontal ? __shape.lineY : 0

            PathLine {
                x: {
                    if (control.orientation === Qt.Horizontal) {
                        return control.title === '' ? 0 : __titleLoader.x - 10;
                    } else {
                        return __shape.lineX;
                    }
                }
                y: control.orientation === Qt.Horizontal ? __shape.lineY : __titleLoader.y - 10
            }
        }

        ShapePath {
            strokeStyle: control.lineStyle === HusDivider.SolidLine ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorSplit
            strokeWidth: control.lineWidth
            dashPattern: control.dashPattern
            fillColor: 'transparent'
            startX: {
                if (control.orientation === Qt.Horizontal) {
                    return control.title === '' ? 0 : (__titleLoader.x + __titleLoader.implicitWidth + 10);
                } else {
                    return __shape.lineX;
                }
            }
            startY: {
                if (control.orientation === Qt.Horizontal) {
                    return __shape.lineY;
                } else {
                    return control.title === '' ? 0 : (__titleLoader.y + __titleLoader.implicitHeight + 10);
                }
            }

            PathLine {
                x: control.orientation === Qt.Horizontal ?  control.width : __shape.lineX
                y: control.orientation === Qt.Horizontal ? __shape.lineY : control.height
            }
        }
    }
    property string contentDescription: title

    objectName: '__HusDivider__'

    Behavior on colorSplit { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    Loader {
        id: __splitLoader
        sourceComponent: control.splitDelegate
    }

    Loader {
        id: __titleLoader
        z: 1
        anchors.top: (control.orientation !== Qt.Horizontal && control.titleAlign === HusDivider.Align_Left) ? parent.top : undefined
        anchors.topMargin: (control.orientation !== Qt.Horizontal && control.titleAlign === HusDivider.Align_Left) ? control.titlePadding : 0
        anchors.bottom: (control.orientation !== Qt.Horizontal && control.titleAlign === HusDivider.Align_Right) ? parent.right : undefined
        anchors.bottomMargin: (control.orientation !== Qt.Horizontal && control.titleAlign === HusDivider.Align_Right) ? control.titlePadding : 0
        anchors.left: (control.orientation === Qt.Horizontal && control.titleAlign === HusDivider.Align_Left) ? parent.left : undefined
        anchors.leftMargin: (control.orientation === Qt.Horizontal && control.titleAlign === HusDivider.Align_Left) ? control.titlePadding : 0
        anchors.right: (control.orientation === Qt.Horizontal && control.titleAlign === HusDivider.Align_Right) ? parent.right : undefined
        anchors.rightMargin: (control.orientation === Qt.Horizontal && control.titleAlign === HusDivider.Align_Right) ? control.titlePadding : 0
        anchors.horizontalCenter: (control.orientation !== Qt.Horizontal || control.titleAlign === HusDivider.Align_Center) ? parent.horizontalCenter : undefined
        anchors.verticalCenter: (control.orientation === Qt.Horizontal || control.titleAlign === HusDivider.Align_Center) ? parent.verticalCenter : undefined
        sourceComponent: control.titleDelegate
    }

    Accessible.role: Accessible.Separator
    Accessible.name: control.title
    Accessible.description: control.contentDescription
}

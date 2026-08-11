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
import QtQuick.Shapes
import HuskarUI.Basic

T.GroupBox {
    id: control

    property color colorTitle: enabled ? themeSource.colorTitle :
                                         themeSource.colorTitleDisabled
    property color colorBg: 'transparent'
    property HusRadius radiusBg: HusRadius { all: HusTheme.Primary.radiusPrimary }
    property HusBorder borderBg: HusBorder {
        width: 1 / Screen.devicePixelRatio
        color: enabled ? themeSource.colorBorder :
                         themeSource.colorBorderDisabled
    }
    property string sizeHint: 'normal'
    property real sizeRatio: HusTheme.sizeHint[sizeHint]
    property var themeSource: HusTheme.HusGroupBox

    objectName: '__HusGroupBox__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitLabelWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    padding: 12 * sizeRatio
    topPadding: padding + (implicitLabelWidth > 0 ? implicitLabelHeight * 0.5 : 0)
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize) * sizeRatio
    }
    label: HusText {
        x: control.leftPadding
        width: control.availableWidth
        text: control.title
        font: control.font
        color: control.colorTitle
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
    background: Item {
        y: control.topPadding - control.bottomPadding
        width: parent.width
        height: parent.height - control.topPadding + control.bottomPadding

        Shape {
            id: __shape
            anchors.fill: parent
            
            ShapePath {
                id: __path
                strokeColor: control.borderBg.color
                strokeWidth: control.borderBg.width
                strokeStyle: {
                    switch (control.borderBg.style) {
                    case Qt.SolidLine: return ShapePath.SolidLine;
                    case Qt.DashLine: return ShapePath.DashLine;
                    default: return ShapePath.SolidLine;
                    }
                }
                fillColor: control.colorBg
                
                property real inset: strokeWidth * 0.5
                property real w: __shape.width - inset
                property real h: __shape.height - inset
                
                property real rTL: Math.max(0.001, control.radiusBg.topLeft)
                property real rTR: Math.max(0.001, control.radiusBg.topRight)
                property real rBR: Math.max(0.001, control.radiusBg.bottomRight)
                property real rBL: Math.max(0.001, control.radiusBg.bottomLeft)
                
                property real labelWidth: control.implicitLabelWidth
                property real gapStartX: control.leftPadding - 4 * control.sizeRatio
                property real gapEndX: control.leftPadding + labelWidth + 4 * control.sizeRatio
                
                property real safeGapStartX: labelWidth <= 0 ? inset + rTL : Math.min(w - rTR, Math.max(inset + rTL, gapStartX))
                property real safeGapEndX: labelWidth <= 0 ? inset + rTL : Math.min(w - rTR, Math.max(inset + rTL, gapEndX))

                startX: safeGapEndX
                startY: inset
                
                PathLine { x: __path.w - __path.rTR; y: __path.inset }
                PathArc {
                    x: __path.w; y: __path.inset + __path.rTR
                    radiusX: __path.rTR; radiusY: __path.rTR
                    useLargeArc: false
                }
                PathLine { x: __path.w; y: __path.h - __path.rBR }
                PathArc {
                    x: __path.w - __path.rBR; y: __path.h
                    radiusX: __path.rBR; radiusY: __path.rBR
                    useLargeArc: false
                }
                PathLine { x: __path.inset + __path.rBL; y: __path.h }
                PathArc {
                    x: __path.inset; y: __path.h - __path.rBL
                    radiusX: __path.rBL; radiusY: __path.rBL
                    useLargeArc: false
                }
                PathLine { x: __path.inset; y: __path.inset + __path.rTL }
                PathArc {
                    x: __path.inset + __path.rTL; y: __path.inset
                    radiusX: __path.rTL; radiusY: __path.rTL
                    useLargeArc: false
                }
                PathLine { x: __path.safeGapStartX; y: __path.inset }
            }
        }
    }

    QtObject {
        id: __private
        property real implicitLabelHeight: control.title === '' ? 0 : control.implicitLabelHeight
    }
}

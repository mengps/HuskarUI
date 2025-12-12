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

T.ToolTip {
    id: control

    enum Position
    {
        Position_Top = 0,
        Position_Bottom = 1,
        Position_Left = 2,
        Position_Right = 3
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property bool showArrow: false
    property int position: HusToolTip.Position_Top
    property color colorShadow: HusTheme.HusToolTip.colorShadow
    property color colorText: HusTheme.HusToolTip.colorText
    property color colorBg: HusTheme.isDark ? HusTheme.HusToolTip.colorBgDark : HusTheme.HusToolTip.colorBg
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusToolTip.radiusBg }

    component Arrow: Canvas {
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onColorBgChanged: requestPaint();
        onPaint: {
            const ctx = getContext('2d');
            ctx.fillStyle = colorBg;
            ctx.beginPath();
            switch (position) {
            case HusToolTip.Position_Top: {
                ctx.moveTo(0, 0);
                ctx.lineTo(width, 0);
                ctx.lineTo(width * 0.5, height);
            } break;
            case HusToolTip.Position_Bottom: {
                ctx.moveTo(0, height);
                ctx.lineTo(width, height);
                ctx.lineTo(width * 0.5, 0);
            } break;
            case HusToolTip.Position_Left: {
                ctx.moveTo(0, 0);
                ctx.lineTo(0, height);
                ctx.lineTo(width, height * 0.5);
            } break;
            case HusToolTip.Position_Right: {
                ctx.moveTo(width, 0);
                ctx.lineTo(width, height);
                ctx.lineTo(0, height * 0.5);
            } break;
            }
            ctx.closePath();
            ctx.fill();
        }
        property color colorBg: control.colorBg
    }

    x: {
        switch (position) {
        case HusToolTip.Position_Top:
        case HusToolTip.Position_Bottom:
            return (__private.controlParentWidth - implicitWidth) * 0.5;
        case HusToolTip.Position_Left:
            return -implicitWidth - 4;
        case HusToolTip.Position_Right:
            return __private.controlParentWidth + 4;
        }
    }
    y: {
        switch (position) {
        case HusToolTip.Position_Top:
            return -implicitHeight - 4;
        case HusToolTip.Position_Bottom:
            return __private.controlParentHeight + 4;
        case HusToolTip.Position_Left:
        case HusToolTip.Position_Right:
            return (__private.controlParentHeight - implicitHeight) * 0.5;
        }
    }

    objectName: '__HusToolTip__'
    implicitWidth: implicitContentWidth
    implicitHeight: implicitContentHeight
    delay: 500
    padding: 0
    font {
        family: HusTheme.HusToolTip.fontFamily
        pixelSize: parseInt(HusTheme.HusToolTip.fontSize)
    }
    enter: Transition {
        NumberAnimation { property: 'opacity'; from: 0.0; to: 1.0; duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 }
    }
    exit: Transition {
        NumberAnimation { property: 'opacity'; from: 1.0; to: 0.0; duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 }
    }
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent
    contentItem: Item {
        implicitWidth: __bg.width + (__private.isHorizontal ? 0 : __arrow.width)
        implicitHeight: __bg.height + (__private.isHorizontal ? __arrow.height : 0)

        HusShadow {
            anchors.fill: __item
            source: __item
            shadowColor: control.colorShadow
        }

        Item {
            id: __item
            anchors.fill: parent

            Arrow {
                id: __arrow
                x: __private.isHorizontal ? (-control.x + (__private.controlParentWidth - width) * 0.5) : 0
                y: __private.isHorizontal ? 0 : (-control.y + (__private.controlParentHeight - height)) * 0.5
                width: __private.arrowSize.width
                height: __private.arrowSize.height
                anchors.top: control.position == HusToolTip.Position_Bottom ? parent.top : undefined
                anchors.bottom: control.position == HusToolTip.Position_Top ? parent.bottom : undefined
                anchors.left: control.position == HusToolTip.Position_Right ? parent.left : undefined
                anchors.right: control.position == HusToolTip.Position_Left ? parent.right : undefined

                Connections {
                    target: control
                    function onPositionChanged() {
                        __arrow.requestPaint();
                    }
                }
            }

            HusRectangleInternal {
                id: __bg
                width: __text.implicitWidth + 14
                height: __text.implicitHeight + 12
                anchors.top: control.position == HusToolTip.Position_Top ? parent.top : undefined
                anchors.bottom: control.position == HusToolTip.Position_Bottom ? parent.bottom : undefined
                anchors.left: control.position == HusToolTip.Position_Left ? parent.left : undefined
                anchors.right: control.position == HusToolTip.Position_Right ? parent.right : undefined
                anchors.margins: 1
                radius: control.radiusBg.all
                topLeftRadius: control.radiusBg.topLeft
                topRightRadius: control.radiusBg.topRight
                bottomLeftRadius: control.radiusBg.bottomLeft
                bottomRightRadius: control.radiusBg.bottomRight
                color: control.colorBg

                HusText {
                    id: __text
                    text: control.text
                    font: control.font
                    color: control.colorText
                    wrapMode: Text.Wrap
                    anchors.centerIn: parent
                }
            }
        }
    }
    background: Item { }

    QtObject {
        id: __private
        property bool isHorizontal: control.position == HusToolTip.Position_Top || control.position == HusToolTip.Position_Bottom
        property size arrowSize: control.showArrow ? (isHorizontal ? Qt.size(12, 6) : Qt.size(6, 12)) : Qt.size(0, 0)
        property real controlParentWidth: control.parent ? control.parent.width : 0
        property real controlParentHeight: control.parent ? control.parent.height : 0
    }
}

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

MouseArea {
    id: root

    property var target: undefined
    property real minimumX: -Number.MAX_VALUE
    property real maximumX: Number.MAX_VALUE
    property real minimumY: -Number.MAX_VALUE
    property real maximumY: Number.MAX_VALUE

    objectName: '__HusMoveMouseArea__'
    onClicked: (mouse) => mouse.accepted = false;
    onPressed:
        (mouse) => {
            __private.startPos = Qt.point(mouse.x, mouse.y);
            cursorShape = Qt.SizeAllCursor;
        }
    onReleased:
        (mouse) => {
            __private.startPos = Qt.point(mouse.x, mouse.y);
            cursorShape = Qt.ArrowCursor;
        }
    onPositionChanged:
        (mouse) => {
            if (pressed) {
                __private.offsetPos = Qt.point(mouse.x - __private.startPos.x, mouse.y - __private.startPos.y);
                if (target) {
                    // x
                    if (minimumX != Number.NaN && minimumX > (target.x + __private.offsetPos.x)) {
                        target.x = minimumX;
                    } else if (maximumX != Number.NaN && maximumX < (target.x + __private.offsetPos.x)) {
                        target.x = maximumX;
                    } else {
                        target.x = target.x + __private.offsetPos.x;
                    }
                    // y
                    if (minimumY != Number.NaN && minimumY > (target.y + __private.offsetPos.y)) {
                        target.y = minimumY;
                    } else if (maximumY != Number.NaN && maximumY < (target.y + __private.offsetPos.y)) {
                        target.y = maximumY;
                    } else {
                        target.y = target.y + __private.offsetPos.y;
                    }
                }
            }
        }

    QtObject {
        id: __private
        property point startPos: Qt.point(0, 0)
        property point offsetPos: Qt.point(0, 0)
    }
}

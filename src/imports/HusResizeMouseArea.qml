import QtQuick

/*
             ↑     ↑     ↑
           ←|1|   |2|   |3|→
           ←|4|   |5|   |6|→
           ←|7|   |8|   |9|→
             ↓     ↓     ↓
             分8个缩放区域
      |5|为移动区域{MoveMouseArea}
    target               缩放目标
    __private.startPos   鼠标起始点
    __private.fixedPos   用于固定目标的点
    每一个area            大小 areaMarginSize x areaMarginSize
*/

Item {
    id: control

    property var target: undefined
    property bool preventStealing: false
    property int areaMarginSize: 8
    property bool resizable: true
    property real minimumWidth: 0
    property real maximumWidth: Number.MAX_VALUE
    property real minimumHeight: 0
    property real maximumHeight: Number.MAX_VALUE
    property alias movable: area5.enabled
    property alias minimumX: area5.minimumX
    property alias maximumX: area5.maximumX
    property alias minimumY: area5.minimumY
    property alias maximumY: area5.maximumY

    objectName: '__HusResizeMouseArea__'

    QtObject {
        id: __private
        property point startPos: Qt.point(0, 0)
        property point fixedPos: Qt.point(0, 0)
    }

    MouseArea {
        id: area1
        x: -areaMarginSize * 0.5
        y: -areaMarginSize * 0.5
        width: areaMarginSize
        height: areaMarginSize
        enabled: resizable
        hoverEnabled: true
        preventStealing: control.preventStealing
        onEntered: cursorShape = Qt.SizeFDiagCursor;
        onExited: cursorShape = Qt.ArrowCursor;
        onPressed: (mouse) => __private.startPos = Qt.point(mouseX, mouseY);
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    let offsetX = mouse.x - __private.startPos.x;
                    let offsetY = mouse.y - __private.startPos.y;
                    //如果本次调整小于最小限制，则调整为最小，大于最大则调整为最大
                    if (maximumWidth != Number.NaN && (target.width - offsetX) > maximumWidth) {
                        target.x += (target.width - maximumWidth);
                        target.width = maximumWidth;
                    } else if ((target.width - offsetX) < minimumWidth) {
                        target.x += (target.width - minimumWidth);
                        target.width = minimumWidth;
                    } else {
                        target.x += offsetX;
                        target.width -= offsetX;
                    }

                    if (maximumHeight != Number.NaN && (target.height - offsetY) > maximumHeight) {
                        target.y += (target.height - maximumHeight);
                        target.height = maximumHeight;
                    } else if ((target.height - offsetY) < minimumHeight) {
                        target.y += (target.height - minimumHeight);
                        target.height = minimumHeight;
                    } else {
                        target.y += offsetY;
                        target.height -= offsetY;
                    }
                }
            }
    }

    MouseArea {
        id: area2
        x: areaMarginSize * 0.5
        y: -areaMarginSize * 0.5
        width: target.width - areaMarginSize
        height: areaMarginSize
        enabled: resizable
        hoverEnabled: true
        preventStealing: control.preventStealing
        onEntered: cursorShape = Qt.SizeVerCursor;
        onExited: cursorShape = Qt.ArrowCursor;
        onPressed: (mouse) => __private.startPos = Qt.point(mouseX, mouseY);
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    let offsetY = mouse.y - __private.startPos.y;
                    if (maximumHeight != Number.NaN && (target.height - offsetY) > maximumHeight) {
                        target.y += (target.height - maximumHeight);
                        target.height = maximumHeight;
                    } else if ((target.height - offsetY) < minimumHeight) {
                        target.y += (target.height - minimumHeight);
                        target.height = minimumHeight;
                    } else {
                        target.y += offsetY;
                        target.height -= offsetY;
                    }
                }
            }
    }

    MouseArea {
        id: area3
        x: target.width - areaMarginSize * 0.5
        y: -areaMarginSize * 0.5
        width: areaMarginSize
        height: areaMarginSize
        enabled: resizable
        hoverEnabled: true
        preventStealing: control.preventStealing
        onEntered: cursorShape = Qt.SizeBDiagCursor;
        onExited: cursorShape = Qt.ArrowCursor;
        onPressed:
            (mouse) => {
                if (control.target) {
                    __private.startPos = Qt.point(mouseX, mouseY);
                    __private.fixedPos = Qt.point(target.x, target.y);
                }
            }
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    let offsetX = mouse.x - __private.startPos.x;
                    let offsetY = mouse.y - __private.startPos.y;
                    target.x = __private.fixedPos.x;
                    if (maximumWidth != Number.NaN && (target.width + offsetX) > maximumWidth) {
                        target.width = maximumWidth;
                    } else if ((target.width + offsetX) < minimumWidth) {
                        target.width = minimumWidth;
                    } else {
                        target.width += offsetX;
                    }

                    if (maximumHeight != Number.NaN && (target.height - offsetY) > maximumHeight) {
                        target.y += (target.height - maximumHeight);
                        target.height = maximumHeight;
                    } else if ((target.height - offsetY) < minimumHeight) {
                        target.y += (target.height - minimumHeight);
                        target.height = minimumHeight;
                    } else {
                        target.y += offsetY;
                        target.height -= offsetY;
                    }
                }
            }
    }

    MouseArea {
        id: area4
        x: -areaMarginSize * 0.5
        y: areaMarginSize * 0.5
        width: areaMarginSize
        height: target.height - areaMarginSize
        enabled: resizable
        hoverEnabled: true
        preventStealing: control.preventStealing
        onEntered: cursorShape = Qt.SizeHorCursor;
        onExited: cursorShape = Qt.ArrowCursor;
        onPressed:
            (mouse) => {
                __private.startPos = Qt.point(mouseX, mouseY);
            }
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    let offsetX = mouse.x - __private.startPos.x;
                    if (maximumWidth != Number.NaN && (target.width - offsetX) > maximumWidth) {
                        target.x += (target.width - maximumWidth);
                        target.width = maximumWidth;
                    } else if ((target.width - offsetX) < minimumWidth) {
                        target.x += (target.width - minimumWidth);
                        target.width = minimumWidth;
                    } else {
                        target.x += offsetX;
                        target.width -= offsetX;
                    }
                }
            }
    }

    HusMoveMouseArea {
        id: area5
        x: areaMarginSize * 0.5
        y: areaMarginSize * 0.5
        width: control.target.width - areaMarginSize
        height: control.target.height - areaMarginSize
        enabled: false
        target: control.target
        preventStealing: control.preventStealing
    }

    MouseArea {
        id: area6
        x: target.width - areaMarginSize * 0.5
        y: areaMarginSize * 0.5
        width: areaMarginSize
        height: target.height - areaMarginSize
        enabled: resizable
        hoverEnabled: true
        preventStealing: control.preventStealing
        property real fixedX: 0
        onEntered: cursorShape = Qt.SizeHorCursor;
        onExited: cursorShape = Qt.ArrowCursor;
        onPressed:
            (mouse) => {
                if (target) {
                    __private.startPos = Qt.point(mouseX, mouseY);
                    __private.fixedPos = Qt.point(target.x, target.y);
                }
            }
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    let offsetX = mouse.x - __private.startPos.x;
                    target.x = __private.fixedPos.x;
                    if (maximumWidth != Number.NaN && (target.width + offsetX) > maximumWidth) {
                        target.width = maximumWidth;
                    } else if ((target.width + offsetX) < minimumWidth) {
                        target.width = minimumWidth;
                    } else {
                        target.width += offsetX;
                    }
                }
            }
    }

    MouseArea {
        id: area7
        x: -areaMarginSize * 0.5
        y: target.height - areaMarginSize * 0.5
        width: areaMarginSize
        height: areaMarginSize
        enabled: resizable
        hoverEnabled: true
        preventStealing: control.preventStealing
        property real fixedX: 0
        onEntered: cursorShape = Qt.SizeBDiagCursor;
        onExited: cursorShape = Qt.ArrowCursor;
        onPressed:
            (mouse) => {
                if (target) {
                    __private.startPos = Qt.point(mouseX, mouseY);
                    __private.fixedPos = Qt.point(target.x, target.y);
                }
            }
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    let offsetX = mouse.x - __private.startPos.x;
                    let offsetY = mouse.y - __private.startPos.y;
                    if (maximumWidth != Number.NaN && (target.width - offsetX) > maximumWidth) {
                        target.x += (target.width - maximumWidth);
                        target.width = maximumWidth;
                    } else if ((target.width - offsetX) < minimumWidth) {
                        target.x += (target.width - minimumWidth);
                        target.width = minimumWidth;
                    } else {
                        target.x += offsetX;
                        target.width -= offsetX;
                    }

                    target.y = __private.fixedPos.y;
                    if (maximumHeight != Number.NaN && (target.height + offsetY) > maximumHeight) {
                        target.height = maximumHeight;
                    } else if ((target.height + offsetY) < minimumHeight) {
                        target.height = minimumHeight;
                    } else {
                        target.height += offsetY;
                    }
                }
            }
    }

    MouseArea {
        id: area8
        x: areaMarginSize * 0.5
        y: target.height - areaMarginSize * 0.5
        width: target.height - areaMarginSize
        height: areaMarginSize
        enabled: resizable
        hoverEnabled: true
        preventStealing: control.preventStealing
        property real fixedX: 0
        onEntered: cursorShape = Qt.SizeVerCursor;
        onExited: cursorShape = Qt.ArrowCursor;
        onPressed:
            (mouse) => {
                if (target) {
                    __private.startPos = Qt.point(mouseX, mouseY);
                    __private.fixedPos = Qt.point(target.x, target.y);
                }
            }
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    let offsetY = mouse.y - __private.startPos.y;
                    target.y = __private.fixedPos.y;
                    if (maximumHeight != Number.NaN && (target.height + offsetY) > maximumHeight) {
                        target.height = maximumHeight;
                    } else if ((target.height + offsetY) < minimumHeight) {
                        target.height = minimumHeight;
                    } else {
                        target.height += offsetY;
                    }
                }
            }
    }

    MouseArea {
        id: area9
        x: target.width - areaMarginSize * 0.5
        y: target.height - areaMarginSize * 0.5
        width: areaMarginSize
        height: areaMarginSize
        enabled: resizable
        hoverEnabled: true
        preventStealing: control.preventStealing
        onEntered: cursorShape = Qt.SizeFDiagCursor;
        onExited: cursorShape = Qt.ArrowCursor;
        onPressed:
            (mouse) => {
                if (target) {
                    __private.startPos = Qt.point(mouseX, mouseY);
                    __private.fixedPos = Qt.point(target.x, target.y);
                }
            }
        onPositionChanged:
            (mouse) => {
                if (pressed && target) {
                    let offsetX = mouse.x - __private.startPos.x;
                    let offsetY = mouse.y - __private.startPos.y;
                    target.x = __private.fixedPos.x;
                    if (maximumWidth != Number.NaN && (target.width + offsetX) > maximumWidth) {
                        target.width = maximumWidth;
                    } else if ((target.width + offsetX) < minimumWidth) {
                        target.width = minimumWidth;
                    } else {
                        target.width += offsetX;
                    }

                    target.y = __private.fixedPos.y;
                    if (maximumHeight != Number.NaN && (target.height + offsetY) > maximumHeight) {
                        target.height = maximumHeight;
                    } else if ((target.height + offsetY) < minimumHeight) {
                        target.height = minimumHeight;
                    } else {
                        target.height += offsetY;
                    }
                }
            }
    }
}

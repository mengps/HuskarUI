import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.Popup {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool penetrationEvent: false
    property bool maskClosable: true
    property Item target: null
    property color colorOverlay: HusTheme.HusTour.colorOverlay
    property int focusMargin: 5
    property int focusRadius: 2

    function close() {
        if (!visible || __private.isClosing) return;
        if (animationEnabled) {
            __private.startClosing();
        } else {
            visible = false;
        }
    }

    focus: true
    modal: !penetrationEvent
    dim: true
    objectName: '__HusTourFocus__'
    closePolicy: maskClosable ? T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside : T.Popup.NoAutoClose
    onFocusMarginChanged: {
        __private.recalcPosition();
    }
    onFocusRadiusChanged: {
        __private.repaint();
    }
    onAboutToShow: {
        __private.recalcPosition();
    }
    onAboutToHide: {
        if (animationEnabled && !__private.isClosing && opacity > 0) {
            visible = true;
            __private.startClosing();
        }
    }
    enter: Transition {
        NumberAnimation {
            property: 'opacity';
            from: 0.0
            to: 1.0
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    exit: null
    parent: T.Overlay.overlay
    background: Item { }
    T.Overlay.modal: Item {
        id: __overlayItem
        onWidthChanged: __private.recalcPosition();
        onHeightChanged: __private.recalcPosition();

        Canvas {
            id: __canvas
            anchors.fill: parent
            opacity: control.opacity
            onPaint: {
                const ctx = getContext('2d');
                ctx.clearRect(0, 0, width, height);

                ctx.save();
                ctx.fillStyle = control.colorOverlay;
                ctx.fillRect(0, 0, width, height);

                ctx.globalCompositeOperation = 'destination-out';
                ctx.fillStyle = '#fff';

                const rect = Qt.rect(__private.focusX, __private.focusY, __private.focusWidth, __private.focusHeight);
                ctx.beginPath();
                ctx.moveTo(rect.x + control.focusRadius, rect.y);
                ctx.lineTo(rect.x + rect.width - control.focusRadius, rect.y);
                ctx.arcTo(rect.x + rect.width, rect.y, rect.x + rect.width, rect.y + control.focusRadius, control.focusRadius);
                ctx.lineTo(rect.x + rect.width, rect.y + rect.height - control.focusRadius);
                ctx.arcTo(rect.x + rect.width, rect.y + rect.height, rect.x + rect.width - control.focusRadius, rect.y + rect.height, control.focusRadius);
                ctx.lineTo(rect.x + control.focusRadius, rect.y + rect.height);
                ctx.arcTo(rect.x, rect.y + rect.height, rect.x, rect.y + rect.height - control.focusRadius, control.focusRadius);
                ctx.lineTo(rect.x, rect.y + control.focusRadius);
                ctx.arcTo(rect.x, rect.y, rect.x + control.focusRadius, rect.y, control.focusRadius);
                ctx.closePath();
                ctx.fill();

                ctx.restore();
            }
        }

        Connections {
            target: __private
            function onRepaint() {
                __canvas.requestPaint();
            }
        }

        Item {
            id: __eventArea
            x: __private.focusX
            y: __private.focusY
            width: __private.focusWidth
            height: __private.focusHeight
            visible: false
        }

        /*! 禁止 target 外的滚动 */
        WheelHandler {
            onWheel:
                event => {
                    if (!__eventArea.contains(Qt.point(event.x, event.y))) {
                        event.accepted = true;
                    }
                }
        }
    }
    T.Overlay.modeless: T.Overlay.modal

    NumberAnimation {
        running: __private.isClosing
        target: control
        property: 'opacity'
        from: 1.0
        to: 0.0
        duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        easing.type: Easing.InQuad
        onFinished: {
            __private.isClosing = false;
            control.visible = false;
        }
    }

    QtObject {
        id: __private

        signal repaint()

        property real focusX: 0
        property real focusY: 0
        property real focusWidth: control.target ? (control.target.width + control.focusMargin * 2) : 0
        property real focusHeight: control.target ? (control.target.height + control.focusMargin * 2) : 0
        property bool isClosing: false

        onFocusXChanged: repaint();
        onFocusYChanged: repaint();
        onFocusWidthChanged: repaint();
        onFocusHeightChanged: repaint();

        function recalcPosition() {
            if (!control.target) return;
            const pos = control.target.mapToItem(null, 0, 0);
            focusX = pos.x - control.focusMargin;
            focusY = pos.y - control.focusMargin;
            __private.repaint();
        }

        function startClosing() {
            if (isClosing) return;
            isClosing = true;
        }
    }
}

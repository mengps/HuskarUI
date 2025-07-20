import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.Popup {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property Item target: null
    property color colorOverlay: HusTheme.HusTour.colorOverlay
    property real focusMargin: 5

    objectName: '__HusTourFocus__'
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside
    onAboutToShow: {
        __private.recalcPosition();
        opacity = 1.0;
    }
    onAboutToHide: {
        if (control.animationEnabled && !__private.isClosing && opacity > 0) {
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
    T.Overlay.modal: Item {
        id: modalOverlay
        onWidthChanged: __private.recalcPosition();
        onHeightChanged: __private.recalcPosition();

        Rectangle {
            id: source
            color: control.colorOverlay
            anchors.fill: parent
            opacity: control.opacity
            layer.enabled: true
            layer.effect: ShaderEffect {
                property real xMin: __private.focusX / source.width
                property real xMax: (__private.focusX + __private.focusWidth) / source.width
                property real yMin: __private.focusY / source.height
                property real yMax: (__private.focusY + __private.focusHeight) / source.height
                fragmentShader: 'qrc:/HuskarUI/shaders/hustour.frag.qsb'
            }
        }
    }
    parent: T.Overlay.overlay
    modal: true
    background: Item { }

    function close() {
        if (!visible || __private.isClosing) return;
        if (control.animationEnabled) {
            __private.startClosing();
        } else {
            control.visible = false;
        }
    }

    NumberAnimation {
        id: __closeAnimation
        target: control
        property: 'opacity'
        from: 1.0
        to: 0.0
        duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        easing.type: Easing.InOutQuad
        onFinished: {
            __private.isClosing = false;
            control.visible = false;
        }
    }

    QtObject {
        id: __private
        property real focusX: 0
        property real focusY: 0
        property real focusWidth: control.target ? (control.target.width + control.focusMargin * 2) : 0
        property real focusHeight: control.target ? (control.target.height + control.focusMargin * 2) : 0
        property bool isClosing: false

        function recalcPosition() {
            if (!control.target) return;
            const pos = control.target.mapToItem(null, 0, 0);
            focusX = pos.x - control.focusMargin;
            focusY = pos.y - control.focusMargin;
        }

        function startClosing() {
            if (isClosing) return;
            isClosing = true;
            __closeAnimation.restart();
        }
    }
}

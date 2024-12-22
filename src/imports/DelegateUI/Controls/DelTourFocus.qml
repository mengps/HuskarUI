import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Popup {
    id: control

    property Item target: null
    property color colorOverlay: DelTheme.DelTour.colorOverlay
    property real focusMargin: 5

    onAboutToShow: __private.recalcPosition();

    QtObject {
        id: __private
        property real focusX: 0
        property real focusY: 0
        property real focusWidth: control.target ? (control.target.width + control.focusMargin * 2) : 0
        property real focusHeight: control.target ? (control.target.height + control.focusMargin * 2) : 0
        function recalcPosition() {
            if (!control.target) return;
            const pos = control.target.mapToItem(null, 0, 0);
            focusX = pos.x - control.focusMargin;
            focusY = pos.y - control.focusMargin;
        }
    }

    T.Overlay.modal: Item {
        onWidthChanged: __private.recalcPosition();
        onHeightChanged: __private.recalcPosition();

        Rectangle {
            id: source
            color: control.colorOverlay
            anchors.fill: parent
            layer.enabled: true
            layer.effect: ShaderEffect {
                property real xMin: __private.focusX / source.width
                property real xMax: (__private.focusX + __private.focusWidth) / source.width
                property real yMin: __private.focusY / source.height
                property real yMax: (__private.focusY + __private.focusHeight) / source.height
                fragmentShader: "qrc:/DelegateUI/shaders/deltour.frag.qsb"
            }
        }
    }
    parent: T.Overlay.overlay
    modal: true
    background: Item { }
}

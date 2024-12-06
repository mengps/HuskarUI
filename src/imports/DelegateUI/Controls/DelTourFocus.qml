import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Popup {
    id: root

    property Item currentTarget: null
    property color overlayColor: DelTheme.DelTour.colorOverlay
    property real focusMargin: 5
    property real focusWidth: currentTarget ? (currentTarget.width + focusMargin * 2) : 0
    property real focusHeight: currentTarget ? (currentTarget.height + focusMargin * 2) : 0

    onAboutToShow: __private.recalcPosition();

    QtObject {
        id: __private
        property real focusX: 0
        property real focusY: 0
        function recalcPosition() {
            if (!root.currentTarget) return;
            const pos = root.currentTarget.mapToItem(null, 0, 0);
            focusX = pos.x - root.focusMargin;
            focusY = pos.y - root.focusMargin;
        }
    }

    T.Overlay.modal: Item {
        onWidthChanged: __private.recalcPosition();
        onHeightChanged: __private.recalcPosition();

        Rectangle {
            id: source
            color: overlayColor
            anchors.fill: parent
            layer.enabled: true
            layer.effect: ShaderEffect {
                property real xMin: __private.focusX / source.width
                property real xMax: (__private.focusX + focusWidth) / source.width
                property real yMin: __private.focusY / source.height
                property real yMax: (__private.focusY + focusHeight) / source.height
                fragmentShader: "qrc:/DelegateUI/shaders/deltour.frag.qsb"
            }
        }
    }
    parent: T.Overlay.overlay
    modal: true
    background: Item { }
}

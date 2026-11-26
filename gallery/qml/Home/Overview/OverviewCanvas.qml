pragma ComponentBehavior: Bound

import QtQuick
import HuskarUI.Basic

Item {
    id: root

    default property alias sceneContent: scene.data
    property real zoom: 0.76
    readonly property real minZoom: 0.25
    readonly property real maxZoom: 4
    property bool sceneEnabled: true
    property real backgroundOpacity: 1

    readonly property int __cameraMargin: 1600
    readonly property int __fitPadding: 144
    readonly property int __fitReferenceHeight: 980
    readonly property real __gridSpacing: Math.max(12, 24 * zoom)
    readonly property point __gridOrigin: Qt.point(scene.x - viewport.contentX, scene.y - viewport.contentY)

    clip: true

    function fit() {
        const widthZoom = (width - __fitPadding) / Math.max(1, scene.width);
        const heightZoom = (height - __fitPadding) / __fitReferenceHeight;
        const worldY = (viewport.contentY - scene.y) / zoom;
        zoom = HusApi.clamp(Math.min(widthZoom, heightZoom), minZoom, 1);
        __moveTo((viewport.contentWidth - width) * 0.5, scene.y + worldY * zoom);
    }

    function zoomTo(nextZoom) {
        __zoomAt(nextZoom, width * 0.5, height * 0.5);
    }

    function __zoomAt(nextZoom, x, y) {
        nextZoom = HusApi.clamp(nextZoom, minZoom, maxZoom);
        if (nextZoom === zoom)
            return;
        const worldX = (viewport.contentX + x - scene.x) / zoom;
        const worldY = (viewport.contentY + y - scene.y) / zoom;
        zoom = nextZoom;
        __moveTo(scene.x + worldX * zoom - x, scene.y + worldY * zoom - y);
    }

    function __moveTo(x, y) {
        viewport.contentX = HusApi.clamp(x, 0, Math.max(0, viewport.contentWidth - viewport.width));
        viewport.contentY = HusApi.clamp(y, 0, Math.max(0, viewport.contentHeight - viewport.height));
    }

    component GridLines: Repeater {
        id: lines
        required property color lineColor
        required property bool vertical
        required property real step
        required property real offset
        readonly property real startOffset: (offset % step + step) % step

        model: Math.ceil((vertical ? root.width : root.height) / step) + 1

        Rectangle {
            required property int index
            readonly property real position: Math.round(lines.startOffset + index * lines.step)
            x: lines.vertical ? position : 0
            y: lines.vertical ? 0 : position
            width: lines.vertical ? 1 : root.width
            height: lines.vertical ? root.height : 1
            color: lines.lineColor
        }
    }

    component GridLayer: Item {
        id: layer
        required property color lineColor
        required property real step

        GridLines {
            lineColor: layer.lineColor
            vertical: true
            step: layer.step
            offset: root.__gridOrigin.x
        }

        GridLines {
            lineColor: layer.lineColor
            vertical: false
            step: layer.step
            offset: root.__gridOrigin.y
        }
    }

    Rectangle {
        anchors.fill: parent
        color: HusThemeFunctions.alpha(HusTheme.isDark ? '#121212' : '#f7f8fa', root.backgroundOpacity)

        GridLayer {
            step: root.__gridSpacing
            lineColor: HusTheme.isDark ? '#0dffffff' : '#0d000000'
        }

        GridLayer {
            step: root.__gridSpacing * 5
            lineColor: HusTheme.isDark ? '#1affffff' : '#1a000000'
        }
    }

    Flickable {
        id: viewport
        anchors.fill: parent
        interactive: false
        boundsBehavior: Flickable.StopAtBounds
        contentY: scene.y
        contentWidth: scene.width * root.zoom + scene.x * 2
        contentHeight: scene.height * root.zoom + scene.y * 2
        HusScrollBar.vertical: verticalBar
        HusScrollBar.horizontal: horizontalBar

        Item {
            id: scene
            x: root.__cameraMargin * root.zoom
            y: root.__cameraMargin * root.zoom
            width: childrenRect.width
            height: childrenRect.height
            scale: root.zoom
            transformOrigin: Item.TopLeft
            enabled: root.sceneEnabled
        }

        HoverHandler {
            parent: viewport
            cursorShape: Qt.ClosedHandCursor
        }

        WheelHandler {
            id: wheelHandler
            parent: viewport
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            acceptedModifiers: Qt.ControlModifier
            onWheel: function (event) {
                const factor = event.angleDelta.y > 0 ? 1.1 : 1 / 1.1;
                const anchor = root.mapFromItem(null, wheelHandler.point.scenePosition);
                root.__zoomAt(root.zoom * factor, anchor.x, anchor.y);
                event.accepted = true;
            }
        }

        DragHandler {
            parent: viewport
            target: null
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            grabPermissions: PointerHandler.CanTakeOverFromItems

            property point __start

            onActiveChanged: {
                if (active)
                    __start = Qt.point(viewport.contentX, viewport.contentY);
            }
            onTranslationChanged: {
                if (active)
                    root.__moveTo(__start.x - activeTranslation.x, __start.y - activeTranslation.y);
            }
        }
    }

    HusScrollBar {
        id: verticalBar
        anchors.top: root.top
        anchors.bottom: root.bottom
        anchors.right: root.right
    }

    HusScrollBar {
        id: horizontalBar
        anchors.left: root.left
        anchors.right: verticalBar.left
        anchors.bottom: root.bottom
    }
}

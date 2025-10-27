import QtQuick
import QtQuick.Effects
import HuskarUI.Basic

Item {
    id: control

    property alias sourceItem: __source.sourceItem
    property alias sourceRect: __source.sourceRect
    property alias opacityNoise: __noiseImage.opacity
    property alias radiusBlur: __fastBlur.radius
    property color colorTint: '#fff'
    property HusRadius radiusBg: HusRadius { all: 0 }
    property real opacityTint: 0.65
    property real luminosity: 0.01

    objectName: '__HusAcrylic__'

    ShaderEffectSource {
        id: __source
        anchors.fill: parent
        visible: false
        sourceRect: Qt.rect(control.x, control.y, control.width, control.height)
    }

    MultiEffect {
        id: __fastBlur
        anchors.fill: parent
        source: __source
        blurEnabled: true
        blur: 1.0
        blurMax: 32
        property alias radius: __fastBlur.blurMax
    }

    HusRectangleInternal {
        anchors.fill: parent
        color: HusThemeFunctions.alpha('#fff', control.luminosity)
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    HusRectangleInternal {
        anchors.fill: parent
        color: HusThemeFunctions.alpha(control.colorTint, control.opacityTint)
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    Image {
        id: __noiseImage
        anchors.fill: parent
        source: 'data:image/png;base64,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'
        fillMode: Image.Tile
        opacity: 0.02
    }
}

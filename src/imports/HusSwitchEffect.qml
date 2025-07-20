import QtQuick
import QtQuick.Effects

Item {
    id: control

    enum EffectType
    {
        Type_None,
        Type_Opacity,
        Type_Blurry,
        Type_Mask,
        Type_Blinds,
        Type_3DFlip,
        Type_Thunder
    }

    signal started();
    signal finished();

    property Item fromItem
    property Item toItem
    property var startCallback:
        () => {
            control.visible = true;
        }
    property var endCallback:
        () => {
            control.visible = false;
        }
    property int type: HusSwitchEffect.Type_None
    property int duration: 800
    readonly property real animationTime: __private.inAnimation
    property alias easing: __animation.easing

    property string maskSource: ''
    property bool maskScaleEnabled: false
    property real maskScale: 1
    property bool maskRotationEnabled: false
    property real maskRotation: 0
    property bool maskColorizationEnabled: false
    property color maskColorizationColor: 'red'
    property real maskColorization: 0

    objectName: '__HusSwitchEffect__'

    function startSwitch(from = null, to = null) {
        __switchAnimation.complete();
        if (from) {
            from.visible = false;
            fromItem = from;
        }
        if (to) {
            to.visible = false;
            toItem = to;
        }
        __switchAnimation.restart();
    }

    QtObject {
        id: __private
        property real inAnimation: 0
        readonly property real outAnimation: 1.0 - inAnimation
    }

    SequentialAnimation {
        id: __switchAnimation
        alwaysRunToEnd: true
        onStarted: {
            control.startCallback();
            control.started();
        }
        onFinished: {
            control.endCallback();
            control.finished();
        }

        NumberAnimation {
            id: __animation
            target: __private
            property: 'inAnimation'
            from: 0
            to: 1
            duration: control.duration
        }
    }

    Loader {
        active: control.type === HusSwitchEffect.Type_Opacity
        anchors.fill: parent
        sourceComponent: Item {
            MultiEffect {
                source: control.fromItem
                anchors.fill: parent
                opacity: __private.outAnimation
            }
            MultiEffect {
                source: control.toItem
                anchors.fill: parent
                opacity: __private.inAnimation
            }
        }
    }

    Loader {
        active: control.type === HusSwitchEffect.Type_Blurry
        anchors.fill: parent
        sourceComponent: Item {
            MultiEffect {
                source: control.fromItem
                anchors.fill: parent
                blurEnabled: true
                blur: __private.inAnimation * 4
                blurMax: 32
                blurMultiplier: 0.5
                opacity: __private.outAnimation
                saturation: -__private.inAnimation * 2
            }
            MultiEffect {
                source: control.toItem
                anchors.fill: parent
                blurEnabled: true
                blur: __private.outAnimation * 4
                blurMax: 32
                blurMultiplier: 0.5
                opacity: __private.inAnimation
                saturation: -__private.outAnimation * 2
            }
        }
    }

    Loader{
        active: control.type === HusSwitchEffect.Type_Mask
        anchors.fill: parent
        sourceComponent: Item {
            Item {
                id: mask
                anchors.fill: parent
                layer.enabled: true
                visible: false
                clip: true

                Image {
                    anchors.fill: parent
                    source: control.maskSource
                    scale: control.maskScaleEnabled ? control.maskScale : 1
                    rotation: control.maskRotationEnabled ? control.maskRotation : 0
                }
            }

            MultiEffect {
                source: control.fromItem
                anchors.fill: parent
                maskEnabled: true
                maskSource: mask
                maskInverted: true
                maskThresholdMin: 0.5
                maskSpreadAtMin: 0.5
            }
            MultiEffect {
                source: control.toItem
                anchors.fill: parent
                maskEnabled: true
                maskSource: mask
                maskThresholdMin: 0.5
                maskSpreadAtMin: 0.5
                colorizationColor: control.maskColorizationColor
                colorization: control.maskColorizationEnabled ? control.maskColorization : 0
            }
        }
    }

    Loader {
        active: control.type === HusSwitchEffect.Type_Blinds
        anchors.fill: parent
        sourceComponent: Item {
            Item {
                id: blindsMask
                anchors.fill: parent
                layer.enabled: true
                visible: false
                smooth: false
                clip: true
                Image {
                    anchors.fill: parent
                    anchors.margins: -parent.width * 0.25
                    source: control.maskSource || 'qrc:/HuskarUI/resources/images/hblinds.png'
                    scale: control.maskScaleEnabled ? control.maskScale : 1
                    rotation: control.maskRotationEnabled ? control.maskRotation : 0
                    smooth: false
                }
            }
            MultiEffect {
                source: control.fromItem
                anchors.fill: parent
                maskEnabled: true
                maskSource: blindsMask
                maskThresholdMin: __private.inAnimation
                maskSpreadAtMin: 0.4
            }
            MultiEffect {
                source: control.toItem
                anchors.fill: parent
                maskEnabled: true
                maskSource: blindsMask
                maskThresholdMax: __private.inAnimation
                maskSpreadAtMax: 0.4
            }
        }
    }

    Loader {
        active: control.type === HusSwitchEffect.Type_3DFlip
        anchors.fill: parent
        sourceComponent: Item {
            MultiEffect {
                x: __private.inAnimation * control.width
                width: parent.width
                height: parent.height
                source: control.fromItem
                opacity: __private.outAnimation
                saturation: -__private.inAnimation * 1.5

                maskEnabled: true
                maskSource: Image {
                    source: control.maskSource || 'qrc:/HuskarUI/resources/images/smoke.png'
                    visible: false
                }
                maskThresholdMin: __private.inAnimation * 0.6
                maskSpreadAtMin: 0.1
                maskThresholdMax: 1.0 - (__private.inAnimation * 0.6)
                maskSpreadAtMax: 0.1

                shadowEnabled: true
                shadowOpacity: 0.2
                shadowBlur: 0.8
                shadowVerticalOffset: 5
                shadowHorizontalOffset: 10 + (x * 0.2)
                shadowScale: 1.02

                transform: Rotation {
                    origin.x: parent.width / 2
                    origin.y: parent.height / 2
                    axis { x: 0; y: 1; z: 0 }
                    angle: __private.inAnimation * 60
                }
                rotation: -__private.inAnimation * 20
                scale: 1.0 + (__private.inAnimation * 0.2)
            }

            MultiEffect {
                x: -__private.outAnimation * control.width
                width: parent.width
                height: parent.height
                source: control.toItem
                opacity: __private.inAnimation
                saturation: -__private.outAnimation * 1.5

                maskEnabled: true
                maskSource: Image {
                    source: control.maskSource || 'qrc:/HuskarUI/resources/images/smoke.png'
                    visible: false
                }
                maskThresholdMin: __private.outAnimation * 0.6
                maskSpreadAtMin: 0.1
                maskThresholdMax: 1.0 - (__private.outAnimation * 0.6)
                maskSpreadAtMax: 0.1

                shadowEnabled: true
                shadowOpacity: 0.2
                shadowBlur: 0.8
                shadowVerticalOffset: 5
                shadowHorizontalOffset: 10 + (x * 0.2)
                shadowScale: 1.02

                transform: Rotation {
                    origin.x: parent.width / 2
                    origin.y: parent.height / 2
                    axis { x: 0; y: 1; z: 0 }
                    angle: -__private.outAnimation * 60
                }
                rotation: __private.outAnimation * 20
                scale: 1.0 - (__private.outAnimation * 0.4)
            }
        }
    }

    Loader {
        active: control.type === HusSwitchEffect.Type_Thunder
        anchors.fill: parent
        sourceComponent: Item {
            property real _xPos: Math.sin(__private.inAnimation * Math.PI * 50) * width * 0.03 * (0.5 - Math.abs(0.5 - __private.inAnimation))
            property real _yPos: Math.sin(__private.inAnimation * Math.PI * 35) * width * 0.02 * (0.5 - Math.abs(0.5 - __private.inAnimation))

            Image {
                id: thunderMask
                source: control.maskSource || 'qrc:/HuskarUI/resources/images/stripes.png'
                scale: control.maskScaleEnabled ? control.maskScale : 1
                rotation: control.maskRotationEnabled ? control.maskRotation : 0
                visible: false
            }

            MultiEffect {
                source: control.fromItem
                width: parent.width
                height: parent.height
                x: parent._xPos
                y: parent._yPos
                blurEnabled: true
                blur: __private.inAnimation
                blurMax: 32
                blurMultiplier: 0.5
                opacity: __private.outAnimation
                colorizationColor: '#f0d060'
                colorization: __private.inAnimation

                contrast: __private.inAnimation
                brightness: __private.inAnimation

                maskEnabled: true
                maskSource: thunderMask
                maskThresholdMin: __private.inAnimation * 0.9
                maskSpreadAtMin: 0.2
                maskThresholdMax: 1.0

                shadowEnabled: true
                shadowColor: '#f04000'
                shadowBlur: 1.0
                shadowOpacity: 5.0 - __private.outAnimation * 5.0
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 0
                shadowScale: 1.04

            }
            MultiEffect {
                source: control.toItem
                width: parent.width
                height: parent.height
                x: -parent._xPos
                y: -parent._yPos
                blurEnabled: true
                blur: __private.outAnimation * 2
                blurMax: 32
                blurMultiplier: 0.5
                opacity: __private.inAnimation * 3.0 - 1.0

                colorizationColor: '#f0d060'
                colorization: __private.outAnimation
                contrast: __private.outAnimation
                brightness: __private.outAnimation

                maskEnabled: true
                maskSource: thunderMask
                maskThresholdMin: __private.outAnimation * 0.6
                maskSpreadAtMin: 0.2
                maskThresholdMax: 1.0

                shadowEnabled: true
                shadowColor: '#f04000'
                shadowBlur: 1.0
                shadowOpacity: 5.0 - __private.inAnimation * 5.0
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 0
                shadowScale: 1.04
            }
        }
    }
}

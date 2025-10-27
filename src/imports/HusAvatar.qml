import QtQuick
import QtQuick.Effects
import HuskarUI.Basic

Item {
    id: control

    enum TextSiz {
        Size_Fixed = 0,
        Size_Auto = 1
    }

    property int size: 30
    property var iconSource: 0 ?? ''

    property string imageSource: ''
    property bool imageMipmap: false

    property string textSource: ''
    property font textFont: Qt.font({
                                        family: HusTheme.Primary.fontPrimaryFamily,
                                        pixelSize: control.size * 0.5
                                    })
    property int textSize: HusAvatar.Size_Fixed
    property int textGap: 4

    property color colorBg: HusTheme.Primary.colorTextQuaternary
    property color colorIcon: 'white'
    property color colorText: 'white'
    property HusRadius radiusBg: HusRadius { all: control.width * 0.5 }

    objectName: '__HusAvatar__'
    width: __loader.width
    height: __loader.height

    Component {
        id: __iconImpl

        HusRectangleInternal {
            width: control.size
            height: control.size
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg

            HusIconText {
                id: __iconSource
                anchors.centerIn: parent
                iconSource: control.iconSource
                iconSize: control.size * 0.7
                colorIcon: control.colorIcon
            }
        }
    }

    Component {
        id: __imageImpl

        HusRectangleInternal {
            width: control.size
            height: control.size
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg

            HusRectangleInternal {
                id: __mask
                anchors.fill: parent
                radius: parent.radius
                topLeftRadius: parent.topLeft
                topRightRadius: parent.topRightRadius
                bottomLeftRadius: parent.bottomLeftRadius
                bottomRightRadius: parent.bottomRightRadius
                layer.enabled: true
                visible: false
            }

            Image {
                id: __imageSource
                anchors.fill: parent
                mipmap: control.imageMipmap
                source: control.imageSource
                sourceSize: Qt.size(width, height)
                layer.enabled: true
                visible: false
            }

            MultiEffect {
                anchors.fill: __imageSource
                maskEnabled: true
                maskSource: __mask
                source: __imageSource
            }
        }
    }

    Component {
        id: __textImpl

        HusRectangleInternal {
            id: __bg
            width: Math.max(control.size, __textSource.implicitWidth + control.textGap * 2);
            height: width
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg
            Component.onCompleted: calcBestSize();

            function calcBestSize() {
                if (control.textSize == HusAvatar.Size_Fixed) {
                    __textSource.font.pixelSize = control.size * 0.5;
                } else {
                    let bestSize = control.size * 0.5;
                    __fontMetrics.font.pixelSize = bestSize;
                    while ((__fontMetrics.advanceWidth(control.textSource) + control.textGap * 2 > control.size)) {
                        bestSize -= 1;
                        __fontMetrics.font.pixelSize = bestSize;
                        if (bestSize <= 1) break;
                    }
                    __textSource.font.pixelSize = bestSize;
                }
            }

            FontMetrics {
                id: __fontMetrics
                font.family: __textSource.font.family
            }

            HusText {
                id: __textSource
                anchors.centerIn: parent
                color: control.colorText
                text: control.textSource
                smooth: true
                font: control.textFont

                Connections {
                    target: control
                    function onTextSourceChanged() {
                        __bg.calcBestSize();
                    }
                }
            }
        }
    }

    Loader {
        id: __loader
        sourceComponent: {
            if (control.iconSource !== 0 && control.iconSource !== '')
                return __iconImpl;
            else if (control.imageSource != '')
                return __imageImpl;
            else
                return __textImpl;
        }
    }
}

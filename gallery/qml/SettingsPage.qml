import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Basic
import DelegateUI

DelWindow {
    id: root
    width: 400
    height: 500
    visible: false
    captionBar.minimizeButtonVisible: false
    captionBar.maximizeButtonVisible: false
    captionBar.winTitle: qsTr("关于")
    captionBar.winIconDelegate: Item {
        DelIconText {
            iconSize: 22
            colorIcon: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath1
        }
        DelIconText {
            iconSize: 22
            colorIcon: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath2
        }
    }
    captionBar.closeCallback: () => root.close();

    component MySlider: RowLayout {
        height: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 30
        spacing: 20

        property alias label: __label
        property alias slider: __slider
        property bool scaleVisible: false

        Text {
            id: __label
            Layout.preferredWidth: DelTheme.Primary.fontPrimarySize * 5
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySize
            }
            color: DelTheme.Primary.colorTextBase
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Row {
                anchors.top: parent.top
                anchors.topMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                visible: scaleVisible
                spacing: (parent.width - 14 - ((__repeater.count - 1) * 4)) / (__repeater.count - 1)

                Repeater {
                    id: __repeater
                    model: Math.round((__slider.max - __slider.min) / __slider.stepSize) + 1
                    delegate: Rectangle {
                        width: 4
                        height: 6
                        radius: 2
                        color: __slider.colorBg

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.bottom
                            anchors.topMargin: 8
                            text: (__slider.stepSize) * index + __slider.min
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }
                    }
                }
            }

            DelSlider {
                id: __slider
                anchors.fill: parent
                min: 0.0
                max: 1.0
                stepSize: 0.1
            }
        }
    }

    Item {
        anchors.fill: parent

        MultiEffect {
            anchors.fill: backRect
            source: backRect
            shadowColor: DelTheme.Primary.colorTextBase
            shadowEnabled: true
        }

        Rectangle {
            id: backRect
            anchors.fill: parent
            radius: 6
            color: DelTheme.Primary.colorBgBase
            border.color: DelThemeFunctions.alpha(DelTheme.Primary.colorTextBase, 0.2)
        }

        Rectangle {
            anchors.fill: parent
            color: DelThemeFunctions.alpha(DelTheme.Primary.colorBgBase, 0.5)

            ShaderEffect {
                anchors.fill: parent
                vertexShader: "qrc:/Gallery/shaders/effect2.vert.qsb"
                fragmentShader: "qrc:/Gallery/shaders/effect2.frag.qsb"
                opacity: 0.7

                property vector3d iResolution: Qt.vector3d(width, height, 0)
                property real iTime: 0

                Timer {
                    running: true
                    repeat: true
                    interval: 10
                    onTriggered: parent.iTime += 0.01;
                }
            }
        }

        Column {
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: captionBar.height
            spacing: 20

            MySlider {
                id: bgOpacitySlider
                label.text: qsTr("背景透明度")
                slider.snapMode: DelSliderType.SnapOnRelease
                slider.onCurrentValueChanged: {
                    galleryBackground.opacity = slider.currentValue;
                }
                slider.handleToolTipDelegate: DelToolTip {
                    delay: 100
                    text: bgOpacitySlider.slider.currentValue.toFixed(1)
                    visible: handlePressed || handleHovered
                }
            }

            MySlider {
                label.text: qsTr("字体大小")
                slider.min: 12
                slider.max: 24
                slider.stepSize: 4
                slider.value: 16
                slider.snapMode: DelSliderType.SnapAlways
                slider.onFirstReleased: {
                    DelTheme.installThemePrimaryFontSize(slider.currentValue);
                }
                scaleVisible: true
            }
        }
    }
}

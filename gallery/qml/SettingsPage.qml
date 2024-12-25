import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import DelegateUI

Popup {
    id: root

    component MySlider: RowLayout {
        height: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 30
        spacing: 20

        property alias label: __label
        property alias slider: __slider

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

        DelSlider {
            id: __slider
            Layout.fillWidth: true
            Layout.fillHeight: true
            min: 0.0
            max: 1.0
            stepSize: 0.1
        }
    }

    width: 400
    height: 500
    closePolicy: Popup.NoAutoClose
    background: Rectangle {
        radius: 6
        color: DelTheme.Primary.colorBgBase
        border.color: DelThemeFunctions.alpha(DelTheme.Primary.colorTextBase, 0.2)
        clip: true

        Column {
            width: parent.width
            spacing: 20

            DelCaptionButton {
                height: 30
                isError: true
                iconSource: DelIcon.CloseOutlined
                anchors.right: parent.right
                onClicked: root.close();
            }

            MySlider {
                label.text: qsTr("背景透明度")
                slider.onCurrentValueChanged: {
                    galleryBackground.opacity = slider.currentValue;
                }
            }

            MySlider {
                label.text: qsTr("字体大小")
                slider.min: 8
                slider.max: 32
                slider.stepSize: 1
                slider.value: 16
                slider.snapMode: DelSliderType.SnapAlways
                slider.onFirstReleased: {
                    DelTheme.installThemePrimaryFontSize(slider.currentValue);
                }
            }
        }
    }
    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.0; to: 1.0; duration: DelTheme.Primary.durationMid }
    }
    exit: Transition {
        NumberAnimation { property: "scale"; from: 1.0; to: 0.0; duration: DelTheme.Primary.durationMid }
    }
}

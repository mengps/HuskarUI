import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

Popup {
    id: root
    closePolicy: Popup.NoAutoClose
    background: Rectangle {
        radius: 6
        color: DelThemeFunctions.alpha(DelTheme.Primary.colorBgBase, 0.8)
        clip: true

        Item {
            width: parent.width
            height: 30

            DelCaptionButton {
                height: parent.height
                isError: true
                iconSource: DelIcon.CloseOutlined
                anchors.right: parent.right
                onClicked: root.close();
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

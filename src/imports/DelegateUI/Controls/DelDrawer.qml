import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Templates as T
import DelegateUI

T.Drawer {
    id: control

    titleFont {
        family: DelTheme.DelDrawer.fontFamily
        pixelSize: DelTheme.DelDrawer.fontSizeTitle
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property string title: ""
    property font titleFont
    property color colorTitle: DelTheme.DelDrawer.colorTitle
    property color colorBg: DelTheme.DelDrawer.colorBg
    property color colorOverlay: DelTheme.DelDrawer.colorOverlay
    property Component titleDelegate: Item {
        Row {
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 15
            spacing: 5

            DelCaptionButton {
                id: __close
                topPadding: 2
                bottomPadding: 2
                leftPadding: 4
                rightPadding: 4
                radiusBg: 4
                anchors.verticalCenter: parent.verticalCenter
                iconSource: DelIcon.CloseOutlined
                onClicked: {
                    control.close();
                }
                Component.onCompleted: {
                    captionBar.addInteractionItem(__close);
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: control.title
                font: control.titleFont
                color: control.colorTitle
            }
        }

        DelDivider {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }
    }
    property Component contentDelegate: Item { }

    enter: Transition { NumberAnimation { duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0 } }
    exit: Transition { NumberAnimation { duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0 } }

    width: edge == Qt.LeftEdge || edge == Qt.RightEdge ? 378 : parent.width
    height: edge == Qt.LeftEdge || edge == Qt.RightEdge ? parent.height : 378
    edge: Qt.RightEdge
    parent: T.Overlay.overlay
    modal: true
    background: Item {
        MultiEffect {
            anchors.fill: __rect
            source: __rect
            shadowEnabled: true
            shadowColor: DelTheme.DelDrawer.colorShadow
            shadowBlur: DelTheme.isDark ? 0.8 : 0.5
            shadowOpacity: DelTheme.isDark ? 0.8 : 0.5
        }
        Rectangle {
            id: __rect
            anchors.fill: parent
            color: control.colorBg
        }
    }
    contentItem: ColumnLayout {
        Loader {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            sourceComponent: titleDelegate
        }
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: contentDelegate
        }
    }

    T.Overlay.modal: Rectangle {
        color: control.colorOverlay
    }
}

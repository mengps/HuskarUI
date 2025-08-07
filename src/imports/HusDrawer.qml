import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Templates as T
import HuskarUI.Basic

T.Drawer {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property int drawerSize: 378
    property string title: ''
    property font titleFont: Qt.font({
                                         family: HusTheme.HusDrawer.fontFamily,
                                         pixelSize: HusTheme.HusDrawer.fontSizeTitle
                                     })
    property color colorTitle: HusTheme.HusDrawer.colorTitle
    property color colorBg: HusTheme.HusDrawer.colorBg
    property color colorOverlay: HusTheme.HusDrawer.colorOverlay
    property Component titleDelegate: Item {
        height: 56

        Row {
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 15
            spacing: 5

            HusCaptionButton {
                id: __close
                topPadding: 2
                bottomPadding: 2
                leftPadding: 4
                rightPadding: 4
                anchors.verticalCenter: parent.verticalCenter
                animationEnabled: control.animationEnabled
                radiusBg: HusTheme.HusDrawer.radiusButtonBg
                iconSource: HusIcon.CloseOutlined
                hoverCursorShape: Qt.PointingHandCursor
                onClicked: {
                    control.close();
                }
            }

            HusText {
                anchors.verticalCenter: parent.verticalCenter
                text: control.title
                font: control.titleFont
                color: control.colorTitle
            }
        }

        HusDivider {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            animationEnabled: control.animationEnabled
        }
    }
    property Component contentDelegate: Item { }

    objectName: '__HusDrawer__'
    width: edge == Qt.LeftEdge || edge == Qt.RightEdge ? drawerSize : parent.width
    height: edge == Qt.LeftEdge || edge == Qt.RightEdge ? parent.height : drawerSize
    edge: Qt.RightEdge
    parent: T.Overlay.overlay
    modal: true
    enter: Transition { NumberAnimation { duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 } }
    exit: Transition { NumberAnimation { duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 } }
    background: Item {
        MultiEffect {
            anchors.fill: __rect
            source: __rect
            shadowEnabled: true
            shadowColor: HusTheme.HusDrawer.colorShadow
            shadowBlur: HusTheme.isDark ? 0.8 : 0.5
            shadowOpacity: HusTheme.isDark ? 0.8 : 0.5
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
            sourceComponent: titleDelegate
            onLoaded: {
                /*! 无边框窗口的标题栏会阻止事件传递, 需要调这个 */
                if (captionBar)
                    captionBar.addInteractionItem(item);
            }
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

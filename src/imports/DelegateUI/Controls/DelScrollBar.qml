import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.ScrollBar {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property int minimumHandleSize: 24
    property color colorBar: control.pressed ? DelTheme.DelScrollBar.colorBarActive :
                                               control.hovered ? DelTheme.DelScrollBar.colorBarHover :
                                                                 DelTheme.DelScrollBar.colorBar
    property color colorBg: control.pressed ? DelTheme.DelScrollBar.colorBgActive :
                                              control.hovered ? DelTheme.DelScrollBar.colorBgHover :
                                                                DelTheme.DelScrollBar.colorBg
    property string contentDescription: ""

    width: control.orientation == Qt.Vertical ? 10 : parent.width
    height: control.orientation == Qt.Horizontal ? 10 : parent.height
    anchors.right: control.orientation == Qt.Vertical ? parent.right : undefined
    anchors.bottom: control.orientation == Qt.Horizontal ? parent.bottom : undefined
    leftPadding: control.orientation == Qt.Horizontal ? (leftInset + 10) : leftInset
    rightPadding: control.orientation == Qt.Horizontal ? (rightInset + 10) : rightInset
    topPadding: control.orientation == Qt.Vertical ? (topInset + 10) : topInset
    bottomPadding: control.orientation == Qt.Vertical ? (bottomInset + 10) : bottomInset
    policy: T.ScrollBar.AlwaysOn
    minimumSize: {
        if (control.orientation == Qt.Vertical)
            return size * height < minimumHandleSize ? minimumHandleSize / height : 0;
        else
            return size * width < minimumHandleSize ? minimumHandleSize / width : 0;
    }
    visible: (control.policy != T.ScrollBar.AlwaysOff) && control.size !== 1
    contentItem: Item {
        Rectangle {
            width: {
                if (control.orientation == Qt.Vertical) {
                    return __private.visible ? 6 : 2;
                } else {
                    return parent.width;
                }
            }
            height: {
                if (control.orientation == Qt.Vertical) {
                    return parent.height;
                } else {
                    return __private.visible ? 6 : 2;
                }
            }
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            radius: control.orientation == Qt.Vertical ? width * 0.5 : height * 0.5
            color: control.colorBar
            opacity: {
                if (control.policy == T.ScrollBar.AlwaysOn) {
                    return 1;
                } else if (control.policy == T.ScrollBar.AsNeeded) {
                    return __private.visible ? 1 : 0;
                } else {
                    return 0;
                }
            }

            Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
            Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
        }
    }
    background: Rectangle {
        color: control.colorBg
        opacity: __private.visible ? 1 : 0

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
    }

    component HoverIcon: DelIconText {
        signal clicked()
        property bool hovered: false

        colorIcon: hovered ? DelTheme.DelScrollBar.colorIconHover : DelTheme.DelScrollBar.colorIcon
        opacity: __private.visible ? 1 : 0

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true;
            onExited: parent.hovered = false;
            onClicked: parent.clicked();
        }
    }

    QtObject {
        id: __private
        property bool visible: control.hovered || control.pressed
    }

    Loader {
        active: control.orientation == Qt.Vertical
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        sourceComponent: HoverIcon {
            iconSize: parent.width
            iconSource: DelIcon.CaretUpOutlined
            onClicked: control.decrease();
        }
    }

    Loader {
        active: control.orientation == Qt.Vertical
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        sourceComponent: HoverIcon {
            iconSize: parent.width
            iconSource: DelIcon.CaretDownOutlined
            onClicked: control.increase();
        }
    }

    Loader {
        active: control.orientation == Qt.Horizontal
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        sourceComponent: HoverIcon {
            iconSize: parent.height
            iconSource: DelIcon.CaretLeftOutlined
            onClicked: control.decrease();
        }
    }

    Loader {
        active: control.orientation == Qt.Horizontal
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        sourceComponent: HoverIcon {
            iconSize: parent.height
            iconSource: DelIcon.CaretRightOutlined
            onClicked: control.increase();
        }
    }

    Accessible.role: Accessible.ScrollBar
    Accessible.description: control.contentDescription
}

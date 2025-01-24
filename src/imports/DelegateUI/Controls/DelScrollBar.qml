import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.ScrollBar {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property color colorBar: control.pressed ? DelTheme.DelScrollBar.colorBarActive :
                                               control.hovered ? DelTheme.DelScrollBar.colorBarHover :
                                                                 DelTheme.DelScrollBar.colorBar
    property color colorBg: control.pressed ? DelTheme.DelScrollBar.colorBgActive :
                                              control.hovered ? DelTheme.DelScrollBar.colorBgHover :
                                                                DelTheme.DelScrollBar.colorBg
    property color colorIcon: control.pressed ? DelTheme.DelScrollBar.colorIconActive :
                                                control.hovered ? DelTheme.DelScrollBar.colorIconHover :
                                                                  DelTheme.DelScrollBar.colorIcon
    property string contentDescription: ""

    QtObject {
        id: __private
        property bool visible: control.hovered || control.pressed
    }

    width: control.orientation == Qt.Vertical ? 10 : parent.width
    height: control.orientation == Qt.Horizontal ? 10 : parent.height
    anchors.right: control.orientation == Qt.Vertical ? parent.right : undefined
    anchors.bottom: control.orientation == Qt.Horizontal ? parent.bottom : undefined
    leftPadding: control.orientation == Qt.Horizontal ? (leftInset + 10) : leftInset
    rightPadding: control.orientation == Qt.Horizontal ? (rightInset + 10) : rightInset
    topPadding: control.orientation == Qt.Vertical ? (topInset + 10) : topInset
    bottomPadding: control.orientation == Qt.Vertical ? (bottomInset + 10) : bottomInset
    policy: T.ScrollBar.AlwaysOn
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

        Loader {
            active: control.orientation == Qt.Vertical
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            sourceComponent: DelIconText {
                iconSize: parent.width
                iconSource: DelIcon.CaretUpOutlined
                colorIcon: control.colorIcon
            }
        }

        Loader {
            active: control.orientation == Qt.Vertical
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            sourceComponent: DelIconText {
                iconSize: parent.width
                iconSource: DelIcon.CaretDownOutlined
                colorIcon: control.colorIcon
            }
        }

        Loader {
            active: control.orientation == Qt.Horizontal
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            sourceComponent: DelIconText {
                iconSize: parent.height
                iconSource: DelIcon.CaretLeftOutlined
                colorIcon: control.colorIcon
            }
        }

        Loader {
            active: control.orientation == Qt.Horizontal
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            sourceComponent: DelIconText {
                iconSize: parent.height
                iconSource: DelIcon.CaretRightOutlined
                colorIcon: control.colorIcon
            }
        }

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
    }

    Accessible.role: Accessible.ScrollBar
    Accessible.description: control.contentDescription
}

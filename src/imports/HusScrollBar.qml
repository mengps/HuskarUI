/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.ScrollBar {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property int minimumHandleSize: 24
    property color colorBar: control.pressed ? HusTheme.HusScrollBar.colorBarActive :
                                               control.hovered ? HusTheme.HusScrollBar.colorBarHover :
                                                                 HusTheme.HusScrollBar.colorBar
    property color colorBg: control.pressed ? HusTheme.HusScrollBar.colorBgActive :
                                              control.hovered ? HusTheme.HusScrollBar.colorBgHover :
                                                                HusTheme.HusScrollBar.colorBg
    property string contentDescription: ''

    objectName: '__HusScrollBar__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    leftPadding: control.orientation === Qt.Horizontal ? 10 : 2
    rightPadding: control.orientation === Qt.Horizontal ? 10 : 2
    topPadding: control.orientation === Qt.Vertical ? 10 : 2
    bottomPadding: control.orientation === Qt.Vertical ? 10 : 2
    policy: T.ScrollBar.AlwaysOn
    minimumSize: {
        if (control.orientation === Qt.Vertical)
            return size * height < minimumHandleSize ? minimumHandleSize / height : 0;
        else
            return size * width < minimumHandleSize ? minimumHandleSize / width : 0;
    }
    visible: (control.policy != T.ScrollBar.AlwaysOff) && control.size !== 1
    contentItem: Rectangle {
        implicitWidth: control.interactive && __private.visible ? 6 : 2
        implicitHeight: control.interactive && __private.visible ? 6 : 2
        radius: control.orientation === Qt.Vertical ? width * 0.5 : height * 0.5
        color: control.colorBar
        opacity: {
            if (control.policy === T.ScrollBar.AlwaysOn) {
                return 1;
            } else if (control.policy === T.ScrollBar.AsNeeded) {
                return __private.visible ? 1 : 0;
            } else {
                return 0;
            }
        }

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    }
    background: Rectangle {
        color: control.colorBg
        opacity: __private.visible ? 1 : 0

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }

        Loader {
            active: control.orientation === Qt.Vertical
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            sourceComponent: HoverIcon {
                iconSize: 10
                iconSource: HusIcon.CaretUpOutlined
                onClicked: control.decrease();
            }
        }

        Loader {
            active: control.orientation === Qt.Vertical
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            sourceComponent: HoverIcon {
                iconSize: 10
                iconSource: HusIcon.CaretDownOutlined
                onClicked: control.increase();
            }
        }

        Loader {
            active: control.orientation === Qt.Horizontal
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            sourceComponent: HoverIcon {
                iconSize: 10
                iconSource: HusIcon.CaretLeftOutlined
                onClicked: control.decrease();
            }
        }

        Loader {
            active: control.orientation === Qt.Horizontal
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            sourceComponent: HoverIcon {
                iconSize: 10
                iconSource: HusIcon.CaretRightOutlined
                onClicked: control.increase();
            }
        }
    }

    onHoveredChanged: {
        if (hovered) {
            __exitTimer.stop();
            __private.exit = false;
        } else {
            __exitTimer.restart();
        }
    }

    component HoverIcon: HusIconText {
        signal clicked()
        property bool hovered: false

        colorIcon: hovered ? HusTheme.HusScrollBar.colorIconHover : HusTheme.HusScrollBar.colorIcon
        opacity: __private.visible ? 1 : 0

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }

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
        property bool visible: control.hovered || control.pressed || !exit
        property bool exit: true
    }

    Timer {
        id: __exitTimer
        interval: 800
        onTriggered: __private.exit = true;
    }

    Accessible.role: Accessible.ScrollBar
    Accessible.description: control.contentDescription
}

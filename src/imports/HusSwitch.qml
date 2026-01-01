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

T.Switch {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool loading: false
    property string checkedText: ''
    property string uncheckedText: ''
    property var checkedIconSource: 0 ?? ''
    property var uncheckedIconSource: 0 ?? ''
    property int iconSize: parseInt(themeSource.fontSize) - 2
    property alias textFont: control.font
    property color colorText: enabled ? themeSource.colorText : themeSource.colorTextDisabled
    property color colorHandle: themeSource.colorHandle
    property color colorBg: {
        if (!enabled)
            return checked ? themeSource.colorBgCheckedDisabled : themeSource.colorBgDisabled;

        if (checked)
            return control.down ? themeSource.colorBgCheckedActive :
                                  control.hovered ? themeSource.colorBgCheckedHover :
                                                    themeSource.colorBgChecked;
        else
            return control.down ? themeSource.colorBgActive :
                                  control.hovered ? themeSource.colorBgHover :
                                                    themeSource.colorBg;
    }
    property HusRadius radiusBg: HusRadius { all: control.implicitIndicatorHeight * 0.5 }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusSwitch

    property Component handleDelegate: Rectangle {
        radius: height * 0.5
        color: control.colorHandle

        HusIconText {
            anchors.centerIn: parent
            iconSize: parent.height - 4
            iconSource: HusIcon.LoadingOutlined
            colorIcon: control.colorBg
            visible: control.loading
            transformOrigin: Item.Center

            NumberAnimation on rotation {
                running: control.loading
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }
    }

    objectName: '__HusSwitch__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize)
    }
    indicator: Item {
        x: control.width - width - control.rightPadding
        y: parent.height * 0.5 - height * 0.5
        implicitWidth: __bg.width
        implicitHeight: __bg.height

        HusRectangleInternal {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.radius
            topLeftRadius: __bg.topLeftRadius
            topRightRadius: __bg.topRightRadius
            bottomLeftRadius: __bg.bottomLeftRadius
            bottomRightRadius: __bg.bottomRightRadius
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: 'transparent'
            border.width: 0
            border.color: control.enabled ? control.themeSource.colorBgHover : 'transparent'
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: 'width'; from: __bg.width + 3; to: __bg.width + 8;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'height'; from: __bg.height + 3; to: __bg.height + 8;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'opacity'; from: 0.2; to: 0;
                    duration: HusTheme.Primary.durationSlow
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled && control.effectEnabled) {
                        __effect.border.width = 8;
                        __animation.restart();
                    }
                }
            }
        }

        HusRectangleInternal {
            id: __bg
            width: Math.max(Math.max(checkedWidth, uncheckedWidth) + __handle.height, height * 2)
            height: hasContent ? Math.max(checkedHeight, uncheckedHeight, 22) : 22
            anchors.centerIn: parent
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
            color: control.colorBg
            clip: true

            property bool hasCheckedIcon: control.checkedIconSource !== 0 && control.checkedIconSource !== ''
            property bool hasUncheckedIcon: control.uncheckedIconSource !== 0 && control.uncheckedIconSource !== ''
            property bool hasContent: hasCheckedIcon || hasUncheckedIcon ||
                                      control.checkedText.length !== 0 || control.uncheckedText.length !== 0
            property real checkedWidth: !hasCheckedIcon ? __checkedText.width + 6 :  __checkedIcon.width + 6
            property real uncheckedWidth: !hasUncheckedIcon ? __uncheckedText.width + 6 : __uncheckedIcon.width + 6
            property real checkedHeight: !hasCheckedIcon ? __checkedText.height + 4 : __checkedIcon.height + 4
            property real uncheckedHeight: !hasUncheckedIcon ? __uncheckedText.height + 4 : __uncheckedIcon.height + 4

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

            HusText {
                id: __checkedText
                width: text.length === 0 ? 0 : Math.max(implicitWidth + 8, __uncheckedText.implicitWidth + 8)
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: __handle.left
                font {
                    family: control.font.family
                    pixelSize: control.iconSize
                }
                text: control.checkedText
                color: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: !__checkedIcon.visible
            }

            HusText {
                id: __uncheckedText
                width: text.length === 0 ? 0 : Math.max(implicitWidth + 8, __checkedText.implicitWidth + 8)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: __handle.right
                font {
                    family: control.font.family
                    pixelSize: control.iconSize
                }
                text: control.uncheckedText
                color: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: !__uncheckedIcon.visible
            }

            HusIconText {
                id: __checkedIcon
                leftPadding: 4
                rightPadding: 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: __handle.left
                iconSize: control.iconSize
                iconSource: control.checkedIconSource
                colorIcon: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: !empty
            }

            HusIconText {
                id: __uncheckedIcon
                leftPadding: 4
                rightPadding: 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: __handle.right
                iconSize: control.iconSize
                iconSource: control.uncheckedIconSource
                colorIcon: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
                visible: !empty
            }

            Loader {
                id: __handle
                x: control.checked ? (parent.width - (control.pressed ? height + 6 : height) - 2) : 2
                width: control.pressed ? height + 6 : height
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: control.handleDelegate

                Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
                Behavior on x { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
            }
        }
    }
    contentItem: HusText {
        text: control.text
        font: control.font
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        rightPadding: control.indicator.width + control.spacing
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.checked ? control.checkedText : control.uncheckedText
    Accessible.description: control.contentDescription
    Accessible.onToggleAction: control.toggle();
}

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
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

HusPopup {
    id: control

    property var iconSource: HusIcon.ExclamationCircleFilled || ''
    property int iconSize: 16
    property string title: ''
    property string description: ''
    property bool showArrow: true
    property int arrowWidth: 16
    property int arrowHeight: 8
    property color colorIcon: control.themeSource.colorIcon
    property color colorTitle: control.themeSource.colorTitle
    property color colorDescription: control.themeSource.colorDescription
    property font titleFont: Qt.font({
                                         family: control.themeSource.fontFamily,
                                         bold: true,
                                         pixelSize: parseInt(control.themeSource.fontSizeTitle)
                                     })
    property font descriptionFont: Qt.font({
                                               family: control.themeSource.fontFamily,
                                               pixelSize: parseInt(control.themeSource.fontSizeDescription)
                                           })
    property Component arrowDelegate: Canvas {
        id: __arrowDelegate
        width: arrowWidth
        height: arrowHeight
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onFillStyleChanged: requestPaint();
        onPaint: {
            const ctx = getContext('2d');
            ctx.fillStyle = fillStyle;
            ctx.beginPath();
            ctx.moveTo(0, height);
            ctx.lineTo(width * 0.5, 0);
            ctx.lineTo(width, height);
            ctx.closePath();
            ctx.fill();
        }
        property color fillStyle: control.colorBg
    }
    property Component iconDelegate: HusIconText {
        color: control.colorIcon
        iconSource: control.iconSource
        iconSize: control.iconSize
    }
    property Component titleDelegate: HusText {
        font: control.titleFont
        color: control.colorTitle
        text: control.title
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component descriptionDelegate: HusText {
        font: control.descriptionFont
        color: control.colorDescription
        text: control.description
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component contentDelegate: Item {
        height: __columnLayout.implicitHeight + 20

        ColumnLayout {
            id: __columnLayout
            width: parent.width - 20
            anchors.centerIn: parent
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                visible: __iconLoader.active || __titleLoader.active

                Loader {
                    id: __iconLoader
                    Layout.alignment: Qt.AlignVCenter
                    active: control.iconSource !== 0 && control.iconSource !== ''
                    sourceComponent: control.iconDelegate
                }

                Loader {
                    id: __titleLoader
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    active: control.title !== ''
                    sourceComponent: control.titleDelegate
                }
            }

            Loader {
                Layout.leftMargin: __iconLoader.width + 5
                Layout.fillWidth: true
                visible: active
                active: control.description !== ''
                sourceComponent: control.descriptionDelegate
            }

            Loader {
                id: __footerLoader
                Layout.fillWidth: true
                sourceComponent: control.footerDelegate
            }
        }
    }
    property Component bgDelegate: HusRectangleInternal {
        color: control.colorBg
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }
    property Component footerDelegate: Item { }

    objectName: '__HusPopover__'
    themeSource: HusTheme.HusPopover
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset
    transformOrigin: __private.isTop ? Item.Bottom : Item.Top
    enter: Transition {
        NumberAnimation {
            property: 'scale'
            from: 0.5
            to: 1.0
            easing.type: Easing.OutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'opacity'
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: 'scale'
            from: 1.0
            to: 0.5
            easing.type: Easing.InQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'opacity'
            from: 1.0
            to: 0
            easing.type: Easing.InQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    background: Item {
        implicitHeight: __bg.height

        HusShadow {
            anchors.fill: __bg
            source: __bg
            shadowColor: control.colorShadow
        }

        Loader {
            active: control.movable || control.resizable
            sourceComponent: HusResizeMouseArea {
                anchors.fill: parent
                target: control
                movable: control.movable
                resizable: control.resizable
                minimumX: control.minimumX
                maximumX: control.maximumX
                minimumY: control.minimumY
                maximumY: control.maximumY
                minimumWidth: control.minimumWidth
                maximumWidth: control.maximumWidth
                minimumHeight: control.minimumHeight
                maximumHeight: control.maximumHeight
            }
        }

        Item {
            id: __bg
            width: parent.width
            height: __arrowLoader.height + __contentLoader.height

            Loader {
                id: __arrowLoader
                x: -control.x + (__private.parentWidth - width) * 0.5
                y: __private.isTop ? (__bg.height - height) : 0
                width: control.arrowWidth
                height: control.arrowHeight
                rotation: __private.isTop ? 180 : 0
                active: control.showArrow
                sourceComponent: control.arrowDelegate
            }

            Loader {
                id: __bgLoader
                y: __private.isTop ? 0 : __arrowLoader.height
                width: parent.width
                height: __contentLoader.height
                sourceComponent: control.bgDelegate
            }
        }

        Loader {
            id: __contentLoader
            y: __private.isTop ? 0 : __arrowLoader.height
            width: parent.width
            sourceComponent: control.contentDelegate
        }
    }
    Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);

    QtObject {
        id: __private
        property real parentWidth: control.parent?.width ?? 0
        property real parentHeight: control.parent?.height ?? 0
        property bool isTop: control.y < parentHeight
    }
}

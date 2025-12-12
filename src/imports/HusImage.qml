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
import HuskarUI.Basic

Image {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool previewEnabled: true
    readonly property alias hovered: __hoverHandler.hovered
    property int hoverCursorShape: Qt.PointingHandCursor
    property string fallback: ''
    property string placeholder: ''
    property var items: []

    objectName: '__HusImage__'
    onSourceChanged: {
        if (items.length == 0) {
            __private.previewItems = [{ url: source }];
        }
    }
    onItemsChanged: {
        if (items.length > 0) {
            __private.previewItems = [...items];
        }
    }

    QtObject {
        id: __private
        property var previewItems: []
    }

    Loader {
        anchors.centerIn: parent
        active: control.status === Image.Error && control.fallback !== ''
        sourceComponent: Image {
            source: control.fallback
            Component.onCompleted: {
                __private.previewItems = [{ url: control.fallback }]
            }
        }
    }

    Loader {
        anchors.centerIn: parent
        active: control.status === Image.Loading && control.placeholder !== ''
        sourceComponent: Image {
            source: control.placeholder
        }
    }

    Loader {
        anchors.fill: parent
        active: control.previewEnabled
        sourceComponent: Rectangle {
            color: HusTheme.Primary.colorTextTertiary
            opacity: control.hovered ? 1.0 : 0.0

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
            Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

            Row {
                anchors.centerIn: parent
                spacing: 5

                HusIconText {
                    anchors.verticalCenter: parent.verticalCenter
                    colorIcon: HusTheme.HusImage.colorText
                    iconSource: HusIcon.EyeOutlined
                    iconSize: parseInt(HusTheme.HusImage.fontSize) + 2
                }

                HusText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr('预览')
                    color: HusTheme.HusImage.colorText
                }
            }

            HusImagePreview {
                id: __preview
                animationEnabled: control.animationEnabled
                items: __private.previewItems
            }

            TapHandler {
                onTapped: {
                    if (!__preview.opened) {
                        __preview.open();
                    }
                }
            }
        }
    }

    HoverHandler {
        id: __hoverHandler
        cursorShape: control.hoverCursorShape
    }
}

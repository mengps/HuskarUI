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
import QtQuick.Layouts
import HuskarUI.Basic

T.Control {
    id: control

    enum ImageStyle
    {
        Style_None = 0,
        Style_Default = 1,
        Style_Simple = 2
    }

    property int imageStyle: HusEmpty.Style_Default
    property string imageSource: {
        switch (imageStyle) {
        case HusEmpty.Style_None: return '';
        case HusEmpty.Style_Default: return 'qrc:/HuskarUI/resources/images/empty-default.svg';
        case HusEmpty.Style_Simple: return 'qrc:/HuskarUI/resources/images/empty-simple.svg';
        }
    }
    property int imageWidth: {
        switch (imageStyle) {
        case HusEmpty.Style_None: return width / 3;
        case HusEmpty.Style_Default: return 92;
        case HusEmpty.Style_Simple: return 64;
        }
    }
    property int imageHeight: {
        switch (imageStyle) {
        case HusEmpty.Style_None: return height / 3;
        case HusEmpty.Style_Default: return 76;
        case HusEmpty.Style_Simple: return 41;
        }
    }
    property bool showDescription: true
    property string description: ''
    property int descriptionSpacing: 12
    property alias descriptionFont: control.font
    property color colorDescription: themeSource.colorDescription
    property var themeSource: HusTheme.HusEmpty

    property Component imageDelegate: Image {
        width: control.imageWidth
        height: control.imageHeight
        source: control.imageSource
        sourceSize: Qt.size(width, height)
    }
    property Component descriptionDelegate: HusText {
        text: control.description
        font: control.descriptionFont
        color: control.colorDescription
        horizontalAlignment: Text.AlignHCenter
    }

    objectName: '__HusEmpty__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize) - 1
    }
    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 200

        ColumnLayout {
            anchors.centerIn: parent
            spacing: control.descriptionSpacing

            Loader {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                visible: active
                active: control.imageSource !== '' || control.imageStyle !== HusEmpty.Style_None
                sourceComponent: control.imageDelegate
            }

            Loader {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                visible: active
                active: control.showDescription
                sourceComponent: control.descriptionDelegate
            }
        }
    }
}

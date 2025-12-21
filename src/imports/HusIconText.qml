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

HusText {
    id: control

    readonly property bool empty: iconSource === 0 || iconSource === ''
    property var iconSource: 0 ?? ''
    property alias iconSize: control.font.pixelSize
    property alias colorIcon: control.color
    property string contentDescription: text

    objectName: '__HusIconText__'
    width: __iconLoader.active ? (__iconLoader.implicitWidth + leftPadding + rightPadding) : implicitWidth
    height: __iconLoader.active ? (__iconLoader.implicitHeight + topPadding + bottomPadding) : implicitHeight
    text: __iconLoader.active ? '' : String.fromCharCode(iconSource)
    font {
        family: 'HuskarUI-Icons'
        pixelSize: parseInt(HusTheme.HusIconText.fontSize)
    }
    color: enabled ? HusTheme.HusIconText.colorText : HusTheme.HusIconText.colorTextDisabled

    Loader {
        id: __iconLoader
        anchors.centerIn: parent
        active: typeof iconSource == 'string' && iconSource !== ''
        sourceComponent: Image {
            source: control.iconSource
            width: control.iconSize
            height: control.iconSize
            sourceSize: Qt.size(width, height)
        }
    }

    Accessible.role: Accessible.Graphic
    Accessible.name: control.text
    Accessible.description: control.contentDescription
}

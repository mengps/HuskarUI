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

T.Label {
    id: control

    property real borderWidth: 1
    property alias colorText: control.color
    property color colorBg: enabled ? themeSource.colorBg : themeSource.colorBgDisabled
    property color colorBorder: themeSource.colorBorder
    property HusRadius radiusBg: HusRadius { all: 0 }
    property var themeSource: HusTheme.HusLabel

    objectName: '__HusLabel__'
    renderType: HusTheme.textRenderType
    color: enabled ? themeSource.colorText : themeSource.colorTextDisabled
    linkColor: enabled ? themeSource.colorLinkText : themeSource.colorTextDisabled
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize)
    }
    background: HusRectangleInternal {
        color: control.colorBg
        border.color: control.colorBorder
        border.width: control.borderWidth
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }
}

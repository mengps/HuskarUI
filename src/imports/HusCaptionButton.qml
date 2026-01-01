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

HusIconButton {
    id: control

    property bool isError: false
    property bool noDisabledState: false

    objectName: '__HusCaptionButton__'
    leftPadding: 12 * sizeRatio
    rightPadding: 12 * sizeRatio
    active: down
    radiusBg.all: 0
    hoverCursorShape: Qt.ArrowCursor
    type: HusButton.Type_Text
    iconSize: parseInt(HusTheme.HusCaptionButton.fontSize)
    effectEnabled: false
    colorIcon: {
        if (enabled || noDisabledState) {
            return checked ? HusTheme.HusCaptionButton.colorIconChecked :
                             HusTheme.HusCaptionButton.colorIcon;
        } else {
            return HusTheme.HusCaptionButton.colorIconDisabled;
        }
    }
    colorBg: {
        if (enabled || noDisabledState) {
            if (isError) {
                return active ? HusTheme.HusCaptionButton.colorErrorBgActive:
                                hovered ? HusTheme.HusCaptionButton.colorErrorBgHover :
                                          HusTheme.HusCaptionButton.colorErrorBg;
            } else {
                return active ? HusTheme.HusCaptionButton.colorBgActive:
                                hovered ? HusTheme.HusCaptionButton.colorBgHover :
                                          HusTheme.HusCaptionButton.colorBg;
            }
        } else {
            return HusTheme.HusCaptionButton.colorBgDisabled;
        }
    }
}

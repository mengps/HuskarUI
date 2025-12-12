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

HusPopover {
    id: control

    signal confirm()
    signal cancel()

    property string confirmText: ''
    property string cancelText: ''
    property Component confirmButtonDelegate: HusButton {
        animationEnabled: control.animationEnabled
        padding: 10
        topPadding: 4
        bottomPadding: 4
        text: control.confirmText
        type: HusButton.Type_Primary
        onClicked: control.confirm();
    }
    property Component cancelButtonDelegate: HusButton {
        animationEnabled: control.animationEnabled
        padding: 10
        topPadding: 4
        bottomPadding: 4
        text: control.cancelText
        type: HusButton.Type_Default
        onClicked: control.cancel();
    }

    footerDelegate: Item {
        implicitHeight: __rowLayout.implicitHeight

        RowLayout {
            id: __rowLayout
            anchors.right: parent.right
            spacing: 10
            visible: __confirmLoader.active || __cancelLoader.active

            Loader {
                id: __confirmLoader
                visible: active
                active: control.confirmText !== ''
                sourceComponent: control.confirmButtonDelegate
            }

            Loader {
                id: __cancelLoader
                visible: active
                active: control.cancelText !== ''
                sourceComponent: control.cancelButtonDelegate
            }
        }
    }

    objectName: '__HusPopconfirm__'
    themeSource: HusTheme.HusPopconfirm
}

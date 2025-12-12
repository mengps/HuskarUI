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
import HuskarUI.Basic

HusButton {
    id: control

    enum IconPosition {
        Position_Start = 0,
        Position_End = 1
    }

    property bool loading: false
    property var iconSource: 0 ?? ''
    property int iconSize: parseInt(themeSource.fontSize)
    property int iconSpacing: 5 * sizeRatio
    property int iconPosition: HusIconButton.Position_Start
    property int orientation: Qt.Horizontal
    property font iconFont: Qt.font({
                                        family: 'HuskarUI-Icons',
                                        pixelSize: iconSize
                                    })
    property color colorIcon: colorText

    property Component iconDelegate: HusIconText {
        font: control.iconFont
        color: control.colorIcon
        iconSize: control.iconSize
        iconSource: control.loading ? HusIcon.LoadingOutlined : control.iconSource
        verticalAlignment: Text.AlignVCenter
        visible: !empty

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        NumberAnimation on rotation {
            running: control.loading
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }
    }

    objectName: '__HusIconButton__'
    contentItem: Item {
        implicitWidth: control.orientation === Qt.Horizontal ? __horLoader.implicitWidth : __verLoader.implicitWidth
        implicitHeight: control.orientation === Qt.Horizontal ? __horLoader.implicitHeight : __verLoader.implicitHeight

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
        Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

        Loader {
            id: __horLoader
            anchors.centerIn: parent
            active: control.orientation === Qt.Horizontal
            sourceComponent: Row {
                spacing: control.iconSpacing
                layoutDirection: control.iconPosition === HusIconButton.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

                Loader {
                    id: __hIcon
                    height: Math.max(__hIcon.implicitHeight, __hText.implicitHeight)
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: control.iconDelegate
                }

                HusText {
                    id: __hText
                    anchors.verticalCenter: parent.verticalCenter
                    text: control.text
                    font: control.font
                    lineHeight: HusTheme.HusButton.fontLineHeight
                    color: control.colorText
                    elide: Text.ElideRight
                    visible: text !== ''

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
            }
        }

        Loader {
            id: __verLoader
            active: control.orientation === Qt.Vertical
            anchors.centerIn: parent
            sourceComponent: Column {
                spacing: control.iconSpacing
                Component.onCompleted: relayout();

                function relayout() {
                    if (control.iconPosition === HusIconButton.Position_Start) {
                        children = [__vIcon, __vText];
                    } else {
                        children = [__vText, __vIcon];
                    }
                }

                Loader {
                    id: __vIcon
                    height: Math.max(__vIcon.implicitHeight, __vText.implicitHeight)
                    anchors.horizontalCenter: parent.horizontalCenter
                    sourceComponent: control.iconDelegate
                }

                HusText {
                    id: __vText
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: control.text
                    font: control.font
                    lineHeight: HusTheme.HusButton.fontLineHeight
                    color: control.colorText
                    elide: Text.ElideRight
                    visible: text !== ''

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
            }
        }
    }
}

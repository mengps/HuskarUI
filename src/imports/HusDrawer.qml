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

T.Drawer {
    id: control

    enum ClosePosition {
        Position_Start = 0,
        Position_End = 1
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property bool maskClosable: true
    property int closePosition: HusDrawer.Position_Start
    property int drawerSize: 378
    property string title: ''
    property font titleFont: Qt.font({
                                         family: HusTheme.HusDrawer.fontFamily,
                                         pixelSize: parseInt(HusTheme.HusDrawer.fontSizeTitle)
                                     })
    property color colorTitle: HusTheme.HusDrawer.colorTitle
    property color colorBg: HusTheme.HusDrawer.colorBg
    property color colorOverlay: HusTheme.HusDrawer.colorOverlay

    property Component closeDelegate: Component {
        HusCaptionButton {
            topPadding: 2
            bottomPadding: 2
            leftPadding: 4
            rightPadding: 4
            anchors.verticalCenter: parent.verticalCenter
            animationEnabled: control.animationEnabled
            radiusBg.all: HusTheme.HusDrawer.radiusButtonBg
            iconSource: HusIcon.CloseOutlined
            hoverCursorShape: Qt.PointingHandCursor
            onClicked: {
                control.close();
            }
        }
    }

    property Component titleDelegate: Item {
        height: 56

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            spacing: 5

            Loader {
                id: __closeStartLoader
                sourceComponent: closeDelegate
                Layout.alignment: Qt.AlignVCenter
                active: control.closePosition === HusDrawer.Position_Start
                visible: control.closePosition === HusDrawer.Position_Start
            }

            HusText {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                text: control.title
                font: control.titleFont
                color: control.colorTitle
            }

            Loader {
                id: __closeEndLoader
                sourceComponent: closeDelegate
                Layout.alignment: Qt.AlignVCenter
                active: control.closePosition === HusDrawer.Position_End
                visible: control.closePosition === HusDrawer.Position_End
            }
        }

        HusDivider {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
            animationEnabled: control.animationEnabled
        }
    }

    property Component contentDelegate: Item { }

    objectName: '__HusDrawer__'
    width: edge == Qt.LeftEdge || edge == Qt.RightEdge ? drawerSize : parent.width
    height: edge == Qt.LeftEdge || edge == Qt.RightEdge ? parent.height : drawerSize
    edge: Qt.RightEdge
    parent: T.Overlay.overlay
    modal: true
    closePolicy: maskClosable ? T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside : T.Popup.NoAutoClose
    enter: Transition { NumberAnimation { duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 } }
    exit: Transition { NumberAnimation { duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 } }
    background: Item {
        HusShadow {
            anchors.fill: __rect
            source: __rect
            shadowColor: HusTheme.HusDrawer.colorShadow
        }

        Rectangle {
            id: __rect
            anchors.fill: parent
            color: control.colorBg
        }
    }
    contentItem: ColumnLayout {
        spacing: 0
        Loader {
            Layout.fillWidth: true
            sourceComponent: control.titleDelegate
            onLoaded: {
                /*! 无边框窗口的标题栏会阻止事件传递, 需要调这个 */
                if (captionBar)
                    captionBar.addInteractionItem(item);
            }
        }
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: control.contentDelegate
        }
    }
    onAboutToShow: {
        if (captionBar && modal)
            captionBar.enabled = false;
    }
    onAboutToHide: {
        if (captionBar && modal)
            captionBar.enabled = true;
    }

    T.Overlay.modal: Rectangle {
        color: control.colorOverlay
    }
}

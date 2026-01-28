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
import HuskarUI.Impl
import HuskarUI.Basic

Rectangle {
    id: control

    property var targetWindow: null
    property HusWindowAgent windowAgent: null

    property alias layoutDirection: __row.layoutDirection

    property bool mirrored: false
    property string winIcon: ''
    property alias winIconWidth: __winIconLoader.width
    property alias winIconHeight: __winIconLoader.height
    property alias showWinIcon: __winIconLoader.visible

    property string winTitle: targetWindow?.title ?? ''
    property font winTitleFont: Qt.font({
                                            family: HusTheme.Primary.fontPrimaryFamily,
                                            pixelSize: 14
                                        })
    property color winTitleColor: HusTheme.Primary.colorTextBase
    property alias showWinTitle: __winTitleLoader.visible

    property bool showReturnButton: false
    property bool showThemeButton: false
    property bool topButtonChecked: false
    property bool showTopButton: false
    property bool showMinimizeButton: Qt.platform.os !== 'osx'
    property bool showMaximizeButton: Qt.platform.os !== 'osx'
    property bool showCloseButton: Qt.platform.os !== 'osx'

    property var returnCallback: () => { }
    property var themeCallback: () => { HusTheme.darkMode = HusTheme.isDark ? HusTheme.Light : HusTheme.Dark; }
    property var topCallback: checked => { }
    property var minimizeCallback:
        () => {
            if (targetWindow) {
                HusApi.setWindowState(targetWindow, Qt.WindowMinimized);
            }
        }
    property var maximizeCallback:
        () => {
            if (!targetWindow) return;

            if (targetWindow.visibility === Window.Maximized ||
                targetWindow.visibility === Window.FullScreen) {
                targetWindow.showNormal();
            } else {
                targetWindow.showMaximized();
            }
        }
    property var closeCallback:
        () => {
            if (targetWindow) targetWindow.close();
        }
    property string contentDescription: winTitle
    property var themeSource: HusTheme.HusCaptionButton

    property Component winNavButtonsDelegate: Row {
        layoutDirection: control.mirrored ? Qt.RightToLeft : Qt.LeftToRight

        HusCaptionButton {
            id: __returnButton
            noDisabledState: true
            iconSource: HusIcon.ArrowLeftOutlined
            iconSize: parseInt(control.themeSource.fontSize) + 2
            visible: control.showReturnButton
            onClicked: control.returnCallback();
            contentDescription: qsTr('返回')
        }
    }
    property Component winIconDelegate: Image {
        width: 20
        height: 20
        source: control.winIcon
        sourceSize.width: width
        sourceSize.height: height
        mipmap: true
    }
    property Component winTitleDelegate: HusText {
        text: control.winTitle
        color: control.winTitleColor
        font: control.winTitleFont
    }
    property Component winPresetButtonsDelegate: Row {
        layoutDirection: control.mirrored ? Qt.RightToLeft : Qt.LeftToRight

        Connections {
            target: control
            function onWindowAgentChanged() {
                control.addInteractionItem(__themeButton);
                control.addInteractionItem(__topButton);
            }
        }

        HusCaptionButton {
            id: __themeButton
            height: parent.height
            visible: control.showThemeButton
            noDisabledState: true
            iconSource: HusTheme.isDark ? HusIcon.MoonOutlined : HusIcon.SunOutlined
            iconSize: 14
            contentDescription: qsTr('明暗主题切换')
            onClicked: control.themeCallback();
        }

        HusCaptionButton {
            id: __topButton
            height: parent.height
            visible: control.showTopButton
            noDisabledState: true
            iconSource: HusIcon.PushpinOutlined
            iconSize: 14
            checkable: true
            checked: control.topButtonChecked
            contentDescription: qsTr('置顶')
            onClicked: control.topCallback(checked);
        }
    }
    property Component winExtraButtonsDelegate: Item { }
    property Component winButtonsDelegate: Row {
        layoutDirection: control.mirrored ? Qt.RightToLeft : Qt.LeftToRight

        Connections {
            target: control
            function onWindowAgentChanged() {
                if (windowAgent) {
                    windowAgent.setSystemButton(HusWindowAgent.Minimize, __minimizeButton);
                    windowAgent.setSystemButton(HusWindowAgent.Maximize, __maximizeButton);
                    windowAgent.setSystemButton(HusWindowAgent.Close, __closeButton);
                }
            }
        }

        HusCaptionButton {
            id: __minimizeButton
            height: parent.height
            visible: control.showMinimizeButton
            noDisabledState: true
            iconSource: HusIcon.LineOutlined
            iconSize: 14
            contentDescription: qsTr('最小化')
            onClicked: control.minimizeCallback();
        }

        HusCaptionButton {
            id: __maximizeButton
            height: parent.height
            visible: control.showMaximizeButton
            noDisabledState: true
            iconSize: 14
            contentItem: HusIconText {
                iconSource: HusIcon.SwitcherTwotonePath3
                iconSize: __maximizeButton.iconSize
                colorIcon: __maximizeButton.colorIcon
                verticalAlignment: Text.AlignVCenter
                visible: targetWindow

                HusIconText {
                    anchors.centerIn: parent
                    iconSource: HusIcon.SwitcherTwotonePath2
                    iconSize: __maximizeButton.iconSize
                    colorIcon: __maximizeButton.colorIcon
                    verticalAlignment: Text.AlignVCenter
                    visible: targetWindow && targetWindow.visibility === Window.Maximized
                }
            }
            contentDescription: qsTr('最大化')
            onClicked: control.maximizeCallback();
        }

        HusCaptionButton {
            id: __closeButton
            height: parent.height
            visible: control.showCloseButton
            noDisabledState: true
            iconSource: HusIcon.CloseOutlined
            iconSize: 14
            isError: true
            contentDescription: qsTr('关闭')
            onClicked: control.closeCallback();
        }
    }

    objectName: '__HusCaptionBar__'
    color: 'transparent'

    function addInteractionItem(item) {
        if (windowAgent)
            windowAgent.setHitTestVisible(item, true);
    }

    function removeInteractionItem(item) {
        if (windowAgent)
            windowAgent.setHitTestVisible(item, false);
    }

    RowLayout {
        id: __row
        anchors.fill: parent
        layoutDirection: control.mirrored ? Qt.RightToLeft : Qt.LeftToRight
        spacing: 0

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: control.winNavButtonsDelegate
        }

        Item {
            id: __title
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: {
                if (control.windowAgent)
                    control.windowAgent.setTitleBar(__title);
            }
            readonly property real maxMargin: Math.max(x,  __row.width - (x + width))
            readonly property real leftMargin: maxMargin > x ? (maxMargin - x) : 0
            readonly property real rightMargin: maxMargin > x ? 0 : (maxMargin - (__row.width - (x + width)))

            Item {
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: Qt.platform.os === 'osx' ? __title.leftMargin : (control.mirrored ? 0 : 8)
                anchors.right: parent.right
                anchors.rightMargin: Qt.platform.os === 'osx' ? __title.rightMargin : (control.mirrored ? 8 : 0)

                Row {
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: Qt.platform.os === 'osx' ? parent.horizontalCenter : undefined
                    layoutDirection: control.mirrored ? Qt.RightToLeft : Qt.LeftToRight
                    spacing: 5

                    Loader {
                        id: __winIconLoader
                        width: 22
                        height: Math.min(parent.height, 22)
                        anchors.verticalCenter: parent.verticalCenter
                        sourceComponent: control.winIconDelegate
                    }

                    Loader {
                        id: __winTitleLoader
                        anchors.verticalCenter: parent.verticalCenter
                        sourceComponent: control.winTitleDelegate
                    }
                }
            }
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: control.winPresetButtonsDelegate
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: control.winExtraButtonsDelegate
        }

        Loader {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            sourceComponent: control.winButtonsDelegate
        }
    }

    Accessible.role: Accessible.TitleBar
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
}

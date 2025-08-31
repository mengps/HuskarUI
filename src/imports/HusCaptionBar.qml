import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Rectangle {
    id: control

    property var targetWindow: null
    property HusWindowAgent windowAgent: null

    property alias layoutDirection: __row.layoutDirection

    property url winIcon: ''
    property alias winIconWidth: __winIconLoader.width
    property alias winIconHeight: __winIconLoader.height
    property alias winIconVisible: __winIconLoader.visible

    property string winTitle: targetWindow ? targetWindow.title : ''
    property font winTitleFont: Qt.font({
                                            family: HusTheme.Primary.fontPrimaryFamily,
                                            pixelSize: 14
                                        })
    property color winTitleColor: HusTheme.Primary.colorTextBase
    property alias winTitleVisible: __winTitleLoader.visible

    property bool returnButtonVisible: false
    property bool themeButtonVisible: false
    property bool topButtonVisible: false
    property bool minimizeButtonVisible: Qt.platform.os !== 'osx'
    property bool maximizeButtonVisible: Qt.platform.os !== 'osx'
    property bool closeButtonVisible: Qt.platform.os !== 'osx'

    property var returnCallback: () => { }
    property var themeCallback: () => { HusTheme.darkMode = HusTheme.isDark ? HusTheme.Light : HusTheme.Dark; }
    property var topCallback: checked => { }
    property var minimizeCallback:
        () => {
            if (targetWindow) HusApi.setWindowState(targetWindow, Qt.WindowMinimized);
        }
    property var maximizeCallback: () => {
            if (!targetWindow) return;

            if (targetWindow.visibility === Window.Maximized) targetWindow.showNormal();
            else targetWindow.showMaximized();
        }
    property var closeCallback: () => { if (targetWindow) targetWindow.close(); }
    property string contentDescription: targetWindow ? targetWindow.title : ''

    property Component winIconDelegate: Image {
        source: control.winIcon
        sourceSize.width: width
        sourceSize.height: height
        mipmap: true
    }
    property Component winTitleDelegate: Text {
        text: winTitle
        color: winTitleColor
        font: winTitleFont
    }
    property Component winButtonsDelegate: Row {
        Connections {
            target: control
            function onWindowAgentChanged() {
                if (windowAgent) {
                    windowAgent.setHitTestVisible(__themeButton, true);
                    windowAgent.setHitTestVisible(__topButton, true);
                    windowAgent.setSystemButton(HusWindowAgent.Minimize, __minimizeButton);
                    windowAgent.setSystemButton(HusWindowAgent.Maximize, __maximizeButton);
                    windowAgent.setSystemButton(HusWindowAgent.Close, __closeButton);
                }
            }
        }

        HusCaptionButton {
            id: __themeButton
            visible: control.themeButtonVisible
            iconSource: HusTheme.isDark ? HusIcon.MoonOutlined : HusIcon.SunOutlined
            iconSize: 16
            contentDescription: qsTr('明暗主题切换')
            onClicked: control.themeCallback();
        }

        HusCaptionButton {
            id: __topButton
            visible: control.topButtonVisible
            iconSource: HusIcon.PushpinOutlined
            iconSize: 16
            checkable: true
            contentDescription: qsTr('置顶')
            onClicked: control.topCallback(checked);
        }

        HusCaptionButton {
            id: __minimizeButton
            visible: control.minimizeButtonVisible
            iconSource: HusIcon.LineOutlined
            iconSize: 14
            contentDescription: qsTr('最小化')
            onClicked: control.minimizeCallback();
        }

        HusCaptionButton {
            id: __maximizeButton
            visible: control.maximizeButtonVisible
            topPadding: 8
            bottomPadding: 8
            contentItem: HusIconText {
                iconSource: HusIcon.SwitcherTwotonePath3
                iconSize: 14
                visible: targetWindow

                HusIconText {
                    iconSource: HusIcon.SwitcherTwotonePath2
                    iconSize: 14
                    visible: targetWindow.visibility === Window.Maximized
                }
            }
            contentDescription: qsTr('最大化')
            onClicked: control.maximizeCallback();
        }

        HusCaptionButton {
            id: __closeButton
            visible: control.closeButtonVisible
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
        spacing: 0

        HusCaptionButton {
            id: __returnButton
            Layout.alignment: Qt.AlignVCenter
            iconSource: HusIcon.ArrowLeftOutlined
            iconSize: HusTheme.HusCaptionButton.fontSize + 2
            visible: control.returnButtonVisible
            onClicked: returnCallback();
            contentDescription: qsTr('返回')
        }

        Item {
            id: __title
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: {
                if (windowAgent)
                    windowAgent.setTitleBar(__title);
            }

            Row {
                height: parent.height
                anchors.left: Qt.platform.os === 'osx' ? undefined : parent.left
                anchors.leftMargin: Qt.platform.os === 'osx' ? 0 : 8
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: Qt.platform.os === 'osx' ? parent.horizontalCenter : undefined
                spacing: 5

                Loader {
                    id: __winIconLoader
                    width: 20
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: winIconDelegate
                }

                Loader {
                    id: __winTitleLoader
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: winTitleDelegate
                }
            }
        }

        Loader {
            Layout.alignment: Qt.AlignVCenter
            width: item ? item.width : 0
            height: item ? item.height : 0
            sourceComponent: winButtonsDelegate
        }
    }

    Accessible.role: Accessible.TitleBar
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
}

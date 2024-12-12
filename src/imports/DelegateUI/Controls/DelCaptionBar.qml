import QtQuick
import QtQuick.Layouts
import QWindowKit
import DelegateUI

Rectangle {
    id: control
    color: "transparent"

    property var targetWindow: null
    property WindowAgent windowAgent: null

    property alias layoutDirection: __row.layoutDirection

    property string winIcon: ""
    property alias winIconWidth: __winIconLoader.width
    property alias winIconHeight: __winIconLoader.height
    property alias winIconVisible: __winIconLoader.visible

    property font winTitleFont
    winTitleFont {
        family: DelTheme.Primary.fontPrimaryFamily
        pixelSize: DelTheme.Primary.fontPrimarySize
    }
    property color winTitleColor: DelTheme.Primary.colorTextBase
    property alias winTitleVisible: __winTitleLoader.visible

    property alias returnButtonVisible: __returnButton.visible
    property alias themeButtonVisible: __themeButton.visible
    property alias topButtonVisible: __topButton.visible
    property alias minimizeButtonVisible: __minimizeButton.visible
    property alias maximizeButtonVisible: __maximizeButton.visible
    property alias closeButtonVisible: __closeButton.visible

    property var returnCallback: ()=>{ }
    property var themeCallback: ()=>{ DelTheme.darkMode = DelTheme.isDark ? DelTheme.Light : DelTheme.Dark; }
    property var topCallback: (checked)=>{ }
    property var minimizeCallback:
        ()=>{
            if (targetWindow) targetWindow.showMinimized();
        }
    property var maximizeCallback: ()=>{
            if (!targetWindow) return;

            if (targetWindow.visibility === Window.Maximized) targetWindow.showNormal();
            else targetWindow.showMaximized();
        }
    property var closeCallback: ()=>{ if (targetWindow) targetWindow.close(); }

    property Component winIconDelegate: Image {
        source: control.winIcon
        sourceSize.width: width
        sourceSize.height: height
        mipmap: true
    }
    property Component winTitleDelegate: Text {
        text: targetWindow ? targetWindow.title : ""
        color: winTitleColor
        font: winTitleFont
    }

    RowLayout {
        id: __row
        anchors.fill: parent
        spacing: 0

        DelCaptionButton {
            id: __returnButton
            Layout.alignment: Qt.AlignVCenter
            iconSource: DelIcon.ArrowLeftOutlined
            iconSize: 16
            onClicked: returnCallback();
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
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter

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

        DelCaptionButton {
            id: __themeButton
            Layout.alignment: Qt.AlignVCenter
            visible: false
            iconSource: DelTheme.isDark ? DelIcon.MoonOutlined : DelIcon.SunOutlined
            iconSize: 16
            onClicked: themeCallback();
        }

        DelCaptionButton {
            id: __topButton
            Layout.alignment: Qt.AlignVCenter
            visible: false
            iconSource: DelIcon.PushpinOutlined
            iconSize: 16
            checkable: true
            onClicked: topCallback(checked);
        }

        DelCaptionButton {
            id: __minimizeButton
            Layout.alignment: Qt.AlignVCenter
            iconSource: DelIcon.LineOutlined
            onClicked: minimizeCallback();
            Component.onCompleted: {
                if (windowAgent)
                    windowAgent.setSystemButton(WindowAgent.Minimize, __minimizeButton);
            }
        }

        DelCaptionButton {
            id: __maximizeButton
            Layout.alignment: Qt.AlignVCenter
            iconSource: targetWindow.visibility === Window.Maximized ? DelIcon.SwitcherOutlined : DelIcon.BorderOutlined
            onClicked: maximizeCallback();
            Component.onCompleted: {
                if (windowAgent)
                    windowAgent.setSystemButton(WindowAgent.Maximize, __maximizeButton);
            }
        }

        DelCaptionButton {
            id: __closeButton
            Layout.alignment: Qt.AlignVCenter
            iconSource: DelIcon.CloseOutlined
            isError: true
            onClicked: closeCallback();
            Component.onCompleted: {
                if (windowAgent)
                    windowAgent.setSystemButton(WindowAgent.Close, __closeButton);
            }
        }
    }
}

import QtQuick
import DelegateUI

Item {
    id: control

    property var targetWindow: null
    property alias layoutDirection: __row.layoutDirection
    property alias themeButtonVisible: __themeButton.visible
    property alias topButtonVisible: __topButton.visible
    property alias minimizeButtonVisible: __minimizeButton.visible
    property alias maximizeButtonVisible: __maximizeButton.visible
    property alias closeButtonVisible: __closeButton.visible

    width: __row.width
    height: __row.height

    Row {
        id: __row

        DelCaptionButton {
            id: __themeButton
            iconSource: DelTheme.isDark ? DelIcon.MoonOutlined : DelIcon.SunOutlined
            iconSize: 16
            onClicked: {
                DelTheme.darkMode = DelTheme.isDark ? DelTheme.Light : DelTheme.Dark;
            }
        }

        DelCaptionButton {
            id: __topButton
            iconSource: DelIcon.PushpinOutlined
            iconSize: 16
            checkable: true
            onClicked: {

            }
        }

        DelCaptionButton {
            id: __minimizeButton
            iconSource: DelIcon.MinusOutlined
            onClicked: {
                control.targetWindow.showMinimized();
            }
        }

        DelCaptionButton {
            id: __maximizeButton
            iconSource: targetWindow.visibility === Window.Maximized ? DelIcon.SwitcherOutlined : DelIcon.BorderOutlined
            onClicked: {
                if (targetWindow.visibility === Window.Maximized)
                    targetWindow.showNormal();
                else
                    targetWindow.showMaximized();
            }
        }

        DelCaptionButton {
            id: __closeButton
            iconSource: DelIcon.CloseOutlined
            isError: true
            onClicked: {
                targetWindow.close();
            }
        }
    }
}

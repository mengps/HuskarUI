import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import DelegateUI

import "./Examples"

DelWindow {
    id: window
    width: 1200
    height: 800
    title: qsTr("DelegateUI Gallery")
    followThemeSwitch: false
    captionBar.themeButtonVisible: true
    captionBar.topButtonVisible: true
    captionBar.winIconWidth: 22
    captionBar.winIconHeight: 22
    captionBar.winIconDelegate: Item {
        DelIconText {
            iconSize: 22
            iconColor: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath1
        }
        DelIconText {
            iconSize: 22
            iconColor: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath2
        }
    }
    captionBar.topCallback: (checked) => {
                                DelApi.setWindowStaysOnTopHint(window, checked);
                            }

    Component.onCompleted: setSpecialEffect(DelWindowSpecialEffect.Mica);

    Rectangle {
        id: background
        anchors.fill: content
    }

    Rectangle {
        id: themeCircle
        x: r - width
        y: -height * 0.5
        width: 0
        height: 0
        radius: width * 0.5
        color: "#141414"

        property real r: Math.sqrt(parent.width * parent.width + parent.height * parent.height)

        NumberAnimation {
            running: DelTheme.isDark
            properties: "width,height"
            target: themeCircle
            from: 0
            to: themeCircle.r * 2
            duration: DelTheme.Primary.durationMid
            onStarted: themeCircle.visible = true;
            onFinished: {
                themeCircle.visible = false;
                themeCircle.width = Qt.binding(()=>themeCircle.r * 2);
                themeCircle.height = Qt.binding(()=>themeCircle.r * 2);
                if (window.specialEffect === DelWindowSpecialEffect.None)
                    window.color = DelTheme.Primary.colorBgBase;
                background.color = DelTheme.Primary.colorBgBase;
                window.setCaptionMode(DelTheme.isDark);
            }
        }

        NumberAnimation on width {
            running: !DelTheme.isDark
            properties: "width,height"
            target: themeCircle
            from: themeCircle.r * 2
            to: 0
            duration: DelTheme.Primary.durationMid
            onStarted: {
                themeCircle.visible = true;
                if (window.specialEffect === DelWindowSpecialEffect.None)
                    window.color = DelTheme.Primary.colorBgBase;
                background.color = DelTheme.Primary.colorBgBase;
                window.setCaptionMode(DelTheme.isDark);
            }
            onFinished: {
                themeCircle.width = 0;
                themeCircle.height = 0;
            }
        }
    }

    Item {
        id: content
        anchors.top: window.captionBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        DelMenu {
            id: menu
            width: 300
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            defaultIconSize: DelTheme.Primary.fontPrimarySizeHeading5
            onClickMenu: function(deep, data) {
                console.debug("onClickMenu", deep, JSON.stringify(data));
                if (data && data.source) {
                    containerLoader.source = "";
                    containerLoader.source = data.source;
                }
            }
            model: [
                {
                    title: qsTr("首页"),
                    iconSource: DelIcon.HomeOutlined
                },
                {
                    title: qsTr("通用"),
                    iconSource: DelIcon.ProductOutlined,
                    menuChildren: [
                        {
                            title: qsTr("DelButton 按钮"),
                            source: "./Examples/General/ExpButton.qml"
                        },
                        {
                            title: qsTr("DelIconText 图标文本"),
                            source: "./Examples/General/ExpIconText.qml"
                        }
                    ]
                },
                {
                    title: qsTr("布局"),
                    iconSource: DelIcon.ProductOutlined,
                    menuChildren: [
                        {
                            title: qsTr("DelDivider 分割线"),
                            source: "./Examples/Layout/ExpDivider.qml"
                        }
                    ]
                },
                {
                    title: qsTr("导航"),
                    iconSource: DelIcon.SendOutlined,
                    menuChildren: [
                        {
                            title: qsTr("DelMenu 菜单"),
                            source: "./Examples/Navigation/ExpMenu.qml",
                        }
                    ]
                },
                {
                    title: qsTr("数据录入"),
                    iconSource: DelIcon.InsertRowBelowOutlined,
                    menuChildren: [
                    ]
                },
                {
                    title: qsTr("数据展示"),
                    iconSource: DelIcon.FundProjectionScreenOutlined,
                    menuChildren: [
                        {
                            title: qsTr("DelTourStep 漫游式引导"),
                            source: "./Examples/DataDisplay/ExpTourStep.qml",
                        }
                    ]
                },
                {
                    title: qsTr("主题"),
                    iconSource: DelIcon.SkinOutlined,
                    menuChildren: [
                        {
                            title: qsTr("DelTheme 主题定制"),
                            source: "./Examples/Theme/ExpTheme.qml",
                        }
                    ]
                }
            ]
        }

        Item {
            id: container
            anchors.left: menu.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5
            clip: true

            Loader {
                id: containerLoader
                anchors.fill: parent

                NumberAnimation on opacity {
                    running: containerLoader.status == Loader.Ready
                    from: 0
                    to: 1
                    duration: DelTheme.Primary.durationSlow
                }
            }
        }
    }
}

pragma ComponentBehavior: Bound

import QtQuick
import DelegateUI

DelWindow {
    id: galleryWindow
    width: 1200
    height: 800
    minimumWidth: 800
    minimumHeight: 600
    title: qsTr("DelegateUI Gallery")
    followThemeSwitch: false
    captionBar.themeButtonVisible: true
    captionBar.topButtonVisible: true
    captionBar.winIconWidth: 22
    captionBar.winIconHeight: 22
    captionBar.winIconDelegate: Item {
        DelIconText {
            iconSize: 22
            colorIcon: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath1
        }
        DelIconText {
            iconSize: 22
            colorIcon: "#C44545"
            font.bold: true
            iconSource: DelIcon.DelegateUIPath2
        }
    }
    captionBar.topCallback: (checked) => {
                                DelApi.setWindowStaysOnTopHint(galleryWindow, checked);
                            }

    Component.onCompleted: {
        setSpecialEffect(DelWindow.MicaAlt);
    }

    Rectangle {
        id: galleryBackground
        anchors.fill: content
        opacity: 0.2
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
            onStarted: {
                galleryWindow.setWindowMode(true);
                themeCircle.visible = true;
            }
            onFinished: {
                themeCircle.visible = false;
                themeCircle.width = Qt.binding(()=>themeCircle.r * 2);
                themeCircle.height = Qt.binding(()=>themeCircle.r * 2);
                if (galleryWindow.specialEffect === DelWindow.None)
                    galleryWindow.color = DelTheme.Primary.colorBgBase;
                galleryBackground.color = DelTheme.Primary.colorBgBase;
            }
        }

        NumberAnimation {
            running: !DelTheme.isDark
            properties: "width,height"
            target: themeCircle
            from: themeCircle.r * 2
            to: 0
            duration: DelTheme.Primary.durationMid
            onStarted: {
                galleryWindow.setWindowMode(false);
                themeCircle.visible = true;
                if (galleryWindow.specialEffect === DelWindow.None)
                    galleryWindow.color = DelTheme.Primary.colorBgBase;
                galleryBackground.color = DelTheme.Primary.colorBgBase;
            }
            onFinished: {
                themeCircle.width = 0;
                themeCircle.height = 0;
            }
        }
    }

    Item {
        id: content
        anchors.top: galleryWindow.captionBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        DelMenu {
            id: galleryMenu
            width: 300
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: aboutButton.top
            defaultIconSize: DelTheme.Primary.fontPrimarySizeHeading5
            onClickMenu: function(deep, key, data) {
                console.debug("onClickMenu", deep, key, JSON.stringify(data));
                if (data && data.source) {
                    containerLoader.visible = true;
                    themeLoader.visible = false;
                    containerLoader.source = "";
                    containerLoader.source = data.source;
                } else if (data && data.isTheme) {
                    containerLoader.visible = false;
                    themeLoader.visible = true;
                }
            }
            defaultSelectedKey: ["HomePage"]
            initModel: [
                {
                    key: "HomePage",
                    title: qsTr("首页"),
                    iconSource: DelIcon.HomeOutlined,
                    source: "./HomePage.qml"
                },
                {
                    title: qsTr("通用"),
                    iconSource: DelIcon.ProductOutlined,
                    menuChildren: [
                        {
                            key: "DelWindow",
                            title: qsTr("DelWindow 无边框窗口"),
                            source: "./Examples/General/ExpWindow.qml"
                        },
                        {
                            key: "DelButton",
                            title: qsTr("DelButton 按钮"),
                            source: "./Examples/General/ExpButton.qml"
                        },
                        {
                            key: "DelIconButton",
                            title: qsTr("DelIconButton 图标按钮"),
                            source: "./Examples/General/ExpIconButton.qml"
                        },
                        {
                            key: "DelCaptionButton",
                            title: qsTr("DelCaptionButton 标题按钮"),
                            source: "./Examples/General/ExpCaptionButton.qml"
                        },
                        {
                            key: "DelIconText",
                            title: qsTr("DelIconText 图标文本"),
                            source: "./Examples/General/ExpIconText.qml"
                        },
                        {
                            key: "DelCopyableText",
                            title: qsTr("DelCopyableText 可复制文本"),
                            source: "./Examples/General/ExpCopyableText.qml"
                        },
                        {
                            key: "DelRectangle",
                            title: qsTr("DelRectangle 圆角矩形"),
                            source: "./Examples/General/ExpRectangle.qml"
                        }
                    ]
                },
                {
                    title: qsTr("布局"),
                    iconSource: DelIcon.BarsOutlined,
                    menuChildren: [
                        {
                            key: "DelDivider",
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
                            key: "DelMenu",
                            title: qsTr("DelMenu 菜单"),
                            source: "./Examples/Navigation/ExpMenu.qml",
                        },
                        {
                            key: "DelScrollBar",
                            title: qsTr("DelScrollBar 滚动条"),
                            source: "./Examples/Navigation/ExpScrollBar.qml",
                        }
                    ]
                },
                {
                    title: qsTr("数据录入"),
                    iconSource: DelIcon.InsertRowBelowOutlined,
                    menuChildren: [
                        {
                            key: "DelSwitch",
                            title: qsTr("DelSwitch 开关"),
                            source: "./Examples/DataEntry/ExpSwitch.qml",
                        },
                        {
                            key: "DelSlider",
                            title: qsTr("DelSlider 滑动输入条"),
                            source: "./Examples/DataEntry/ExpSlider.qml",
                        },
                        {
                            key: "DelSelect",
                            title: qsTr("DelSelect 选择器"),
                            source: "./Examples/DataEntry/ExpSelect.qml",
                        },
                        {
                            key: "DelInput",
                            title: qsTr("DelInput 输入框"),
                            source: "./Examples/DataEntry/ExpInput.qml",
                        },
                        {
                            key: "DelOTPInput",
                            title: qsTr("DelOTPInput 一次性口令输入框"),
                            source: "./Examples/DataEntry/ExpOTPInput.qml",
                        },
                        {
                            key: "DelRate",
                            title: qsTr("DelRate 评分"),
                            source: "./Examples/DataEntry/ExpRate.qml",
                        },
                        {
                            key: "DelRadio",
                            title: qsTr("DelRadio 单选框"),
                            source: "./Examples/DataEntry/ExpRadio.qml",
                        },
                        {
                            key: "DelRadioBlock",
                            title: qsTr("DelRadioBlock 单选块"),
                            source: "./Examples/DataEntry/ExpRadioBlock.qml",
                        },
                        {
                            key: "DelCheckBox",
                            title: qsTr("DelCheckBox 多选框"),
                            source: "./Examples/DataEntry/ExpCheckBox.qml",
                        },
                        {
                            key: "DelTimePicker",
                            title: qsTr("DelTimePicker 时间选择框"),
                            source: "./Examples/DataEntry/ExpTimePicker.qml",
                        }
                    ]
                },
                {
                    title: qsTr("数据展示"),
                    iconSource: DelIcon.FundProjectionScreenOutlined,
                    menuChildren: [
                        {
                            key: "DelToolTip",
                            title: qsTr("DelToolTip 文字提示"),
                            source: "./Examples/DataDisplay/ExpToolTip.qml",
                        },
                        {
                            key: "DelTourFocus",
                            title: qsTr("DelTourFocus 漫游焦点"),
                            source: "./Examples/DataDisplay/ExpTourFocus.qml",
                        },
                        {
                            key: "DelTourStep",
                            title: qsTr("DelTourStep 漫游式引导"),
                            source: "./Examples/DataDisplay/ExpTourStep.qml",
                        },
                        {
                            key: "DelTabView",
                            title: qsTr("DelTabView 标签视图"),
                            source: "./Examples/DataDisplay/ExpTabView.qml",
                        },
                        {
                            key: "DelCollapse",
                            title: qsTr("DelCollapse 折叠面板"),
                            source: "./Examples/DataDisplay/ExpCollapse.qml",
                        },
                        {
                            key: "DelAvatar",
                            title: qsTr("DelAvatar 头像"),
                            source: "./Examples/DataDisplay/ExpAvatar.qml",
                        },
                        {
                            key: "DelCard",
                            title: qsTr("DelCard 卡片"),
                            source: "./Examples/DataDisplay/ExpCard.qml",
                        }
                    ]
                },
                {
                    title: qsTr("效果"),
                    iconSource: DelIcon.FireOutlined,
                    menuChildren: [
                        {
                            key: "DelAcrylic",
                            title: qsTr("DelAcrylic 亚克力效果"),
                            source: "./Examples/Effect/ExpAcrylic.qml",
                        }
                    ]
                },
                {
                    title: qsTr("工具"),
                    iconSource: DelIcon.ToolOutlined,
                    menuChildren: [
                        {
                            key: "DelAsyncHasher",
                            title: qsTr("DelAsyncHasher 异步哈希器"),
                            source: "./Examples/Utils/ExpAsyncHasher.qml",
                        }
                    ]
                },
                {
                    title: qsTr("反馈"),
                    iconSource: DelIcon.MessageOutlined,
                    menuChildren: [
                        {
                            key: "DelWatermark",
                            title: qsTr("DelWatermark 水印"),
                            source: "./Examples/Feedback/ExpWatermark.qml",
                        },
                        {
                            key: "DelDrawer",
                            title: qsTr("DelDrawer 抽屉"),
                            source: "./Examples/Feedback/ExpDrawer.qml",
                        }
                    ]
                },
                {
                    title: qsTr("主题"),
                    iconSource: DelIcon.SkinOutlined,
                    menuChildren: [
                        {
                            key: "DelTheme",
                            title: qsTr("DelTheme 主题定制"),
                            isTheme: true
                        }
                    ]
                }
            ]
        }

        DelDivider {
            width: galleryMenu.width
            height: 1
            anchors.bottom: aboutButton.top
        }

        Loader {
            id: aboutLoader
            visible: false
            sourceComponent: AboutPage { visible: aboutLoader.visible }
        }

        Loader {
            id: settingsLoader
            visible: false
            sourceComponent: SettingsPage { visible: settingsLoader.visible }
        }

        DelIconButton {
            id: aboutButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: setttingsButton.top
            type: DelButton.Type_Text
            radiusBg: 0
            text: qsTr("关于")
            colorText: DelTheme.Primary.colorTextBase
            iconSource: DelIcon.UserOutlined
            onClicked: {
                if (aboutLoader.visible)
                    aboutLoader.visible = false;
                else {
                    aboutLoader.visible = true;
                    settingsLoader.visible = false;
                }
            }
        }

        DelIconButton {
            id: setttingsButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: parent.bottom
            type: DelButton.Type_Text
            radiusBg: 0
            text: qsTr("设置")
            colorText: DelTheme.Primary.colorTextBase
            iconSource: DelIcon.SettingOutlined
            onClicked: {
                if (settingsLoader.visible)
                    settingsLoader.visible = false;
                else {
                    settingsLoader.visible = true;
                    aboutLoader.visible = false;
                }
            }
        }

        Item {
            id: container
            anchors.left: galleryMenu.right
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

            Loader {
                id: themeLoader
                anchors.fill: parent
                source: "./Examples/Theme/ExpTheme.qml"
                visible: false
            }
        }
    }
}

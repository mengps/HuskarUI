pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic
import Gallery

import './Home'

HusWindow {
    id: galleryWindow
    width: 1300
    height: 850
    opacity: 0
    minimumWidth: 800
    minimumHeight: 600
    title: qsTr('HuskarUI Gallery')
    followThemeSwitch: true
    captionBar.visible: Qt.platform.os === 'windows' || Qt.platform.os === 'linux' || Qt.platform.os === 'osx'
    captionBar.height: captionBar.visible ? 30 : 0
    captionBar.color: HusTheme.Primary.colorFillTertiary
    captionBar.themeButtonVisible: true
    captionBar.topButtonVisible: true
    captionBar.winIconWidth: 22
    captionBar.winIconHeight: 22
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/huskarui_icon.svg'
        }
    }
    captionBar.themeCallback: () => {
        themeSwitchLoader.active = true;
    }
    captionBar.topCallback: (checked) => {
        HusApi.setWindowStaysOnTopHint(galleryWindow, checked);
    }
    Component.onCompleted: {
        if (Qt.platform.os === 'windows') {
            if (setSpecialEffect(HusWindow.Win_MicaAlt)) return;
            if (setSpecialEffect(HusWindow.Win_Mica)) return;
            if (setSpecialEffect(HusWindow.Win_AcrylicMaterial)) return;
            if (setSpecialEffect(HusWindow.Win_DwmBlur)) return;
        } else if (Qt.platform.os === 'osx') {
            if (setSpecialEffect(HusWindow.Mac_BlurEffect)) return;
        }
    }
    onWidthChanged: {
        galleryMenu.compactMode = width < 1100;
    }

    property var galleryGlobal: Global { }

    Behavior on opacity { NumberAnimation { } }

    Timer {
        running: true
        interval: 200
        onTriggered: {
            galleryWindow.opacity = 1;
        }
    }

    Rectangle {
        id: galleryBackground
        anchors.fill: content
        color: '#f5f5f5'
        opacity: 0.2
    }

    Loader {
        id: themeSwitchLoader
        z: 65536
        active: false
        anchors.fill: galleryWindow.contentItem
        sourceComponent: ThemeSwitchItem {
            opacity: galleryWindow.specialEffect == HusWindow.None ? 1.0 : galleryBackground.opacity
            target: galleryWindow.contentItem
            isDark: HusTheme.isDark
            onSwitchStarted: {
                galleryBackground.color = HusTheme.isDark ? '#f5f5f5' : '#181818';
                themeSwitchLoader.changeDark();
            }
            onAnimationFinished: {
                if (galleryWindow.specialEffect === HusWindow.None)
                    galleryWindow.color = HusTheme.Primary.colorBgBase;
                themeSwitchLoader.active = false;
            }
            Component.onCompleted: {
                colorBg = HusTheme.isDark ? '#f5f5f5' : '#181818';
                const distance = function(x1, y1, x2, y2) {
                    return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
                }
                const startX = content.width - 170;
                const startY = 0;
                const radius = Math.max(distance(startX, startY, 0, 0),
                                        distance(startX, startY, content.width, 0),
                                        distance(startX, startY, 0, content.height),
                                        distance(startX, startY, content.width, content.height));
                start(width, height, Qt.point(startX, startY), radius);
            }
        }

        function changeDark() {
            HusTheme.darkMode = HusTheme.isDark ? HusTheme.Light : HusTheme.Dark;
        }

        Connections {
            target: HusTheme
            function onIsDarkChanged() {
                if (HusTheme.darkMode == HusTheme.System) {
                    galleryWindow.setWindowMode(HusTheme.isDark);
                    galleryBackground.color = HusTheme.isDark ? '#181818' : '#f5f5f5';
                }
            }
        }
    }

    Item {
        id: content
        anchors.top: galleryWindow.captionBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: authorCard
            width: visible ? galleryMenu.defaultMenuWidth : 0
            height: visible ? 80 : 0
            anchors.top: parent.top
            anchors.topMargin: 5
            radius: HusTheme.Primary.radiusPrimary
            color: hovered ? HusTheme.isDark ? '#10ffffff' : '#10000000' : 'transparent'
            visible: !galleryMenu.compactMode
            clip: true

            property bool hovered: authorCardHover.hovered

            Behavior on height { NumberAnimation { duration: HusTheme.Primary.durationFast } }
            Behavior on color { ColorAnimation { duration: HusTheme.Primary.durationFast } }

            Item {
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10

                HusAvatar {
                    id: avatarIcon
                    size: 60
                    anchors.verticalCenter: parent.verticalCenter
                    imageSource: 'https://avatars.githubusercontent.com/u/33405710?v=4'
                }

                Column {
                    anchors.left: avatarIcon.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    HusText {
                        text: 'MenPenS'
                        font.weight: Font.DemiBold
                        font.italic: true
                        font.pixelSize: HusTheme.Primary.fontPrimarySize + 1
                    }

                    HusText {
                        text: '843261040@qq.com'
                        font.pixelSize: HusTheme.Primary.fontPrimarySize - 1
                        color: HusTheme.Primary.colorTextSecondary
                    }

                    HusText {
                        width: parent.width
                        text: 'https://github.com/mengps'
                        font.pixelSize: HusTheme.Primary.fontPrimarySize - 1
                        color: HusTheme.Primary.colorTextSecondary
                        wrapMode: HusText.WrapAnywhere
                    }
                }
            }

            HoverHandler {
                id: authorCardHover
            }

            TapHandler {
                onTapped: {
                    Qt.openUrlExternally('https://github.com/mengps');
                }
            }
        }

        HusAutoComplete {
            id: searchComponent
            property bool expanded: false
            z: 10
            clip: true
            width: (!galleryMenu.compactMode || expanded) ? (galleryMenu.defaultMenuWidth - 20) : 0
            anchors.top: authorCard.bottom
            anchors.left: !galleryMenu.compactMode ? galleryMenu.left : galleryMenu.right
            anchors.margins: 10
            topPadding: 6
            bottomPadding: 6
            rightPadding: 50
            tooltipVisible: true
            placeholderText: qsTr('搜索组件')
            iconSource: HusIcon.SearchOutlined
            colorBg: galleryMenu.compactMode ? HusTheme.HusInput.colorBg : 'transparent'
            options: galleryGlobal.options
            filterOption: function(input, option) {
                return option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1;
            }
            onSelect: function(option) {
                galleryMenu.gotoMenu(option.key);
            }
            labelDelegate: HusText {
                height: implicitHeight + 4
                text: parent.textData
                color: HusTheme.HusAutoComplete.colorItemText
                font {
                    family: HusTheme.HusAutoComplete.fontFamily
                    pixelSize: HusTheme.HusAutoComplete.fontSize
                    weight: parent.highlighted ? Font.DemiBold : Font.Normal
                }
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter

                property var model: parent.modelData
                property string tagState: model.state ?? ''

                HusTag {
                    id: __tag
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: parent.tagState
                    presetColor: parent.tagState === 'New' ? 'red' : 'green'
                    visible: parent.tagState !== ''
                }
            }

            Keys.onEscapePressed: {
                if (expanded) {
                    expanded = false;
                } else {
                    closePopup();
                }
            }

            Behavior on width {
                enabled: galleryMenu.compactMode && galleryMenu.width === galleryMenu.compactWidth
                NumberAnimation { duration: HusTheme.Primary.durationFast }
            }
        }

        HusIconButton {
            id: searchCollapse
            visible: galleryMenu.compactMode
            anchors.top: parent.top
            anchors.left: galleryMenu.left
            anchors.right: galleryMenu.right
            anchors.margins: 10
            type: HusButton.Type_Text
            colorText: HusTheme.Primary.colorTextBase
            iconSource: HusIcon.SearchOutlined
            iconSize: searchComponent.iconSize
            onClicked: {
                searchComponent.expanded = !searchComponent.expanded;
                if (searchComponent.expanded) {
                    searchComponent.forceActiveFocus();
                }
            }
            onVisibleChanged: {
                if (visible) {
                    searchComponent.closePopup();
                    searchComponent.expanded = false;
                }
            }
        }

        HusMenu {
            id: galleryMenu
            anchors.left: parent.left
            anchors.top: searchComponent.bottom
            anchors.bottom: creatorButton.top
            showEdge: true
            tooltipVisible: true
            defaultMenuWidth: 300
            defaultSelectedKey: ['HomePage']
            initModel: galleryGlobal.menus
            menuLabelDelegate: Item {
                property var model: parent.model
                property var menuButton: parent.menuButton
                property string tagState: model.state ?? ''

                HusText {
                    anchors.left: parent.left
                    anchors.leftMargin: menuButton.iconSpacing
                    anchors.right: __tag.left
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: menuButton.text
                    font: menuButton.font
                    color: menuButton.colorText
                    elide: Text.ElideRight
                }

                HusTag {
                    id: __tag
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: parent.tagState
                    presetColor: parent.tagState === 'New' ? 'red' : 'green'
                    visible: parent.tagState !== ''
                }
            }
            menuBackgroundDelegate: Rectangle {
                radius: menuButton.radiusBg
                color: menuButton.colorBg
                border.color: menuButton.colorBorder
                border.width: 1

                property var model: parent.model
                property var menuButton: parent.menuButton
                property string badgeState: model.badgeState ?? ''

                Behavior on color { enabled: galleryMenu.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
                Behavior on border.color { enabled: galleryMenu.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

                HusBadge {
                    anchors.left: undefined
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: undefined
                    anchors.margins: 1
                    dot: true
                    presetColor: parent.badgeState == 'New' ? 'red' : 'green'
                    visible: parent.badgeState !== ''
                }
            }
            onClickMenu: function(deep, key, keyPath, data) {
                if (data) {
                    if (data.hasOwnProperty('menuChildren')) {
                        setDataProperty(key, 'badgeState', '');
                    } else {
                        console.debug('onClickMenu', deep, key, keyPath, JSON.stringify(data));
                        containerLoader.version = data.addVersion || data.updateVersion || '';
                        containerLoader.desc = data.desc || '';
                        containerLoader.tagState = data.state || '';
                        gallerySwitchEffect.switchToSource(data.source);
                    }
                }
            }
        }

        HusDivider {
            width: galleryMenu.width
            height: 1
            anchors.bottom: creatorButton.top
        }

        Loader {
            id: creatorLoader
            active: false
            visible: false
            sourceComponent: CreatorPage { visible: creatorLoader.visible }
        }

        Loader {
            id: aboutLoader
            active: false
            visible: false
            sourceComponent: AboutPage { visible: aboutLoader.visible }
        }

        Loader {
            id: settingsLoader
            active: false
            visible: false
            sourceComponent: SettingsPage { visible: settingsLoader.visible }
        }

        HusIconButton {
            id: creatorButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: aboutButton.top
            type: HusButton.Type_Text
            radiusBg: 0
            text: galleryMenu.compactMode ? '' : qsTr('创建')
            colorText: HusTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
            iconSource: HusIcon.PlusCircleOutlined
            onClicked: {
                if (!creatorLoader.active)
                    creatorLoader.active = true;
                creatorLoader.visible = !creatorLoader.visible;
            }
        }

        HusIconButton {
            id: aboutButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: setttingsButton.top
            type: HusButton.Type_Text
            radiusBg: 0
            text: galleryMenu.compactMode ? '' : qsTr('关于')
            colorText: HusTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
            iconSource: HusIcon.UserOutlined
            onClicked: {
                if (!aboutLoader.active)
                    aboutLoader.active = true;
                aboutLoader.visible = !aboutLoader.visible;
            }
        }

        HusIconButton {
            id: setttingsButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: parent.bottom
            type: HusButton.Type_Text
            radiusBg: 0
            text: galleryMenu.compactMode ? '' : qsTr('设置')
            colorText: HusTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
            iconSource: HusIcon.SettingOutlined
            onClicked: {
                if (!settingsLoader.active)
                    settingsLoader.active = true;
                settingsLoader.visible = !settingsLoader.visible;
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

            property string source: ''

            HusSwitchEffect {
                id: gallerySwitchEffect
                anchors.fill: parent
                duration: 0
                type: HusSwitchEffect.Type_None
                maskScale: animationTime * 3
                maskRotation: (1.0 - animationTime) * 360
                onFinished: {
                    containerLoader.source = container.source;
                    containerLoader.visible = true;
                }

                function switchToSource(source) {
                    if (container.source !== source) {
                        container.source = source;
                        nextLoader.source = source;
                        containerLoader.visible = false;
                        gallerySwitchEffect.startSwitch(containerLoader, nextLoader);
                    }
                }
            }

            Loader {
                id: nextLoader
                anchors.fill: parent
                visible: false
            }

            Loader {
                id: containerLoader
                anchors.fill: parent
                visible: false
                property string tagState: ''
                property string version: ''
                property string desc: ''
            }
        }
    }
}

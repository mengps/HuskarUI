pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import HuskarUI.Basic
import Gallery

import './Home'

HusWindow {
    id: galleryWindow
    width: 1400
    height: 900
    opacity: 0
    minimumWidth: 800
    minimumHeight: 600
    title: qsTr(`${HusApp.libName()} Gallery`)
    followThemeSwitch: true
    captionBar.visible: Qt.platform.os === 'windows' || Qt.platform.os === 'linux' || Qt.platform.os === 'osx'
    captionBar.height: captionBar.visible ? 30 : 0
    captionBar.color: HusTheme.Primary.colorFillTertiary
    captionBar.showThemeButton: true
    captionBar.showTopButton: true
    captionBar.showWinIcon: Qt.platform.os !== 'osx'
    captionBar.winIconWidth: 22
    captionBar.winIconHeight: 22
    captionBar.winIconDelegate: Item {
        Image {
            width: 16
            height: 16
            anchors.centerIn: parent
            source: 'qrc:/Gallery/images/huskarui_new_square.svg'
        }
    }
    captionBar.themeCallback: () => {
        themeSwitchLoader.active = true;
    }
    captionBar.topCallback: (checked) => {
        HusApi.setWindowStaysOnTopHint(galleryWindow, checked);
    }
    captionBar.winTitleDelegate: RowLayout {
        layoutDirection: captionBar.mirrored ? Qt.RightToLeft : Qt.LeftToRight
        spacing: 0

        Connections {
            target: captionBar
            function onWindowAgentChanged() {
                captionBar.addInteractionItem(goBackButton);
                captionBar.addInteractionItem(goForwardButton);
                captionBar.addInteractionItem(historyButton);
            }
        }

        HusText {
            text: captionBar.winTitle
            color: captionBar.winTitleColor
            font: captionBar.winTitleFont
        }

        HusCaptionButton {
            id: goBackButton
            Layout.leftMargin: 10
            Layout.fillHeight: true
            noDisabledState: true
            enabled: galleryRouter.canGoBack
            hoverCursorShape: Qt.PointingHandCursor
            iconSource: HusIcon.ArrowLeftOutlined
            iconSize: 14
            colorIcon: enabled ? themeSource.colorIcon :
                                 themeSource.colorIconDisabled
            colorBg: {
                if (enabled) {
                    return active ? themeSource.colorBgActive :
                                    hovered ? themeSource.colorBgHover : 'transparent';
                } else {
                    return 'transparent';
                }
            }
            contentDescription: qsTr('后退')
            onClicked: galleryRouter.goBack();

            HusToolTip {
                visible: parent.hovered
                showArrow: true
                position: HusToolTip.Position_Bottom
                text: parent.contentDescription
            }
        }

        HusCaptionButton {
            id: goForwardButton
            Layout.fillHeight: true
            noDisabledState: true
            enabled: galleryRouter.canGoForward
            hoverCursorShape: Qt.PointingHandCursor
            iconSource: HusIcon.ArrowRightOutlined
            iconSize: 14
            colorIcon: enabled ? themeSource.colorIcon :
                                 themeSource.colorIconDisabled
            colorBg: {
                if (enabled) {
                    return active ? themeSource.colorBgActive :
                                    hovered ? themeSource.colorBgHover : 'transparent';
                } else {
                    return 'transparent';
                }
            }
            contentDescription: qsTr('前进')
            onClicked: galleryRouter.goForward();

            HusToolTip {
                visible: parent.hovered
                showArrow: true
                position: HusToolTip.Position_Bottom
                text: parent.contentDescription
            }
        }

        HusCaptionButton {
            id: historyButton
            Layout.fillHeight: true
            noDisabledState: true
            hoverCursorShape: Qt.PointingHandCursor
            iconSource: HusIcon.HistoryOutlined
            iconSize: 14
            contentDescription: qsTr('历史记录')
            onClicked: historyPopup.open();

            HusToolTip {
                visible: parent.hovered
                showArrow: true
                position: HusToolTip.Position_Bottom
                text: parent.contentDescription
            }

            HusPopup {
                id: historyPopup
                x: (parent.width - width) * 0.5
                y: parent.height
                padding: 5
                contentItem: ListView {
                    implicitWidth: 180
                    implicitHeight: Math.min(contentHeight, 300)
                    clip: true
                    model: galleryRouter.history
                    delegate: HusButton {
                        width: ListView.view.width
                        effectEnabled: false
                        text: urlData.label
                        colorBorder: 'transparent'
                        radiusBg.all: 0
                        onClicked: galleryRouter.gotoUrl(modelData.location);
                        required property var modelData
                        property var urlData: galleryRouter.urlDataMap.get(modelData.location)
                    }
                    ScrollBar.vertical: HusScrollBar { }
                }
            }
        }
    }
    captionBar.winPresetButtonsDelegate: RowLayout {
        layoutDirection: captionBar.mirrored ? Qt.RightToLeft : Qt.LeftToRight
        spacing: 0

        Connections {
            target: captionBar
            function onWindowAgentChanged() {
                captionBar.addInteractionItem(wikiButton);
                captionBar.addInteractionItem(themeButton);
                captionBar.addInteractionItem(topButton);
            }
        }

        HusCaptionButton {
            id: wikiButton
            Layout.fillHeight: true
            noDisabledState: true
            text: qsTr('在线 Wiki (AI)')
            colorText: HusTheme.Primary.colorTextBase
            iconSize: 14
            iconSource: HusIcon.BookOutlined
            background: Item {
                ShaderEffect {
                    anchors.fill: parent
                    vertexShader: 'qrc:/Gallery/shaders/effect2.vert.qsb'
                    fragmentShader: 'qrc:/Gallery/shaders/effect2.frag.qsb'
                    opacity: wikiButton.hovered ? 0.4 : 0.25

                    property vector3d iResolution: Qt.vector3d(width, height, 0)
                    property real iTime: 0

                    Timer {
                        running: true
                        repeat: true
                        interval: 16
                        onTriggered: parent.iTime += 0.03;
                    }
                }
            }
            onClicked: {
                Qt.openUrlExternally(`https://deepwiki.com/mengps/${HusApp.libName()}`);
            }

            HusToolTip {
                visible: parent.hovered
                showArrow: true
                position: HusToolTip.Position_Bottom
                text: qsTr(`在线 Wiki (AI), 可进行 ${HusApp.libName()} 相关的 AI 问答`)
            }
        }

        HusCaptionButton {
            id: themeButton
            Layout.fillHeight: true
            noDisabledState: true
            iconSource: HusTheme.isDark ? HusIcon.MoonOutlined : HusIcon.SunOutlined
            iconSize: 14
            contentDescription: qsTr('明暗主题切换')
            onClicked: captionBar.themeCallback();
        }

        HusCaptionButton {
            id: topButton
            Layout.fillHeight: true
            noDisabledState: true
            iconSource: HusIcon.PushpinOutlined
            iconSize: 14
            checkable: true
            checked: captionBar.topButtonChecked
            contentDescription: qsTr('置顶')
            onClicked: captionBar.topCallback(checked);
        }
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
        color: HusTheme.isDark ? '#181818' : '#f5f5f5'
        opacity: 0.2
    }

    HusRouter {
        id: galleryRouter
        property var urlDataMap: new Map
        function gotoUrl(url) {
            if (urlDataMap.has(url)) {
                const data = urlDataMap.get((url));
                containerLoader.version = data.addVersion || data.updateVersion || '';
                containerLoader.desc = data.desc || '';
                containerLoader.tagState = data.state || '';
                galleryMenu.gotoMenu(data.key);
                gallerySwitchEffect.switchToSource(data.source);
            }
        }
        onCurrentUrlChanged: gotoUrl(currentUrl);
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
                if (HusTheme.darkMode === HusTheme.System) {
                    galleryWindow.setWindowMode(HusTheme.isDark);
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
            visible: galleryMenu.compactMode === HusMenu.Mode_Relaxed
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
            width: (galleryMenu.compactMode === HusMenu.Mode_Relaxed || expanded) ? (galleryMenu.defaultMenuWidth - 20) : 0
            anchors.top: authorCard.bottom
            anchors.left: galleryMenu.compactMode === HusMenu.Mode_Relaxed ? galleryMenu.left : galleryMenu.right
            anchors.margins: 10
            topPadding: 6
            bottomPadding: 6
            rightPadding: 50
            showToolTip: true
            placeholderText: qsTr('搜索组件')
            iconSource: HusIcon.SearchOutlined
            colorBg: !(galleryMenu.compactMode === HusMenu.Mode_Relaxed) ? HusTheme.HusInput.colorBg : 'transparent'
            options: galleryGlobal.options
            filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
            onSelect: option => galleryMenu.gotoMenu(option.key)
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
                enabled: !(galleryMenu.compactMode === HusMenu.Mode_Relaxed) &&
                         galleryMenu.width === galleryMenu.compactWidth
                NumberAnimation { duration: HusTheme.Primary.durationFast }
            }
        }

        HusIconButton {
            id: searchCollapse
            visible: !(galleryMenu.compactMode === HusMenu.Mode_Relaxed)
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
            anchors.bottom: buttonsColumn.top
            showEdge: true
            showToolTip: true
            defaultMenuWidth: 300
            defaultSelectedKey: ['HomePage']
            initModel: galleryGlobal.menus
            menuLabelDelegate: HusText {
                text: menuButton.text
                font: menuButton.font
                color: menuButton.colorText
                elide: Text.ElideRight

                property var model: parent.model
                property var menuButton: parent.menuButton
                property string tagState: model.state ?? ''

                HusTag {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: parent.tagState
                    presetColor: parent.tagState === 'New' ? 'red' : 'green'
                    visible: parent.tagState !== ''
                }
            }
            menuBgDelegate: Rectangle {
                radius: menuButton.radiusBg.all
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
                        galleryRouter.urlDataMap.set(Qt.url(data.source), data);
                        galleryRouter.push(data.source);
                        console.debug('onClickMenu', deep, key, keyPath, JSON.stringify(data));
                    }
                }
            }
            onSelectedKeyChanged: {
            }
        }

        HusDivider {
            width: galleryMenu.width
            height: 5
            anchors.bottom: buttonsColumn.top
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

        Column {
            id: buttonsColumn
            width: galleryMenu.width
            anchors.bottom: parent.bottom

            HusIconButton {
                id: creatorButton
                width: parent.width
                height: 40
                type: HusButton.Type_Text
                radiusBg.all: 0
                text: galleryMenu.compactMode !== HusMenu.Mode_Relaxed ? '' : qsTr('创建')
                colorText: HusTheme.Primary.colorTextBase
                iconSize: galleryMenu.defaultMenuIconSize
                iconSource: HusIcon.PlusCircleOutlined
                visible: HusApp.libName() === 'HuskarUI'
                onClicked: {
                    if (!creatorLoader.active)
                        creatorLoader.active = true;
                    creatorLoader.visible = !creatorLoader.visible;
                }

                HusToolTip {
                    visible: parent.hovered
                    showArrow: true
                    text: qsTr('创建新项目')
                }
            }

            HusIconButton {
                id: aboutButton
                width: parent.width
                height: 40
                type: HusButton.Type_Text
                radiusBg.all: 0
                text: galleryMenu.compactMode !== HusMenu.Mode_Relaxed ? '' : qsTr('关于')
                colorText: HusTheme.Primary.colorTextBase
                iconSize: galleryMenu.defaultMenuIconSize
                iconSource: HusIcon.UserOutlined
                onClicked: {
                    if (!aboutLoader.active)
                        aboutLoader.active = true;
                    aboutLoader.visible = !aboutLoader.visible;
                }

                HusToolTip {
                    visible: parent.hovered
                    showArrow: true
                    text: qsTr('关于')
                }
            }

            HusIconButton {
                id: setttingsButton
                width: parent.width
                height: 40
                type: HusButton.Type_Text
                radiusBg.all: 0
                text: galleryMenu.compactMode !== HusMenu.Mode_Relaxed ? '' : qsTr('设置')
                colorText: HusTheme.Primary.colorTextBase
                iconSize: galleryMenu.defaultMenuIconSize
                iconSource: HusIcon.SettingOutlined
                onClicked: {
                    if (!settingsLoader.active)
                        settingsLoader.active = true;
                    settingsLoader.visible = !settingsLoader.visible;
                }

                HusToolTip {
                    visible: parent.hovered
                    showArrow: true
                    text: qsTr('设置')
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
                        if (type === HusSwitchEffect.Type_None) {
                            nextLoader.source = '';
                            nextLoader.visible = false;
                            containerLoader.source = source;
                            containerLoader.visible = true;
                        } else {
                            container.source = source;
                            nextLoader.source = source;
                            containerLoader.visible = false;
                            gallerySwitchEffect.startSwitch(containerLoader, nextLoader);
                        }
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

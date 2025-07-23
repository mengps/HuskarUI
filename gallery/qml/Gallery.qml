pragma ComponentBehavior: Bound

import QtQuick
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
    followThemeSwitch: false
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
        /*! 解析 Primary.tokens */
        for (const key in HusTheme.Primary) {
            primaryTokens.push({ label: `@${key}` });
        }
        /*! 解析 Component.tokens */
        const indexFile = `:/HuskarUI/theme/Index.json`;
        const indexObject = JSON.parse(HusApi.readFileToString(indexFile));
        for (const source in indexObject.componentStyle) {
            const themeFile = `:/HuskarUI/theme/${source}.json`;
            const object = JSON.parse(HusApi.readFileToString(themeFile));
            let model = [];
            for (const key in object) {
                model.push({
                               'tokenName': key,
                               'tokenValue': { 'key': key, 'value': object[key] },
                               'tokenCalcValue': key,
                           });
            }
            componentTokens[source] = model;
        }
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

    property int themeIndex: 8
    property var primaryTokens: []
    property var componentTokens: new Object

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
                galleryWindow.setWindowMode(!HusTheme.isDark);
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
            colorBg: galleryMenu.compactMode ? HusTheme.HusInput.colorBg : 'transparent'
            Component.onCompleted: {
                let model = [];
                for (let i = 0; i < galleryMenu.defaultModel.length; i++) {
                    let item = galleryMenu.defaultModel[i];
                    if (item && item.menuChildren) {
                        for (let j = 0; j < item.menuChildren.length; j++) {
                            let childItem = item.menuChildren[j];
                            if (childItem && childItem.label) {
                                model.push({
                                               'key': childItem.key,
                                               'value': childItem.key,
                                               'label': childItem.label,
                                               'state': childItem.state ?? '',
                                           });
                            }
                        }
                    }
                }
                model.sort((a, b) => a.key.localeCompare(b.key));
                options = model;
            }
            filterOption: function(input, option){
                return option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1;
            }
            onSelect: function(option) {
                galleryMenu.gotoMenu(option.key);
            }
            labelDelegate: Text {
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
            clearIconSource: searchComponent.length > 0 ? HusIcon.CloseCircleFilled : HusIcon.SearchOutlined

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
            onClicked: searchComponent.expanded = !searchComponent.expanded;
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
            menuLabelDelegate: Item {
                property var model: parent.model
                property var menuButton: parent.menuButton
                property string tagState: model.state ?? ''

                Text {
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
            onClickMenu: function(deep, key, data) {
                console.debug('onClickMenu', deep, key, JSON.stringify(data));
                if (data) {
                    gallerySwitchEffect.switchToSource(data.source);
                }
            }
            Component.onCompleted: {
                let list = [];
                for (const item of defaultModel) {
                    if (item && item.menuChildren) {
                        let hasNew = false;
                        let hasUpdate = false;
                        item.menuChildren.sort((a, b) => a.key.localeCompare(b.key));
                        item.menuChildren.forEach(
                            object => {
                                if (object.state) {
                                    if (object.state === 'New') hasNew = true;
                                    if (object.state === 'Update') hasUpdate = true;
                                }
                            });
                        if (hasNew)
                            item.badgeState = 'New';
                        else
                            item.badgeState = hasUpdate ? 'Update' : '';
                    }
                    list.push(item);
                }
                initModel = list;
            }
            property var defaultModel: [
                {
                    key: 'HomePage',
                    label: qsTr('首页'),
                    iconSource: HusIcon.HomeOutlined,
                    source: './Home/HomePage.qml'
                },
                {
                    type: 'divider'
                },
                {
                    label: qsTr('通用'),
                    iconSource: HusIcon.ProductOutlined,
                    menuChildren: [
                        {
                            key: 'HusWindow',
                            label: qsTr('HusWindow 无边框窗口'),
                            source: './Examples/General/ExpWindow.qml',
                            state: 'Update',
                        },
                        {
                            key: 'HusButton',
                            label: qsTr('HusButton 按钮'),
                            source: './Examples/General/ExpButton.qml'
                        },
                        {
                            key: 'HusIconButton',
                            label: qsTr('HusIconButton 图标按钮'),
                            source: './Examples/General/ExpIconButton.qml'
                        },
                        {
                            key: 'HusCaptionButton',
                            label: qsTr('HusCaptionButton 标题按钮'),
                            source: './Examples/General/ExpCaptionButton.qml'
                        },
                        {
                            key: 'HusIconText',
                            label: qsTr('HusIconText 图标文本'),
                            source: './Examples/General/ExpIconText.qml'
                        },
                        {
                            key: 'HusCopyableText',
                            label: qsTr('HusCopyableText 可复制文本'),
                            source: './Examples/General/ExpCopyableText.qml'
                        },
                        {
                            key: 'HusRectangle',
                            label: qsTr('HusRectangle 圆角矩形'),
                            source: './Examples/General/ExpRectangle.qml'
                        },
                        {
                            key: 'HusPopup',
                            label: qsTr('HusPopup 弹窗'),
                            source: './Examples/General/ExpPopup.qml'
                        },
                        {
                            key: 'HusText',
                            label: qsTr('HusText 文本'),
                            source: './Examples/General/ExpText.qml'
                        },
                        {
                            key: 'HusButtonBlock',
                            label: qsTr('HusButtonBlock 按钮块'),
                            source: './Examples/General/ExpButtonBlock.qml',
                            state: 'New',
                        },
                        {
                            key: 'HusMoveMouseArea',
                            label: qsTr('HusMoveMouseArea 鼠标移动区域'),
                            source: './Examples/General/ExpMoveMouseArea.qml',
                            state: 'New',
                        },
                        {
                            key: 'HusResizeMouseArea',
                            label: qsTr('HusResizeMouseArea 鼠标改变大小区域'),
                            source: './Examples/General/ExpResizeMouseArea.qml',
                            state: 'New',
                        },
                        {
                            key: 'HusCaptionBar',
                            label: qsTr('HusCaptionBar 标题栏'),
                            source: './Examples/General/ExpCaptionBar.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('布局'),
                    iconSource: HusIcon.BarsOutlined,
                    menuChildren: [
                        {
                            key: 'HusDivider',
                            label: qsTr('HusDivider 分割线'),
                            source: './Examples/Layout/ExpDivider.qml'
                        }
                    ]
                },
                {
                    label: qsTr('导航'),
                    iconSource: HusIcon.SendOutlined,
                    menuChildren: [
                        {
                            key: 'HusMenu',
                            label: qsTr('HusMenu 菜单'),
                            source: './Examples/Navigation/ExpMenu.qml',
                            state: 'Update',
                        },
                        {
                            key: 'HusScrollBar',
                            label: qsTr('HusScrollBar 滚动条'),
                            source: './Examples/Navigation/ExpScrollBar.qml',
                        },
                        {
                            key: 'HusPagination',
                            label: qsTr('HusPagination 分页'),
                            source: './Examples/Navigation/ExpPagination.qml',
                        },
                        {
                            key: 'HusContextMenu',
                            label: qsTr('HusContextMenu 上下文菜单'),
                            source: './Examples/Navigation/ExpContextMenu.qml',
                            state: 'New',
                        },
                        {
                            key: 'HusBreadcrumb',
                            label: qsTr('HusBreadcrumb 面包屑'),
                            source: './Examples/Navigation/ExpBreadcrumb.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('数据录入'),
                    iconSource: HusIcon.InsertRowBelowOutlined,
                    menuChildren: [
                        {
                            key: 'HusSwitch',
                            label: qsTr('HusSwitch 开关'),
                            source: './Examples/DataEntry/ExpSwitch.qml',
                        },
                        {
                            key: 'HusSlider',
                            label: qsTr('HusSlider 滑动输入条'),
                            source: './Examples/DataEntry/ExpSlider.qml',
                        },
                        {
                            key: 'HusSelect',
                            label: qsTr('HusSelect 选择器'),
                            source: './Examples/DataEntry/ExpSelect.qml',
                        },
                        {
                            key: 'HusInput',
                            label: qsTr('HusInput 输入框'),
                            source: './Examples/DataEntry/ExpInput.qml',
                        },
                        {
                            key: 'HusOTPInput',
                            label: qsTr('HusOTPInput 一次性口令输入框'),
                            source: './Examples/DataEntry/ExpOTPInput.qml',
                            state: 'Update',
                        },
                        {
                            key: 'HusRate',
                            label: qsTr('HusRate 评分'),
                            source: './Examples/DataEntry/ExpRate.qml',
                        },
                        {
                            key: 'HusRadio',
                            label: qsTr('HusRadio 单选框'),
                            source: './Examples/DataEntry/ExpRadio.qml',
                        },
                        {
                            key: 'HusRadioBlock',
                            label: qsTr('HusRadioBlock 单选块'),
                            source: './Examples/DataEntry/ExpRadioBlock.qml',
                        },
                        {
                            key: 'HusCheckBox',
                            label: qsTr('HusCheckBox 多选框'),
                            source: './Examples/DataEntry/ExpCheckBox.qml',
                        },
                        {
                            key: 'HusTimePicker',
                            label: qsTr('HusTimePicker 时间选择框'),
                            source: './Examples/DataEntry/ExpTimePicker.qml',
                        },
                        {
                            key: 'HusAutoComplete',
                            label: qsTr('HusAutoComplete 自动完成'),
                            source: './Examples/DataEntry/ExpAutoComplete.qml',
                        },
                        {
                            key: 'HusDatePicker',
                            label: qsTr('HusDatePicker 日期选择框'),
                            source: './Examples/DataEntry/ExpDatePicker.qml',
                        },
                        {
                            key: 'HusInputNumber',
                            label: qsTr('HusInputNumber 数字输入框'),
                            source: './Examples/DataEntry/ExpInputNumber.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('数据展示'),
                    iconSource: HusIcon.FundProjectionScreenOutlined,
                    menuChildren: [
                        {
                            key: 'HusToolTip',
                            label: qsTr('HusToolTip 文字提示'),
                            source: './Examples/DataDisplay/ExpToolTip.qml',
                        },
                        {
                            key: 'HusTourFocus',
                            label: qsTr('HusTourFocus 漫游焦点'),
                            source: './Examples/DataDisplay/ExpTourFocus.qml',
                        },
                        {
                            key: 'HusTourStep',
                            label: qsTr('HusTourStep 漫游式引导'),
                            source: './Examples/DataDisplay/ExpTourStep.qml',
                        },
                        {
                            key: 'HusTabView',
                            label: qsTr('HusTabView 标签页'),
                            source: './Examples/DataDisplay/ExpTabView.qml',
                        },
                        {
                            key: 'HusCollapse',
                            label: qsTr('HusCollapse 折叠面板'),
                            source: './Examples/DataDisplay/ExpCollapse.qml',
                        },
                        {
                            key: 'HusAvatar',
                            label: qsTr('HusAvatar 头像'),
                            source: './Examples/DataDisplay/ExpAvatar.qml',
                        },
                        {
                            key: 'HusCard',
                            label: qsTr('HusCard 卡片'),
                            source: './Examples/DataDisplay/ExpCard.qml',
                        },
                        {
                            key: 'HusTimeline',
                            label: qsTr('HusTimeline 时间轴'),
                            source: './Examples/DataDisplay/ExpTimeline.qml',
                        },
                        {
                            key: 'HusTag',
                            label: qsTr('HusTag 标签'),
                            source: './Examples/DataDisplay/ExpTag.qml',
                        },
                        {
                            key: 'HusTableView',
                            label: qsTr('HusTableView 表格'),
                            source: './Examples/DataDisplay/ExpTableView.qml',
                            state: 'Update',
                        },
                        {
                            key: 'HusBadge',
                            label: qsTr('HusBadge 徽标数'),
                            source: './Examples/DataDisplay/ExpBadge.qml',
                            state: 'New',
                        },
                        {
                            key: 'HusCarousel',
                            label: qsTr('HusCarousel 走马灯'),
                            source: './Examples/DataDisplay/ExpCarousel.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('效果'),
                    iconSource: HusIcon.FireOutlined,
                    menuChildren: [
                        {
                            key: 'HusAcrylic',
                            label: qsTr('HusAcrylic 亚克力效果'),
                            source: './Examples/Effect/ExpAcrylic.qml',
                        },
                        {
                            key: 'HusSwitchEffect',
                            label: qsTr('HusSwitchEffect 切换特效'),
                            source: './Examples/Effect/ExpSwitchEffect.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('工具'),
                    iconSource: HusIcon.ToolOutlined,
                    menuChildren: [
                        {
                            key: 'HusAsyncHasher',
                            label: qsTr('HusAsyncHasher 异步哈希器'),
                            source: './Examples/Utils/ExpAsyncHasher.qml',
                        }
                    ]
                },
                {
                    label: qsTr('反馈'),
                    iconSource: HusIcon.MessageOutlined,
                    menuChildren: [
                        {
                            key: 'HusWatermark',
                            label: qsTr('HusWatermark 水印'),
                            source: './Examples/Feedback/ExpWatermark.qml',
                        },
                        {
                            key: 'HusDrawer',
                            label: qsTr('HusDrawer 抽屉'),
                            source: './Examples/Feedback/ExpDrawer.qml',
                        },
                        {
                            key: 'HusMessage',
                            label: qsTr('HusMessage 消息提示'),
                            source: './Examples/Feedback/ExpMessage.qml',
                        },
                        {
                            key: 'HusProgress',
                            label: qsTr('HusProgress 进度条'),
                            source: './Examples/Feedback/ExpProgress.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    type: 'divider'
                },
                {
                    label: qsTr('主题相关'),
                    iconSource: HusIcon.SkinOutlined,
                    type: 'group',
                    menuChildren: [
                        {
                            key: 'HusTheme',
                            label: qsTr('HusTheme 主题定制'),
                            source: './Examples/Theme/ExpTheme.qml',
                        }
                    ]
                }
            ]
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
            }
        }
    }
}

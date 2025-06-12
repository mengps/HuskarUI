pragma ComponentBehavior: Bound

import QtQuick
import DelegateUI
import Gallery

import './Home'

DelWindow {
    id: galleryWindow
    width: 1200
    height: 800
    opacity: 0
    minimumWidth: 800
    minimumHeight: 600
    title: qsTr('DelegateUI Gallery')
    followThemeSwitch: false
    captionBar.color: DelTheme.Primary.colorFillTertiary
    captionBar.themeButtonVisible: true
    captionBar.topButtonVisible: true
    captionBar.winIconWidth: 22
    captionBar.winIconHeight: 22
    captionBar.winIconDelegate: Item {
        DelIconText {
            iconSize: 22
            colorIcon: '#C44545'
            font.bold: true
            iconSource: DelIcon.DelegateUIPath1
        }
        DelIconText {
            iconSize: 22
            colorIcon: '#C44545'
            font.bold: true
            iconSource: DelIcon.DelegateUIPath2
        }
    }
    captionBar.themeCallback: () => {
        themeSwitchLoader.active = true;
    }
    captionBar.topCallback: (checked) => {
        DelApi.setWindowStaysOnTopHint(galleryWindow, checked);
    }

    Component.onCompleted: {
        if (Qt.platform.os === 'windows') {
            if (setSpecialEffect(DelWindow.Win_MicaAlt)) return;
            if (setSpecialEffect(DelWindow.Win_Mica)) return;
            if (setSpecialEffect(DelWindow.Win_AcrylicMaterial)) return;
            if (setSpecialEffect(DelWindow.Win_DwmBlur)) return;
        } else if (Qt.platform.os === 'osx') {
            if (setSpecialEffect(DelWindow.Mac_BlurEffect)) return;
        }
    }
    onWidthChanged: {
        galleryMenu.compactMode = width < 1100;
    }

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
        opacity: 0.2
    }

    Loader {
        id: themeSwitchLoader
        z: 65536
        active: false
        anchors.fill: galleryWindow.contentItem
        sourceComponent: ThemeSwitchItem {
            opacity: galleryWindow.specialEffect == DelWindow.None ? 1.0 : galleryBackground.opacity
            target: galleryWindow.contentItem
            isDark: DelTheme.isDark
            onSwitchStarted: {
                galleryWindow.setWindowMode(!DelTheme.isDark);
                galleryBackground.color = DelTheme.isDark ? 'white' : 'black';
                themeSwitchLoader.changeDark();
            }
            onAnimationFinished: {
                if (galleryWindow.specialEffect === DelWindow.None)
                    galleryWindow.color = DelTheme.Primary.colorBgBase;
                themeSwitchLoader.active = false;
            }
            Component.onCompleted: {
                colorBg = DelTheme.isDark ? 'white' : 'black';
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
            DelTheme.darkMode = DelTheme.isDark ? DelTheme.Light : DelTheme.Dark;
        }
    }

    Item {
        id: content
        anchors.top: galleryWindow.captionBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        DelAutoComplete {
            id: searchComponent
            property bool expanded: false
            z: 10
            clip: true
            width: (!galleryMenu.compactMode || expanded) ? (galleryMenu.defaultMenuWidth - 20) : 0
            anchors.top: parent.top
            anchors.left: !galleryMenu.compactMode ? galleryMenu.left : galleryMenu.right
            anchors.margins: 10
            topPadding: 6
            bottomPadding: 6
            rightPadding: 50
            tooltipVisible: true
            placeholderText: qsTr('搜索组件')
            colorBg: galleryMenu.compactMode ? DelTheme.DelInput.colorBg : 'transparent'
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
                color: DelTheme.DelAutoComplete.colorItemText
                font {
                    family: DelTheme.DelAutoComplete.fontFamily
                    pixelSize: DelTheme.DelAutoComplete.fontSize
                    weight: parent.highlighted ? Font.DemiBold : Font.Normal
                }
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter

                property var model: parent.modelData
                property string tagState: model.state ?? ''

                DelTag {
                    id: __tag
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: parent.tagState
                    presetColor: parent.tagState === 'New' ? 'red' : 'green'
                    visible: parent.tagState !== ''
                }
            }
            clearIconSource: searchComponent.length > 0 ? DelIcon.CloseCircleFilled : DelIcon.SearchOutlined

            Behavior on width {
                enabled: galleryMenu.compactMode && galleryMenu.width === galleryMenu.compactWidth
                NumberAnimation { duration: DelTheme.Primary.durationFast }
            }
        }

        DelIconButton {
            id: searchCollapse
            visible: galleryMenu.compactMode
            anchors.top: parent.top
            anchors.left: galleryMenu.left
            anchors.right: galleryMenu.right
            anchors.margins: 10
            type: DelButton.Type_Text
            colorText: DelTheme.Primary.colorTextBase
            iconSource: DelIcon.SearchOutlined
            iconSize: searchComponent.iconSize
            onClicked: searchComponent.expanded = !searchComponent.expanded;
            onVisibleChanged: {
                if (visible) {
                    searchComponent.closePopup();
                    searchComponent.expanded = false;
                }
            }
        }

        DelMenu {
            id: galleryMenu
            anchors.left: parent.left
            anchors.top: searchComponent.bottom
            anchors.bottom: aboutButton.top
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

                DelTag {
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

                Behavior on color { enabled: galleryMenu.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
                Behavior on border.color { enabled: galleryMenu.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }

                DelBadge {
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
                    iconSource: DelIcon.HomeOutlined,
                    source: './Home/HomePage.qml'
                },
                {
                    type: 'divider'
                },
                {
                    label: qsTr('通用'),
                    iconSource: DelIcon.ProductOutlined,
                    menuChildren: [
                        {
                            key: 'DelWindow',
                            label: qsTr('DelWindow 无边框窗口'),
                            source: './Examples/General/ExpWindow.qml',
                            state: 'Update',
                        },
                        {
                            key: 'DelButton',
                            label: qsTr('DelButton 按钮'),
                            source: './Examples/General/ExpButton.qml'
                        },
                        {
                            key: 'DelIconButton',
                            label: qsTr('DelIconButton 图标按钮'),
                            source: './Examples/General/ExpIconButton.qml'
                        },
                        {
                            key: 'DelCaptionButton',
                            label: qsTr('DelCaptionButton 标题按钮'),
                            source: './Examples/General/ExpCaptionButton.qml'
                        },
                        {
                            key: 'DelIconText',
                            label: qsTr('DelIconText 图标文本'),
                            source: './Examples/General/ExpIconText.qml'
                        },
                        {
                            key: 'DelCopyableText',
                            label: qsTr('DelCopyableText 可复制文本'),
                            source: './Examples/General/ExpCopyableText.qml'
                        },
                        {
                            key: 'DelRectangle',
                            label: qsTr('DelRectangle 圆角矩形'),
                            source: './Examples/General/ExpRectangle.qml'
                        },
                        {
                            key: 'DelPopup',
                            label: qsTr('DelPopup 弹窗'),
                            source: './Examples/General/ExpPopup.qml'
                        },
                        {
                            key: 'DelText',
                            label: qsTr('DelText 文本'),
                            source: './Examples/General/ExpText.qml'
                        },
                        {
                            key: 'DelButtonBlock',
                            label: qsTr('DelButtonBlock 按钮块'),
                            source: './Examples/General/ExpButtonBlock.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('布局'),
                    iconSource: DelIcon.BarsOutlined,
                    menuChildren: [
                        {
                            key: 'DelDivider',
                            label: qsTr('DelDivider 分割线'),
                            source: './Examples/Layout/ExpDivider.qml'
                        }
                    ]
                },
                {
                    label: qsTr('导航'),
                    iconSource: DelIcon.SendOutlined,
                    menuChildren: [
                        {
                            key: 'DelMenu',
                            label: qsTr('DelMenu 菜单'),
                            source: './Examples/Navigation/ExpMenu.qml',
                            state: 'Update',
                        },
                        {
                            key: 'DelScrollBar',
                            label: qsTr('DelScrollBar 滚动条'),
                            source: './Examples/Navigation/ExpScrollBar.qml',
                        },
                        {
                            key: 'DelPagination',
                            label: qsTr('DelPagination 分页'),
                            source: './Examples/Navigation/ExpPagination.qml',
                        },
                        {
                            key: 'DelContextMenu',
                            label: qsTr('DelContextMenu 上下文菜单'),
                            source: './Examples/Navigation/ExpContextMenu.qml',
                            state: 'New',
                        },
                        {
                            key: 'DelBreadcrumb',
                            label: qsTr('DelBreadcrumb 面包屑'),
                            source: './Examples/Navigation/ExpBreadcrumb.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('数据录入'),
                    iconSource: DelIcon.InsertRowBelowOutlined,
                    menuChildren: [
                        {
                            key: 'DelSwitch',
                            label: qsTr('DelSwitch 开关'),
                            source: './Examples/DataEntry/ExpSwitch.qml',
                        },
                        {
                            key: 'DelSlider',
                            label: qsTr('DelSlider 滑动输入条'),
                            source: './Examples/DataEntry/ExpSlider.qml',
                        },
                        {
                            key: 'DelSelect',
                            label: qsTr('DelSelect 选择器'),
                            source: './Examples/DataEntry/ExpSelect.qml',
                        },
                        {
                            key: 'DelInput',
                            label: qsTr('DelInput 输入框'),
                            source: './Examples/DataEntry/ExpInput.qml',
                        },
                        {
                            key: 'DelOTPInput',
                            label: qsTr('DelOTPInput 一次性口令输入框'),
                            source: './Examples/DataEntry/ExpOTPInput.qml',
                            state: 'Update',
                        },
                        {
                            key: 'DelRate',
                            label: qsTr('DelRate 评分'),
                            source: './Examples/DataEntry/ExpRate.qml',
                        },
                        {
                            key: 'DelRadio',
                            label: qsTr('DelRadio 单选框'),
                            source: './Examples/DataEntry/ExpRadio.qml',
                        },
                        {
                            key: 'DelRadioBlock',
                            label: qsTr('DelRadioBlock 单选块'),
                            source: './Examples/DataEntry/ExpRadioBlock.qml',
                        },
                        {
                            key: 'DelCheckBox',
                            label: qsTr('DelCheckBox 多选框'),
                            source: './Examples/DataEntry/ExpCheckBox.qml',
                        },
                        {
                            key: 'DelTimePicker',
                            label: qsTr('DelTimePicker 时间选择框'),
                            source: './Examples/DataEntry/ExpTimePicker.qml',
                        },
                        {
                            key: 'DelAutoComplete',
                            label: qsTr('DelAutoComplete 自动完成'),
                            source: './Examples/DataEntry/ExpAutoComplete.qml',
                        },
                        {
                            key: 'DelDatePicker',
                            label: qsTr('DelDatePicker 日期选择框'),
                            source: './Examples/DataEntry/ExpDatePicker.qml',
                        }
                    ]
                },
                {
                    label: qsTr('数据展示'),
                    iconSource: DelIcon.FundProjectionScreenOutlined,
                    menuChildren: [
                        {
                            key: 'DelToolTip',
                            label: qsTr('DelToolTip 文字提示'),
                            source: './Examples/DataDisplay/ExpToolTip.qml',
                        },
                        {
                            key: 'DelTourFocus',
                            label: qsTr('DelTourFocus 漫游焦点'),
                            source: './Examples/DataDisplay/ExpTourFocus.qml',
                        },
                        {
                            key: 'DelTourStep',
                            label: qsTr('DelTourStep 漫游式引导'),
                            source: './Examples/DataDisplay/ExpTourStep.qml',
                        },
                        {
                            key: 'DelTabView',
                            label: qsTr('DelTabView 标签页'),
                            source: './Examples/DataDisplay/ExpTabView.qml',
                        },
                        {
                            key: 'DelCollapse',
                            label: qsTr('DelCollapse 折叠面板'),
                            source: './Examples/DataDisplay/ExpCollapse.qml',
                        },
                        {
                            key: 'DelAvatar',
                            label: qsTr('DelAvatar 头像'),
                            source: './Examples/DataDisplay/ExpAvatar.qml',
                        },
                        {
                            key: 'DelCard',
                            label: qsTr('DelCard 卡片'),
                            source: './Examples/DataDisplay/ExpCard.qml',
                        },
                        {
                            key: 'DelTimeline',
                            label: qsTr('DelTimeline 时间轴'),
                            source: './Examples/DataDisplay/ExpTimeline.qml',
                        },
                        {
                            key: 'DelTag',
                            label: qsTr('DelTag 标签'),
                            source: './Examples/DataDisplay/ExpTag.qml',
                        },
                        {
                            key: 'DelTableView',
                            label: qsTr('DelTableView 表格'),
                            source: './Examples/DataDisplay/ExpTableView.qml',
                            state: 'Update',
                        },
                        {
                            key: 'DelBadge',
                            label: qsTr('DelBadge 徽标数'),
                            source: './Examples/DataDisplay/ExpBadge.qml',
                            state: 'New',
                        },
                        {
                            key: 'DelCarousel',
                            label: qsTr('DelCarousel 走马灯'),
                            source: './Examples/DataDisplay/ExpCarousel.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('效果'),
                    iconSource: DelIcon.FireOutlined,
                    menuChildren: [
                        {
                            key: 'DelAcrylic',
                            label: qsTr('DelAcrylic 亚克力效果'),
                            source: './Examples/Effect/ExpAcrylic.qml',
                        },
                        {
                            key: 'DelSwitchEffect',
                            label: qsTr('DelSwitchEffect 切换特效'),
                            source: './Examples/Effect/ExpSwitchEffect.qml',
                            state: 'New',
                        }
                    ]
                },
                {
                    label: qsTr('工具'),
                    iconSource: DelIcon.ToolOutlined,
                    menuChildren: [
                        {
                            key: 'DelAsyncHasher',
                            label: qsTr('DelAsyncHasher 异步哈希器'),
                            source: './Examples/Utils/ExpAsyncHasher.qml',
                        }
                    ]
                },
                {
                    label: qsTr('反馈'),
                    iconSource: DelIcon.MessageOutlined,
                    menuChildren: [
                        {
                            key: 'DelWatermark',
                            label: qsTr('DelWatermark 水印'),
                            source: './Examples/Feedback/ExpWatermark.qml',
                        },
                        {
                            key: 'DelDrawer',
                            label: qsTr('DelDrawer 抽屉'),
                            source: './Examples/Feedback/ExpDrawer.qml',
                        },
                        {
                            key: 'DelMessage',
                            label: qsTr('DelMessage 消息提示'),
                            source: './Examples/Feedback/ExpMessage.qml',
                        },
                        {
                            key: 'DelProgress',
                            label: qsTr('DelProgress 进度条'),
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
                    iconSource: DelIcon.SkinOutlined,
                    type: 'group',
                    menuChildren: [
                        {
                            key: 'DelTheme',
                            label: qsTr('DelTheme 主题定制'),
                            source: './Examples/Theme/ExpTheme.qml',
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

        DelIconButton {
            id: aboutButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: setttingsButton.top
            type: DelButton.Type_Text
            radiusBg: 0
            text: galleryMenu.compactMode ? '' : qsTr('关于')
            colorText: DelTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
            iconSource: DelIcon.UserOutlined
            onClicked: {
                aboutLoader.visible = !aboutLoader.visible;
            }
        }

        DelIconButton {
            id: setttingsButton
            width: galleryMenu.width
            height: 40
            anchors.bottom: parent.bottom
            type: DelButton.Type_Text
            radiusBg: 0
            text: galleryMenu.compactMode ? '' : qsTr('设置')
            colorText: DelTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
            iconSource: DelIcon.SettingOutlined
            onClicked: {
                gallerySwitchEffect.switchToSource('./Home/SettingsPage.qml');
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

            DelSwitchEffect {
                id: gallerySwitchEffect
                anchors.fill: parent
                duration: 350
                type: DelSwitchEffect.Type_Blurry
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

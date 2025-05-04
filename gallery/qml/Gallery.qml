pragma ComponentBehavior: Bound

import QtQuick
import DelegateUI

DelWindow {
    id: galleryWindow
    width: 1200
    height: 800
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
        color: '#141414'

        property real r: Math.sqrt(parent.width * parent.width + parent.height * parent.height)

        NumberAnimation {
            running: DelTheme.isDark
            properties: 'width,height'
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
                themeCircle.width = Qt.binding(() => themeCircle.r * 2);
                themeCircle.height = Qt.binding(() => themeCircle.r * 2);
                if (galleryWindow.specialEffect === DelWindow.None)
                    galleryWindow.color = DelTheme.Primary.colorBgBase;
                galleryBackground.color = DelTheme.Primary.colorBgBase;
            }
        }

        NumberAnimation {
            running: !DelTheme.isDark
            properties: 'width,height'
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
                for (let i = 0; i < galleryMenu.initModel.length; i++) {
                    let item = galleryMenu.initModel[i];
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
            clearIconDelegate: Row {
                spacing: 5

                DelIconText {
                    visible: searchComponent.length > 0
                    iconSource: DelIcon.CloseSquareFilled
                    iconSize: searchComponent.iconSize
                    colorIcon: searchComponent.enabled ?
                                   __iconMouse.hovered ? DelTheme.DelAutoComplete.colorIconHover :
                                                         DelTheme.DelAutoComplete.colorIcon : DelTheme.DelAutoComplete.colorIconDisabled

                    Behavior on colorIcon { enabled: searchComponent.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

                    MouseArea {
                        id: __iconMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: parent.iconSource == searchComponent.clearIconSource ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onEntered: hovered = true;
                        onExited: hovered = false;
                        onClicked: searchComponent.clearInput();
                        property bool hovered: false
                    }
                }

                DelIconText {
                    iconSource: DelIcon.SearchOutlined
                    iconSize: searchComponent.iconSize
                }
            }

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

        Component {
            id: menuContentDelegate

            Item {
                property var model: parent.model
                property var menuButton: parent.menuButton

                Text {
                    id: __text
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
                    text: model.state
                    presetColor: model.state === 'New' ? 'red' : 'green'
                }
            }
        }

        DelMenu {
            id: galleryMenu
            anchors.left: parent.left
            anchors.top: searchComponent.bottom
            anchors.bottom: aboutButton.top
            showEdge: true
            defaultMenuWidth: 300
            defaultMenuIconSize: 18
            defaultSelectedKey: ['HomePage']
            onClickMenu: function(deep, key, data) {
                console.debug('onClickMenu', deep, key, JSON.stringify(data));
                if (data && data.source) {
                    containerLoader.visible = true;
                    themeLoader.visible = false;
                    containerLoader.source = '';
                    containerLoader.source = data.source;
                } else if (data && data.isTheme) {
                    containerLoader.visible = false;
                    themeLoader.visible = true;
                }
            }
            initModel: [
                {
                    key: 'HomePage',
                    label: qsTr('首页'),
                    iconSource: DelIcon.HomeOutlined,
                    source: './HomePage.qml'
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
                            contentDelegate: menuContentDelegate
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
                            contentDelegate: menuContentDelegate
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
                            contentDelegate: menuContentDelegate
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
                            contentDelegate: menuContentDelegate
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
            text: galleryMenu.compactMode ? '' : qsTr('关于')
            colorText: DelTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
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
            text: galleryMenu.compactMode ? '' : qsTr('设置')
            colorText: DelTheme.Primary.colorTextBase
            iconSize: galleryMenu.defaultMenuIconSize
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
                source: './Examples/Theme/ExpTheme.qml'
                visible: false
            }
        }
    }
}

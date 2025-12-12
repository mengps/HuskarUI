import QtQuick
import HuskarUI.Basic

QtObject {
    id: root

    property int themeIndex: 8
    property var primaryTokens: []
    property var componentTokens: new Object
    property var menus: []
    property var options: []
    property var updates: []
    property var galleryModel: [
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
            key: 'General',
            label: qsTr('通用'),
            iconSource: HusIcon.ProductOutlined,
            menuChildren: [
                {
                    key: 'HusWindow',
                    label: qsTr('HusWindow 无边框窗口'),
                    source: './Examples/General/ExpWindow.qml',
                    desc: qsTr('添加 setMacSystemButtonsVisible() 函数。\n更新 [SpecialEffect] 枚举值。')
                },
                {
                    key: 'HusButton',
                    label: qsTr('HusButton 按钮'),
                    source: './Examples/General/ExpButton.qml',
                    updateVersion: '0.4.9.0',
                    desc: qsTr('新增 sizeHint 尺寸提示。')
                },
                {
                    key: 'HusIconButton',
                    label: qsTr('HusIconButton 图标按钮'),
                    source: './Examples/General/ExpIconButton.qml',
                    updateVersion: '0.5.2',
                    desc: qsTr('新增 iconFont 图标字体。\n新增 iconDelegate 图标代理。')
                },
                {
                    key: 'HusCaptionButton',
                    label: qsTr('HusCaptionButton 标题按钮'),
                    source: './Examples/General/ExpCaptionButton.qml',
                    desc: qsTr('一般用于窗口标题栏的按钮。')
                },
                {
                    key: 'HusIconText',
                    label: qsTr('HusIconText 图标文本'),
                    source: './Examples/General/ExpIconText.qml',
                    updateVersion: '0.4.6.0',
                    desc: qsTr('新增 empty 用于判断图标是否为空。\n新增 iconSource 支持内置图标和外部 url 链接。')
                },
                {
                    key: 'HusCopyableText',
                    label: qsTr('HusCopyableText 可复制文本'),
                    source: './Examples/General/ExpCopyableText.qml',
                    desc: qsTr('用于代替 Text 以提供可复制的文本。')
                },
                {
                    key: 'HusRectangle',
                    label: qsTr('HusRectangle 圆角矩形'),
                    source: './Examples/General/ExpRectangle.qml',
                    desc: qsTr('使用 HusRectangle 可以轻松实现任意四个对角方向上的圆角矩形。')
                },
                {
                    key: 'HusPopup',
                    label: qsTr('HusPopup 弹窗'),
                    source: './Examples/General/ExpPopup.qml',
                    desc: qsTr('代替内置 Popup 的弹出式窗口。')
                },
                {
                    key: 'HusText',
                    label: qsTr('HusText 文本'),
                    source: './Examples/General/ExpText.qml',
                    desc: qsTr('代替内置 Text 的来统一字体和文本。')
                },
                {
                    key: 'HusButtonBlock',
                    label: qsTr('HusButtonBlock 按钮块'),
                    source: './Examples/General/ExpButtonBlock.qml',
                    desc: qsTr('HusIconButton 的变体，用于将多个按钮组织成块，类似 HusRadioBlock。')
                },
                {
                    key: 'HusMoveMouseArea',
                    label: qsTr('HusMoveMouseArea 鼠标移动区域'),
                    source: './Examples/General/ExpMoveMouseArea.qml',
                    desc: qsTr('移动鼠标区域，提供对任意 Item 进行鼠标移动操作的区域。')
                },
                {
                    key: 'HusResizeMouseArea',
                    label: qsTr('HusResizeMouseArea 鼠标改变大小区域'),
                    source: './Examples/General/ExpResizeMouseArea.qml',
                    desc: qsTr('改变大小鼠标区域，提供对任意 Item 进行鼠标改变大小操作的区域。')
                },
                {
                    key: 'HusCaptionBar',
                    label: qsTr('HusCaptionBar 标题栏'),
                    source: './Examples/General/ExpCaptionBar.qml',
                    desc: qsTr('新增窗口额外按钮代理 winExtraButtonsDelegate。')
                },
                {
                    key: 'HusRadius',
                    label: qsTr('HusRadius 圆角半径'),
                    source: './Examples/General/ExpRadius.qml',
                    addVersion: '0.4.9.0',
                    desc: qsTr('提供四方向的圆角半径类型。')
                }
            ]
        },
        {
            key: 'Layout',
            label: qsTr('布局'),
            iconSource: HusIcon.BarsOutlined,
            menuChildren: [
                {
                    key: 'HusDivider',
                    label: qsTr('HusDivider 分割线'),
                    source: './Examples/Layout/ExpDivider.qml',
                    desc: qsTr('区隔内容的分割线。')
                }
            ]
        },
        {
            key: 'Navigation',
            label: qsTr('导航'),
            iconSource: HusIcon.SendOutlined,
            menuChildren: [
                {
                    key: 'HusMenu',
                    label: qsTr('HusMenu 菜单'),
                    source: './Examples/Navigation/ExpMenu.qml',
                    updateVersion: '0.4.9.1',
                    desc: qsTr('重做 compactMode 模式。\n移除 defaultMenuHeight 属性。\n新增 defaultMenu[Top/Bottom]Padding 默认菜单上/下边距属性。')
                },
                {
                    key: 'HusScrollBar',
                    label: qsTr('HusScrollBar 滚动条'),
                    source: './Examples/Navigation/ExpScrollBar.qml',
                    desc: qsTr('滚动条是一个交互式栏，用于滚动某个区域或视图到特定位置。')
                },
                {
                    key: 'HusPagination',
                    label: qsTr('HusPagination 分页'),
                    source: './Examples/Navigation/ExpPagination.qml',
                    desc: qsTr('分页器用于分隔长列表，每次只加载一个页面。')
                },
                {
                    key: 'HusContextMenu',
                    label: qsTr('HusContextMenu 上下文菜单'),
                    source: './Examples/Navigation/ExpContextMenu.qml',
                    updateVersion: '0.4.9.1',
                    desc: qsTr('移除 defaultMenuHeight 属性。\n新增 defaultMenu[Top/Bottom]Padding 默认菜单上/下边距属性。')
                },
                {
                    key: 'HusBreadcrumb',
                    label: qsTr('HusBreadcrumb 面包屑'),
                    source: './Examples/Navigation/ExpBreadcrumb.qml',
                    desc: qsTr('面包屑，显示当前页面在系统层级结构中的位置，并能向上返回。')
                }
            ]
        },
        {
            key: 'DataEntry',
            label: qsTr('数据录入'),
            iconSource: HusIcon.InsertRowBelowOutlined,
            menuChildren: [
                {
                    key: 'HusSwitch',
                    label: qsTr('HusSwitch 开关'),
                    source: './Examples/DataEntry/ExpSwitch.qml',
                    desc: qsTr('使用开关切换两种状态之间。')
                },
                {
                    key: 'HusSlider',
                    label: qsTr('HusSlider 滑动输入条'),
                    source: './Examples/DataEntry/ExpSlider.qml',
                    desc: qsTr('新增 handleToolTipDelegate 滑块文字提示代理。')
                },
                {
                    key: 'HusSelect',
                    label: qsTr('HusSelect 选择器'),
                    source: './Examples/DataEntry/ExpSelect.qml',
                    updateVersion: '0.4.8.1',
                    desc: qsTr('新增 clearIconDelegate。\n新增 bgDelegate代理。\n新增清除图标相关属性和信号。')
                },
                {
                    key: 'HusInput',
                    label: qsTr('HusInput 输入框'),
                    source: './Examples/DataEntry/ExpInput.qml',
                    updateVersion: '0.4.9.0',
                    desc: qsTr('新增 sizeHint 尺寸提示。')
                },
                {
                    key: 'HusOTPInput',
                    label: qsTr('HusOTPInput 一次性口令输入框'),
                    source: './Examples/DataEntry/ExpOTPInput.qml',
                    desc: qsTr('新增 setInput() 函数。\n新增 setInputAtIndex() 函数。')
                },
                {
                    key: 'HusRate',
                    label: qsTr('HusRate 评分'),
                    source: './Examples/DataEntry/ExpRate.qml',
                    desc: qsTr('新增 toolTipDelegate 星星上方的文字提示代理。')
                },
                {
                    key: 'HusRadio',
                    label: qsTr('HusRadio 单选框'),
                    source: './Examples/DataEntry/ExpRadio.qml',
                    desc: qsTr('用于在多个备选项中选中单个状态。')
                },
                {
                    key: 'HusRadioBlock',
                    label: qsTr('HusRadioBlock 单选块'),
                    source: './Examples/DataEntry/ExpRadioBlock.qml',
                    desc: qsTr('新增支持图标。')
                },
                {
                    key: 'HusCheckBox',
                    label: qsTr('HusCheckBox 多选框'),
                    source: './Examples/DataEntry/ExpCheckBox.qml',
                    desc: qsTr('收集用户的多项选择。')
                },
                {
                    key: 'HusAutoComplete',
                    label: qsTr('HusAutoComplete 自动完成'),
                    source: './Examples/DataEntry/ExpAutoComplete.qml',
                    desc: qsTr('输入框自动完成功能。')
                },
                {
                    key: 'HusInputNumber',
                    label: qsTr('HusInputNumber 数字输入框'),
                    source: './Examples/DataEntry/ExpInputNumber.qml',
                    updateVersion: '0.4.8.3',
                    desc: qsTr('新增初始化标签列表索引属性。')
                },
                {
                    key: 'HusMultiSelect',
                    label: qsTr('HusMultiSelect 多选器'),
                    source: './Examples/DataEntry/ExpMultiSelect.qml',
                    addVersion: '0.4.3',
                    desc: qsTr('多选器，可多选的下拉选择器。'),
                },
                {
                    key: 'HusDateTimePicker',
                    label: qsTr('HusDateTimePicker 日期时间选择框'),
                    source: './Examples/DataEntry/ExpDateTimePicker.qml',
                    addVersion: '0.4.4',
                    desc: qsTr('日期时间选择框，输入或选择日期的控件。')
                },
                {
                    key: 'HusTextArea',
                    label: qsTr('HusTextArea 文本域'),
                    source: './Examples/DataEntry/ExpTextArea.qml',
                    addVersion: '0.5.0',
                    desc: qsTr('新增 scrollToBeginning() / scrollToEnd()。')
                },
                {
                    key: 'HusInputInteger',
                    label: qsTr('HusInputInteger 整数输入框'),
                    source: './Examples/DataEntry/ExpInputInteger.qml',
                    addVersion: '0.5.1',
                    desc: qsTr('等同于 HusInputNumber，但只支持整数。')
                },
                {
                    key: 'HusColorPickerPanel',
                    label: qsTr('HusColorPickerPanel 颜色选择器面板'),
                    source: './Examples/DataEntry/ExpColorPickerPanel.qml',
                    addVersion: '0.5.2',
                    desc: qsTr('用于选择颜色的面板。')
                },
                {
                    key: 'HusColorPicker',
                    label: qsTr('HusColorPicker 颜色选择器'),
                    source: './Examples/DataEntry/ExpColorPicker.qml',
                    addVersion: '0.5.2',
                    desc: qsTr('用于选择颜色的弹出式窗口。')
                },
            ]
        },
        {
            key: 'DataDisplay',
            label: qsTr('数据展示'),
            iconSource: HusIcon.FundProjectionScreenOutlined,
            menuChildren: [
                {
                    key: 'HusToolTip',
                    label: qsTr('HusToolTip 文字提示'),
                    source: './Examples/DataDisplay/ExpToolTip.qml',
                    desc: qsTr('简单的文字提示气泡框，用来代替内置 ToolTip。')
                },
                {
                    key: 'HusTourFocus',
                    label: qsTr('HusTourFocus 漫游焦点'),
                    source: './Examples/DataDisplay/ExpTourFocus.qml',
                    updateVersion: '0.4.5.2',
                    desc: qsTr('新增 penetrationEvent/focusRadius 属性。')
                },
                {
                    key: 'HusTourStep',
                    label: qsTr('HusTourStep 漫游式引导'),
                    source: './Examples/DataDisplay/ExpTourStep.qml',
                    updateVersion: '0.4.5.2',
                    desc: qsTr('新增 penetrationEvent/focusRadius 属性。\n优化步骤卡片显示逻辑。')
                },
                {
                    key: 'HusTabView',
                    label: qsTr('HusTabView 标签页'),
                    source: './Examples/DataDisplay/ExpTabView.qml',
                    updateVersion: '0.4.*.1',
                    desc: qsTr('新增 closeTabCallback() 关闭标签回调。')
                },
                {
                    key: 'HusCollapse',
                    label: qsTr('HusCollapse 折叠面板'),
                    source: './Examples/DataDisplay/ExpCollapse.qml',
                    desc: qsTr('可以折叠/展开的内容区域。')
                },
                {
                    key: 'HusAvatar',
                    label: qsTr('HusAvatar 头像'),
                    source: './Examples/DataDisplay/ExpAvatar.qml',
                    desc: qsTr('用来代表用户或事物，支持图片、图标或字符展示。')
                },
                {
                    key: 'HusCard',
                    label: qsTr('HusCard 卡片'),
                    source: './Examples/DataDisplay/ExpCard.qml',
                    desc: qsTr('最基础的卡片容器，可承载文字、列表、图片、段落。')
                },
                {
                    key: 'HusTimeline',
                    label: qsTr('HusTimeline 时间轴'),
                    source: './Examples/DataDisplay/ExpTimeline.qml',
                    desc: qsTr('垂直展示的时间流信息。')
                },
                {
                    key: 'HusTag',
                    label: qsTr('HusTag 标签'),
                    source: './Examples/DataDisplay/ExpTag.qml',
                    desc: qsTr('进行标记和分类的小标签。')
                },
                {
                    key: 'HusTableView',
                    label: qsTr('HusTableView 表格'),
                    source: './Examples/DataDisplay/ExpTableView.qml',
                    updateVersion: '0.4.8.1',
                    desc: qsTr('新增 getCellData 获取单元数据。\n新增 setCellData 设置单元数据。')
                },
                {
                    key: 'HusBadge',
                    label: qsTr('HusBadge 徽标数'),
                    source: './Examples/DataDisplay/ExpBadge.qml',
                    desc: qsTr('徽标数，图标右上角的圆形徽标数字。')
                },
                {
                    key: 'HusCarousel',
                    label: qsTr('HusCarousel 走马灯'),
                    source: './Examples/DataDisplay/ExpCarousel.qml',
                    desc: qsTr('走马灯，一组轮播的区域。')
                },
                {
                    key: 'HusImage',
                    label: qsTr('HusImage 图片'),
                    source: './Examples/DataDisplay/ExpImage.qml',
                    addVersion: '0.4.2',
                    desc: qsTr('可预览的图片。')
                },
                {
                    key: 'HusImagePreview',
                    label: qsTr('HusImagePreview 图片预览'),
                    source: './Examples/DataDisplay/ExpImagePreview.qml',
                    addVersion: '0.4.2',
                    desc: qsTr('用于预览的图片的基本工具，提供常用的图片变换(平移/缩放/翻转/旋转)操作。')
                },
                {
                    key: 'HusEmpty',
                    label: qsTr('HusEmpty 空状态'),
                    source: './Examples/DataDisplay/ExpEmpty.qml',
                    addVersion: '0.4.8.3',
                    desc: qsTr('显示一个表示空状态的图像和描述文本。')
                },
                {
                    key: 'HusQrCode',
                    label: qsTr('HusQrCode 二维码'),
                    source: './Examples/DataDisplay/ExpQrCode.qml',
                    addVersion: '0.5.0',
                    desc: qsTr('能够将文本转换生成二维码的组件，支持自定义配色和 Logo 配置。')
                },
                {
                    key: 'HusAnimatedImage',
                    label: qsTr('HusAnimatedImage 动态图片'),
                    source: './Examples/DataDisplay/ExpAnimatedImage.qml',
                    addVersion: '0.5.2',
                    desc: qsTr('可预览的动态图片。')
                },
                {
                    key: 'HusCheckerBoard',
                    label: qsTr('HusCheckerBoard 棋盘格'),
                    source: './Examples/DataDisplay/ExpCheckerBoard.qml',
                    addVersion: '0.5.2',
                    desc: qsTr('用于创建双色棋盘格。')
                },
            ]
        },
        {
            key: 'Effect',
            label: qsTr('效果'),
            iconSource: HusIcon.FireOutlined,
            menuChildren: [
                {
                    key: 'HusAcrylic',
                    label: qsTr('HusAcrylic 亚克力效果'),
                    source: './Examples/Effect/ExpAcrylic.qml',
                    desc: qsTr('使用 HusAcrylic 可以轻松实现亚克力/毛玻璃效果。')
                },
                {
                    key: 'HusSwitchEffect',
                    label: qsTr('HusSwitchEffect 切换特效'),
                    source: './Examples/Effect/ExpSwitchEffect.qml',
                    desc: qsTr('为两个组件之间增加切换/过渡特效。')
                },
                {
                    key: 'HusShadow',
                    label: qsTr('HusShadow 阴影效果'),
                    source: './Examples/Effect/ExpShadow.qml',
                    addVersion: '0.4.8',
                    desc: qsTr('通用&统一的阴影特效。')
                }
            ]
        },
        {
            key: 'Utils',
            label: qsTr('工具'),
            iconSource: HusIcon.ToolOutlined,
            menuChildren: [
                {
                    key: 'HusAsyncHasher',
                    label: qsTr('HusAsyncHasher 异步哈希器'),
                    source: './Examples/Utils/ExpAsyncHasher.qml',
                    desc: qsTr('可对任意数据(url/text/object)生成加密哈希的异步散列器。')
                }
            ]
        },
        {
            key: 'Feedback',
            label: qsTr('反馈'),
            iconSource: HusIcon.MessageOutlined,
            menuChildren: [
                {
                    key: 'HusWatermark',
                    label: qsTr('HusWatermark 水印'),
                    source: './Examples/Feedback/ExpWatermark.qml',
                    desc: qsTr('可给页面的任意项加上水印，支持文本/图像水印。')
                },
                {
                    key: 'HusDrawer',
                    label: qsTr('HusDrawer 抽屉'),
                    source: './Examples/Feedback/ExpDrawer.qml',
                    desc: qsTr('新增 drawerSize(抽屉宽度) 属性。')
                },
                {
                    key: 'HusMessage',
                    label: qsTr('HusMessage 消息提示'),
                    source: './Examples/Feedback/ExpMessage.qml',
                    desc: qsTr('新增消息体代理 messageDelegate。\n新增 defaultIconSize。\n新增 spacing。\n新增 topMargin。')
                },
                {
                    key: 'HusProgress',
                    label: qsTr('HusProgress 进度条'),
                    source: './Examples/Feedback/ExpProgress.qml',
                    desc: qsTr('进度条，展示操作的当前进度。')
                },
                {
                    key: 'HusNotification',
                    label: qsTr('HusNotification 通知提醒框'),
                    source: './Examples/Feedback/ExpNotification.qml',
                    addVersion: '0.4.5',
                    desc: qsTr('通知提醒框，全局展示通知提醒信息。')
                },
                {
                    key: 'HusPopconfirm',
                    label: qsTr('HusPopconfirm 气泡确认框'),
                    source: './Examples/Feedback/ExpPopconfirm.qml',
                    addVersion: '0.4.6',
                    desc: qsTr('气泡确认框，弹出气泡式的确认框。')
                },
                {
                    key: 'HusPopover',
                    label: qsTr('HusPopover 气泡显示框'),
                    source: './Examples/Feedback/ExpPopover.qml',
                    addVersion: '0.4.8.2',
                    desc: qsTr('气泡显示框，弹出气泡式的显示框。')
                },
                {
                    key: 'HusModal',
                    label: qsTr('HusModal 对话框'),
                    source: './Examples/Feedback/ExpModal.qml',
                    addVersion: '0.4.7',
                    desc: qsTr('展示一个对话框，提供标题、内容区、操作区。')
                },
                {
                    key: 'HusSpin',
                    label: qsTr('HusSpin 加载中'),
                    source: './Examples/Feedback/ExpSpin.qml',
                    addVersion: '0.5.1',
                    desc: qsTr('用于页面和区块的加载中状态。')
                }
            ]
        },
        {
            type: 'divider'
        },
        {
            key: 'Theme',
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

    Component.onCompleted: {
        /*! 解析 Primary.tokens */
        for (const token in HusTheme.Primary) {
            primaryTokens.push({ label: `@${token}` });
        }
        /*! 解析 Component.tokens */
        const indexFile = `:/HuskarUI/resources/theme/Index.json`;
        const indexObject = JSON.parse(HusApi.readFileToString(indexFile));
        for (const source in indexObject.__component__) {
            const __style__ = {};
            const parseImport = (name) => {
                const path = `:/HuskarUI/resources/theme/${name}.json`;
                const fileContent = HusApi.readFileToString(path);
                if (!fileContent) {
                    console.warn("Failed to read file:", path);
                    return;
                }
                const object = JSON.parse(fileContent);
                const imports = object?.__init__?.__import__;
                const style = object.__style__;
                if (imports) {
                    imports.forEach(i => parseImport(i));
                }
                for (const token in style) {
                    __style__[token] = style[token];
                }
            }
            parseImport(source);

            const list = [];
            for (const token in __style__) {
                list.push({
                              'tokenName': token,
                              'tokenValue': {
                                  'token': token,
                                  'value': __style__[token],
                                  'rawValue': __style__[token],
                              },
                              'tokenCalcValue': token,
                          });
            }
            componentTokens[source] = list;
        }

        /*! 创建菜单等 */
        let __menus = [], __options = [], __updates = [];
        for (const item of galleryModel) {
            if (item && item.menuChildren) {
                let hasNew = false;
                let hasUpdate = false;
                item.menuChildren.sort((a, b) => a.key.localeCompare(b.key));
                item.menuChildren.forEach(
                            object => {
                                object.state = object.addVersion ? 'New' : object.updateVersion ? 'Update' : '';
                                if (object.state) {
                                    if (object.state === 'New') hasNew = true;
                                    if (object.state === 'Update') hasUpdate = true;
                                }
                                if (object.label) {
                                    __options.push({
                                                       'key': object.key,
                                                       'value': object.key,
                                                       'label': object.label,
                                                       'state': object.state,
                                                   });
                                    __updates.push({
                                                       'name': object.key,
                                                       'desc': object.desc ?? '',
                                                       'tagState': object.state,
                                                       'version': object.addVersion || object.updateVersion || '',
                                                   });
                                }
                            });
                if (hasNew)
                    item.badgeState = 'New';
                else
                    item.badgeState = hasUpdate ? 'Update' : '';
            }
            __menus.push(item);
        }
        menus = __menus;
        options = __options.sort((a, b) => a.key.localeCompare(b.key));
        updates = __updates.sort(
                    (a, b) => {
                        const parts1 = a.version.split('.').map(Number);
                        const parts2 = b.version.split('.').map(Number);
                        for (let i = 0; i < Math.max(parts1.length, parts2.length); i++) {
                            const num1 = parts1[i] || 0;
                            const num2 = parts2[i] || 0;

                            if (num1 > num2) return -1;
                            if (num1 < num2) return 1;
                        }
                        return 0;
                    });
    }
}

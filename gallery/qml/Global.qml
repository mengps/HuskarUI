//pragma Singleton

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
            label: qsTr('通用'),
            iconSource: HusIcon.ProductOutlined,
            menuChildren: [
                {
                    key: 'HusWindow',
                    label: qsTr('HusWindow 无边框窗口'),
                    source: './Examples/General/ExpWindow.qml',
                    desc: qsTr('添加 setMacSystemButtonsVisble() 函数。\n更新 [SpecialEffect] 枚举值。')
                },
                {
                    key: 'HusButton',
                    label: qsTr('HusButton 按钮'),
                    source: './Examples/General/ExpButton.qml',
                    desc: qsTr('新增 Link 类型按钮。')
                },
                {
                    key: 'HusIconButton',
                    label: qsTr('HusIconButton 图标按钮'),
                    source: './Examples/General/ExpIconButton.qml',
                    desc: qsTr('带图标的按钮。')
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
                    updateVersion: '0.4.6',
                    state: 'Update',
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
                    source: './Examples/Layout/ExpDivider.qml',
                    desc: qsTr('区隔内容的分割线。')
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
                    desc: qsTr('优化菜单背景颜色以及显示逻辑。')
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
                    desc: qsTr('上下文菜单，通常作为右键单击后显示的菜单。')
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
                    desc: qsTr('下拉选择器(即传统组合框)。')
                },
                {
                    key: 'HusInput',
                    label: qsTr('HusInput 输入框'),
                    source: './Examples/DataEntry/ExpInput.qml',
                    desc: qsTr('通过鼠标或键盘输入内容，是最基础的表单域的包装(即传统输入框)。')
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
                    desc: qsTr('数字输入框，通过鼠标或键盘，输入范围内的数值。')
                },
                {
                    key: 'HusMultiSelect',
                    label: qsTr('HusMultiSelect 多选器'),
                    source: './Examples/DataEntry/ExpMultiSelect.qml',
                    addVersion: '0.4.3',
                    state: 'New',
                    desc: qsTr('多选器，可多选的下拉选择器。'),
                },
                {
                    key: 'HusDateTimePicker',
                    label: qsTr('HusDateTimePicker 日期时间选择框'),
                    source: './Examples/DataEntry/ExpDateTimePicker.qml',
                    addVersion: '0.4.4',
                    state: 'New',
                    desc: qsTr('日期时间选择框，输入或选择日期的控件。')
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
                    desc: qsTr('简单的文字提示气泡框，用来代替内置 ToolTip。')
                },
                {
                    key: 'HusTourFocus',
                    label: qsTr('HusTourFocus 漫游焦点'),
                    source: './Examples/DataDisplay/ExpTourFocus.qml',
                    updateVersion: '0.4.5.2',
                    state: 'Update',
                    desc: qsTr('新增 penetrationEvent/focusRadius 属性。')
                },
                {
                    key: 'HusTourStep',
                    label: qsTr('HusTourStep 漫游式引导'),
                    source: './Examples/DataDisplay/ExpTourStep.qml',
                    updateVersion: '0.4.5.2',
                    state: 'Update',
                    desc: qsTr('新增 penetrationEvent/focusRadius 属性。\n优化步骤卡片显示逻辑。')
                },
                {
                    key: 'HusTabView',
                    label: qsTr('HusTabView 标签页'),
                    source: './Examples/DataDisplay/ExpTabView.qml',
                    desc: qsTr('HusTabView 是通过选项卡标签切换内容的组件。')
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
                    desc: qsTr('展示行列数据。')
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
                    state: 'New',
                    desc: qsTr('可预览的图片。')
                },
                {
                    key: 'HusImagePreview',
                    label: qsTr('HusImagePreview 图片预览'),
                    source: './Examples/DataDisplay/ExpImagePreview.qml',
                    addVersion: '0.4.2',
                    state: 'New',
                    desc: qsTr('用于预览的图片的基本工具，提供常用的图片变换(平移/缩放/翻转/旋转)操作。')
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
                    desc: qsTr('使用 HusAcrylic 可以轻松实现亚克力/毛玻璃效果。')
                },
                {
                    key: 'HusSwitchEffect',
                    label: qsTr('HusSwitchEffect 切换特效'),
                    source: './Examples/Effect/ExpSwitchEffect.qml',
                    desc: qsTr('为两个组件之间增加切换/过渡特效。')
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
                    desc: qsTr('可对任意数据(url/text/object)生成加密哈希的异步散列器。')
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
                    state: 'New',
                    desc: qsTr('通知提醒框，全局展示通知提醒信息。')
                },
                {
                    key: 'HusPopconfirm',
                    label: qsTr('HusPopconfirm 气泡确认框'),
                    source: './Examples/Feedback/ExpPopconfirm.qml',
                    addVersion: '0.4.6',
                    state: 'New',
                    desc: qsTr('气泡确认框，弹出气泡式的确认框。')
                },
                {
                    key: 'HusModal',
                    label: qsTr('HusModal 对话框'),
                    source: './Examples/Feedback/ExpModal.qml',
                    addVersion: '0.4.7',
                    state: 'New',
                    desc: qsTr('展示一个对话框，提供标题、内容区、操作区。')
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

    Component.onCompleted: {
        /*! 解析 Primary.tokens */
        for (const token in HusTheme.Primary) {
            primaryTokens.push({ label: `@${token}` });
        }
        /*! 解析 Component.tokens */
        const indexFile = `:/HuskarUI/theme/Index.json`;
        const indexObject = JSON.parse(HusApi.readFileToString(indexFile));
        for (const source in indexObject.__component__) {
            const __style__ = {};
            const parseImport = (name) => {
                const path = `:/HuskarUI/theme/${name}.json`;
                const object = JSON.parse(HusApi.readFileToString(path));
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
                                if (object.state) {
                                    if (object.state === 'New') hasNew = true;
                                    if (object.state === 'Update') hasUpdate = true;
                                }
                                if (object.label) {
                                    __options.push({
                                                       'key': object.key,
                                                       'value': object.key,
                                                       'label': object.label,
                                                       'state': object.state ?? '',
                                                   });
                                    __updates.push({
                                                       'name': object.key,
                                                       'desc': object.desc ?? '',
                                                       'tagState': object.state ?? '',
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
        options = __options;
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

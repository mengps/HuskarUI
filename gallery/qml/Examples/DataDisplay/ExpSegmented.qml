import QtQuick
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    HusScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        DocDescription {
            desc: qsTr(`
# HusSegmented 分段控制器 \n
用于展示多个选项并允许用户选择其中单个选项。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **indicatorDelegate: Component** 指示器代理。\n
- **itemDelegate: Component** 项代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
  - \`pressed: bool\` 是否按下\n
  - \`hovered: bool\` 是否悬浮\n
  - \`isCurrent: bool\` 是否为当前项\n
- **iconDelegate: Component** 内容代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
  - \`pressed: bool\` 是否按下\n
  - \`hovered: bool\` 是否悬浮\n
  - \`isCurrent: bool\` 是否为当前项\n
- **toolTipDelegate: Component** 文本提示代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
  - \`pressed: bool\` 是否按下\n
  - \`hovered: bool\` 是否悬浮\n
  - \`isCurrent: bool\` 是否为当前项\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
options | array | [] | 选项模型列表
currentIndex | int | 0 | 当前索引
currentValue | var(readonly) | - | 当前值
count | int(readonly) | - | 选项数量
block | bool | false | 是否填充父元素整行
orientation | enum | Qt.Horizontal | 方向(来自 Qt.*)
defaultItemHeight | real | 26 | 默认项高度
iconSpacing | int | 5 | 图标间隔
iconFont | font | - | 图标字体
colorBg | color | - | 背景颜色
colorIndicatorBg | color | - | 指示器颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
borderBg | [HusBorder](internal://HusBorder) | - | 背景边框
sizeHint | string | 'normal' | 尺寸提示
\n<br/>
\n### 选项支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | string | 必选 | 标签文本
value | var | 可选 | 值(默认为label)
enabled | bool | 可选 | 是否启用
toolTip | string | 可选 | 文本提示
iconSource | int丨string | 可选 | 本标签的图标源
\n<br/>
\n### 支持的函数：\n
- \`get(index: int): Object\` 获取 \`index\` 处的选项数据 \n
- \`set(index: int, object: Object)\` 设置 \`index\` 处的选项数据为 \`object\` \n
- \`setProperty(index: int, propertyName: string, value: any)\` 设置 \`index\` 处的选项数据属性名 \`propertyName\` 值为 \`value\` \n
- \`move(from: int, to: int, count: int = 1)\` 将 \`count\` 个选项数据从 \`from\` 位置移动到 \`to\` 位置 \n
- \`insert(index: int, object: Object)\` 插入选项 \`object\` 到 \`index\` 处 \n
- \`append(object: Object)\` 在末尾添加选项 \`object\` \n
- \`remove(index: int, count: int = 1)\` 删除 \`index\` 处 \`count\` 个选项数据 \n
- \`clear()\` 清空所有选项数据 \n
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 用于展示多个选项并允许用户选择其中单个选项。\n
- 当切换选中选项时，关联区域的内容会发生变化。\n
                       `)
        }

        ThemeToken {
            source: 'HusSegmented'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusSegmented.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
最简单的用法。\n
通过 \`options\` 属性设置选项数据，数据项可以为字符串。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRadioBlock {
                        id: sizeHintRadio
                        initCheckedIndex: 1
                        model: [
                            { label: 'Small', value: 'small' },
                            { label: 'Normal', value: 'normal' },
                            { label: 'Large', value: 'large' },
                        ]
                    }

                    HusSegmented {
                        sizeHint: sizeHintRadio.currentCheckedValue
                        options: ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly']
                    }

                    HusSegmented {
                        sizeHint: sizeHintRadio.currentCheckedValue
                        options: [
                            { label: 'List', value: 'List', iconSource: HusIcon.BarsOutlined },
                            { label: 'Kanban', value: 'Kanban', iconSource: HusIcon.AppstoreOutlined }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRadioBlock {
                    id: sizeHintRadio
                    initCheckedIndex: 1
                    model: [
                        { label: 'Small', value: 'small' },
                        { label: 'Normal', value: 'normal' },
                        { label: 'Large', value: 'large' },
                    ]
                }

                HusSegmented {
                    sizeHint: sizeHintRadio.currentCheckedValue
                    options: ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly']
                }

                HusSegmented {
                    sizeHint: sizeHintRadio.currentCheckedValue
                    options: [
                        { label: 'List', value: 'List', iconSource: HusIcon.BarsOutlined },
                        { label: 'Kanban', value: 'Kanban', iconSource: HusIcon.AppstoreOutlined }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('垂直方向')
            desc: qsTr(`
通过 \`orientation\` 属性改变方向，支持的方向：\n
- 水平方向(默认){ Qt.Horizontal }\n
- 垂直方向{ Qt.Vertical }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSegmented {
                        id: customSegmented
                        width: 100
                        borderBg.color: '#77BEF0'
                        orientation: Qt.Vertical
                        options: [
                            {
                                label: 'Boost ',
                                toolTip: 'Boost',
                                iconSource: HusIcon.RocketOutlined,
                            },
                            {
                                label: 'Stream',
                                toolTip: 'Stream',
                                iconSource: HusIcon.ThunderboltOutlined,
                            },
                            {
                                label: 'Cloud ',
                                toolTip: 'Cloud',
                                iconSource: HusIcon.CloudOutlined,
                            }
                        ]
                        iconDelegate: HusIconText {
                            font: customSegmented.iconFont
                            colorIcon: '#77BEF0'
                            iconSource: model.iconSource
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSegmented {
                    id: customSegmented
                    width: 100
                    borderBg.color: '#77BEF0'
                    orientation: Qt.Vertical
                    options: [
                        {
                            label: 'Boost ',
                            toolTip: 'Boost',
                            iconSource: HusIcon.RocketOutlined,
                        },
                        {
                            label: 'Stream',
                            toolTip: 'Stream',
                            iconSource: HusIcon.ThunderboltOutlined,
                        },
                        {
                            label: 'Cloud ',
                            toolTip: 'Cloud',
                            iconSource: HusIcon.CloudOutlined,
                        }
                    ]
                    iconDelegate: HusIconText {
                        font: customSegmented.iconFont
                        colorIcon: '#77BEF0'
                        iconSource: model.iconSource
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('填充整行')
            desc: qsTr(`
通过 \`block\` 属性使其填充父元素宽度。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSegmented {
                        block: true
                        options: [123, 456, 'longtext-longtext-longtext-longtext']
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSegmented {
                    block: true
                    options: [123, 456, 'longtext-longtext-longtext-longtext']
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('启用/禁用')
            desc: qsTr(`
通过 \`options.enabled\` 属性启用/禁用项。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSegmented {
                        enabled: false
                        options: ['Map', 'Transit', 'Satellite']
                    }

                    HusSegmented {
                        options: [
                            'Daily',
                            { label: 'Weekly', value: 'Weekly', enabled: false },
                            'Monthly',
                            { label: 'Quarterly', value: 'Quarterly', enabled: false },
                            'Yearly',
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSegmented {
                    enabled: false
                    options: ['Map', 'Transit', 'Satellite']
                }

                HusSegmented {
                    options: [
                        'Daily',
                        { label: 'Weekly', value: 'Weekly', enabled: false },
                        'Monthly',
                        { label: 'Quarterly', value: 'Quarterly', enabled: false },
                        'Yearly',
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('胶囊形状')
            desc: qsTr(`
胶囊型的 HusSegmented。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSegmented {
                        options: ['small', 'middle', 'large']
                    }

                    HusSegmented {
                        options: [
                            { iconSource: HusIcon.SunOutlined },
                            { iconSource: HusIcon.MoonOutlined },
                        ]
                        radiusBg.all: height * 0.5
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSegmented {
                    options: ['small', 'middle', 'large']
                }

                HusSegmented {
                    options: [
                        { iconSource: HusIcon.SunOutlined },
                        { iconSource: HusIcon.MoonOutlined },
                    ]
                    radiusBg.all: height * 0.5
                }
            }
        }
    }
}

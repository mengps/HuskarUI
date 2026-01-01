import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusButtonBlock 按钮块(HusIconButton变种) \n
用于将多个按钮组织成块，类似 HusRadioBlock。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **toolTipDelegate: Component** 文字提示代理，代理可访问属性：\n
  - \`pressed: int\` 是否按下\n
  - \`hovered: int\` 是否悬浮\n
  - \`toolTip: var\` 文字提示数据\n
- **buttonDelegate: Component** 按钮项代理，代理可访问属性：\n
  - \`index: int\` 按钮项索引\n
  - \`modelData: var\` 按钮项数据\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
model | list | [] | 按钮块模型
count | int | - | 按钮数量
size | enum | HusButtonBlock.Size_Auto | 按钮项大小(来自 HusButtonBlock)
buttonWidth | int | 120 | 按钮项宽度(size == HusButtonBlock.Size_Fixed 生效)
buttonHeight | int | 30 | 按钮项高度(size == HusButtonBlock.Size_Fixed 生效)
buttonLeftPadding | int | 10 | 按钮项左填充
buttonRightPadding | int | 10 | 按钮项右填充
buttonTopPadding | int | 8 | 按钮项上填充
buttonBottomPadding | int | 8 | 按钮项下填充
radiusBg | [HusRadius](internal://HusRadius) | - | 按钮项背景半径
contentDescription | string | '' | 内容描述(提高可用性)
\n<br/>
\n### 模型支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | string | 必选 | 本按钮的标签
value | sting | 可选 | 本按钮的值
enabled | bool | 可选 | 本按钮是否启用
iconSource | int丨string | 可选 | 本按钮图标(参见 HusIcon)或图标链接
type | enum | 可选 | 本按钮类型(参见 HusButton.type)
autoRepeat | bool | 可选 | 本按钮是否自动重复(参见 Button.autoRepeat)
toolTip | var | 可选 | 存在时则创建文字提示
toolTip.text | string | 可选 | 存在时则创建文字提示
toolTip.delay | int | 可选 | 文字提示延时(ms)
toolTip.timeout | int | 可选 | 文字提示超时(ms)
\n<br/>
\n### 支持的信号：\n
- \`pressed(index: int, buttonData: var)\` 按下按钮时发出\n
  - \`index\` 按钮索引\n
  - \`buttonData\` 按钮项数据\n
- \`released(index: int, buttonData: var)\` 释放按钮时发出\n
  - \`index\` 按钮索引\n
  - \`buttonData\` 按钮项数据\n
- \`clicked(index: int, buttonData: var)\` 点击按钮时发出\n
  - \`index\` 按钮索引\n
  - \`buttonData\` 按钮项数据\n
- \`doubleClicked(index: int, buttonData: var)\` 双击按钮时发出\n
  - \`index\` 按钮索引\n
  - \`buttonData\` 按钮项数据\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 用于将多个按钮组织成块。\n
- 和 [HusRadioBlock](internal://HusRadioBlock) 的区别是，HusButtonBlock 没有单选和互斥状态。\n
                       `)
        }

        ThemeToken {
            source: 'HusButton'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`model\` 属性设置初始按钮块的模型，按钮项支持的属性：\n
- { label: 本按钮的标签 }\n
- { value: 本按钮的值 }\n
- { enabled: 本按钮是否启用 }\n
- { iconSource: 本按钮图标源 }\n
- { type: 本按钮类型(参见 HusButton.type) }\n
- { autoRepeat: 本按钮是否自动重复(参见Button.autoRepeat) }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusButtonBlock {
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear' },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    HusButtonBlock {
                        model: [
                            { label: 'Default', type: HusButton.Type_Default },
                            { label: 'Outlined', type: HusButton.Type_Outlined },
                            { label: 'Primary', type: HusButton.Type_Primary },
                            { label: 'Filled', type: HusButton.Type_Filled },
                            { label: 'Text', type: HusButton.Type_Text },
                        ]
                    }

                    HusButtonBlock {
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear', enabled: false },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    HusButtonBlock {
                        enabled: false
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear', enabled: false },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    HusButtonBlock {
                        model: [
                            { iconSource: HusIcon.PlusOutlined },
                            { iconSource: HusIcon.MinusOutlined },
                            { iconSource: HusIcon.CloseOutlined },
                            { label: ' / ' },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButtonBlock {
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                HusButtonBlock {
                    model: [
                        { label: 'Default', type: HusButton.Type_Default },
                        { label: 'Outlined', type: HusButton.Type_Outlined },
                        { label: 'Primary', type: HusButton.Type_Primary },
                        { label: 'Filled', type: HusButton.Type_Filled },
                        { label: 'Text', type: HusButton.Type_Text },
                    ]
                }

                HusButtonBlock {
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear', enabled: false },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                HusButtonBlock {
                    enabled: false
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear', enabled: false },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                HusButtonBlock {
                    model: [
                        { iconSource: HusIcon.PlusOutlined },
                        { iconSource: HusIcon.MinusOutlined },
                        { iconSource: HusIcon.CloseOutlined },
                        { label: ' / ' },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`size\` 属性设置按钮块调整大小的模式，支持的大小：\n
- 自动计算大小(默认) { HusButtonBlock.Size_Auto }\n
- 固定大小(将使用buttonWidth/buttonHeight) { HusButtonBlock.Size_Fixed }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusButtonBlock {
                        size: HusButtonBlock.Size_Auto
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear' },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    HusButtonBlock {
                        size: HusButtonBlock.Size_Fixed
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear' },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButtonBlock {
                    size: HusButtonBlock.Size_Auto
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                HusButtonBlock {
                    size: HusButtonBlock.Size_Fixed
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }
            }
        }
    }
}

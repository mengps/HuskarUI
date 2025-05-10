import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelButtonBlock 按钮块(DelIconButton变种) \n
用于将多个按钮组织成块，类似 DelRadioBlock。\n
* **继承自 { Item }**\n
支持的代理：\n
- **buttonDelegate: Component** 按钮项代理，代理可访问属性：\n
  - \`index: int\` 按钮项索引\n
  - \`modelData: var\` 按钮项数据\n
支持的属性：\n
属性名 | 类型 | 默认值 | 描述 |
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画(默认true)
effectEnabled | bool | true | 是否开启点击效果(默认true)
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
model | list | [] | 按钮块模型
count | int | - | 按钮数量
size | enum | DelButtonBlock.Size_Auto | 按钮项大小(来自 DelButtonBlock)
buttonWidth | int | 120 | 按钮项宽度(size == DelButtonBlock.Size_Fixed 生效)
buttonHeight | int | 30 | 按钮项高度(size == DelButtonBlock.Size_Fixed 生效)
buttonLeftPadding | int | 10 | 按钮项左填充
buttonRightPadding | int | 10 | 按钮项右填充
buttonTopPadding | int | 8 | 按钮项上填充
buttonBottomPadding | int | 8 | 按钮项下填充
font | font | - | 按钮项字体
radiusBg | int | 6 | 按钮项背景半径
contentDescription | string | '' | 内容描述(提高可用性)
\n模型支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
label(可选) | string | 本按钮的标签
value(可选) | sting | 本按钮的值
enabled(可选) | var | 本按钮是否启用
icon(可选) | int | 本按钮图标
type(可选) | int | 本按钮类型(参见 DelButton.type)
autoRepeat(可选) | int | 本按钮是否自动重复(参见 Button.autoRepeat)
\n支持的信号：\n
- \`pressed(index: int, buttonData: var)\` 按下按钮时发出\n
  - \`index\` 按钮索引\n
  - \`buttonData\` 按钮项数据\n
- \`released(index: int, buttonData: var)\` 释放按钮时发出\n
  - \`index\` 按钮索引\n
  - \`buttonData\` 按钮项数据\n
- \`clicked(index: int, buttonData: var)\` 点击按钮时发出\n
  - \`index\` 按钮索引\n
  - \`buttonData\` 按钮项数据\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 用于将多个按钮组织成块。\n
- 和 [DelRadioBlock](internal://DelRadioBlock) 的区别是，DelButtonBlock 没有单选和互斥状态。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`model\` 属性设置初始按钮块的模型，按钮项支持的属性：\n
- { label: 本按钮的标签 }\n
- { value: 本按钮的值 }\n
- { enabled: 本按钮是否启用 }\n
- { icon: 本按钮图标 }\n
- { type: 本按钮类型(参见 DelButton.type) }\n
- { autoRepeat: 本按钮是否自动重复(参见Button.autoRepeat) }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelButtonBlock {
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear' },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    DelButtonBlock {
                        model: [
                            { label: 'Default', type: DelButton.Type_Default },
                            { label: 'Outlined', type: DelButton.Type_Outlined },
                            { label: 'Primary', type: DelButton.Type_Primary },
                            { label: 'Filled', type: DelButton.Type_Filled },
                            { label: 'Text', type: DelButton.Type_Text },
                        ]
                    }

                    DelButtonBlock {
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear', enabled: false },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    DelButtonBlock {
                        enabled: false
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear', enabled: false },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    DelButtonBlock {
                        model: [
                            { icon: DelIcon.PlusOutlined },
                            { icon: DelIcon.MinusOutlined },
                            { icon: DelIcon.CloseOutlined },
                            { label: ' / ' },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelButtonBlock {
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                DelButtonBlock {
                    model: [
                        { label: 'Default', type: DelButton.Type_Default },
                        { label: 'Outlined', type: DelButton.Type_Outlined },
                        { label: 'Primary', type: DelButton.Type_Primary },
                        { label: 'Filled', type: DelButton.Type_Filled },
                        { label: 'Text', type: DelButton.Type_Text },
                    ]
                }

                DelButtonBlock {
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear', enabled: false },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                DelButtonBlock {
                    enabled: false
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear', enabled: false },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                DelButtonBlock {
                    model: [
                        { icon: DelIcon.PlusOutlined },
                        { icon: DelIcon.MinusOutlined },
                        { icon: DelIcon.CloseOutlined },
                        { label: ' / ' },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`size\` 属性设置按钮块调整大小的模式，支持的大小：\n
- 自动计算大小(默认) { DelButtonBlock.Size_Auto }\n
- 固定大小(将使用buttonWidth/buttonHeight) { DelButtonBlock.Size_Fixed }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelButtonBlock {
                        size: DelButtonBlock.Size_Auto
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear' },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    DelButtonBlock {
                        size: DelButtonBlock.Size_Fixed
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

                DelButtonBlock {
                    size: DelButtonBlock.Size_Auto
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                DelButtonBlock {
                    size: DelButtonBlock.Size_Fixed
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

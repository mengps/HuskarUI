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
## DelRadioBlock 单选块(DelRadio变种) \n
用于在多个备选项中选中单个状态。\n
* **继承自 { Item }**\n
支持的代理：\n
- **radioDelegate: Component** 单选项代理，代理可访问属性：\n
  - \`index: int\` 单选项索引\n
  - \`modelData: var\` 单选项数据\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
effectEnabled | bool | 是否开启点击效果(默认true)
hoverCursorShape | int | 悬浮时鼠标形状(来自 Qt.*Cursor)
model | list | 单选块模型
count | int | 单选数量
initCheckedIndex | int | 初始选择的单选项索引
currentCheckedIndex | int | 当前选择的单选项索引
currentCheckedValue | var | 当前选择的单选项的值
type | enum | 单选项类型(来自 DelRadioBlock)
size | enum | 单选项大小(来自 DelRadioBlock)
radioWidth | int | 单选项宽度(size == DelRadioBlock.Size_Fixed 生效)
radioHeight | int | 单选项高度(size == DelRadioBlock.Size_Fixed 生效)
font | font | 单选项字体
radiusBg | int | 单选项背景半径
contentDescription | string | 内容描述(提高可用性)
\n模型支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
label(可选) | string | 本单选项的标签
value(可选) | sting | 本单选项的值
enabled(可选) | var | 本单选项是否启用
icon(可选) | int | 本单选项图标
\n支持的信号：\n
- \`clicked(index: int, radioData: var)\` 点击单选项时发出\n
  - \`index\` 单选项索引\n
  - \`radioData\` 单选项数据\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 用于在多个备选项中选中单个状态。\n
- 和 [DelSelect](internal://DelSelect) 的区别是，DelRadioBlock 所有选项默认可见，方便用户在比较中选择，因此选项不宜过多。\n
- 和 [DelRadio](internal://DelRadio) 的区别是，DelRadioBlock 是成组的，通过 \`model\` 统一设置。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`model\` 属性设置初始单选块的模型，单选项支持的属性：\n
- { label: 本单选项的标签 }\n
- { value: 本单选项的值 }\n
- { enabled: 本单选项是否启用 }\n
- { icon: 本单选项图标 }\n
通过 \`type\` 属性设置单选块的类型，支持的类型：\n
- 填充样式的按钮(默认) { DelRadioBlock.Type_Filled }\n
- 线框样式的按钮(无填充) { DelRadioBlock.Type_Outlined }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelRadioBlock {
                        initCheckedIndex: 0
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear' },
                            { label: 'Orange', value: 'Orange' },
                            { icon: DelIcon.QuestionOutlined, value: 'Orange' },
                        ]
                    }

                    DelRadioBlock {
                        initCheckedIndex: 1
                        type: DelRadioBlock.Type_Outlined
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear' },
                            { label: 'Orange', value: 'Orange' },
                            { icon: DelIcon.QuestionOutlined, value: 'Orange' },
                        ]
                    }

                    DelRadioBlock {
                        initCheckedIndex: 2
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear', enabled: false },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    DelRadioBlock {
                        enabled: false
                        initCheckedIndex: 2
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear', enabled: false },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelRadioBlock {
                    initCheckedIndex: 0
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                        { icon: DelIcon.QuestionOutlined, value: 'Orange' },
                    ]
                }

                DelRadioBlock {
                    initCheckedIndex: 1
                    type: DelRadioBlock.Type_Outlined
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                        { icon: DelIcon.QuestionOutlined, value: 'Orange' },
                    ]
                }

                DelRadioBlock {
                    initCheckedIndex: 2
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear', enabled: false },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                DelRadioBlock {
                    enabled: false
                    initCheckedIndex: 2
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear', enabled: false },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`size\` 属性设置单选块调整大小的模式，支持的大小：\n
- 自动计算大小(默认) { DelRadioBlock.Size_Auto }\n
- 固定大小(将使用radioWidth/radioHeight) { DelRadioBlock.Size_Fixed }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelRadioBlock {
                        initCheckedIndex: 0
                        size: DelRadioBlock.Size_Fixed
                        model: [
                            { label: 'Apple', value: 'Apple' },
                            { label: 'Pear', value: 'Pear' },
                            { label: 'Orange', value: 'Orange' },
                        ]
                    }

                    DelRadioBlock {
                        initCheckedIndex: 0
                        size: DelRadioBlock.Size_Fixed
                        type: DelRadioBlock.Type_Outlined
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

                DelRadioBlock {
                    initCheckedIndex: 0
                    size: DelRadioBlock.Size_Fixed
                    model: [
                        { label: 'Apple', value: 'Apple' },
                        { label: 'Pear', value: 'Pear' },
                        { label: 'Orange', value: 'Orange' },
                    ]
                }

                DelRadioBlock {
                    initCheckedIndex: 0
                    size: DelRadioBlock.Size_Fixed
                    type: DelRadioBlock.Type_Outlined
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

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
## DelSelect 选择器 \n
下拉选择器。\n
* **继承自 { ComboBox }**\n
支持的代理：\n
- **indicatorDelegate: Component** 右侧指示器代理\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
tooltipVisible | bool | 是否显示文字提示(默认false)
loading | bool | 是否在加载中
defaulPopupMaxHeight | int | 默认弹窗最大高度
colorText | color | 文本颜色
colorBorder | color | 边框颜色
colorBg | color | 背景颜色
radiusBg | int | 背景半径
radiusPopupBg | int | 弹窗背景半径
contentDescription | string | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 弹出一个下拉菜单给用户选择操作，用于代替原生的组合框(ComboBox)，或者需要一个更优雅的多选器时。\n
- 当选项少时（少于 5 项），建议直接将选项平铺，使用 [DelRadioButton](internal://DelRadioButton) 是更好的选择。\n
- 如果你在寻找一个可输可选的输入框，那你可能需要 [DelAutoComplete](internal://DelAutoComplete)。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`model\` 属性设置初始选择器的模型，选择项支持的属性：\n
- { label: 本选择项的标签 } 可通过 **textRole** 更改\n
- { value: 本选择项的值 } 可通过 **valueRole** 更改\n
- { enabled: 本选择项是否启用 }\n
通过 \`loading\` 属性设置是否在加载中。\n
可以让 \`enabled\` 绑定 \`loading\` 实现加载完成才启用。\n
通过 \`tooltipVisible\` 属性设置是否显示文字提示框(主要用于长文本，默认false)。\n
通过 \`defaulPopupMaxHeight\` 属性设置默认弹出窗口的高度。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import DelegateUI

                Row {
                    width: parent.width
                    spacing: 10

                    DelSelect {
                        width: 120
                        height: 30
                        tooltipVisible: true
                        model: [
                            { value: 'jack', label: 'Jack' },
                            { value: 'lucy', label: 'Lucy' },
                            { value: 'yiminghe', label: 'Yimingheabcdef' },
                            { value: 'disabled', label: 'Disabled', enabled: false },
                        ]
                    }

                    DelSelect {
                        width: 120
                        height: 30
                        enabled: false
                        model: [
                            { value: 'jack', label: 'Jack' },
                            { value: 'lucy', label: 'Lucy' },
                            { value: 'yiminghe', label: 'Yiminghe' },
                            { value: 'disabled', label: 'Disabled', enabled: false },
                        ]
                    }

                    DelSelect {
                        width: 120
                        height: 30
                        loading: true
                        model: [
                            { value: 'jack', label: 'Jack' },
                            { value: 'lucy', label: 'Lucy' },
                            { value: 'yiminghe', label: 'Yiminghe' },
                            { value: 'disabled', label: 'Disabled', enabled: false },
                        ]
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelSelect {
                    width: 120
                    height: 30
                    tooltipVisible: true
                    model: [
                        { value: 'jack', label: 'Jack' },
                        { value: 'lucy', label: 'Lucy' },
                        { value: 'yiminghe', label: 'Yimingheabcdef' },
                        { value: 'disabled', label: 'Disabled', enabled: false },
                    ]
                }

                DelSelect {
                    width: 120
                    height: 30
                    enabled: false
                    model: [
                        { value: 'jack', label: 'Jack' },
                        { value: 'lucy', label: 'Lucy' },
                        { value: 'yiminghe', label: 'Yiminghe' },
                        { value: 'disabled', label: 'Disabled', enabled: false },
                    ]
                }

                DelSelect {
                    width: 120
                    height: 30
                    loading: true
                    model: [
                        { value: 'jack', label: 'Jack' },
                        { value: 'lucy', label: 'Lucy' },
                        { value: 'yiminghe', label: 'Yiminghe' },
                        { value: 'disabled', label: 'Disabled', enabled: false },
                    ]
                }
            }
        }
    }
}

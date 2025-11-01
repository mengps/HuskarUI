import QtQuick
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
# HusIconButton 图标按钮\n
带图标的按钮。\n
* **继承自 { [HusButton](internal://HusButton) }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
iconSource | int丨string | 0丨'' | 图标源(来自 HusIcon)或图标链接
iconSize | int | - | 图标大小
iconSpacing | int | 5 | 图标间隔
iconPosition | enum | HusIconButton.Position_Start | 图标位置(来自 HusIconButton)
orientation | enum | Qt.Horizontal | 方向(Qt.Horizontal 或 Qt.Vertical)
colorIcon | color | - | 图标颜色
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
等同于 [HusButton](internal://HusButton)，但提供一个前/后/上/下的可选图标。
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
通过 \`iconSource\` 属性设置图标源{ HusIcon中定义 }\n
通过 \`iconSize\` 属性设置图标大小\n
通过 \`iconPosition\` 属性设置图标位置，支持的位置有：\n
- 图标处于开始位置(默认){ HusIconButton.Position_Start }\n
- 图标处于结束位置{ HusIconButton.Position_End }\n
通过 \`orientation\` 属性改变方向，支持的方向：\n
- 水平排布(默认){ Qt.Horizontal }\n
- 垂直排布{ Qt.Vertical }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRadioBlock {
                        id: orientationRadio
                        initCheckedIndex: 0
                        model: [
                            { label: 'Horizontal', value: Qt.Horizontal },
                            { label: 'Vertical', value: Qt.Vertical },
                        ]
                    }

                    Row {
                        spacing: 15

                        HusIconButton {
                            text: qsTr('搜索')
                            iconSource: HusIcon.SearchOutlined
                            orientation: orientationRadio.currentCheckedValue
                        }

                        HusIconButton {
                            text: qsTr('搜索')
                            type: HusButton.Type_Outlined
                            iconSource: HusIcon.SearchOutlined
                            orientation: orientationRadio.currentCheckedValue
                        }

                        HusIconButton {
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.SearchOutlined
                            orientation: orientationRadio.currentCheckedValue
                        }

                        HusIconButton {
                            text: qsTr('搜索')
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.SearchOutlined
                            orientation: orientationRadio.currentCheckedValue
                        }

                        HusIconButton {
                            text: qsTr('搜索')
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.SearchOutlined
                            iconPosition: HusIconButton.Position_End
                            orientation: orientationRadio.currentCheckedValue
                        }

                        HusIconButton {
                            text: qsTr('搜索')
                            type: HusButton.Type_Filled
                            iconSource: HusIcon.SearchOutlined
                            orientation: orientationRadio.currentCheckedValue
                        }

                        HusIconButton {
                            text: qsTr('搜索')
                            type: HusButton.Type_Text
                            iconSource: HusIcon.SearchOutlined
                            orientation: orientationRadio.currentCheckedValue
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRadioBlock {
                    id: orientationRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Horizontal', value: Qt.Horizontal },
                        { label: 'Vertical', value: Qt.Vertical },
                    ]
                }

                Row {
                    spacing: 15

                    HusIconButton {
                        text: qsTr('搜索')
                        iconSource: HusIcon.SearchOutlined
                        orientation: orientationRadio.currentCheckedValue
                    }

                    HusIconButton {
                        text: qsTr('搜索')
                        type: HusButton.Type_Outlined
                        iconSource: HusIcon.SearchOutlined
                        orientation: orientationRadio.currentCheckedValue
                    }

                    HusIconButton {
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.SearchOutlined
                        orientation: orientationRadio.currentCheckedValue
                    }

                    HusIconButton {
                        text: qsTr('搜索')
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.SearchOutlined
                        orientation: orientationRadio.currentCheckedValue
                    }

                    HusIconButton {
                        text: qsTr('搜索')
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.SearchOutlined
                        iconPosition: HusIconButton.Position_End
                        orientation: orientationRadio.currentCheckedValue
                    }

                    HusIconButton {
                        text: qsTr('搜索')
                        type: HusButton.Type_Filled
                        iconSource: HusIcon.SearchOutlined
                        orientation: orientationRadio.currentCheckedValue
                    }

                    HusIconButton {
                        text: qsTr('搜索')
                        type: HusButton.Type_Text
                        iconSource: HusIcon.SearchOutlined
                        orientation: orientationRadio.currentCheckedValue
                    }
                }
            }
        }
    }
}

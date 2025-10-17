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
# HusCaptionButton 标题按钮\n
一般用于窗口标题栏的按钮。\n
* **继承自 { [HusIconButton](internal://HusIconButton) }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
isError | bool | false | 是否为警示按钮
noDisabledState | bool | false | 无禁用状态(即被禁用时不会更改颜色)
                       `)
        }

        ThemeToken {
            source: 'HusCaptionButton'
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
一般配合无边框窗口使用，用于窗口标题栏的自定义按钮。
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`isError\` 属性设置为警示按钮，例如关闭按钮。
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 15

                    HusCaptionButton {
                        iconSource: HusIcon.CloseOutlined
                    }

                    HusCaptionButton {
                        isError: true
                        iconSource: HusIcon.CloseOutlined
                    }

                    HusCaptionButton {
                        text: qsTr('关闭')
                        colorText: colorIcon
                        iconSource: HusIcon.CloseOutlined
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                HusCaptionButton {
                    iconSource: HusIcon.CloseOutlined
                }

                HusCaptionButton {
                    isError: true
                    iconSource: HusIcon.CloseOutlined
                }

                HusCaptionButton {
                    text: qsTr('关闭')
                    colorText: colorIcon
                    iconSource: HusIcon.CloseOutlined
                }
            }
        }
    }
}

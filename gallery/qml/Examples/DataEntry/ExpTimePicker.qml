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
## DelTimePicker 输入框 \n
输入或选择时间的控件。\n
* **继承自 { TextField }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
active(readonly) | bool | 是否处于激活状态
format | enum | 时间格式(来自 DelTimePicker)
iconSize | int | 图标大小
iconPosition | enum | 图标位置(来自 DelTimePicker)
colorText | color | 输入框文本颜色
colorBorder | color | 输入框边框颜色
colorBg | color | 输入框背景颜色
colorPopupText | color | 弹出框背景颜色
popupFont | font | 弹出框字体
radiusBg | int | 输入框背景半径
radiusPopupBg | int | 弹出框背景半径
contentDescription | string | 内容描述(提高可用性)
\n支持的函数：\n
- \`clearTime()\` 清空时间 \n
\n支持的信号：\n
- \`acceptedTime(time: string)\` 接受时间时发出\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
当用户需要输入一个时间，可以点击标准输入框，弹出时间面板进行选择。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`enabled\` 属性设置是否启用\n
通过 \`iconPosition\` 属性改变图标位置，支持的位置：\n
- 图标在输入框左边{ DelTimePicker.Position_Left }\n
- 图标在输入框右边(默认){ DelTimePicker.Position_Right }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelTimePicker {
                        iconPosition: DelTimePicker.Position_Right
                    }

                    DelTimePicker {
                        iconPosition: DelTimePicker.Position_Left
                    }

                    DelTimePicker {
                        enabled: false
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelTimePicker {
                    iconPosition: DelTimePicker.Position_Right
                }

                DelTimePicker {
                    iconPosition: DelTimePicker.Position_Left
                }

                DelTimePicker {
                    enabled: false
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`format\` 属性设置显示时间格式，支持的格式：\n
- 小时分钟秒{hh:mm:ss}(默认){ DelTimePicker.Format_HHMMSS }\n
- 小时分钟{hh:mm}{ DelTimePicker.Format_HHMM }\n
- 分钟秒{mm:ss}{ DelTimePicker.Format_MMSS }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 10

                    DelTimePicker {
                        format: DelTimePicker.Format_HHMMSS
                    }

                    DelTimePicker {
                        format: DelTimePicker.Format_HHMM
                    }

                    DelTimePicker {
                        format: DelTimePicker.Format_MMSS
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelTimePicker {
                    format: DelTimePicker.Format_HHMMSS
                }

                DelTimePicker {
                    format: DelTimePicker.Format_HHMM
                }

                DelTimePicker {
                    format: DelTimePicker.Format_MMSS
                }
            }
        }
    }
}

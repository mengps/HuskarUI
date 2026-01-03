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

        Description {
            desc: qsTr(`
# HusCheckerBoard 棋盘格 \n
显示一个双色棋盘格。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
rows | int | 0 | 行数
columns | int | 0 | 列数
colorWhite | color | 'transparent' | 白格子颜色
colorBlack | color | - | 黑格子颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在用户需要快速创建双色棋盘格时使用。\n
                       `)
        }

        ThemeToken {
            source: ''
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最简单的用法。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10
    
                    HusCheckerBoard {
                        width: 400
                        height: 400
                        rows: 16
                        columns: 16
                        colorWhite: 'white'
                        colorBlack: 'black'
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusCheckerBoard {
                    width: 400
                    height: 400
                    rows: 16
                    columns: 16
                    colorWhite: 'white'
                    colorBlack: 'black'
                }
            }
        }
    }
}

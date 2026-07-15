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

        DocDescription {
            desc: qsTr(`
# HusBorder 边框\n
提供统一的边框类型。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { QQuickPen(即Rectangle.border) }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
border.width | real | 1 | 边框宽度(参见 Rectangle.border.width)
border.color | color | 'black' | 边框颜色(参见 Rectangle.border.color)
border.pixelAligned | bool | true | 边框像素对齐(参见 Rectangle.border.pixelAligned)
border.style | enum | Qt.SolidLine | 边框线样式(来自 Qt.*), 仅对 [HusRectangle](internal://HusRectangle) 生效
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在用户需要统一的边框类型时使用。\n
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/cpp/items/husborder.cpp'
        }
    }
}

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
# HusRadius 圆角半径\n
提供四方向的圆角半径类型。\n
* **继承自 { QObject }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
all | real | 0 | 统一设置四个圆角半径
topLeft | real | -1 | 左上圆角半径
topRight | real | -1 | 右上圆角半径
bottomLeft | real | -1 | 左下圆角半径
bottomRight | real | -1 | 右下圆角半径
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在用户需要任意方向圆角半径类型时使用。\n
                       `)
        }

        ThemeToken { }
    }
}

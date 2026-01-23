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
# HusApi 内置API \n
提供一系列实用接口。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { QObject }**\n
\n<br/>
\n### 支持的函数：\n
- \`clamp(value: real, min: real, max: real): real\`\n
    将一个值限制在指定的范围内。\n
- \`setWindowStaysOnTopHint(window: Window, hint: bool)\`\n
    将指定窗口 \`window\` 置顶。\n
- \`setWindowState(window: Window, state: int)\`\n
    设置 \`window\` 的窗口状态为 \`state\`。\n
- \`setPopupAllowAutoFlip(popup: Popup, allowVerticalFlip: bool = true, allowHorizontalFlip: bool = true)\`\n
    设置 \`Popup\` 弹窗是否允许超过窗口外时自动翻转(水平翻转/垂直翻转)。\n
- \`getClipbordText(): string\`\n
    获取当前剪切板内容。\n
- \`setClipbordText(text: string): bool\`\n
    设置当前剪切板内容为 \`text\`。\n
- \`readFileToString(fileName: string)\`\n
    读取 \`fileName\` 文件内容为字符串。\n
- \`getWeekNumber(dateTime: date): int\`\n
    获取 \`dateTime\` 指定的日期的周数。\n
- \`dateFromString(dateTime：date, format: string): date\`\n
    将字符串日期 \`dateTime\` 以 \`format\` 格式化并返回日期。\n
- \`openLocalUrl(local: string)\`\n
    打开本地Url \`local\`。\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当需要一些实用函数时。\n
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/cpp/utils/husapi.cpp'
        }
    }
}

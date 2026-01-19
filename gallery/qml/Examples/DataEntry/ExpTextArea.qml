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
# HusTextArea 文本域 \n
通过鼠标或键盘输入内容，是最基础的表单域的包装。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **bgDelegate: Component** 背景代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
active | bool | - | 是否处于激活状态
resizable | bool | false | 是否可手动改变高度
minResizeHeight | int | 30 | 最小手动可改变高度
autoSize | bool | false | 是否自动调整高度
minRows | int | -1 | 最小行数
maxRows | int | -1 | 最大行数
lineCount | int(readonly) | 0 | 文本行数
length | int | 0 | 文本长度
maxLength | int | -1 | 最大文本长度
readOnly | bool | false | 是否只读
textFormat | enum | - | 文本格式(来自TextEdit.*)
text | string | '' | 文本
placeholderText | string | '' | 占位文本
colorText | color | - | 文本颜色
colorPlaceholderText | color | - | 占位文本颜色
colorSelectedText | color | - | 选中文本颜色
colorSelection | color | - | 选区颜色
colorBorder | color | - | 边框颜色
colorBg | color | - | 背景颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
contentDescription | string | '' | 内容描述(提高可用性)
textArea | TextArea | - | 访问内部文本区域
verScrollBar | [HusScrollBar](internal://HusScrollBar) | - | 访问内部垂直滚动条
horScrollBar | [HusScrollBar](internal://HusScrollBar) | - | 访问内部水平滚动条
\n **注意** 其他原生 \`TextArea\` 属性请通过 \`textArea\` 访问/更改
\n<br/>
\n### 支持的函数：\n
- \`scrollToBeginning()\` 将光标滚动到起始位置\n
- \`scrollToEnd()\` 将光标滚动到结束位置\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要用户输入多行表单域内容时。\n
                       `)
        }

        ThemeToken {
            source: 'HusTextArea'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusTextArea.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本使用')
            desc: qsTr(`
通过 \`resizable\` 属性设置允许手动更改高度(右下角图标)。\n
通过 \`minResizeHeight\` 属性设置最小手动更改高度。\n
通过 \`maxLength\` 属性设置最大字符长度。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusTextArea {
                        width: parent.width
                        height: 120
                        minResizeHeight: 30
                        resizable: true
                    }

                    HusTextArea {
                        width: parent.width
                        height: 120
                        minResizeHeight: 30
                        resizable: true
                        maxLength: 6
                        placeholderText: 'maxLength is 6'
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTextArea {
                    width: parent.width
                    height: 120
                    minResizeHeight: 30
                    resizable: true
                }

                HusTextArea {
                    width: parent.width
                    height: 120
                    minResizeHeight: 30
                    resizable: true
                    maxLength: 6
                    placeholderText: 'maxLength is 6'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('适应文本高度的文本域')
            desc: qsTr(`
通过 \`autoSize\` 属性设置自动计算高度。\n
当 \`minRows\` 和 \`maxRows\` 属性大于 \`0\` 时，自动限制高度。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusTextArea {
                        width: parent.width
                        placeholderText: 'Autosize height based on content lines'
                        autoSize: true
                    }

                    HusTextArea {
                        width: parent.width
                        placeholderText: 'Autosize height with minimum and maximum number of lines'
                        autoSize: true
                        minRows: 2
                        maxRows: 6
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTextArea {
                    width: parent.width
                    placeholderText: 'Autosize height based on content lines'
                    autoSize: true
                }

                HusTextArea {
                    width: parent.width
                    placeholderText: 'Autosize height with minimum and maximum number of lines'
                    autoSize: true
                    minRows: 2
                    maxRows: 6
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('带数字的提示')
            desc: qsTr(`
带数字的提示。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width

                    HusTextArea {
                        id: textArea1
                        width: parent.width
                        maxLength: 20
                        autoSize: true
                        placeholderText: 'maxLength is 20'
                    }

                    HusText {
                        anchors.right: parent.right
                        text: \`\${textArea1.length}/\${textArea1.maxLength}\`
                        color: textArea1.colorPlaceholderText
                    }
                }
            `
            exampleDelegate: Column {

                HusTextArea {
                    id: textArea1
                    width: parent.width
                    maxLength: 20
                    autoSize: true
                    placeholderText: 'maxLength is 20'
                }

                HusText {
                    anchors.right: parent.right
                    text: `${textArea1.length}/${textArea1.maxLength}`
                    color: textArea1.colorPlaceholderText
                }
            }
        }
    }
}

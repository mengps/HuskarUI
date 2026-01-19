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
# HusDivider 分割线\n
区隔内容的分割线。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **titleDelegate: Component** 标题代理\n
- **splitDelegate: Component** 分割线代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
title | string | '' | 标题
titleFont | font | - | 标题字体
titleAlign | enum | HusDivider.Align_Left | 标题对齐(来自 HusDivider)
titlePadding | int | 20 | 标题填充
lineStyle | enum | HusDivider.SolidLine | 分割线样式(来自 HusDivider)
lineWidth | real | 1 | 分割线宽度
dashPattern | list | [4, 2] | 分割线虚线模式
orientation | enum | Qt.Horizontal | 方向(Qt.Horizontal 或 Qt.Vertical)
colorText | color | - | 标题颜色
colorSplit | color | - | 分割线颜色
contentDescription | string | '' | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 对不同章节的文本段落进行分割。\n
- 对行内文字/链接进行分割，例如表格的操作列。\n
                       `)
        }

        ThemeToken {
            source: 'HusDivider'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusDivider.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`title\` 属性改变标题文字。\n
通过 \`titleAlign\` 属性改变标题对齐，支持的对齐：\n
- 居左(默认){ HusDivider.Align_Left }\n
- 居中{ HusDivider.Align_Center }\n
- 居右{ HusDivider.Align_Right }
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 15

                    HusText {
                        width: parent.width
                        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.'
                        wrapMode: Text.WrapAnywhere
                    }

                    HusDivider {
                        width: parent.width
                        height: 30
                        title: qsTr('水平分割线-居左')
                        titleAlign: HusDivider.Align_Left
                    }

                    HusDivider {
                        width: parent.width
                        height: 30
                        title: qsTr('水平分割线-居中')
                        titleAlign: HusDivider.Align_Center
                    }

                    HusDivider {
                        width: parent.width
                        height: 30
                        title: qsTr('水平分割线-居右')
                        titleAlign: HusDivider.Align_Right
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusText {
                    width: parent.width
                    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.'
                    wrapMode: Text.WrapAnywhere
                }

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('水平分割线-居左')
                    titleAlign: HusDivider.Align_Left
                }

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('水平分割线-居中')
                    titleAlign: HusDivider.Align_Center
                }

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('水平分割线-居右')
                    titleAlign: HusDivider.Align_Right
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`orientation\` 属性改变方向，支持的方向：\n
- 水平分割线(默认){ Qt.Horizontal }\n
- 垂直分割线{ Qt.Vertical }\n
如果需要垂直标题，请自行添加\`\\n\`
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 15

                    HusText {
                        width: parent.width
                        text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                        wrapMode: Text.WrapAnywhere
                    }

                    HusDivider {
                        width: parent.width
                        height: 30
                        title: qsTr('水平分割线')
                    }

                    HusDivider {
                        width: 30
                        height: 200
                        orientation: Qt.Vertical
                        title: qsTr('垂\\n直\\n分\\n割\\n线')
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusText {
                    width: parent.width
                    text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                    wrapMode: Text.WrapAnywhere
                }

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('水平分割线')
                }

                HusDivider {
                    width: 30
                    height: 200
                    orientation: Qt.Vertical
                    title: qsTr('垂\n直\n分\n割\n线')
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`lineStyle\` 属性改变线条风格，支持的风格：\n
- 实线(默认){ HusDivider.SolidLine }\n
- 虚线{ HusDivider.DashLine }
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 15

                    HusText {
                        width: parent.width
                        text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                        wrapMode: Text.WrapAnywhere
                    }

                    HusDivider {
                        width: parent.width
                        height: 30
                        title: qsTr('实线分割线')
                    }

                    HusDivider {
                        width: parent.width
                        height: 30
                        lineStyle: HusDivider.DashLine
                        title: qsTr('虚线分割线')
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusText {
                    width: parent.width
                    text: qsTr('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.')
                    wrapMode: Text.WrapAnywhere
                }

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('实线分割线')
                }

                HusDivider {
                    width: parent.width
                    height: 30
                    lineStyle: HusDivider.DashLine
                    title: qsTr('虚线分割线')
                }
            }
        }
    }
}

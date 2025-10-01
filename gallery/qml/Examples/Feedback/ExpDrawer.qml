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
# HusDrawer 抽屉 \n
屏幕边缘滑出的浮层面板。\n
* **继承自 { Drawer }**\n
\n<br/>
\n### 支持的代理：\n
- **closeDelegate: Component** 关闭按钮代理\n
- **titleDelegate: Component** 标题代理\n
- **contentDelegate: Component** 内容代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
maskClosable | bool | true | 点击蒙层是否允许关闭
closePosition | enum | HusDrawer.Position_Start | 关闭按钮的位置(来自 HusDrawer)
drawerSize | int | 378 | 抽屉宽度
edge | enum | Qt.RightEdge | 抽屉打开的位置(来自 Qt.*Edge)
title | string | '' | 标题文本
titleFont | font | - | 标题字体
colorTitle | color | - | 标题颜色
colorBg | color | - | 抽屉背景颜色
colorOverlay | color | - | 覆盖层颜色
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
抽屉从父窗体边缘滑入，覆盖住部分父窗体内容。用户在抽屉内操作时不必离开当前任务，操作完成后，可以平滑地回到原任务。
- 当需要一个附加的面板来控制父窗体内容，这个面板在需要时呼出。比如，控制界面展示样式，往界面中添加内容。\n
- 当需要在当前任务流中插入临时任务，创建或预览附加内容。比如展示协议条款，创建子对象。\n
                       `)
        }

        ThemeToken {
            source: 'HusDrawer'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            async: false
            desc: qsTr(`
基础抽屉，点击触发按钮抽屉从右滑出，点击遮罩区(非抽屉区)关闭。
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    HusButton {
                        type: HusButton.Type_Primary
                        text: qsTr('打开')
                        onClicked: drawer.open();

                        HusDrawer {
                            id: drawer
                            title: qsTr('Basic Drawer')
                            contentDelegate: HusCopyableText {
                                leftPadding: 15
                                text: 'Some contents...\\nSome contents...\\nSome contents...'
                            }
                        }
                    }
                }
            `
            exampleDelegate: Row {
                HusButton {
                    type: HusButton.Type_Primary
                    text: qsTr('打开')
                    onClicked: drawer.open();

                    HusDrawer {
                        id: drawer
                        title: qsTr('Basic Drawer')
                        contentDelegate: HusCopyableText {
                            leftPadding: 15
                            text: 'Some contents...\nSome contents...\nSome contents...'
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            desc: qsTr(`
通过 \`edge\` 属性设置抽屉打开的位置，支持的位置：\n
- 抽屉在窗口上边{ Qt.TopEdge }\n
- 抽屉在项目下边{ Qt.BottomEdge }\n
- 抽屉在项目左边{ Qt.LeftEdge }\n
- 抽屉在项目右边(默认){ Qt.RightEdge }\n\n
通过 \`closePosition\` 属性设置抽屉关闭按钮的位置，支持的位置：\n
- 起始位置(默认){ HusDrawer.Position_Start }\n
- 末尾位置{ HusDrawer.Position_End }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusButton {
                        type: HusButton.Type_Primary
                        text: qsTr('打开')
                        onClicked: drawer2.open();

                        HusDrawer {
                            id: drawer2
                            edge: edgeRadio.currentCheckedValue
                            title: qsTr('Basic Drawer')
                            closePosition: closeRadio.currentCheckedValue
                            contentDelegate: HusCopyableText {
                                leftPadding: 15
                                text: 'Some contents...\nSome contents...\nSome contents...'
                            }
                        }
                    }

                    HusRadioBlock {
                        id: edgeRadio
                        initCheckedIndex: 3
                        model: [
                            { label: 'Top', value: Qt.TopEdge },
                            { label: 'Bottom', value: Qt.BottomEdge },
                            { label: 'Left', value: Qt.LeftEdge },
                            { label: 'Right', value: Qt.RightEdge }
                        ]
                    }

                    HusRadioBlock {
                        id: closeRadio
                        initCheckedIndex: 0
                        model: [
                            { label: 'Start', value: HusDrawer.Position_Start },
                            { label: 'End', value: HusDrawer.Position_End }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButton {
                    type: HusButton.Type_Primary
                    text: qsTr('打开')
                    onClicked: drawer2.open();

                    HusDrawer {
                        id: drawer2
                        edge: edgeRadio.currentCheckedValue
                        title: qsTr('Basic Drawer')
                        closePosition: closeRadio.currentCheckedValue
                        contentDelegate: HusCopyableText {
                            leftPadding: 15
                            text: 'Some contents...\nSome contents...\nSome contents...'
                        }
                    }
                }

                HusRadioBlock {
                    id: edgeRadio
                    initCheckedIndex: 3
                    model: [
                        { label: 'Top', value: Qt.TopEdge },
                        { label: 'Bottom', value: Qt.BottomEdge },
                        { label: 'Left', value: Qt.LeftEdge },
                        { label: 'Right', value: Qt.RightEdge }
                    ]
                }

                HusRadioBlock {
                    id: closeRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Start', value: HusDrawer.Position_Start },
                        { label: 'End', value: HusDrawer.Position_End }
                    ]
                }
            }
        }
    }
}

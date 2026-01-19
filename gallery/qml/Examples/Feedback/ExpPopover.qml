import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    HusMessage {
        id: message
        z: 999
        parent: galleryWindow.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        DocDescription {
            desc: qsTr(`
# HusPopover 气泡显示框 \n
点击元素，弹出气泡式的显示框。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { [HusPopup](internal://HusPopup) }**\n
\n<br/>
\n### 支持的代理：\n
- **arrowDelegate: Component** 箭头代理\n
- **iconDelegate: Component** 图标代理\n
- **titleDelegate: Component** 标题代理\n
- **descriptionDelegate: Component** 描述代理\n
- **contentDelegate: Component** 内容代理\n
- **bgDelegate: Component** 背景代理\n
- **footerDelegate: Component** 页脚代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
iconSource | int丨string | HusIcon.ExclamationCircleFilled丨'' | 图标源(来自 HusIcon)或图标链接
iconSize | int | 16 | 图标大小
title | string | '' | 标题文本
description | string | '' | 描述文本
showArrow | bool | true | 是否显示箭头
arrowWidth | int | 16 | 箭头宽度
arrowHeight | int | 8 | 箭头高度
colorIcon | color | - | 图标颜色
colorTitle | color | - | 标题文本颜色
colorDescription | color | - | 描述文本颜色
titleFont | font | - | 标题文本字体
descriptionFont | font | - | 描述文本字体
\n<br/>
\n **注意** 需要显示给出弹出宽度，高度将根据内容自动计算
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
目标元素的操作需要展示更多详细信息时，在目标元素附近弹出浮层提示。\n
                       `)
        }

        ThemeToken {
            source: 'HusPopover'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusPopover.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
最简单的用法，支持标题和描述。\n
通过 \`title\` 属性设置标题文本。\n
通过 \`description\` 属性设置描述文本。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 10

                    HusButton {
                        text: 'Hover'
                        type: HusButton.Type_Outlined

                        HusPopover {
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 300
                            visible: parent.hovered || parent.down
                            closePolicy: HusPopover.NoAutoClose
                            title: 'Hover details'
                            description: 'What are you doing here?'
                        }
                    }

                    HusButton {
                        text: 'Click'
                        type: HusButton.Type_Outlined
                        onClicked: popover.open();

                        HusPopover {
                            id: popover
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 300
                            title: 'Click details'
                            description: 'What are you doing here?'
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusButton {
                    text: 'Hover'
                    type: HusButton.Type_Outlined

                    HusPopover {
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        width: 300
                        visible: parent.hovered || parent.down
                        closePolicy: HusPopover.NoAutoClose
                        title: 'Hover details'
                        description: 'What are you doing here?'
                    }
                }

                HusButton {
                    text: 'Click'
                    type: HusButton.Type_Outlined
                    onClicked: popover.open();

                    HusPopover {
                        id: popover
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        width: 300
                        title: 'Click details'
                        description: 'What are you doing here?'
                    }
                }
            }
        }
    }
}

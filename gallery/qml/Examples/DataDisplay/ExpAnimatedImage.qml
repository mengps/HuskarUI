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
# HusAnimatedImage 动态图片\n
可预览的动态图片。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { AnimatedImage }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
previewEnabled | bool | true| 是否启用预览
hovered | bool(readonly) | - | 鼠标是否悬浮
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
fallback | url | '' | 加载失败时显示的图像占位符
placeholder | url | '' | 加载时显示的图像占位符
items | list | [] | 预览图片源
\n<br/>
\n### {items}支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
url | url | 必选 | 图片源
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要展示动态图片时使用。\n
- 加载显示动态图或加载失败时容错处理。\n
                       `)
        }

        ThemeToken {
            source: 'HusImage'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusAnimatedImage.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
基本用法与 [HusImage](internal://HusImage) 一致。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSwitch {
                        id: previewEnabledSwitch
                        checkedText: 'Enable'
                        uncheckedText: 'Disable'
                        checked: true
                    }

                    HusAnimatedImage {
                        width: 200
                        height: width
                        source: 'https://gw.alipayobjects.com/zos/rmsportal/LyTPSGknLUlxiVdwMWyu.gif'
                        previewEnabled: previewEnabledSwitch.checked
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSwitch {
                    id: previewEnabledSwitch
                    checkedText: 'Enable'
                    uncheckedText: 'Disable'
                    checked: true
                }

                HusAnimatedImage {
                    width: 200
                    height: width
                    source: 'https://gw.alipayobjects.com/zos/rmsportal/LyTPSGknLUlxiVdwMWyu.gif'
                    previewEnabled: previewEnabledSwitch.checked
                }
            }
        }
    }
}

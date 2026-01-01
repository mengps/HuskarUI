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
# HusEmpty 空状态 \n
显示一个表示空状态的图像和描述文本。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **imageDelegate: Component** 图片代理\n
- **descriptionDelegate: Component** 描述文本代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
imageSource | string | '' | 自定义的图片地址(优先显示此地址)
imageStyle | int | HusEmpty.Style_Default | 预设的图片样式(来自 HusEmpty)
imageWidth | int | - | 图片宽度
imageHeight | int | - | 图片高度
showDescription | bool | true | 是否显示描述文本
description | string | '' | 描述文本
descriptionFont | font | - | 描述文本字体
descriptionSpacing | int | 12 | 描述文本与图像的间距
colorDescription | color | - | 描述文本颜色
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
目标元素为空，如查无数据时，在目标元素占位。\n
                       `)
        }

        ThemeToken {
            source: 'HusEmpty'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
最简单的用法，支持图像和描述。\n
通过 \`imageSource\` 属性设置图片地址。\n
通过 \`imageStyle\` 属性设置预设的图片样式。\n
通过 \`description\` 属性设置描述文本。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10
    
                    HusRadioBlock {
                        id: imageStyleRadio
                        initCheckedIndex: 1
                        model: [
                            { label: 'None', value: HusEmpty.Style_None },
                            { label: 'Default', value: HusEmpty.Style_Default },
                            { label: 'Simple', value: HusEmpty.Style_Simple }
                        ]
                    }

                    Rectangle {
                        width: 230
                        height: 230
                        color: HusTheme.Primary.colorBgBase

                        HusEmpty {
                            anchors.fill: parent
                            imageStyle: imageStyleRadio.currentCheckedValue
                            description: qsTr('暂无数据')
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRadioBlock {
                    id: imageStyleRadio
                    initCheckedIndex: 1
                    model: [
                        { label: 'None', value: HusEmpty.Style_None },
                        { label: 'Default', value: HusEmpty.Style_Default },
                        { label: 'Simple', value: HusEmpty.Style_Simple }
                    ]
                }

                Rectangle {
                    width: 230
                    height: 230
                    color: HusTheme.Primary.colorBgBase

                    HusEmpty {
                        anchors.fill: parent
                        imageStyle: imageStyleRadio.currentCheckedValue
                        description: qsTr('暂无数据')
                    }
                }
            }
        }
    }
}

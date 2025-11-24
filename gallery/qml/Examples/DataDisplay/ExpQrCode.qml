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
# HusQrCode 二维码 \n
能够将文本转换生成二维码的组件，支持自定义配色和 Logo 配置。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
text | string | '' | 要编码的内容
margin | int | 4 | 边距
errorLevel | enum | HusQrCode.Medium | 纠错等级(来自 HusQrCode)
icon.url | url | '' | 图标链接
icon.width | int | 40 | 图标宽度
icon.height | int | 40 | 图高度标
color | color | 'black' | 二维码颜色
colorMargin | color | 'transparent' | 边距颜色
colorBg | color | 'transparent' | 背景颜色
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当需要将文本转换成为二维码时使用。\n
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
            descTitle: qsTr('基本使用')
            desc: qsTr(`
通过 \`text\` 属性设置文本内容。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusQrCode {
                        text: input.text
                        color: HusTheme.Primary.colorTextBase

                        Rectangle {
                            anchors.fill: parent
                            radius: HusTheme.Primary.radiusPrimary
                            color: 'transparent'
                            border.color: HusTheme.Primary.colorFillPrimary
                        }
                    }

                    HusInput {
                        id: input
                        width: 280
                        maximumLength: 60
                        text: 'https://github.com/mengps/HuskarUI'
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusQrCode {
                    text: input.text
                    color: HusTheme.Primary.colorTextBase

                    Rectangle {
                        anchors.fill: parent
                        radius: HusTheme.Primary.radiusPrimary
                        color: 'transparent'
                        border.color: HusTheme.Primary.colorFillPrimary
                    }
                }

                HusInput {
                    id: input
                    width: 280
                    maximumLength: 60
                    text: 'https://github.com/mengps/HuskarUI'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('带 Icon 的例子')
            desc: qsTr(`
通过 \`icon\` 属性设置图标对象，支持的属性有：\n
- icon.url 图标链接\n
- icon.width 图标宽度(默认40)\n
- icon.height 图标高度(默认40)\n
通过 \`errorLevel\` 属性设置错误级别，支持的级别有：\n
- L级 { HusQrCode.Low }\n
- M级(默认) { HusQrCode.Medium }\n
- Q级 { HusQrCode.Quartile }\n
- H级{ HusQrCode.High }\n
**说明:** L级 可纠正约 7% 错误、M级 可纠正约 15% 错误、Q级 可纠正约 25% 错误、H级 可纠正约30% 错误。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusQrCode {
                        text: 'https://github.com/mengps/HuskarUI'
                        errorLevel: HusQrCode.High
                        color: HusTheme.Primary.colorTextBase
                        icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

                        Rectangle {
                            anchors.fill: parent
                            radius: HusTheme.Primary.radiusPrimary
                            color: 'transparent'
                            border.color: HusTheme.Primary.colorFillPrimary
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusQrCode {
                    text: 'https://github.com/mengps/HuskarUI'
                    errorLevel: HusQrCode.High
                    color: HusTheme.Primary.colorTextBase
                    icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

                    Rectangle {
                        anchors.fill: parent
                        radius: HusTheme.Primary.radiusPrimary
                        color: 'transparent'
                        border.color: HusTheme.Primary.colorFillPrimary
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义尺寸')
            desc: qsTr(`
通过 \`width/height\` 属性设置二维码大小。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusButtonBlock {
                        id: sizeBlock
                        model: [
                            { iconSource: HusIcon.MinusOutlined, autoRepeat: true, label: 'Smaller' },
                            { iconSource: HusIcon.PlusOutlined, autoRepeat: true, label: 'Larger' },
                        ]
                        onClicked:
                            (index) => {
                                if (index === 0) size = Math.max(48, Math.min(300, size - 10));
                                if (index === 1) size = Math.max(48, Math.min(300, size + 10));
                            }
                        property int size: 160
                    }

                    HusQrCode {
                        text: 'https://github.com/mengps/HuskarUI'
                        width: sizeBlock.size
                        height: sizeBlock.size
                        errorLevel: HusQrCode.High
                        color: HusTheme.Primary.colorTextBase
                        icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

                        Rectangle {
                            anchors.fill: parent
                            radius: HusTheme.Primary.radiusPrimary
                            color: 'transparent'
                            border.color: HusTheme.Primary.colorFillPrimary
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButtonBlock {
                    id: sizeBlock
                    model: [
                        { iconSource: HusIcon.MinusOutlined, autoRepeat: true, label: 'Smaller' },
                        { iconSource: HusIcon.PlusOutlined, autoRepeat: true, label: 'Larger' },
                    ]
                    onClicked:
                        (index) => {
                            if (index === 0) size = Math.max(48, Math.min(300, size - 10));
                            if (index === 1) size = Math.max(48, Math.min(300, size + 10));
                        }
                    property int size: 160
                }

                HusQrCode {
                    text: 'https://github.com/mengps/HuskarUI'
                    width: sizeBlock.size
                    height: sizeBlock.size
                    errorLevel: HusQrCode.High
                    color: HusTheme.Primary.colorTextBase
                    icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

                    Rectangle {
                        anchors.fill: parent
                        radius: HusTheme.Primary.radiusPrimary
                        color: 'transparent'
                        border.color: HusTheme.Primary.colorFillPrimary
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义颜色')
            desc: qsTr(`
通过 \`color\` 属性设置二维码颜色。\n
通过 \`colorBg\` 属性设置背景颜色。\n
通过 \`colorMargin\` 属性设置边缘颜色。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 10

                    HusQrCode {
                        text: 'https://github.com/mengps/HuskarUI'
                        color: HusTheme.Primary.colorSuccess
                    }

                    HusQrCode {
                        text: 'https://github.com/mengps/HuskarUI'
                        color: HusTheme.Primary.colorInfo
                        colorBg: HusTheme.Primary.colorWarning
                        colorMargin: "#80ff0000"
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusQrCode {
                    text: 'https://github.com/mengps/HuskarUI'
                    color: HusTheme.Primary.colorSuccess
                }

                HusQrCode {
                    text: 'https://github.com/mengps/HuskarUI'
                    color: HusTheme.Primary.colorInfo
                    colorBg: HusTheme.Primary.colorWarning
                    colorMargin: "#80ff0000"
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('高级用法')
            desc: qsTr(`
带气泡卡片的例子。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 10

                    HusButton {
                        text: 'Hover me'
                        type: HusButton.Type_Primary

                        HusPopover {
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 160
                            visible: parent.hovered || parent.down
                            closePolicy: HusPopover.NoAutoClose
                            contentDelegate: HusQrCode {
                                text: 'https://github.com/mengps/HuskarUI'
                                color: HusTheme.Primary.colorTextBase
                            }
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusButton {
                    text: 'Hover me'
                    type: HusButton.Type_Primary

                    HusPopover {
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        width: 160
                        visible: parent.hovered || parent.down
                        closePolicy: HusPopover.NoAutoClose
                        contentDelegate: HusQrCode {
                            text: 'https://github.com/mengps/HuskarUI'
                            color: HusTheme.Primary.colorTextBase
                        }
                    }
                }
            }
        }
    }
}

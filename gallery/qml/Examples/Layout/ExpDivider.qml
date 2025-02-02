import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelDivider 分割线\n
区隔内容的分割线。\n
* **继承自 { Item }**\n
支持的代理：\n
- **titleDelegate: Component** 标题代理\n
- **splitDelegate: Component** 分割线代理\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
title | string | 标题
titleFont | font | 标题字体
titleAlign | int | 标题对齐(来自 DelDivider)
titlePadding | int | 标题填充
colorText | color | 标题颜色
colorSplit | color | 分割线颜色
contentDescription | string | 内容描述(提高可用性)
style | int | 分割线样式(来自 DelDivider)
orientation | int | 方向( Qt.Horizontal 或 Qt.Vertical )
                       `)
        }

        Text {
            width: parent.width - 20
            height: implicitHeight - 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("代码演示")
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySizeHeading3
            }
            color: DelTheme.Primary.colorTextBase
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`title\` 属性改变标题文字\n
通过 \`titleAlign\` 属性改变标题对齐，支持的对齐：\n
- 居左(默认){ DelDivider.AlignLeft }\n
- 居中{ DelDivider.AlignCenter }\n
- 居右{ DelDivider.AlignRight }
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 15

                    Text {
                        width: parent.width
                        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                        wrapMode: Text.WrapAnywhere
                        color: DelTheme.Primary.colorTextBase
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("水平分割线-居左")
                        titleAlign: DelDivider.AlignLeft
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("水平分割线-居中")
                        titleAlign: DelDivider.AlignCenter
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("水平分割线-居右")
                        titleAlign: DelDivider.AlignRight
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Text {
                    width: parent.width
                    text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                    wrapMode: Text.WrapAnywhere
                    color: DelTheme.Primary.colorTextBase
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("水平分割线-居左")
                    titleAlign: DelDivider.AlignLeft
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("水平分割线-居中")
                    titleAlign: DelDivider.AlignCenter
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("水平分割线-居右")
                    titleAlign: DelDivider.AlignRight
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
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 15

                    Text {
                        width: parent.width
                        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                        wrapMode: Text.WrapAnywhere
                        color: DelTheme.Primary.colorTextBase
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("水平分割线")
                    }

                    DelDivider {
                        width: 30
                        height: 200
                        orientation: Qt.Vertical
                        title: qsTr("垂\\n直\\n分\\n割\\n线")
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Text {
                    width: parent.width
                    text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                    wrapMode: Text.WrapAnywhere
                    color: DelTheme.Primary.colorTextBase
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("水平分割线")
                }

                DelDivider {
                    width: 30
                    height: 200
                    orientation: Qt.Vertical
                    title: qsTr("垂\n直\n分\n割\n线")
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`style\` 属性改变线条风格，支持的风格：\n
- 实线(默认){ DelDivider.SolidLine }\n
- 虚线{ DelDivider.DashLine }
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 15

                    Text {
                        width: parent.width
                        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                        wrapMode: Text.WrapAnywhere
                        color: DelTheme.Primary.colorTextBase
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("实线分割线")
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        style: DelDivider.DashLine
                        title: qsTr("虚线分割线")
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Text {
                    width: parent.width
                    text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                    wrapMode: Text.WrapAnywhere
                    color: DelTheme.Primary.colorTextBase
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("实线分割线")
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    style: DelDivider.DashLine
                    title: qsTr("虚线分割线")
                }
            }
        }
    }
}

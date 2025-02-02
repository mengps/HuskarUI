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
## DelSwitch 开关\n
使用开关切换两种状态之间。\n
* **继承自 { Button }**\n
支持的代理：\n
- **handleDelgate: Component** 开关把手代理\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
effectEnabled | bool | 是否开启点击效果(默认true)
loading | bool | 是否在加载中
checkedText | string | 选中文本
uncheckedText | string | 未选中文本
checkedIconSource | int | 选中图标(来自 DelIcon)
uncheckedIconSource | int | 未选中图标(来自 DelIcon)
contentDescription | string | 内容描述(提高可用性)
radiusBg | int | 背景半径
colorHandle | color | 把手颜色
colorBg | color | 背景颜色
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
最简单的用法。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    DelSwitch { }
                }
            `
            exampleDelegate: Row {
                DelSwitch { }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
Switch 失效状态，由 \`enabled\` 属性控制。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 15

                    DelSwitch {
                        id: switch1
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("切换 enabled")
                        type: DelButton.Type_Primary
                        onClicked: switch1.enabled = !switch1.enabled;
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                DelSwitch {
                    id: switch1
                    enabled: false
                }

                DelButton {
                    text: qsTr("切换 enabled")
                    type: DelButton.Type_Primary
                    onClicked: switch1.enabled = !switch1.enabled;
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
Switch 支持两种文本：\n
\`checkedText\` 属性设置选中文本\n
\`uncheckedText\` 属性设置未选中文本\n
或者：\n
\`checkedIconSource\` 属性设置选中图标\n
\`uncheckedIconSource\` 属性设置未选中图标\n
**注意**：如果两种同时设置了，则显示为图标。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 15

                    DelSwitch {
                        checkedText: qsTr("开启")
                        uncheckedText: qsTr("关闭")
                    }

                    DelSwitch {
                        checkedIconSource: DelIcon.CheckOutlined
                        uncheckedIconSource: DelIcon.CloseOutlined
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                DelSwitch {
                    checkedText: qsTr("开启")
                    uncheckedText: qsTr("关闭")
                }

                DelSwitch {
                    checkedIconSource: DelIcon.CheckOutlined
                    uncheckedIconSource: DelIcon.CloseOutlined
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`loading\` 属性设置开关显示加载动画。\n
可以让 \`enabled\` 绑定 \`loading\` 实现加载完成才启用。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 15

                    DelSwitch {
                        loading: true
                        checked: true
                    }

                    DelSwitch {
                        loading: true
                        checked: true
                        enabled: !loading
                    }

                    DelSwitch {
                        loading: true
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                DelSwitch {
                    loading: true
                    checked: true
                }

                DelSwitch {
                    loading: true
                    checked: true
                    enabled: !loading
                }

                DelSwitch {
                    loading: true
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`handleDelegate\` 属性定义开关把手的代理。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 15

                    DelSwitch {
                        id: switch2
                        radiusBg: 2
                        handleDelegate: Rectangle {
                            radius: 2
                            color: switch2.colorHandle
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                DelSwitch {
                    id: switch2
                    radiusBg: 2
                    handleDelegate: Rectangle {
                        radius: 2
                        color: switch2.colorHandle
                    }
                }
            }
        }
    }
}

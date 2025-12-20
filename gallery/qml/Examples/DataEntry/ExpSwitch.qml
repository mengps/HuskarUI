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
# HusSwitch 开关\n
使用开关切换两种状态之间。\n
* **继承自 { Switch }**\n
\n<br/>
\n### 支持的代理：\n
- **handleDelgate: Component** 开关把手代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
hoverCursorShape | enum | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
loading | bool | false | 是否在加载中
checkedText | string | '' | 选中文本
uncheckedText | string | '' | 未选中文本
checkedIconSource | int丨string | 0丨'' | 选中图标(来自 HusIcon)或图标链接
uncheckedIconSource | int丨string | 0丨'' | 未选中图标(来自 HusIcon)或图标链接
iconSize | int | - | 选中/未选中图标大小
textFont | font | - | 文本字体
colorText | color | - | 文本颜色
colorHandle | color | - | 把手颜色
colorBg | color | - | 背景颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景半径
contentDescription | string | '' | 内容描述(提高可用性)
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要表示开关状态/两种状态之间的切换时。\n
- 和 [HusCheckBox](internal://HusCheckBox) 的区别是，切换 HusSwitch 会直接触发状态改变，而 [HusCheckBox](internal://HusCheckBox) 一般用于状态标记，需要和提交操作配合。\n
                       `)
        }

        ThemeToken {
            source: 'HusSwitch'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
最简单的用法。
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    HusSwitch { }
                }
            `
            exampleDelegate: Row {
                HusSwitch { }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
Switch 失效状态，由 \`enabled\` 属性控制。
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 15

                    HusSwitch {
                        id: switch1
                        enabled: false
                    }

                    HusButton {
                        text: qsTr('切换 enabled')
                        type: HusButton.Type_Primary
                        onClicked: switch1.enabled = !switch1.enabled;
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusSwitch {
                    id: switch1
                    enabled: false
                }

                HusButton {
                    text: qsTr('切换 enabled')
                    type: HusButton.Type_Primary
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
                import HuskarUI.Basic

                Column {
                    spacing: 15

                    HusSwitch {
                        checkedText: qsTr('开启')
                        uncheckedText: qsTr('关闭')
                    }

                    HusSwitch {
                        checkedIconSource: HusIcon.CheckOutlined
                        uncheckedIconSource: HusIcon.CloseOutlined
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusSwitch {
                    checkedText: qsTr('开启')
                    uncheckedText: qsTr('关闭')
                }

                HusSwitch {
                    checkedIconSource: HusIcon.CheckOutlined
                    uncheckedIconSource: HusIcon.CloseOutlined
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
                import HuskarUI.Basic

                Column {
                    spacing: 15

                    HusSwitch {
                        loading: true
                        checked: true
                    }

                    HusSwitch {
                        loading: true
                        checked: true
                        enabled: !loading
                    }

                    HusSwitch {
                        loading: true
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusSwitch {
                    loading: true
                    checked: true
                }

                HusSwitch {
                    loading: true
                    checked: true
                    enabled: !loading
                }

                HusSwitch {
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
                import HuskarUI.Basic

                Column {
                    spacing: 15

                    HusSwitch {
                        id: switch2
                        radiusBg.all: 2
                        handleDelegate: Rectangle {
                            radius: 2
                            color: switch2.colorHandle
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusSwitch {
                    id: switch2
                    radiusBg.all: 2
                    handleDelegate: Rectangle {
                        radius: 2
                        color: switch2.colorHandle
                    }
                }
            }
        }
    }
}

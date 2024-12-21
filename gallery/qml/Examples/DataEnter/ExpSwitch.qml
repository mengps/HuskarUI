import QtQuick
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height

    Column {
        id: column
        width: parent.width
        spacing: 30

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
                        type: DelButtonType.Type_Primary
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
                    type: DelButtonType.Type_Primary
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
    }
}

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
# HusBadge 徽标数\n
图标右上角的圆形徽标数字。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
badgeState | enum | HusBadge.State_Error | 徽标状态(来自 HusBadge)
presetColor | color | '' | 预设颜色
count | int | 0 | 徽标展示的数字
iconSource | int丨string | 0丨'' | 徽标展示的图标(来自 HusIcon)或图标链接
dot | bool | false | 不展示数字,只有一个小红点(默认 false)
showZero | bool | false | 当数值为 0 时, 是否展示 HusBadge
overflowCount | int | 99 | 展示封顶的数字值
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorText | color | - | 文本颜色
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
一般出现在通知图标或头像的右上角，用于显示需要处理的消息条数，通过醒目视觉形式吸引用户处理。\n
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusBadge.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
通过 \`count \` 属性设置展示的数字，大于 overflowCount 时显示为 {overflowCount}+，为 0 时隐藏。\n
通过 \`showZero\` 属性设置为 0 时也显示数字。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 20

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge { count: 5 }
                    }

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge { count: 0; showZero: true }
                    }

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge {
                            iconSource: HusIcon.ClockCircleOutlined
                            colorBorder: 'transparent'
                            colorBg: 'transparent'
                            colorText: '#f5222d'
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 20

                HusAvatar {
                    size: 40
                    radiusBg.all: 6

                    HusBadge { count: 5 }
                }

                HusAvatar {
                    size: 40
                    radiusBg.all: 6

                    HusBadge { count: 0; showZero: true }
                }

                HusAvatar {
                    size: 40
                    radiusBg.all: 6

                    HusBadge {
                        iconSource: HusIcon.ClockCircleOutlined
                        colorBorder: 'transparent'
                        colorBg: 'transparent'
                        colorText: '#f5222d'
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('独立使用')
            desc: qsTr(`
不包裹任何元素即是独立使用，可自定样式展现。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 10

                    HusSwitch {
                        id: showSwitch
                        checked: false
                    }

                    HusBadge { count: showSwitch.checked ? 11 : 0; showZero: true; colorBg: '#faad14' }
                    HusBadge { count: showSwitch.checked ? 25 : 0 }
                    HusBadge {
                        iconSource: showSwitch.checked ? HusIcon.ClockCircleOutlined : 0
                        colorBorder: 'transparent'
                        colorBg: 'transparent'
                        colorText: '#f5222d'
                    }
                    HusBadge { count: showSwitch.checked ? 109 : 0; colorBg: '#52c41a' }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusSwitch {
                    id: showSwitch
                    checked: false
                }

                HusBadge { count: showSwitch.checked ? 11 : 0; showZero: true; colorBg: '#faad14' }
                HusBadge { count: showSwitch.checked ? 25 : 0 }
                HusBadge {
                    iconSource: showSwitch.checked ? HusIcon.ClockCircleOutlined : 0
                    colorBorder: 'transparent'
                    colorBg: 'transparent'
                    colorText: '#f5222d'
                }
                HusBadge { count: showSwitch.checked ? 109 : 0; colorBg: '#52c41a' }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('封顶数字')
            desc: qsTr(`
通过 \`overflowCount\` 属性设置展示封顶的数字值。\n
超过 \`overflowCount\` 的会显示为 \`{overflowCount}+\`，默认的 \`overflowCount\` 为 99。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 20

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge { count: 99 }
                    }

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge { count: 100 }
                    }

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge { count: 99; overflowCount: 10 }
                    }

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge { count: 1000; overflowCount: 999 }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 20

                HusAvatar {
                    size: 40
                    radiusBg.all: 6

                    HusBadge { count: 99 }
                }

                HusAvatar {
                    size: 40
                    radiusBg.all: 6

                    HusBadge { count: 100 }
                }

                HusAvatar {
                    size: 40
                    radiusBg.all: 6

                    HusBadge { count: 99; overflowCount: 10 }
                }

                HusAvatar {
                    size: 40
                    radiusBg.all: 6

                    HusBadge { count: 1000; overflowCount: 999 }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('讨嫌的小红点')
            desc: qsTr(`
没有具体的数字。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 20

                    HusIconText {
                        iconSize: 18
                        iconSource: HusIcon.NotificationOutlined

                        HusBadge { dot: true }
                    }

                    HusButton {
                        padding: 0
                        topPadding: 0
                        bottomPadding: 0
                        type: HusButton.Type_Link
                        text: 'Link something'

                        HusBadge { dot: true }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 20

                HusIconText {
                    iconSize: 18
                    iconSource: HusIcon.NotificationOutlined

                    HusBadge { dot: true }
                }

                HusButton {
                    padding: 0
                    topPadding: 0
                    bottomPadding: 0
                    type: HusButton.Type_Link
                    text: 'Link something'

                    HusBadge { dot: true }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('动态')
            desc: qsTr(`
展示动态变化的效果。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 20
                    width: parent.width

                    Row {
                        spacing: 20

                        HusAvatar {
                            size: 40
                            radiusBg.all: 6

                            HusBadge { id: badge; count: 5 }
                        }

                        HusButtonBlock {
                            model: [
                                { iconSource: HusIcon.MinusOutlined, autoRepeat: true },
                                { iconSource: HusIcon.PlusOutlined, autoRepeat: true },
                                { iconSource: HusIcon.QuestionOutlined, autoRepeat: true },
                            ]
                            onClicked:
                                (index) => {
                                    switch (index) {
                                        case 0: badge.count = Math.max(0, badge.count - 1); break;
                                        case 1: badge.count++; break;
                                        case 2: badge.count = Math.floor(Math.random() * 100); break;
                                    }
                                }
                        }
                    }

                    Row {
                        spacing: 20

                        HusAvatar {
                            size: 40
                            radiusBg.all: 6

                            HusBadge { id: badge2; count: 0; dot: true }
                        }

                        HusSwitch {
                            checked: true
                            onCheckedChanged: badge2.dot = checked;
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 20
                width: parent.width

                Row {
                    spacing: 20

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge { id: badge; count: 5 }
                    }

                    HusButtonBlock {
                        model: [
                            { iconSource: HusIcon.MinusOutlined, autoRepeat: true },
                            { iconSource: HusIcon.PlusOutlined, autoRepeat: true },
                            { iconSource: HusIcon.QuestionOutlined, autoRepeat: true },
                        ]
                        onClicked:
                            (index) => {
                                switch (index) {
                                    case 0: badge.count = Math.max(0, badge.count - 1); break;
                                    case 1: badge.count++; break;
                                    case 2: badge.count = Math.floor(Math.random() * 100); break;
                                }
                            }
                    }
                }

                Row {
                    spacing: 20

                    HusAvatar {
                        size: 40
                        radiusBg.all: 6

                        HusBadge { id: badge2; count: 0; dot: true }
                    }

                    HusSwitch {
                        checked: true
                        onCheckedChanged: badge2.dot = checked;
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('状态点')
            desc: qsTr(`
通过 \`badgeState\` 来设置不同的状态，支持的状态有：\n
- 默认状态{ HusBadge.State_Default }\n
- 成功状态{ HusBadge.State_Success }\n
- 处理中状态(该状态有动效){ HusBadge.State_Processing }\n
- 错误状态(默认){ HusBadge.State_Error }\n
- 警告状态{ HusBadge.State_Warning }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10
                    width: parent.width

                    Row {
                        spacing: 10

                        HusBadge { dot: true; badgeState: HusBadge.State_Success }
                        HusBadge { dot: true; badgeState: HusBadge.State_Processing }
                        HusBadge { dot: true; badgeState: HusBadge.State_Error }
                        HusBadge { dot: true; badgeState: HusBadge.State_Warning }
                        HusBadge { dot: true; badgeState: HusBadge.State_Default }
                    }

                    Column {
                        spacing: 10

                        Row {
                            spacing: 10
                            HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Success }
                            HusText { text: 'Success' }
                        }

                        Row {
                            spacing: 10
                            HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Processing }
                            HusText { text: 'Processing' }
                        }

                        Row {
                            spacing: 10
                            HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Error }
                            HusText { text: 'Error' }
                        }

                        Row {
                            spacing: 10
                            HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Warning }
                            HusText { text: 'Warning' }
                        }

                        Row {
                            spacing: 10
                            HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Default }
                            HusText { text: 'Default' }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    HusBadge { dot: true; badgeState: HusBadge.State_Success }
                    HusBadge { dot: true; badgeState: HusBadge.State_Processing }
                    HusBadge { dot: true; badgeState: HusBadge.State_Error }
                    HusBadge { dot: true; badgeState: HusBadge.State_Warning }
                    HusBadge { dot: true; badgeState: HusBadge.State_Default }
                }

                Column {
                    spacing: 10

                    Row {
                        spacing: 10
                        HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Success }
                        HusText { text: 'Success' }
                    }

                    Row {
                        spacing: 10
                        HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Processing }
                        HusText { text: 'Processing' }
                    }

                    Row {
                        spacing: 10
                        HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Error }
                        HusText { text: 'Error' }
                    }

                    Row {
                        spacing: 10
                        HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Warning }
                        HusText { text: 'Warning' }
                    }

                    Row {
                        spacing: 10
                        HusBadge { anchors.verticalCenter: parent.verticalCenter; dot: true; badgeState: HusBadge.State_Default }
                        HusText { text: 'Default' }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('多彩徽标')
            desc: qsTr(`
我们添加了多种预设色彩的徽标样式，用作不同场景使用。如果预设值不能满足你的需求，可以设置为具体的色值。\n
通过 \`presetColor\` 设置预设颜色。\n
支持的预设颜色：\n
**['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']** \n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10
                    width: parent.width

                    Repeater {
                        model: ['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']
                        delegate: Row {
                            spacing: 10

                            HusBadge {
                                anchors.verticalCenter: parent.verticalCenter
                                dot: true
                                presetColor: modelData
                            }

                            HusText {
                                text: modelData
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Repeater {
                    model: ['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']
                    delegate: Row {
                        spacing: 10

                        HusBadge {
                            anchors.verticalCenter: parent.verticalCenter
                            dot: true
                            presetColor: modelData
                        }

                        HusText {
                            text: modelData
                        }
                    }
                }
            }
        }
    }
}

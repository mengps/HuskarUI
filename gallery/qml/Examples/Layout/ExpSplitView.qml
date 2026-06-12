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

        DocDescription {
            desc: qsTr(`
# HusSplitView 分隔视图 \n
用于水平或垂直布局项目，并在每个项目之间都有一个可拖动的拆分器。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { SplitView }**\n
\n<br/>
\n### 支持的代理：\n
- **collapseBarStart: Component** (左侧/上侧)折叠按钮\n
  - \`index: int\` 把手索引\n
  - \`collapseBarHovered: bool\` 是否悬浮\n
- **collapseBarEnd: Component** (右侧/下侧)折叠按钮\n
  - \`index: int\` 把手索引\n
  - \`collapseBarHovered: bool\` 是否悬浮\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
resizable | bool | true | 是否开启拖拽伸缩
showCollapsibleIcon | string丨bool | false | 是否显示快速折叠图标(为'auto'时自动显示)
handleSize | real | 2 | 拖拽把手大小
handleTriggerSize | real | 6 | 拖拽触发区域大小
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 可以水平或垂直地分隔区域。\n
- 当需要自由拖拽调整各区域大小。\n
- 当需要指定区域的最大最小宽高时。\n
                       `)
        }

        ThemeToken {
            source: 'HusSplitView'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusSplitView.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最简单的用法。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSplitView {
                        width: parent.width
                        height: 300

                        Rectangle {
                            HusSplitView.preferredWidth: parent.width * 0.4
                            HusSplitView.fillHeight: true
                            HusSplitView.minimumWidth: parent.width * 0.1
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'First'
                            }
                        }

                        Rectangle {
                            HusSplitView.fillWidth: true
                            HusSplitView.fillHeight: true
                            HusSplitView.minimumWidth: parent.width * 0.1
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'Second'
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSplitView {
                    width: parent.width
                    height: 300

                    Rectangle {
                        HusSplitView.preferredWidth: parent.width * 0.4
                        HusSplitView.fillHeight: true
                        HusSplitView.minimumWidth: parent.width * 0.1
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'First'
                        }
                    }

                    Rectangle {
                        HusSplitView.fillWidth: true
                        HusSplitView.fillHeight: true
                        HusSplitView.minimumWidth: parent.width * 0.1
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'Second'
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('启用/禁用拖拽')
            desc: qsTr(`
通过 \`resizable\` 属性来启用/禁用拖拽。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSwitch {
                        id: resizableSwitch
                        checked: false
                        checkedText: 'Enabled'
                        uncheckedText: 'Disabled'
                    }

                    HusSplitView {
                        width: parent.width
                        height: 300
                        resizable: resizableSwitch.checked

                        Rectangle {
                            HusSplitView.preferredWidth: parent.width * 0.4
                            HusSplitView.fillHeight: true
                            HusSplitView.minimumWidth: parent.width * 0.1
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'First'
                            }
                        }

                        Rectangle {
                            HusSplitView.fillWidth: true
                            HusSplitView.fillHeight: true
                            HusSplitView.minimumWidth: parent.width * 0.1
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'Second'
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSwitch {
                    id: resizableSwitch
                    checked: false
                    checkedText: 'Enabled'
                    uncheckedText: 'Disabled'
                }

                HusSplitView {
                    width: parent.width
                    height: 300
                    resizable: resizableSwitch.checked

                    Rectangle {
                        HusSplitView.preferredWidth: parent.width * 0.4
                        HusSplitView.fillHeight: true
                        HusSplitView.minimumWidth: parent.width * 0.1
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'First'
                        }
                    }

                    Rectangle {
                        HusSplitView.fillWidth: true
                        HusSplitView.fillHeight: true
                        HusSplitView.minimumWidth: parent.width * 0.1
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'Second'
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('垂直方向')
            desc: qsTr(`
通过 \`orientation\` 属性来设置方向。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSplitView {
                        width: parent.width
                        height: 300
                        orientation: Qt.Vertical

                        Rectangle {
                            HusSplitView.fillWidth: true
                            HusSplitView.preferredHeight: parent.height * 0.5
                            HusSplitView.minimumHeight: parent.height * 0.1
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'First'
                            }
                        }

                        Rectangle {
                            HusSplitView.fillWidth: true
                            HusSplitView.preferredHeight: parent.height * 0.5
                            HusSplitView.minimumHeight: parent.height * 0.1
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'Second'
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSplitView {
                    width: parent.width
                    height: 300
                    orientation: Qt.Vertical

                    Rectangle {
                        HusSplitView.fillWidth: true
                        HusSplitView.preferredHeight: parent.height * 0.5
                        HusSplitView.minimumHeight: parent.height * 0.1
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'First'
                        }
                    }

                    Rectangle {
                        HusSplitView.fillWidth: true
                        HusSplitView.preferredHeight: parent.height * 0.5
                        HusSplitView.minimumHeight: parent.height * 0.1
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'Second'
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('可折叠图标显示')
            desc: qsTr(`
通过 \`showCollapsibleIcon\` 属性来控制可折叠图标的显示方式，支持的方式有：\n
- 不显示(默认){ false }\n
- 始终显示{ true }\n
- 悬浮时显示{ 'auto' }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    Row {
                        spacing: 20

                        HusText {
                            text: 'ShowCollapsibleIcon:'
                        }

                        HusRadio {
                            text: 'Auto'
                            checked: true
                            onToggled: splitView.showCollapsibleIcon = 'auto';
                        }

                        HusRadio {
                            text: 'True'
                            onToggled: splitView.showCollapsibleIcon = true;
                        }

                        HusRadio {
                            text: 'False'
                            onToggled: splitView.showCollapsibleIcon = false;
                        }
                    }

                    HusSplitView {
                        id: splitView
                        width: parent.width
                        height: 300
                        showCollapsibleIcon: 'auto'

                        Rectangle {
                            HusSplitView.preferredWidth: parent.width * 0.2
                            HusSplitView.fillHeight: true
                            clip: true
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'First'
                            }
                        }

                        Rectangle {
                            HusSplitView.preferredWidth: parent.width * 0.2
                            HusSplitView.fillHeight: true
                            clip: true
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'Second'
                            }
                        }

                        Rectangle {
                            HusSplitView.preferredWidth: parent.width * 0.6
                            HusSplitView.fillHeight: true
                            clip: true
                            color: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'Third'
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 20

                    HusText {
                        text: 'ShowCollapsibleIcon:'
                    }

                    HusRadio {
                        text: 'Auto'
                        checked: true
                        onToggled: splitView.showCollapsibleIcon = 'auto';
                    }

                    HusRadio {
                        text: 'True'
                        onToggled: splitView.showCollapsibleIcon = true;
                    }

                    HusRadio {
                        text: 'False'
                        onToggled: splitView.showCollapsibleIcon = false;
                    }
                }

                HusSplitView {
                    id: splitView
                    width: parent.width
                    height: 300
                    showCollapsibleIcon: 'auto'
                    orientation: Qt.Vertical

                    Rectangle {
                        HusSplitView.preferredWidth: parent.width * 0.2
                        HusSplitView.fillHeight: true
                        clip: true
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'First'
                        }
                    }

                    Rectangle {
                        HusSplitView.preferredWidth: parent.width * 0.2
                        HusSplitView.fillHeight: true
                        clip: true
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'Second'
                        }
                    }

                    Rectangle {
                        HusSplitView.preferredWidth: parent.width * 0.6
                        HusSplitView.fillHeight: true
                        clip: true
                        color: HusTheme.Primary.colorBgBase

                        HusText {
                            anchors.centerIn: parent
                            text: 'Third'
                        }
                    }
                }
            }
        }
    }
}

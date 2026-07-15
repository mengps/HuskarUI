import QtQuick
import QtQuick.Layouts
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
# HusFrame 框架\n
逻辑控件组的视觉框架。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Frame }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
colorBg | color | - | 背景颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
borderBg | [HusBorder](internal://HusBorder) | - | 背景边框
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当需要在视觉框架内将一组逻辑控件布局在一起时使用。
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusFrame.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Frame\`
                       `)
            code: `
                import QtQuick
                import QtQuick.Layouts
                import HuskarUI.Basic

                Column {
                    spacing: 15

                    HusFrame {
                        padding: 20

                        HusSpace {
                            anchors.fill: parent
                            layout: 'ColumnLayout'
                            spacing: 10

                            HusCheckBox { text: 'E-mail '}
                            HusCheckBox { text: 'Calendar' }
                            HusCheckBox { text: 'Contacts' }
                        }
                    }

                    HusFrame {
                        padding: 20

                        HusSpace {
                            anchors.fill: parent
                            layout: 'ColumnLayout'

                            HusCard {
                                Layout.fillWidth: true
                                title: 'Card title'
                                extraDelegate: HusButton { type: HusButton.Type_Link; text: 'More' }
                                bodyDescription: 'Card content\nCard content\nCard content'
                            }
                            HusSpace {
                                Layout.fillWidth: true
                                layout: 'RowLayout'

                                HusInput { text: 'https://github.com/mengps/HuskarUI' }
                                HusButton { Layout.preferredWidth: 80; type: HusButton.Type_Primary; text: 'Submit' }
                            }
                            HusSpace {
                                Layout.fillWidth: true
                                layout: 'RowLayout'

                                HusInput { text: 'https://github.com/mengps/HuskarUI' }
                                HusIconButton { Layout.preferredWidth: 80; iconSource: HusIcon.CopyOutlined }
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusFrame {
                    padding: 20

                    HusSpace {
                        layout: 'ColumnLayout'
                        spacing: 10

                        HusCheckBox { text: 'E-mail '}
                        HusCheckBox { text: 'Calendar' }
                        HusCheckBox { text: 'Contacts' }
                    }
                }

                HusFrame {
                    padding: 20

                    HusSpace {
                        layout: 'ColumnLayout'

                        HusCard {
                            Layout.fillWidth: true
                            title: 'Card title'
                            extraDelegate: HusButton { type: HusButton.Type_Link; text: 'More' }
                            bodyDescription: 'Card content\nCard content\nCard content'
                        }
                        HusSpace {
                            Layout.fillWidth: true
                            layout: 'RowLayout'

                            HusInput { text: 'https://github.com/mengps/HuskarUI' }
                            HusButton { Layout.preferredWidth: 80; type: HusButton.Type_Primary; text: 'Submit' }
                        }
                        HusSpace {
                            Layout.fillWidth: true
                            layout: 'RowLayout'

                            HusInput { text: 'https://github.com/mengps/HuskarUI' }
                            HusIconButton { Layout.preferredWidth: 80; iconSource: HusIcon.CopyOutlined }
                        }
                    }
                }
            }
        }
    }
}

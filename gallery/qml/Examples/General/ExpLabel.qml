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
# HusLabel 文本标签\n
扩展了HusText(文本)的功能, 并自带背景和圆角。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Label }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
borderWidth | real | 1 | 边框宽度
colorText | color | - | 文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要统一字体和颜色的并带自背景和圆角的文本时建议使用。
                       `)
        }

        ThemeToken {
            source: 'HusLabel'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusLabel.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Label\`
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 15

                    Row {
                        HusText {
                            anchors.verticalCenter: parent.verticalCenter
                            text: 'Radius:   '
                        }
                        HusSlider {
                            id: radiusSlider
                            width: 150
                            height: 30
                            min: 0
                            max: 30
                            value: 0
                        }
                    }

                    HusSwitch {
                        id: enabledSwitch
                        checked: true
                        text: 'Enabeld: '
                    }

                    HusLabel {
                        padding: 20
                        enabled: enabledSwitch.checked
                        text: qsTr('HusLabel文本')
                        radiusBg.all: radiusSlider.currentValue
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Row {
                    HusText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'Radius:   '
                    }
                    HusSlider {
                        id: radiusSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 30
                        value: 0
                    }
                }

                HusSwitch {
                    id: enabledSwitch
                    checked: true
                    text: 'Enabeld: '
                }

                HusLabel {
                    padding: 20
                    enabled: enabledSwitch.checked
                    text: qsTr('HusLabel文本')
                    radiusBg.all: radiusSlider.currentValue
                }
            }
        }
    }
}

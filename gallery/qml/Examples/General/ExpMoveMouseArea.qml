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
# HusMoveMouseArea 移动鼠标区域\n
提供对任意 Item 进行鼠标移动操作的区域。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { MouseArea }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
target | var | undefined | 要移动的目标
minimumX | real | -Number.MAX_VALUE | 可移动的最小x坐标
maximumX | real | Number.MAX_VALUE | 可移动的最大x坐标
minimumY | real | -Number.MAX_VALUE | 可移动的最小y坐标
maximumY | real | Number.MAX_VALUE | 可移动的最大y坐标
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要实时移动某一项时使用。
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusMoveMouseArea.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`target\` 设置要移动的目标。
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Rectangle {
                    color: 'transparent'
                    border.color: HusTheme.Primary.colorTextQuaternary
                    width: 400
                    height: 400
                    clip: true

                    Rectangle {
                        width: 100
                        height: 100
                        color: 'red'

                        HusMoveMouseArea {
                            anchors.fill: parent
                            target: parent
                            preventStealing: true
                        }
                    }
                }
            `
            exampleDelegate: Rectangle {
                color: 'transparent'
                border.color: HusTheme.Primary.colorTextQuaternary
                width: 400
                height: 400
                clip: true

                Rectangle {
                    width: 100
                    height: 100
                    color: 'red'

                    HusMoveMouseArea {
                        anchors.fill: parent
                        target: parent
                        preventStealing: true
                    }
                }
            }
        }
    }
}

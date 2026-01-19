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
# HusRectangle 圆角矩形\n
在需要任意方向圆角的矩形时使用。\n
**注意** Qt6.7 以后则可以直接使用原生 Rectangle。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
radius | real | 0 | 统一设置四个圆角半径
topLeftRadius | real | -1 | 左上圆角半径
topRightRadius | real | -1 | 右上圆角半径
bottomLeftRadius | real | -1 | 左下圆角半径
bottomRightRadius | real | -1 | 右下圆角半径
color | color | '#fff' | 填充颜色
gradient | Gradient | - | 填充渐变
border.color | color | 'transparent' | 边框线颜色
border.width | int | 1 | 边框线宽度
border.style | int | Qt.SolidLine | 边框线样式(来自 Qt.*)
\n**注意** \`border.style\` 为 HusRectangle 特有。
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在用户需要任意方向圆角的矩形时使用。
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/cpp/controls/husrectangle.cpp'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Rectangle\`
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 15

                    HusRadioBlock {
                        id: styleRadio
                        initCheckedIndex: 0
                        model: [
                            { label: qsTr('实线'), value: Qt.SolidLine },
                            { label: qsTr('虚线'), value: Qt.DashLine },
                            { label: qsTr('虚点线'), value: Qt.DashDotLine },
                            { label: qsTr('虚点点线'), value: Qt.DashDotDotLine }
                        ]
                    }

                    HusSlider {
                        id: bordrWidthSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 20
                        stepSize: 1
                        value: 1

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('边框线宽: ') + parent.currentValue.toFixed(0);
                        }
                    }

                    HusSlider {
                        id: topLeftSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 100
                        stepSize: 1

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('左上圆角: ') + parent.currentValue.toFixed(0);
                        }
                    }

                    HusSlider {
                        id: topRightSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 100
                        stepSize: 1

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('右上圆角: ') + parent.currentValue.toFixed(0);
                        }
                    }

                    HusSlider {
                        id: bottomLeftSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 100
                        stepSize: 1

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('左下圆角: ') + parent.currentValue.toFixed(0);
                        }
                    }

                    HusSlider {
                        id: bottomRightSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 100
                        stepSize: 1

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('右下圆角: ') + parent.currentValue.toFixed(0);
                        }
                    }

                    HusRectangle {
                        width: 200
                        height: 200
                        border.width: bordrWidthSlider.currentValue
                        border.color: HusTheme.Primary.colorTextBase
                        border.style: styleRadio.currentCheckedValue
                        topLeftRadius: topLeftSlider.currentValue
                        topRightRadius: topRightSlider.currentValue
                        bottomLeftRadius: bottomLeftSlider.currentValue
                        bottomRightRadius: bottomRightSlider.currentValue
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: 'red' }
                            GradientStop { position: 0.33; color: 'yellow' }
                            GradientStop { position: 1.0; color: 'green' }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                HusRadioBlock {
                    id: styleRadio
                    initCheckedIndex: 0
                    model: [
                        { label: qsTr('实线'), value: Qt.SolidLine },
                        { label: qsTr('虚线'), value: Qt.DashLine },
                        { label: qsTr('虚点线'), value: Qt.DashDotLine },
                        { label: qsTr('虚点点线'), value: Qt.DashDotDotLine }
                    ]
                }

                HusSlider {
                    id: bordrWidthSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 20
                    stepSize: 1
                    value: 1

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('边框线宽: ') + parent.currentValue.toFixed(0);
                    }
                }

                HusSlider {
                    id: topLeftSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('左上圆角: ') + parent.currentValue.toFixed(0);
                    }
                }

                HusSlider {
                    id: topRightSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('右上圆角: ') + parent.currentValue.toFixed(0);
                    }
                }

                HusSlider {
                    id: bottomLeftSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('左下圆角: ') + parent.currentValue.toFixed(0);
                    }
                }

                HusSlider {
                    id: bottomRightSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('右下圆角: ') + parent.currentValue.toFixed(0);
                    }
                }

                HusRectangle {
                    width: 200
                    height: 200
                    border.width: bordrWidthSlider.currentValue
                    border.color: HusTheme.Primary.colorTextBase
                    border.style: styleRadio.currentCheckedValue
                    topLeftRadius: topLeftSlider.currentValue
                    topRightRadius: topRightSlider.currentValue
                    bottomLeftRadius: bottomLeftSlider.currentValue
                    bottomRightRadius: bottomRightSlider.currentValue
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: 'red' }
                        GradientStop { position: 0.33; color: 'yellow' }
                        GradientStop { position: 1.0; color: 'green' }
                    }
                }
            }
        }
    }
}

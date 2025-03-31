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
## DelRectangle 圆角矩形\n
在需要任意方向圆角的矩形时使用。\n
**注意** Qt6.7 以后则可以直接使用 Rectangle。\n
* **继承自 { QQuickPaintedItem }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
radius | real | 统一设置四个圆角半径
topLeftRadius | real | 左上圆角半径
topRightRadius | real | 右上圆角半径
bottomLeftRadius | real | 左下圆角半径
bottomRightRadius | real | 右下圆角半径
color | color | 填充颜色
border.color | color | 边框线颜色
border.width | int | 边框线宽度
border.style | int | 边框线样式(来自 Qt.*)
\n**注意** \`border.style\` 为 DelRectangle 特有。
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
在用户需要任意方向圆角的矩形时使用。
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Rectangle\`
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 15

                    DelSlider {
                        id: topLeftSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 100
                        stepSize: 1

                        DelCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: "左上圆角: " + parent.currentValue.toFixed(0);
                        }
                    }

                    DelSlider {
                        id: topRightSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 100
                        stepSize: 1

                        DelCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: "右上圆角: " + parent.currentValue.toFixed(0);
                        }
                    }

                    DelSlider {
                        id: bottomLeftSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 100
                        stepSize: 1

                        DelCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: "左下圆角: " + parent.currentValue.toFixed(0);
                        }
                    }

                    DelSlider {
                        id: bottomRightSlider
                        width: 150
                        height: 30
                        min: 0
                        max: 100
                        stepSize: 1

                        DelCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: "右下圆角: " + parent.currentValue.toFixed(0);
                        }
                    }

                    DelRectangle {
                        width: 200
                        height: 200
                        color: "#60ff0000"
                        border.width: 1
                        border.color: DelTheme.Primary.colorTextBase
                        topLeftRadius: topLeftSlider.currentValue
                        topRightRadius: topRightSlider.currentValue
                        bottomLeftRadius: bottomLeftSlider.currentValue
                        bottomRightRadius: bottomRightSlider.currentValue
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                DelRadioBlock {
                    id: styleRadio
                    initCheckedIndex: 0
                    model: [
                        { label: qsTr("实线"), value: Qt.SolidLine },
                        { label: qsTr("虚线"), value: Qt.DashLine },
                        { label: qsTr("虚点线"), value: Qt.DashDotLine },
                        { label: qsTr("虚点点线"), value: Qt.DashDotDotLine }
                    ]
                }

                DelSlider {
                    id: bordrWidthSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 20
                    stepSize: 1
                    value: 1

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr("边框线宽: ") + parent.currentValue.toFixed(0);
                    }
                }

                DelSlider {
                    id: topLeftSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr("左上圆角: ") + parent.currentValue.toFixed(0);
                    }
                }

                DelSlider {
                    id: topRightSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr("右上圆角: ") + parent.currentValue.toFixed(0);
                    }
                }

                DelSlider {
                    id: bottomLeftSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr("左下圆角: ") + parent.currentValue.toFixed(0);
                    }
                }

                DelSlider {
                    id: bottomRightSlider
                    width: 150
                    height: 30
                    min: 0
                    max: 100
                    stepSize: 1

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr("右下圆角: ") + parent.currentValue.toFixed(0);
                    }
                }

                DelRectangle {
                    width: 200
                    height: 200
                    color: "#60ff0000"
                    border.width: bordrWidthSlider.currentValue
                    border.color: DelTheme.Primary.colorTextBase
                    border.style: styleRadio.currentCheckedValue
                    topLeftRadius: topLeftSlider.currentValue
                    topRightRadius: topRightSlider.currentValue
                    bottomLeftRadius: bottomLeftSlider.currentValue
                    bottomRightRadius: bottomRightSlider.currentValue
                }
            }
        }
    }
}

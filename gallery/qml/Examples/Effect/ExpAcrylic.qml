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
## DelAcrylic 亚克力 \n
亚克力/毛玻璃效果。\n
* **继承自 { Item }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
sourceItem | Item | 源项目
sourceRect | rect | 源矩形大小
opacityNoise | real | 噪声图像透明度
radiusBlur | real | 模糊半径
radiusBg | real | 背景半径
colorTint | color | 色调颜色
opacityTint | real | 色调透明度
luminosity | real | 亮度
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
当用户需要实现[亚克力/毛玻璃]的效果时。
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`sourceItem\` 属性设置需要该效果的项目，**注意** \`DelAcrylic\` 不能为 \`sourceItem\` 的子项 \n
通过 \`opacityTint\` 属性设置色调透明度 \n
通过 \`luminosity\` 属性设置亮度 \n
通过 \`radiusBlur\` 模糊半径 \n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {

                    DelSlider {
                        id: opacityTintSlider
                        width: 200
                        height: 30
                        min: 0.0
                        max: 1.0
                        stepSize: 0.01
                        value: 0.65

                        DelCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr("色调透明度: ") + parent.currentValue.toFixed(2);
                        }
                    }

                    DelSlider {
                        id: luminositySlider
                        width: 200
                        height: 30
                        min: 0.0
                        max: 1.0
                        stepSize: 0.01
                        value: 0.01

                        DelCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr("亮度: ") + parent.currentValue.toFixed(2);
                        }
                    }

                    DelSlider {
                        id: radiusBlurSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 128
                        stepSize: 1
                        value: 32

                        DelCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr("模糊半径: ") + parent.currentValue.toFixed(0);
                        }
                    }

                    Rectangle {
                        width: 400
                        height: 400
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "transparent"
                        border.color: DelTheme.Primary.colorTextBase

                        DelIconText {
                            id: source
                            iconSize: 400
                            iconSource: DelIcon.BugOutlined
                            colorIcon: DelTheme.Primary.colorPrimary
                        }

                        DelAcrylic {
                            x: (source.width - width) * 0.5
                            y: (source.height - height) * 0.5
                            width: 200
                            height: width
                            sourceItem: source
                            opacityTint: opacityTintSlider.currentValue
                            luminosity: luminositySlider.currentValue
                            radiusBlur: radiusBlurSlider.currentValue

                            DragHandler {
                                target: parent
                                xAxis.minimum: source.x
                                xAxis.maximum: source.x + source.width - parent.width
                                yAxis.minimum: source.y
                                yAxis.maximum: source.y + source.height - parent.height
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {

                DelSlider {
                    id: opacityTintSlider
                    width: 200
                    height: 30
                    min: 0.0
                    max: 1.0
                    stepSize: 0.01
                    value: 0.65

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr("色调透明度: ") + parent.currentValue.toFixed(2);
                    }
                }

                DelSlider {
                    id: luminositySlider
                    width: 200
                    height: 30
                    min: 0.0
                    max: 1.0
                    stepSize: 0.01
                    value: 0.01

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr("亮度: ") + parent.currentValue.toFixed(2);
                    }
                }

                DelSlider {
                    id: radiusBlurSlider
                    width: 200
                    height: 30
                    min: 0
                    max: 128
                    stepSize: 1
                    value: 32

                    DelCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr("模糊半径: ") + parent.currentValue.toFixed(0);
                    }
                }

                Rectangle {
                    width: 400
                    height: 400
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "transparent"
                    border.color: DelTheme.Primary.colorTextBase

                    DelIconText {
                        id: source
                        iconSize: 400
                        iconSource: DelIcon.BugOutlined
                        colorIcon: DelTheme.Primary.colorPrimary
                    }

                    DelAcrylic {
                        x: (source.width - width) * 0.5
                        y: (source.height - height) * 0.5
                        width: 200
                        height: width
                        sourceItem: source
                        opacityTint: opacityTintSlider.currentValue
                        luminosity: luminositySlider.currentValue
                        radiusBlur: radiusBlurSlider.currentValue

                        DragHandler {
                            target: parent
                            xAxis.minimum: source.x
                            xAxis.maximum: source.x + source.width - parent.width
                            yAxis.minimum: source.y
                            yAxis.maximum: source.y + source.height - parent.height
                        }
                    }
                }
            }
        }
    }
}

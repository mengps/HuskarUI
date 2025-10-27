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
# HusAcrylic 亚克力 \n
亚克力/毛玻璃效果。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
sourceItem | Item | - | 源项目
sourceRect | rect | - | 源矩形大小
opacityNoise | real | 0.02 | 噪声图像透明度
radiusBlur | real | 32 | 模糊半径
colorTint | color | '#fff' | 色调颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
opacityTint | real | 0.65 | 色调透明度
luminosity | real | 0.01 | 亮度
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要实现[亚克力/毛玻璃]的效果时。
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`sourceItem\` 属性设置需要该效果的项目，**注意** \`HusAcrylic\` 不能为 \`sourceItem\` 的子项。\n
通过 \`opacityTint\` 属性设置色调透明度。\n
通过 \`luminosity\` 属性设置亮度。\n
通过 \`radiusBlur\` 模糊半径。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {

                    HusSlider {
                        id: opacityTintSlider
                        width: 200
                        height: 30
                        min: 0.0
                        max: 1.0
                        stepSize: 0.01
                        value: 0.65

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('色调透明度: ') + parent.currentValue.toFixed(2);
                        }
                    }

                    HusSlider {
                        id: luminositySlider
                        width: 200
                        height: 30
                        min: 0.0
                        max: 1.0
                        stepSize: 0.01
                        value: 0.01

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('亮度: ') + parent.currentValue.toFixed(2);
                        }
                    }

                    HusSlider {
                        id: radiusBlurSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 128
                        stepSize: 1
                        value: 32

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('模糊半径: ') + parent.currentValue.toFixed(0);
                        }
                    }

                    Rectangle {
                        width: 400
                        height: 400
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: 'transparent'
                        border.color: HusTheme.Primary.colorTextBase

                        HusIconText {
                            id: source
                            iconSize: 400
                            iconSource: HusIcon.BugOutlined
                            colorIcon: HusTheme.Primary.colorPrimary
                        }

                        HusAcrylic {
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

                HusSlider {
                    id: opacityTintSlider
                    width: 200
                    height: 30
                    min: 0.0
                    max: 1.0
                    stepSize: 0.01
                    value: 0.65

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('色调透明度: ') + parent.currentValue.toFixed(2);
                    }
                }

                HusSlider {
                    id: luminositySlider
                    width: 200
                    height: 30
                    min: 0.0
                    max: 1.0
                    stepSize: 0.01
                    value: 0.01

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('亮度: ') + parent.currentValue.toFixed(2);
                    }
                }

                HusSlider {
                    id: radiusBlurSlider
                    width: 200
                    height: 30
                    min: 0
                    max: 128
                    stepSize: 1
                    value: 32

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('模糊半径: ') + parent.currentValue.toFixed(0);
                    }
                }

                Rectangle {
                    width: 400
                    height: 400
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'transparent'
                    border.color: HusTheme.Primary.colorTextBase

                    HusIconText {
                        id: source
                        iconSize: 400
                        iconSource: HusIcon.BugOutlined
                        colorIcon: HusTheme.Primary.colorPrimary
                    }

                    HusAcrylic {
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

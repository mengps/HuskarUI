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
# HusLiquidGlass 液态玻璃 \n
液态玻璃/折射效果，灵感来源于 Apple WWDC 2025 液态玻璃 (Liquid Glass) 设计风格。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
sourceItem | Item | - | 源项目
sourceRect | rect | - | 源矩形大小
refraction | real | 0.026 | 折射强度
bevelDepth | real | 0.119 | 斜面深度
bevelWidth | real | 0.057 | 斜面宽度
animated | bool | true | 是否启用动态高光
frost | real | 0.0 | 磨砂程度
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
specularIntensity | real | 1.0 | 高光强度
tiltX | real | 0.0 | 水平倾斜角度
tiltY | real | 0.0 | 垂直倾斜角度
magnify | real | 1.0 | 放大倍数
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要实现类似液态玻璃的折射/磨砂效果时。
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusLiquidGlass.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`sourceItem\` 属性设置需要该效果的项目，**注意** \`HusLiquidGlass\` 不能为 \`sourceItem\` 的子项。\n
通过 \`refraction\` 控制折射强度，\`frost\` 控制磨砂程度。\n
通过 \`bevelDepth\` / \`bevelWidth\` 控制边缘斜面效果。\n
通过 \`specularIntensity\` 控制镜面高光强度。\n
通过 \`tiltX\` / \`tiltY\` 模拟倾斜折射。\n
通过 \`magnify\` 控制放大缩小。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {

                    HusSlider {
                        id: refractionSlider
                        width: 200; height: 30
                        min: 0.0; max: 0.1; stepSize: 0.01; value: 0.1
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('折射: ') + parent.currentValue.toFixed(3)
                        }
                    }

                    HusSlider {
                        id: frostSlider
                        width: 200; height: 30
                        min: 0.0; max: 10.0; stepSize: 0.1; value: 1.0
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('磨砂: ') + parent.currentValue.toFixed(1)
                        }
                    }

                    HusSlider {
                        id: bevelDepthSlider
                        width: 200; height: 30
                        min: 0.0; max: 0.5; stepSize: 0.01; value: 0.1
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('斜面深度: ') + parent.currentValue.toFixed(2)
                        }
                    }

                    HusSlider {
                        id: bevelWidthSlider
                        width: 200; height: 30
                        min: 0.0; max: 0.5; stepSize: 0.01; value: 0.1
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('斜面宽度: ') + parent.currentValue.toFixed(2)
                        }
                    }

                    HusSlider {
                        id: specularSlider
                        width: 200; height: 30
                        min: 0.0; max: 2.0; stepSize: 0.1; value: 1.0
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('高光: ') + parent.currentValue.toFixed(1)
                        }
                    }

                    HusSlider {
                        id: radiusSlider
                        width: 200; height: 30
                        min: 0; max: 80; stepSize: 1; value: 30
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('圆角: ') + parent.currentValue.toFixed(0)
                        }
                    }

                    HusSlider {
                        id: tiltXSlider
                        width: 200; height: 30
                        min: -45; max: 45; stepSize: 1; value: 0
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('水平倾斜: ') + parent.currentValue.toFixed(0) + '°'
                        }
                    }

                    HusSlider {
                        id: tiltYSlider
                        width: 200; height: 30
                        min: -45; max: 45; stepSize: 1; value: 0
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('垂直倾斜: ') + parent.currentValue.toFixed(0) + '°'
                        }
                    }

                    HusSlider {
                        id: magnifySlider
                        width: 200; height: 30
                        min: 0.5; max: 3.0; stepSize: 0.05; value: 1.25
                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right; anchors.leftMargin: 10
                            text: qsTr('放大: ') + parent.currentValue.toFixed(2) + 'x'
                        }
                    }

                    Rectangle {
                        width: 400; height: 400
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: 'transparent'
                        border.color: HusTheme.Primary.colorTextBase

                        Image {
                            id: source
                            width: 400; height: 400
                            source: 'qrc:/Gallery/images/switch_effect1.jpg'
                            fillMode: Image.PreserveAspectCrop
                        }

                        HusLiquidGlass {
                            x: (source.width - width) * 0.5
                            y: (source.height - height) * 0.5
                            width: 200; height: width
                            sourceItem: source
                            refraction: refractionSlider.currentValue
                            frost: frostSlider.currentValue
                            bevelDepth: bevelDepthSlider.currentValue
                            bevelWidth: bevelWidthSlider.currentValue
                            radiusBg: HusRadius { all: radiusSlider.currentValue }
                            tiltX: tiltXSlider.currentValue
                            tiltY: tiltYSlider.currentValue
                            magnify: magnifySlider.currentValue

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
                    id: refractionSlider
                    width: 200; height: 30
                    min: 0.0; max: 0.1; stepSize: 0.01; value: 0.1
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('折射: ') + parent.currentValue.toFixed(3)
                    }
                }

                HusSlider {
                    id: frostSlider
                    width: 200; height: 30
                    min: 0.0; max: 10.0; stepSize: 0.1; value: 1.0
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('磨砂: ') + parent.currentValue.toFixed(1)
                    }
                }

                HusSlider {
                    id: bevelDepthSlider
                    width: 200; height: 30
                    min: 0.0; max: 0.5; stepSize: 0.01; value: 0.1
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('斜面深度: ') + parent.currentValue.toFixed(2)
                    }
                }

                HusSlider {
                    id: bevelWidthSlider
                    width: 200; height: 30
                    min: 0.0; max: 0.5; stepSize: 0.01; value: 0.1
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('斜面宽度: ') + parent.currentValue.toFixed(2)
                    }
                }

                HusSlider {
                    id: specularSlider
                    width: 200; height: 30
                    min: 0.0; max: 2.0; stepSize: 0.1; value: 1.0
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('高光: ') + parent.currentValue.toFixed(1)
                    }
                }

                HusSlider {
                    id: radiusSlider
                    width: 200; height: 30
                    min: 0; max: 80; stepSize: 1; value: 30
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('圆角: ') + parent.currentValue.toFixed(0)
                    }
                }

                HusSlider {
                    id: tiltXSlider
                    width: 200; height: 30
                    min: -45; max: 45; stepSize: 1; value: 0
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('水平倾斜: ') + parent.currentValue.toFixed(0) + '°'
                    }
                }

                HusSlider {
                    id: tiltYSlider
                    width: 200; height: 30
                    min: -45; max: 45; stepSize: 1; value: 0
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('垂直倾斜: ') + parent.currentValue.toFixed(0) + '°'
                    }
                }

                HusSlider {
                    id: magnifySlider
                    width: 200; height: 30
                    min: 0.5; max: 3.0; stepSize: 0.05; value: 1.25
                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right; anchors.leftMargin: 10
                        text: qsTr('放大: ') + parent.currentValue.toFixed(2) + 'x'
                    }
                }

                Rectangle {
                    width: 400; height: 400
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'transparent'
                    border.color: HusTheme.Primary.colorTextBase

                    Image {
                        id: source
                        width: 400; height: 400
                        source: 'qrc:/Gallery/images/switch_effect1.jpg'
                        fillMode: Image.PreserveAspectCrop
                    }

                    HusLiquidGlass {
                        x: (source.width - width) * 0.5
                        y: (source.height - height) * 0.5
                        width: 200; height: width
                        sourceItem: source
                        refraction: refractionSlider.currentValue
                        frost: frostSlider.currentValue
                        bevelDepth: bevelDepthSlider.currentValue
                        bevelWidth: bevelWidthSlider.currentValue
                        specularIntensity: specularSlider.currentValue
                        radiusBg: HusRadius { all: radiusSlider.currentValue }
                        tiltX: tiltXSlider.currentValue
                        tiltY: tiltYSlider.currentValue
                        magnify: magnifySlider.currentValue

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

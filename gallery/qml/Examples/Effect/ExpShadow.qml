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
# HusShadow 阴影 \n
阴影效果。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { MultiEffect }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当用户需要统一的阴影效果时。
                       `)
        }

        ThemeToken {
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusShadow.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`source\` 属性设置需要阴影的项目。\n
通过 \`shadowOpacity\` 属性设置阴影透明度。\n
通过 \`shadowScale\` 属性设置阴影缩放。\n
通过 \`shadowVerticalOffset\` 属性设置阴影垂直偏移。\n
通过 \`shadowHorizontalOffset\` 属性设置阴影水平偏移。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusSlider {
                        id: shadowOpacitySlider
                        width: 150
                        height: 30
                        value: 1.0
                        min: 0.0
                        max: 1.0
                        stepSize: 0.1

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('阴影透明度: ') + parent.currentValue.toFixed(1);
                        }
                    }

                    HusSlider {
                        id: shadowScaleSlider
                        width: 150
                        height: 30
                        value: 1.0
                        min: 1.0
                        max: 1.5
                        stepSize: 0.01

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('阴影缩放: ') + parent.currentValue.toFixed(1);
                        }
                    }

                    HusSlider {
                        id: shadowVerticalOffsetSlider
                        width: 150
                        height: 30
                        value: 0
                        min: -100
                        max: 100
                        stepSize: 1

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('阴影垂直偏移: ') + parent.currentValue.toFixed(1);
                        }
                    }

                    HusSlider {
                        id: shadowHorizontalOffsetSlider
                        width: 150
                        height: 30
                        value: 0
                        min: -100
                        max: 100
                        stepSize: 1

                        HusCopyableText {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            anchors.leftMargin: 10
                            text: qsTr('阴影水平偏移: ') + parent.currentValue.toFixed(1);
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

                    Item {
                        width: parent.width
                        height: 200

                        HusShadow {
                            anchors.fill: back
                            source: back
                            shadowOpacity: shadowOpacitySlider.currentValue
                            shadowScale: shadowScaleSlider.currentValue
                            shadowVerticalOffset: shadowVerticalOffsetSlider.currentValue
                            shadowHorizontalOffset: shadowHorizontalOffsetSlider.currentValue
                            paddingRect: Qt.rect(width * shadowScale, height * shadowScale, width * shadowScale, height * shadowScale)
                        }

                        HusRectangle {
                            id: back
                            width: 200
                            height: 200
                            anchors.centerIn: parent
                            color: '#EF8A8A'
                            topLeftRadius: topLeftSlider.currentValue
                            topRightRadius: topRightSlider.currentValue
                            bottomLeftRadius: bottomLeftSlider.currentValue
                            bottomRightRadius: bottomRightSlider.currentValue
                            visible: false
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSlider {
                    id: shadowOpacitySlider
                    width: 150
                    height: 30
                    value: 0.5
                    min: 0.0
                    max: 1.0
                    stepSize: 0.1

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('阴影透明度: ') + parent.currentValue.toFixed(1);
                    }
                }

                HusSlider {
                    id: shadowScaleSlider
                    width: 150
                    height: 30
                    value: 1.0
                    min: 1.0
                    max: 1.5
                    stepSize: 0.01

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('阴影缩放: ') + parent.currentValue.toFixed(1);
                    }
                }

                HusSlider {
                    id: shadowVerticalOffsetSlider
                    width: 150
                    height: 30
                    value: 0
                    min: -100
                    max: 100
                    stepSize: 1

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('阴影垂直偏移: ') + parent.currentValue.toFixed(1);
                    }
                }

                HusSlider {
                    id: shadowHorizontalOffsetSlider
                    width: 150
                    height: 30
                    value: 0
                    min: -100
                    max: 100
                    stepSize: 1

                    HusCopyableText {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.right
                        anchors.leftMargin: 10
                        text: qsTr('阴影水平偏移: ') + parent.currentValue.toFixed(1);
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

                Item {
                    width: parent.width
                    height: 200

                    HusShadow {
                        anchors.fill: back
                        source: back
                        shadowOpacity: shadowOpacitySlider.currentValue
                        shadowScale: shadowScaleSlider.currentValue
                        shadowVerticalOffset: shadowVerticalOffsetSlider.currentValue
                        shadowHorizontalOffset: shadowHorizontalOffsetSlider.currentValue
                        paddingRect: Qt.rect(width * shadowScale, height * shadowScale, width * shadowScale, height * shadowScale)
                    }

                    HusRectangle {
                        id: back
                        width: 200
                        height: 200
                        anchors.centerIn: parent
                        color: '#EF8A8A'
                        topLeftRadius: topLeftSlider.currentValue
                        topRightRadius: topRightSlider.currentValue
                        bottomLeftRadius: bottomLeftSlider.currentValue
                        bottomRightRadius: bottomRightSlider.currentValue
                        visible: false
                    }
                }
            }
        }
    }
}

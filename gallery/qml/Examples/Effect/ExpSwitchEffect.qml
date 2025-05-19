import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelSwitchEffect 切换效果 \n
两个组件之间的切换/过渡效果。\n
* **继承自 { Item }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 默认值 | 描述 |
------ | --- | :---: | ---
fromItem | Item | - | 从项目
toItem | rect | - | 到项目
startCallback | function | - | 开始回调(started信号之前调用)
endCallback | function | - | 结束回调(finished信号之前调用)
type | enum | - | 特效类型(来自 DelSwitchEffect)
duration | int | 800 | 特效持续时间(毫秒)
easing | QEasingCurve | - | 缓动曲线
maskSource | string | '' | 遮罩源
maskScaleEnabled | bool | false | 是否启用遮罩缩放
maskScale | real | 1.0 | 遮罩缩放
maskRotationEnabled | bool | false | 是否启用遮罩旋转
maskRotation | real | 0 | 遮罩旋转角度
maskColorizationEnabled | bool | false | 是否启用遮罩源着色
maskColorizationColor | color | 'red' | 着色颜色
maskColorization | real | 0 | 着色强度(0.0~1.0)
\n支持的函数：\n
 - \`startSwitch(from = null, to = null)\` 特效开始从 \`from\` 项切换到 \`to\`。\n
\n支持的信号：\n
 - \`started()\` 动画开始时发出\n
 - \`finished()\` 动画结束时发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当需要给一个组件到另一个组件的切换时增加特效时。
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`type\` 属性设置特效类型，支持的类型：\n
- 无{ DelSwitchEffect.Type_None }\n
- 透明度特效{ DelSwitchEffect.Type_Opacity }\n
- 模糊特效{ DelSwitchEffect.Type_Blurry }\n
- 遮罩特效{ DelSwitchEffect.Type_Mask }\n
- 百叶窗特效{ DelSwitchEffect.Type_Blinds }\n
- 3D翻转特效{ DelSwitchEffect.Type_3DFlip }\n
- 雷电特效{ DelSwitchEffect.Type_Thunder }\n
通过 \`duration\` 属性设置特效持续时间(毫秒)。\n
通过 \`startSwitch\` 函数开始切换。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelButton {
                        id: startButton
                        leftPadding: 20
                        rightPadding: 20
                        text: qsTr('开始')
                        type: DelButton.Type_Primary
                        onClicked: {
                            direction = !direction;
                            if (direction) {
                                switchEffect.startSwitch(item1, item2)
                            } else {
                                switchEffect.startSwitch(item2, item1)
                            }
                        }
                        property bool direction: false
                    }

                    Row {
                        height: 30
                        spacing: 10

                        DelText {
                            text: qsTr('持续时间')
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        DelSlider {
                            id: durationSlider
                            width: 240
                            height: parent.height
                            min: 0
                            max: 3000
                            value: 1500
                        }

                        DelText {
                            text: durationSlider.currentValue.toFixed(0)
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    DelRadioBlock {
                        id: effectType
                        initCheckedIndex: 0
                        model: [
                            { 'label': qsTr('无'), 'value': DelSwitchEffect.Type_None, 'duration': 0 },
                            { 'label': qsTr('透明度特效'), 'value': DelSwitchEffect.Type_Opacity, 'duration': 800 },
                            { 'label': qsTr('模糊特效'), 'value': DelSwitchEffect.Type_Blurry, 'duration': 1200 },
                            {
                                'label': qsTr('遮罩特效'),
                                'value': DelSwitchEffect.Type_Mask,
                                'duration': 1500,
                                'maskScaleEnabled': true,
                                'maskRotationEnabled': true,
                                'maskSource': 'qrc:/DelegateUI/images/star.png',
                            },
                            {
                                'label': qsTr('百叶窗特效'),
                                'value': DelSwitchEffect.Type_Blinds,
                                'duration': 1500,
                            },
                            {
                                'label': qsTr('3D翻转特效'),
                                'value': DelSwitchEffect.Type_3DFlip,
                                'duration': 1500,
                            },
                            {
                                'label': qsTr('雷电特效'),
                                'value': DelSwitchEffect.Type_Thunder,
                                'duration': 1500,
                            },
                        ]
                        onClicked: function(index, radioData) {
                            switchEffect.type = radioData.value;
                            switchEffect.maskScaleEnabled = radioData.maskScaleEnabled ?? false;
                            switchEffect.maskRotationEnabled = radioData.maskRotationEnabled ?? false;
                            switchEffect.maskSource = radioData.maskSource || '';
                            durationSlider.value = radioData.duration;
                        }
                    }

                    Item {
                        width: parent.width
                        height: 500

                        Image {
                            id: item1
                            width: parent.width
                            height: parent.height
                            source: 'qrc:/Gallery/images/swithc_effect1.jpg'
                            visible: true
                        }

                        Image {
                            id: item2
                            width: parent.width
                            height: parent.height
                            source: 'qrc:/Gallery/images/swithc_effect2.jpg'
                            visible: false
                        }

                        DelSwitchEffect {
                            id: switchEffect
                            anchors.fill: parent
                            duration: durationSlider.currentValue
                            maskScale: animationTime * 3
                            maskRotation: (1.0 - animationTime) * 360
                            onFinished: {
                                item1.visible = !startButton.direction;
                                item2.visible = startButton.direction;
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelButton {
                    id: startButton
                    leftPadding: 20
                    rightPadding: 20
                    text: qsTr('开始')
                    type: DelButton.Type_Primary
                    onClicked: {
                        direction = !direction;
                        if (direction) {
                            switchEffect.startSwitch(item1, item2)
                        } else {
                            switchEffect.startSwitch(item2, item1)
                        }
                    }
                    property bool direction: false
                }

                Row {
                    height: 30
                    spacing: 10

                    DelText {
                        text: qsTr('持续时间')
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    DelSlider {
                        id: durationSlider
                        width: 240
                        height: parent.height
                        min: 0
                        max: 3000
                        value: 1500
                    }

                    DelText {
                        text: durationSlider.currentValue.toFixed(0)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                DelRadioBlock {
                    id: effectType
                    initCheckedIndex: 0
                    model: [
                        { 'label': qsTr('无'), 'value': DelSwitchEffect.Type_None, 'duration': 0 },
                        { 'label': qsTr('透明度特效'), 'value': DelSwitchEffect.Type_Opacity, 'duration': 800 },
                        { 'label': qsTr('模糊特效'), 'value': DelSwitchEffect.Type_Blurry, 'duration': 1200 },
                        {
                            'label': qsTr('遮罩特效'),
                            'value': DelSwitchEffect.Type_Mask,
                            'duration': 1500,
                            'maskScaleEnabled': true,
                            'maskRotationEnabled': true,
                            'maskSource': 'qrc:/DelegateUI/images/star.png',
                        },
                        {
                            'label': qsTr('百叶窗特效'),
                            'value': DelSwitchEffect.Type_Blinds,
                            'duration': 1500,
                            'maskRotationEnabled': true,
                        },
                        {
                            'label': qsTr('3D翻转特效'),
                            'value': DelSwitchEffect.Type_3DFlip,
                            'duration': 1500,
                        },
                        {
                            'label': qsTr('雷电特效'),
                            'value': DelSwitchEffect.Type_Thunder,
                            'duration': 1500,
                        },
                    ]
                    onClicked: function(index, radioData) {
                        switchEffect.type = radioData.value;
                        switchEffect.maskScaleEnabled = radioData.maskScaleEnabled ?? false;
                        switchEffect.maskRotationEnabled = radioData.maskRotationEnabled ?? false;
                        switchEffect.maskSource = radioData.maskSource || '';
                        durationSlider.value = radioData.duration;
                    }
                }

                Item {
                    width: parent.width
                    height: 500

                    Image {
                        id: item1
                        width: parent.width
                        height: parent.height
                        source: 'qrc:/Gallery/images/swithc_effect1.jpg'
                        visible: true
                    }

                    Image {
                        id: item2
                        width: parent.width
                        height: parent.height
                        source: 'qrc:/Gallery/images/swithc_effect2.jpg'
                        visible: false
                    }

                    DelSwitchEffect {
                        id: switchEffect
                        anchors.fill: parent
                        duration: durationSlider.currentValue
                        maskScale: animationTime * 3
                        maskRotation: type == DelSwitchEffect.Type_Blinds ? 45 : (1.0 - animationTime) * 360
                        onFinished: {
                            item1.visible = !startButton.direction;
                            item2.visible = startButton.direction;
                        }
                    }
                }
            }
        }
    }
}

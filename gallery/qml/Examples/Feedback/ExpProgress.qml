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
## DelProgress 进度条 \n
展示操作的当前进度。\n
* **继承自 { Item }**\n
支持的代理：\n
- **infoDelegate: Component** 进度信息的代理\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
type | enum | 进度条类型(来自 DelProgress)
status | enum | 进度条状态(来自 DelProgress)
percent | real | 进度百分比(0.0~100.0)
barThickness | real | 进度条宽度
strokeLineCap | string | 进度条线帽样式, 支持 'butt'丨'round'
steps | int | 进度条步骤总数(大于0显示为步骤形式)
currentStep | int | 当前步骤数
gap | real | 步骤间隔(步骤形式时有效)
gapDegree | real | 间隔角度(仪表盘进度条时有效)
useGradient | bool | 是否使用渐变色
gradientStops | object | 渐变色样式对象
showInfo | bool | 是否显示进度数值或状态图标
precision | int | 进度文本显示的小数点精度(默认0)
formatter | function | 信息文本格式化器
colorBar | color | 进度条颜色
colorTrack | color | 进度条轨道颜色
colorInfo | color | 进度条信息文本颜色
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
在操作需要较长时间才能完成时，为用户显示该操作的当前进度和状态。\n
- 当一个操作会打断当前界面，或者需要在后台运行，且耗时可能超过 2 秒时。\n
- 当需要显示一个操作完成的百分比时。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('条形进度条')
            desc: qsTr(`
默认的条形进度条。\n
通过 \`type\` 设置进度条类型，支持的类型：\n
- 条形进度条(默认){ DelProgress.Type_Line }\n
- 圆形进度条{ DelProgress.Type_Circle }\n
- 仪表盘进度条{ DelProgress.Type_Dashboard }
通过 \`status\` 设置进度条状态，支持的状态：\n
- 一般状态(默认){ DelProgress.Status_Normal }\n
- 成功状态{ DelProgress.Status_Success }\n
- 异常状态{ DelProgress.Status_Exception }\n
- 激活状态(仅条形进度条有效){ DelProgress.Status_Active }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelProgress { percent: 30 }
                    DelProgress { percent: 50; status: DelProgress.Status_Active }
                    DelProgress { percent: 70; status: DelProgress.Status_Exception }
                    DelProgress { percent: 100; status: DelProgress.Status_Success }
                    DelProgress { percent: 50; showInfo: false }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelProgress { percent: 30 }
                DelProgress { percent: 50; status: DelProgress.Status_Active }
                DelProgress { percent: 70; status: DelProgress.Status_Exception }
                DelProgress { percent: 100; status: DelProgress.Status_Success }
                DelProgress { percent: 50; showInfo: false }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('圆形进度条')
            desc: qsTr(`
圆形进度条。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    width: parent.width
                    spacing: 10

                    DelProgress { width: 120; height: width; type: DelProgress.Type_Circle; percent: 75 }
                    DelProgress { width: 120; height: width; type: DelProgress.Type_Circle; percent: 75; status: DelProgress.Status_Exception }
                    DelProgress { width: 120; height: width; type: DelProgress.Type_Circle; percent: 100; status: DelProgress.Status_Success }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelProgress { width: 120; height: width; type: DelProgress.Type_Circle; percent: 75 }
                DelProgress { width: 120; height: width; type: DelProgress.Type_Circle; percent: 75; status: DelProgress.Status_Exception }
                DelProgress { width: 120; height: width; type: DelProgress.Type_Circle; percent: 100; status: DelProgress.Status_Success }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('仪表盘进度条')
            desc: qsTr(`
通过设置 \`type\` 为 \`DelProgress.Type_Dashboard\`，可以很方便地实现仪表盘样式的进度条。\n
若想要修改缺口的角度，可以设置 \`gapDegree\` 为你想要的值。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    width: parent.width
                    spacing: 10

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Dashboard
                        percent: 75
                    }

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Dashboard
                        percent: 75
                        gapDegree: 30
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelProgress {
                    width: 120
                    height: width
                    type: DelProgress.Type_Dashboard
                    percent: 75
                }

                DelProgress {
                    width: 120
                    height: width
                    type: DelProgress.Type_Dashboard
                    percent: 75
                    gapDegree: 30
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('动态展示')
            desc: qsTr(`
会动的进度条才是好进度条。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10
                    property real newPercent: 0

                    DelProgress {
                        width: parent.width
                        type: DelProgress.Type_Line
                        percent: newPercent
                        status: percent >= 100 ? DelProgress.Status_Success : DelProgress.Status_Normal
                    }

                    Row {
                        DelProgress {
                            width: 120
                            height: width
                            type: DelProgress.Type_Circle
                            percent: newPercent
                            gapDegree: 30
                            status: percent >= 100 ? DelProgress.Status_Success : DelProgress.Status_Normal
                        }

                        DelProgress {
                            width: 120
                            height: width
                            type: DelProgress.Type_Dashboard
                            percent: newPercent
                            status: percent >= 100 ? DelProgress.Status_Success : DelProgress.Status_Normal
                        }
                    }

                    Row {
                        DelIconButton {
                            padding: 10
                            radiusBg: 0
                            iconSource: DelIcon.MinusOutlined
                            onClicked: {
                                if (newPercent - 10 >= 0)
                                    newPercent -= 10;
                            }
                        }
                        DelIconButton {
                            padding: 10
                            radiusBg: 0
                            iconSource: DelIcon.PlusOutlined
                            onClicked: {
                                if (newPercent + 10 <= 100)
                                    newPercent += 10;
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10
                property real newPercent: 0

                DelProgress {
                    width: parent.width
                    type: DelProgress.Type_Line
                    percent: newPercent
                    status: percent >= 100 ? DelProgress.Status_Success : DelProgress.Status_Normal
                }

                Row {
                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Circle
                        percent: newPercent
                        gapDegree: 30
                        status: percent >= 100 ? DelProgress.Status_Success : DelProgress.Status_Normal
                    }

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Dashboard
                        percent: newPercent
                        status: percent >= 100 ? DelProgress.Status_Success : DelProgress.Status_Normal
                    }
                }

                Row {
                    DelIconButton {
                        padding: 10
                        radiusBg: 0
                        iconSource: DelIcon.MinusOutlined
                        onClicked: {
                            if (newPercent - 10 >= 0)
                                newPercent -= 10;
                        }
                    }
                    DelIconButton {
                        padding: 10
                        radiusBg: 0
                        iconSource: DelIcon.PlusOutlined
                        onClicked: {
                            if (newPercent + 10 <= 100)
                                newPercent += 10;
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义信息文字格式')
            desc: qsTr(`
通过 \`formatter\` 属性指定格式，格式化器是形如：\`function(): string { }\` 的函数。\n。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    width: parent.width
                    spacing: 10

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Circle
                        percent: 75
                        formatter: () => \`\${percent} Days\`
                    }

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Circle
                        percent: 100
                        status: DelProgress.Status_Success
                        formatter: () => 'Done'
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelProgress {
                    width: 120
                    height: width
                    type: DelProgress.Type_Circle
                    percent: 75
                    formatter: () => `${percent} Days`
                }

                DelProgress {
                    width: 120
                    height: width
                    type: DelProgress.Type_Circle
                    percent: 100
                    status: DelProgress.Status_Success
                    formatter: () => 'Done'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义进度条渐变色')
            desc: qsTr(`
通过 \`useGradient\` 属性启用渐变，此时 \`colorBar\` 将不会生效。\n
通过 \`gradientStops\` 属性设置渐变色，它是形如 \`{ '0%': '#108ee9', '100%': '#87d068' }\` 的对象。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    property var twoColors: {
                        '0%': '#108ee9',
                        '100%': '#87d068',
                    }
                    property var conicColors: {
                        '0%': '#87d068',
                        '50%': '#ffe58f',
                        '100%': '#ffccc7',
                    };

                    Column {
                        spacing: 10

                        DelProgress {
                            width: 600
                            percent: 99.9
                            useGradient: true
                            gradientStops: twoColors
                        }

                        DelProgress {
                            width: 600
                            percent: 50
                            useGradient: true
                            gradientStops: twoColors
                        }
                    }

                    Row {
                        spacing: 10

                        DelProgress {
                            width: 120
                            height: width
                            type: DelProgress.Type_Circle
                            percent: 75
                            useGradient: true
                            gradientStops: twoColors
                        }

                        DelProgress {
                            width: 120
                            height: width
                            type: DelProgress.Type_Circle
                            status: DelProgress.Status_Success
                            percent: 100
                            useGradient: true
                            gradientStops: twoColors
                        }

                        DelProgress {
                            width: 120
                            height: width
                            type: DelProgress.Type_Circle
                            percent: 93
                            useGradient: true
                            gradientStops: conicColors
                        }
                    }

                    Row {
                        spacing: 10

                        DelProgress {
                            width: 120
                            height: width
                            type: DelProgress.Type_Dashboard
                            percent: 75
                            useGradient: true
                            gradientStops: twoColors
                        }

                        DelProgress {
                            width: 120
                            height: width
                            type: DelProgress.Type_Dashboard
                            status: DelProgress.Status_Success
                            percent: 100
                            useGradient: true
                            gradientStops: twoColors
                        }

                        DelProgress {
                            width: 120
                            height: width
                            type: DelProgress.Type_Dashboard
                            percent: 93
                            useGradient: true
                            gradientStops: conicColors
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                property var twoColors: {
                    '0%': '#108ee9',
                    '100%': '#87d068',
                }
                property var conicColors: {
                    '0%': '#87d068',
                    '50%': '#ffe58f',
                    '100%': '#ffccc7',
                };

                Column {
                    spacing: 10

                    DelProgress {
                        width: 600
                        percent: 99.9
                        useGradient: true
                        gradientStops: twoColors
                    }

                    DelProgress {
                        width: 600
                        percent: 50
                        useGradient: true
                        gradientStops: twoColors
                    }
                }

                Row {
                    spacing: 10

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Circle
                        percent: 75
                        useGradient: true
                        gradientStops: twoColors
                    }

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Circle
                        status: DelProgress.Status_Success
                        percent: 100
                        useGradient: true
                        gradientStops: twoColors
                    }

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Circle
                        percent: 93
                        useGradient: true
                        gradientStops: conicColors
                    }
                }

                Row {
                    spacing: 10

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Dashboard
                        percent: 75
                        useGradient: true
                        gradientStops: twoColors
                    }

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Dashboard
                        status: DelProgress.Status_Success
                        percent: 100
                        useGradient: true
                        gradientStops: twoColors
                    }

                    DelProgress {
                        width: 120
                        height: width
                        type: DelProgress.Type_Dashboard
                        percent: 93
                        useGradient: true
                        gradientStops: conicColors
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('步骤进度条')
            desc: qsTr(`
通过将 \`steps\` 设置步骤总数为大于 0 的值来创建步骤形式的进度条。\n
通过将 \`currentStep\` 设置当前的步骤值。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    Column {
                        DelCopyableText {
                            text: \`Custom step count: \${stepCoutSlider.currentValue}\`
                        }

                        DelSlider {
                            id: stepCoutSlider
                            width: 200
                            height: 30
                            min: 1
                            max: 100
                            value: 8
                            stepSize: 1
                        }

                        DelCopyableText {
                            text: \`Custom gap: \${gapCountSlider.currentValue}\`
                        }

                        DelSlider {
                            id: gapCountSlider
                            width: 200
                            height: 30
                            min: 0
                            max: 40
                            value: 4
                            stepSize: 4
                            snapMode: DelSlider.SnapAlways
                        }

                        DelCopyableText {
                            text: \`Custom bar thickness: \${barThicknessSlider.currentValue}\`
                        }

                        DelSlider {
                            id: barThicknessSlider
                            width: 200
                            height: 30
                            min: 4
                            max: 40
                            value: 8
                            stepSize: 1
                        }
                    }

                    Column {
                        spacing: 10

                        DelProgress {
                            width: 600
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }

                        DelProgress {
                            width: 600
                            status: DelProgress.Status_Exception
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }
                    }

                    Row {
                        spacing: 10

                        DelProgress {
                            width: 200
                            height: width
                            type: DelProgress.Type_Circle
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }

                        DelProgress {
                            width: 200
                            height: width
                            type: DelProgress.Type_Circle
                            status: DelProgress.Status_Exception
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }
                    }

                    Row {
                        spacing: 10

                        DelProgress {
                            width: 200
                            height: width
                            type: DelProgress.Type_Dashboard
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }

                        DelProgress {
                            width: 200
                            height: width
                            type: DelProgress.Type_Dashboard
                            status: DelProgress.Status_Exception
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Column {
                    DelCopyableText {
                        text: `Custom step count: ${stepCoutSlider.currentValue}`
                    }

                    DelSlider {
                        id: stepCoutSlider
                        width: 200
                        height: 30
                        min: 1
                        max: 100
                        value: 8
                        stepSize: 1
                    }

                    DelCopyableText {
                        text: `Custom gap: ${gapCountSlider.currentValue}`
                    }

                    DelSlider {
                        id: gapCountSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 40
                        value: 4
                        stepSize: 4
                        snapMode: DelSlider.SnapAlways
                    }

                    DelCopyableText {
                        text: `Custom bar thickness: ${barThicknessSlider.currentValue}`
                    }

                    DelSlider {
                        id: barThicknessSlider
                        width: 200
                        height: 30
                        min: 4
                        max: 40
                        value: 8
                        stepSize: 1
                    }
                }

                Column {
                    spacing: 10

                    DelProgress {
                        width: 600
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    DelProgress {
                        width: 600
                        status: DelProgress.Status_Exception
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }
                }

                Row {
                    spacing: 10

                    DelProgress {
                        width: 200
                        height: width
                        type: DelProgress.Type_Circle
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    DelProgress {
                        width: 200
                        height: width
                        type: DelProgress.Type_Circle
                        status: DelProgress.Status_Exception
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }
                }

                Row {
                    spacing: 10

                    DelProgress {
                        width: 200
                        height: width
                        type: DelProgress.Type_Dashboard
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    DelProgress {
                        width: 200
                        height: width
                        type: DelProgress.Type_Dashboard
                        status: DelProgress.Status_Exception
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }
                }
            }
        }
    }
}

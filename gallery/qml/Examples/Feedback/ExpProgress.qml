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
# HusProgress 进度条 \n
展示操作的当前进度。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **infoDelegate: Component** 进度信息的代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
type | enum | HusProgress.Type_Line | 进度条类型(来自 HusProgress)
status | enum | HusProgress.Status_Normal | 进度条状态(来自 HusProgress)
percent | real | 0 | 进度百分比(0.0~100.0)
barThickness | real | 8 | 进度条宽度
strokeLineCap | string | 'round' | 进度条线帽样式, 支持 'butt'丨'round'
steps | int | 0 | 进度条步骤总数(大于0显示为步骤形式)
currentStep | int | 0 | 当前步骤数
gap | real | 4 | 步骤间隔(步骤形式时有效)
gapDegree | real | 60 | 间隔角度(仪表盘进度条时有效)
useGradient | bool | false | 是否使用渐变色
gradientStops | object | - | 渐变色样式对象
showInfo | bool | true | 是否显示进度数值或状态图标
precision | int | 0 | 进度文本显示的小数点精度
formatter | function | - | 信息文本格式化器
colorBar | color | - | 进度条颜色
colorTrack | color | - | 进度条轨道颜色
colorInfo | color | - | 进度条信息文本颜色
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在操作需要较长时间才能完成时，为用户显示该操作的当前进度和状态。\n
- 当一个操作会打断当前界面，或者需要在后台运行，且耗时可能超过 2 秒时。\n
- 当需要显示一个操作完成的百分比时。\n
                       `)
        }

        ThemeToken {
            source: 'HusProgress'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('条形进度条')
            desc: qsTr(`
默认的条形进度条。\n
通过 \`type\` 设置进度条类型，支持的类型：\n
- 条形进度条(默认){ HusProgress.Type_Line }\n
- 圆形进度条{ HusProgress.Type_Circle }\n
- 仪表盘进度条{ HusProgress.Type_Dashboard }
通过 \`status\` 设置进度条状态，支持的状态：\n
- 一般状态(默认){ HusProgress.Status_Normal }\n
- 成功状态{ HusProgress.Status_Success }\n
- 异常状态{ HusProgress.Status_Exception }\n
- 激活状态(仅条形进度条有效){ HusProgress.Status_Active }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusProgress { width: parent.width; percent: 30 }
                    HusProgress { width: parent.width; percent: 50; status: HusProgress.Status_Active }
                    HusProgress { width: parent.width; percent: 70; status: HusProgress.Status_Exception }
                    HusProgress { width: parent.width; percent: 100; status: HusProgress.Status_Success }
                    HusProgress { width: parent.width; percent: 50; showInfo: false }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusProgress { width: parent.width; percent: 30 }
                HusProgress { width: parent.width; percent: 50; status: HusProgress.Status_Active }
                HusProgress { width: parent.width; percent: 70; status: HusProgress.Status_Exception }
                HusProgress { width: parent.width; percent: 100; status: HusProgress.Status_Success }
                HusProgress { width: parent.width; percent: 50; showInfo: false }
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
                import HuskarUI.Basic

                Row {
                    width: parent.width
                    spacing: 10

                    HusProgress { width: 120; height: width; type: HusProgress.Type_Circle; percent: 75 }
                    HusProgress { width: 120; height: width; type: HusProgress.Type_Circle; percent: 75; status: HusProgress.Status_Exception }
                    HusProgress { width: 120; height: width; type: HusProgress.Type_Circle; percent: 100; status: HusProgress.Status_Success }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusProgress { width: 120; height: width; type: HusProgress.Type_Circle; percent: 75 }
                HusProgress { width: 120; height: width; type: HusProgress.Type_Circle; percent: 75; status: HusProgress.Status_Exception }
                HusProgress { width: 120; height: width; type: HusProgress.Type_Circle; percent: 100; status: HusProgress.Status_Success }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('仪表盘进度条')
            desc: qsTr(`
通过设置 \`type\` 为 \`HusProgress.Type_Dashboard\`，可以很方便地实现仪表盘样式的进度条。\n
若想要修改缺口的角度，可以设置 \`gapDegree\` 为你想要的值。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    width: parent.width
                    spacing: 10

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Dashboard
                        percent: 75
                    }

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Dashboard
                        percent: 75
                        gapDegree: 30
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusProgress {
                    width: 120
                    height: width
                    type: HusProgress.Type_Dashboard
                    percent: 75
                }

                HusProgress {
                    width: 120
                    height: width
                    type: HusProgress.Type_Dashboard
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
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10
                    property real newPercent: 0

                    HusProgress {
                        width: parent.width
                        type: HusProgress.Type_Line
                        percent: newPercent
                        status: percent >= 100 ? HusProgress.Status_Success : HusProgress.Status_Normal
                    }

                    Row {
                        HusProgress {
                            width: 120
                            height: width
                            type: HusProgress.Type_Circle
                            percent: newPercent
                            gapDegree: 30
                            status: percent >= 100 ? HusProgress.Status_Success : HusProgress.Status_Normal
                        }

                        HusProgress {
                            width: 120
                            height: width
                            type: HusProgress.Type_Dashboard
                            percent: newPercent
                            status: percent >= 100 ? HusProgress.Status_Success : HusProgress.Status_Normal
                        }
                    }

                    Row {
                        HusIconButton {
                            padding: 10
                            radiusBg.all: 0
                            radiusBg.topLeft: 5
                            radiusBg.bottomLeft: 5
                            iconSource: HusIcon.MinusOutlined
                            onClicked: {
                                if (newPercent - 10 >= 0)
                                    newPercent -= 10;
                            }
                        }
                        HusIconButton {
                            padding: 10
                            radiusBg.all: 0
                            radiusBg.topRight: 5
                            radiusBg.bottomRight: 5
                            iconSource: HusIcon.PlusOutlined
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

                HusProgress {
                    width: parent.width
                    type: HusProgress.Type_Line
                    percent: newPercent
                    status: percent >= 100 ? HusProgress.Status_Success : HusProgress.Status_Normal
                }

                Row {
                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Circle
                        percent: newPercent
                        gapDegree: 30
                        status: percent >= 100 ? HusProgress.Status_Success : HusProgress.Status_Normal
                    }

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Dashboard
                        percent: newPercent
                        status: percent >= 100 ? HusProgress.Status_Success : HusProgress.Status_Normal
                    }
                }

                Row {
                    HusIconButton {
                        padding: 10
                        radiusBg.all: 0
                        radiusBg.topLeft: 5
                        radiusBg.bottomLeft: 5
                        iconSource: HusIcon.MinusOutlined
                        onClicked: {
                            if (newPercent - 10 >= 0)
                                newPercent -= 10;
                        }
                    }
                    HusIconButton {
                        padding: 10
                        radiusBg.all: 0
                        radiusBg.topRight: 5
                        radiusBg.bottomRight: 5
                        iconSource: HusIcon.PlusOutlined
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
                import HuskarUI.Basic

                Row {
                    width: parent.width
                    spacing: 10

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Circle
                        percent: 75
                        formatter: () => \`\${percent} Days\`
                    }

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Circle
                        percent: 100
                        status: HusProgress.Status_Success
                        formatter: () => 'Done'
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusProgress {
                    width: 120
                    height: width
                    type: HusProgress.Type_Circle
                    percent: 75
                    formatter: () => `${percent} Days`
                }

                HusProgress {
                    width: 120
                    height: width
                    type: HusProgress.Type_Circle
                    percent: 100
                    status: HusProgress.Status_Success
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
                import HuskarUI.Basic

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

                        HusProgress {
                            width: 600
                            percent: 99.9
                            useGradient: true
                            gradientStops: twoColors
                        }

                        HusProgress {
                            width: 600
                            percent: 50
                            useGradient: true
                            gradientStops: twoColors
                        }
                    }

                    Row {
                        spacing: 10

                        HusProgress {
                            width: 120
                            height: width
                            type: HusProgress.Type_Circle
                            percent: 75
                            useGradient: true
                            gradientStops: twoColors
                        }

                        HusProgress {
                            width: 120
                            height: width
                            type: HusProgress.Type_Circle
                            status: HusProgress.Status_Success
                            percent: 100
                            useGradient: true
                            gradientStops: twoColors
                        }

                        HusProgress {
                            width: 120
                            height: width
                            type: HusProgress.Type_Circle
                            percent: 93
                            useGradient: true
                            gradientStops: conicColors
                        }
                    }

                    Row {
                        spacing: 10

                        HusProgress {
                            width: 120
                            height: width
                            type: HusProgress.Type_Dashboard
                            percent: 75
                            useGradient: true
                            gradientStops: twoColors
                        }

                        HusProgress {
                            width: 120
                            height: width
                            type: HusProgress.Type_Dashboard
                            status: HusProgress.Status_Success
                            percent: 100
                            useGradient: true
                            gradientStops: twoColors
                        }

                        HusProgress {
                            width: 120
                            height: width
                            type: HusProgress.Type_Dashboard
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

                    HusProgress {
                        width: 600
                        percent: 99.9
                        useGradient: true
                        gradientStops: twoColors
                    }

                    HusProgress {
                        width: 600
                        percent: 50
                        useGradient: true
                        gradientStops: twoColors
                    }
                }

                Row {
                    spacing: 10

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Circle
                        percent: 75
                        useGradient: true
                        gradientStops: twoColors
                    }

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Circle
                        status: HusProgress.Status_Success
                        percent: 100
                        useGradient: true
                        gradientStops: twoColors
                    }

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Circle
                        percent: 93
                        useGradient: true
                        gradientStops: conicColors
                    }
                }

                Row {
                    spacing: 10

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Dashboard
                        percent: 75
                        useGradient: true
                        gradientStops: twoColors
                    }

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Dashboard
                        status: HusProgress.Status_Success
                        percent: 100
                        useGradient: true
                        gradientStops: twoColors
                    }

                    HusProgress {
                        width: 120
                        height: width
                        type: HusProgress.Type_Dashboard
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
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    Column {
                        HusCopyableText {
                            text: \`Custom step count: \${stepCoutSlider.currentValue}\`
                        }

                        HusSlider {
                            id: stepCoutSlider
                            width: 200
                            height: 30
                            min: 1
                            max: 100
                            value: 8
                            stepSize: 1
                        }

                        HusCopyableText {
                            text: \`Custom gap: \${gapCountSlider.currentValue}\`
                        }

                        HusSlider {
                            id: gapCountSlider
                            width: 200
                            height: 30
                            min: 0
                            max: 40
                            value: 4
                            stepSize: 4
                            snapMode: HusSlider.SnapAlways
                        }

                        HusCopyableText {
                            text: \`Custom bar thickness: \${barThicknessSlider.currentValue}\`
                        }

                        HusSlider {
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

                        HusProgress {
                            width: 600
                            height: Math.min(40, Math.max(barThickness, 16))
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }

                        HusProgress {
                            width: 600
                            height: Math.min(40, Math.max(barThickness, 16))
                            status: HusProgress.Status_Exception
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }
                    }

                    Row {
                        spacing: 10

                        HusProgress {
                            width: 200
                            height: width
                            type: HusProgress.Type_Circle
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }

                        HusProgress {
                            width: 200
                            height: width
                            type: HusProgress.Type_Circle
                            status: HusProgress.Status_Exception
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }
                    }

                    Row {
                        spacing: 10

                        HusProgress {
                            width: 200
                            height: width
                            type: HusProgress.Type_Dashboard
                            barThickness: barThicknessSlider.currentValue
                            percent: 75
                            gap: gapCountSlider.currentValue
                            steps: Math.round(stepCoutSlider.currentValue)
                            currentStep: Math.floor(percent / 100 * steps)
                        }

                        HusProgress {
                            width: 200
                            height: width
                            type: HusProgress.Type_Dashboard
                            status: HusProgress.Status_Exception
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
                    HusCopyableText {
                        text: `Custom step count: ${stepCoutSlider.currentValue}`
                    }

                    HusSlider {
                        id: stepCoutSlider
                        width: 200
                        height: 30
                        min: 1
                        max: 100
                        value: 8
                        stepSize: 1
                    }

                    HusCopyableText {
                        text: `Custom gap: ${gapCountSlider.currentValue}`
                    }

                    HusSlider {
                        id: gapCountSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 40
                        value: 4
                        stepSize: 4
                        snapMode: HusSlider.SnapAlways
                    }

                    HusCopyableText {
                        text: `Custom bar thickness: ${barThicknessSlider.currentValue}`
                    }

                    HusSlider {
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

                    HusProgress {
                        width: 600
                        height: Math.min(40, Math.max(barThickness, 16))
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    HusProgress {
                        width: 600
                        height: Math.min(40, Math.max(barThickness, 16))
                        status: HusProgress.Status_Exception
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }
                }

                Row {
                    spacing: 10

                    HusProgress {
                        width: 200
                        height: width
                        type: HusProgress.Type_Circle
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    HusProgress {
                        width: 200
                        height: width
                        type: HusProgress.Type_Circle
                        status: HusProgress.Status_Exception
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }
                }

                Row {
                    spacing: 10

                    HusProgress {
                        width: 200
                        height: width
                        type: HusProgress.Type_Dashboard
                        barThickness: barThicknessSlider.currentValue
                        percent: 75
                        gap: gapCountSlider.currentValue
                        steps: Math.round(stepCoutSlider.currentValue)
                        currentStep: Math.floor(percent / 100 * steps)
                    }

                    HusProgress {
                        width: 200
                        height: width
                        type: HusProgress.Type_Dashboard
                        status: HusProgress.Status_Exception
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

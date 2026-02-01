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
# HusTourStep 漫游式引导\n
用于分步引导用户了解产品功能的气泡组件。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Popup }**\n
\n<br/>
\n### 支持的代理：\n
- **arrowDelegate: Component** 步骤箭头代理\n
- **closeButtonDelegate: Component** 右上角关闭按钮代理\n
- **stepCardDelegate: Component** 步骤卡片代理\n
- **indicatorDelegate: Component** 步骤指示器代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
penetrationEvent | bool | false | 是否可穿透事件
closable | bool | true | 是否显示右上角的关闭按钮
maskClosable | bool | false | 点击蒙层是否允许关闭
stepModel | array | [] | 步骤模型
currentTarget | Item | null | 当前步骤目标
currentStep | int | 0 | 当前步数
overlayColor | color | - | 覆盖层颜色
showArrow | bool | true |  是否显示箭头
arrowWidth | int | 16 | 箭头宽度
arrowHeight | int | 8 | 箭头高度
focusMargin | int | 5 | 焦点边距
focusRadius | int | 2 | 焦点圆角
stepCardWidth | int | 250 | 步骤卡片宽度
radiusStepCard | [HusRadius](internal://HusRadius) | - | 步骤默认卡片半径
colorStepCard | color | - | 步骤默认卡片颜色
stepTitleFont | font | - | 步骤默认标题字体
colorStepTitle | color | - | 步骤默认标题颜色
stepDescriptionFont | font | - | 步骤默认描述字体
colorStepDescription | color | - | 步骤默认描述颜色
indicatorFont | font | - | 步骤默认指示器字体
colorIndicator | color | - | 步骤默认指示器颜色
buttonFont | font | - | 步骤默认按钮字体
\n### 步骤对象支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
target | Item | 必选 | 本步骤指向目标
title | sting | 可选 | 本步骤标题
titleColor | color | 可选 | 本步骤标题颜色
description | sting | 可选 | 本步骤描述内容
descriptionColor | color | 可选 | 本步骤描述内容文本颜色
cardWidth | int | 可选 | 本步骤卡片宽度
cardHeight | int | 可选 | 本步骤卡片高度
cardColor | color | 可选 | 本步骤卡片颜色
cardRadius | int | 可选 | 本步骤卡片圆角
\n<br/>
\n### 支持的函数：\n
- \`gotoStep(step: int)\` 跳转步骤\n
- \`resetStep()\` 重置步骤\n
- \`appendStep(object: Object)\` 添加步骤\n
  - \`object\` 步骤对象\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
常用于引导用户分步了解产品功能。\n
                       `)
        }

        ThemeToken {
            source: 'HusTour'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusTourStep.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
通过 \`currentTarget\` 属性获取当前步骤目标\n
通过 \`currentStep\` 属性获取当前步数\n
通过 \`overlayColor\` 属性设置覆盖层颜色\n
通过 \`stepModel\` 属性设置步骤模型{需为list}，步骤项支持的属性有：\n
- { target: 本步骤指向目标 }\n
- { title: 本步骤标题 }\n
- { titleColor: 本步骤标题颜色 }\n
- { description: 本步骤描述内容 }\n
- { descriptionColor: 本步骤描述内容文本颜色 }\n
- { cardWidth: 本步骤卡片宽度 }\n
- { cardHeight: 本步骤卡片高度 }\n
- { cardColor: 本步骤卡片颜色 }\n
- { cardRadius: 本步骤卡片圆角 }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusButton {
                        text: qsTr('漫游步骤')
                        type: HusButton.Type_Primary
                        onClicked: {
                            tourStep.resetStep();
                            tourStep.open();
                        }

                        HusTourStep {
                            id: tourStep
                            closable: closableRadio.currentCheckedValue
                            stepModel: [
                                {
                                    target: tourStepButton1,
                                    title: qsTr('步骤1'),
                                    titleColor: '#3fcc9b',
                                    description: qsTr('这是步骤1\\n========'),
                                },
                                {
                                    target: tourStepButton2,
                                    title: qsTr('步骤2'),
                                    description: qsTr('这是步骤2\\n!!!!!!!!!!'),
                                    descriptionColor: '#3116ff'
                                },
                                {
                                    target: tourStep3Button,
                                    cardColor: '#ffa2eb',
                                    title: qsTr('步骤3'),
                                    titleColor: 'red',
                                    description: qsTr('这是步骤3\\n##############')
                                }
                            ]
                        }
                    }

                    Row {
                        spacing: 10

                        HusButton {
                            id: tourStepButton1
                            text: qsTr('漫游步骤1')
                            type: HusButton.Type_Outlined
                        }

                        HusButton {
                            id: tourStepButton2
                            text: qsTr('漫游步骤2')
                            type: HusButton.Type_Outlined
                        }

                        HusButton {
                            id: tourStepButton3
                            text: qsTr('漫游步骤3   ####')
                            type: HusButton.Type_Outlined
                        }
                    }

                    HusRadioBlock {
                        id: closableRadio
                        initCheckedIndex: 0
                        model: [
                            { label: 'Closable', value: true},
                            { label: 'Non-closable', value: false }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButton {
                    text: qsTr('漫游步骤')
                    type: HusButton.Type_Primary
                    onClicked: {
                        tourStep.resetStep();
                        tourStep.open();
                    }

                    HusTourStep {
                        id: tourStep
                        closable: closableRadio.currentCheckedValue
                        stepModel: [
                            {
                                target: tourStepButton1,
                                title: qsTr('步骤1'),
                                titleColor: '#3fcc9b',
                                description: qsTr('这是步骤1\n========'),
                            },
                            {
                                target: tourStepButton2,
                                title: qsTr('步骤2'),
                                description: qsTr('这是步骤2\n!!!!!!!!!!'),
                                descriptionColor: '#3116ff'
                            },
                            {
                                target: tourStepButton3,
                                cardColor: '#ffa2eb',
                                title: qsTr('步骤3'),
                                titleColor: 'red',
                                description: qsTr('这是步骤3\n##############')
                            }
                        ]
                    }
                }

                Row {
                    spacing: 10

                    HusButton {
                        id: tourStepButton1
                        text: qsTr('漫游步骤1')
                        type: HusButton.Type_Outlined
                    }

                    HusButton {
                        id: tourStepButton2
                        text: qsTr('漫游步骤2')
                        type: HusButton.Type_Outlined
                    }

                    HusButton {
                        id: tourStepButton3
                        text: qsTr('漫游步骤3   ####')
                        type: HusButton.Type_Outlined
                    }
                }

                HusRadioBlock {
                    id: closableRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Closable', value: true},
                        { label: 'Non-closable', value: false }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义高亮区域的样式')
            desc: qsTr(`
通过 \`penetrationEvent\` 属性设置是否可穿透事件。\n
通过 \`focusMargin\` 属性设置高亮区域边距。\n
通过 \`focusRadius\` 属性设置高亮区域圆角。\n
通过 \`stepCardDelegate\` 属性自定义卡片。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusButton {
                        text: qsTr('开始漫游')
                        type: HusButton.Type_Primary
                        onClicked: {
                            tourStep2.open();
                        }

                        HusTourStep {
                            id: tourStep2
                            penetrationEvent: true
                            focusMargin: marginSlider.currentValue
                            focusRadius: radiusSlider.currentValue
                            stepModel: [{ target: tourStepGrid }]
                            stepCardDelegate: Rectangle {
                                id: __stepCardDelegate
                                width: 520
                                height: column2.height + 20
                                color: tourStep2.colorStepCard
                                radius: tourStep2.radiusStepCard

                                property var stepData: tourStep2.stepModel[tourStep2.currentStep]

                                Column {
                                    id: column2
                                    width: parent.width - 20
                                    anchors.centerIn: parent
                                    spacing: 10

                                    HusCaptionButton {
                                        anchors.right: parent.right
                                        iconSource: HusIcon.CloseOutlined
                                        onClicked: {
                                            tourStep2.close();
                                        }
                                    }

                                    Image {
                                        width: parent.width
                                        height: 120
                                        source: 'https://user-images.githubusercontent.com/5378891/197385811-55df8480-7ff4-44bd-9d43-a7dade598d70.png'
                                    }

                                    HusText {
                                        text: 'Upload File'
                                        font.bold: true
                                    }

                                    HusText {
                                        text: 'Put your files here.'
                                    }

                                    HusButton {
                                        anchors.right: parent.right
                                        text: qsTr('结束导览')
                                        type: HusButton.Type_Primary
                                        onClicked: {
                                            tourStep2.close();
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Grid {
                        id: tourStepGrid
                        spacing: 10
                        columns: 2
                        verticalItemAlignment: Grid.AlignVCenter

                        HusText {
                            text: 'Margin: '
                        }

                        HusSlider {
                            id: marginSlider
                            width: 200
                            height: 30
                            min: 0
                            max: 30
                            value: 5
                            handleToolTipDelegate: HusToolTip {
                                visible: handleHovered || handlePressed
                                text: marginSlider.currentValue.toFixed(0)
                            }
                        }

                        HusText {
                            text: 'Radius: '
                        }

                        HusSlider {
                            id: radiusSlider
                            width: 200
                            height: 30
                            min: 0
                            max: 30
                            handleToolTipDelegate: HusToolTip {
                                visible: handleHovered || handlePressed
                                text: radiusSlider.currentValue.toFixed(0)
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButton {
                    text: qsTr('开始漫游')
                    type: HusButton.Type_Primary
                    onClicked: {
                        tourStep2.open();
                    }

                    HusTourStep {
                        id: tourStep2
                        penetrationEvent: true
                        focusMargin: marginSlider.currentValue
                        focusRadius: radiusSlider.currentValue
                        stepModel: [{ target: tourStepGrid }]
                        stepCardDelegate: Rectangle {
                            id: __stepCardDelegate
                            width: 520
                            height: column2.height + 20
                            color: tourStep2.colorStepCard
                            radius: tourStep2.radiusStepCard

                            property var stepData: tourStep2.stepModel[tourStep2.currentStep]

                            Column {
                                id: column2
                                width: parent.width - 20
                                anchors.centerIn: parent
                                spacing: 10

                                HusCaptionButton {
                                    anchors.right: parent.right
                                    iconSource: HusIcon.CloseOutlined
                                    onClicked: {
                                        tourStep2.close();
                                    }
                                }

                                Image {
                                    width: parent.width
                                    height: 120
                                    source: 'https://user-images.githubusercontent.com/5378891/197385811-55df8480-7ff4-44bd-9d43-a7dade598d70.png'
                                }

                                HusText {
                                    text: 'Upload File'
                                    font.bold: true
                                }

                                HusText {
                                    text: 'Put your files here.'
                                }

                                HusButton {
                                    anchors.right: parent.right
                                    text: qsTr('结束导览')
                                    type: HusButton.Type_Primary
                                    onClicked: {
                                        tourStep2.close();
                                    }
                                }
                            }
                        }
                    }
                }

                Grid {
                    id: tourStepGrid
                    spacing: 10
                    columns: 2
                    verticalItemAlignment: Grid.AlignVCenter

                    HusText {
                        text: 'Margin: '
                    }

                    HusSlider {
                        id: marginSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 30
                        value: 5
                        handleToolTipDelegate: HusToolTip {
                            visible: handleHovered || handlePressed
                            text: marginSlider.currentValue.toFixed(0)
                        }
                    }

                    HusText {
                        text: 'Radius: '
                    }

                    HusSlider {
                        id: radiusSlider
                        width: 200
                        height: 30
                        min: 0
                        max: 30
                        handleToolTipDelegate: HusToolTip {
                            visible: handleHovered || handlePressed
                            text: radiusSlider.currentValue.toFixed(0)
                        }
                    }
                }
            }
        }
    }
}

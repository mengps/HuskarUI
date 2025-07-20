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
# HusTourStep 漫游式引导\n
用于分步引导用户了解产品功能的气泡组件。\n
* **继承自 { Popup }**\n
\n<br/>
\n### 支持的代理：\n
- **arrowDelegate: Component** 步骤箭头代理\n
- **stepCardDelegate: Component** 步骤卡片代理\n
- **indicatorDelegate: Component** 步骤指示器代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
stepModel | list | [] | 步骤模型
currentTarget | Item | null | 当前步骤目标
currentStep | int | 0 | 当前步数
overlayColor | color | - | 覆盖层颜色
showArrow | bool | true |  是否显示箭头
arrowWidth | real | 20 | 箭头宽度
arrowHeight | real | 10 | 箭头高度
focusMargin | real | 5 | 焦点边缘
focusWidth | real | 10 | 焦点高度
focusHeight | int | 10 | 焦点高度
stepCardWidth | real | 255 | 步骤卡片宽度
radiusStepCard | int | - | 步骤默认卡片半径
colorStepCard | color | - | 步骤默认卡片颜色
stepTitleFont | font | - | 步骤默认标题字体
colorStepTitle | color | - | 步骤默认标题颜色
stepDescriptionFont | font | - | 步骤默认描述字体
colorStepDescription | color | - | 步骤默认描述颜色
indicatorFont | font | - | 步骤默认指示器字体
colorIndicator | color | - | 步骤默认指示器颜色
buttonFont | font | - | 步骤默认按钮字体
\n<br/>
\n### 支持的函数：\n
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
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
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
- { cardRadius: 本步骤卡片半径 }\n
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
                            stepModel: [
                                {
                                    target: tourStep1,
                                    title: qsTr('步骤1'),
                                    titleColor: '#3fcc9b',
                                    description: qsTr('这是步骤1\\n========'),
                                },
                                {
                                    target: tourStep2,
                                    title: qsTr('步骤2'),
                                    description: qsTr('这是步骤2\\n!!!!!!!!!!'),
                                    descriptionColor: '#3116ff'
                                },
                                {
                                    target: tourStep3,
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
                            id: tourStep1
                            text: qsTr('漫游步骤1')
                            type: HusButton.Type_Outlined
                        }

                        HusButton {
                            id: tourStep2
                            text: qsTr('漫游步骤2')
                            type: HusButton.Type_Outlined
                        }

                        HusButton {
                            id: tourStep3
                            text: qsTr('漫游步骤3   ####')
                            type: HusButton.Type_Outlined
                        }
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
                        stepModel: [
                            {
                                target: tourStep1,
                                title: qsTr('步骤1'),
                                titleColor: '#3fcc9b',
                                description: qsTr('这是步骤1\n========'),
                            },
                            {
                                target: tourStep2,
                                title: qsTr('步骤2'),
                                description: qsTr('这是步骤2\n!!!!!!!!!!'),
                                descriptionColor: '#3116ff'
                            },
                            {
                                target: tourStep3,
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
                        id: tourStep1
                        text: qsTr('漫游步骤1')
                        type: HusButton.Type_Outlined
                    }

                    HusButton {
                        id: tourStep2
                        text: qsTr('漫游步骤2')
                        type: HusButton.Type_Outlined
                    }

                    HusButton {
                        id: tourStep3
                        text: qsTr('漫游步骤3   ####')
                        type: HusButton.Type_Outlined
                    }
                }
            }
        }
    }
}

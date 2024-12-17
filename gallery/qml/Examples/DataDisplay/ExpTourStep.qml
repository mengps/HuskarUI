import QtQuick
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height

    Column {
        id: column
        width: parent.width
        spacing: 30

        CodeBox {
            width: parent.width
            desc: qsTr(`
**DelTourFocus 漫游焦点**\n
支持的属性：\n
通过 \`target\` 属性设置焦点目标\n
通过 \`overlayColor\` 属性设置覆盖层颜色\n
通过 \`focusMargin\` 属性设置焦点边距\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10

                    DelButton {
                        text: qsTr("漫游焦点")
                        type: DelButtonType.Type_Primary
                        onClicked: {
                            tourFocus.open();
                        }

                        DelTourFocus {
                            id: tourFocus
                            target: tourFocus1
                        }
                    }

                    Row {
                        spacing: 10

                        DelButton {
                            id: tourFocus1
                            text: qsTr("漫游焦点1")
                            type: DelButtonType.Type_Outlined
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelButton {
                    text: qsTr("漫游焦点")
                    type: DelButtonType.Type_Primary
                    onClicked: {
                        tourFocus.open();
                    }

                    DelTourFocus {
                        id: tourFocus
                        target: tourFocus1
                    }
                }

                Row {
                    spacing: 10

                    DelButton {
                        id: tourFocus1
                        text: qsTr("漫游焦点1")
                        type: DelButtonType.Type_Outlined
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
**DelTourStep 漫游步骤**\n
 \n
支持的代理：\n
**arrowDelegate: Component** 步骤箭头代理\n
**stepCardDelegate: Component** 步骤卡片代理\n
**indicatorDelegate: Component** 步骤指示器代理\n
支持的属性：\n
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
                import DelegateUI

                Column {
                    spacing: 10

                    DelButton {
                        text: qsTr("漫游步骤")
                        type: DelButtonType.Type_Primary
                        onClicked: {
                            tourStep.resetStep();
                            tourStep.open();
                        }

                        DelTourStep {
                            id: tourStep
                            stepModel: [
                                {
                                    target: tourStep1,
                                    title: qsTr("步骤1"),
                                    titleColor: "#3fcc9b",
                                    description: qsTr("这是步骤1\\n========"),
                                },
                                {
                                    target: tourStep2,
                                    title: qsTr("步骤2"),
                                    description: qsTr("这是步骤2\\n!!!!!!!!!!"),
                                    descriptionColor: "#3116ff"
                                },
                                {
                                    target: tourStep3,
                                    cardColor: "#ffa2eb",
                                    title: qsTr("步骤3"),
                                    titleColor: "red",
                                    description: qsTr("这是步骤3\\n##############")
                                }
                            ]
                        }
                    }

                    Row {
                        spacing: 10

                        DelButton {
                            id: tourStep1
                            text: qsTr("漫游步骤1")
                        }

                        DelButton {
                            id: tourStep2
                            text: qsTr("漫游步骤2")
                        }

                        DelButton {
                            id: tourStep3
                            text: qsTr("漫游步骤3   ####")
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelButton {
                    text: qsTr("漫游步骤")
                    type: DelButtonType.Type_Primary
                    onClicked: {
                        tourStep.resetStep();
                        tourStep.open();
                    }

                    DelTourStep {
                        id: tourStep
                        stepModel: [
                            {
                                target: tourStep1,
                                title: qsTr("步骤1"),
                                titleColor: "#3fcc9b",
                                description: qsTr("这是步骤1\n========"),
                            },
                            {
                                target: tourStep2,
                                title: qsTr("步骤2"),
                                description: qsTr("这是步骤2\n!!!!!!!!!!"),
                                descriptionColor: "#3116ff"
                            },
                            {
                                target: tourStep3,
                                cardColor: "#ffa2eb",
                                title: qsTr("步骤3"),
                                titleColor: "red",
                                description: qsTr("这是步骤3\n##############")
                            }
                        ]
                    }
                }

                Row {
                    spacing: 10

                    DelButton {
                        id: tourStep1
                        text: qsTr("漫游步骤1")
                    }

                    DelButton {
                        id: tourStep2
                        text: qsTr("漫游步骤2")
                    }

                    DelButton {
                        id: tourStep3
                        text: qsTr("漫游步骤3   ####")
                    }
                }
            }
        }
    }
}

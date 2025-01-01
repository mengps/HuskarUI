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
## DelTabView 标签页\n
通过选项卡标签切换内容的组件。\n
* **继承自 { Item }**\n
支持的代理：\n
- **tabDelegate: Component** 标签代理，代理可访问属性：\n
  - \`index\` 标签索引\n
  - \`modelData\` 模型数据\n
- **highlightDelegate: Component** 高亮项(当前标签背景)代理\n
- **contentDelegate: Component** 内容代理，代理可访问属性：\n
  - \`index\` 内容索引\n
  - \`modelData\` 模型数据\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
model | list | 标签页模型
currentIndex | int | 当前标签页索引
tabPosition | int | 标签位置(来自 DelTabViewType)
tabCentered | bool | 标签是否居中(默认false)
defaultTabWidth | int | 默认标签宽度
defaultTabHeight | int | 默认标签高度
defaultTabSpacing | int | 默认标签间隔
\n支持的函数：\n
- \`insert(index: int, object: Object)\` 插入标签 \`object\` 到 \`index\` 处 \n
- \`append(object: Object)\` 在末尾添加标签 \`object\` \n
- \`removeAt(index: int)\` 删除 \`index\` 处的标签和内容 \n
- \`clear()\`清空所有标签和内容 \n
                       `)
        }

        Text {
            width: parent.width - 20
            height: implicitHeight - 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("代码演示")
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySizeHeading3
            }
            color: DelTheme.Primary.colorTextBase
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`model\` 属性设置标签和标签页的模型{需为list}，标签项支持的属性有：\n
- { key: 本标签页的键 }\n
- { title: 本标签的标题 }\n
- { icon: 本标签的图标 }\n
- { iconSize: 本标签的图标大小 }\n
- { iconPosition: 本标签的图标位置 }\n
- { tabWidth: 本标签宽度 }\n
- { tabHeight: 本标签高度 }\n
通过 \`tabPosition\` 属性设置标签位置，支持的位置：\n
- 标签在上方(默认){ DelTabViewType.Top }\n
- 标签在下方{ DelTabViewType.Bottom }\n
- 标签在左方{ DelTabViewType.Left }\n
- 标签在右方{ DelTabViewType.Right }\n
通过 \`tabCentered\` 属性设置标签列表是否居中\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    Row {
                        spacing: 2

                        DelButton {
                            text: qsTr("上")
                            type: DelButtonType.Type_Outlined
                            onClicked: positionTabView.tabPosition = DelTabViewType.Top;
                        }
                        DelButton {
                            text: qsTr("下")
                            type: DelButtonType.Type_Outlined
                            onClicked: positionTabView.tabPosition = DelTabViewType.Bottom;
                        }
                        DelButton {
                            text: qsTr("左")
                            type: DelButtonType.Type_Outlined
                            onClicked: positionTabView.tabPosition = DelTabViewType.Left;
                        }
                        DelButton {
                            text: qsTr("右")
                            type: DelButtonType.Type_Outlined
                            onClicked: positionTabView.tabPosition = DelTabViewType.Right;
                        }
                    }

                    Row {
                        spacing: 2

                        DelButton {
                            text: qsTr("不居中")
                            type: DelButtonType.Type_Outlined
                            onClicked: positionTabView.tabCentered = false;
                        }

                        DelButton {
                            text: qsTr("居中")
                            type: DelButtonType.Type_Outlined
                            onClicked: positionTabView.tabCentered = true;
                        }
                    }

                    DelTabView {
                        id: positionTabView
                        width: parent.width
                        height: 200
                        contentDelegate: Rectangle {
                            color: modelData.contentColor

                            Text {
                                anchors.centerIn: parent
                                text: modelData.content + (index + 1)
                                font {
                                    family: DelTheme.Primary.fontPrimaryFamily
                                    pixelSize: DelTheme.Primary.fontPrimarySize
                                }
                                color: DelTheme.Primary.colorTextBase
                            }
                        }
                        model: [
                            {
                                key: "1",
                                icon: DelIcon.CreditCardOutlined,
                                title: "Tab 1",
                                content: "Content of Tab Content ",
                                contentColor: "#60ff0000"
                            },
                            {
                                key: "2",
                                icon: DelIcon.CreditCardOutlined,
                                iconPosition: DelButtonType.Position_End,
                                title: "Tab 2",
                                content: "Content of Tab Content ",
                                contentColor: "#6000ff00"
                            },
                            {
                                key: "3",
                                title: "Tab 3",
                                content: "Content of Tab Content ",
                                contentColor: "#600000ff"
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 2

                    DelButton {
                        text: qsTr("上")
                        type: DelButtonType.Type_Outlined
                        onClicked: positionTabView.tabPosition = DelTabViewType.Top;
                    }
                    DelButton {
                        text: qsTr("下")
                        type: DelButtonType.Type_Outlined
                        onClicked: positionTabView.tabPosition = DelTabViewType.Bottom;
                    }
                    DelButton {
                        text: qsTr("左")
                        type: DelButtonType.Type_Outlined
                        onClicked: positionTabView.tabPosition = DelTabViewType.Left;
                    }
                    DelButton {
                        text: qsTr("右")
                        type: DelButtonType.Type_Outlined
                        onClicked: positionTabView.tabPosition = DelTabViewType.Right;
                    }
                }

                Row {
                    spacing: 2

                    DelButton {
                        text: qsTr("不居中")
                        type: DelButtonType.Type_Outlined
                        onClicked: positionTabView.tabCentered = false;
                    }

                    DelButton {
                        text: qsTr("居中")
                        type: DelButtonType.Type_Outlined
                        onClicked: positionTabView.tabCentered = true;
                    }
                }

                DelTabView {
                    id: positionTabView
                    width: parent.width
                    height: 200
                    contentDelegate: Rectangle {
                        color: modelData.contentColor

                        Text {
                            anchors.centerIn: parent
                            text: modelData.content + (index + 1)
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }
                    }
                    model: [
                        {
                            key: "1",
                            icon: DelIcon.CreditCardOutlined,
                            title: "Tab 1",
                            content: "Content of Tab Content ",
                            contentColor: "#60ff0000"
                        },
                        {
                            key: "2",
                            icon: DelIcon.CreditCardOutlined,
                            iconPosition: DelButtonType.Position_End,
                            title: "Tab 2",
                            content: "Content of Tab Content ",
                            contentColor: "#6000ff00"
                        },
                        {
                            key: "3",
                            title: "Tab 3",
                            content: "Content of Tab Content ",
                            contentColor: "#600000ff"
                        }
                    ]
                }
            }
        }
    }
}

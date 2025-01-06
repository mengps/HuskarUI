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
- **addButtonDelegate: Component** 添加按钮的代理\n
- **highlightDelegate: Component** 高亮项(当前标签背景)代理\n
- **tabDelegate: Component** 标签代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
- **contentDelegate: Component** 内容代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
initModel | list | 标签页初始模型
count | int | 当前标签页数量
currentIndex | int | 当前标签页索引(更改该值可切换页)
tabType | int | 标签类型(来自 DelTabViewType)
tabPosition | int | 标签位置(来自 DelTabViewType)
tabCentered | bool | 标签是否居中(默认false)
tabCardMovable | bool | 标签卡片是否可移动(tabType == Card*生效)
defaultTabWidth | int | 默认标签宽度
defaultTabHeight | int | 默认标签高度
defaultTabSpacing | int | 默认标签间隔
defaultTabBgRadius | int | 默认标签背景半径(tabType == Card*生效)
defaultHighlightWidth | int | 默认高亮条宽度半径(tabType == Default生效)
addTabCallback | Function | 添加标签回调(点击+按钮时调用)
\n支持的函数：\n    
- \`flick(index: int)\` 等同于调用 \`Flickable.flick()\` \n
- \`positionViewAtBeginning(index: int)\` 等同于调用 \`ListView.positionViewAtBeginning()\` \n
- \`positionViewAtIndex(index: int, mode: int)\` 等同于调用 \`ListView.positionViewAtIndex()\` \n
- \`positionViewAtEnd(index: int)\` 等同于调用 \`ListView.positionViewAtEnd()\` \n
- \`Object get(index: int)\` 获取 \`index\` 处的模型数据 \n
- \`set(index: int, object: Object)\` 设置 \`index\` 处的模型数据为 \`object\` \n
- \`setProperty(index: int, propertyName: string, value: any)\` 设置 \`index\` 处的模型数据属性名 \`propertyName\` 值为 \`value\` \n
- \`move(from: int, to: int, count: int = 1)\` 将 \`count\` 个模型数据从 \`from\` 位置移动到 \`to\` 位置 \n
- \`insert(index: int, object: Object)\` 插入标签 \`object\` 到 \`index\` 处 \n
- \`append(object: Object)\` 在末尾添加标签 \`object\` \n
- \`removeAt(index: int, count: int = 1)\` 删除 \`index\` 处 \`count\` 个模型数据 \n
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
通过 \`initModel\` 属性设置初始标签页的模型{需为list}，标签项支持的属性有：\n
- { key: 本标签页的键 }\n
- { title: 本标签的标题 }\n
- { icon: 本标签的图标 }\n
- { iconSize: 本标签的图标大小 }\n
- { iconSpacing: 本标签和文本间隔 }\n
- { tabWidth: 本标签宽度 }\n
- { tabHeight: 本标签高度 }\n
- { editable: 本标签是否可编辑(tabType == CardEditable时生效) }\n
通过 \`tabPosition\` 属性设置标签位置，支持的位置：\n
- 标签在上方(默认){ DelTabViewType.Top }\n
- 标签在下方{ DelTabViewType.Bottom }\n
- 标签在左方{ DelTabViewType.Left }\n
- 标签在右方{ DelTabViewType.Right }\n
通过 \`tabSize\` 属性设置标签大小计算方式，支持的方式：\n
- 自动计算标签大小(取决于文本大小){ DelTabViewType.Auto }\n
- 固定标签大小(取决于 tabWidth 和 defaultTabWidth){ DelTabViewType.Fixed }\n
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
                            onClicked: defaultTabView.tabPosition = DelTabViewType.Top;
                        }
                        DelButton {
                            text: qsTr("下")
                            type: DelButtonType.Type_Outlined
                            onClicked: defaultTabView.tabPosition = DelTabViewType.Bottom;
                        }
                        DelButton {
                            text: qsTr("左")
                            type: DelButtonType.Type_Outlined
                            onClicked: defaultTabView.tabPosition = DelTabViewType.Left;
                        }
                        DelButton {
                            text: qsTr("右")
                            type: DelButtonType.Type_Outlined
                            onClicked: defaultTabView.tabPosition = DelTabViewType.Right;
                        }
                    }

                    Row {
                        spacing: 10

                        Text {
                            text: qsTr("是否居中")
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }

                        DelSwitch {
                            id: isCenterSwitch
                            checkedText: qsTr("是")
                            uncheckedText: qsTr("否")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10

                        Text {
                            text: qsTr("标签大小")
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }

                        DelSwitch {
                            id: sizeSwitch
                            checkedText: qsTr("固定")
                            uncheckedText: qsTr("自动")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    DelTabView {
                        id: defaultTabView
                        width: parent.width
                        height: 200
                        defaultTabWidth: 40
                        tabSize: sizeSwitch.checked ? DelTabViewType.Fixed : DelTabViewType.Auto
                        tabCentered: isCenterSwitch.checked
                        addTabCallback:
                            () => {
                                append({
                                           title: "New Tab " + (count + 1),
                                           content: "Content of Tab Content ",
                                           contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                                       });
                                currentIndex = count - 1;
                                positionViewAtEnd();
                            }
                        contentDelegate: Rectangle {
                            color: model.contentColor

                            Text {
                                anchors.centerIn: parent
                                text: model.content + (index + 1)
                                font {
                                    family: DelTheme.Primary.fontPrimaryFamily
                                    pixelSize: DelTheme.Primary.fontPrimarySize
                                }
                                color: DelTheme.Primary.colorTextBase
                            }
                        }
                        initModel: [
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
                        onClicked: defaultTabView.tabPosition = DelTabViewType.Top;
                    }
                    DelButton {
                        text: qsTr("下")
                        type: DelButtonType.Type_Outlined
                        onClicked: defaultTabView.tabPosition = DelTabViewType.Bottom;
                    }
                    DelButton {
                        text: qsTr("左")
                        type: DelButtonType.Type_Outlined
                        onClicked: defaultTabView.tabPosition = DelTabViewType.Left;
                    }
                    DelButton {
                        text: qsTr("右")
                        type: DelButtonType.Type_Outlined
                        onClicked: defaultTabView.tabPosition = DelTabViewType.Right;
                    }
                }

                Row {
                    spacing: 10

                    Text {
                        text: qsTr("是否居中")
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                        color: DelTheme.Primary.colorTextBase
                    }

                    DelSwitch {
                        id: isCenterSwitch
                        checkedText: qsTr("是")
                        uncheckedText: qsTr("否")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 10

                    Text {
                        text: qsTr("标签大小")
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                        color: DelTheme.Primary.colorTextBase
                    }

                    DelSwitch {
                        id: sizeSwitch
                        checkedText: qsTr("固定")
                        uncheckedText: qsTr("自动")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                DelTabView {
                    id: defaultTabView
                    width: parent.width
                    height: 200
                    defaultTabWidth: 40
                    tabSize: sizeSwitch.checked ? DelTabViewType.Fixed : DelTabViewType.Auto
                    tabCentered: isCenterSwitch.checked
                    addTabCallback:
                        () => {
                            append({
                                       title: "New Tab " + (count + 1),
                                       content: "Content of Tab Content ",
                                       contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                                   });
                            currentIndex = count - 1;
                            positionViewAtEnd();
                        }
                    contentDelegate: Rectangle {
                        color: model.contentColor

                        Text {
                            anchors.centerIn: parent
                            text: model.content + (index + 1)
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }
                    }
                    initModel: [
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

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`tabType\` 属性设置标签类型，支持的类型：\n
- 默认标签(默认){ DelTabViewType.Default }\n
- 卡片标签{ DelTabViewType.Card }\n
- 可编辑卡片标签{ DelTabViewType.CardEditable }\n
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
                            onClicked: cardTabView.tabPosition = DelTabViewType.Top;
                        }
                        DelButton {
                            text: qsTr("下")
                            type: DelButtonType.Type_Outlined
                            onClicked: cardTabView.tabPosition = DelTabViewType.Bottom;
                        }
                        DelButton {
                            text: qsTr("左")
                            type: DelButtonType.Type_Outlined
                            onClicked: cardTabView.tabPosition = DelTabViewType.Left;
                        }
                        DelButton {
                            text: qsTr("右")
                            type: DelButtonType.Type_Outlined
                            onClicked: cardTabView.tabPosition = DelTabViewType.Right;
                        }
                    }

                    Row {
                        spacing: 10

                        Text {
                            text: qsTr("是否居中")
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }

                        DelSwitch {
                            id: isCenterSwitch2
                            checkedText: qsTr("是")
                            uncheckedText: qsTr("否")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10

                        Text {
                            text: qsTr("标签大小")
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }

                        DelSwitch {
                            id: sizeSwitch2
                            checkedText: qsTr("固定")
                            uncheckedText: qsTr("自动")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10

                        Text {
                            text: qsTr("是否可编辑")
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }

                        DelSwitch {
                            id: typeSwitch
                            checkedText: qsTr("是")
                            uncheckedText: qsTr("否")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    DelTabView {
                        id: cardTabView
                        width: parent.width
                        height: 200
                        defaultTabWidth: 50
                        tabSize: sizeSwitch2.checked ? DelTabViewType.Fixed : DelTabViewType.Auto
                        tabType: typeSwitch.checked ? DelTabViewType.CardEditable :  DelTabViewType.Card
                        tabCentered: isCenterSwitch2.checked
                        addTabCallback:
                            () => {
                                append({
                                           title: "New Tab " + (count + 1),
                                           content: "Content of Tab Content ",
                                           contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                                       });
                                currentIndex = count - 1;
                                positionViewAtEnd();
                            }
                        contentDelegate: Rectangle {
                            color: model.contentColor

                            Text {
                                anchors.centerIn: parent
                                text: model.content + (index + 1)
                                font {
                                    family: DelTheme.Primary.fontPrimaryFamily
                                    pixelSize: DelTheme.Primary.fontPrimarySize
                                }
                                color: DelTheme.Primary.colorTextBase
                            }
                        }
                        initModel: [
                            {
                                key: "1",
                                icon: DelIcon.CreditCardOutlined,
                                title: "Tab 1",
                                content: "Content of Card Tab Content ",
                                contentColor: "#60ff0000"
                            },
                            {
                                key: "2",
                                editable: false,
                                icon: DelIcon.CreditCardOutlined,
                                title: "Tab 2",
                                content: "Content of Card Tab Content ",
                                contentColor: "#6000ff00"
                            },
                            {
                                key: "3",
                                title: "Tab 3",
                                content: "Content of Card Tab Content ",
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
                        onClicked: cardTabView.tabPosition = DelTabViewType.Top;
                    }
                    DelButton {
                        text: qsTr("下")
                        type: DelButtonType.Type_Outlined
                        onClicked: cardTabView.tabPosition = DelTabViewType.Bottom;
                    }
                    DelButton {
                        text: qsTr("左")
                        type: DelButtonType.Type_Outlined
                        onClicked: cardTabView.tabPosition = DelTabViewType.Left;
                    }
                    DelButton {
                        text: qsTr("右")
                        type: DelButtonType.Type_Outlined
                        onClicked: cardTabView.tabPosition = DelTabViewType.Right;
                    }
                }

                Row {
                    spacing: 10

                    Text {
                        text: qsTr("是否居中")
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                        color: DelTheme.Primary.colorTextBase
                    }

                    DelSwitch {
                        id: isCenterSwitch2
                        checkedText: qsTr("是")
                        uncheckedText: qsTr("否")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 10

                    Text {
                        text: qsTr("标签大小")
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                        color: DelTheme.Primary.colorTextBase
                    }

                    DelSwitch {
                        id: sizeSwitch2
                        checkedText: qsTr("固定")
                        uncheckedText: qsTr("自动")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 10

                    Text {
                        text: qsTr("是否可编辑")
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                        color: DelTheme.Primary.colorTextBase
                    }

                    DelSwitch {
                        id: typeSwitch
                        checkedText: qsTr("是")
                        uncheckedText: qsTr("否")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                DelTabView {
                    id: cardTabView
                    width: parent.width
                    height: 200
                    defaultTabWidth: 50
                    tabSize: sizeSwitch2.checked ? DelTabViewType.Fixed : DelTabViewType.Auto
                    tabType: typeSwitch.checked ? DelTabViewType.CardEditable :  DelTabViewType.Card
                    tabCentered: isCenterSwitch2.checked
                    addTabCallback:
                        () => {
                            append({
                                       title: "New Tab " + (count + 1),
                                       content: "Content of Tab Content ",
                                       contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                                   });
                            currentIndex = count - 1;
                            positionViewAtEnd();
                        }
                    contentDelegate: Rectangle {
                        color: model.contentColor

                        Text {
                            anchors.centerIn: parent
                            text: model.content + (index + 1)
                            font {
                                family: DelTheme.Primary.fontPrimaryFamily
                                pixelSize: DelTheme.Primary.fontPrimarySize
                            }
                            color: DelTheme.Primary.colorTextBase
                        }
                    }
                    initModel: [
                        {
                            key: "1",
                            icon: DelIcon.CreditCardOutlined,
                            title: "Tab 1",
                            content: "Content of Card Tab Content ",
                            contentColor: "#60ff0000"
                        },
                        {
                            key: "2",
                            editable: false,
                            icon: DelIcon.CreditCardOutlined,
                            title: "Tab 2",
                            content: "Content of Card Tab Content ",
                            contentColor: "#6000ff00"
                        },
                        {
                            key: "3",
                            title: "Tab 3",
                            content: "Content of Card Tab Content ",
                            contentColor: "#600000ff"
                        }
                    ]
                }
            }
        }
    }
}

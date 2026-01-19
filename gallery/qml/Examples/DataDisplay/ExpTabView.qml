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
# HusTabView 标签页\n
通过选项卡标签切换内容的组件。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **addButtonDelegate: Component** 添加按钮的代理\n
- **highlightDelegate: Component** 高亮项(当前标签背景)代理\n
- **tabDelegate: Component** 标签代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
- **contentDelegate: Component** 内容代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
initModel | list | true | 标签页初始模型
count | int | true | 当前标签页数量
currentIndex | int | true | 当前标签页索引(更改该值可切换页)
tabType | enum | HusTabView.Type_Default | 标签类型(来自 HusTabView)
tabSize | enum | HusTabView.Size_Auto | 标签大小(来自 HusTabView)
tabPosition | enum | HusTabView.Position_Top | 标签位置(来自 HusTabView)
tabAddable | bool | false | 标签是否可新增
tabCentered | bool | false | 标签是否居中
tabCardMovable | bool | true | 标签卡片是否可移动(tabType == Type_Card*生效)
defaultTabWidth | int | 80 | 默认标签宽度
defaultTabHeight | int | - | 默认标签高度
defaultTabSpacing | int | 2 | 默认标签间隔
defaultTabBgRadius | int | - | 默认标签背景半径(tabType == Type_Card*生效)
defaultHighlightWidth | int | 30丨20 | 默认高亮条宽度半径(tabType == Type_Default生效)
addTabCallback | function() | - | 添加标签回调(点击+按钮时调用)
closeTabCallback | function(index, data) | - | 关闭标签回调(点击x按钮时调用)
\n<br/>
\n### 模型支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
key | string | 可选 | 本标签页的键
title | string | 可选 | 本标签的标题
iconSource | int丨string | 可选 | 本标签的图标源
iconSize | int | 可选 | 本标签的图标大小
iconSpacing | bool | 可选 | 本标签图标和文本的间隔
tabWidth | int | 可选 | 本标签宽度
tabHeight | int | 可选 | 本标签高度
editable | bool | 可选 | 本标签是否可编辑
\n<br/>
\n### 支持的函数：\n
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
- \`remove(index: int, count: int = 1)\` 删除 \`index\` 处 \`count\` 个模型数据 \n
- \`clear()\`清空所有标签和内容 \n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
提供平级的区域将大块内容进行收纳和展现，保持界面整洁。\n
**HuskarUI** 依次提供了三级选项卡，分别用于不同的场景。\n
- 卡片式的页签，提供可关闭的样式，常用于容器顶部。\n
- 既可用于容器顶部，也可用于容器内部，是最通用的 Tabs。\n
- [HusRadio](internal://HusRadio) 可作为更次级的页签来使用。\n
                       `)
        }

        ThemeToken {
            source: 'HusTabView'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusTabView.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`initModel\` 属性设置初始标签页的模型{需为list}，标签项支持的属性有：\n
- { key: 本标签页的键 }\n
- { title: 本标签的标题 }\n
- { iconSource: 本标签的图标源 }\n
- { iconSize: 本标签的图标大小 }\n
- { iconSpacing: 本标签图标和文本的间隔 }\n
- { tabWidth: 本标签宽度 }\n
- { tabHeight: 本标签高度 }\n
- { editable: 本标签是否可编辑(tabType == Type_CardEditable时生效) }\n
通过 \`tabPosition\` 属性设置标签位置，支持的位置：\n
- 标签在上方(默认){ HusTabView.Position_Top }\n
- 标签在下方{ HusTabView.Position_Bottom }\n
- 标签在左方{ HusTabView.Position_Left }\n
- 标签在右方{ HusTabView.Position_Right }\n
通过 \`tabSize\` 属性设置标签大小计算方式，支持的方式：\n
- 自动计算标签大小(取决于文本大小){ HusTabView.Size_Auto }\n
- 固定标签大小(取决于 tabWidth 和 defaultTabWidth){ HusTabView.Size_Fixed }\n
通过 \`tabAddable\` 属性设置标签列表是否可新增\n
通过 \`tabCentered\` 属性设置标签列表是否居中\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusRadioBlock {
                        id: positionRadio1
                        initCheckedIndex: 0
                        model: [
                            { label: qsTr('上'), value: HusTabView.Position_Top },
                            { label: qsTr('下'), value: HusTabView.Position_Bottom },
                            { label: qsTr('左'), value: HusTabView.Position_Left },
                            { label: qsTr('右'), value: HusTabView.Position_Right }
                        ]
                    }

                    Row {
                        spacing: 10
    
                        HusText { text: qsTr('是否可新增') }
    
                        HusSwitch {
                            id: addableSwitch
                            checkedText: qsTr('是')
                            uncheckedText: qsTr('否')
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10

                        HusText { text: qsTr('是否居中') }

                        HusSwitch {
                            id: isCenterSwitch
                            checkedText: qsTr('是')
                            uncheckedText: qsTr('否')
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10

                        HusText { text: qsTr('标签大小') }

                        HusSwitch {
                            id: sizeSwitch
                            checkedText: qsTr('固定')
                            uncheckedText: qsTr('自动')
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    HusTabView {
                        id: defaultTabView
                        width: parent.width
                        height: 200
                        defaultTabWidth: 40
                        tabPosition: positionRadio1.currentCheckedValue
                        tabSize: sizeSwitch.checked ? HusTabView.Size_Fixed : HusTabView.Size_Auto
                        tabAddable: addableSwitch.checked
                        tabCentered: isCenterSwitch.checked
                        addTabCallback:
                            () => {
                                append({
                                           title: 'New Tab ' + (count + 1),
                                           content: 'Content of Tab Content ',
                                           contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                                       });
                                currentIndex = count - 1;
                                positionViewAtEnd();
                            }
                        contentDelegate: Rectangle {
                            color: model.contentColor

                            HusText {
                                anchors.centerIn: parent
                                text: model.content + (index + 1)
                            }
                        }
                        initModel: [
                            {
                                key: '1',
                                iconSource: HusIcon.CreditCardOutlined,
                                title: 'Tab 1',
                                content: 'Content of Tab Content ',
                                contentColor: '#60ff0000'
                            },
                            {
                                key: '2',
                                iconSource: HusIcon.CreditCardOutlined,
                                title: 'Tab 2',
                                content: 'Content of Tab Content ',
                                contentColor: '#6000ff00'
                            },
                            {
                                key: '3',
                                title: 'Tab 3',
                                content: 'Content of Tab Content ',
                                contentColor: '#600000ff'
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRadioBlock {
                    id: positionRadio1
                    initCheckedIndex: 0
                    model: [
                        { label: qsTr('上'), value: HusTabView.Position_Top },
                        { label: qsTr('下'), value: HusTabView.Position_Bottom },
                        { label: qsTr('左'), value: HusTabView.Position_Left },
                        { label: qsTr('右'), value: HusTabView.Position_Right }
                    ]
                }

                Row {
                    spacing: 10

                    HusText { text: qsTr('是否可新增') }

                    HusSwitch {
                        id: addableSwitch
                        checkedText: qsTr('是')
                        uncheckedText: qsTr('否')
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 10

                    HusText { text: qsTr('是否居中')  }

                    HusSwitch {
                        id: isCenterSwitch
                        checkedText: qsTr('是')
                        uncheckedText: qsTr('否')
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 10

                    HusText { text: qsTr('标签大小') }

                    HusSwitch {
                        id: sizeSwitch
                        checkedText: qsTr('固定')
                        uncheckedText: qsTr('自动')
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                HusTabView {
                    id: defaultTabView
                    width: parent.width
                    height: 200
                    defaultTabWidth: 40
                    tabPosition: positionRadio1.currentCheckedValue
                    tabSize: sizeSwitch.checked ? HusTabView.Size_Fixed : HusTabView.Size_Auto
                    tabAddable: addableSwitch.checked
                    tabCentered: isCenterSwitch.checked
                    addTabCallback:
                        () => {
                            append({
                                       title: 'New Tab ' + (count + 1),
                                       content: 'Content of Tab Content ',
                                       contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                                   });
                            currentIndex = count - 1;
                            positionViewAtEnd();
                        }
                    contentDelegate: Rectangle {
                        color: model.contentColor

                        HusText {
                            anchors.centerIn: parent
                            text: model.content + (index + 1)
                        }
                    }
                    initModel: [
                        {
                            key: '1',
                            iconSource: HusIcon.CreditCardOutlined,
                            title: 'Tab 1',
                            content: 'Content of Tab Content ',
                            contentColor: '#60ff0000'
                        },
                        {
                            key: '2',
                            iconSource: HusIcon.CreditCardOutlined,
                            title: 'Tab 2',
                            content: 'Content of Tab Content ',
                            contentColor: '#6000ff00'
                        },
                        {
                            key: '3',
                            title: 'Tab 3',
                            content: 'Content of Tab Content ',
                            contentColor: '#600000ff'
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`tabType\` 属性设置标签类型，支持的类型：\n
- 默认标签(默认){ HusTabView.Type_Default }\n
- 卡片标签{ HusTabView.Type_Card }\n
- 可编辑卡片标签{ HusTabView.Type_CardEditable }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusRadioBlock {
                        id: positionRadio2
                        initCheckedIndex: 0
                        model: [
                            { label: qsTr('上'), value: HusTabView.Position_Top },
                            { label: qsTr('下'), value: HusTabView.Position_Bottom },
                            { label: qsTr('左'), value: HusTabView.Position_Left },
                            { label: qsTr('右'), value: HusTabView.Position_Right }
                        ]
                    }

                    Row {
                        spacing: 10

                        HusText { text: qsTr('是否可新增') }

                        HusSwitch {
                            id: addableSwitch2
                            checkedText: qsTr('是')
                            uncheckedText: qsTr('否')
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10

                        HusText { text: qsTr('是否居中') }

                        HusSwitch {
                            id: isCenterSwitch2
                            checkedText: qsTr('是')
                            uncheckedText: qsTr('否')
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10

                        HusText { text: qsTr('标签大小') }

                        HusSwitch {
                            id: sizeSwitch2
                            checkedText: qsTr('固定')
                            uncheckedText: qsTr('自动')
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Row {
                        spacing: 10

                        HusText { text: qsTr('是否可编辑') }

                        HusSwitch {
                            id: typeSwitch
                            checkedText: qsTr('是')
                            uncheckedText: qsTr('否')
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    HusTabView {
                        id: cardTabView
                        width: parent.width
                        height: 200
                        defaultTabWidth: 50
                        tabPosition: positionRadio2.currentCheckedValue
                        tabSize: sizeSwitch2.checked ? HusTabView.Size_Fixed : HusTabView.Size_Auto
                        tabType: typeSwitch.checked ? HusTabView.Type_CardEditable :  HusTabView.Type_Card
                        tabAddable: addableSwitch2.checked
                        tabCentered: isCenterSwitch2.checked
                        addTabCallback:
                            () => {
                                append({
                                           title: 'New Tab ' + (count + 1),
                                           content: 'Content of Tab Content ',
                                           contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                                       });
                                currentIndex = count - 1;
                                positionViewAtEnd();
                            }
                        contentDelegate: Rectangle {
                            color: model.contentColor

                            HusText {
                                anchors.centerIn: parent
                                text: model.content + (index + 1)
                            }
                        }
                        initModel: [
                            {
                                key: '1',
                                iconSource: HusIcon.CreditCardOutlined,
                                title: 'Tab 1',
                                content: 'Content of Card Tab Content ',
                                contentColor: '#60ff0000'
                            },
                            {
                                key: '2',
                                editable: false,
                                iconSource: HusIcon.CreditCardOutlined,
                                title: 'Tab 2',
                                content: 'Content of Card Tab Content ',
                                contentColor: '#6000ff00'
                            },
                            {
                                key: '3',
                                title: 'Tab 3',
                                content: 'Content of Card Tab Content ',
                                contentColor: '#600000ff'
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRadioBlock {
                    id: positionRadio2
                    initCheckedIndex: 0
                    model: [
                        { label: qsTr('上'), value: HusTabView.Position_Top },
                        { label: qsTr('下'), value: HusTabView.Position_Bottom },
                        { label: qsTr('左'), value: HusTabView.Position_Left },
                        { label: qsTr('右'), value: HusTabView.Position_Right }
                    ]
                }

                Row {
                    spacing: 10

                    HusText { text: qsTr('是否可新增') }

                    HusSwitch {
                        id: addableSwitch2
                        checkedText: qsTr('是')
                        uncheckedText: qsTr('否')
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 10

                    HusText {
                        text: qsTr('是否居中')
                        font {
                            family: HusTheme.Primary.fontPrimaryFamily
                            pixelSize: HusTheme.Primary.fontPrimarySize
                        }
                        color: HusTheme.Primary.colorTextBase
                    }

                    HusSwitch {
                        id: isCenterSwitch2
                        checkedText: qsTr('是')
                        uncheckedText: qsTr('否')
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 10

                    HusText { text: qsTr('标签大小') }

                    HusSwitch {
                        id: sizeSwitch2
                        checkedText: qsTr('固定')
                        uncheckedText: qsTr('自动')
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    spacing: 10

                    HusText { text: qsTr('是否可编辑') }

                    HusSwitch {
                        id: typeSwitch
                        checkedText: qsTr('是')
                        uncheckedText: qsTr('否')
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                HusTabView {
                    id: cardTabView
                    width: parent.width
                    height: 200
                    defaultTabWidth: 50
                    tabPosition: positionRadio2.currentCheckedValue
                    tabSize: sizeSwitch2.checked ? HusTabView.Size_Fixed : HusTabView.Size_Auto
                    tabType: typeSwitch.checked ? HusTabView.Type_CardEditable :  HusTabView.Type_Card
                    tabAddable: addableSwitch2.checked
                    tabCentered: isCenterSwitch2.checked
                    addTabCallback:
                        () => {
                            append({
                                       title: 'New Tab ' + (count + 1),
                                       content: 'Content of Tab Content ',
                                       contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                                   });
                            currentIndex = count - 1;
                            positionViewAtEnd();
                        }
                    contentDelegate: Rectangle {
                        color: model.contentColor

                        HusText {
                            anchors.centerIn: parent
                            text: model.content + (index + 1)
                        }
                    }
                    initModel: [
                        {
                            key: '1',
                            iconSource: HusIcon.CreditCardOutlined,
                            title: 'Tab 1',
                            content: 'Content of Card Tab Content ',
                            contentColor: '#60ff0000'
                        },
                        {
                            key: '2',
                            editable: false,
                            iconSource: HusIcon.CreditCardOutlined,
                            title: 'Tab 2',
                            content: 'Content of Card Tab Content ',
                            contentColor: '#6000ff00'
                        },
                        {
                            key: '3',
                            title: 'Tab 3',
                            content: 'Content of Card Tab Content ',
                            contentColor: '#600000ff'
                        }
                    ]
                }
            }
        }
    }
}

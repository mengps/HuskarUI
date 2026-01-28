import QtQuick
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    HusScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        DocDescription {
            desc: qsTr(`
# HusTreeView 树视图 \n
多层次的结构列表。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **switcherDelegate: Component** 切换器(展开/折叠按钮)代理，代理可访问属性：\n
  - \`row: int\` 视图行索引\n
  - \`depth: int\` 节点深度\n
  - \`treeData: var\` 节点数据\n
  - \`isSelected: bool\` 节点是否选中\n
  - \`isExpanded: bool\` 节点是否展开\n
- **nodeContentDelegate: Component** 节点内容(不包含切换器和复选框)代理，代理可访问属性：\n
  - \`row: int\` 视图行索引\n
  - \`depth: int\` 节点深度\n
  - \`treeData: var\` 节点数据\n
  - \`isSelected: bool\` 节点是否选中\n
  - \`isExpanded: bool\` 节点是否展开\n
- **nodeBgDelegate: Component** 节点背景(包含切换器和复选框)代理，代理可访问属性：\n
  - \`row: int\` 视图行索引\n
  - \`depth: int\` 节点深度\n
  - \`treeData: var\` 节点数据\n
  - \`isSelected: bool\` 节点是否选中\n
  - \`isExpanded: bool\` 节点是否展开\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
reuseItems | bool | false | 是否重用项目(具体参考官方文档)
checkable | bool | false | 是否添加[HusCheckbox](internal://HusCheckbox)复选框
blockNode | bool | false | 节点内容是否填充整行
genDefaultKey | bool | true | 未提供key时是否生成默认键(生成键形如'0-1-2...')
forceUpdateCheckState | bool | false | 强制更新check状态(为true时将不受enabled/checkboxDisabled约束)
indent | real | 18 | 缩进宽度
showIcon | bool | false | 是否显示节点图标
defaultNodeIconSize | int | 16 | 默认节点图标大小
showLine | bool | false | 是否显示连接线
lineStyle | enum | HusTreeView.SolidLine | 连接线样式(来自 HusTreeView)
lineWidth | real | 1 | 连接线宽度
dashPattern | list | [4, 4] | 连接线虚线模式
switcherIconSouce | int丨string | HusIcon.CaretRightOutlined | 切换器图标源(来自 HusIcon)或图标链接
switcherIconSize | int | 12 | 切换器图标大小
rowSpacing | real | 4 | 节点行之间的间隔
defaultCheckedKeys | list | [] | 默认选中的键列表
checkedKeys | list | [] | 选中的键列表
selectedKey | string | '' | 当前选择的键(非复选框)
initModel | list | [] | 初始模型
titleFont | font | - | 节点标题文本字体
nodeIconFont | font | - | 节点图标字体
colorLine | color | - | 连接线颜色
colorNodeIcon | color | - | 节点图标颜色
radiusSwitcherBg | [HusRadius](internal://HusRadius) | - | 切换器背景圆角
radiusTitleBg | [HusRadius](internal://HusRadius) | - | 节点标题背景圆角
verScrollBar | [HusScrollBar](internal://HusScrollBar) | - | 访问内部垂直滚动条
horScrollBar | [HusScrollBar](internal://HusScrollBar) | - | 访问内部水平滚动条
treeView | TreeView | - | 访问内部树视图
treeModel | TreeModel | - | 访问内部树模型
\n<br/>
\n### 模型支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
title | string | 必选 | 本节点标题
key | string | 可选 | 本节点键
enabled | bool | 可选 | 本节点是否启用(默认true)
checkboxDisabled | bool | 可选 | 复选框是否禁用(默认false)
delegateUrl | url | 可选 | 本节点代理的url(等同于Loader.source)
children | list | 可选 | 子节点列表
\n<br/>
\n### 支持的函数：\n
- \`clear()\` 清空所有模型数据(包括initModel)。\n
- \`checkForKeys(keys: Array)\` 选中 \`keys\` 提供的键列表。\n
- \`expandForKeys(keys: Array)\` 展开 \`keys\` 提供的键列表。\n
- \`expandToIndex(index: QModelIndex)\` 展开 \`index\` 到所在的节点。\n
- \`collapseToIndex(index: QModelIndex)\` 折叠 \`index\` 到所在的节点。\n
- \`expandAll()\` 展开所有节点。\n
- \`collapseAll()\` 折叠所有节点。\n
- \`index(treePath：Array): QModelIndex\` 由节点路径(形如[0,0,1...])创建模型索引。\n
- \`appendNode(parentIndex: QModelIndex)\` 添加节点到 \`parentIndex\` 下。\n
- \`removeNode(index: QModelIndex)\` 删除 \`index\` 所在的节点。\n
- \`moveNode(fromIndex: QModelIndex, toIndex: QModelIndex)\` 将 \`fromIndex\` 节点移动到 \`toIndex\` 位置。\n
- \`setNodeData(index: QModelIndex, data: Object)\` 设置 \`index\` 处节点的数据为 \`data\`。\n
- \`getNodeData(index: QModelIndex): Object\` 获取 \`index\` 处节点的数据。\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
文件夹、组织架构、生物分类、国家地区等等，世间万物的大多数结构都是树形结构。\n
使用树控件可以完整展现其中的层级关系，并具有展开收起选择等交互功能。\n
                       `)
        }

        ThemeToken {
            source: 'HusTreeView'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusTreeView.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('基本')
            desc: qsTr(`
最简单的用法，展示可勾选，可选中，禁用，默认勾选，展开折叠等功能。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusRadioBlock {
                        id: checkableRadio
                        initCheckedIndex: 0
                        model: [
                            { label: 'Checkable' },
                            { label: 'NotCheckable' },
                        ]
                    }

                    Row {
                        spacing: 10

                        HusButton {
                            type: HusButton.Type_Primary
                            text: 'Expand for keys'
                            onClicked: {
                                treeView.expandForKeys(['0-0', '0-1']);
                            }
                        }

                        HusButton {
                            type: HusButton.Type_Primary
                            text: 'Collapse all'
                            onClicked: {
                                treeView.collapseAll();
                            }
                        }
                    }

                    HusTreeView {
                        id: treeView
                        checkable: checkableRadio.currentCheckedIndex === 0
                        selectedKey: '0-1'
                        defaultCheckedKeys: ['0-0', '0-1']
                        Component.onCompleted: expandForKeys(['0-0', '0-1']);
                        initModel: [
                            {
                                title: 'parent 0',
                                key: '0',
                                children: [
                                    {
                                        title: 'parent 0-0',
                                        key: '0-0',
                                        enabled: false,
                                        children: [
                                            {
                                                title: 'leaf',
                                                key: '0-0-0',
                                                checkboxDisabled: true,
                                            },
                                            {
                                                title: 'leaf',
                                                key: '0-0-1',
                                            },
                                        ],
                                    },
                                    {
                                        title: 'parent 0-1',
                                        key: '0-1',
                                        children: [
                                            {
                                                title: 'sss',
                                                key: '0-1-0',
                                                delegateUrl: 'HusRate.qml'
                                            },
                                            {
                                                title: 'leaf',
                                                key: '0-1-1',
                                            },
                                        ],
                                    },
                                    {
                                        title: 'leaf',
                                        key: '0-2',
                                    },
                                ],
                            },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusRadioBlock {
                    id: checkableRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Checkable' },
                        { label: 'NotCheckable' },
                    ]
                }

                Row {
                    spacing: 10

                    HusButton {
                        type: HusButton.Type_Primary
                        text: 'Expand for keys'
                        onClicked: {
                            treeView.expandForKeys(['0-0', '0-1']);
                        }
                    }

                    HusButton {
                        type: HusButton.Type_Primary
                        text: 'Collapse all'
                        onClicked: {
                            treeView.collapseAll();
                        }
                    }
                }

                HusTreeView {
                    id: treeView
                    checkable: checkableRadio.currentCheckedIndex === 0
                    selectedKey: '0-1'
                    defaultCheckedKeys: ['0-0', '0-1']
                    Component.onCompleted: expandForKeys(['0-0', '0-1']);
                    initModel: [
                        {
                            title: 'parent 0',
                            key: '0',
                            children: [
                                {
                                    title: 'parent 0-0',
                                    key: '0-0',
                                    enabled: false,
                                    children: [
                                        {
                                            title: 'leaf',
                                            key: '0-0-0',
                                            checkboxDisabled: true,
                                        },
                                        {
                                            title: 'leaf',
                                            key: '0-0-1',
                                        },
                                    ],
                                },
                                {
                                    title: 'parent 0-1',
                                    key: '0-1',
                                    children: [
                                        {
                                            title: 'sss',
                                            key: '0-1-0',
                                            delegateUrl: 'HusRate.qml'
                                        },
                                        {
                                            title: 'leaf',
                                            key: '0-1-1',
                                        },
                                    ],
                                },
                                {
                                    title: 'leaf',
                                    key: '0-2',
                                },
                            ],
                        },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('自定义图标')
            desc: qsTr(`
通过 \`showIcon\` 设置是否显示图标。\n
通过 \`model.iconSource\` 和 \`model.iconSize\` 设定图标。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusTreeView {
                        showIcon: true
                        Component.onCompleted: expandForKeys(['0-0-0']);
                        initModel: [
                            {
                                title: 'parent 0',
                                key: '0-0',
                                iconSource: HusIcon.SmileOutlined,
                                children: [
                                    {
                                        title: 'leaf',
                                        key: '0-0-0',
                                        iconSource: HusIcon.MehOutlined,
                                    },
                                    {
                                        title: 'leaf',
                                        key: '0-0-1',
                                        iconSource: HusIcon.FrownFilled,
                                    },
                                ],
                            },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTreeView {
                    showIcon: true
                    Component.onCompleted: expandForKeys(['0-0-0']);
                    initModel: [
                        {
                            title: 'parent 0',
                            key: '0-0',
                            iconSource: HusIcon.SmileOutlined,
                            children: [
                                {
                                    title: 'leaf',
                                    key: '0-0-0',
                                    iconSource: HusIcon.MehOutlined,
                                },
                                {
                                    title: 'leaf',
                                    key: '0-0-1',
                                    iconSource: HusIcon.FrownFilled,
                                },
                            ],
                        },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('自定义展开/折叠图标')
            desc: qsTr(`
通过 \`switcherIconSouce\` 设置展开/折叠图标。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusTreeView {
                        showLine: true
                        switcherIconSouce: HusIcon.DownOutlined
                        Component.onCompleted: expandForKeys(['0-0-0']);
                        initModel: [
                            {
                                title: 'parent 1',
                                key: '0-0',
                                children: [
                                    {
                                        title: 'parent 1-0',
                                        key: '0-0-0',
                                        children: [
                                            {
                                                title: 'leaf',
                                                key: '0-0-0-0',
                                            },
                                            {
                                                title: 'leaf',
                                                key: '0-0-0-1',
                                            },
                                            {
                                                title: 'leaf',
                                                key: '0-0-0-2',
                                            },
                                        ],
                                    },
                                    {
                                        title: 'parent 1-1',
                                        key: '0-0-1',
                                        children: [
                                            {
                                                title: 'leaf',
                                                key: '0-0-1-0',
                                            },
                                        ],
                                    },
                                    {
                                        title: 'parent 1-2',
                                        key: '0-0-2',
                                        children: [
                                            {
                                                title: 'leaf',
                                                key: '0-0-2-0',
                                            },
                                            {
                                                title: 'leaf',
                                                key: '0-0-2-1',
                                            },
                                        ],
                                    },
                                ],
                            },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTreeView {
                    showLine: true
                    switcherIconSouce: HusIcon.RightOutlined
                    Component.onCompleted: expandForKeys(['0-0-0']);
                    initModel: [
                        {
                            title: 'parent 1',
                            key: '0-0',
                            children: [
                                {
                                    title: 'parent 1-0',
                                    key: '0-0-0',
                                    children: [
                                        {
                                            title: 'leaf',
                                            key: '0-0-0-0',
                                        },
                                        {
                                            title: 'leaf',
                                            key: '0-0-0-1',
                                        },
                                        {
                                            title: 'leaf',
                                            key: '0-0-0-2',
                                        },
                                    ],
                                },
                                {
                                    title: 'parent 1-1',
                                    key: '0-0-1',
                                    children: [
                                        {
                                            title: 'leaf',
                                            key: '0-0-1-0',
                                        },
                                    ],
                                },
                                {
                                    title: 'parent 1-2',
                                    key: '0-0-2',
                                    children: [
                                        {
                                            title: 'leaf',
                                            key: '0-0-2-0',
                                        },
                                        {
                                            title: 'leaf',
                                            key: '0-0-2-1',
                                        },
                                    ],
                                },
                            ],
                        },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('连接线')
            desc: qsTr(`
通过 \`showLine\` 设置是否显示连接线。\n
通过 \`lineStyle\` 设置连接线样式。\n
通过 \`lineWidth\` 设置连接线宽度。\n
通过 \`dashPattern\` 设置虚线模式(style == HusTreeView.DashLine 时有效)。\n
通过 \`switcherDelegate\` 自定义切换器(展开/折叠按钮)代理。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusSwitch {
                        id: showIconSwitch
                        text: 'showIcon: '
                        checked: false
                    }

                    HusSwitch {
                        id: showLineSwitch
                        text: 'showLine: '
                        checked: true
                    }

                    HusRadioBlock {
                        id: lineStyleRadio
                        initCheckedIndex: 0
                        model: [
                            { label: 'SolidLine', value: HusTreeView.SolidLine },
                            { label: 'DashLine', value: HusTreeView.DashLine },
                        ]
                    }

                    HusColorPicker {
                        id: lineColorPicker
                        defaultValue: '#80888888'
                    }

                    HusTreeView {
                        id: showLineTreeView
                        checkable: false
                        showIcon: showIconSwitch.checked
                        showLine: showLineSwitch.checked
                        lineStyle: lineStyleRadio.currentCheckedValue
                        colorLine: lineColorPicker.value
                        switcherDelegate: HusIconButton {
                            padding: 0
                            leftPadding: 0
                            rightPadding: 0
                            colorBorder: 'transparent'
                            iconSource: isExpanded ? HusIcon.MinusSquareOutlined : HusIcon.PlusSquareOutlined
                            onClicked: {
                                showLineTreeView.treeView.toggleExpanded(row);
                            }
                        }
                        Component.onCompleted: expandForKeys(['0-0-0']);
                        initModel: [
                           {
                               title: 'parent 1',
                               key: '0-0',
                               iconSource: HusIcon.CarryOutOutlined,
                               children: [
                                   {
                                       title: 'parent 1-0',
                                       key: '0-0-0',
                                       iconSource: HusIcon.CarryOutOutlined,
                                       children: [
                                           { title: 'leaf', key: '0-0-0-0', iconSource: HusIcon.CarryOutOutlined },
                                           {
                                               title: 'multiple line title\nmultiple line title',
                                               key: '0-0-0-1',
                                               iconSource: HusIcon.CarryOutOutlined,
                                           },
                                           { title: 'leaf', key: '0-0-0-2', iconSource: HusIcon.CarryOutOutlined },
                                       ],
                                   },
                                   {
                                       title: 'parent 1-1',
                                       key: '0-0-1',
                                       iconSource: HusIcon.CarryOutOutlined,
                                       children: [{ title: 'leaf', key: '0-0-1-0', iconSource: HusIcon.CarryOutOutlined }],
                                   },
                                   {
                                       title: 'parent 1-2',
                                       key: '0-0-2',
                                       iconSource: HusIcon.CarryOutOutlined,
                                       children: [
                                           { title: 'leaf', key: '0-0-2-0', iconSource: HusIcon.CarryOutOutlined },
                                           {
                                               title: 'leaf',
                                               key: '0-0-2-1',
                                               iconSource: HusIcon.CarryOutOutlined,
                                           },
                                       ],
                                   },
                               ],
                           },
                           {
                               title: 'parent 2',
                               key: '0-1',
                               iconSource: HusIcon.CarryOutOutlined,
                               children: [
                                   {
                                       title: 'parent 2-0',
                                       key: '0-1-0',
                                       iconSource: HusIcon.CarryOutOutlined,
                                       children: [
                                           { title: 'leaf', key: '0-1-0-0', iconSource: HusIcon.CarryOutOutlined },
                                           { title: 'leaf', key: '0-1-0-1', iconSource: HusIcon.CarryOutOutlined },
                                       ],
                                   },
                               ],
                           },
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSwitch {
                    id: showIconSwitch
                    text: 'showIcon: '
                    checked: false
                }

                HusSwitch {
                    id: showLineSwitch
                    text: 'showLine: '
                    checked: true
                }

                HusRadioBlock {
                    id: lineStyleRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'SolidLine', value: HusTreeView.SolidLine },
                        { label: 'DashLine', value: HusTreeView.DashLine },
                    ]
                }

                HusColorPicker {
                    id: lineColorPicker
                    defaultValue: '#80888888'
                }

                HusTreeView {
                    id: showLineTreeView
                    checkable: false
                    showIcon: showIconSwitch.checked
                    showLine: showLineSwitch.checked
                    lineStyle: lineStyleRadio.currentCheckedValue
                    colorLine: lineColorPicker.value
                    switcherDelegate: HusIconButton {
                        padding: 0
                        leftPadding: 0
                        rightPadding: 0
                        colorBorder: 'transparent'
                        iconSource: isExpanded ? HusIcon.MinusSquareOutlined : HusIcon.PlusSquareOutlined
                        onClicked: {
                            showLineTreeView.treeView.toggleExpanded(row);
                        }
                    }
                    Component.onCompleted: expandForKeys(['0-0-0']);
                    initModel: [
                       {
                           title: 'parent 1',
                           key: '0-0',
                           iconSource: HusIcon.CarryOutOutlined,
                           children: [
                               {
                                   title: 'parent 1-0',
                                   key: '0-0-0',
                                   iconSource: HusIcon.CarryOutOutlined,
                                   children: [
                                       { title: 'leaf', key: '0-0-0-0', iconSource: HusIcon.CarryOutOutlined },
                                       {
                                           title: 'multiple line title\nmultiple line title',
                                           key: '0-0-0-1',
                                           iconSource: HusIcon.CarryOutOutlined,
                                       },
                                       { title: 'leaf', key: '0-0-0-2', iconSource: HusIcon.CarryOutOutlined },
                                   ],
                               },
                               {
                                   title: 'parent 1-1',
                                   key: '0-0-1',
                                   iconSource: HusIcon.CarryOutOutlined,
                                   children: [{ title: 'leaf', key: '0-0-1-0', iconSource: HusIcon.CarryOutOutlined }],
                               },
                               {
                                   title: 'parent 1-2',
                                   key: '0-0-2',
                                   iconSource: HusIcon.CarryOutOutlined,
                                   children: [
                                       { title: 'leaf', key: '0-0-2-0', iconSource: HusIcon.CarryOutOutlined },
                                       {
                                           title: 'leaf',
                                           key: '0-0-2-1',
                                           iconSource: HusIcon.CarryOutOutlined,
                                       },
                                   ],
                               },
                           ],
                       },
                       {
                           title: 'parent 2',
                           key: '0-1',
                           iconSource: HusIcon.CarryOutOutlined,
                           children: [
                               {
                                   title: 'parent 2-0',
                                   key: '0-1-0',
                                   iconSource: HusIcon.CarryOutOutlined,
                                   children: [
                                       { title: 'leaf', key: '0-1-0-0', iconSource: HusIcon.CarryOutOutlined },
                                       { title: 'leaf', key: '0-1-0-1', iconSource: HusIcon.CarryOutOutlined },
                                   ],
                               },
                           ],
                       },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            async: false
            descTitle: qsTr('填充整行')
            desc: qsTr(`
通过 \`blockNode\` 设置节点内容是否填充整行。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    Rectangle {
                        width: 400
                        height: 100
                        color: HusTheme.Primary.colorBgBase
                        border.color: HusTheme.Primary.colorFillPrimary
                        border.width: 2

                        HusTreeView {
                            anchors.fill: parent
                            checkable: true
                            blockNode: true
                            Component.onCompleted: expandForKeys(['0-0-0']);
                            initModel: [
                                {
                                    title: 'parent 0',
                                    key: '0-0',
                                    children: [
                                        {
                                            title: 'leaf',
                                            key: '0-0-0',
                                        },
                                        {
                                            title: 'leaf',
                                            key: '0-0-1',
                                        },
                                    ],
                                },
                            ]
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Rectangle {
                    width: 400
                    height: 100
                    color: HusTheme.Primary.colorBgBase
                    border.color: HusTheme.Primary.colorFillPrimary
                    border.width: 2

                    HusTreeView {
                        anchors.fill: parent
                        checkable: true
                        blockNode: true
                        Component.onCompleted: expandForKeys(['0-0-0']);
                        initModel: [
                            {
                                title: 'parent 0',
                                key: '0-0',
                                children: [
                                    {
                                        title: 'leaf',
                                        key: '0-0-0',
                                    },
                                    {
                                        title: 'leaf',
                                        key: '0-0-1',
                                    },
                                ],
                            },
                        ]
                    }
                }
            }
        }
    }
}

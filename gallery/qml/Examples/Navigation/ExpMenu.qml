import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Component {
        id: myContentDelegate

        Item {
            Text {
                id: __text
                anchors.left: parent.left
                anchors.right: __tag.left
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                text: menuButton.text
                font: menuButton.font
                color: menuButton.colorText
                elide: Text.ElideRight
            }

            DelTag {
                id: __tag
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: 'Success'
                tagState: DelTag.State_Success
            }
        }
    }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelMenu 菜单\n
为页面和功能提供导航的菜单列表。\n
* **继承自 { Item }**\n
支持的代理：\n
- **menuIconDelegate: Component** 菜单图标代理，代理可访问属性：\n
  - \`model: var\` 本菜单数据(访问错误则使用 \`parent.model\`)\n
  - \`menuButton: var\` 菜单按钮(访问错误则使用 \`parent.menuButton\`)\n
- **menuLabelDelegate: Component** 菜单标签代理，代理可访问属性：\n
  - \`model: var\` 本菜单数据(访问错误则使用 \`parent.model\`)\n
  - \`menuButton: var\` 菜单按钮(访问错误则使用 \`parent.menuButton\`)\n
- **menuBackgroundDelegate: Component** 菜单背景代理，代理可访问属性：\n
  - \`model: var\` 本菜单数据(访问错误则使用 \`parent.model\`)\n
  - \`menuButton: var\` 菜单按钮(访问错误则使用 \`parent.menuButton\`)\n
- **menuContentDelegate: Component** 菜单内容代理，代理可访问属性：\n
  - \`model: var\` 本菜单数据(访问错误则使用 \`parent.model\`)\n
  - \`menuButton: var\` 菜单按钮(访问错误则使用 \`parent.menuButton\`)\n
支持的属性：\n
属性名 | 类型 | 默认值 | 描述 |
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画
contentDescription | string | '' | 内容描述(提高可用性)
showEdge | bool | false | 是否显示边线
tooltipVisible | bool | false | 是否显示工具提示
compactMode | bool | false | 是否为紧凑模式
compactWidth | int | 50 | 紧凑模式宽度
popupMode | bool | false | 是否为弹出模式
popupWidth | int | 200 | 弹窗宽度
popupOffset | int | 4 | 弹窗之间的偏移
popupMaxHeight | int | - | 弹窗最大高度
defaultMenuIconSize | int | - | 默认菜单图标大小
defaultMenuIconSpacing | int | 8 | 默认菜单图标间隔
defaultMenuWidth | int | 300 | 默认菜单宽度
defaultMenuHieght | int | 40 | 默认菜单高度
defaultMenuSpacing | int | 4 | 默认菜单间隔
defaultSelectedKey | list | [] | 初始选中的菜单项 key 数组
initModel | list | [] | 初始菜单模型
\n模型支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
key | string | 菜单键(最好唯一)
label | sting | 菜单标签
type | sting | 菜单项类型
height | int | 本菜单项高度
enabled | bool | 是否启用(false则禁用本菜单项)
iconSize | int | 图标大小
iconSource | int | 图标源
iconSpacing | int | 图标间隔
menuChildren | list | 子菜单(支持无限嵌套)
iconDelegate | var | 本菜单项图标代理(menuIconDelegate)
labelDelegate | var | 本菜单项标签代理(menuLabelDelegate)
contentDelegate | var | 本菜单项内容代理(将覆盖menuContentDelegate)
backgroundDelegate | var | 本菜单项背景代理(menuBackgroundDelegate)
\n \`contentDelegate\` 可访问属性：\n
- **model: var** 模型数据(访问错误则使用 \`parent.model\`)\n
- **menuButton: DelButton** 自身菜单按钮(访问错误则使用 \`parent.menuButton\`)，可访问的属性：\n
  - model: var 本菜单模型\n
  - iconSource: int 图标源\n
  - iconSize: int 图标大小\n
  - iconSpacing: int 图标间隔\n
  - iconStart: int 图标起始坐标\n
  - expanded: int 是否展开\n
  - isCurrent: int 是否为当前选择菜单\n
  - isGroup: int 是否为组菜单\n
\n支持的函数：\n
- \`gotoMenu(key: string)\` 跳转到菜单键为 \`key\` 处的菜单项 \n
- \`Object get(index: int)\` 获取 \`index\` 处的模型数据 \n
- \`set(index: int, object: Object)\` 设置 \`index\` 处的模型数据为 \`object\` \n
- \`setProperty(index: int, propertyName: string, value: any)\` 设置 \`index\` 处的模型数据属性名 \`propertyName\` 值为 \`value\` \n
- \`move(from: int, to: int, count: int = 1)\` 将 \`count\` 个模型数据从 \`from\` 位置移动到 \`to\` 位置 \n
- \`insert(index: int, object: Object)\` 插入菜单 \`object\` 到 \`index\` 处 \n
- \`append(object: Object)\` 在末尾添加菜单 \`object\` \n
- \`remove(index: int, count: int = 1)\` 删除 \`index\` 处 \`count\` 个模型数据 \n
- \`clear()\` 清空所有模型数据 \n
\n支持的信号：\n
- \`clickMenu(deep: int, menuKey: string, menuData: Object)\` 点击任意菜单项时发出\n
  - \`deep\` 菜单项深度\n
  - \`menuKey\` 菜单项的键\n
  - \`menuData\` 菜单项数据\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
菜单是一个应用的灵魂，用户依赖导航在各个页面中进行跳转。\n
一般分为顶部导航和侧边导航。\n
- 顶部导航提供全局性的类目和功能。\n
- 侧边导航提供多级结构来收纳和排列网站架构。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("基本用法")
            desc: qsTr(`
通过 \`initModel\` 属性设置初始菜单模型{需为list}，菜单项支持的属性有：\n
- { key: 菜单键(最好唯一) }\n
- { label: 标题 }\n
- { type: 类型 }\n
- { height: 本菜单项高度 }\n
- { enabled: 是否启用(false则禁用该菜单项) }\n
- { iconSize: 图标大小 }\n
- { iconSource: 图标源 }\n
- { iconSpacing: 图标间隔 }\n
- { menuChildren: 子菜单(支持无限嵌套) }\n
- { contentDelegate: 该菜单项内容代理 }\n
菜单项 \`type\` 支持：\n
- "item" { 普通菜单项(默认) }\n
- "group" { 组菜单项 }\n
- "divider" { 此菜单项为分隔器 }\n
点击任意菜单项将发出 \`clickMenu(deep, menuKey, menuData)\` 信号。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Item {
                    width: parent.width
                    height: 200

                    DelButton {
                        text: qsTr("添加")
                        anchors.right: parent.right
                        onClicked: menu.append({
                                                    label: qsTr("Test"),
                                                    iconSource: DelIcon.HomeOutlined,
                                                    contentDelegate: myContentDelegate
                                               });
                    }

                    DelMenu {
                        id: menu
                        height: parent.height
                        initModel: [
                            {
                                label: qsTr("首页1"),
                                iconSource: DelIcon.HomeOutlined
                            },
                            {
                                label: qsTr("首页2"),
                                iconSource: DelIcon.HomeOutlined,
                                menuChildren: [
                                    {
                                        label: qsTr("首页2-1"),
                                        iconSource: DelIcon.HomeOutlined,
                                        menuChildren: [
                                            {
                                                label: qsTr("首页2-1-1"),
                                                iconSource: DelIcon.HomeOutlined,
                                                contentDelegate: myContentDelegate
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                label: qsTr("首页3"),
                                iconSource: DelIcon.HomeOutlined,
                                enabled: false
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Item {
                height: 200

                DelButton {
                    text: qsTr("添加")
                    anchors.right: parent.right
                    onClicked: menu.append({
                                                label: qsTr("Test"),
                                                iconSource: DelIcon.HomeOutlined,
                                                contentDelegate: myContentDelegate
                                           });
                }

                DelMenu {
                    id: menu
                    height: parent.height
                    initModel: [
                        {
                            label: qsTr("首页1"),
                            iconSource: DelIcon.HomeOutlined
                        },
                        {
                            label: qsTr("首页2"),
                            iconSource: DelIcon.HomeOutlined,
                            menuChildren: [
                                {
                                    label: qsTr("首页2-1"),
                                    iconSource: DelIcon.HomeOutlined,
                                    menuChildren: [
                                        {
                                            label: qsTr("首页2-1-1"),
                                            iconSource: DelIcon.HomeOutlined,
                                            contentDelegate: myContentDelegate
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            label: qsTr("首页3"),
                            iconSource: DelIcon.HomeOutlined,
                            enabled: false
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("弹出形式")
            desc: qsTr(`
通过 \`popupMode\` 属性设置菜单为弹出模式 \n
通过 \`popupWidth\` 属性设置弹窗的宽度 \n
通过 \`popupMaxHeight\` 属性设置弹窗的最大高度(最小高度是自动计算的) \n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelRadioBlock {
                        id: popupModeRadio
                        initCheckedIndex: 0
                        model: [
                            { label: qsTr("默认模式"), value: false },
                            { label: qsTr("弹出模式"), value: true }
                        ]
                    }

                    DelMenu {
                        height: 250
                        popupMode: popupModeRadio.currentCheckedValue
                        popupWidth: 150
                        initModel: [
                            {
                                label: qsTr("首页1"),
                                iconSource: DelIcon.HomeOutlined
                            },
                            {
                                label: qsTr("首页2"),
                                iconSource: DelIcon.HomeOutlined,
                                menuChildren: [
                                    {
                                        label: qsTr("首页2-1"),
                                        iconSource: DelIcon.HomeOutlined,
                                        menuChildren: [
                                            {
                                                label: qsTr("首页2-1-1"),
                                                iconSource: DelIcon.HomeOutlined
                                            }
                                        ]
                                    },
                                    {
                                        label: qsTr("首页2-2"),
                                        iconSource: DelIcon.HomeOutlined,
                                        menuChildren: [
                                            {
                                                label: qsTr("首页2-2-1"),
                                                iconSource: DelIcon.HomeOutlined
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                label: qsTr("首页3"),
                                iconSource: DelIcon.HomeOutlined,
                                menuChildren: [
                                    {
                                        label: qsTr("首页3-1"),
                                        iconSource: DelIcon.HomeOutlined,
                                        menuChildren: [
                                            {
                                                label: qsTr("首页3-1-1"),
                                                iconSource: DelIcon.HomeOutlined
                                            }
                                        ]
                                    }
                                ]
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelRadioBlock {
                    id: popupModeRadio
                    initCheckedIndex: 0
                    model: [
                        { label: qsTr("默认模式"), value: false },
                        { label: qsTr("弹出模式"), value: true }
                    ]
                }

                DelMenu {
                    height: 250
                    popupMode: popupModeRadio.currentCheckedValue
                    popupWidth: 150
                    initModel: [
                        {
                            label: qsTr("首页1"),
                            iconSource: DelIcon.HomeOutlined
                        },
                        {
                            label: qsTr("首页2"),
                            iconSource: DelIcon.HomeOutlined,
                            menuChildren: [
                                {
                                    label: qsTr("首页2-1"),
                                    iconSource: DelIcon.HomeOutlined,
                                    menuChildren: [
                                        {
                                            label: qsTr("首页2-1-1"),
                                            iconSource: DelIcon.HomeOutlined,
                                            contentDelegate: myContentDelegate
                                        }
                                    ]
                                },
                                {
                                    label: qsTr("首页2-2"),
                                    iconSource: DelIcon.HomeOutlined,
                                    menuChildren: [
                                        {
                                            label: qsTr("首页2-2-1"),
                                            iconSource: DelIcon.HomeOutlined
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            label: qsTr("首页3"),
                            iconSource: DelIcon.HomeOutlined,
                            menuChildren: [
                                {
                                    label: qsTr("首页3-1"),
                                    iconSource: DelIcon.HomeOutlined,
                                    menuChildren: [
                                        {
                                            label: qsTr("首页3-1-1"),
                                            iconSource: DelIcon.HomeOutlined
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("紧凑模式")
            desc: qsTr(`
通过 \`compactMode\` 属性设置菜单是否为紧凑模式 \n
通过 \`compactWidth\` 属性设置紧凑模式的宽度 \n
通过 \`popupWidth\` 属性设置弹窗的宽度 \n
通过 \`popupMaxHeight\` 属性设置弹窗的最大高度(最小高度是自动计算的) \n
**注意** 设置为紧凑模式则不需要设置弹出模式 \n
**注意** 使用 \`defaultMenuWidth\` 来设置宽度 \n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelRadioBlock {
                        id: compactModeRadio
                        initCheckedIndex: 0
                        model: [
                            { label: qsTr("默认模式"), value: false },
                            { label: qsTr("紧凑模式"), value: true }
                        ]
                    }

                    DelMenu {
                        height: 250
                        compactMode: compactModeRadio.currentCheckedValue
                        popupWidth: 150
                        initModel: [
                            {
                                label: qsTr("首页1"),
                                iconSource: DelIcon.HomeOutlined
                            },
                            {
                                label: qsTr("首页2"),
                                iconSource: DelIcon.HomeOutlined,
                                menuChildren: [
                                    {
                                        label: qsTr("首页2-1"),
                                        iconSource: DelIcon.HomeOutlined,
                                        menuChildren: [
                                            {
                                                label: qsTr("首页2-1-1"),
                                                iconSource: DelIcon.HomeOutlined
                                            }
                                        ]
                                    },
                                    {
                                        label: qsTr("首页2-2"),
                                        iconSource: DelIcon.HomeOutlined,
                                        menuChildren: [
                                            {
                                                label: qsTr("首页2-2-1"),
                                                iconSource: DelIcon.HomeOutlined
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                label: qsTr("首页3"),
                                iconSource: DelIcon.HomeOutlined,
                                menuChildren: [
                                    {
                                        label: qsTr("首页3-1"),
                                        iconSource: DelIcon.HomeOutlined,
                                        menuChildren: [
                                            {
                                                label: qsTr("首页3-1-1"),
                                                iconSource: DelIcon.HomeOutlined
                                            }
                                        ]
                                    }
                                ]
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelRadioBlock {
                    id: compactModeRadio
                    initCheckedIndex: 0
                    model: [
                        { label: qsTr("默认模式"), value: false },
                        { label: qsTr("紧凑模式"), value: true }
                    ]
                }

                DelMenu {
                    height: 250
                    compactMode: compactModeRadio.currentCheckedValue
                    popupWidth: 150
                    initModel: [
                        {
                            label: qsTr("首页1"),
                            iconSource: DelIcon.HomeOutlined
                        },
                        {
                            label: qsTr("首页2"),
                            iconSource: DelIcon.HomeOutlined,
                            menuChildren: [
                                {
                                    label: qsTr("首页2-1"),
                                    iconSource: DelIcon.HomeOutlined,
                                    menuChildren: [
                                        {
                                            label: qsTr("首页2-1-1"),
                                            iconSource: DelIcon.HomeOutlined
                                        }
                                    ]
                                },
                                {
                                    label: qsTr("首页2-2"),
                                    iconSource: DelIcon.HomeOutlined,
                                    menuChildren: [
                                        {
                                            label: qsTr("首页2-2-1"),
                                            iconSource: DelIcon.HomeOutlined
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            label: qsTr("首页3"),
                            iconSource: DelIcon.HomeOutlined,
                            menuChildren: [
                                {
                                    label: qsTr("首页3-1"),
                                    iconSource: DelIcon.HomeOutlined,
                                    menuChildren: [
                                        {
                                            label: qsTr("首页3-1-1"),
                                            iconSource: DelIcon.HomeOutlined
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            }
        }
    }
}

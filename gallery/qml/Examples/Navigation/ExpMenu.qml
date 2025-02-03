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
## DelMenu 菜单\n
为页面和功能提供导航的菜单列表。\n
* **继承自 { Item }**\n
支持的代理：\n
- **menuDelegate: Component** 菜单项代理，代理可访问属性：\n
  - \`index: int\` 菜单项索引\n
  - \`model: var\` 菜单项数据\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
contentDescription | string | 内容描述(提高可用性)
defaultIconSize | int | 默认图标大小
defaultIconSpacing | int | 默认图标间隔
defaultHieght | int | 默认高度
defaultSpacing | int | 默认间隔
defaultSelectedKey | list | 初始选中的菜单项 key 数组
model | list | 菜单模型
\n支持的函数：\n
- \`gotoMenu(key: string)\` 跳转到菜单键为 \`key\` 处的菜单项 \n
- \`Object get(index: int)\` 获取 \`index\` 处的模型数据 \n
- \`set(index: int, object: Object)\` 设置 \`index\` 处的模型数据为 \`object\` \n
- \`setProperty(index: int, propertyName: string, value: any)\` 设置 \`index\` 处的模型数据属性名 \`propertyName\` 值为 \`value\` \n
- \`move(from: int, to: int, count: int = 1)\` 将 \`count\` 个模型数据从 \`from\` 位置移动到 \`to\` 位置 \n
- \`insert(index: int, object: Object)\` 插入标签 \`object\` 到 \`index\` 处 \n
- \`append(object: Object)\` 在末尾添加标签 \`object\` \n
- \`removeAt(index: int, count: int = 1)\` 删除 \`index\` 处 \`count\` 个模型数据 \n
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
            desc: qsTr(`
通过 \`initModel\` 属性设置初始菜单模型{需为list}，菜单项支持的属性有：\n
- { key: 菜单键(最好唯一) }\n
- { title: 标题 }\n
- { height: 本菜单项高度 }\n
- { enabled: 是否启用(false则禁用该菜单项) }\n
- { iconSize: 图标大小 }\n
- { iconSource: 图标源 }\n
- { iconSpacing: 图标间隔 }\n
- { menuChildren: 子菜单(支持无限嵌套) }\n
点击任意菜单项将发出 \`clickMenu(deep, menuKey, menuData)\` 信号。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Item {
                    width: parent.width
                    height: 300

                    DelButton {
                        text: qsTr("添加")
                        anchors.right: parent.right
                        onClicked: menu.append({
                                                   title: qsTr("Test"),
                                                   iconSource: DelIcon.HomeOutlined
                                               });
                    }

                    DelMenu {
                        id: menu
                        width: 300
                        height: 300
                        initModel: [
                            {
                                title: qsTr("首页1"),
                                iconSource: DelIcon.HomeOutlined
                            },
                            {
                                title: qsTr("首页2"),
                                iconSource: DelIcon.HomeOutlined,
                                menuChildren: [
                                    {
                                        title: qsTr("首页2-1"),
                                        iconSource: DelIcon.HomeOutlined,
                                        menuChildren: [
                                            {
                                                title: qsTr("首页2-1-1"),
                                                iconSource: DelIcon.HomeOutlined
                                            }
                                        ]
                                    }
                                ]
                            },
                            {
                                title: qsTr("首页3"),
                                iconSource: DelIcon.HomeOutlined,
                                enabled: false
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Item {
                height: 300

                DelButton {
                    text: qsTr("添加")
                    anchors.right: parent.right
                    onClicked: menu.append({
                                               title: qsTr("Test"),
                                               iconSource: DelIcon.HomeOutlined
                                           });
                }

                DelMenu {
                    id: menu
                    width: 300
                    height: 300
                    initModel: [
                        {
                            title: qsTr("首页1"),
                            iconSource: DelIcon.HomeOutlined
                        },
                        {
                            title: qsTr("首页2"),
                            iconSource: DelIcon.HomeOutlined,
                            menuChildren: [
                                {
                                    title: qsTr("首页2-1"),
                                    iconSource: DelIcon.HomeOutlined,
                                    menuChildren: [
                                        {
                                            title: qsTr("首页2-1-1"),
                                            iconSource: DelIcon.HomeOutlined
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            title: qsTr("首页3"),
                            iconSource: DelIcon.HomeOutlined,
                            enabled: false
                        }
                    ]
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width
        spacing: 30

        Description {
            desc: qsTr(`
## DelMenu 菜单\n
为页面和功能提供导航的菜单列表。\n
* **继承自 { Item }**\n
支持的代理：\n
- **menuDelegate: Component** 菜单项代理\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
contentDescription | string | 内容描述(提高可用性)
defaultIconSize | int | 默认图标大小
defaultIconSpacing | int | 默认图标间隔
defaultHieght | int | 默认高度
defaultSpacing | int | 默认间隔
model | list | 菜单模型
\n支持的信号：\n
- \`clickMenu(deep: int, menuData: Object)\` 点击任意菜单项时发出\n
  - \`deep\` 菜单项深度\n
  - \`menuData\` 菜单项数据\n
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
通过 \`model\` 属性设置菜单模型{需为list}，菜单项支持的属性有：\n
- { title: 标题 }\n
- { height: 本菜单项高度 }\n
- { enabled: 是否启用(false则禁用该菜单项) }\n
- { iconSize: 图标大小 }\n
- { iconSource: 图标源 }\n
- { iconSpacing: 图标间隔 }\n
- { menuChildren: 子菜单(支持无限嵌套) }\n
点击任意菜单项将发出 \`clickMenu(deep, menuData)\` 信号。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Item {
                    height: 300

                    DelMenu {
                        width: 300
                        height: 300
                        model: [
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

                DelMenu {
                    width: 300
                    height: 300
                    model: [
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

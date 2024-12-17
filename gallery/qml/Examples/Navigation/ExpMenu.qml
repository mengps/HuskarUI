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
支持的属性：\n
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

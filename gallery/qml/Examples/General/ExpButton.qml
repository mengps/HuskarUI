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
通过 \`type\` 属性改变按钮类型，支持的类型：\n
- 默认按钮{ DelButtonType.Type_Default }\n
- 线框按钮{ DelButtonType.Type_Outlined }\n
- 主要按钮{ DelButtonType.Type_Primary }\n
- 填充按钮{ DelButtonType.Type_Filled }\n
- 文本按钮{ DelButtonType.Type_Text }。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelButton {
                        text: qsTr("默认")
                    }

                    DelButton {
                        text: qsTr("线框")
                        type: DelButtonType.Type_Outlined
                    }

                    DelButton {
                        text: qsTr("主要")
                        type: DelButtonType.Type_Primary
                    }

                    DelButton {
                        text: qsTr("填充")
                        type: DelButtonType.Type_Filled
                    }

                    DelButton {
                        text: qsTr("文本")
                        type: DelButtonType.Type_Text
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelButton {
                    text: qsTr("默认")
                }

                DelButton {
                    text: qsTr("线框")
                    type: DelButtonType.Type_Outlined
                }

                DelButton {
                    text: qsTr("主要")
                    type: DelButtonType.Type_Primary
                }

                DelButton {
                    text: qsTr("填充")
                    type: DelButtonType.Type_Filled
                }

                DelButton {
                    text: qsTr("文本")
                    type: DelButtonType.Type_Text
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`enabled\` 属性启用或禁用按钮，禁用的按钮不会响应任何交互。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelButton {
                        text: qsTr("默认")
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("线框")
                        type: DelButtonType.Type_Outlined
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("主要")
                        type: DelButtonType.Type_Primary
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("填充")
                        type: DelButtonType.Type_Filled
                        enabled: false
                    }

                    DelButton {
                        text: qsTr("文本")
                        type: DelButtonType.Type_Text
                        enabled: false
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelButton {
                    text: qsTr("默认")
                    enabled: false
                }

                DelButton {
                    text: qsTr("线框")
                    type: DelButtonType.Type_Outlined
                    enabled: false
                }

                DelButton {
                    text: qsTr("主要")
                    type: DelButtonType.Type_Primary
                    enabled: false
                }

                DelButton {
                    text: qsTr("填充")
                    type: DelButtonType.Type_Filled
                    enabled: false
                }

                DelButton {
                    text: qsTr("文本")
                    type: DelButtonType.Type_Text
                    enabled: false
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`shape\` 属性改变按钮形状，支持的形状：\n
- 默认形状{ DelButtonType.Shape_Default }\n
- 圆形{ DelButtonType.Shape_Circle }。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelButton {
                        text: qsTr("A")
                        shape: DelButtonType.Shape_Circle
                    }

                    DelButton {
                        text: qsTr("A")
                        type: DelButtonType.Type_Outlined
                        shape: DelButtonType.Shape_Circle
                    }

                    DelButton {
                        text: qsTr("A")
                        type: DelButtonType.Type_Primary
                        shape: DelButtonType.Shape_Circle
                    }

                    DelButton {
                        text: qsTr("A")
                        type: DelButtonType.Type_Filled
                        shape: DelButtonType.Shape_Circle
                    }

                    DelButton {
                        text: qsTr("A")
                        type: DelButtonType.Type_Text
                        shape: DelButtonType.Shape_Circle
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelButton {
                    text: qsTr("A")
                    shape: DelButtonType.Shape_Circle
                }

                DelButton {
                    text: qsTr("A")
                    type: DelButtonType.Type_Outlined
                    shape: DelButtonType.Shape_Circle
                }

                DelButton {
                    text: qsTr("A")
                    type: DelButtonType.Type_Primary
                    shape: DelButtonType.Shape_Circle
                }

                DelButton {
                    text: qsTr("A")
                    type: DelButtonType.Type_Filled
                    shape: DelButtonType.Shape_Circle
                }

                DelButton {
                    text: qsTr("A")
                    type: DelButtonType.Type_Text
                    shape: DelButtonType.Shape_Circle
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
**DelIconButton 带图标的按钮**\n
DelIconButton继承{ DelButton }中的属性\n
通过 \`iconSource\` 属性设置图标源{ DelIcon中定义 }\n
通过 \`iconSize\` 属性设置图标大小\n
通过 \`iconPosition\` 属性设置图标位置，支持的位置有：\n
- 图标处于开始位置(默认){ DelButtonType.Position_Start }\n
- 图标处于结束位置{ DelButtonType.Position_End }。。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    spacing: 15

                    DelIconButton {
                        text: qsTr("搜索")
                        iconSource: DelIcon.SearchOutlined
                    }

                    DelIconButton {
                        text: qsTr("搜索")
                        type: DelButtonType.Type_Outlined
                        iconSource: DelIcon.SearchOutlined
                    }

                    DelIconButton {
                        type: DelButtonType.Type_Primary
                        iconSource: DelIcon.SearchOutlined
                    }

                    DelIconButton {
                        text: qsTr("搜索")
                        type: DelButtonType.Type_Filled
                        iconSource: DelIcon.SearchOutlined
                    }

                    DelIconButton {
                        text: qsTr("搜索")
                        type: DelButtonType.Type_Text
                        iconSource: DelIcon.SearchOutlined
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 15

                DelIconButton {
                    text: qsTr("搜索")
                    iconSource: DelIcon.SearchOutlined
                }

                DelIconButton {
                    text: qsTr("搜索")
                    type: DelButtonType.Type_Outlined
                    iconSource: DelIcon.SearchOutlined
                }

                DelIconButton {
                    type: DelButtonType.Type_Primary
                    iconSource: DelIcon.SearchOutlined
                }

                DelIconButton {
                    text: qsTr("搜索")
                    type: DelButtonType.Type_Filled
                    iconSource: DelIcon.SearchOutlined
                }

                DelIconButton {
                    text: qsTr("搜索")
                    type: DelButtonType.Type_Text
                    iconSource: DelIcon.SearchOutlined
                }
            }
        }
    }
}

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
通过 \`title\` 属性改变标题文字\n
通过 \`titleAlign\` 属性改变标题对齐，支持的对齐：\n
- 居左(默认){ DelDividerType.Left }\n
- 居中{ DelDividerType.Center }\n
- 居右{ DelDividerType.Right }
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 15

                    Text {
                        width: parent.width
                        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                        wrapMode: Text.WrapAnywhere
                        color: DelTheme.Primary.colorTextBase
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("水平分割线-居左")
                        titleAlign: DelDividerType.Left
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("水平分割线-居中")
                        titleAlign: DelDividerType.Center
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("水平分割线-居右")
                        titleAlign: DelDividerType.Right
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Text {
                    width: parent.width
                    text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                    wrapMode: Text.WrapAnywhere
                    color: DelTheme.Primary.colorTextBase
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("水平分割线-居左")
                    titleAlign: DelDividerType.Left
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("水平分割线-居中")
                    titleAlign: DelDividerType.Center
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("水平分割线-居右")
                    titleAlign: DelDividerType.Right
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`orientation\` 属性改变方向，支持的方向：\n
- 水平分割线(默认){ Qt.Horizontal }\n
- 垂直分割线{ Qt.Vertical }\n
如果需要垂直标题，请自行添加\`\\n\`
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 15

                    Text {
                        width: parent.width
                        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                        wrapMode: Text.WrapAnywhere
                        color: DelTheme.Primary.colorTextBase
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("水平分割线")
                    }

                    DelDivider {
                        width: 30
                        height: 200
                        orientation: Qt.Vertical
                        title: qsTr("垂\\n直\\n分\\n割\\n线")
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Text {
                    width: parent.width
                    text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                    wrapMode: Text.WrapAnywhere
                    color: DelTheme.Primary.colorTextBase
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("水平分割线")
                }

                DelDivider {
                    width: 30
                    height: 200
                    orientation: Qt.Vertical
                    title: qsTr("垂\n直\n分\n割\n线")
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`style\` 属性改变线条风格，支持的风格：\n
- 实线(默认){ DelDividerType.SolidLine }\n
- 虚线{ DelDividerType.DashLine }
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 15

                    Text {
                        width: parent.width
                        text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                        wrapMode: Text.WrapAnywhere
                        color: DelTheme.Primary.colorTextBase
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        title: qsTr("实线分割线")
                    }

                    DelDivider {
                        width: parent.width
                        height: 30
                        style: DelDividerType.DashLine
                        title: qsTr("虚线分割线")
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 15

                Text {
                    width: parent.width
                    text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                    wrapMode: Text.WrapAnywhere
                    color: DelTheme.Primary.colorTextBase
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("实线分割线")
                }

                DelDivider {
                    width: parent.width
                    height: 30
                    style: DelDividerType.DashLine
                    title: qsTr("虚线分割线")
                }
            }
        }
    }
}

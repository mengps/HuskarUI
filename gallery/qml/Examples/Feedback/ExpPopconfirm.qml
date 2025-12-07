import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    HusMessage {
        id: message
        z: 999
        parent: galleryWindow.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusPopconfirm 气泡确认框 \n
点击元素，弹出气泡式的确认框。\n
* **继承自 { [HusPopover](internal://HusPopover) }**\n
\n<br/>
\n### 支持的代理：\n
- **confirmButtonDelegate: Component** 确认按钮代理\n
- **cancelButtonDelegate: Component** 取消按钮代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
confirmText | string | '' | 确认文本
cancelText | string | '' | 取消文本
\n<br/>
\n **注意** 需要显示给出弹出宽度，高度将根据内容自动计算
\n<br/>
\n### 支持的信号：\n
- \`confirm()\` 点击确认按钮后发出\n
- \`cancel()\` 点击取消按钮后发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
目标元素的操作需要用户进一步的确认时，在目标元素附近弹出浮层提示，询问用户。\n
和 [HusModal](internal://HusModal) 弹出的全屏居中模态对话框相比，交互形式更轻量。\n
                       `)
        }

        ThemeToken {
            source: 'HusPopconfirm'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
最简单的用法，支持标题和描述以及确认/取消按钮。\n
通过 \`title\` 属性设置标题文本。\n
通过 \`description\` 属性设置描述文本。\n
通过 \`confirmText\` 属性设置确认文本\n
通过 \`cancelText\` 属性设置取消文本。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    HusButton {
                        text: 'Delete'
                        type: HusButton.Type_Outlined
                        onClicked: popconfirm.open();

                        HusPopconfirm {
                            id: popconfirm
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 300
                            title: 'Delete the task'
                            description: 'Are you sure to delete this task?'
                            confirmText: 'Yes'
                            cancelText: 'No'
                            onConfirm: {
                                message.success('Click on Yes');
                                close();
                            }
                            onCancel: {
                                message.error('Click on No');
                                close();
                            }
                        }
                    }
                }
            `
            exampleDelegate: Row {
                HusButton {
                    text: 'Delete'
                    type: HusButton.Type_Outlined
                    onClicked: popconfirm.open();

                    HusPopconfirm {
                        id: popconfirm
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        width: 300
                        title: 'Delete the task'
                        description: 'Are you sure to delete this task?'
                        confirmText: 'Yes'
                        cancelText: 'No'
                        onConfirm: {
                            message.success('Click on Yes');
                            close();
                        }
                        onCancel: {
                            message.error('Click on No');
                            close();
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义 Icon 图标')
            desc: qsTr(`
通过 \`iconSource\` 属性设置图标源。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    spacing: 10

                    HusButton {
                        text: 'Add'
                        type: HusButton.Type_Outlined
                        onClicked: popconfirm2.open();

                        HusPopconfirm {
                            id: popconfirm2
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            iconSource: HusIcon.QuestionCircleOutlined
                            width: 300
                            title: 'Add the task'
                            description: 'Are you sure to add this task?'
                            confirmText: 'Yes'
                            cancelText: 'No'
                            onConfirm: {
                                message.success('Click on Yes');
                                close();
                            }
                            onCancel: {
                                message.error('Click on No');
                                close();
                            }
                        }
                    }

                    HusButton {
                        text: 'Delete'
                        type: HusButton.Type_Outlined
                        onClicked: popconfirm3.open();

                        HusPopconfirm {
                            id: popconfirm3
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            iconSource: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'
                            width: 300
                            title: 'Delete the task'
                            description: 'Are you sure to delete this task?'
                            confirmText: 'Yes'
                            cancelText: 'No'
                            onConfirm: {
                                message.success('Click on Yes');
                                close();
                            }
                            onCancel: {
                                message.error('Click on No');
                                close();
                            }
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusButton {
                    text: 'Add'
                    type: HusButton.Type_Outlined
                    onClicked: popconfirm2.open();

                    HusPopconfirm {
                        id: popconfirm2
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        iconSource: HusIcon.QuestionCircleOutlined
                        width: 300
                        title: 'Add the task'
                        description: 'Are you sure to add this task?'
                        confirmText: 'Yes'
                        cancelText: 'No'
                        onConfirm: {
                            message.success('Click on Yes');
                            close();
                        }
                        onCancel: {
                            message.error('Click on No');
                            close();
                        }
                    }
                }

                HusButton {
                    text: 'Delete'
                    type: HusButton.Type_Outlined
                    onClicked: popconfirm3.open();

                    HusPopconfirm {
                        id: popconfirm3
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        iconSource: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'
                        width: 300
                        title: 'Delete the task'
                        description: 'Are you sure to delete this task?'
                        confirmText: 'Yes'
                        cancelText: 'No'
                        onConfirm: {
                            message.success('Click on Yes');
                            close();
                        }
                        onCancel: {
                            message.error('Click on No');
                            close();
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('替代 ToolTip')
            desc: qsTr(`
可简单替代实现 [HusToolTip](internal://HusToolTip)。\n
\`confirmText\` 为空则不显示确认按钮，\`cancelText\` 为空则不显示取消按钮。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    HusButton {
                        text: 'Hover Tooltip'
                        type: HusButton.Type_Primary

                        HusPopconfirm {
                            id: popconfirm4
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 150
                            title: 'Tooltip'
                            description: 'This is tooltip!'
                            iconSource: 0
                            visible: parent.hovered
                        }
                    }
                }
            `
            exampleDelegate: Row {
                HusButton {
                    text: 'Hover Tooltip'
                    type: HusButton.Type_Primary

                    HusPopconfirm {
                        id: popconfirm4
                        x: (parent.width - width) * 0.5
                        y: parent.height + 6
                        width: 150
                        title: 'Tooltip'
                        description: 'This is tooltip!'
                        iconSource: 0
                        visible: parent.hovered
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Layouts
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

        Description {
            desc: qsTr(`
# HusTag 标签 \n
进行标记和分类的小标签。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
tagState | enum | HusTag.State_Default | 标签状态(来自 HusTag)
text | string | '' | 标签文本
rotating | bool | false | 旋转中
iconSource | int丨string | 0丨'' | 图标(来自 HusIcon)或图标链接
iconSize | int | - | 图标大小
closeIconSource | int丨string | 0丨'' | 关闭图标(来自 HusIcon)或图标链接
closeIconSize | int | true | 关闭图标大小
presetColor | string | '' | 预设颜色
colorText | color | - |文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorIcon | color | - | 图标颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
\n<br/>
\n### 支持的信号：\n
- \`close()\` 点击关闭图标(如果有)时发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 用于标记事物的属性和维度。\n
- 进行分类。\n
                       `)
        }

        ThemeToken {
            source: 'HusTag'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
基本标签的用法\n
通过 \`text\` 设置标签文本。\n
通过 \`closeIconSource\` 设置关闭图标。\n
点击关闭图标将发送 \`close\` 信号。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    Row {
                        spacing: 10

                        HusTag {
                            text: 'Tag 1'
                        }

                        HusTag {
                            text: 'Link'

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Qt.openUrlExternally('https://github.com/mengps/HuskarUI');
                                }
                            }
                        }

                        HusTag {
                            text: 'Prevent Default'
                            closeIconSource: HusIcon.CloseOutlined
                        }

                        HusTag {
                            text: 'Tag 2'
                            closeIconSource: HusIcon.CloseCircleOutlined
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    HusTag {
                        text: 'Tag 1'
                    }

                    HusTag {
                        text: 'Link'

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Qt.openUrlExternally('https://github.com/mengps/HuskarUI');
                            }
                        }
                    }

                    HusTag {
                        text: 'Prevent Default'
                        closeIconSource: HusIcon.CloseOutlined
                    }

                    HusTag {
                        text: 'Tag 2'
                        closeIconSource: HusIcon.CloseCircleOutlined
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('多彩标签')
            desc: qsTr(`
通过 \`presetColor\` 设置预设颜色。\n
支持的预设颜色：\n
**['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']** \n
如果预设颜色不在该列表中，则为自定义标签。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    Row {
                        spacing: 10

                        Repeater {
                            model: [ 'red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta' ]
                            delegate: HusTag {
                                text: modelData
                                presetColor: modelData
                            }
                        }
                    }

                    Row {
                        spacing: 10

                        Repeater {
                            model: [ '#f50', '#2db7f5', '#87d068', '#108ee9' ]
                            delegate: HusTag {
                                text: modelData
                                presetColor: modelData
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    Repeater {
                        model: [ 'red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta' ]
                        delegate: HusTag {
                            text: modelData
                            presetColor: modelData
                        }
                    }
                }

                Row {
                    spacing: 10

                    Repeater {
                        model: [ '#f50', '#2db7f5', '#87d068', '#108ee9' ]
                        delegate: HusTag {
                            text: modelData
                            presetColor: modelData
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('动态添加和删除')
            desc: qsTr(`
简单生成一组标签，利用 \`close()\` 信号可以实现动态添加和删除。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    Flow {
                        width: parent.width
                        spacing: 10

                        Repeater {
                            id: editRepeater
                            model: ListModel {
                                id: editTagsModel
                                ListElement { tag: 'Unremovable'; removable: false }
                                ListElement { tag: 'Tag 1'; removable: true }
                                ListElement { tag: 'Tag 2'; removable: true }
                            }
                            delegate: HusTag {
                                text: tag
                                closeIconSource: removable ? HusIcon.CloseOutlined : 0
                                onClose: {
                                    editTagsModel.remove(index, 1);
                                }
                            }
                        }

                        HusInput {
                            width: 100
                            font.pixelSize: HusTheme.Primary.fontPrimarySize - 2
                            iconSource: HusIcon.PlusOutlined
                            placeholderText: 'New Tag'
                            colorBg: 'transparent'
                            onAccepted: {
                                focus = false;
                                editTagsModel.append({ tag: text, removable: true })
                                clear();
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Flow {
                    width: parent.width
                    spacing: 10

                    Repeater {
                        id: editRepeater
                        model: ListModel {
                            id: editTagsModel
                            ListElement { tag: 'Unremovable'; removable: false }
                            ListElement { tag: 'Tag 1'; removable: true }
                            ListElement { tag: 'Tag 2'; removable: true }
                        }
                        delegate: HusTag {
                            text: tag
                            closeIconSource: removable ? HusIcon.CloseOutlined : 0
                            onClose: {
                                editTagsModel.remove(index, 1);
                            }
                        }
                    }

                    HusInput {
                        width: 100
                        font.pixelSize: HusTheme.Primary.fontPrimarySize - 2
                        iconSource: HusIcon.PlusOutlined
                        placeholderText: 'New Tag'
                        colorBg: 'transparent'
                        onAccepted: {
                            focus = false;
                            editTagsModel.append({ tag: text, removable: true })
                            clear();
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('带图标的标签')
            desc: qsTr(`
通过 \`iconSource\` 设置左侧图标。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Row {
                    width: parent.width
                    spacing: 10

                    HusTag {
                        text: 'Twitter'
                        iconSource: HusIcon.TwitterOutlined
                        presetColor: '#55acee'
                    }

                    HusTag {
                        text: 'Youtube'
                        iconSource: HusIcon.YoutubeOutlined
                        presetColor: '#cd201f'
                    }

                    HusTag {
                        text: 'Facebook '
                        iconSource: HusIcon.FacebookOutlined
                        presetColor: '#3b5999'
                    }

                    HusTag {
                        text: 'LinkedIn'
                        iconSource: HusIcon.LinkedinOutlined
                        presetColor: '#55acee'
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusTag {
                    text: 'Twitter'
                    iconSource: HusIcon.TwitterOutlined
                    presetColor: '#55acee'
                }

                HusTag {
                    text: 'Youtube'
                    iconSource: HusIcon.YoutubeOutlined
                    presetColor: '#cd201f'
                }

                HusTag {
                    text: 'Facebook '
                    iconSource: HusIcon.FacebookOutlined
                    presetColor: '#3b5999'
                }

                HusTag {
                    text: 'LinkedIn'
                    iconSource: HusIcon.LinkedinOutlined
                    presetColor: '#55acee'
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('预设状态的标签')
            desc: qsTr(`
通过 \`rotating\` 设置图标是否旋转中。\n
通过 \`tagState\` 来设置不同的状态，支持的状态有：\n
- 默认状态(默认){ HusTag.State_Default }\n
- 成功状态{ HusTag.State_Success }\n
- 处理中状态{ HusTag.State_Processing }\n
- 错误状态{ HusTag.State_Error }\n
- 警告状态{ HusTag.State_Warning }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    Row {
                        spacing: 10

                        HusTag {
                            text: 'success'
                            tagState: HusTag.State_Success
                        }

                        HusTag {
                            text: 'processing'
                            tagState: HusTag.State_Processing
                        }

                        HusTag {
                            text: 'error'
                            tagState: HusTag.State_Error
                        }

                        HusTag {
                            text: 'warning'
                            tagState: HusTag.State_Warning
                        }

                        HusTag {
                            text: 'default'
                            tagState: HusTag.State_Default
                        }
                    }

                    Row {
                        spacing: 10

                        HusTag {
                            text: 'success'
                            tagState: HusTag.State_Success
                            iconSource: HusIcon.CheckCircleOutlined
                        }

                        HusTag {
                            text: 'processing'
                            rotating: true
                            tagState: HusTag.State_Processing
                            iconSource: HusIcon.SyncOutlined
                        }

                        HusTag {
                            text: 'error'
                            tagState: HusTag.State_Error
                            iconSource: HusIcon.CloseCircleOutlined
                        }

                        HusTag {
                            text: 'warning'
                            tagState: HusTag.State_Warning
                            iconSource: HusIcon.ExclamationCircleOutlined
                        }

                        HusTag {
                            text: 'waiting'
                            tagState: HusTag.State_Default
                            iconSource: HusIcon.ClockCircleOutlined
                        }

                        HusTag {
                            text: 'stop'
                            tagState: HusTag.State_Default
                            iconSource: HusIcon.MinusCircleOutlined
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    HusTag {
                        text: 'success'
                        tagState: HusTag.State_Success
                    }

                    HusTag {
                        text: 'processing'
                        tagState: HusTag.State_Processing
                    }

                    HusTag {
                        text: 'error'
                        tagState: HusTag.State_Error
                    }

                    HusTag {
                        text: 'warning'
                        tagState: HusTag.State_Warning
                    }

                    HusTag {
                        text: 'default'
                        tagState: HusTag.State_Default
                    }
                }

                Row {
                    spacing: 10

                    HusTag {
                        text: 'success'
                        tagState: HusTag.State_Success
                        iconSource: HusIcon.CheckCircleOutlined
                    }

                    HusTag {
                        text: 'processing'
                        rotating: true
                        tagState: HusTag.State_Processing
                        iconSource: HusIcon.SyncOutlined
                    }

                    HusTag {
                        text: 'error'
                        tagState: HusTag.State_Error
                        iconSource: HusIcon.CloseCircleOutlined
                    }

                    HusTag {
                        text: 'warning'
                        tagState: HusTag.State_Warning
                        iconSource: HusIcon.ExclamationCircleOutlined
                    }

                    HusTag {
                        text: 'waiting'
                        tagState: HusTag.State_Default
                        iconSource: HusIcon.ClockCircleOutlined
                    }

                    HusTag {
                        text: 'stop'
                        tagState: HusTag.State_Default
                        iconSource: HusIcon.MinusCircleOutlined
                    }
                }
            }
        }
    }
}

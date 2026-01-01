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
# HusTimeline 时间轴 \n
垂直展示的时间流信息。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **nodeDelegate: Component** 节点(圆圈)代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
- **lineDelegate: Component**  线条项代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
- **timeDelegate: Component** 时间项代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
  - \`onLeft: bool\` 指示项是否应该在左边\n
- **contentDelegate: Component** 内容项代理，代理可访问属性：\n
  - \`index: int\` 模型数据索引\n
  - \`model: var\` 模型数据\n
  - \`onLeft: bool\` 指示项是否应该在左边\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
initModel | list | [] | 初始模型数组
mode | enum | HusTimeline.Mode_Left | 时间节点展现模式(来自 HusTimeline)
reverse | bool | false | 文本颜色
defaultNodeSize | int | 11 | 默认圆圈大小
defaultLineWidth | int | 1 | 默认线条宽度
defaultTimeFormat | string | 'yyyy-MM-dd' | 默认时间格式
defaultContentFormat | enum | Text.AutoText | 默认内容文本格式(来自 Text)
colorNode | color | - | 圆圈颜色
colorNodeBg | color | - | 圆圈背景颜色
colorLine | color | - | 线条颜色
timeFont | font | - | 时间字体
colorTimeText | color | - | 时间文本颜色
contentFont | font | - | 内容字体
colorContentText | color | - | 内容文本颜色
\n<br/>
\n### 模型支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
colorNode | string | 可选 | 本时间节点的节点颜色
iconSource | int丨string | 可选 | 本时间节点的图标源
iconSize | sting | 可选 | 本时间节点的图标大小
loading | bool | 可选 | 本时间节点是否在加载中
time | date | 可选 | 本时间节点的时间
timeFormat | string | 可选 | 本时间节点的展现格式
content | string | 可选 | 本时间节点的内容
contentFormat | enum | 可选 | 本时间节点内容的文本格式(来自 Text)
\n<br/>
\n### 支持的函数：\n
- \`get(index: int): Object\` 获取 \`index\` 处的模型数据 \n
- \`set(index: int, object: Object)\` 设置 \`index\` 处的模型数据为 \`object\` \n
- \`setProperty(index: int, propertyName: string, value: any)\` 设置 \`index\` 处的模型数据属性名 \`propertyName\` 值为 \`value\` \n
- \`move(from: int, to: int, count: int = 1)\` 将 \`count\` 个模型数据从 \`from\` 位置移动到 \`to\` 位置 \n
- \`insert(index: int, object: Object)\` 插入时间节点 \`object\` 到 \`index\` 处 \n
- \`append(object: Object)\` 在末尾添加时间节点 \`object\` \n
- \`remove(index: int, count: int = 1)\` 删除 \`index\` 处 \`count\` 个模型数据 \n
- \`clear()\` 清空所有模型数据 \n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 当有一系列信息需按时间排列时，可正序和倒序。\n
- 需要有一条时间轴进行视觉上的串联时。\n
                       `)
        }

        ThemeToken {
            source: 'HusTimeline'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
通过 \`initModel\` 属性设置初始标签页的模型{需为list}，时间节点支持的属性有：\n
- { colorNode: 本时间节点的节点颜色 }\n
- { icon: 本时间节点的图标 }\n
- { iconSize: 本时间节点的图标大小 }\n
- { loading: 本时间节点是否在加载中 }\n
- { time: 本时间节点的时间(Date) }\n
- { timeFormat: 本时间节点的展现格式 }\n
- { content: 本时间节点的内容 }\n
- { contentFormat: 本时间节点内容的文本格式(如Text.RichText) }\n
如果未给出 \`time\`，则不会显示时间部分\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusTimeline {
                        width: parent.width
                        height: 200
                        initModel: [
                            {
                                content: 'Create a services site',
                            },
                            {
                                content: 'Solve initial network problems',
                            },
                            {
                                content: 'Technical testing',
                            },
                            {
                                content: 'Network problems being solved',
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTimeline {
                    width: parent.width
                    height: 200
                    initModel: [
                        {
                            content: 'Create a services site',
                        },
                        {
                            content: 'Solve initial network problems',
                        },
                        {
                            content: 'Technical testing',
                        },
                        {
                            content: 'Network problems being solved',
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('节点颜色')
            desc: qsTr(`
通过模型数据的 \`colorNode\` 属性设置节点的颜色\n
通过模型数据的 \`icon\` 属性设置节点显示为图标\n
通过模型数据的 \`iconSize\` 属性设置图标的大小\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusTimeline {
                        width: parent.width
                        height: 300
                        initModel: [
                            {
                                colorNode: HusTheme.Primary.colorSuccess,
                                content: 'Create a services site',
                            },
                            {
                                colorNode: HusTheme.Primary.colorError,
                                content: 'Solve initial network problems 1\nSolve initial network problems 2\nSolve initial network problems 3',
                            },
                            {
                                colorNode: HusTheme.Primary.colorWarning,
                                content: 'Technical testing 1\nTechnical testing 2\nTechnical testing 3',
                            },
                            {
                                content: 'Network problems being solved',
                            },
                            {
                                colorNode: '#00CCFF',
                                icon: HusIcon.SmileOutlined,
                                iconSize: 20,
                                content: 'Custom icon testing',
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTimeline {
                    width: parent.width
                    height: 300
                    initModel: [
                        {
                            colorNode: HusTheme.Primary.colorSuccess,
                            content: 'Create a services site',
                        },
                        {
                            colorNode: HusTheme.Primary.colorError,
                            content: 'Solve initial network problems 1\nSolve initial network problems 2\nSolve initial network problems 3',
                        },
                        {
                            colorNode: HusTheme.Primary.colorWarning,
                            content: 'Technical testing 1\nTechnical testing 2\nTechnical testing 3',
                        },
                        {
                            content: 'Network problems being solved',
                        },
                        {
                            colorNode: '#00CCFF',
                            icon: HusIcon.SmileOutlined,
                            iconSize: 20,
                            content: 'Custom icon testing',
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('节点加载中')
            desc: qsTr(`
通过模型数据的 \`loading\` 属性设置节点为加载中\n
稍后，可通过 \`set()\` 或 \`setProperty()\` 函数将其设置为 \`false\` 结束加载状态\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusButton {
                        text: 'Stop loading'
                        type: HusButton.Type_Primary
                        onClicked: {
                            loadingTimeline.set(3, {
                                                    time: new Date(),
                                                    loading: false,
                                                    content: 'New Content',
                                                });
                        }
                    }

                    HusTimeline {
                        id: loadingTimeline
                        width: parent.width
                        height: 200
                        initModel: [
                            {
                                content: 'Create a services site',
                            },
                            {
                                content: 'Solve initial network problems',
                            },
                            {
                                content: 'Technical testing',
                            },
                            {
                                loading: true,
                                content: 'Recording...',
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButton {
                    text: 'Stop loading'
                    type: HusButton.Type_Primary
                    onClicked: {
                        loadingTimeline.set(3, {
                                                time: new Date(),
                                                loading: false,
                                                content: 'New Content',
                                            });
                    }
                }

                HusTimeline {
                    id: loadingTimeline
                    width: parent.width
                    height: 200
                    initModel: [
                        {
                            content: 'Create a services site',
                        },
                        {
                            content: 'Solve initial network problems',
                        },
                        {
                            content: 'Technical testing',
                        },
                        {
                            loading: true,
                            content: 'Recording...',
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('排序和模式')
            desc: qsTr(`
通过属性 \`reverse\` 控制节点排序，为 false 时按正序排列，为 true 时按倒序排列\n
通过属性 \`mode\` 控制节点展现模式，支持的模式：\n
- 时间在轴左侧(默认){ HusTimeline.Mode_Left }\n
- 时间在轴右侧{ HusTimeline.Mode_Right }\n
- 交替展现{ HusTimeline.Mode_Alternate }\n
通过模型数据的 \`time\` 属性设置时间，类型为 \`Date\`\n
通过模型数据的 \`timeFormat\` 属性设置时间的格式 \n
或通过属性 \`defaultTimeFormat\` 统一设置默认的时间格式\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusButton {
                        text: 'Toggle Reverse'
                        type: HusButton.Type_Primary
                        onClicked: {
                            reverseTimeline.reverse = !reverseTimeline.reverse;
                        }
                    }

                    HusRadioBlock {
                        id: modeRadio
                        initCheckedIndex: 0
                        model: [
                            { label: 'Left', value: HusTimeline.Mode_Left },
                            { label: 'Right', value: HusTimeline.Mode_Right },
                            { label: 'Alternate', value: HusTimeline.Mode_Alternate }
                        ]
                    }

                    HusTimeline {
                        id: reverseTimeline
                        width: parent.width
                        height: 200
                        mode: modeRadio.currentCheckedValue
                        initModel: [
                            {
                                time: new Date(2020, 2, 19),
                                content: 'Create a services site',
                            },
                            {
                                time: new Date(2022, 2, 19),
                                content: 'Solve initial network problems',
                            },
                            {
                                content: 'Technical testing',
                            },
                            {
                                time: new Date(2024, 2, 19),
                                timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                                loading: true,
                                content: 'Recording...',
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusButton {
                    text: 'Toggle Reverse'
                    type: HusButton.Type_Primary
                    onClicked: {
                        reverseTimeline.reverse = !reverseTimeline.reverse;
                    }
                }

                HusRadioBlock {
                    id: modeRadio
                    initCheckedIndex: 0
                    model: [
                        { label: 'Left', value: HusTimeline.Mode_Left },
                        { label: 'Right', value: HusTimeline.Mode_Right },
                        { label: 'Alternate', value: HusTimeline.Mode_Alternate }
                    ]
                }

                HusTimeline {
                    id: reverseTimeline
                    width: parent.width
                    height: 200
                    mode: modeRadio.currentCheckedValue
                    initModel: [
                        {
                            time: new Date(2020, 2, 19),
                            content: 'Create a services site',
                        },
                        {
                            time: new Date(2022, 2, 19),
                            content: 'Solve initial network problems',
                        },
                        {
                            content: 'Technical testing',
                        },
                        {
                            time: new Date(2024, 2, 19),
                            timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                            loading: true,
                            content: 'Recording...',
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('内容文本格式')
            desc: qsTr(`
通过模型数据的 \`contentFormat\` 属性设置内容的文本格式，参见 \`Text.textFormat\`\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    width: parent.width
                    spacing: 10

                    HusTimeline {
                        width: parent.width
                        height: 300
                        initModel: [
                            {
                                time: new Date(2020, 2, 19),
                                content: '<p style=\'color:red\'>HTML Text</p><br><img src=\'https://avatars.githubusercontent.com/u/33405710?v=4\' width=\'50\' height=\'50\'>',
                                contentFormat: Text.RichText
                            },
                            {
                                time: new Date(2022, 2, 19),
                                content: 'Solve initial network problems',
                            },
                            {
                                content: 'Technical testing',
                            },
                            {
                                time: new Date(2024, 2, 19),
                                timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                                loading: true,
                                content: '### Markdown Text\n - Line 1\n - Line 2',
                                contentFormat: Text.MarkdownText
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTimeline {
                    width: parent.width
                    height: 300
                    initModel: [
                        {
                            time: new Date(2020, 2, 19),
                            content: '<p style=\'color:red\'>HTML Text</p><br><img src=\'https://avatars.githubusercontent.com/u/33405710?v=4\' width=\'50\' height=\'50\'>',
                            contentFormat: Text.RichText
                        },
                        {
                            time: new Date(2022, 2, 19),
                            content: 'Solve initial network problems',
                        },
                        {
                            content: 'Technical testing',
                        },
                        {
                            time: new Date(2024, 2, 19),
                            timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                            loading: true,
                            content: '### Markdown Text\n - Line 1\n - Line 2',
                            contentFormat: Text.MarkdownText
                        }
                    ]
                }
            }
        }
    }
}

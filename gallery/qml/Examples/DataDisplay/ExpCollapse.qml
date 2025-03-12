import QtQuick
import QtQuick.Layouts
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
## DelCollapse 折叠面板 \n
可以折叠/展开的内容区域。\n
* **继承自 { Item }**\n
支持的代理：\n
- **titleDelegate: Component** 面板标题代理，代理可访问属性：\n
  - \`index: int\` 面板项索引\n
  - \`model: var\` 面板项数据\n
  - \`isActive: bool\` 是否激活\n
- **contentDelegate: Component** 面板内容代理，代理可访问属性：\n
  - \`index: int\` 面板项索引\n
  - \`model: var\` 面板项数据\n
  - \`isActive: bool\` 是否激活\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
hoverCursorShape | int | 悬浮时鼠标形状(来自 Qt.*Cursor)
initModel | list | 初始面板模型
count | int | 模型中的数据条目数
spacing | int | 每个面板间的间隔
accordion | bool | 是否为手风琴(默认false)
activeKey | string / list | 当前激活的键(手风琴模式为string,否则为list)
defaultActiveKey | list | 初始激活的面板项 key 数组
expandIcon | int | 展开图标(来自 DelIcon)
titleFont | font | 标题字体
contentFont | font | 内容字体
colorBg | color | 背景颜色
colorIcon | color | 展开图标颜色
colorTitle | color | 标题文本颜色
colorTitleBg | color | 标题背景颜色
colorContent | color | 内容文本颜色
colorContentBg | color | 内容背景颜色
colorBorder | color | 边框颜色
radiusBg | int | 背景半径
\n支持的函数：\n
- \`Object get(index: int)\` 获取 \`index\` 处的模型数据 \n
- \`set(index: int, object: Object)\` 设置 \`index\` 处的模型数据为 \`object\` \n
- \`setProperty(index: int, propertyName: string, value: any)\` 设置 \`index\` 处的模型数据属性名 \`propertyName\` 值为 \`value\` \n
- \`move(from: int, to: int, count: int = 1)\` 将 \`count\` 个模型数据从 \`from\` 位置移动到 \`to\` 位置 \n
- \`insert(index: int, object: Object)\` 插入标签 \`object\` 到 \`index\` 处 \n
- \`append(object: Object)\` 在末尾添加标签 \`object\` \n
- \`removeAt(index: int, count: int = 1)\` 删除 \`index\` 处 \`count\` 个模型数据 \n
- \`clear()\` 清空所有模型数据 \n
\n支持的信号：\n
- \`actived(key: string)\` 激活面板时发出\n
  - \`key\` 该面板的键值\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 对复杂区域进行分组和隐藏，保持页面的整洁。\n
- \`手风琴\` 是一种特殊的折叠面板，只允许单个内容区域展开。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`defaultActiveKey\` 属性设置默认激活(即展开)键，这个例子默认展开了第一个。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelCollapse {
                        width: parent.width
                        defaultActiveKey: ['1']
                        initModel: [
                            {
                                key: '1',
                                title: 'This is panel header 1',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '2',
                                title: 'This is panel header 2',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '3',
                                title: 'This is panel header 3',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelCollapse {
                    width: parent.width
                    defaultActiveKey: ['1']
                    initModel: [
                        {
                            key: '1',
                            title: 'This is panel header 1',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '2',
                            title: 'This is panel header 2',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '3',
                            title: 'This is panel header 3',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("手风琴")
            desc: qsTr(`
通过 \`accordion\` 属性设置手风琴模式，始终只有一个面板处在激活状态。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelCollapse {
                        width: parent.width
                        accordion: true
                        initModel: [
                            {
                                key: '1',
                                title: 'This is panel header 1',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '2',
                                title: 'This is panel header 2',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '3',
                                title: 'This is panel header 3',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelCollapse {
                    width: parent.width
                    accordion: true
                    initModel: [
                        {
                            key: '1',
                            title: 'This is panel header 1',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '2',
                            title: 'This is panel header 2',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '3',
                            title: 'This is panel header 3',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`contentDelegate\` 属性设置自定义内容代理，可以实现嵌套折叠面板。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelCollapse {
                        id: collapse
                        width: parent.width
                        contentDelegate: Item {
                            Component.onCompleted: {
                                if (model.children) {
                                    childrenCollapse.visible = true;
                                    for (let i = 0; i < model.children.count; i++) {
                                        childrenCollapse.append(model.children.get(i));
                                    }
                                    height= Qt.binding(()=>childrenCollapse.height + 20);
                                } else {
                                    defaultContent.visible = true;
                                    height = defaultContent.height;
                                }
                            }

                            DelCopyableText {
                                id: defaultContent
                                width: parent.width
                                padding: 16
                                topPadding: 8
                                bottomPadding: 8
                                text: model.content
                                font: collapse.contentFont
                                wrapMode: Text.WordWrap
                                color: collapse.colorContent
                                visible: false
                            }

                            DelCollapse {
                                id: childrenCollapse
                                width: parent.width - 20
                                anchors.centerIn: parent
                                defaultActiveKey: ["1-1"]
                                visible: false
                            }
                        }
                        initModel: [
                            {
                                key: '1',
                                title: 'This is panel header 1',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.',
                                children: [
                                    {
                                        key: '1-1',
                                        title: 'This is panel header 1-1',
                                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                                    }
                                ]
                            },
                            {
                                key: '2',
                                title: 'This is panel header 2',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '3',
                                title: 'This is panel header 3',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelCollapse {
                    id: collapse
                    width: parent.width
                    contentDelegate: Item {
                        Component.onCompleted: {
                            if (model.children) {
                                childrenCollapse.visible = true;
                                for (let i = 0; i < model.children.count; i++) {
                                    childrenCollapse.append(model.children.get(i));
                                }
                                height= Qt.binding(()=>childrenCollapse.height + 20);
                            } else {
                                defaultContent.visible = true;
                                height = defaultContent.height;
                            }
                        }

                        DelCopyableText {
                            id: defaultContent
                            width: parent.width
                            padding: 16
                            topPadding: 8
                            bottomPadding: 8
                            text: model.content
                            font: collapse.contentFont
                            wrapMode: Text.WordWrap
                            color: collapse.colorContent
                            visible: false
                        }

                        DelCollapse {
                            id: childrenCollapse
                            width: parent.width - 20
                            anchors.centerIn: parent
                            defaultActiveKey: ["1-1"]
                            visible: false
                        }
                    }
                    initModel: [
                        {
                            key: '1',
                            title: 'This is panel header 1',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.',
                            children: [
                                {
                                    key: '1-1',
                                    title: 'This is panel header 1-1',
                                    content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                                }
                            ]
                        },
                        {
                            key: '2',
                            title: 'This is panel header 2',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '3',
                            title: 'This is panel header 3',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`spacing\` 属性设置面板之间的间隔以分离各个面板。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelCollapse {
                        width: parent.width
                        spacing: 10
                        initModel: [
                            {
                                key: '1',
                                title: 'This is panel header 1',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '2',
                                title: 'This is panel header 2',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '3',
                                title: 'This is panel header 3',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelCollapse {
                    width: parent.width
                    spacing: 10
                    initModel: [
                        {
                            key: '1',
                            title: 'This is panel header 1',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '2',
                            title: 'This is panel header 2',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '3',
                            title: 'This is panel header 3',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`expandIcon\` 属性设置展开图标, 设置为 0 则不显示图标。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelCollapse {
                        width: parent.width
                        expandIcon: DelIcon.CaretRightOutlined
                        initModel: [
                            {
                                key: '1',
                                title: 'This is panel header 1',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '2',
                                title: 'This is panel header 2',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            },
                            {
                                key: '3',
                                title: 'This is panel header 3',
                                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelCollapse {
                    width: parent.width
                    expandIcon: DelIcon.CaretRightOutlined
                    initModel: [
                        {
                            key: '1',
                            title: 'This is panel header 1',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '2',
                            title: 'This is panel header 2',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        },
                        {
                            key: '3',
                            title: 'This is panel header 3',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        }
                    ]
                }
            }
        }
    }
}

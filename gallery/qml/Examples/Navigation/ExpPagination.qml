import QtQuick
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
# HusPagination 分页\n
分页器用于分隔长列表，每次只加载一个页面。\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **prevButtonDelegate: Component** 上一页按钮代理\n
- **nextButtonDelegate: Component** 下一页按钮代理\n
- **quickJumperDelegate: Component** 快速跳转代理\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
defaultButtonWidth | int | 32 | 按钮宽度
defaultButtonHeight | int | 32 | 按钮高度
defaultButtonSpacing | int | 8 | 按钮间隔
showQuickJumper | bool | false | 是否显示快速跳转
currentPageIndex | int | 0 | 当前页索引
total | int | 0 | 数据项总数
pageTotal | int | - | 页总数
pageButtonMaxCount | int | 7 | 最大页按钮数量
pageSize | int | 10 | 每页数量
pageSizeModel | list | [] | 每页数量模型
prevButtonTooltip | string | '上一页' | 上一页按钮的提示文本(为空不显示)
nextButtonTooltip | string | '下一页' | 下一页按钮的提示文本(为空不显示)
\n<br/>
\n### 支持的函数：\n
- \`gotoPageIndex(index: int)\` 跳转到\`index\` 处的页 \n
- \`gotoPrevPage()\` 跳转到前一页 \n
- \`gotoPrev5Page()\` 跳转到前五页 \n
- \`gotoNextPage()\` 跳转到后一页 \n
- \`gotoNext5Page()\` 跳转到后五页 \n
`)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 当加载/渲染所有数据将花费很多时间时。
- 可切换页码浏览数据。
                       `)
        }

        ThemeToken {
            source: 'HusPagination'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基础')
            desc: qsTr(`
基础分页，通过 \`currentPageIndex\` 设置当前页索引。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                HusPagination {
                    currentPageIndex: 0
                    total: 50
                }
            `
            exampleDelegate: HusPagination {
                currentPageIndex: 0
                total: 50
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('更多')
            desc: qsTr(`
通过 \`enabled\` 设置是否启用。\n
通过 \`total\` 设置数据总数。\n
通过 \`pageSizeModel\` 设置每页数量选择模型，选择项支持的属性：\n
- { label: 数量标签 }\n
- { value: 每页数量 }\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusPagination {
                        currentPageIndex: 6
                        total: 500
                        pageSizeModel: [
                            { label: qsTr('10条每页'), value: 10 },
                            { label: qsTr('20条每页'), value: 20 },
                            { label: qsTr('30条每页'), value: 30 },
                            { label: qsTr('40条每页'), value: 40 }
                        ]
                    }

                    HusPagination {
                        enabled: false
                        currentPageIndex: 6
                        total: 500
                        pageSizeModel: [
                            { label: qsTr('10条每页'), value: 10 },
                            { label: qsTr('20条每页'), value: 20 },
                            { label: qsTr('30条每页'), value: 30 },
                            { label: qsTr('40条每页'), value: 40 }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusPagination {
                    currentPageIndex: 6
                    total: 500
                    pageSizeModel: [
                        { label: qsTr('10条每页'), value: 10 },
                        { label: qsTr('20条每页'), value: 20 },
                        { label: qsTr('30条每页'), value: 30 },
                        { label: qsTr('40条每页'), value: 40 }
                    ]
                }

                HusPagination {
                    enabled: false
                    currentPageIndex: 6
                    total: 500
                    pageSizeModel: [
                        { label: qsTr('10条每页'), value: 10 },
                        { label: qsTr('20条每页'), value: 20 },
                        { label: qsTr('30条每页'), value: 30 },
                        { label: qsTr('40条每页'), value: 40 }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('跳转')
            desc: qsTr(`
通过 \`showQuickJumper\` 显示快速跳转项，可通过 \`quickJumperDelegate\` 自定义。
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusPagination {
                        currentPageIndex: 6
                        total: 500
                        showQuickJumper: true
                        pageSizeModel: [
                            { label: qsTr('10条每页'), value: 10 },
                            { label: qsTr('20条每页'), value: 20 },
                            { label: qsTr('30条每页'), value: 30 },
                            { label: qsTr('40条每页'), value: 40 }
                        ]
                    }

                    HusPagination {
                        enabled: false
                        currentPageIndex: 6
                        total: 500
                        showQuickJumper: true
                        pageSizeModel: [
                            { label: qsTr('10条每页'), value: 10 },
                            { label: qsTr('20条每页'), value: 20 },
                            { label: qsTr('30条每页'), value: 30 },
                            { label: qsTr('40条每页'), value: 40 }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusPagination {
                    currentPageIndex: 6
                    total: 500
                    showQuickJumper: true
                    pageSizeModel: [
                        { label: qsTr('10条每页'), value: 10 },
                        { label: qsTr('20条每页'), value: 20 },
                        { label: qsTr('30条每页'), value: 30 },
                        { label: qsTr('40条每页'), value: 40 }
                    ]
                }

                HusPagination {
                    enabled: false
                    currentPageIndex: 6
                    total: 500
                    showQuickJumper: true
                    pageSizeModel: [
                        { label: qsTr('10条每页'), value: 10 },
                        { label: qsTr('20条每页'), value: 20 },
                        { label: qsTr('30条每页'), value: 30 },
                        { label: qsTr('40条每页'), value: 40 }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('上一步和下一步')
            desc: qsTr(`
通过 \`prevButtonDelegate\` 和 \`nextButtonDelegate\` 自定义上一步和下一步按钮。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                HusPagination {
                    currentPageIndex: 2
                    total: 500
                    pageSizeModel: [
                        { label: qsTr('10条每页'), value: 10 },
                        { label: qsTr('20条每页'), value: 20 },
                        { label: qsTr('30条每页'), value: 30 },
                        { label: qsTr('40条每页'), value: 40 }
                    ]
                    prevButtonDelegate: HusButton {
                        text: 'Previous'
                        type: HusButton.Type_Link
                        onClicked: gotoPrevPage();
                    }
                    nextButtonDelegate: HusButton {
                        text: 'Next'
                        type: HusButton.Type_Link
                        onClicked: gotoNextPage();
                    }
                }
            `
            exampleDelegate: HusPagination {
                currentPageIndex: 2
                total: 500
                pageSizeModel: [
                    { label: qsTr('10条每页'), value: 10 },
                    { label: qsTr('20条每页'), value: 20 },
                    { label: qsTr('30条每页'), value: 30 },
                    { label: qsTr('40条每页'), value: 40 }
                ]
                prevButtonDelegate: HusButton {
                    text: 'Previous'
                    type: HusButton.Type_Link
                    onClicked: gotoPrevPage();
                }
                nextButtonDelegate: HusButton {
                    text: 'Next'
                    type: HusButton.Type_Link
                    onClicked: gotoNextPage();
                }
            }
        }
    }
}

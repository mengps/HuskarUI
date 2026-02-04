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

        DocDescription {
            desc: qsTr(`
# HusTransfer 穿梭框 \n
双栏穿梭选择框。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { Control }**\n
\n<br/>
\n### 支持的代理：\n
- **titleDelegate: Component** 标题代理，代理可访问属性：\n
  - \`title: string\` 标题文本\n
- **searchInputDelegate: Component** 搜索输入框代理。\n
- **leftActionDelegate: Component** 向左动作代理。\n
- **rightActionDelegate: Component** 向右动作代理。\n
- **emptyDelegate: Component** 空状态代理。\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
dataSource | array | [] | 数据源
sourceKeys | array(readonly) | [] | 左侧数据的 key 集合
targetKeys | array | [] | 右侧框数据的 key 集合(左侧将根据此自动计算)
sourceCheckedKeys | array | [] | 左侧选中的键列表
targetCheckedKeys | array | [] | 右侧选中的键列表
defaultSourceCheckedKeys | array | [] | 左侧默认选中的键列表
defaultTargetCheckedKeys | array | [] | 右侧默认选中的键列表
sourceCheckedCount | int(readonly) | - | 左侧选中的数量
targetCheckedCount | int(readonly) | - | 右侧选中的数量
titles | array | ['Source', 'Target'] | 标题列表，顺序从左至右
operations | array | ['>', '<'] | 操作文案集合，顺序从左至右
showSearch | bool | false | 是否显示搜索框
filterOption | function(value, record) | - | 输入项将使用该函数进行筛选(showSearch需为true)
searchPlaceholder | string | 'Search here' | 搜索框占位符
pagination | bool丨object | false | 是否使用分页样式
oneWay | bool | false | 是否单向穿梭
titleFont | font | - | 标题文本
colorTitle | color | - | 标题颜色
colorText | color | - | 项文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 背景边框色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景圆角
sourceTableView | [HusTableView](internal://HusTableView) | - | 访问内部左侧表格视图
targetTableView | [HusTableView](internal://HusTableView) | - | 访问内部右侧表格视图
\n<br/>
\n### {dataSource}支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
key | string | 必选 | 数据键
title | string | 必选 | 标题
enabled | bool | 可选 | 是否启用
\n<br/>
\n### 支持的函数：\n
- \`clearAllCheckedKeys(direction: string = 'left')\` 清除 \`direction\` 指定方向的所有选中键。\n
- \`filter(text: string, direction: string = 'left')\` 使用 \`text\` 对 \`direction\` 指定方向的数据执行过滤。\n
\n<br/>
\n### 支持的信号：\n
- \`change(nextTargetKeys: var, direction: string, moveKeys: var)\` 选项在两栏之间转移时发出\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 需要在多个可选项中进行多选时。\n
- 比起 [HusSelect](internal://HusSelect) 和 [HusTreeSelect](internal://HusTreeSelect)，穿梭框占据更大的空间，可以展示可选项的更多信息。\n
- 穿梭框可以直观地展示被选中的元素，便于查看和反选。\n
                       `)
        }

        ThemeToken {
            source: 'HusTransfer'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusTransfer.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
最基本的用法，展示了 \`dataSource\`、\`targetKeys\`、\`defaultTargetCheckedKeys\` 的用法。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusTransfer {
                        width: 400
                        height: 200
                        dataSource: [
                            { key: '1', title: 'Content 1' },
                            { key: '2', title: 'Content 2', enabled: false },
                            { key: '3', title: 'Content 3' },
                            { key: '4', title: 'Content 4' },
                            { key: '5', title: 'Content 5' },
                            { key: '6', title: 'Content 6' },
                            { key: '7', title: 'Content 7' },
                            { key: '8', title: 'Content 8' },
                        ]
                        targetKeys: ['3', '4', '5']
                        defaultTargetCheckedKeys: ['3', '4']
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTransfer {
                    width: 400
                    height: 200
                    dataSource: [
                        { key: '1', title: 'Content 1' },
                        { key: '2', title: 'Content 2', enabled: false },
                        { key: '3', title: 'Content 3' },
                        { key: '4', title: 'Content 4' },
                        { key: '5', title: 'Content 5' },
                        { key: '6', title: 'Content 6' },
                        { key: '7', title: 'Content 7' },
                        { key: '8', title: 'Content 8' },
                    ]
                    targetKeys: ['3', '4', '5']
                    defaultTargetCheckedKeys: ['3', '4']
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('带搜索框')
            desc: qsTr(`
通过 \`showSearch\` 设置为 \`true\` 显示搜索框。\n
通过 \`filterOption\` 设置过滤选项，它是形如：\`function(value: string, record: var): bool { }\` 的函数。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusTransfer {
                        width: 400
                        height: 200
                        titles: ['Source', 'Target']
                        showSearch: true
                        dataSource: {
                            const data = [];
                            for (let i = 0; i < 20; i++) {
                                data.push({
                                    key: i.toString(),
                                    title: 'Content ' + (i + 1),
                                    description: 'Description of content ' + (i + 1),
                                    enabled: i % 3 !== 0
                                });
                            }
                            return data;
                        }
                        targetKeys: ['1', '4']
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTransfer {
                    width: 400
                    height: 200
                    titles: ['Source', 'Target']
                    showSearch: true
                    dataSource: {
                        const data = [];
                        for (let i = 0; i < 20; i++) {
                            data.push({
                                key: i.toString(),
                                title: 'Content ' + (i + 1),
                                description: 'Description of content ' + (i + 1),
                                enabled: i % 3 !== 0
                            });
                        }
                        return data;
                    }
                    targetKeys: ['1', '4']
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('分页')
            desc: qsTr(`
大数据下使用分页。\n
通过 \`pagination\` 设置为 \`object\` 显示为分页格式。\n
\`pagination\` 对象支持的属性有：\n
- defaultButtonSpacing 按钮间隔。\n
- pageSize 每页数量。\n
- pageButtonMaxCount 最大页按钮数。\n
- showQuickJumper 是否显示快速跳转。\n
详细说明见 [HusPagination](internal://HusPagination)。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10

                    HusTransfer {
                        width: 800
                        height: 300
                        titles: ['Source', 'Target']
                        showSearch: true
                        dataSource: {
                            const data = [];
                            for (let i = 0; i < 1000; i++) {
                                data.push({
                                    key: i.toString(),
                                    title: 'Content ' + (i + 1),
                                    description: 'Description of content ' + (i + 1),
                                    enabled: i % 3 !== 0
                                });
                            }
                            return data;
                        }
                        targetKeys: ['1', '4', '9']
                        pagination: ({
                                         pageSize: 100,
                                         pageButtonMaxCount: 5
                                     })
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusTransfer {
                    width: 800
                    height: 300
                    titles: ['Source', 'Target']
                    showSearch: true
                    dataSource: {
                        const data = [];
                        for (let i = 0; i < 1000; i++) {
                            data.push({
                                key: i.toString(),
                                title: 'Content ' + (i + 1),
                                description: 'Description of content ' + (i + 1),
                                enabled: i % 3 !== 0
                            });
                        }
                        return data;
                    }
                    targetKeys: ['1', '4', '9']
                    pagination: ({
                                     pageSize: 100,
                                     pageButtonMaxCount: 5
                                 })
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls.Basic
import Qt.labs.qmlmodels
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Component {
        id: textDelegate

        Text {
            id: displayText
            leftPadding: 8
            rightPadding: 8
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySize
            }
            text: cellData
            color: DelTheme.Primary.colorTextBase
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            TextMetrics {
                id: displayWidth
                font: displayText.font
                text: displayText.text
            }

            TextMetrics {
                id: startWidth
                font: displayText.font
                text: {
                    let index = displayText.text.indexOf(filterInput);
                    if (index !== -1)
                        return displayText.text.substring(0, index);
                    else
                        return '';
                }
            }

            TextMetrics {
                id: filterWidth
                font: displayText.font
                text: filterInput
            }

            Rectangle {
                color: "red"
                opacity: 0.1
                x: startWidth.advanceWidth + (displayText.width - displayWidth.advanceWidth) * 0.5
                width: filterWidth.advanceWidth
                height: parent.height
            }
        }
    }

    Component {
        id: tagsDelegate

        Item {
            Row {
                id: row
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Repeater {
                    model: cellData
                    delegate: DelTag {
                        text: modelData
                        presetColor: [ "red", "green", "orange", "magenta", "cyan"][index]
                        required property int index
                        required property string modelData
                    }
                }
            }
        }
    }

    Component {
        id: actionDelegate

        Item {
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                DelButton {
                    type: DelButton.Type_Link
                    text: qsTr(`Invite`)
                }

                DelButton {
                    type: DelButton.Type_Link
                    text: qsTr(`Delete`)
                }
            }
        }
    }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelTableView 表格\n
展示行列数据。\n
* **继承自 { DelRectangle }**\n
支持的代理：\n
- **columnHeaderDelegate: Component** 列头代理，代理可访问属性：\n
  - \`model: var\` 列模型索引数据\n
  - \`headerData: var\` 列模型数据(即columns[column])\n
  - \`column: int\` 列索引\n
- **rowHeaderDelegate: Component** 行头代理，代理可访问属性：\n
  - \`model: var\` 行模型索引数据\n
  - \`row: int\` 行索引\n
- **columnHeaderSorterIconDelegate: Component** 列头搜索器图标代理，代理可访问属性：\n
  - \`sorter: var\` 该列的搜索器\n
  - \`sortDirections: list\` 该列的搜索方向数组\n
  - \`column: int\` 列索引\n
- **columnHeaderFilterIconDelegate: Component** 列头过滤器图标代理，代理可访问属性：\n
  - \`onFilter: var\` 该列的过滤器\n
  - \`column: int\` 列索引\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
alternatingRow | bool | 是否交替显示行背景(默认false)
defaultColumnHeaderHeight | int | 默认列头高度
defaultRowHeaderWidth | int | 默认行头宽度
columnGridVisible | bool | 是否显示列网格线(默认false)
rowGridVisible | bool | 是否显示行网格线(默认false)
minimumRowHeight | int | 最小行高
maximumRowHeight | int | 最大行高
initModel | list | 表格初始数据模型
columns | list | 列描述对象数组
checkedKeys | list | 选中行的键列表
colorGridLine | color | 网格线颜色
columnHeaderVisible | bool | 是否显示列头
columnHeaderTitleFont | font | 列头标题字体
colorColumnHeaderTitle | color | 列头标题颜色
colorColumnHeaderBg | color |  列头背景颜色
rowHeaderVisible | bool | 是否显示行头
rowHeaderTitleFont | font | 行头标题字体
colorRowHeaderTitle | color | 行头标题颜色
colorRowHeaderBg | color | 行头背景颜色
colorResizeBlockBg | color | 调整头大小块(左上角方块)背景色
\n{columns}支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
title | string | 标题
dataIndex | sting | 数据索引
delegate | var | 该列的单元格代理
width | int | 该列初始宽度
minimumWidth(可选) | int | 该列最小宽度
maximumWidth(可选) | int | 该列最大宽度
editable(可选) | bool | 列头标题是否可编辑
align(可选) | string | 列头标题对齐方式, 支持 'center'丨'left'丨'right'
selectionType(可选) | string | 该列选择类型, 支持 'checkbox'
sorter(可选) | var | 该列排序器
sortDirections(可选) | list | 该列排序方向, 支持 'false'丨'ascend'丨'descend'
onFilter(可选) | var | 该列过滤器
filterInput(可选) | string | 该列过滤输入
\n支持的函数：\n
- \`checkForRows(rows: Array)\` 选中 \`rows\` 提供的行列表。\n
- \`checkForKeys(keys: Array)\` 选中 \`keys\` 提供的键列表。\n
- \`Array getCheckedKeys()\` 获取选中的键列表。\n
- \`clearAllCheckedKeys()\` 清除所有选中的键。\n
- \`scrollToRow(row: int)\` 滚动到 \`row\` 指定的行。\n
- \`sort(column: int)\` 排序 \`column\` 指定的列(该列的描述对象需要具有 \`sorter\` 和 \`sortDirections\`)。\n
- \`clearSort()\` 清除所有排序(即还原为初始状态)。\n
- \`filter()\` 使用提供的(如果有，可以多列) \`onFilter\` 过滤整个模型。\n
- \`clearFilter()\` 清除所有过滤(即还原为初始状态)。\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 当有大量结构化的数据需要展现时。\n
- 当需要对数据进行排序、搜索、分页、自定义操作等复杂行为时。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("基本用法")
            desc: qsTr(`
简单的表格，最后一列是各种操作。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelTableView {
                        width: parent.width
                        height: 200
                        columns: [
                            {
                                title: 'Name',
                                dataIndex: 'name',
                                key: 'name',
                                delegate: textDelegate,
                                width: 200
                            },
                            {
                                title: 'Age',
                                dataIndex: 'age',
                                key: 'age',
                                delegate: textDelegate,
                                width: 100
                            },
                            {
                                title: 'Address',
                                dataIndex: 'address',
                                key: 'address',
                                delegate: textDelegate,
                                width: 300
                            },
                            {
                                title: 'Tags',
                                key: 'tags',
                                dataIndex: 'tags',
                                delegate: tagsDelegate,
                                width: 200
                            },
                            {
                                title: 'Action',
                                key: 'action',
                                dataIndex: 'action',
                                delegate: actionDelegate,
                                width: 300
                            }
                        ]
                        initModel: [
                            {
                                key: '1',
                                name: 'John Brown',
                                age: 32,
                                address: 'New York No. 1 Lake Park',
                                tags: ['nice', 'developer'],
                            },
                            {
                                key: '2',
                                name: 'Jim Green',
                                age: 42,
                                address: 'London No. 1 Lake Park',
                                tags: ['loser'],
                            },
                            {
                                key: '3',
                                name: 'Joe Black',
                                age: 32,
                                address: 'Sydney No. 1 Lake Park',
                                tags: ['cool', 'teacher'],
                            }
                        ]
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelTableView {
                    width: parent.width
                    height: 200
                    columns: [
                        {
                            title: 'Name',
                            dataIndex: 'name',
                            key: 'name',
                            delegate: textDelegate,
                            width: 200
                        },
                        {
                            title: 'Age',
                            dataIndex: 'age',
                            key: 'age',
                            delegate: textDelegate,
                            width: 100
                        },
                        {
                            title: 'Address',
                            dataIndex: 'address',
                            key: 'address',
                            delegate: textDelegate,
                            width: 300
                        },
                        {
                            title: 'Tags',
                            key: 'tags',
                            dataIndex: 'tags',
                            delegate: tagsDelegate,
                            width: 200
                        },
                        {
                            title: 'Action',
                            key: 'action',
                            dataIndex: 'action',
                            delegate: actionDelegate,
                            width: 300
                        }
                    ]
                    initModel: [
                        {
                            key: '1',
                            name: 'John Brown',
                            age: 32,
                            address: 'New York No. 1 Lake Park',
                            tags: ['nice', 'developer'],
                        },
                        {
                            key: '2',
                            name: 'Jim Green',
                            age: 42,
                            address: 'London No. 1 Lake Park',
                            tags: ['loser'],
                        },
                        {
                            key: '3',
                            name: 'Joe Black',
                            age: 32,
                            address: 'Sydney No. 1 Lake Park',
                            tags: ['cool', 'teacher'],
                        }
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("自定义选择项")
            desc: qsTr(`
通过 \`columns\` 对应列中的 \`selectionType\` 设置选择类型，目前支持 'checkbox' 多选框。\n
**注意** 设置多列 \`selectionType\` 行为未定义。\n
通过 \`columns\` 对应列中的 \`editable\` 设置该列头是否可编辑。\n
通过 \`scrollToRow()\` 滚动到指定行。\n
通过 \`alternatingRow\` 设置是否交替显示行背景。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    Row {
                        spacing: 10

                        DelIconButton {
                            text: qsTr("Reload")
                            type: DelButton.Type_Primary
                            enabled: tableView.checkedKeys.length > 0
                            onClicked: {
                                loading = true;
                                reloadTimer.restart();
                            }

                            Timer {
                                id: reloadTimer
                                interval: 2000
                                onTriggered: {
                                    parent.loading = false;
                                    tableView.clearAllCheckedKeys();
                                }
                            }
                        }

                        DelButton {
                            text: qsTr("ScrollToRow 0")
                            type: DelButton.Type_Primary
                            onClicked: tableView.scrollToRow(0);
                        }

                        DelButton {
                            text: qsTr("ScrollToRow 99")
                            type: DelButton.Type_Primary
                            onClicked: tableView.scrollToRow(99);
                        }

                        DelCheckBox {
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Switch alternatingRow")
                            onClicked: tableView.alternatingRow = checked;
                        }
                    }

                    DelTableView {
                        id: tableView
                        width: parent.width
                        height: 400
                        columns: [
                            {
                                title: 'Name',
                                dataIndex: 'name',
                                delegate: textDelegate,
                                width: 200,
                                minimumWidth: 100,
                                maximumWidth: 400,
                                align: 'center',
                                selectionType: 'checkbox',
                            },
                            {
                                title: 'Age',
                                dataIndex: 'age',
                                delegate: textDelegate,
                                width: 100,
                                editable: true,
                            },
                            {
                                title: 'Address',
                                dataIndex: 'address',
                                delegate: textDelegate,
                                width: 300
                            },
                            {
                                title: 'Tags',
                                dataIndex: 'tags',
                                delegate: tagsDelegate,
                                width: 350,
                            },
                            {
                                title: 'Action',
                                dataIndex: 'action',
                                delegate: actionDelegate,
                                width: 200
                            }
                        ]
                    }

                    DelPagination {
                        anchors.horizontalCenter: parent.horizontalCenter
                        total: 1000
                        pageSize: 100
                        showQuickJumper: true
                        onCurrentPageIndexChanged: {
                            /*! 生成一些数据 */
                            tableView.initModel = Array.from({ length: pageSize }).map(
                                        (_, i) => {
                                            return {
                                                key: String(i + currentPageIndex * pageSize),
                                                name: \`Edward King \${i + currentPageIndex * pageSize}\`,
                                                age: i % 30 + 30,
                                                address: \`London, Park Lane no. \${i + currentPageIndex * pageSize}\`,
                                                tags: ['nice', 'cool', 'loser', 'teacher', 'developer'].splice(0, i % 5 + 1),
                                            }
                                        });
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    DelIconButton {
                        text: qsTr("Reload")
                        type: DelButton.Type_Primary
                        enabled: tableView.checkedKeys.length > 0
                        onClicked: {
                            loading = true;
                            reloadTimer.restart();
                        }

                        Timer {
                            id: reloadTimer
                            interval: 2000
                            onTriggered: {
                                parent.loading = false;
                                tableView.clearAllCheckedKeys();
                            }
                        }
                    }

                    DelButton {
                        text: qsTr("ScrollToRow 0")
                        type: DelButton.Type_Primary
                        onClicked: tableView.scrollToRow(0);
                    }

                    DelButton {
                        text: qsTr("ScrollToRow 99")
                        type: DelButton.Type_Primary
                        onClicked: tableView.scrollToRow(99);
                    }

                    DelCheckBox {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Switch alternatingRow")
                        onClicked: tableView.alternatingRow = checked;
                    }
                }

                DelTableView {
                    id: tableView
                    width: parent.width
                    height: 400
                    columns: [
                        {
                            title: 'Name',
                            dataIndex: 'name',
                            delegate: textDelegate,
                            width: 200,
                            minimumWidth: 100,
                            maximumWidth: 400,
                            align: 'center',
                            selectionType: 'checkbox',
                        },
                        {
                            title: 'Age',
                            dataIndex: 'age',
                            delegate: textDelegate,
                            width: 100,
                            editable: true,
                        },
                        {
                            title: 'Address',
                            dataIndex: 'address',
                            delegate: textDelegate,
                            width: 300
                        },
                        {
                            title: 'Tags',
                            dataIndex: 'tags',
                            delegate: tagsDelegate,
                            width: 350,
                        },
                        {
                            title: 'Action',
                            dataIndex: 'action',
                            delegate: actionDelegate,
                            width: 200
                        }
                    ]
                }

                DelPagination {
                    anchors.horizontalCenter: parent.horizontalCenter
                    total: 1000
                    pageSize: 100
                    showQuickJumper: true
                    onCurrentPageIndexChanged: {
                        /*! 生成一些数据 */
                        tableView.initModel = Array.from({ length: pageSize }).map(
                                    (_, i) => {
                                        return {
                                            key: String(i + currentPageIndex * pageSize),
                                            name: `Edward King ${i + currentPageIndex * pageSize}`,
                                            age: i % 30 + 30,
                                            address: `London, Park Lane no. ${i + currentPageIndex * pageSize}`,
                                            tags: ['nice', 'cool', 'loser', 'teacher', 'developer'].splice(0, i % 5 + 1),
                                        }
                                    });
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr("排序和过滤")
            desc: qsTr(`
通过 \`columns\` 对应列中的 \`sorter\` 设置排序器，其原型为 \`function(a, b){}\`，具体可参考 \`Array.sort()\` 参数。\n
通过 \`columns\` 对应列中的 \`sortDirections\` 设置排序方向列表，在切换排序时按数组内容指示的方向依次切换，项 \`ascend\` 视作升序()。\n
通过 \`columns\` 对应列中的 \`onFilter\` 设置过滤器，其原型为 \`function(value, record){}\`，\`value\` 为过滤输入，\`record\` 为当前数据记录。\n
**一种在外部实现自定义过滤的方式** \n
- 设置 \`columns\` 对应列中的 \`filterInput\`，接着调用 \`filter()\` 函数即可对该列实现过滤。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    width: parent.width
                    spacing: 10

                    DelTableView {
                        id: sortAndFilterTable
                        width: parent.width
                        height: 400
                        columns: [
                            {
                                title: 'Name',
                                dataIndex: 'name',
                                delegate: textDelegate,
                                width: 200,
                                minimumWidth: 100,
                                maximumWidth: 400,
                                align: 'center',
                                selectionType: 'checkbox',
                            },
                            {
                                title: 'Age',
                                dataIndex: 'age',
                                delegate: textDelegate,
                                width: 150,
                                sorter: (a, b) => a.age - b.age,
                                sortDirections: ['descend', 'false'],
                                onFilter: (value, record) => String(record.age).includes(value)
                            },
                            {
                                title: 'Address',
                                dataIndex: 'address',
                                delegate: textDelegate,
                                width: 300,
                                sorter: (a, b) => a.address.length - b.address.length,
                                sortDirections: ['ascend', 'descend', 'false'],
                                onFilter: (value, record) => record.address.includes(value)
                            },
                            {
                                title: 'Tags',
                                dataIndex: 'tags',
                                delegate: tagsDelegate,
                                width: 350,
                            },
                        ]
                    }

                    DelPagination {
                        anchors.horizontalCenter: parent.horizontalCenter
                        total: 1000
                        pageSize: 100
                        showQuickJumper: true
                        onCurrentPageIndexChanged: {
                            /*! 生成一些数据 */
                            sortAndFilterTable.initModel = Array.from({ length: pageSize }).map(
                                        (_, i) => {
                                            return {
                                                key: String(i + currentPageIndex * pageSize),
                                                name: \`Edward King \${i + currentPageIndex * pageSize}\`,
                                                age: i % 30 + 30,
                                                address: \`London, Park Lane no. \${i + currentPageIndex * pageSize}\`,
                                                tags: ['nice', 'cool', 'loser', 'teacher', 'developer'].splice(0, i % 5 + 1),
                                            }
                                        });
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelTableView {
                    id: sortAndFilterTable
                    width: parent.width
                    height: 400
                    columns: [
                        {
                            title: 'Name',
                            dataIndex: 'name',
                            delegate: textDelegate,
                            width: 200,
                            minimumWidth: 100,
                            maximumWidth: 400,
                            align: 'center',
                            selectionType: 'checkbox',
                        },
                        {
                            title: 'Age',
                            dataIndex: 'age',
                            delegate: textDelegate,
                            width: 150,
                            sorter: (a, b) => a.age - b.age,
                            sortDirections: ['descend', 'false'],
                            onFilter: (value, record) => String(record.age).includes(value)
                        },
                        {
                            title: 'Address',
                            dataIndex: 'address',
                            delegate: textDelegate,
                            width: 300,
                            sorter: (a, b) => a.address.length - b.address.length,
                            sortDirections: ['ascend', 'descend', 'false'],
                            onFilter: (value, record) => record.address.includes(value)
                        },
                        {
                            title: 'Tags',
                            dataIndex: 'tags',
                            delegate: tagsDelegate,
                            width: 350,
                        },
                    ]
                }

                DelPagination {
                    anchors.horizontalCenter: parent.horizontalCenter
                    total: 10000
                    pageSize: 1000
                    showQuickJumper: true
                    onCurrentPageIndexChanged: {
                        /*! 生成一些数据 */
                        sortAndFilterTable.initModel = Array.from({ length: pageSize }).map(
                                    (_, i) => {
                                        return {
                                            key: String(i + currentPageIndex * pageSize),
                                            name: `Edward King ${i + currentPageIndex * pageSize}`,
                                            age: i % 30 + 30,
                                            address: `London, Park Lane no. ${i + currentPageIndex * pageSize}`,
                                            tags: ['nice', 'cool', 'loser', 'teacher', 'developer'].splice(0, i % 5 + 1),
                                        }
                                    });
                    }
                }
            }
        }
    }
}

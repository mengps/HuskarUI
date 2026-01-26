[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusTableView 表格


展示行列数据。

* **模块 { HuskarUI.Basic }**

* **继承自 { HusRectangle }**


<br/>

### 支持的代理：

- **columnHeaderDelegate: Component** 列头代理，代理可访问属性：

  - `model: var` 列模型数据

  - `headerData: var` 列描述数据(即columns[column])

  - `column: int` 列索引

- **rowHeaderDelegate: Component** 行头代理，代理可访问属性：

  - `model: var` 行模型数据

  - `row: int` 行索引

- **columnHeaderSorterIconDelegate: Component** 列头搜索器图标代理，代理可访问属性：

  - `sorter: var` 该列的搜索器

  - `sortDirections: list` 该列的搜索方向数组

  - `column: int` 列索引

- **columnHeaderFilterIconDelegate: Component** 列头过滤器图标代理，代理可访问属性：

  - `onFilter: var` 该列的过滤器

  - `column: int` 列索引


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画
reuseItems | bool | false | 是否重用项目(具体参考官方文档)
propagateWheelEvent | bool | false | 是否传播鼠标滚轮事件
alternatingRow | bool | false | 是否交替显示行背景
defaultColumnHeaderHeight | int | 40 | 默认列头高度
defaultRowHeaderWidth | int | 40 | 默认行头宽度
showColumnGrid | bool | false | 是否显示列网格线
showRowGrid | bool | false | 是否显示行网格线
rowHeightProvider | function(row, key) | minimumRowHeight | 行高提供函数
minimumRowHeight | int | 40 | 最小行高
maximumRowHeight | int | Number.MAX_VALUE | 最大行高
initModel | list | [] | 表格初始数据模型
rowCount | int | 0 | 当前模型行数
columns | list | [] | 列描述对象数组
checkedKeys | list | [] | 选中行的键列表
colorGridLine | color | - | 网格线颜色
showColumnHeader | bool | true | 是否显示列头
columnHeaderTitleFont | font | - | 列头标题字体
colorColumnHeaderTitle | color | - | 列头标题颜色
colorColumnHeaderBg | color | - |  列头背景颜色
showRowHeader | bool | true | 是否显示行头
rowHeaderTitleFont | font | - | 行头标题字体
colorRowHeaderTitle | color | - | 行头标题颜色
colorRowHeaderBg | color | - | 行头背景颜色
colorResizeBlockBg | color | - | 调整头大小块(左上角方块)背景色
verScrollBar | [HusScrollBar](../Navigation/HusScrollBar.md) | - | 访问内部垂直滚动条
horScrollBar | [HusScrollBar](../Navigation/HusScrollBar.md) | - | 访问内部水平滚动条
tableView | TableView | - | 访问内部表格视图
tableModel | TableModel | - | 访问内部表格模型

<br/>

### {columns}支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
title | string | 必选 | 标题
dataIndex | string | 必选 | 数据索引
delegate | var | 必选 | 该列的单元格代理
width | int | 必选 | 该列初始宽度
minimumWidth | int | 可选 | 该列最小宽度
maximumWidth | int | 可选 | 该列最大宽度
editable | bool | 可选 | 列头标题是否可编辑
align | string | 可选 | 列头标题对齐方式, 支持 'center'丨'left'丨'right'
selectionType | string | 可选 | 该列选择类型, 支持 'checkbox'
sorter | var | 可选 | 该列排序器
sortDirections | list | 可选 | 该列排序方向, 支持 'false'丨'ascend'丨'descend'
onFilter | var | 可选 | 该列过滤器
filterInput | string | 可选 | 该列过滤输入

<br/>

### {columns.delegate}可访问属性：

属性名 | 类型 | 描述
------ | --- | ---
row | int | 行索引
column | int | 列索引
cellData | var | 单元格数据
cellIndex | int | 单元格索引
dataIndex | string | 数据索引
filterInput | string | 单元格的过滤输入

<br/>

### 支持的函数：

- `checkForRows(rows: Array)` 选中 `rows` 提供的行列表。

- `checkForKeys(keys: Array)` 选中 `keys` 提供的键列表。

- `Array getCheckedKeys()` 获取选中的键列表。

- `clearAllCheckedKeys()` 清除所有选中的键。

- `scrollToRow(row: int)` 滚动到 `row` 指定的行。

- `sort(column: int)` 排序 `column` 指定的列(该列的描述对象需要具有 `sorter` 和 `sortDirections`)。

- `clearSort()` 清除所有排序(即还原为初始状态)。

- `filter()` 使用提供的(如果有，可以多列) `onFilter` 过滤整个模型，**注意** 此函数还会确定应用了排序的列并自动进行重排。

- `clearFilter()` 清除所有过滤(即还原为初始状态)。

- `clear()` 清空所有模型数据、排序和过滤。

**注意** 以下函数仅作用于当前(排序&过滤后)的数据，不会更改 `initModel`，并且，为了最佳的性能，

需要用户自行判断是否应该重新排序&过滤(调用 `filter()` 即可)
。
- `appendRow(object: var)` 在当前模型末尾添加 `object` 行, 不会更改 `initModel`。

- `getRow(rowIndex: int): var` 获取当前模型 `rowIndex` 处的行数据。

- `setRow(rowIndex: int, object: var)` 设置当前模型 `rowIndex` 处行数据为 `object`, 不会更改 `initModel`。

- `insertRow(rowIndex: int, object: var)` 在当前模型插入行数据 `object` 到 `rowIndex` 处, 不会更改 `initModel`。

- `moveRow(fromRowIndex: int, toRowIndex: int, count: int = 1)`将 `count` 个模型数据从 `from` 位置移动到 `to` 位置, 不会更改 `initModel`。

- `removeRow(rowIndex: int, count: int = 1)` 删除当前模型 `rowIndex` 处的 `count` 条行数据, 不会更改 `initModel`。

- `getCellData(rowIndex: int, columnIndex: int): var` 获取当前模型 `(rowIndex, columnIndex)` 处的单元数据。

- `setCellData(rowIndex: int, columnIndex: int, data: var)` 设置当前模型 `(rowIndex, columnIndex)` 处的单元数据为 `data`, 不会更改 `initModel`。

- `getTableModel(): Array` 获取当前表格模型(排序&过滤后的数据)。

- `rowCount(): int` 获取当前模型的行数(排序&过滤后的数据)。

- `columnCount(): int` 获取当前模型的列数(排序&过滤后的数据)。


<br/>

## 代码演示

### 示例 1 - 基本用法

简单的表格，最后一列是各种操作。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusTableView {
        width: parent.width
        height: 200
        columns: [
            {
                title: 'Name',
                dataIndex: 'name',
                delegate: textDelegate,
                width: 200
            },
            {
                title: 'Age',
                dataIndex: 'age',
                delegate: textDelegate,
                width: 100
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
                width: 200
            },
            {
                title: 'Action',
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
```

---

### 示例 2 - 自定义选择项

通过 `columns` 对应列中的 `selectionType` 设置选择类型，目前支持 'checkbox' 多选框。

**注意** 设置多列 `selectionType` 行为未定义。

通过 `columns` 对应列中的 `editable` 设置该列头是否可编辑。

通过 `scrollToRow()` 滚动到指定行。

通过 `alternatingRow` 设置是否交替显示行背景。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    Row {
        spacing: 10

        HusIconButton {
            text: qsTr('Reload')
            type: HusButton.Type_Primary
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

        HusButton {
            text: qsTr('ScrollToRow 0')
            type: HusButton.Type_Primary
            onClicked: tableView.scrollToRow(0);
        }

        HusButton {
            text: qsTr('ScrollToRow 99')
            type: HusButton.Type_Primary
            onClicked: tableView.scrollToRow(99);
        }

        HusCheckBox {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr('Switch alternatingRow')
            onClicked: tableView.alternatingRow = checked;
        }
    }

    HusTableView {
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

    HusPagination {
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
                                name: `Edward King \${i + currentPageIndex * pageSize}`,
                                age: i % 30 + 30,
                                address: `London, Park Lane no. \${i + currentPageIndex * pageSize}`,
                                tags: ['nice', 'cool', 'loser', 'teacher', 'developer'].splice(0, i % 5 + 1),
                            }
                        });
        }
    }
}
```

---

### 示例 3 - 排序和过滤

通过 `columns` 对应列中的 `sorter` 设置排序器，其原型为 `function(a, b){}`，具体可参考 `Array.sort()` 参数。

通过 `columns` 对应列中的 `sortDirections` 设置排序方向列表，在切换排序时按数组内容指示的方向依次切换，项 `ascend` 视作升序()。

通过 `columns` 对应列中的 `onFilter` 设置过滤器，其原型为 `function(value, record){}`，`value` 为过滤输入，`record` 为当前数据记录。

**一种在外部实现自定义过滤的方式** 

- 设置 `columns` 对应列中的 `filterInput`，接着调用 `filter()` 函数即可对该列实现过滤。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusTableView {
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

    HusPagination {
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
                                name: `Edward King \${i + currentPageIndex * pageSize}`,
                                age: i % 30 + 30,
                                address: `London, Park Lane no. \${i + currentPageIndex * pageSize}`,
                                tags: ['nice', 'cool', 'loser', 'teacher', 'developer'].splice(0, i % 5 + 1),
                            }
                        });
        }
    }
}
```

---

### 示例 4 - 从C++中导入数据

通常来说，大多数人从 C++ 创建和处理数据。

有一种相当简单的方式将数据从 C++ 导入到 Qml 环境：

1. 使用 QVariant 包装你的数据结构。

```c++
    struct MyData {
        QString name;
        int age;
        QVariantMap toVariant() {
            QVariantMap var;
            var["name"] = myData.name;
            var["age"] = myData.age;
            return var;
        }
    };
```

2. 提供访问你的数据集接口，类型可以是 QVariant/QVariantList/QVariantMap。

```c++
    Q_INVOKABLE QVariantList getMyDataList() {
        MyData myData;
        QVariantList list;
        list.append(data.toVariant());
        return list;
    }
```

3. 在 Qml 中直接访问该数据集并赋值给 HusTableView.initModel。

```auto
    HusTableView {
        Component.onCompleted: {
            initModel = getMyDataList();
        }
    }
```

4. **注意** 使用 HusTableView 提供的接口操作数据(增删查改)。

**更详细的说明请参考官方文档：**

- [QML 和 C++ 之间的数据类型转换](https://doc.qt.io/qt-6/zh/qtqml-cppintegration-data.html)


```qml
import QtQuick
import HuskarUI.Basic
import Gallery

Column {
    spacing: 10
    width: parent.width

    HusButton {
        text: qsTr('Import 10 pieces data from C++')
        type: HusButton.Type_Primary
        onClicked: {
            const list = DataGenerator.genTableData(10);
            for (const object of list) {
                cppTableView.appendRow(object);
            }
        }
    }

    HusTableView {
        id: cppTableView
        width: parent.width
        height: 400
        columns: [
            {
                title: 'Name',
                dataIndex: 'name',
                delegate: textDelegate,
                width: 200
            },
            {
                title: 'Age',
                dataIndex: 'age',
                delegate: textDelegate,
                width: 100
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
                width: 200
            },
            {
                title: 'Action',
                dataIndex: 'action',
                delegate: actionDelegate,
                width: 300
            }
        ]

        Component.onCompleted: {
            initModel = DataGenerator.genTableData(10);
        }
    }
}
```


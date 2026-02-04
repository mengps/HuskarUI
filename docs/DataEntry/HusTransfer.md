[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusTransfer 穿梭框 


双栏穿梭选择框。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **titleDelegate: Component** 标题代理，代理可访问属性：

  - `title: string` 标题文本

- **searchInputDelegate: Component** 搜索输入框代理。

- **leftActionDelegate: Component** 向左动作代理。

- **rightActionDelegate: Component** 向右动作代理。

- **emptyDelegate: Component** 空状态代理。


<br/>

### 支持的属性：

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
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角
sourceTableView | [HusTableView](../DataDisplay/HusTableView.md) | - | 访问内部左侧表格视图
targetTableView | [HusTableView](../DataDisplay/HusTableView.md) | - | 访问内部右侧表格视图

<br/>

### {dataSource}支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
key | string | 必选 | 数据键
title | string | 必选 | 标题
enabled | bool | 可选 | 是否启用

<br/>

### 支持的函数：

- `clearAllCheckedKeys(direction: string = 'left')` 清除 `direction` 指定方向的所有选中键。

- `filter(text: string, direction: string = 'left')` 使用 `text` 对 `direction` 指定方向的数据执行过滤。


<br/>

### 支持的信号：

- `change(nextTargetKeys: var, direction: string, moveKeys: var)` 选项在两栏之间转移时发出


<br/>

## 代码演示

### 示例 1 - 基本用法

最基本的用法，展示了 `dataSource`、`targetKeys`、`defaultTargetCheckedKeys` 的用法。


```qml
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
```

---

### 示例 2 - 带搜索框

通过 `showSearch` 设置为 `true` 显示搜索框。

通过 `filterOption` 设置过滤选项，它是形如：`function(value: string, record: var): bool { }` 的函数。


```qml
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
```

---

### 示例 3 - 分页

大数据下使用分页。

通过 `pagination` 设置为 `object` 显示为分页格式。

`pagination` 对象支持的属性有：

- defaultButtonSpacing 按钮间隔。

- pageSize 每页数量。

- pageButtonMaxCount 最大页按钮数。

- showQuickJumper 是否显示快速跳转。

详细说明见 [HusPagination](../Navigation/HusPagination.md)。


```qml
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
```


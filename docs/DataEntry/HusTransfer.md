[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusTransfer 穿梭框 


双栏穿梭选择框。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **leftActionDelegate: Component** 向左动作代理。

- **rightActionDelegate: Component** 向右动作代理。


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
dataSource | array | [] | 数据源
sourceKeys | array(readonly) | [] | 左侧框数据的 key 集合
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
oneWay | bool | false | 是否单向穿梭
colorTitle | color | - | 标题颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 背景边框色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角
radiusTransferBg | [HusRadius](../General/HusRadius.md) | - | 穿梭框背景圆角
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
        defaultTargetCheckedKeys: ['1']
        onChange: (nextTargetKeys, direction, moveKeys) => targetKeys = nextTargetKeys;
    }
}
```

---

### 示例 2 - 带搜索框

通过 `showSearch` 为 `true` 显示搜索框。

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
        onChange: (nextTargetKeys, direction, moveKeys) => targetKeys = nextTargetKeys;
    }
}
```


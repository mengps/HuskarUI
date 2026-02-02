[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusBreadcrumb 面包屑


显示当前页面在系统层级结构中的位置，并能向上返回。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **itemDelegate: Component** 路由项代理，代理可访问属性：

  - `index: int` 当前项索引

  - `model: var` 当前项数据

  - `isCurrent: bool` 是否为当前路由

- **separatorDelegate: Component** 分隔符代理，代理可访问属性：

  - `index: int` 当前项索引

  - `model: var` 当前项数据

  - `isCurrent: bool` 是否为当前路由


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
initModel | array | [] | 初始模型
separator | string | '/' | 默认分隔符
titleFont | font | - | 路由项标题字体
defaultIconSize | int | - | 默认图标大小
defaultMenuWidth | int | 120 | 默认菜单宽度
radiusItemBg | [HusRadius](../General/HusRadius.md) | - | 路由项的背景圆角半径

<br/>

### 模型支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
title | string | 必选 | 标题
key | string | 可选 | 路由键(最好唯一)
iconSource | int | 可选 | 本路由项图标源(来自HusIcon)
iconUrl | url | 可选 | 本路由项链接
iconSize | int | 可选 | 本路由项图标大小
loading | bool | 可选 | 本路由项是否加载中
separator | string | 可选 | 本路由项分隔符
itemDelegate | var | 可选 | 本路由项图标代理(将覆盖默认itemDelegate)
separatorDelegate | var | 可选 | 本路由项分隔符代理(将覆盖默separatorDelegate)
menu | object | 可选 | 本路由项菜单

<br/>

### 路由项菜单支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
width | string | 可选 | 菜单宽度
items | array | 可选 | 菜单模型

<br/>

### 支持的函数：

- `get(index: int): Object` 获取 `index` 处的模型数据 

- `set(index: int, object: Object)` 设置 `index` 处的模型数据为 `object` 

- `setProperty(index: int, propertyName: string, value: any)` 设置 `index` 处的模型数据属性名 `propertyName` 值为 `value` 

- `move(from: int, to: int, count: int = 1)` 将 `count` 个模型数据从 `from` 位置移动到 `to` 位置 

- `insert(index: int, object: Object)` 插入标签 `object` 到 `index` 处 

- `append(object: Object)` 在末尾添加标签 `object` 

- `remove(index: int, count: int = 1)` 删除 `index` 处 `count` 个模型数据 

- `clear()` 清空所有模型数据 

- `string getPath()` 获取当前路由路径 


<br/>

### 支持的信号：

- `click(index: int, data: var)` 点击路由项时发出

  - `index` 路由项索引

  - `data` 路由项数据

- `clickMenu(deep: int, key: string, keyPath: var, data: var)` 点击任意路由-菜单项时发出

  - `deep` 菜单项深度

  - `key` 菜单项的键

  - `keyPath` 菜单项的键路径数组

  - `data` 菜单项数据


<br/>

## 代码演示

### 示例 1 - 基本

最简单的用法。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusButton {
        text: 'Reset'
        type: HusButton.Type_Primary
        onClicked: breadcrumb.reset();
    }

    HusBreadcrumb {
        id: breadcrumb
        width: parent.width
        initModel: [
            { title: 'Home' },
            { title: 'Application Center' },
            { title: 'Application List' },
            { title: 'An Application', },
        ]
        onClick: (index, data) => remove(index + 1, count - index - 1);
    }
}
```

---

### 示例 2 - 带有图标的

通过 `iconSource` 将图标放在文字前面, 如果设置了 `loading`, 则显示为加载中。

```qml
import QtQuick
import HuskarUI.Basic

HusBreadcrumb {
    width: parent.width
    initModel: [
        { iconSource: HusIcon.HomeOutlined },
        { iconSource: HusIcon.UserOutlined, title: 'Application List' },
        { loading: true, title: 'Application', },
    ]
}
```

---

### 示例 3 - 分隔符

通过 `separator` 属性设置分隔符。

```qml
import QtQuick
import HuskarUI.Basic

HusBreadcrumb {
    width: parent.width
    separator: '>'
    initModel: [
        { title: 'Home' },
        { title: 'Application Center' },
        { title: 'Application List' },
        { title: 'An Application', },
    ]
}
```

---

### 示例 4 - 独立的分隔符

通过 `model.separator` 属性自定义单独的分隔符。

```qml
import QtQuick
import HuskarUI.Basic

HusBreadcrumb {
    width: parent.width
    initModel: [
        { title: 'Location', separator: ':' },
        { title: 'Application Center' },
        { title: 'Application List' },
        { title: 'An Application', },
    ]
}
```

---

### 示例 5 - 带下拉菜单的面包屑

面包屑支持下拉菜单。

通过 `model.menu` 属性设置为菜单即 [HusContextMenu](./HusContextMenu.md)。

通过 `model.menu.items` 属性设置菜单列表{即 `HusContextMenu` 的 `initModel` }。

通过 `model.menu.width` 属性设置菜单的宽度：


```qml
import QtQuick
import HuskarUI.Basic

HusBreadcrumb {
    width: parent.width
    initModel: [
        { title: 'HuskarUI'  },
        { title: 'Component' },
        {
            title: 'General',
            menu: {
                items: [
                    { label: 'General' },
                    { label: 'Layout' },
                    { label: 'Navigation' },
                ]
            }
        },
        { title: 'Button' },
    ]
}
```


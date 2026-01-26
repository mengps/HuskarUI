[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusMenu 菜单


为页面和功能提供导航的菜单列表。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **menuIconDelegate: Component** 菜单图标代理，代理可访问属性：

  - `model: var` 本菜单数据(访问错误则使用 `parent.model`)

  - `menuButton: var` 菜单按钮(访问错误则使用 `parent.menuButton`)

- **menuLabelDelegate: Component** 菜单标签代理，代理可访问属性：

  - `model: var` 本菜单数据(访问错误则使用 `parent.model`)

  - `menuButton: var` 菜单按钮(访问错误则使用 `parent.menuButton`)

- **menuBgDelegate: Component** 菜单背景代理，代理可访问属性：

  - `model: var` 本菜单数据(访问错误则使用 `parent.model`)

  - `menuButton: var` 菜单按钮(访问错误则使用 `parent.menuButton`)

- **menuContentDelegate: Component** 菜单内容代理，代理可访问属性：

  - `model: var` 本菜单数据(访问错误则使用 `parent.model`)

  - `menuButton: var` 菜单按钮(访问错误则使用 `parent.menuButton`)


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
contentDescription | string | '' | 内容描述(提高可用性)
showEdge | bool | false | 是否显示边线
showToolTip | bool | false | 是否显示工具提示
compactMode | enum | HusMenu.Mode_Relaxed | 紧凑模式
compactWidth | int | - | 紧凑模式宽度
popupMode | bool | false | 是否为弹出模式
popupWidth | int | 200 | 弹窗宽度
popupOffset | int | 4 | 弹窗之间的偏移
popupMaxHeight | int | - | 弹窗最大高度
defaultMenuIconSize | int | - | 默认菜单图标大小
defaultMenuIconSpacing | int | 8 | 默认菜单图标间隔
defaultMenuWidth | int | 300 | 默认菜单宽度
defaultMenuTopPadding | int | 10 | 默认菜单上边距
defaultMenuBottomPadding | int | 10 | 默认菜单下边距
defaultMenuSpacing | int | 4 | 默认菜单间隔
defaultSelectedKey | list | [] | 初始选中的菜单项 key 数组
selectedKey | string | '' | 当前选中的菜单 key
initModel | list | [] | 初始菜单模型
radiusMenuBg | [HusRadius](../General/HusRadius.md) | - | 菜单项背景圆角
radiusPopupBg | [HusRadius](../General/HusRadius.md) | - | 弹窗背景圆角
scrollBar | [HusScrollBar](./HusScrollBar.md) | - | 访问内部菜单滚动条

<br/>

### 模型支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
key | string | 可选 | 菜单键(最好唯一)
label | sting | 必选 | 菜单标签
shortLabel | sting | 可选 | 菜单短标签(compactMode == HusMenu.Mode_Standard 时使用, 没有则为label)
type | sting | 可选 | 菜单项类型
enabled | bool | 可选 | 是否启用(false则禁用本菜单项)
iconSize | int | 可选 | 图标大小
iconSource | int | 可选 | 图标源
iconSpacing | int | 可选 | 图标间隔
menuChildren | list | 可选 | 子菜单(支持无限嵌套)
iconDelegate | var | 可选 | 本菜单项图标代理(将覆盖menuIconDelegate)
labelDelegate | var | 可选 | 本菜单项标签代理(将覆盖menuLabelDelegate)
contentDelegate | var | 可选 | 本菜单项内容代理(将覆盖menuContentDelegate)
bgDelegate | var | 可选 | 本菜单项背景代理(将覆盖menuBgDelegate)

 `iconDelegate` | `labelDelegate` | `contentDelegate` | `bgDelegate` 可访问属性：

- **model: var** 模型数据(访问错误则使用 `parent.model`)

- **menuButton: HusButton** 自身菜单按钮(访问错误则使用 `parent.menuButton`)，可访问的属性：

  - model: var 本菜单模型

  - menuDeep: int 本菜单深度

  - iconSource: int 图标源

  - iconSize: int 图标大小

  - iconSpacing: int 图标间隔

  - expanded: int 是否展开

  - isCurrent: int 是否为当前选择菜单

  - isGroup: int 是否为组菜单


<br/>

### 支持的函数：

- `gotoMenu(key: string)` 跳转到菜单键为 `key` 处的菜单项 

- `get(index: int): Object` 获取 `index` 处的模型数据 

- `set(index: int, object: Object)` 设置 `index` 处的模型数据为 `object` 

- `setProperty(index: int, propertyName: string, value: any)` 设置 `index` 处的模型数据属性名 `propertyName` 值为 `value` 

- `setData(key: string, data: var)` 将菜单键为 `key` 处的菜单项数据设置为 `data` 

- `setDataProperty(key: string, propertyName: string, value: var)` 设置菜单键为 `key` 处的菜单项数据属性名 `propertyName` 的值为 `value` 

- `move(from: int, to: int, count: int = 1)` 将 `count` 个模型数据从 `from` 位置移动到 `to` 位置 

- `insert(index: int, object: Object)` 插入菜单 `object` 到 `index` 处 

- `append(object: Object)` 在末尾添加菜单 `object` 

- `remove(index: int, count: int = 1)` 删除 `index` 处 `count` 个模型数据 

- `clear()` 清空所有模型数据 


<br/>

### 支持的信号：

- `clickMenu(deep: int, key: string, keyPath: var, data: var)` 点击任意菜单项时发出

  - `deep` 菜单项深度

  - `key` 菜单项的键

  - `keyPath` 菜单项的键路径数组

  - `data` 菜单项数据


<br/>

## 代码演示

### 示例 1 - 基本用法

通过 `initModel` 属性设置初始菜单模型{需为list}，菜单项支持的属性有：

- { key: 菜单键(最好唯一) }

- { label: 标题 }

- { shortLabel: 短标题 }

- { type: 类型 }

- { enabled: 是否启用(false则禁用该菜单项) }

- { iconSize: 图标大小 }

- { iconSource: 图标源 }

- { iconSpacing: 图标间隔 }

- { menuChildren: 子菜单(支持无限嵌套) }

- { contentDelegate: 该菜单项内容代理 }

菜单项 `type` 支持：

- 'item' { 普通菜单项(默认) }

- 'group' { 组菜单项 }

- 'divider' { 此菜单项为分隔器 }

点击任意菜单项将发出 `clickMenu(deep, key, keyPath, data)` 信号。

```qml
import QtQuick
import HuskarUI.Basic

Item {
    width: parent.width
    height: 200

    HusButton {
        text: qsTr('添加')
        anchors.right: parent.right
        onClicked: menu.append({
                                    label: qsTr('Test'),
                                    iconSource: HusIcon.HomeOutlined,
                                    contentDelegate: myContentDelegate
                               });
    }

    HusMenu {
        id: menu
        height: parent.height
        initModel: [
            {
                label: qsTr('首页1'),
                iconSource: HusIcon.HomeOutlined
            },
            {
                label: qsTr('首页2'),
                iconSource: HusIcon.HomeOutlined,
                menuChildren: [
                    {
                        label: qsTr('首页2-1'),
                        iconSource: HusIcon.HomeOutlined,
                        menuChildren: [
                            {
                                label: qsTr('首页2-1-1'),
                                iconSource: HusIcon.HomeOutlined,
                                contentDelegate: myContentDelegate
                            }
                        ]
                    }
                ]
            },
            {
                label: qsTr('首页3'),
                iconSource: HusIcon.HomeOutlined,
                enabled: false
            }
        ]
    }
}
```

---

### 示例 2 - 弹出形式

通过 `popupMode` 属性设置菜单为弹出模式。

通过 `popupWidth` 属性设置弹窗的宽度。

通过 `popupMaxHeight` 属性设置弹窗的最大高度(最小高度是自动计算的)。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusRadioBlock {
        id: popupModeRadio
        initCheckedIndex: 0
        model: [
            { label: qsTr('默认模式'), value: false },
            { label: qsTr('弹出模式'), value: true }
        ]
    }

    HusMenu {
        height: 250
        popupMode: popupModeRadio.currentCheckedValue
        popupWidth: 150
        initModel: [
            {
                label: qsTr('首页1'),
                iconSource: HusIcon.HomeOutlined
            },
            {
                label: qsTr('首页2'),
                iconSource: HusIcon.HomeOutlined,
                menuChildren: [
                    {
                        label: qsTr('首页2-1'),
                        iconSource: HusIcon.HomeOutlined,
                        menuChildren: [
                            {
                                label: qsTr('首页2-1-1'),
                                iconSource: HusIcon.HomeOutlined
                            }
                        ]
                    },
                    {
                        label: qsTr('首页2-2'),
                        iconSource: HusIcon.HomeOutlined,
                        menuChildren: [
                            {
                                label: qsTr('首页2-2-1'),
                                iconSource: HusIcon.HomeOutlined
                            }
                        ]
                    }
                ]
            },
            {
                label: qsTr('首页3'),
                iconSource: HusIcon.HomeOutlined,
                menuChildren: [
                    {
                        label: qsTr('首页3-1'),
                        iconSource: HusIcon.HomeOutlined,
                        menuChildren: [
                            {
                                label: qsTr('首页3-1-1'),
                                iconSource: HusIcon.HomeOutlined
                            }
                        ]
                    }
                ]
            }
        ]
    }
}
```

---

### 示例 3 - 紧凑模式

通过 `compactMode` 属性设置菜单的紧凑模式，支持的模式：

- 宽松模式(默认){ HusMenu.Mode_Relaxed }

- 标准模式{ HusMenu.Mode_Standard }

- 紧凑模式{ HusMenu.Mode_Compact }

通过 `compactWidth` 属性设置紧凑模式的宽度(默认无需设置)。

通过 `popupWidth` 属性设置弹窗的宽度。

通过 `popupMaxHeight` 属性设置弹窗的最大高度(最小高度是自动计算的)。

**注意** 设置非宽松模式则自动变为弹出模式。

**注意** 使用 `defaultMenuWidth` 来设置宽度。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusRadioBlock {
        id: compactModeRadio
        initCheckedIndex: 0
        model: [
            { label: qsTr('宽松模式'), value: HusMenu.Mode_Relaxed },
            { label: qsTr('标准模式'), value: HusMenu.Mode_Standard },
            { label: qsTr('紧凑模式'), value: HusMenu.Mode_Compact }
        ]
    }

    HusMenu {
        height: 250
        compactMode: compactModeRadio.currentCheckedValue
        popupWidth: 150
        initModel: [
            {
                label: qsTr('首页1'),
                shortLabel: qsTr('1'),
                iconSource: HusIcon.HomeOutlined
            },
            {
                label: qsTr('首页2'),
                shortLabel: qsTr('2'),
                iconSource: HusIcon.HomeOutlined,
                menuChildren: [
                    {
                        label: qsTr('首页2-1'),
                        iconSource: HusIcon.HomeOutlined,
                        menuChildren: [
                            {
                                label: qsTr('首页2-1-1'),
                                iconSource: HusIcon.HomeOutlined
                            }
                        ]
                    },
                    {
                        label: qsTr('首页2-2'),
                        iconSource: HusIcon.HomeOutlined,
                        menuChildren: [
                            {
                                label: qsTr('首页2-2-1'),
                                iconSource: HusIcon.HomeOutlined
                            }
                        ]
                    }
                ]
            },
            {
                label: qsTr('首页3'),
                shortLabel: qsTr('3'),
                iconSource: HusIcon.HomeOutlined,
                menuChildren: [
                    {
                        label: qsTr('首页3-1'),
                        iconSource: HusIcon.HomeOutlined,
                        menuChildren: [
                            {
                                label: qsTr('首页3-1-1'),
                                iconSource: HusIcon.HomeOutlined
                            }
                        ]
                    }
                ]
            }
        ]
    }
}
```


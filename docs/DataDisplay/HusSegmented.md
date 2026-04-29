[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusSegmented 分段控制器 


用于展示多个选项并允许用户选择其中单个选项。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **indicatorDelegate: Component** 指示器代理。

- **itemDelegate: Component** 项代理，代理可访问属性：

  - `index: int` 模型数据索引

  - `model: var` 模型数据

  - `pressed: bool` 是否按下

  - `hovered: bool` 是否悬浮

  - `isCurrent: bool` 是否为当前项

- **iconDelegate: Component** 内容代理，代理可访问属性：

  - `index: int` 模型数据索引

  - `model: var` 模型数据

  - `pressed: bool` 是否按下

  - `hovered: bool` 是否悬浮

  - `isCurrent: bool` 是否为当前项

- **toolTipDelegate: Component** 文本提示代理，代理可访问属性：

  - `index: int` 模型数据索引

  - `model: var` 模型数据

  - `pressed: bool` 是否按下

  - `hovered: bool` 是否悬浮

  - `isCurrent: bool` 是否为当前项


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
options | array | [] | 选项模型列表
currentIndex | int | 0 | 当前索引
currentValue | var(readonly) | - | 当前值
count | int(readonly) | - | 选项数量
block | bool | false | 是否填充父元素整行
orientation | enum | Qt.Horizontal | 方向(来自 Qt.*)
defaultItemHeight | real | 26 | 默认项高度
iconSpacing | int | 5 | 图标间隔
iconFont | font | - | 图标字体
colorBg | color | - | 背景颜色
colorIndicatorBg | color | - | 指示器颜色
colorBorder | color | - | 边框颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角
sizeHint | string | 'normal' | 尺寸提示

<br/>

### 选项支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | string | 必选 | 标签文本
value | var | 可选 | 值(默认为label)
enabled | bool | 可选 | 是否启用
toolTip | string | 可选 | 文本提示
iconSource | int丨string | 可选 | 本标签的图标源

<br/>

### 支持的函数：

- `get(index: int): Object` 获取 `index` 处的选项数据 

- `set(index: int, object: Object)` 设置 `index` 处的选项数据为 `object` 

- `setProperty(index: int, propertyName: string, value: any)` 设置 `index` 处的选项数据属性名 `propertyName` 值为 `value` 

- `move(from: int, to: int, count: int = 1)` 将 `count` 个选项数据从 `from` 位置移动到 `to` 位置 

- `insert(index: int, object: Object)` 插入选项 `object` 到 `index` 处 

- `append(object: Object)` 在末尾添加选项 `object` 

- `remove(index: int, count: int = 1)` 删除 `index` 处 `count` 个选项数据 

- `clear()` 清空所有选项数据 


<br/>

<br/>

## 代码演示

### 示例 1 - 基本

最简单的用法。

通过 `options` 属性设置选项数据，数据项可以为字符串。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusRadioBlock {
        id: sizeHintRadio
        initCheckedIndex: 1
        model: [
            { label: 'Small', value: 'small' },
            { label: 'Normal', value: 'normal' },
            { label: 'Large', value: 'large' },
        ]
    }

    HusSegmented {
        sizeHint: sizeHintRadio.currentCheckedValue
        options: ['Daily', 'Weekly', 'Monthly', 'Quarterly', 'Yearly']
    }

    HusSegmented {
        sizeHint: sizeHintRadio.currentCheckedValue
        options: [
            { label: 'List', value: 'List', iconSource: HusIcon.BarsOutlined },
            { label: 'Kanban', value: 'Kanban', iconSource: HusIcon.AppstoreOutlined }
        ]
    }
}
```

---

### 示例 2 - 垂直方向

通过 `orientation` 属性改变方向，支持的方向：

- 水平方向(默认){ Qt.Horizontal }

- 垂直方向{ Qt.Vertical }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSegmented {
        id: customSegmented
        width: 100
        colorBorder: '#77BEF0'
        orientation: Qt.Vertical
        options: [
            {
                label: 'Boost ',
                toolTip: 'Boost',
                iconSource: HusIcon.RocketOutlined,
            },
            {
                label: 'Stream',
                toolTip: 'Stream',
                iconSource: HusIcon.ThunderboltOutlined,
            },
            {
                label: 'Cloud ',
                toolTip: 'Cloud',
                iconSource: HusIcon.CloudOutlined,
            }
        ]
        iconDelegate: HusIconText {
            font: customSegmented.iconFont
            colorIcon: '#77BEF0'
            iconSource: model.iconSource
        }
    }
}
```

---

### 示例 3 - 填充整行

通过 `block` 属性使其填充父元素宽度。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSegmented {
        block: true
        options: [123, 456, 'longtext-longtext-longtext-longtext']
    }
}
```

---

### 示例 4 - 启用/禁用

通过 `options.enabled` 属性启用/禁用项。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSegmented {
        enabled: false
        options: ['Map', 'Transit', 'Satellite']
    }

    HusSegmented {
        options: [
            'Daily',
            { label: 'Weekly', value: 'Weekly', enabled: false },
            'Monthly',
            { label: 'Quarterly', value: 'Quarterly', enabled: false },
            'Yearly',
        ]
    }
}
```

---

### 示例 5 - 胶囊形状

胶囊型的 HusSegmented。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSegmented {
        options: ['small', 'middle', 'large']
    }

    HusSegmented {
        options: [
            { iconSource: HusIcon.SunOutlined },
            { iconSource: HusIcon.MoonOutlined },
        ]
        radiusBg.all: height * 0.5
    }
}
```


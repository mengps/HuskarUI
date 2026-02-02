[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusRadioBlock 单选块(HusRadio变种) 


用于在多个备选项中选中单个状态。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **toolTipDelegate: Component** 文字提示代理，代理可访问属性：

  - `checked: int` 是否选中

  - `pressed: int` 是否按下

  - `hovered: int` 是否悬浮

  - `toolTip: var` 文字提示数据

- **radioDelegate: Component** 单选项代理，代理可访问属性：

  - `index: int` 单选项索引

  - `modelData: var` 单选项数据


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
effectEnabled | bool | true | 是否开启点击效果
hoverCursorShape | enum |  Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
model | array | [] | 单选块模型
count | int | model.length | 单选数量
initCheckedIndex | int | -1 | 初始选择的单选项索引
currentCheckedIndex | int | -1 | 当前选择的单选项索引
currentCheckedValue | var | undefined | 当前选择的单选项的值
type | enum | HusRadioBlock.Type_Filled | 单选项类型(来自 HusRadioBlock)
size | enum | HusRadioBlock.Size_Auto | 单选项大小(来自 HusRadioBlock)
radioWidth | int | 120 | 单选项宽度(size == HusRadioBlock.Size_Fixed 生效)
radioHeight | int | 30 | 单选项高度(size == HusRadioBlock.Size_Fixed 生效)
radiusBg | [HusRadius](../General/HusRadius.md) | - | 单选项背景圆角
contentDescription | string | '' | 内容描述(提高可用性)

<br/>

### 模型支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | string | 必选 | 本单选项的标签
value | sting | 可选 | 本单选项的值
enabled | var | 可选 | 本单选项是否启用
iconSource | int丨string | 可选 | 本按钮图标(参见 HusIcon)或图标链接
toolTip | var | 可选 | 存在时则创建文字提示
toolTip.text | string | 可选 | 存在时则创建文字提示
toolTip.delay | int | 可选 | 文字提示延时(ms)
toolTip.timeout | int | 可选 | 文字提示超时(ms)

<br/>

### 支持的信号：

- `clicked(index: int, radioData: var)` 点击单选项时发出

  - `index` 单选项索引

  - `radioData` 单选项数据


<br/>

## 代码演示

### 示例 1

通过 `model` 属性设置初始单选块的模型，单选项支持的属性：

- { label: 本单选项的标签 }

- { value: 本单选项的值 }

- { enabled: 本单选项是否启用 }

- { iconSource: 本单选项图标 }

通过 `type` 属性设置单选块的类型，支持的类型：

- 填充样式的按钮(默认) { HusRadioBlock.Type_Filled }

- 线框样式的按钮(无填充) { HusRadioBlock.Type_Outlined }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusRadioBlock {
        initCheckedIndex: 0
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear' },
            { label: 'Orange', value: 'Orange' },
            { iconSource: HusIcon.QuestionOutlined, value: 'Orange' },
        ]
    }

    HusRadioBlock {
        initCheckedIndex: 1
        type: HusRadioBlock.Type_Outlined
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear' },
            { label: 'Orange', value: 'Orange' },
            { iconSource: HusIcon.QuestionOutlined, value: 'Orange' },
        ]
    }

    HusRadioBlock {
        initCheckedIndex: 2
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear', enabled: false },
            { label: 'Orange', value: 'Orange' },
        ]
    }

    HusRadioBlock {
        enabled: false
        initCheckedIndex: 2
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear', enabled: false },
            { label: 'Orange', value: 'Orange' },
        ]
    }
}
```

---

### 示例 2

通过 `size` 属性设置单选块调整大小的模式，支持的大小：

- 自动计算大小(默认) { HusRadioBlock.Size_Auto }

- 固定大小(将使用radioWidth/radioHeight) { HusRadioBlock.Size_Fixed }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusRadioBlock {
        initCheckedIndex: 0
        size: HusRadioBlock.Size_Fixed
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear' },
            { label: 'Orange', value: 'Orange' },
        ]
    }

    HusRadioBlock {
        initCheckedIndex: 0
        size: HusRadioBlock.Size_Auto
        type: HusRadioBlock.Type_Outlined
        model: [
            { label: 'Apple', value: 'Apple' },
            { label: 'Pear', value: 'Pear' },
            { label: 'Orange', value: 'Orange' },
        ]
    }
}
```


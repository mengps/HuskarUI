[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusInputInteger 整数输入框 


通过鼠标或键盘，输入范围内的整数。

* **模块 { HuskarUI.Basic }**

* **继承自 { SpinBox }**


<br/>

### 支持的代理：

- **beforeDelegate: Component** 前置标签代理

- **afterDelegate: Component** 后置标签代理

- **handlerDelegate: Component** 增减按钮代理

- **bgDelegate: Component** 背景代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画
active | bool | - | 是否处于激活状态
showShadow | bool | false | 是否显示阴影
type | enum | HusInput.Type_Outlined | 输入框形态类型(来自 HusInput)
clearEnabled | bool丨'active' | false | 是否启用清除按钮(active-仅当激活状态下可见)
clearIconSource | int丨string | HusIcon.CloseCircleFilled | 清除图标源(来自 HusIcon)或图标链接
clearIconSize | int | - | 清除图标大小
clearIconPosition | enum | HusInput.Position_Right | 清除图标位置(来自 HusInput)
readOnly | bool | false | 输入框是否只读
showHandler | bool | true | 是否显示增减按钮
alwaysShowHandler | bool | false | 是否始终显示增减按钮
useWheel | bool | false | 是否使用鼠标滚轮控制
useKeyboard | bool | true | 是否使用键盘控制
value | int | 0 | 当前值
min | int | INT_MIN | 最小值
max | int | INT_MAX | 最大值
step | int | 1 | 增减步长
prefix | string | '' | 前缀文本(图标)
suffix | string | '' | 后缀文本(图标)
upIcon | int丨string | HusIcon.UpOutlined | 增按钮图标
downIcon | int丨string  | HusIcon.DownOutlined | 减按钮图标
inputFont | font | - | 输入框字体
labelFont | font | 'HuskarUI-Icons' | 前置后置标签字体
beforeLabel | sting丨list | '' | 前置标签(列表)
afterLabel | sting丨list | '' | 后置标签(列表)
initBeforeLabelIndex | int | 0 | 初始前置列表索引
initAfterLabelIndex | int | 0 | 初始后置列表索引
currentBeforeLabel | sting | '' | 当前前置标签
currentAfterLabel | sting | '' | 当前后置标签
formatter | function | - | 格式化器(格式化数值为字符串)
parser | function | - | 解析器(解析字符串为数值)
defaultHandlerWidth | int | 22 | 默认增减按钮宽度
colorText | color | - | 文本颜色
colorBg | color | - | 背景颜色
colorShadow | color | - | 阴影颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角
sizeHint | string | 'normal' | 尺寸提示
input | [HusInput](./HusInput.md) | - | 访问内部输入框

<br/>

### 支持的信号：

- `beforeActivated(index: int, var data)` 当前置为列表时，点击选择项发出

  - `index` 选择项索引

  - `data` 选择项数据

- `afterActivated(index: int, var data)` 当后置为列表时，点击选择项发出

  - `index` 选择项索引

  - `data` 选择项数据


<br/>

### 支持的函数：

- `getFullText(): string` 获取完整输入文本 

以下函数来自 `TextInput`，具体请查阅官方文档：

- `select(start: int, end: int)` 

- `selectAll(start: int, end: int)` 

- `selectWord(start: int, end: int)` 

- `clear()` 

- `copy()` 

- `cut()` 

- `paste()` 

- `redo()` 

- `undo()` 


<br/>

## 代码演示

### 示例 1 - 基本

数字输入框。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSwitch {
        id: shadowSwitch
        checked: false
        text: 'Show shadow: '
    }

    HusInputInteger {
        width: 150
        min: 0
        max: 10
        clearEnabled: true
        showShadow: shadowSwitch.checked
    }

    HusInputInteger {
        width: 150
        min: 0
        max: 10
        type: HusInput.Type_Outlined
        showShadow: shadowSwitch.checked
    }

    HusInputInteger {
        width: 150
        min: 0
        max: 10
        type: HusInput.Type_Dashed
        showShadow: shadowSwitch.checked
    }

    HusInputInteger {
        width: 150
        min: 0
        max: 10
        type: HusInput.Type_Borderless
        showShadow: shadowSwitch.checked
    }

    HusInputInteger {
        width: 150
        min: 0
        max: 10
        type: HusInput.Type_Underlined
        showShadow: shadowSwitch.checked
    }

    HusInputInteger {
        width: 150
        min: 0
        max: 10
        type: HusInput.Type_Filled
        showShadow: shadowSwitch.checked
    }
}
```

---

### 示例 2 - 前置/后置标签

用于配置一些固定组合。

通过 `beforeLabel` / `afterLabel` 属性设置前置/后置标签，支持 `string | list`，为数组时则创建为 [HusSelect](./HusSelect.md)。

通过 `currentBeforeLabel` / `currentAfterLabel` 属性获取当前前置/后置标签。


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

    HusInputInteger {
        width: 240
        value: 100
        beforeLabel: '+'
        afterLabel: '$'
        sizeHint: sizeHintRadio.currentCheckedValue
    }

    HusInputInteger {
        width: 240
        value: 100
        beforeLabel: [
            { label: '+', value: 'add' },
            { label: '-', value: 'minus' },
        ]
        afterLabel: [
            { label: '$', value: 'USD' },
            { label: '€', value: 'EUR' },
            { label: '£', value: 'GBP' },
            { label: '¥', value: 'CNY' },
        ]
        prefix: currentAfterLabel
        sizeHint: sizeHintRadio.currentCheckedValue
    }

    HusInputInteger {
        width: 240
        value: 100
        afterLabel: String.fromCharCode(HusIcon.SettingOutlined)
        sizeHint: sizeHintRadio.currentCheckedValue
    }

    HusInputInteger {
        enabled: false
        width: 240
        value: 100
        beforeLabel: [
            { label: '+', value: 'add' },
            { label: '-', value: 'minus' },
        ]
        sizeHint: sizeHintRadio.currentCheckedValue
    }

    HusInputInteger {
        enabled: false
        width: 240
        value: 100
        beforeLabel: [
            { label: '+', value: 'add' },
            { label: '-', value: 'minus' },
        ]
        afterLabel: String.fromCharCode(HusIcon.SettingOutlined)
        prefix: '¥'
        suffix: 'RMB'
        sizeHint: sizeHintRadio.currentCheckedValue
    }
}
```

---

### 示例 3 - 格式化展示

通过 `formatter` 格式化数值为字符串，以展示具有具体含义的数据，往往需要配合 `parser` 一起使用。

通过 `parser` 解析字符串为数值，以内部能够正确处理数值，往往需要配合 `formatter` 一起使用。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusInputInteger {
        width: 200
        value: 1000
        formatter: (value) => '$ ' + String(value).replace(/(\d)(?=(\d{3})+(?!\d))/g, '\$1,')
        parser: (text) => text.replace(/\$\s?|(,*)/g, '')
    }

    HusInputInteger {
        width: 200
        value: 50
        min: 0
        max: 100
        formatter: (value) => value + '%'
        parser: (text) => text.replace('%', '')
    }
}
```

---

### 示例 4 - 前缀/后缀

通过 `prefix` / `suffix` 属性设置前缀/后缀字符串(或图标)。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusInputInteger {
        width: 200
        prefix: '￥'
    }

    HusInputInteger {
        width: 200
        beforeLabel: String.fromCharCode(HusIcon.UserOutlined)
        prefix: '￥'
    }

    HusInputInteger {
        width: 200
        beforeLabel: String.fromCharCode(HusIcon.UserOutlined)
        prefix: '￥'
        suffix: 'RMB'
    }

    HusInputInteger {
        enabled: false
        width: 200
        beforeLabel: String.fromCharCode(HusIcon.UserOutlined)
        prefix: '￥'
    }
}
```

---

### 示例 5 - 鼠标滚轮

通过 `useWheel` 属性设置是否使用鼠标滚轮控制。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    width: parent.width
    spacing: 10

    HusInputInteger {
        width: 140
        min: 0
        max: 10
        useWheel: wheelCheckBox.checked
    }

    HusCheckBox {
        id: wheelCheckBox
        anchors.verticalCenter: parent.verticalCenter
        text: 'Toggle mouse wheel'
        checked: false
    }
}
```

---

### 示例 6 - 键盘行为

通过 `useKeyboard` 属性设置是否使用键盘控制。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    width: parent.width
    spacing: 10

    HusInputInteger {
        width: 140
        min: 0
        max: 10
        useKeyboard: keyboardCheckBox.checked
    }

    HusCheckBox {
        id: keyboardCheckBox
        anchors.verticalCenter: parent.verticalCenter
        text: 'Toggle keyboard'
        checked: true
    }
}
```


[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusAutoComplete 自动完成 


输入框自动完成功能。

* **模块 { HuskarUI.Basic }**

* **继承自 { [HusInput](./HusInput.md) }**


<br/>

### 支持的代理：

- **labelDelegate: Component** 弹出框标签项代理，代理可访问属性：

  - `parent.textData: var` {textRole}对应的文本数据

  - `parent.valueData: var` {valueRole}对应的值数据

  - `parent.modelData: var` 选项模型数据

  - `parent.hovered: bool` 是否悬浮

  - `parent.highlighted: bool` 是否高亮

- **labelBgDelegate: Component** 弹出框标签项背景代理，代理可访问属性：

  - `parent.textData: var` {textRole}对应的文本数据

  - `parent.valueData: var` {valueRole}对应的值数据

  - `parent.modelData: var` 选项模型数据

  - `parent.hovered: bool` 是否悬浮

  - `parent.selected: bool` 是否选择

  - `parent.highlighted: bool` 是否高亮


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
options | array | [] | 选项模型列表
filterOption | function(input, option) | - | 输入项将使用该函数进行筛选
count | int(readonly) | - | 当前options模型的项目数
textRole | string | 'label' | 弹出框文本的模型角色。
valueRole | string | 'value' | 弹出框值的模型角色。
showToolTip | bool | false | 是否显示文字提示
defaultPopupMaxHeight | int | 240 | 默认弹出框最大高度
defaultOptionSpacing | int | 0 | 默认选项间隔

<br/>

### 模型支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
label | sting | 必选 | 标签
value | string | 可选 | 值

<br/>

### 支持的函数：

- `clearInput()` 清空输入 

- `openPopup()` 打开弹出框 

- `closePopup()` 关闭弹出框 

- `filter()` 使用 `filterOption` 过滤选项列表

<br/>

### 支持的信号：

- `search(input: string)` 搜索补全项的时发出

  - `input` 输入文本

- `select(option: var)` 选择补全项时发出

  - `option` 选择的选项


<br/>

## 代码演示

### 示例 1 - 基本使用

基本使用，通过 `options` 设置自动完成的数据源。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusAutoComplete {
        width: 180
        placeholderText: 'Basic Usage'
        onSearch: function(input) {
            options = input ? [{ label: input.repeat(1) }, { label: input.repeat(2) }, { label: input.repeat(3) }] : [];
        }
    }
}
```

---

### 示例 2 - 自定义选项

可以返回自定义的 `options` 的 label。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusAutoComplete {
        width: 180
        placeholderText: 'Custom Options'
        onSearch: function(input) {
            if (!input || input.includes('@')) {
                options = [];
            } else {
                options = ['gmail.com', '163.com', 'qq.com'].map(
                            (domain) => ({
                                             label: `\${input}@\${domain}`,
                                             value: `\${input}@\${domain}`,
                                         }));
            }
        }
    }
}
```

---

### 示例 3 - 不区分大小写

不区分大小写的 HusAutoComplete。

通过 `filterOption` 设置过滤选项，它是形如：`function(input: string, option: var): bool { }` 的函数。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusAutoComplete {
        width: 180
        placeholderText: 'try to type `b`'
        options: [
            { label: 'Burns Bay Road' },
            { label: 'Downing Street' },
            { label: 'Wall Street' },
        ]
        filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
    }
}
```

---

### 示例 4 - 查询模式 - 确定类目

查询模式: 确定类目 示例。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusAutoComplete {
        width: 280
        showToolTip: true
        placeholderText: 'input here'
        options: [
            { label: 'HuskarUI', option: 'Libraries' },
            { label: 'HuskarUI for Qml' },
            { label: 'HuskarUI FAQ', option: 'Solutions' },
            { label: 'HuskarUI for Qml FAQ' },
            { label: 'HuskarUI', option: 'Copyright' },
            { label: 'Copyright (C) 2025 mengps. All rights reserved.' },
        ]
        labelDelegate: Column {
            id: delegateColumn

            property string option: modelData.option ?? ''

            Loader {
                active: delegateColumn.option !== ''
                sourceComponent: HusDivider {
                    width: delegateColumn.width
                    height: 30
                    titleAlign: HusDivider.Align_Center
                    title: delegateColumn.option
                    colorText: 'red'
                }
            }

            HusText {
                id: label
                text: textData
                color: HusTheme.HusAutoComplete.colorItemText
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }
        labelBgDelegate: Item {
            property string option: modelData.option ?? ''

            Rectangle {
                width: parent.width
                height: option == '' ? parent.height : parent.height - 30
                anchors.bottom: parent.bottom
                clip: true
                radius: 2
                color: highlighted ? HusTheme.HusAutoComplete.colorItemBgActive :
                                     hovered ? HusTheme.HusAutoComplete.colorItemBgHover :
                                               HusTheme.HusAutoComplete.colorItemBg;
            }
        }
    }
}
```

---

### 示例 5 - 查询模式 - 不确定类目

查询模式: 不确定类目 示例。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    HusAutoComplete {
        width: 280
        height: 40
        radiusBg.topRight: 0
        radiusBg.bottomRight: 0
        showToolTip: true
        placeholderText: 'input here'
        onSearch: function(input) {
            if (!input) {
                options = [];
            } else {
                const getRandomInt = (max, min = 0) => Math.floor(Math.random() * (max - min + 1)) + min;
                options =
                        Array.from({ length: getRandomInt(5) })
                            .join('.')
                            .split('.')
                            .map((_, idx) => {
                                     const category = `\${input}\${idx}`;
                                     return {
                                         value: category,
                                         label: `Found \${input} on <span style='color:#1677FF'>\${category}</span> \${getRandomInt(200, 100)} results`
                                     }
                                 });
            }
        }
        labelDelegate: HusText {
            text: textData
            color: HusTheme.HusAutoComplete.colorItemText
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            textFormat: Text.RichText
        }
    }

    HusIconButton {
        id: searchButton
        height: 40
        type: HusButton.Type_Primary
        iconSource: HusIcon.SearchOutlined
        radiusBg.topLeft: 0
        radiusBg.bottomLeft: 0
    }
}
```

---

### 示例 6 - 自定义清除按钮

通过 `clearEnabled` 设置是否启用清除按钮。

通过 `clearIconSource` 设置清除图标，为 0 则不显示。

通过 `clearIconSize` 设置清除图标大小。

通过 `clearIconPosition` 设置清除图标的位置，支持的位置：

- 清除图标在输入框左边(默认){ HusAutoComplete.Position_Left }

- 清除图标在输入框右边{ HusAutoComplete.Position_Right }


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusAutoComplete {
        width: 240
        clearIconSource: HusIcon.CloseSquareFilled
        placeholderText: 'Customized clear icon'
        onSearch: function(input) {
            options = input ? [{ label: input.repeat(1) }, { label: input.repeat(2) }, { label: input.repeat(3) }] : [];
        }
    }
}
```


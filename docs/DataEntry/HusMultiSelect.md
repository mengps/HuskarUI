[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusMultiSelect 多选器 


下拉多选器。

* **模块 { HuskarUI.Basic }**

* **继承自 { [HusSelect](./HusSelect.md) }**


<br/>

### 支持的代理：

- **prefixDelegate: Component** 前缀代理

- **suffixDelegate: Component** 后缀代理

- **tagDelegate: Component** 标签代理，代理可访问属性：

  - `index: var` 标签索引

  - `tagData: var` 标签数据


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
options | array | [] | 选项模型列表
filterOption | function | - | 输入项将使用该函数进行筛选
text | string | '' | 当前输入文本
prefix | string | '' | 前缀文本
suffix | string | '' | 后缀文本
genDefaultKey | bool | true | 是否生成默认键(如果没有给定key则为label)
defaultSelectedKeys | array | [] | 默认选中的键数组
selectedKeys | array | [] | 选中项的键
searchEnabled | bool | true | 是否启用搜索
tagCount | int(readonly) | 0 | 当前(选择)标签数量
maxTagCount | int | -1 | 最多显示多少个标签(-1无限制)
tagSpacing | int | 5 | 标签间隔
colorTagText | color | - | 标签文本颜色
colorTagBg | color | - | 标签背景颜色
radiusTagBg | [HusRadius](../General/HusRadius.md) | - | 标签圆角

<br/>

### 支持的函数：

- `findKey(key: string): var` 查找 `key` 处的选项数据 

- `filter()` 过滤选项列表 

- `insertTag(index: int, key: string)` 插入键为 `key` 的标签到 `index` 处(必须是 `options` 中的数据) 

- `appendTag(key: string)` 在末尾添加键为 `key` 的标签(必须是 `options` 中的数据) 

- `removeTagAtKey(key: string)` 删除 `key` 处的标签 

- `removeTagAtIndex(index: int)` 删除 `index` 处的标签 

- `clearTag()` 清空标签 

- `clearInput()` 清空输入 

- `openPopup()` 打开弹出框 

- `closePopup()` 关闭弹出框 


<br/>

### 支持的信号：

- `search(input: string)` 搜索补全项的时发出

  - `input` 输入文本

- `select(option: var)` 选择补全项时发出

  - `option` 选择的选项

- `removeTag(option: var)` 删除标签项时发出

  - `option` 删除的选项


<br/>

### 注意事项：

`options` 列表通常需要 `key` 属性，如果未给出将使用 `label` 作为 `key`

<br/>

## 代码演示

### 示例 1 - 基本使用

通过 `options` 设置数据源。

通过 `filterOption` 设置过滤选项，它是形如：`function(input: string, option: var): bool { }` 的函数。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
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

    HusMultiSelect {
        width: 200
        sizeHint: sizeHintRadio.currentCheckedValue
        filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
        Component.onCompleted: {
            const list = [];
            for (let i = 10; i < 36; i++) {
                list.push({
                              label: i.toString(36) + i,
                              value: i.toString(36) + i,
                          });
            }
            options = list;
        }
    }
}
```

---

### 示例 2 - 自定义下拉文本

通过 `textRole` 设置弹窗显示的文本角色。

通过 `searchEnabled` 设置是否启用搜索。

通过 `placeholderText` 设置占位符文本。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    width: parent.width
    spacing: 10

    HusMultiSelect {
        width: 200
        textRole: 'desc'
        searchEnabled: false
        placeholderText: 'select one country'
        options: [
            {
                label: 'China',
                value: 'china',
```

---

### 示例 3 - 前缀和后缀

通过 `prefix` 设置前缀文本。

通过 `suffix` 设置后缀文本。

通过 `prefixDelegate` 设置前缀代理。

通过 `suffixDelegate` 设置后缀代理。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    width: parent.width
    spacing: 10

    HusMultiSelect {
        width: 200
        prefix: 'User'
        options: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'Yiminghe', label: 'yiminghe' },
            { value: 'disabled', label: 'Disabled', disabled: true },
        ]
    }

    HusMultiSelect {
        width: 200
        prefixDelegate: HusIconText { iconSource: HusIcon.SmileOutlined }
        options: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'Yiminghe', label: 'yiminghe' },
            { value: 'disabled', label: 'Disabled', disabled: true },
        ]
    }

    HusMultiSelect {
        width: 200
        suffix: 'User'
        options: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'Yiminghe', label: 'yiminghe' },
            { value: 'disabled', label: 'Disabled', disabled: true },
        ]
    }

    HusMultiSelect {
        width: 200
        suffixDelegate: HusIconText { iconSource: HusIcon.SmileOutlined }
        options: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'Yiminghe', label: 'yiminghe' },
            { value: 'disabled', label: 'Disabled', disabled: true },
        ]
    }
}
```

---

### 示例 4 - 隐藏已选择选项

隐藏下拉列表中已选择的选项。


```qml
import QtQuick
import HuskarUI.Basic

HusMultiSelect {
    width: 500
    filterOption:
        (input, option) => {
            filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
            return filteredOptions.indexOf(option.label) != -1;
        }
    onSelect: {
        filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
        options = filteredOptions.map((item) => ({ label: item }));
    }
    onRemoveTag: {
        filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
        options = filteredOptions.map((item) => ({ label: item }));
    }
    Component.onCompleted: options = theOptions.map((item) => ({ label: item }));
    property var theOptions: ['Apples', 'Nails', 'Bananas', 'Helicopters']
    property var filteredOptions: []
}
```

---

### 示例 5 - 自定义选择标签

允许自定义选择标签的样式。

通过 `tagDelegate` 设置标签代理。


```qml
import QtQuick
import HuskarUI.Basic

HusMultiSelect {
    id: customTag
    width: 500
    tagDelegate: HusTag {
        text: tagData.label
        presetColor: tagData.value
        closeIconSource: HusIcon.CloseOutlined
        closeIconSize: 12
        onClose: customTag.removeTagAtIndex(index);
    }
    options: [
        { label: 'gold', value: 'gold' },
        { label: 'lime', value: 'lime' },
        { label: 'green', value: 'green' },
        { label: 'cyan', value: 'cyan' },
    ]
}
```

---

### 示例 6 - 最大选中数量

通过设置 `maxTagCount` 约束最多可选中的数量，当超出限制时会变成禁止选中状态。


```qml
import QtQuick
import HuskarUI.Basic

HusMultiSelect {
    width: 500
    maxTagCount: 3
    suffix: `\${tagCount}/\${maxTagCount}`
    options: [
        { value: 'Ava Swift', label: 'Ava Swift' },
        { value: 'Cole Reed', label: 'Cole Reed' },
        { value: 'Mia Blake', label: 'Mia Blake' },
        { value: 'Jake Stone', label: 'Jake Stone' },
        { value: 'Lily Lane', label: 'Lily Lane' },
        { value: 'Ryan Chase', label: 'Ryan Chase' },
        { value: 'Zoe Fox', label: 'Zoe Fox' },
        { value: 'Alex Grey', label: 'Alex Grey' },
        { value: 'Elle Blair', label: 'Elle Blair' },
    ]
}
```

---

### 示例 7 - 大数据

100000 选择项。


```qml
import QtQuick
import HuskarUI.Basic

Loader {
    asynchronous: true
    sourceComponent: HusMultiSelect {
        width: 500
        genDefaultKey: false
        filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
        Component.onCompleted: {
            const list = [];
            for (let i = 0; i < 100000; i++) {
                const label = `\${i.toString(36)}\${i}`;
                list.push({ key: label, label: label, disabled: i === 10 });
            }
            options = list;
        }
    }
}
```


[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusPagination 分页


分页器用于分隔长列表，每次只加载一个页面。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **prevButtonDelegate: Component** 上一页按钮代理

- **nextButtonDelegate: Component** 下一页按钮代理

- **quickJumperDelegate: Component** 快速跳转代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
defaultButtonWidth | int | 32 | 按钮宽度
defaultButtonHeight | int | 32 | 按钮高度
defaultButtonSpacing | int | 8 | 按钮间隔
showQuickJumper | bool | false | 是否显示快速跳转
currentPageIndex | int | 0 | 当前页索引
total | int | 0 | 数据项总数
pageTotal | int(readonly) | - | 页总数(自动计算)
pageButtonMaxCount | int | 7 | 最大页按钮数量
pageSize | int | 10 | 每页数量
pageSizeModel | array | [] | 每页数量模型
prevButtonTooltip | string | '上一页' | 上一页按钮的提示文本(为空不显示)
nextButtonTooltip | string | '下一页' | 下一页按钮的提示文本(为空不显示)
sizeHint | string | 'normal' | 尺寸提示

<br/>

### 支持的函数：

- `gotoPageIndex(index: int)` 跳转到`index` 处的页 

- `gotoPrevPage()` 跳转到前一页 

- `gotoPrev5Page()` 跳转到前五页 

- `gotoNextPage()` 跳转到后一页 

- `gotoNext5Page()` 跳转到后五页 


<br/>

## 代码演示

### 示例 1 - 基础

基础分页，通过 `currentPageIndex` 设置当前页索引。


```qml
import QtQuick
import HuskarUI.Basic

HusPagination {
    currentPageIndex: 0
    total: 50
}
```

---

### 示例 2 - 更多

通过 `enabled` 设置是否启用。

通过 `total` 设置数据总数。

通过 `pageSizeModel` 设置每页数量选择模型，选择项支持的属性：

- { label: 数量标签 }

- { value: 每页数量 }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusPagination {
        currentPageIndex: 6
        total: 500
        pageSizeModel: [
            { label: qsTr('10条每页'), value: 10 },
            { label: qsTr('20条每页'), value: 20 },
            { label: qsTr('30条每页'), value: 30 },
            { label: qsTr('40条每页'), value: 40 }
        ]
    }

    HusPagination {
        enabled: false
        currentPageIndex: 6
        total: 500
        pageSizeModel: [
            { label: qsTr('10条每页'), value: 10 },
            { label: qsTr('20条每页'), value: 20 },
            { label: qsTr('30条每页'), value: 30 },
            { label: qsTr('40条每页'), value: 40 }
        ]
    }
}
```

---

### 示例 3 - 跳转

通过 `showQuickJumper` 显示快速跳转项，可通过 `quickJumperDelegate` 自定义。

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

    HusPagination {
        sizeHint: sizeHintRadio.currentCheckedValue
        currentPageIndex: 6
        total: 500
        showQuickJumper: true
        pageSizeModel: [
            { label: qsTr('10条每页'), value: 10 },
            { label: qsTr('20条每页'), value: 20 },
            { label: qsTr('30条每页'), value: 30 },
            { label: qsTr('40条每页'), value: 40 }
        ]
    }

    HusPagination {
        sizeHint: sizeHintRadio.currentCheckedValue
        enabled: false
        currentPageIndex: 6
        total: 500
        showQuickJumper: true
        pageSizeModel: [
            { label: qsTr('10条每页'), value: 10 },
            { label: qsTr('20条每页'), value: 20 },
            { label: qsTr('30条每页'), value: 30 },
            { label: qsTr('40条每页'), value: 40 }
        ]
    }
}
```

---

### 示例 4 - 上一步和下一步

通过 `prevButtonDelegate` 和 `nextButtonDelegate` 自定义上一步和下一步按钮。


```qml
import QtQuick
import HuskarUI.Basic

HusPagination {
    currentPageIndex: 2
    total: 500
    pageSizeModel: [
        { label: qsTr('10条每页'), value: 10 },
        { label: qsTr('20条每页'), value: 20 },
        { label: qsTr('30条每页'), value: 30 },
        { label: qsTr('40条每页'), value: 40 }
    ]
    prevButtonDelegate: HusButton {
        text: 'Previous'
        type: HusButton.Type_Link
        onClicked: gotoPrevPage();
    }
    nextButtonDelegate: HusButton {
        text: 'Next'
        type: HusButton.Type_Link
        onClicked: gotoNextPage();
    }
}
```


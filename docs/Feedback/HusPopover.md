[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusPopover 气泡显示框 


点击元素，弹出气泡式的显示框。

* **模块 { HuskarUI.Basic }**

* **继承自 { [HusPopup](../General/HusPopup.md) }**


<br/>

### 支持的代理：

- **arrowDelegate: Component** 箭头代理

- **iconDelegate: Component** 图标代理

- **titleDelegate: Component** 标题代理

- **descriptionDelegate: Component** 描述代理

- **contentDelegate: Component** 内容代理

- **bgDelegate: Component** 背景代理

- **footerDelegate: Component** 页脚代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
iconSource | int丨string | HusIcon.ExclamationCircleFilled丨'' | 图标源(来自 HusIcon)或图标链接
iconSize | int | 16 | 图标大小
title | string | '' | 标题文本
description | string | '' | 描述文本
showArrow | bool | true | 是否显示箭头
arrowWidth | int | 16 | 箭头宽度
arrowHeight | int | 8 | 箭头高度
colorIcon | color | - | 图标颜色
colorTitle | color | - | 标题文本颜色
colorDescription | color | - | 描述文本颜色
titleFont | font | - | 标题文本字体
descriptionFont | font | - | 描述文本字体

<br/>

 **注意** 需要显示给出弹出宽度，高度将根据内容自动计算

<br/>

## 代码演示

### 示例 1 - 基本

最简单的用法，支持标题和描述。

通过 `title` 属性设置标题文本。

通过 `description` 属性设置描述文本。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusButton {
        text: 'Hover'
        type: HusButton.Type_Outlined

        HusPopover {
            x: (parent.width - width) * 0.5
            y: parent.height + 6
            width: 300
            visible: parent.hovered || parent.down
            closePolicy: HusPopover.NoAutoClose
            title: 'Hover details'
            description: 'What are you doing here?'
        }
    }

    HusButton {
        text: 'Click'
        type: HusButton.Type_Outlined
        onClicked: popover.open();

        HusPopover {
            id: popover
            x: (parent.width - width) * 0.5
            y: parent.height + 6
            width: 300
            title: 'Click details'
            description: 'What are you doing here?'
        }
    }
}
```


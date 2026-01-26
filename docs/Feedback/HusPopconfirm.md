[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusPopconfirm 气泡确认框 


点击元素，弹出气泡式的确认框。

* **模块 { HuskarUI.Basic }**

* **继承自 { [HusPopover](./HusPopover.md) }**


<br/>

### 支持的代理：

- **confirmButtonDelegate: Component** 确认按钮代理

- **cancelButtonDelegate: Component** 取消按钮代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
confirmText | string | '' | 确认文本
cancelText | string | '' | 取消文本

<br/>

 **注意** 需要显示给出弹出宽度，高度将根据内容自动计算

<br/>

### 支持的信号：

- `confirm()` 点击确认按钮后发出

- `cancel()` 点击取消按钮后发出


<br/>

## 代码演示

### 示例 1 - 基本

最简单的用法，支持标题和描述以及确认/取消按钮。

通过 `title` 属性设置标题文本。

通过 `description` 属性设置描述文本。

通过 `confirmText` 属性设置确认文本

通过 `cancelText` 属性设置取消文本。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    HusButton {
        text: 'Delete'
        type: HusButton.Type_Outlined
        onClicked: popconfirm.open();

        HusPopconfirm {
            id: popconfirm
            x: (parent.width - width) * 0.5
            y: parent.height + 6
            width: 300
            title: 'Delete the task'
            description: 'Are you sure to delete this task?'
            confirmText: 'Yes'
            cancelText: 'No'
            onConfirm: {
                message.success('Click on Yes');
                close();
            }
            onCancel: {
                message.error('Click on No');
                close();
            }
        }
    }
}
```

---

### 示例 2 - 自定义 Icon 图标

通过 `iconSource` 属性设置图标源。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusButton {
        text: 'Add'
        type: HusButton.Type_Outlined
        onClicked: popconfirm2.open();

        HusPopconfirm {
            id: popconfirm2
            x: (parent.width - width) * 0.5
            y: parent.height + 6
            iconSource: HusIcon.QuestionCircleOutlined
            width: 300
            title: 'Add the task'
            description: 'Are you sure to add this task?'
            confirmText: 'Yes'
            cancelText: 'No'
            onConfirm: {
                message.success('Click on Yes');
                close();
            }
            onCancel: {
                message.error('Click on No');
                close();
            }
        }
    }

    HusButton {
        text: 'Delete'
        type: HusButton.Type_Outlined
        onClicked: popconfirm3.open();

        HusPopconfirm {
            id: popconfirm3
            x: (parent.width - width) * 0.5
            y: parent.height + 6
            iconSource: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'
            width: 300
            title: 'Delete the task'
            description: 'Are you sure to delete this task?'
            confirmText: 'Yes'
            cancelText: 'No'
            onConfirm: {
                message.success('Click on Yes');
                close();
            }
            onCancel: {
                message.error('Click on No');
                close();
            }
        }
    }
}
```

---

### 示例 3 - 替代 ToolTip

可简单替代实现 [HusToolTip](../DataDisplay/HusToolTip.md)。

`confirmText` 为空则不显示确认按钮，`cancelText` 为空则不显示取消按钮。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    HusButton {
        text: 'Hover Tooltip'
        type: HusButton.Type_Primary

        HusPopconfirm {
            id: popconfirm4
            x: (parent.width - width) * 0.5
            y: parent.height + 6
            width: 150
            title: 'Tooltip'
            description: 'This is tooltip!'
            iconSource: 0
            visible: parent.hovered
        }
    }
}
```


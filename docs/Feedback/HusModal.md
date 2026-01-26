[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusModal 对话框 


展示一个对话框，提供标题、内容区、操作区。

* **模块 { HuskarUI.Basic }**

* **继承自 { [HusPopup](../General/HusPopup.md) }**


<br/>

### 支持的代理：

- **iconDelegate: Component** 内容代理

- **titleDelegate: Component** 标题代理

- **descriptionDelegate: Component** 描述代理

- **closeButtonDelegate: Component** 右上角关闭按钮代理

- **confirmButtonDelegate: Component** 确认按钮代理

- **cancelButtonDelegate: Component** 取消按钮代理

- **footerDelegate: Component** 底部代理(包含确认/取消按钮)

- **contentDelegate: Component** 内容代理

- **bgDelegate: Component** 背景代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
position | enum | HusModal.Position_Center | 弹框出现的位置(来自 HusModal)
positionMargin | int | 120 | 弹框出现位置距离窗口边缘的距离
closable | bool | true | 是否显示右上角的关闭按钮
maskClosable | bool | true | 点击蒙层是否允许关闭
iconSource | int丨string | 0丨'' | 图标源(来自 HusIcon)或图标链接
iconSize | int | 24 | 图标大小
title | string | '' | 标题文本
description | string | '' | 描述文本
confirmText | string | '' | 确认文本
cancelText | string | '' | 取消文本
colorIcon | color | - | 图标颜色
colorTitle | color | - | 标题文本颜色
colorDescription | color | - | 描述文本颜色
titleFont | font | - | 标题文本字体
descriptionFont | font | - | 描述文本字体

<br/>

### 支持的函数：

- `openInfo()` 打开 `info` 弹框

- `openSuccess()` 打开 `success` 弹框

- `openError()` 打开 `error` 弹框

- `openWarning()` 打开 `warning` 弹框


<br/>

### 支持的信号：

- `confirm()` 点击确认按钮后发出

- `cancel()` 点击取消按钮后发出


<br/>

## 代码演示

### 示例 1 - 基本

基础弹框。

通过 `modal` 属性设置是否为模态。

通过 `title` 属性设置标题文本。

通过 `description` 属性设置描述文本。

通过 `confirmText` 属性设置确认文本

通过 `cancelText` 属性设置取消文本。

通过 `closable` 属性设置右上角关闭按钮。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusButton {
        text: 'Open Modal'
        type: HusButton.Type_Primary
        onClicked: modal1.open();

        HusModal {
            id: modal1
            width: 500
            modal: modalSwitch.checked
            position: parseInt(positionRadio.currentCheckedValue)
            closable: closableRadio.currentCheckedValue
            title: 'Basic Modal'
            description: 'Some contents...\nSome contents...\nSome contents...'
            confirmText: 'Yes'
            cancelText: 'No'
            onConfirm: close();
            onCancel: close();
        }
    }

    Row {
        spacing: 10

        HusText {
            text: 'Modal:'
            anchors.verticalCenter: parent.verticalCenter
        }

        HusSwitch {
            id: modalSwitch
            checked: true
        }
    }

    HusRadioBlock {
        id: positionRadio
        initCheckedIndex: 0
        model: [
            { label: 'Top', value: HusModal.Position_Top},
            { label: 'Bottom', value: HusModal.Position_Bottom },
            { label: 'Center', value: HusModal.Position_Center },
            { label: 'Left', value: HusModal.Position_Left },
            { label: 'Right', value: HusModal.Position_Right }
        ]
    }

    HusRadioBlock {
        id: closableRadio
        initCheckedIndex: 0
        model: [
            { label: 'Closable', value: true},
            { label: 'Non-closable', value: false }
        ]
    }
}
```

---

### 示例 2 - 自定义页脚

更复杂的例子，自定义了页脚的按钮，点击提交后进入 `loading` 状态，完成后关闭。

不需要默认确定取消按钮时，你可以把 `footerDelegate` 设为 null。

通过 `footerDelegate` 属性设置自定义页脚代理。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusButton {
        text: 'Open Modal'
        type: HusButton.Type_Primary
        onClicked: modal2.open();

        HusModal {
            id: modal2
            width: 500
            title: 'Title'
            description: 'Some contents...\nSome contents...\nSome contents...\nSome contents...\nSome contents...'
            footerDelegate: Item {
                height: 30

                Row {
                    anchors.right: parent.right
                    spacing: 10

                    HusButton {
                        text: 'Return'
                        type: HusButton.Type_Outlined
                        onClicked: modal2.close();
                    }

                    HusIconButton {
                        text: 'Submit'
                        type: HusButton.Type_Primary
                        onClicked: {
                            loading = true;
                            submitTimer.restart();
                        }

                        Timer {
                            id: submitTimer
                            interval: 2000
                            onTriggered: {
                                modal2.close();
                                parent.loading = false;
                            }
                        }
                    }

                    HusButton {
                        text: 'Search on Google'
                        type: HusButton.Type_Primary
                        onClicked: Qt.openUrlExternally('https://google.com');
                    }
                }
            }
        }
    }
}
```

---

### 示例 3 - 其他提示消息类型

包括成功、失败、信息、警告弹框。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusButton {
        text: 'Success'
        onClicked: modal3.openSuccess();
    }

    HusButton {
        text: 'Warning'
        onClicked: modal3.openWarning();
    }

    HusButton {
        text: 'Info'
        onClicked: modal3.openInfo();
    }

    HusButton {
        text: 'Error'
        onClicked: modal3.openError();
    }

    HusModal {
        id: modal3
        width: 500
        title: 'Title'
        description: 'Reachable: Light!\nUnreachable: null!'
        confirmText: 'Yes'
        cancelText: 'No'
        onConfirm: close();
        onCancel: close();
    }
}
```

---

### 示例 4 - 可拖拽的弹框

通过 `movable` 属性设置为可移动，具体请参考 [HusPopup](../General/HusPopup.md)。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusButton {
        text: 'Open Draggable Modal'
        onClicked: modal4.open();

        HusModal {
            id: modal4
            width: 500
            title: 'Draggable Modal'
            movable: true
            description: 'Just dont learn physics at school and your life will be full of magic and miracles. \n\nDay before yesterday I saw a rabbit, and yesterday a deer, and today, you.'
            confirmText: 'Yes'
            cancelText: 'No'
            onConfirm: close();
            onCancel: close();
        }
    }
}
```


[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusPopup 弹窗


自带跟随主题切换的背景和阴影, 用来替代内置 Popup。

* **模块 { HuskarUI.Basic }**

* **继承自 { Popup }**

* **继承此 { [HusImagePreview](../DataDisplay/HusImagePreview.md), [HusModal](../Feedback/HusModal.md), [HusPopover](../Feedback/HusPopover.md), [HusContextMenu](../Navigation/HusContextMenu.md) }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
movable | bool | false | 是否可移动
resizable | bool | false | 是否可改变大小
minimumX | int | Number.NaN | 可移动的最小X坐标(movable为true生效)
maximumX | int | Number.NaN | 可移动的最大X坐标(movable为true生效)
minimumY | int | Number.NaN | 可移动的最小Y坐标(movable为true生效)
maximumY | int | Number.NaN | 可移动的最大Y坐标(movable为true生效)
minimumWidth | int | 0 | 可改变的最小宽度(resizable为true生效)
maximumWidth | int | Number.NaN | 可改变的最小宽度(resizable为true生效)
minimumHeight | int | 0 | 可改变的最小高度(resizable为true生效)
maximumHeight | int | Number.NaN | 可改变的最小高度(resizable为true生效)
colorShadow | color | - | 阴影颜色
colorBg | color | - | 背景颜色
radiusBg | [HusRadius](./HusRadius.md) | - | 背景圆角半径

<br/>

## 代码演示

### 示例 1

使用方法等同于 `Popup` 

通过 `movable` 设置为可移动 

通过 `resizable` 设置为可改变大小 


```qml
import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

Item {
    height: 50

    HusButton {
        text: (popup.opened ? qsTr('隐藏') : qsTr('显示'))
        type: HusButton.Type_Primary
        onClicked: {
            if (popup.opened)
                popup.close();
            else
                popup.open();
        }
    }

    HusPopup {
        id: popup
        x: (parent.width - width) * 0.5
        y: (parent.height - height) * 0.5
        width: 400
        height: 300
        parent: Overlay.overlay
        closePolicy: HusPopup.NoAutoClose
        movable: true
        resizable: true
        minimumX: 0
        maximumX: parent.width - width
        minimumY: 0
        maximumY: parent.height - height
        minimumWidth: 400
        minimumHeight: 300
        radiusBg.topLeft: 100
        radiusBg.bottomRight: 100
        contentItem: Item {
            HusCaptionButton {
                anchors.right: parent.right
                radiusBg.topRight: popup.radiusBg.topRight
                colorText: colorIcon
                iconSource: HusIcon.CloseOutlined
                onClicked: popup.close();
            }
        }
    }
}
```


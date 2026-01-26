[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusDrawer 抽屉 


屏幕边缘滑出的浮层面板。

* **模块 { HuskarUI.Basic }**

* **继承自 { Drawer }**


<br/>

### 支持的代理：

- **closeDelegate: Component** 关闭按钮代理

- **titleDelegate: Component** 标题代理

- **contentDelegate: Component** 内容代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
maskClosable | bool | true | 点击蒙层是否允许关闭
closePosition | enum | HusDrawer.Position_Start | 关闭按钮的位置(来自 HusDrawer)
drawerSize | int | 378 | 抽屉宽度
edge | enum | Qt.RightEdge | 抽屉打开的位置(来自 Qt.*Edge)
title | string | '' | 标题文本
titleFont | font | - | 标题字体
colorTitle | color | - | 标题颜色
colorBg | color | - | 抽屉背景颜色
colorOverlay | color | - | 覆盖层颜色

<br/>

## 代码演示

### 示例 1

基础抽屉，点击触发按钮抽屉从右滑出，点击遮罩区(非抽屉区)关闭。

```qml
import QtQuick
import HuskarUI.Basic

Row {
    HusButton {
        type: HusButton.Type_Primary
        text: qsTr('打开')
        onClicked: drawer.open();

        HusDrawer {
            id: drawer
            title: qsTr('Basic Drawer')
            contentDelegate: HusCopyableText {
                leftPadding: 15
                text: 'Some contents...\nSome contents...\nSome contents...'
            }
        }
    }
}
```

---

### 示例 2

通过 `edge` 属性设置抽屉打开的位置，支持的位置：

- 抽屉在窗口上边{ Qt.TopEdge }

- 抽屉在项目下边{ Qt.BottomEdge }

- 抽屉在项目左边{ Qt.LeftEdge }

- 抽屉在项目右边(默认){ Qt.RightEdge }


通过 `closePosition` 属性设置抽屉关闭按钮的位置，支持的位置：

- 起始位置(默认){ HusDrawer.Position_Start }

- 末尾位置{ HusDrawer.Position_End }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusButton {
        type: HusButton.Type_Primary
        text: qsTr('打开')
        onClicked: drawer2.open();

        HusDrawer {
            id: drawer2
            edge: edgeRadio.currentCheckedValue
            title: qsTr('Basic Drawer')
            closePosition: closeRadio.currentCheckedValue
            contentDelegate: HusCopyableText {
                leftPadding: 15
                text: 'Some contents...\nSome contents...\nSome contents...'
            }
        }
    }

    HusRadioBlock {
        id: edgeRadio
        initCheckedIndex: 3
        model: [
            { label: 'Top', value: Qt.TopEdge },
            { label: 'Bottom', value: Qt.BottomEdge },
            { label: 'Left', value: Qt.LeftEdge },
            { label: 'Right', value: Qt.RightEdge }
        ]
    }

    HusRadioBlock {
        id: closeRadio
        initCheckedIndex: 0
        model: [
            { label: 'Start', value: HusDrawer.Position_Start },
            { label: 'End', value: HusDrawer.Position_End }
        ]
    }
}
```


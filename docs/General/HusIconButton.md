[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusIconButton 图标按钮


带图标的按钮。

* **模块 { HuskarUI.Basic }**

* **继承自 { [HusButton](./HusButton.md) }**

* **继承此 { [HusCaptionButton](./HusCaptionButton.md) }**


<br/>

### 支持的代理：

- **iconDelegate: Component** 图标代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
iconSource | int丨string | 0丨'' | 图标源(来自 HusIcon)或图标链接
iconSize | int | - | 图标大小
iconSpacing | int | 5 | 图标间隔
iconPosition | enum | HusIconButton.Position_Start | 图标位置(来自 HusIconButton)
loading | bool | false | 是否在加载中
orientation | enum | Qt.Horizontal | 方向(Qt.Horizontal 或 Qt.Vertical)
textFont | font | - | 文本字体
iconFont | font | 'HuskarUI-Icons' | 图标字体
colorIcon | color | - | 图标颜色

<br/>

## 代码演示

### 示例 1

通过 `iconSource` 属性设置图标源{ HusIcon中定义 }

通过 `iconSize` 属性设置图标大小

通过 `iconPosition` 属性设置图标位置，支持的位置有：

- 图标处于开始位置(默认){ HusIconButton.Position_Start }

- 图标处于结束位置{ HusIconButton.Position_End }

通过 `orientation` 属性改变方向，支持的方向：

- 水平排布(默认){ Qt.Horizontal }

- 垂直排布{ Qt.Vertical }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusRadioBlock {
        id: orientationRadio
        initCheckedIndex: 0
        model: [
            { label: 'Horizontal', value: Qt.Horizontal },
            { label: 'Vertical', value: Qt.Vertical },
        ]
    }

    Row {
        spacing: 15

        HusIconButton {
            text: qsTr('搜索')
            iconSource: HusIcon.SearchOutlined
            orientation: orientationRadio.currentCheckedValue
        }

        HusIconButton {
            text: qsTr('搜索')
            type: HusButton.Type_Outlined
            iconSource: HusIcon.SearchOutlined
            orientation: orientationRadio.currentCheckedValue
        }

        HusIconButton {
            type: HusButton.Type_Primary
            iconSource: HusIcon.SearchOutlined
            orientation: orientationRadio.currentCheckedValue
        }

        HusIconButton {
            text: qsTr('搜索')
            type: HusButton.Type_Primary
            iconSource: HusIcon.SearchOutlined
            orientation: orientationRadio.currentCheckedValue
        }

        HusIconButton {
            text: qsTr('搜索')
            type: HusButton.Type_Primary
            iconSource: HusIcon.SearchOutlined
            iconPosition: HusIconButton.Position_End
            orientation: orientationRadio.currentCheckedValue
        }

        HusIconButton {
            text: qsTr('搜索')
            type: HusButton.Type_Filled
            iconSource: HusIcon.SearchOutlined
            orientation: orientationRadio.currentCheckedValue
        }

        HusIconButton {
            text: qsTr('搜索')
            type: HusButton.Type_Text
            iconSource: HusIcon.SearchOutlined
            orientation: orientationRadio.currentCheckedValue
        }
    }
}
```


[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusSlider 滑动输入条


滑动型输入器，展示当前值和可选范围。。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **handleDelgate: Component** 滑块代理，代理可访问属性：

  - `slider: Slider / RangeSlider` 滑动条本身
  - `visualPosition: real` 滑块的有效视觉位置

  - `pressed: bool` 当前滑块是否被按下 

- **handleToolTipDelegate: Component** 滑块文字提示代理，代理可访问属性：

  - `handleHovered: bool` 指示当前滑块是否有鼠标悬浮

  - `handlePressed: bool` 指示当前滑块是否有鼠标按下

- **bgDelegate: Component** 背景代理，代理可访问属性：

  - `slider: Slider / RangeSlider` 滑动条本身
  - `visualPosition: bool` 滑块的有效视觉位置


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
hoverCursorShape | enum | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
min | real | 0 | 最小值
max | real | 100 | 最大值
stepSize | real | 0.0 | 步长
value | number丨[number, number] | 0丨[0, 0] | 设置滑块值, range为true时为数组[min, max]
currentValue | (readonly)number丨[number, number] | - | 获取当前滑块值, range为true时为数组[min, max]
range | bool | false | 是否双滑块模式
snapMode | enum | HusSlider.NoSnap | 滑块对齐模式(来自 HusSlider)
orientation | enum | Qt.Horizontal | 滑动条方向(Qt.Horizontal 或 Qt.Vertical)
colorHandle | color | - | 滑块颜色
colorTrack | color | - | 滑块轨道颜色
colorBg | color | - | 背景颜色
radiusBg | int | - | 背景圆角
contentDescription | string | '' | 内容描述(提高可用性)

<br/>

### 支持的函数：

- `decrease(frist: bool = true)` 将第 `first` 个滑块(first 为 false 则为第二个)值减小 stepSize 或 0.1

- `increase(frist: bool = true)` 将第 `first` 个滑块(first 为 false 则为第二个)值增加 stepSize 或 0.1


<br/>

### 支持的信号：

- `firstMoved()` 第一个滑块移动时发出

- `firstReleased()` 第一个滑块释放时发出

- `secondMoved()` 第二个滑块移动时发出(range为true)

- `secondReleased()` 第二个滑块释放时发出(range为true)


<br/>

## 代码演示

### 示例 1

基本滑动条。

当 `range` 为 `true` 时，渲染为双滑块。

当 `enabled` 为 `false` 时，滑块处于不可用状态。

通过 `value` 设置当前值，当 `range` 为 `true` 时接受数组值`[minValue, maxValue]`，否则接受 number 值 `value`。

通过 `currentValue` 获取当前值，当 `range` 为 `true` 时返回 `[minValue, maxValue]`，否则返回 `value`。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    HusSlider {
        width: 300
        height: 30
        value: 50

        HusCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.currentValue.toFixed(0);
        }
    }

    HusSlider {
        width: 300
        height: 30
        range: true
        value: [20, 50]

        HusCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: {
                const v = parent.currentValue;
                return v[0].toFixed(0) + ', '+ v[1].toFixed(0);
            }
        }
    }

    HusSlider {
        width: 300
        height: 30
        value: 50
        enabled: false
    }
}
```

---

### 示例 2

垂直方向的滚动条。

通过 `orientation` 属性改变方向，支持的方向：

- 水平滚动条(默认){ Qt.Horizontal }

- 垂直滚动条{ Qt.Vertical }


```qml
import QtQuick
import HuskarUI.Basic

Row {
    height: 310 + HusTheme.Primary.fontPrimarySize
    spacing: 30

    HusSlider {
        width: 30
        height: 300
        value: 50
        orientation: Qt.Vertical

        HusCopyableText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            anchors.topMargin: 10
            text: parent.currentValue.toFixed(0);
        }
    }

    HusSlider {
        width: 30
        height: 300
        range: true
        value: [20, 50]
        orientation: Qt.Vertical

        HusCopyableText {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            anchors.topMargin: 10
            text: {
                const v = parent.currentValue;
                return v[0].toFixed(0) + ', '+ v[1].toFixed(0);
            }
        }
    }
}
```

---

### 示例 3

通过 `snapMode` 属性改变滑块对齐模式，支持的模式：

- 不对齐(默认){ HusSlider.NoSnap }

- 拖动控制柄时滑块会自动对齐 { HusSlider.SnapAlways }

- 滑块在拖动时不会对齐，但只有在释放滑块后才会对齐 { HusSlider.SnapOnRelease }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    HusSlider {
        width: 300
        height: 30
        min: 0
        max: 10
        stepSize: 1
        snapMode: HusSlider.NoSnap

        HusCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.currentValue;
        }
    }

    HusSlider {
        width: 300
        height: 30
        min: 0
        max: 10
        stepSize: 1
        snapMode: HusSlider.SnapAlways

        HusCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.currentValue;
        }
    }

    HusSlider {
        width: 300
        height: 30
        min: 0
        max: 10
        stepSize: 1
        snapMode: HusSlider.SnapOnRelease

        HusCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: parent.currentValue;
        }
    }
}
```


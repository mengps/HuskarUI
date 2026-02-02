[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusCarousel 走马灯


一组轮播的区域。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **contentDelegate: Component** 内容代理，代理可访问属性：

  - `index: int` 内容项索引

  - `model: var` 内容项数据

- **indicatorDelegate: Component** 指示器代理，代理可访问属性：

  - `index: int` 指示器索引

  - `model: var` 指示器数据

- **prevDelegate: Component** 向前箭头代理

- **nextDelegate: Component** 向后箭头代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
initModel | array | [] | 初始数据模型
currentIndex | int | -1 | 当前索引
position | enum | HusCarousel.Position_Bottom | 滚动的方向和指示器的位置(来自 HusCarousel)
speed | int | 500 | 切换动效的时间(毫秒)
infinite | bool | true | 是否无限滚动
autoplay | bool | false | 是否自动切换
autoplaySpeed | int | 3000 | 自动切换的时间(毫秒)
draggable | bool | true | 是否启用拖拽切换
showIndicator | bool | true | 是否显示指示器
indicatorSpacing | int | 6 | 指示器间隔
showArrow | bool | false | 是否显示箭头

<br/>

### 支持的函数：

- `swithTo(index: int, animated: bool = true)` 

  - `index` 要切换的目标处索引
  - `animated` 是否使用切换动效
- `swithToPrev()` 切换到前一页 

- `swithToNext()` 切换到后一页 

- `int getSuitableIndicatorWidth(contentWidth: int, indicatorMaxWidth: int = 18)` 获取合适的指示器宽度 

  - `contentWidth` 轮播内容的宽度
  - `indicatorMaxWidth` 指示器最大宽度

<br/>

## 代码演示

### 示例 1 - 基本

最简单的用法。

通过 `infinite` 属性设置是否无限滚动。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10
    width: parent.width

    Row {
        spacing: 10

        HusText { text: qsTr('无限滚动') }

        HusSwitch {
            id: infiniteSwitch
            checked: true
        }
    }

    HusCarousel {
        id: carousel1
        width: parent.width
        height: 200
        infinite: infiniteSwitch.checked
        initModel: [
            { label: '1' },
            { label: '2' },
            { label: '3' },
            { label: '4' },
        ]
        contentDelegate: Rectangle {
            width: carousel1.width
            height: carousel1.height
            color: '#364d79'

            HusText {
                anchors.centerIn: parent
                text: model.label
                color: 'white'
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
```

---

### 示例 2 - 位置

通过 `position` 属性设置滚动的方向和指示器的位置，支持的位置：

- 水平滚动，指示器在上方，{ HusCarousel.Position_Top }

- 水平滚动，指示器在下方{ HusCarousel.Position_Bottom }

- 垂直滚动，指示器在左方{ HusCarousel.Position_Left }

- 垂直滚动，指示器在右方{ HusCarousel.Position_Right }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10
    width: parent.width

    HusRadioBlock {
        id: positionBlock
        initCheckedIndex: 1
        model: [
            { label: qsTr('上'), value: HusCarousel.Position_Top },
            { label: qsTr('下'), value: HusCarousel.Position_Bottom },
            { label: qsTr('左'), value: HusCarousel.Position_Left },
            { label: qsTr('右'), value: HusCarousel.Position_Right }
        ]
    }

    HusCarousel {
        id: carousel2
        width: parent.width
        height: 200
        position: positionBlock.currentCheckedValue
        initModel: [
            { label: '1' },
            { label: '2' },
            { label: '3' },
            { label: '4' },
        ]
        contentDelegate: Rectangle {
            width: carousel2.width
            height: carousel2.height
            color: '#364d79'

            HusText {
                anchors.centerIn: parent
                text: model.label
                color: 'white'
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
```

---

### 示例 3 - 自动切换

通过 `autoplay` 属性设置是否自动切换。

通过 `autoplaySpeed` 属性设置自动切换时间。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10
    width: parent.width

    HusCarousel {
        id: carousel4
        width: parent.width
        height: 200
        autoplay: true
        initModel: [
            { label: '1' },
            { label: '2' },
            { label: '3' },
            { label: '4' },
        ]
        contentDelegate: Rectangle {
            width: carousel4.width
            height: carousel4.height
            color: '#364d79'

            HusText {
                anchors.centerIn: parent
                text: model.label
                color: 'white'
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
```

---

### 示例 4 - 切换箭头

通过 `showArrow` 属性设置是否显示切换箭头。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10
    width: parent.width

    HusCarousel {
        id: carousel5
        width: parent.width
        height: 200
        showArrow: true
        initModel: [
            { label: '1' },
            { label: '2' },
            { label: '3' },
            { label: '4' },
        ]
        contentDelegate: Rectangle {
            width: carousel5.width
            height: carousel5.height
            color: '#364d79'

            HusText {
                anchors.centerIn: parent
                text: model.label
                color: 'white'
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
```


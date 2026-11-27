[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusSpin 加载中


用于页面和区块的加载中状态。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **contentDelegate: Component** 局部加载遮罩下的内容代理

- **indicatorDelegate: Component** 指示器代理

- **indicatorItemDelegate: Component** 指示器子项代理，代理可访问属性：

  - `index: int` 指示器索引

  - `itemSize: real` 子项大小(等同于 `indicatorSize` )

- **tipDelegate: Component** 提示代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
spinSize | real | 20 | 指示器整体尺寸
indicatorSize | real | 9 | 指示器子项大小
indicatorItemCount | int | 4 | 指示项数量
spinning | bool | true | 是否为加载中状态
delay | int | 0 | 加载指示器和遮罩出现前的延迟（毫秒）
fullscreen | bool | false | 是否遮罩整个窗口
tip | string | '' | 提示文本
percent | string丨real | undefined | 未设置或为 0 时显示旋转指示器，'auto' 自动模拟进度，正数显示实际进度
colorTip | color | - | 提示文本颜色
colorIndicator | color | - | 指示器颜色
colorProgressBar | color | - | 进度环颜色
colorProgressTrack | color | - | 进度环轨道颜色
colorContentMask | color | - | 局部加载遮罩颜色
colorFullscreenMask | color | - | 全屏加载遮罩颜色
sizeHint | string | 'normal' | 支持 'small'（14）、'normal'（20）、'large'（32）
contentDescription | string | '' | 内容描述(提高可用性)

<br/>

## 代码演示

### 示例 1 - 基本用法

一个简单的 loading 状态。

```qml
import QtQuick
import HuskarUI.Basic

Row {
    HusSpin { }
}
```

---

### 示例 2 - 各种大小

通过 `sizeHint` 属性设置尺寸。

小的用于文本加载，默认用于卡片容器级加载，大的用于页面级加载。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusSpin { sizeHint: 'small' }
    HusSpin { sizeHint: 'normal' }
    HusSpin { sizeHint: 'large' }
}
```

---

### 示例 3 - 卡片加载中

通过 `contentDelegate` 提供卡片内容。开启加载 200 毫秒后显示遮罩并暂停卡片交互。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSpin {
        width: parent.width
        spinning: loadingSwitch.checked
        delay: 200
        tip: qsTr('加载中')
        contentDelegate: Rectangle {
            implicitHeight: 100
            radius: 6
            color: HusTheme.Primary.colorInfoBg
            border.color: HusTheme.Primary.colorInfoBorder

            HusText {
                x: 20
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr('卡片内容')
            }
        }
    }

    HusSwitch {
        id: loadingSwitch
        checked: false
        checkedText: qsTr('加载中')
        uncheckedText: qsTr('已就绪')
    }
}
```

---

### 示例 4 - 全屏加载

通过 `fullscreen` 在当前窗口上显示遮罩。

```qml
import QtQuick
import HuskarUI.Basic

HusButton {
    text: qsTr('显示全屏加载')
    onClicked: {
        fullscreenSpin.spinning = true;
        fullscreenTimer.restart();
    }

    HusSpin {
        id: fullscreenSpin
        fullscreen: true
        spinning: false
        sizeHint: 'large'
        tip: qsTr('加载中')
    }

    Timer {
        id: fullscreenTimer
        interval: 2000
        onTriggered: fullscreenSpin.spinning = false
    }
}
```

---

### 示例 5 - 自定义提示文案

通过 `tip` 属性设置提示文案。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusSpin { sizeHint: 'small'; tip: 'Loading' }
    HusSpin { sizeHint: 'normal'; tip: 'Loading' }
    HusSpin { sizeHint: 'large'; tip: 'Loading' }
}
```

---

### 示例 6 - 展示进度

将 `percent` 设为 `'auto'` 可自动模拟进度，也可直接传入百分比来显示真实进度。

```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 20

    HusSpin { percent: 'auto' }
    HusSpin { percent: 40 }
    HusSpin { percent: 80 }
}
```

---

### 示例 7 - 自定义指示符

通过 `indicatorDelegate` 属性自定义指示符。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    Component {
        id: myIndicator

        HusIconText {
            iconSize: parent.width
            iconSource: HusIcon.LoadingOutlined
            colorIcon: HusTheme.Primary.colorPrimary
        }
    }

    HusSpin { sizeHint: 'small'; indicatorDelegate: myIndicator }
    HusSpin { sizeHint: 'normal'; indicatorDelegate: myIndicator }
    HusSpin { sizeHint: 'large'; indicatorDelegate: myIndicator }
}
```

---

### 示例 8 - 自定义指示符子项

通过 `indicatorItemDelegate` 属性自定义指示符子项。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    Component {
        id: myIndicatorItem

        HusIconText {
            iconSize: itemSize
            iconSource: HusIcon.SmileOutlined
            colorIcon: colorArray[index]
            property var colorArray: [
                HusTheme.Primary.colorInfo,
                HusTheme.Primary.colorSuccess,
                HusTheme.Primary.colorWarning,
                HusTheme.Primary.colorError,
            ]
        }
    }

    HusSpin { sizeHint: 'small'; indicatorItemDelegate: myIndicatorItem }
    HusSpin { sizeHint: 'normal'; indicatorItemDelegate: myIndicatorItem }
    HusSpin { sizeHint: 'large'; indicatorItemDelegate: myIndicatorItem }
}
```


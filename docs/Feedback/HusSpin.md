[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusSpin 加载中


用于页面和区块的加载中状态。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **indicatorDelegate: Component** 指示器代理

- **indicatorItemDelegate: Component** 指示器子项代理，代理可访问属性：

  - `index: int` 指示器索引

  - `itemSize: int` 子项大小(等同于 `indicatorSize` )

- **tipDelegate: Component** 提示代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
spinSize | real | 24 | 内容项大小
indicatorSize | real | 7 | 指示器大小
indicatorItemCount | int | 4 | 指示项数量
spinning | bool | true | 是否为加载中状态
tip | string | '' | 提示文本
percent | string丨int | 'auto' | 进度百分比
colorTip | color | - | 提示文本颜色
colorIndicator | color | - | 指示器颜色
colorProgressBar | color | - | 进度条颜色
sizeHint | string | 'normal' | 尺寸提示
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

切换卡片加载中状态。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    Rectangle {
        width: parent.width
        height: 100
        radius: 6
        enabled: !loadingSwitch.checked
        color: enabled ? HusThemeFunctions.alpha(HusTheme.Primary.colorInfoBgHover, 0.5) :
                         HusThemeFunctions.alpha(HusTheme.Primary.colorInfoBg, 0.5)
        border.color: enabled ? HusThemeFunctions.alpha(HusTheme.Primary.colorInfoBorderHover, 0.5) :
                                HusThemeFunctions.alpha(HusTheme.Primary.colorInfoBorder, 0.5)

        Behavior on color { ColorAnimation { duration: HusTheme.Primary.durationMid } }

        HusText {
            x: 20
            anchors.verticalCenter: parent.verticalCenter
            text: 'Alert message title\n\nFurther details about the context of this alert.'
            color: enabled ? HusTheme.Primary.colorTextPrimary : HusTheme.Primary.colorTextQuaternary

            Behavior on color { ColorAnimation { duration: HusTheme.Primary.durationMid } }
        }

        HusSpin {
            anchors.centerIn: parent
            spinning: loadingSwitch.checked
        }
    }

    Row {
        spacing: 10

        HusText {
            text: 'Loading state：'
        }

        HusSwitch {
            id: loadingSwitch
            checked: false
        }
    }
}
```

---

### 示例 4 - 自定义提示文案

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

### 示例 5 - 展示进度

通过 `percent` 属性设置进度百分比，设置为 `'auto'` 时显示为加载中，设置为 `0~100` 时显示为进度条。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusSwitch {
        id: progressSwitch
        checked: true
        checkedText: 'Auto'
        uncheckedText: 'Progress'
        onCheckedChanged: {
            if (checked) {
                progressTimer.stop();
            } else {
                progressTimer.progress = 0;
                progressTimer.restart();
            }
        }

        Timer {
            id: progressTimer
            interval: 50
            repeat: true
            onTriggered: {
                progress += 1;
                if (progress >= 100)
                    stop();
            }
            property real progress: 0
        }
    }

    HusSpin {
        sizeHint: 'small'
        percent: progressSwitch.checked ? 'auto' : progressTimer.progress
    }

    HusSpin {
        sizeHint: 'normal'
        percent: progressSwitch.checked ? 'auto' : progressTimer.progress
    }

    HusSpin {
        sizeHint: 'large'
        percent: progressSwitch.checked ? 'auto' : progressTimer.progress
    }
}
```

---

### 示例 6 - 自定义指示符

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

### 示例 7 - 自定义指示符子项

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


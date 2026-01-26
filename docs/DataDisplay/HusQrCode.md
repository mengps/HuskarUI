[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusQrCode 二维码 


能够将文本转换生成二维码的组件，支持自定义配色和 Logo 配置。

* **模块 { HuskarUI.Basic }**

* **继承自 { Item }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
text | string | '' | 要编码的内容
margin | int | 4 | 边距
errorLevel | enum | HusQrCode.Medium | 纠错等级(来自 HusQrCode)
icon.url | url | '' | 图标链接
icon.width | int | 40 | 图标宽度
icon.height | int | 40 | 图高度标
color | color | 'black' | 二维码颜色
colorMargin | color | 'transparent' | 边距颜色
colorBg | color | 'transparent' | 背景颜色

<br/>

<br/>

## 代码演示

### 示例 1 - 基本使用

通过 `text` 属性设置文本内容。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusQrCode {
        text: input.text
        color: HusTheme.Primary.colorTextBase

        Rectangle {
            anchors.fill: parent
            radius: HusTheme.Primary.radiusPrimary
            color: 'transparent'
            border.color: HusTheme.Primary.colorFillPrimary
        }
    }

    HusInput {
        id: input
        width: 280
        maximumLength: 60
        text: 'https://github.com/mengps/HuskarUI'
    }
}
```

---

### 示例 2 - 带 Icon 的例子

通过 `icon` 属性设置图标对象，支持的属性有：

- icon.url 图标链接

- icon.width 图标宽度(默认40)

- icon.height 图标高度(默认40)

通过 `errorLevel` 属性设置错误级别，支持的级别有：

- L级 { HusQrCode.Low }

- M级(默认) { HusQrCode.Medium }

- Q级 { HusQrCode.Quartile }

- H级{ HusQrCode.High }

**说明:** L级 可纠正约 7% 错误、M级 可纠正约 15% 错误、Q级 可纠正约 25% 错误、H级 可纠正约30% 错误。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusQrCode {
        text: 'https://github.com/mengps/HuskarUI'
        errorLevel: HusQrCode.High
        color: HusTheme.Primary.colorTextBase
        icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

        Rectangle {
            anchors.fill: parent
            radius: HusTheme.Primary.radiusPrimary
            color: 'transparent'
            border.color: HusTheme.Primary.colorFillPrimary
        }
    }
}
```

---

### 示例 3 - 自定义尺寸

通过 `width/height` 属性设置二维码大小。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusButtonBlock {
        id: sizeBlock
        model: [
            { iconSource: HusIcon.MinusOutlined, autoRepeat: true, label: 'Smaller' },
            { iconSource: HusIcon.PlusOutlined, autoRepeat: true, label: 'Larger' },
        ]
        onClicked:
            (index) => {
                if (index === 0) size = Math.max(48, Math.min(300, size - 10));
                if (index === 1) size = Math.max(48, Math.min(300, size + 10));
            }
        property int size: 160
    }

    HusQrCode {
        text: 'https://github.com/mengps/HuskarUI'
        width: sizeBlock.size
        height: sizeBlock.size
        errorLevel: HusQrCode.High
        color: HusTheme.Primary.colorTextBase
        icon.url: 'https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg'

        Rectangle {
            anchors.fill: parent
            radius: HusTheme.Primary.radiusPrimary
            color: 'transparent'
            border.color: HusTheme.Primary.colorFillPrimary
        }
    }
}
```

---

### 示例 4 - 自定义颜色

通过 `color` 属性设置二维码颜色。

通过 `colorBg` 属性设置背景颜色。

通过 `colorMargin` 属性设置边缘颜色。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusQrCode {
        text: 'https://github.com/mengps/HuskarUI'
        color: HusTheme.Primary.colorSuccess
    }

    HusQrCode {
        text: 'https://github.com/mengps/HuskarUI'
        color: HusTheme.Primary.colorInfo
        colorBg: HusTheme.Primary.colorWarning
        colorMargin: "#80ff0000"
    }
}
```

---

### 示例 5 - 高级用法

带气泡卡片的例子。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusButton {
        text: 'Hover me'
        type: HusButton.Type_Primary

        HusPopover {
            x: (parent.width - width) * 0.5
            y: parent.height + 6
            width: 160
            visible: parent.hovered || parent.down
            closePolicy: HusPopover.NoAutoClose
            contentDelegate: HusQrCode {
                text: 'https://github.com/mengps/HuskarUI'
                color: HusTheme.Primary.colorTextBase
            }
        }
    }
}
```


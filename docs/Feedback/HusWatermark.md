[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusWatermark 水印 


可给页面的任意项加上水印。

* **模块 { HuskarUI.Basic }**

* **继承自 { Item }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
text | string | '' | 水印文本(和图片二选一)
image | url | '' | 水印图片地址
markSize | size | - | 水印大小
gap | point | (100,100) | 水印间隔
offset | point | (50,50) | 水印偏移
rotate | real | - | 水印旋转角度(0~360)
font | font | - | 水印字体
colorText | color | - | 水印文本颜色

<br/>

## 代码演示

### 示例 1

通过 `text` 属性设置需要水印的文本。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    HusSlider {
        id: slider1
        width: 200
        height: 30
        min: 0
        max: 360
        stepSize: 1
        value: 0

        HusCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('旋转角度: ') + parent.currentValue.toFixed(0)
        }
    }

    Rectangle {
        width: 400
        height: 400
        color: 'transparent'
        border.color: HusTheme.Primary.colorTextBase

        HusWatermark {
            anchors.fill: parent
            anchors.margins: 1
            offset.x: -50
            offset.y: -50
            text: qsTr('HuskarUI')
            rotate: slider1.currentValue
            font.family: HusTheme.Primary.fontPrimaryFamily
            colorText: '#80ff0000'
        }

        HusText {
            anchors.centerIn: parent
            text: qsTr('文字水印测试')
            font {
                family: HusTheme.Primary.fontPrimaryFamily
                pixelSize: HusTheme.Primary.fontPrimarySize + 20
            }
        }
    }
}
```

---

### 示例 2

通过 `image` 属性设置需要水印图像的链接(可以是本地)。

```qml
import QtQuick
import HuskarUI.Basic

Column {
    HusSlider {
        id: slider2
        width: 200
        height: 30
        min: 0
        max: 360
        stepSize: 1
        value: 0

        HusCopyableText {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 10
            text: qsTr('旋转角度: ') + parent.currentValue.toFixed(0)
        }
    }

    Rectangle {
        width: 400
        height: 400
        color: 'transparent'
        border.color: HusTheme.Primary.colorTextBase

        HusWatermark {
            anchors.fill: parent
            anchors.margins: 1
            offset.x: -50
            offset.y: -50
            image: 'https://avatars.githubusercontent.com/u/33405710?v=4'
            markSize.width: 100
            markSize.height: 100
            rotate: slider2.currentValue
            colorText: '#80ff0000'
            font.family: HusTheme.Primary.fontPrimaryFamily
        }

        HusText {
            anchors.centerIn: parent
            text: qsTr('图片水印测试')
            font {
                family: HusTheme.Primary.fontPrimaryFamily
                pixelSize: HusTheme.Primary.fontPrimarySize + 20
            }
        }
    }
}
```


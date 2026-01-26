[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusAvatar 头像 


用来代表用户或事物，支持图片、图标或字符展示。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
size | int | 30 | 头像大小
iconSource | int丨string | 0 | 头像图标(来自 HusIcon)或图标链接
imageSource | url | '' | 头像图像
imageMipmap | bool | false | 是否开启层级映射
textSource | string | '' | 头像文本
textFont | font | - | 文本字体(文本头像时生效)
textSize | enum | HusAvatar.Size_Fixed | 文本大小模式(来自 HusAvatar)
textGap | int | 4 | 文本距离两侧单位像素(文本头像时生效)
colorBg | color | - | 背景颜色
colorIcon | color | 'white' | 图标颜色(图标头像时生效)
colorText | color | 'white' |文本颜色(文本头像时生效)
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角

 **注意** `[iconSource/imageSource/textSource]`只需提供一种即可

<br/>

## 代码演示

### 示例 1 - 基本

通过 `size` 属性设置大小。

通过 `radiusBg` 属性设置圆角大小(默认为size一半, 即圆形)。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    Row {
        spacing: 10

        HusAvatar {
            size: 100
            iconSource: HusIcon.UserOutlined
        }

        HusAvatar {
            size: 80
            iconSource: HusIcon.UserOutlined
        }

        HusAvatar {
            size: 60
            iconSource: HusIcon.UserOutlined
        }

        HusAvatar {
            size: 40
            iconSource: HusIcon.UserOutlined
        }

        HusAvatar {
            size: 20
            iconSource: HusIcon.UserOutlined
        }
    }

    Row {
        spacing: 10

        HusAvatar {
            size: 100
            iconSource: HusIcon.UserOutlined
            radiusBg.all: 6
        }

        HusAvatar {
            size: 80
            iconSource: HusIcon.UserOutlined
            radiusBg.all: 6
        }

        HusAvatar {
            size: 60
            iconSource: HusIcon.UserOutlined
            radiusBg.all: 6
        }

        HusAvatar {
            size: 40
            iconSource: HusIcon.UserOutlined
            radiusBg.all: 6
        }

        HusAvatar {
            size: 20
            iconSource: HusIcon.UserOutlined
            radiusBg.all: 6
        }
    }
}
```

---

### 示例 2 - 类型

支持三种类型：图片、图标以及字符型头像。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusAvatar {
        anchors.verticalCenter: parent.verticalCenter
        iconSource: HusIcon.UserOutlined
    }

    HusAvatar {
        anchors.verticalCenter: parent.verticalCenter
        textSource: 'U'
    }

    HusAvatar {
        anchors.verticalCenter: parent.verticalCenter
        textSource: 'USER'
    }

    HusAvatar {
        anchors.verticalCenter: parent.verticalCenter
        imageSource: 'https://avatars.githubusercontent.com/u/33405710?v=4'
    }

    HusAvatar {
        anchors.verticalCenter: parent.verticalCenter
        textSource: 'U'
        colorText: '#F56A00'
        colorBg: '#FDE3CF'
    }

    HusAvatar {
        anchors.verticalCenter: parent.verticalCenter
        iconSource: HusIcon.UserOutlined
        colorBg: '#87D068'
    }
}
```

---

### 示例 3 - 自动调整字符型头像大小

通过 `textSize` 属性设置文本大小调整模式，支持的大小：

- 固定大小(默认) { HusAvatar.Size_Fixed }

- 自动计算大小 { HusAvatar.Size_Auto }

通过 `textGap` 属性设置字符距离左右两侧边界单位像素。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    spacing: 10

    HusAvatar {
        anchors.verticalCenter: parent.verticalCenter
        size: 40
        textSource: changeButton.userList[changeButton.index]
        colorBg: changeButton.colorList[changeButton.index]
        textSize: HusAvatar.Size_Fixed
    }

    HusAvatar {
        anchors.verticalCenter: parent.verticalCenter
        size: 40
        textSource: changeButton.userList[changeButton.index]
        colorBg: changeButton.colorList[changeButton.index]
        textSize: HusAvatar.Size_Auto
    }

    HusButton {
        id: changeButton
        anchors.verticalCenter: parent.verticalCenter
        text: qsTr('ChangeUser')
        onClicked: {
            index = (index + 1) % 4;
        }
        property int index: 0
        property var userList: ['U', 'Lucy', 'Tom', 'Edward']
        property var colorList: ['#f56a00', '#7265e6', '#ffbf00', '#00a2ae']
    }
}
```


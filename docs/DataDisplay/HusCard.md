[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusCard 卡片 


通用卡片容器。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **titleDelegate: Component** 卡片标题代理

- **extraDelegate: Component** 卡片右上角操作代理

- **coverDelegate: Component** 卡片封面代理

- **bodyDelegate: Component** 卡片主体代理

- **actionDelegate: Component** 卡片动作代理


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
hoverable | bool | false | 鼠标移过时可浮起
showShadow | bool | hoverable | 是否显示阴影
title | string | '' | 标题文本
coverSource | url | '' | 封面图片链接
coverFillMode | enum | Image.Stretch | 封面图片填充模式(来自 Image)
bodyAvatarSize | int |  40 | 内容字体
bodyAvatarIcon | int | 0 | 主体部分头像图标(来自 HusIcon)
bodyAvatarSource | url | '' | 主体部分头像链接
bodyAvatarText | string | '' | 主体部分头像文本
bodyTitle | string | '' | 主体部分标题文本
bodyDescription | string | '' | 主体部分描述文本
titleFont | font | - | 标题字体
bodyTitleFont | font | - | 主体部分标题字体
bodyDescriptionFont | font | - | 主体部分描述字体
colorTitle | color | - | 标题文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorShadow | color | - | 阴影颜色
colorBodyAvatar | color | - | 主体部分头像颜色
colorBodyAvatarBg | color | - | 主体部分头像背景颜色
colorBodyTitle | color | - | 主体部分标题颜色
colorBodyDescription | color | - | 主体部分描述颜色

 **注意** `[bodyAvatarIcon/bodyAvatarSource/bodyAvatarText]`只需提供一种即可

<br/>

## 代码演示

### 示例 1 - 典型卡片

包含标题、内容、操作区域。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    HusSwitch {
        id: shadowSwitch
        checked: true
        text: 'Show shadow: '
    }

    HusCard {
        title: 'Card title'
        showShadow: shadowSwitch.checked
        extraDelegate: HusButton { type: HusButton.Type_Link; text: 'More' }
        bodyDescription: 'Card content\nCard content\nCard content'
    }
}
```

---

### 示例 2 - 悬浮效果

通过 `hoverable` 属性设置鼠标移过时可浮起。

通过 `colorShadow` 属性设置阴影颜色。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 15

    Row {
        spacing: 5

        HusText {
            text: 'ShadowColor: '
            anchors.verticalCenter: parent.verticalCenter
        }

        HusColorPicker {
            id: colorPicker
            autoChange: false
            changeValue: HusTheme.Primary.colorTextBase
            onChange: (color) => changeValue = color;
        }
    }

    Grid {
        rows: 2
        columns: 3
        spacing: -1

        Repeater {
            model: 6

            HusCard {
                hoverable: true
                title: 'Title'
                bodyDelegate: null
                radiusBg.all: 0
                colorShadow: colorPicker.value
            }
        }
    }
}
```

---

### 示例 3 - 整体结构

通过代理可自由定制卡片内容: 

- **titleDelegate: Component** 卡片标题代理

- **extraDelegate: Component** 卡片右上角操作代理

- **coverDelegate: Component** 卡片封面代理

- **bodyDelegate: Component** 卡片主体代理

- **actionDelegate: Component** 卡片动作代理

将代理设置为 `Item {}` 可以隐藏该部分。


```qml
import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Row {
    width: parent.width

    HusCard {
        id: card
        title: 'Card title'
        extraDelegate: HusButton { type: HusButton.Type_Link; text: 'More' }
        coverSource: 'https://gw.alipayobjects.com/zos/rmsportal/JiqGstEfoWAOHiTxclqi.png'
        bodyAvatarIcon: HusIcon.AccountBookOutlined
        bodyTitle: 'Card Meta title'
        bodyDescription: 'This is the description'
        actionDelegate: Item {
            height: 45

            HusDivider {
                width: parent.width
                height: 1
            }

            RowLayout {
                width: parent.width
                height: parent.height

                Item {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    HusIconText {
                        anchors.centerIn: parent
                        iconSource: HusIcon.SettingOutlined
                        iconSize: 16
                    }
                }

                Item {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    HusDivider {
                        width: 1
                        height: parent.height * 0.5
                        anchors.verticalCenter: parent.verticalCenter
                        orientation: Qt.Vertical
                    }

                    HusIconText {
                        anchors.centerIn: parent
                        iconSource: HusIcon.EditOutlined
                        iconSize: 16
                    }
                }

                Item {
                    Layout.preferredWidth: parent.width / 3
                    Layout.fillHeight: true

                    HusDivider {
                        width: 1
                        height: parent.height * 0.5
                        anchors.verticalCenter: parent.verticalCenter
                        orientation: Qt.Vertical
                    }

                    HusIconText {
                        anchors.centerIn: parent
                        iconSource: HusIcon.EllipsisOutlined
                        iconSize: 16
                    }
                }
            }
        }
    }
}
```


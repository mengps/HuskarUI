[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusTag 标签 


进行标记和分类的小标签。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
tagState | enum | HusTag.State_Default | 标签状态(来自 HusTag)
text | string | '' | 标签文本
rotating | bool | false | 旋转中
iconSource | int丨string | 0丨'' | 图标(来自 HusIcon)或图标链接
iconSize | int | - | 图标大小
closeIconSource | int丨string | 0丨'' | 关闭图标(来自 HusIcon)或图标链接
closeIconSize | int | true | 关闭图标大小
presetColor | string | '' | 预设颜色
colorText | color | - |文本颜色
colorBg | color | - | 背景颜色
colorBorder | color | - | 边框颜色
colorIcon | color | - | 图标颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角

<br/>

### 支持的信号：

- `close()` 点击关闭图标(如果有)时发出


<br/>

## 代码演示

### 示例 1 - 基本用法

基本标签的用法

通过 `text` 设置标签文本。

通过 `closeIconSource` 设置关闭图标。

点击关闭图标将发送 `close` 信号。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    Row {
        spacing: 10

        HusTag {
            text: 'Tag 1'
        }

        HusTag {
            text: 'Link'

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    Qt.openUrlExternally('https://github.com/mengps/HuskarUI');
                }
            }
        }

        HusTag {
            text: 'Prevent Default'
            closeIconSource: HusIcon.CloseOutlined
        }

        HusTag {
            text: 'Tag 2'
            closeIconSource: HusIcon.CloseCircleOutlined
        }
    }
}
```

---

### 示例 2 - 多彩标签

通过 `presetColor` 设置预设颜色。

支持的预设颜色：

**['red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta']** 

如果预设颜色不在该列表中，则为自定义标签。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    Row {
        spacing: 10

        Repeater {
            model: [ 'red', 'volcano', 'orange', 'gold', 'yellow', 'lime', 'green', 'cyan', 'blue', 'geekblue', 'purple', 'magenta' ]
            delegate: HusTag {
                text: modelData
                presetColor: modelData
            }
        }
    }

    Row {
        spacing: 10

        Repeater {
            model: [ '#f50', '#2db7f5', '#87d068', '#108ee9' ]
            delegate: HusTag {
                text: modelData
                presetColor: modelData
            }
        }
    }
}
```

---

### 示例 3 - 动态添加和删除

简单生成一组标签，利用 `close()` 信号可以实现动态添加和删除。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    Flow {
        width: parent.width
        spacing: 10

        Repeater {
            id: editRepeater
            model: ListModel {
                id: editTagsModel
                ListElement { tag: 'Unremovable'; removable: false }
                ListElement { tag: 'Tag 1'; removable: true }
                ListElement { tag: 'Tag 2'; removable: true }
            }
            delegate: HusTag {
                text: tag
                closeIconSource: removable ? HusIcon.CloseOutlined : 0
                onClose: {
                    editTagsModel.remove(index, 1);
                }
            }
        }

        HusInput {
            width: 100
            font.pixelSize: HusTheme.Primary.fontPrimarySize - 2
            iconSource: HusIcon.PlusOutlined
            placeholderText: 'New Tag'
            colorBg: 'transparent'
            onAccepted: {
                focus = false;
                editTagsModel.append({ tag: text, removable: true })
                clear();
            }
        }
    }
}
```

---

### 示例 4 - 带图标的标签

通过 `iconSource` 设置左侧图标。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    width: parent.width
    spacing: 10

    HusTag {
        text: 'Twitter'
        iconSource: HusIcon.TwitterOutlined
        presetColor: '#55acee'
    }

    HusTag {
        text: 'Youtube'
        iconSource: HusIcon.YoutubeOutlined
        presetColor: '#cd201f'
    }

    HusTag {
        text: 'Facebook '
        iconSource: HusIcon.FacebookOutlined
        presetColor: '#3b5999'
    }

    HusTag {
        text: 'LinkedIn'
        iconSource: HusIcon.LinkedinOutlined
        presetColor: '#55acee'
    }
}
```

---

### 示例 5 - 预设状态的标签

通过 `rotating` 设置图标是否旋转中。

通过 `tagState` 来设置不同的状态，支持的状态有：

- 默认状态(默认){ HusTag.State_Default }

- 成功状态{ HusTag.State_Success }

- 处理中状态{ HusTag.State_Processing }

- 错误状态{ HusTag.State_Error }

- 警告状态{ HusTag.State_Warning }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    Row {
        spacing: 10

        HusTag {
            text: 'success'
            tagState: HusTag.State_Success
        }

        HusTag {
            text: 'processing'
            tagState: HusTag.State_Processing
        }

        HusTag {
            text: 'error'
            tagState: HusTag.State_Error
        }

        HusTag {
            text: 'warning'
            tagState: HusTag.State_Warning
        }

        HusTag {
            text: 'default'
            tagState: HusTag.State_Default
        }
    }

    Row {
        spacing: 10

        HusTag {
            text: 'success'
            tagState: HusTag.State_Success
            iconSource: HusIcon.CheckCircleOutlined
        }

        HusTag {
            text: 'processing'
            rotating: true
            tagState: HusTag.State_Processing
            iconSource: HusIcon.SyncOutlined
        }

        HusTag {
            text: 'error'
            tagState: HusTag.State_Error
            iconSource: HusIcon.CloseCircleOutlined
        }

        HusTag {
            text: 'warning'
            tagState: HusTag.State_Warning
            iconSource: HusIcon.ExclamationCircleOutlined
        }

        HusTag {
            text: 'waiting'
            tagState: HusTag.State_Default
            iconSource: HusIcon.ClockCircleOutlined
        }

        HusTag {
            text: 'stop'
            tagState: HusTag.State_Default
            iconSource: HusIcon.MinusCircleOutlined
        }
    }
}
```


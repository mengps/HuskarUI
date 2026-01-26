[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusTimeline 时间轴 


垂直展示的时间流信息。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **nodeDelegate: Component** 节点(圆圈)代理，代理可访问属性：

  - `index: int` 模型数据索引

  - `model: var` 模型数据

- **lineDelegate: Component**  线条项代理，代理可访问属性：

  - `index: int` 模型数据索引

  - `model: var` 模型数据

- **timeDelegate: Component** 时间项代理，代理可访问属性：

  - `index: int` 模型数据索引

  - `model: var` 模型数据

  - `onLeft: bool` 指示项是否应该在左边

- **contentDelegate: Component** 内容项代理，代理可访问属性：

  - `index: int` 模型数据索引

  - `model: var` 模型数据

  - `onLeft: bool` 指示项是否应该在左边


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
initModel | list | [] | 初始模型数组
mode | enum | HusTimeline.Mode_Left | 时间节点展现模式(来自 HusTimeline)
reverse | bool | false | 文本颜色
defaultNodeSize | int | 11 | 默认圆圈大小
defaultLineWidth | int | 1 | 默认线条宽度
defaultTimeFormat | string | 'yyyy-MM-dd' | 默认时间格式
defaultContentFormat | enum | Text.AutoText | 默认内容文本格式(来自 Text)
colorNode | color | - | 圆圈颜色
colorNodeBg | color | - | 圆圈背景颜色
colorLine | color | - | 线条颜色
timeFont | font | - | 时间字体
colorTimeText | color | - | 时间文本颜色
contentFont | font | - | 内容字体
colorContentText | color | - | 内容文本颜色

<br/>

### 模型支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
colorNode | string | 可选 | 本时间节点的节点颜色
iconSource | int丨string | 可选 | 本时间节点的图标源
iconSize | sting | 可选 | 本时间节点的图标大小
loading | bool | 可选 | 本时间节点是否在加载中
time | date | 可选 | 本时间节点的时间
timeFormat | string | 可选 | 本时间节点的展现格式
content | string | 可选 | 本时间节点的内容
contentFormat | enum | 可选 | 本时间节点内容的文本格式(来自 Text)

<br/>

### 支持的函数：

- `get(index: int): Object` 获取 `index` 处的模型数据 

- `set(index: int, object: Object)` 设置 `index` 处的模型数据为 `object` 

- `setProperty(index: int, propertyName: string, value: any)` 设置 `index` 处的模型数据属性名 `propertyName` 值为 `value` 

- `move(from: int, to: int, count: int = 1)` 将 `count` 个模型数据从 `from` 位置移动到 `to` 位置 

- `insert(index: int, object: Object)` 插入时间节点 `object` 到 `index` 处 

- `append(object: Object)` 在末尾添加时间节点 `object` 

- `remove(index: int, count: int = 1)` 删除 `index` 处 `count` 个模型数据 

- `clear()` 清空所有模型数据 


<br/>

## 代码演示

### 示例 1 - 基本用法

通过 `initModel` 属性设置初始标签页的模型{需为list}，时间节点支持的属性有：

- { colorNode: 本时间节点的节点颜色 }

- { icon: 本时间节点的图标 }

- { iconSize: 本时间节点的图标大小 }

- { loading: 本时间节点是否在加载中 }

- { time: 本时间节点的时间(Date) }

- { timeFormat: 本时间节点的展现格式 }

- { content: 本时间节点的内容 }

- { contentFormat: 本时间节点内容的文本格式(如Text.RichText) }

如果未给出 `time`，则不会显示时间部分


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusTimeline {
        width: parent.width
        initModel: [
            {
                content: 'Create a services site',
            },
            {
                content: 'Solve initial network problems',
            },
            {
                content: 'Technical testing',
            },
            {
                content: 'Network problems being solved',
            }
        ]
    }
}
```

---

### 示例 2 - 节点颜色

通过模型数据的 `colorNode` 属性设置节点的颜色

通过模型数据的 `icon` 属性设置节点显示为图标

通过模型数据的 `iconSize` 属性设置图标的大小


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusTimeline {
        width: parent.width
        initModel: [
            {
                colorNode: HusTheme.Primary.colorSuccess,
                content: 'Create a services site',
            },
            {
                colorNode: HusTheme.Primary.colorError,
                content: 'Solve initial network problems 1\nSolve initial network problems 2\nSolve initial network problems 3',
            },
            {
                colorNode: HusTheme.Primary.colorWarning,
                content: 'Technical testing 1\nTechnical testing 2\nTechnical testing 3',
            },
            {
                content: 'Network problems being solved',
            },
            {
                colorNode: '#00CCFF',
                icon: HusIcon.SmileOutlined,
                iconSize: 20,
                content: 'Custom icon testing',
            }
        ]
    }
}
```

---

### 示例 3 - 节点加载中

通过模型数据的 `loading` 属性设置节点为加载中

稍后，可通过 `set()` 或 `setProperty()` 函数将其设置为 `false` 结束加载状态


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusButton {
        text: 'Stop loading'
        type: HusButton.Type_Primary
        onClicked: {
            loadingTimeline.set(3, {
                                    time: new Date(),
                                    loading: false,
                                    content: 'New Content',
                                });
        }
    }

    HusTimeline {
        id: loadingTimeline
        width: parent.width
        initModel: [
            {
                content: 'Create a services site',
            },
            {
                content: 'Solve initial network problems',
            },
            {
                content: 'Technical testing',
            },
            {
                loading: true,
                content: 'Recording...',
            }
        ]
    }
}
```

---

### 示例 4 - 排序和模式

通过属性 `reverse` 控制节点排序，为 false 时按正序排列，为 true 时按倒序排列

通过属性 `mode` 控制节点展现模式，支持的模式：

- 时间在轴左侧(默认){ HusTimeline.Mode_Left }

- 时间在轴右侧{ HusTimeline.Mode_Right }

- 交替展现{ HusTimeline.Mode_Alternate }

通过模型数据的 `time` 属性设置时间，类型为 `Date`

通过模型数据的 `timeFormat` 属性设置时间的格式 

或通过属性 `defaultTimeFormat` 统一设置默认的时间格式


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusButton {
        text: 'Toggle Reverse'
        type: HusButton.Type_Primary
        onClicked: {
            reverseTimeline.reverse = !reverseTimeline.reverse;
        }
    }

    HusRadioBlock {
        id: modeRadio
        initCheckedIndex: 0
        model: [
            { label: 'Left', value: HusTimeline.Mode_Left },
            { label: 'Right', value: HusTimeline.Mode_Right },
            { label: 'Alternate', value: HusTimeline.Mode_Alternate }
        ]
    }

    HusTimeline {
        id: reverseTimeline
        width: parent.width
        mode: modeRadio.currentCheckedValue
        initModel: [
            {
                time: new Date(2020, 2, 19),
                content: 'Create a services site',
            },
            {
                time: new Date(2022, 2, 19),
                content: 'Solve initial network problems',
            },
            {
                content: 'Technical testing',
            },
            {
                time: new Date(2024, 2, 19),
                timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                loading: true,
                content: 'Recording...',
            }
        ]
    }
}
```

---

### 示例 5 - 内容文本格式

通过模型数据的 `contentFormat` 属性设置内容的文本格式，参见 `Text.textFormat`


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusTimeline {
        width: parent.width
        initModel: [
            {
                time: new Date(2020, 2, 19),
                content: '<p style='color:red'>HTML Text</p><br><img src='https://avatars.githubusercontent.com/u/33405710?v=4' width='50' height='50'>',
                contentFormat: Text.RichText
            },
            {
                time: new Date(2022, 2, 19),
                content: 'Solve initial network problems',
            },
            {
                content: 'Technical testing',
            },
            {
                time: new Date(2024, 2, 19),
                timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                loading: true,
                content: '### Markdown Text\n - Line 1\n - Line 2',
                contentFormat: Text.MarkdownText
            }
        ]
    }
}
```


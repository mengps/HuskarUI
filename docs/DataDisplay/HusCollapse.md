[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusCollapse 折叠面板 


可以折叠/展开的内容区域。

* **模块 { HuskarUI.Basic }**

* **继承自 { Control }**


<br/>

### 支持的代理：

- **titleDelegate: Component** 面板标题代理，代理可访问属性：

  - `index: int` 面板项索引

  - `model: var` 面板项数据

  - `isActive: bool` 是否激活

- **contentDelegate: Component** 面板内容代理，代理可访问属性：

  - `index: int` 面板项索引

  - `model: var` 面板项数据

  - `isActive: bool` 是否激活


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
hoverCursorShape | int | Qt.PointingHandCursor | 悬浮时鼠标形状(来自 Qt.*Cursor)
initModel | list | [] | 初始面板模型
count | int | 0 | 模型中的数据条目数
spacing | int | -1 | 每个面板间的间隔
accordion | bool | false | 是否为手风琴
activeKey | string丨list | ''丨[] | 当前激活的键(手风琴模式为string,否则为list)
defaultActiveKey | list | [] | 初始激活的面板项 key 数组
expandIcon | int丨string | HusIcon.RightOutlined | 展开图标(来自 HusIcon)或图标链接
titleFont | font | - | 标题字体
contentFont | font | - | 内容字体
colorBg | color | - | 背景颜色
colorIcon | color | - | 展开图标颜色
colorTitle | color | - | 标题文本颜色
colorTitleBg | color | - | 标题背景颜色
colorContent | color | - | 内容文本颜色
colorContentBg | color | - | 内容背景颜色
colorBorder | color | - | 边框颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景圆角

<br/>

### 支持的函数：

- `get(index: int): Object` 获取 `index` 处的模型数据 

- `set(index: int, object: Object)` 设置 `index` 处的模型数据为 `object` 

- `setProperty(index: int, propertyName: string, value: any)` 设置 `index` 处的模型数据属性名 `propertyName` 值为 `value` 

- `move(from: int, to: int, count: int = 1)` 将 `count` 个模型数据从 `from` 位置移动到 `to` 位置 

- `insert(index: int, object: Object)` 插入标签 `object` 到 `index` 处 

- `append(object: Object)` 在末尾添加标签 `object` 

- `remove(index: int, count: int = 1)` 删除 `index` 处 `count` 个模型数据 

- `clear()` 清空所有模型数据 


<br/>

### 支持的信号：

- `actived(key: string)` 激活面板时发出

  - `key` 该面板的键值


<br/>

## 代码演示

### 示例 1

通过 `defaultActiveKey` 属性设置默认激活(即展开)键，这个例子默认展开了第一个。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusCollapse {
        width: parent.width
        defaultActiveKey: ['1']
        initModel: [
            {
                key: '1',
                title: 'This is panel header 1',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '2',
                title: 'This is panel header 2',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '3',
                title: 'This is panel header 3',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            }
        ]
    }
}
```

---

### 示例 2 - 手风琴

通过 `accordion` 属性设置手风琴模式，始终只有一个面板处在激活状态。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusCollapse {
        width: parent.width
        accordion: true
        initModel: [
            {
                key: '1',
                title: 'This is panel header 1',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '2',
                title: 'This is panel header 2',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '3',
                title: 'This is panel header 3',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            }
        ]
    }
}
```

---

### 示例 3 - 高级定制

通过 `contentDelegate` 属性设置自定义内容代理，可以单独定制每个面板的内容。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    Component {
        id: contentDelegate1
        Rectangle { color: '#80ff0000' }
    }

    Component {
        id: contentDelegate2
        Rectangle { color: '#8000ff00' }
    }

    Component {
        id: contentDelegate3
        Rectangle { color: '#800000ff' }
    }

    HusCollapse {
        width: parent.width
        radiusBg.all: 0
        initModel: [
            {
                key: '1',
                title: 'This is panel header 1',
                contentDelegate: contentDelegate1
            },
            {
                key: '1',
                title: 'This is panel header 2',
                contentDelegate: contentDelegate2
            },
            {
                key: '1',
                title: 'This is panel header 3',
                contentDelegate: contentDelegate3
            },
        ]
        contentDelegate: Item {
            height: 100

            Loader {
                anchors.fill: parent
                sourceComponent: model.contentDelegate
            }
        }
    }
}
```

---

### 示例 4 - 高级定制

通过 `contentDelegate` 属性设置自定义内容代理，可以实现嵌套折叠面板。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusCollapse {
        id: collapse
        width: parent.width
        contentDelegate: Item {
            height: hasChildren ? childrenLoader.implicitHeight + 20 : defaultLoader.implicitHeight

            property var __model: model
            property var __children: model?.children?.initModel
            property bool hasChildren: __children !== undefined

            Loader {
                id: defaultLoader
                active: !hasChildren
                width: parent.width
                sourceComponent: HusCopyableText {
                    padding: 16
                    topPadding: 8
                    bottomPadding: 8
                    text: __model.content
                    font: collapse.contentFont
                    wrapMode: Text.WordWrap
                    color: collapse.colorContent
                }
            }

            Loader {
                id: childrenLoader
                active: hasChildren
                width: parent.width - 20
                anchors.centerIn: parent
                sourceComponent: HusCollapse {
                    initModel: __children
                    defaultActiveKey: ['1-1']
                }
            }
        }
        initModel: [
            {
                key: '1',
                title: 'This is panel header 1',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.',
                children: {
                    initModel: [
                        {
                            key: '1-1',
                            title: 'This is panel header 1-1',
                            content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                        }
                    ]
                }
            },
            {
                key: '2',
                title: 'This is panel header 2',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '3',
                title: 'This is panel header 3',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            }
        ]
    }
}
```

---

### 示例 5

通过 `spacing` 属性设置面板之间的间隔以分离各个面板。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusCollapse {
        width: parent.width
        spacing: 10
        initModel: [
            {
                key: '1',
                title: 'This is panel header 1',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '2',
                title: 'This is panel header 2',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '3',
                title: 'This is panel header 3',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            }
        ]
    }
}
```

---

### 示例 6

通过 `expandIcon` 属性设置展开图标, 设置为 0 则不显示图标。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    width: parent.width
    spacing: 10

    HusCollapse {
        width: parent.width
        expandIcon: HusIcon.CaretRightOutlined
        initModel: [
            {
                key: '1',
                title: 'This is panel header 1',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '2',
                title: 'This is panel header 2',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            },
            {
                key: '3',
                title: 'This is panel header 3',
                content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
            }
        ]
    }
}
```


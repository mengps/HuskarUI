[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusSplitView 分隔视图 


用于水平或垂直布局项目，并在每个项目之间都有一个可拖动的拆分器。

* **模块 { HuskarUI.Basic }**

* **继承自 { SplitView }**


<br/>

### 支持的代理：

- **collapseBarStart: Component** (左侧/上侧)折叠按钮

  - `index: int` 把手索引

  - `collapseBarHovered: bool` 是否悬浮

- **collapseBarEnd: Component** (右侧/下侧)折叠按钮

  - `index: int` 把手索引

  - `collapseBarHovered: bool` 是否悬浮


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
resizable | bool | true | 是否开启拖拽伸缩
showCollapsibleIcon | string丨bool | false | 是否显示快速折叠图标(为'auto'时自动显示)
handleSize | real | 2 | 拖拽把手大小
handleTriggerSize | real | 6 | 拖拽触发区域大小
radiusCollapseBar | [HusRadius](../General/HusRadius.md) | - | 折叠按钮圆角

<br/>

<br/>

## 代码演示

### 示例 1 - 基本用法

最简单的用法。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSplitView {
        width: parent.width
        height: 300

        Rectangle {
            HusSplitView.preferredWidth: parent.width * 0.4
            HusSplitView.fillHeight: true
            HusSplitView.minimumWidth: parent.width * 0.1
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'First'
            }
        }

        Rectangle {
            HusSplitView.fillWidth: true
            HusSplitView.fillHeight: true
            HusSplitView.minimumWidth: parent.width * 0.1
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'Second'
            }
        }
    }
}
```

---

### 示例 2 - 启用/禁用拖拽

通过 `resizable` 属性来启用/禁用拖拽。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSwitch {
        id: resizableSwitch
        checked: false
        checkedText: 'Enabled'
        uncheckedText: 'Disabled'
    }

    HusSplitView {
        width: parent.width
        height: 300
        resizable: resizableSwitch.checked

        Rectangle {
            HusSplitView.preferredWidth: parent.width * 0.4
            HusSplitView.fillHeight: true
            HusSplitView.minimumWidth: parent.width * 0.1
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'First'
            }
        }

        Rectangle {
            HusSplitView.fillWidth: true
            HusSplitView.fillHeight: true
            HusSplitView.minimumWidth: parent.width * 0.1
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'Second'
            }
        }
    }
}
```

---

### 示例 3 - 垂直方向

通过 `orientation` 属性来设置方向。


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    HusSplitView {
        width: parent.width
        height: 300
        orientation: Qt.Vertical

        Rectangle {
            HusSplitView.fillWidth: true
            HusSplitView.preferredHeight: parent.height * 0.5
            HusSplitView.minimumHeight: parent.height * 0.1
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'First'
            }
        }

        Rectangle {
            HusSplitView.fillWidth: true
            HusSplitView.preferredHeight: parent.height * 0.5
            HusSplitView.minimumHeight: parent.height * 0.1
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'Second'
            }
        }
    }
}
```

---

### 示例 4 - 可折叠图标显示

通过 `showCollapsibleIcon` 属性来控制可折叠图标的显示方式，支持的方式有：

- 不显示(默认){ false }

- 始终显示{ true }

- 悬浮时显示{ 'auto' }


```qml
import QtQuick
import HuskarUI.Basic

Column {
    spacing: 10

    Row {
        spacing: 20

        HusText {
            text: 'ShowCollapsibleIcon:'
        }

        HusRadio {
            text: 'Auto'
            checked: true
            onToggled: splitView.showCollapsibleIcon = 'auto';
        }

        HusRadio {
            text: 'True'
            onToggled: splitView.showCollapsibleIcon = true;
        }

        HusRadio {
            text: 'False'
            onToggled: splitView.showCollapsibleIcon = false;
        }
    }

    HusSplitView {
        id: splitView
        width: parent.width
        height: 300
        showCollapsibleIcon: 'auto'

        Rectangle {
            HusSplitView.preferredWidth: parent.width * 0.2
            HusSplitView.fillHeight: true
            clip: true
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'First'
            }
        }

        Rectangle {
            HusSplitView.preferredWidth: parent.width * 0.2
            HusSplitView.fillHeight: true
            clip: true
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'Second'
            }
        }

        Rectangle {
            HusSplitView.preferredWidth: parent.width * 0.6
            HusSplitView.fillHeight: true
            clip: true
            color: HusTheme.Primary.colorBgBase

            HusText {
                anchors.centerIn: parent
                text: 'Third'
            }
        }
    }
}
```


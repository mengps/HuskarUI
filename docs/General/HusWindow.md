[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusWindow 无边框窗口


跨平台无边框窗口的最佳实现，基于 [QWindowKit](https://github.com/stdware/qwindowkit)。

* **模块 { HuskarUI.Basic }**

* **继承自 { Window }**


<br/>

### 支持的代理：

- 无


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
contentHeight | int | - | 窗口内容高度(即减去标题栏高度)
captionBar | [HusCaptionBar](./HusCaptionBar.md) | - | 窗口标题栏
windowAgent | HusWindowAgent | - | 窗口代理
followThemeSwitch | bool | true | 是否跟随系统明/暗模式自动切换
initialized | bool | false | 指示窗口是否已经初始化完毕
specialEffect | enum | HusWindow.None | 特殊效果(来自 HusWindow)

<br/>

### 支持的函数：

- `setMacSystemButtonsVisible(visible: bool): bool` 设置是否显示系统按钮(MacOSX有效) 

- `setWindowMode(isDark: bool): bool` 设置窗口明/暗模式 

- `setSpecialEffect(specialEffect: int): bool` 设置窗口的特殊效果 


<br/>

## 代码演示

### 示例 1

使用方法等同于 `Window` 

**注意** 不要嵌套使用 HusWindow (源于Qt的某些BUG)：

```qml
HusWindow {
    HusWindow { }
}
```
更应该使用动态创建：

```qml
HusWindow {
   Loader {
       id: loader
       visible: false
       sourceComponent: HusWindow {
           visible: loader.visible
       }
   }
}
```

```qml
import QtQuick
import HuskarUI.Basic

Item {
    height: 50

    HusButton {
        text: (windowLoader.visible ? qsTr('隐藏') : qsTr('显示')) + qsTr('窗口')
        type: HusButton.Type_Primary
        onClicked: windowLoader.visible = !windowLoader.visible;
    }

    Loader {
        id: windowLoader
        visible: false
        sourceComponent: HusWindow {
            width: 600
            height: 400
            visible: windowLoader.visible
            title: qsTr('无边框窗口')
            captionBar.winIconWidth: 0
            captionBar.winIconHeight: 0
            captionBar.winIconDelegate: Item { }
            captionBar.closeCallback: () => windowLoader.visible = false;
        }
    }
}
```


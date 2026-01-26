[← 返回主目录](../index.md)

[← 返回本类别目录](./index.md)

# HusMessage 消息提示 


全局/页面内展示操作反馈信息。

* **模块 { HuskarUI.Basic }**

* **继承自 { Item }**


<br/>

### 支持的代理：

- **messageDelegate: Component** 消息文本代理，代理可访问属性：

  - `parent.index: int` 消息索引

  - `parent.key: string` 消息键

  - `parent.message: string` 消息文本


<br/>

### 支持的属性：

属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
defaultIconSize | int | 18 | 默认图标大小
showCloseButton | bool | false | 是否显示关闭按钮
spacing | int | 10 | 消息之间的间隔
topMargin | int | 12 | 消息距离顶端的距离
bgTopPadding | int | 12 | 背景上部填充
bgBottomPadding | int | 12 | 背景下部填充
bgLeftPadding | int | 12 | 背景左部填充
bgRightPadding | int | 12 | 背景右部填充
colorMessage | color | - | 消息颜色
colorBg | color | - | 背景颜色
colorBgShadow | color | - | 背景阴影颜色
radiusBg | [HusRadius](../General/HusRadius.md) | - | 背景半径
messageFont | font | - | 消息字体
messageSpacing | int | 8 | 消息和图标之间间隔

<br/>

### {message}支持的属性：

属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
key | string | 可选 | 消息键
loading | sting | 可选 | 是否加载中
message | string | 可选 | 消息文本
type | int | 可选 | 消息类型(来自 HusMessage)
duration | int | 可选 | 消息持续时间(默认3000ms)
iconSize | int | 可选 | 消息图标大小
iconSource | int | 可选 | 消息图标
colorIcon | color | 可选 | 消息图标颜色

<br/>

### 支持的函数：

- `info(message: string, duration = 3000)` 弹出一条 `info` 消息。

- `success(message: string, duration = 3000)` 弹出一条 `success` 消息。

- `error(message: string, duration = 3000)` 弹出一条 `error` 消息。

- `warning(message: string, duration = 3000)` 弹出一条 `warning` 消息。

- `loading(message: string, duration = 3000)` 弹出一条 `loading` 消息。

- `open(object: var)` 弹出一条消息体为 `{object}` 的消息。

- `close(key: string)` 关闭一条消息键为 `key` 的消息。

- `clear()` 清空所有消息。

- `getMessage(key: string): object` 获取消息键为 `key` 的消息对象 `object`。

- `setProperty(key: string, property: string, value: var)` 设置消息键为 `key` 的属性 `property` 的值为 `value`。


<br/>

### 支持的信号：

- `closed(key: string)` 消息关闭时发出

  - `key` 消息键


<br/>

## 代码演示

### 示例 1 - 基本用法

一般消息，**注意** 推荐通过将 `parent` 设置为窗口标题栏(window.captionBar)从而将其置于顶层。


```qml
import QtQuick
import HuskarUI.Basic

Item {
    width: parent.width

    HusMessage {
        id: message
        z: 999
        parent: root.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }

    HusButton {
        type: HusButton.Type_Primary
        text: 'Display normal message'
        onClicked: {
            message.info('Hello, HuskarUI!');
        }
    }
}
```

---

### 示例 2 - 其他提示消息类型

包括成功、失败、警告。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    width: parent.width
    spacing: 10

    HusMessage {
        id: message1
        z: 999
        parent: root.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }

    HusButton {
        text: 'Success'
        onClicked: {
            message1.success('This is a success message');
        }
    }

    HusButton {
        text: 'Error'
        onClicked: {
            message1.error('This is an error message');
        }
    }

    HusButton {
        text: 'Warning'
        onClicked: {
            message1.warning('This is a warning message');
        }
    }
}
```

---

### 示例 3 - 修改持续时间

通过 `duration` 属性设置持续时间。

自定义时长 10000ms，默认时长为 3000ms。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    width: parent.width
    spacing: 10

    HusMessage {
        id: message2
        z: 999
        parent: root.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }

    HusButton {
        text: 'Customized display duration'
        onClicked: {
            message2.open({
                              'type': HusMessage.Type_Success,
                              'message': 'This is a prompt message for success, and it will disappear in 10 seconds',
                              'duration': 10000
                          });
        }
    }
}
```

---

### 示例 4 - 加载中

通过 `loading` 属性设置加载中，然后通过 `close()` 自行关闭。

**注意** `close()` 需要设置 `key` 属性。


```qml
import QtQuick
import HuskarUI.Basic

Row {
    width: parent.width
    spacing: 10

    HusMessage {
        id: message3
        z: 999
        parent: root.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }

    HusButton {
        property int index: 0
        text: 'Display a loading indicator'
        onClicked: {
            let key = String(++index);
            message3.open({
                              'key': key,
                              'loading': true,
                              'message': 'Action in progress...',
                              'duration': 60 * 60 * 1000
                          });
            setTimeout(() => message3.close(key), 2500);
        }

        function setTimeout(callback, interval) {
            let timer = Qt.createQmlObject(`import QtQuick; Timer{}`, Qt.application);
            timer.interval = interval;
            timer.triggered.connect(() => { callback(); timer.destroy(); });
            timer.start();
        }
    }
}
```

---

### 示例 5 - 自定义图标和颜色

通过 `iconSource` 属性设置图标源(来自 HusIcon)。

通过 `colorIcon` 属性设置图标颜色。

通过 `showCloseButton` 显示关闭按钮。


```qml
import QtQuick
import HuskarUI.Basic

Item {
    width: parent.width

    HusMessage {
        id: message4
        z: 999
        parent: root.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        showCloseButton: true
    }

    HusButton {
        text: 'Display custom message'
        type: HusButton.Type_Primary
        onClicked: {
            message4.open({
                              'message': 'This is a custom message',
                              'iconSource': HusIcon.AccountBookOutlined,
                              'colorIcon': 'red'
                          });
        }
    }
}
```


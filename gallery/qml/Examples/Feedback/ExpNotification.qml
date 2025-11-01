import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar {}

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusNotification 通知提醒框 \n
全局/页面内展示通知提醒信息。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **messageDelegate: Component** 通知消息代理：\n
  - \`parent.index: int\` 通知索引\n
  - \`parent.key: string\` 通知键\n
  - \`parent.message: string\` 通知消息文本\n
- **descriptionDelegate: Component** 通知描述代理：\n
  - \`parent.index: int\` 通知索引\n
  - \`parent.key: string\` 通知键\n
  - \`parent.description: string\` 通知描述文本\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
position | enum | HusNotification.Position_Top | 通知显示的位置(来自HusNotification)
pauseOnHover | bool | true | 是否悬浮暂停超时
showProgress | bool | false | 是否显示进度条
stackMode | bool | true | 堆叠模式(超过stackThreshold自动堆叠)
stackThreshold | int | 5 | 堆叠阈值
defaultIconSize | int | 20 | 默认图标大小
maxNotificationWidth | int | 300 | 通知框最大宽度
spacing | int | 10 | 通知之间的间隔
showCloseButton | bool | false | 是否显示关闭按钮
topMargin | int | 12 | 通知距离顶端的距离
bgTopPadding | int | 12 | 背景上部填充
bgBottomPadding | int | 12 | 背景下部填充
bgLeftPadding | int | 12 | 背景左部填充
bgRightPadding | int | 12 | 背景右部填充
colorMessage | color | - | 通知消息文本颜色
colorDescription | color | - | 通知描述文本颜色
colorBg | color | - | 背景颜色
colorBgShadow | color | - | 背景阴影颜色
radiusBg | [HusRadius](internal://HusRadius) | - | 背景半径
messageFont | font | - | 通知消息字体
messageSpacing | int | 8 | 通知文本和图标之间的间隔
descriptionFont | font | - | 通知描述字体
descriptionSpacing | int | 10 | 消息和描述之间的间隔
\n<br/>
\n### {notification}支持的属性：\n
属性名 | 类型 | 可选/必选 | 描述
------ | --- | :---: | ---
key | string | 可选 | 通知键
loading | sting | 可选 | 是否加载中
message | string | 可选 | 通知文本
type | int | 可选 | 通知类型(来自 HusNotification)
duration | int | 可选 | 通知持续时间(默认4500ms)
iconSize | int | 可选 | 通知图标大小
iconSource | int | 可选 | 通知图标
colorIcon | color | 可选 | 通知图标颜色
\n<br/>
\n### 支持的函数：\n
- \`info(message: string, description: string, duration = 4500)\` 弹出一条 \`info\` 通知。\n
- \`success(message: string, description: string, duration = 4500)\` 弹出一条 \`success\` 通知。\n
- \`error(message: string, description: string, duration = 4500)\` 弹出一条 \`error\` 通知。\n
- \`warning(message: string, description: string, duration = 4500)\` 弹出一条 \`warning\` 通知。\n
- \`loading(message: string, description: string, duration = 4500)\` 弹出一条 \`loading\` 通知。\n
- \`open(object: var)\` 弹出一条通知体为 \`{object}\` 的通知。\n
- \`close(key: string)\` 关闭一条通知键为 \`key\` 的通知。\n
- \`clear()\` 清空所有通知。\n
- \`getNotification(key: string): object\` 获取通知键为 \`key\` 的通知对象 \`object\`。\n
- \`setProperty(key: string, property: string, value: var)\` 设置通知键为 \`key\` 的属性 \`property\` 的值为 \`value\`。\n
\n<br/>
\n### 支持的信号：\n
- \`closed(key: string)\` 通知关闭时发出\n
  - \`key\` 通知键\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
在系统八个方向显示通知提醒信息。经常用于以下情况：\n
- 较为复杂的通知内容。\n
- 带有交互的通知，给出用户下一步的行动点。\n
- 系统主动推送。\n
                       `)
        }

        ThemeToken {
            source: 'HusNotification'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
一般通知，**注意** 推荐通过将 \`parent\` 设置为窗口覆盖层 \`Overlay.overlay\` 从而将其置于顶层。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Controls.Basic
                import HuskarUI.Basic

                Item {
                    width: parent.width

                    HusNotification {
                        id: notification1
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_TopLeft
                    }

                    HusNotification {
                        id: notification2
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_TopRight
                    }

                    HusNotification {
                        id: notification3
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_BottomLeft
                    }

                    HusNotification {
                        id: notification4
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_BottomRight
                    }

                    HusNotification {
                        id: notification5
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_Top
                    }

                    HusNotification {
                        id: notification6
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_Bottom
                    }

                    Grid {
                        rows: 3
                        columns: 2
                        spacing: 10

                        HusIconButton {
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.RadiusUpleftOutlined
                            text: 'TopLeft'
                            onClicked: {
                                notification1.info('Notification TopLeft', 'Hello, HuskarUI!');
                            }
                        }

                        HusIconButton {
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.RadiusUprightOutlined
                            text: 'TopRight'
                            onClicked: {
                                notification2.info('Notification TopRight', 'Hello, HuskarUI!');
                            }
                        }

                        HusIconButton {
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.RadiusBottomleftOutlined
                            text: 'BottomLeft'
                            onClicked: {
                                notification3.info('Notification BottomLeft', 'Hello, HuskarUI!');
                            }
                        }

                        HusIconButton {
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.RadiusBottomrightOutlined
                            text: 'BottomRight'
                            onClicked: {
                                notification4.info('Notification BottomRight', 'Hello, HuskarUI!');
                            }
                        }

                        HusIconButton {
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.BorderTopOutlined
                            text: 'Top'
                            onClicked: {
                                notification5.info('Notification Top', 'Hello, HuskarUI!');
                            }
                        }

                        HusIconButton {
                            type: HusButton.Type_Primary
                            iconSource: HusIcon.BorderBottomOutlined
                            text: 'Bottom'
                            onClicked: {
                                notification6.info('Notification Bottom', 'Hello, HuskarUI!');
                            }
                        }
                    }
                }
            `
            exampleDelegate: Row {

                HusNotification {
                    id: notification1
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_TopLeft
                }

                HusNotification {
                    id: notification2
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_TopRight
                }

                HusNotification {
                    id: notification3
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_BottomLeft
                }

                HusNotification {
                    id: notification4
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_BottomRight
                }

                HusNotification {
                    id: notification5
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_Top
                }

                HusNotification {
                    id: notification6
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_Bottom
                }

                Grid {
                    rows: 3
                    columns: 2
                    spacing: 10

                    HusIconButton {
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.RadiusUpleftOutlined
                        text: 'TopLeft'
                        onClicked: {
                            notification1.info('Notification TopLeft', 'Hello, HuskarUI!');
                        }
                    }

                    HusIconButton {
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.RadiusUprightOutlined
                        text: 'TopRight'
                        onClicked: {
                            notification2.info('Notification TopRight', 'Hello, HuskarUI!');
                        }
                    }

                    HusIconButton {
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.RadiusBottomleftOutlined
                        text: 'BottomLeft'
                        onClicked: {
                            notification3.info('Notification BottomLeft', 'Hello, HuskarUI!');
                        }
                    }

                    HusIconButton {
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.RadiusBottomrightOutlined
                        text: 'BottomRight'
                        onClicked: {
                            notification4.info('Notification BottomRight', 'Hello, HuskarUI!');
                        }
                    }

                    HusIconButton {
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.BorderTopOutlined
                        text: 'Top'
                        onClicked: {
                            notification5.info('Notification Top', 'Hello, HuskarUI!');
                        }
                    }

                    HusIconButton {
                        type: HusButton.Type_Primary
                        iconSource: HusIcon.BorderBottomOutlined
                        text: 'Bottom'
                        onClicked: {
                            notification6.info('Notification Bottom', 'Hello, HuskarUI!');
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自动关闭的延时')
            desc: qsTr(`
自定义通知框自动关闭的延时，通过 \`duration\` 属性设置持续时间，默认 4.5s。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Controls.Basic
                import HuskarUI.Basic

                Item {
                    width: parent.width
                    HusNotification {
                        id: notification7
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_TopRight
                    }

                    HusButton {
                        type: HusButton.Type_Primary
                        text: 'Open the notification box'
                        onClicked: {
                            notification7.info('Notification Title', 'I will never close automatically. This is a purposely very very long description that has many many characters and words.', 99999999);
                        }
                    }
                }
            `
            exampleDelegate: Row {
                HusNotification {
                    id: notification7
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_TopRight
                }

                HusButton {
                    type: HusButton.Type_Primary
                    text: 'Open the notification box'
                    onClicked: {
                        notification7.info('Notification Title', 'I will never close automatically. This is a purposely very very long description that has many many characters and words.', 99999999);
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('其他提示通知类型')
            desc: qsTr(`
包括成功、信息、失败、警告。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Controls.Basic
                import HuskarUI.Basic

                Row {
                    width: parent.width
                    spacing: 10

                    HusNotification {
                        id: notification8
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_TopRight
                    }

                    HusButton {
                        text: 'Success'
                        onClicked: {
                            notification8.success('Notification Title', 'This is a success notification!');
                        }
                    }

                    HusButton {
                        text: 'Info'
                        onClicked: {
                            notification8.info('Notification Title', 'This is a info notification!');
                        }
                    }

                    HusButton {
                        text: 'Warning'
                        onClicked: {
                            notification8.warning('Notification Title', 'This is a warning notification!');
                        }
                    }

                    HusButton {
                        text: 'Error'
                        onClicked: {
                            notification8.error('Notification Title', 'This is an error notification!');
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusNotification {
                    id: notification8
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_TopRight
                }

                HusButton {
                    text: 'Success'
                    onClicked: {
                        notification8.success('Notification Title', 'This is a success notification!');
                    }
                }

                HusButton {
                    text: 'Info'
                    onClicked: {
                        notification8.info('Notification Title', 'This is a info notification!');
                    }
                }

                HusButton {
                    text: 'Warning'
                    onClicked: {
                        notification8.warning('Notification Title', 'This is a warning notification!');
                    }
                }

                HusButton {
                    text: 'Error'
                    onClicked: {
                        notification8.error('Notification Title', 'This is an error notification!');
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('显示进度条')
            desc: qsTr(`
通过 \`showProgress\` 属性设置是否显示进度条。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Controls.Basic
                import HuskarUI.Basic

                Row {
                    width: parent.width
                    spacing: 10

                    HusNotification {
                        id: notification9
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_TopRight
                        showProgress: true
                    }

                    HusButton {
                        text: 'Show progress notification'
                        onClicked: {
                            notification9.info('Notification Title', 'This is a show progress notification!');
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusNotification {
                    id: notification9
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_TopRight
                    showProgress: true
                }

                HusButton {
                    text: 'Show progress notification'
                    type: HusButton.Type_Primary
                    onClicked: {
                        notification9.info('Notification Title', 'This is a show progress notification!');
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('堆叠')
            desc: qsTr(`
通过 \`stackMode\` 属性设置是否开启堆叠模式。\n
通过 \`stackThreshold\` 属性设置堆叠阈值。\n
                       `)
            code: `
                import QtQuick
                import QtQuick.Controls.Basic
                import HuskarUI.Basic

                Row {
                    width: parent.width
                    spacing: 10

                    HusNotification {
                        id: notification10
                        parent: Overlay.overlay
                        anchors.fill: parent
                        anchors.topMargin: captionBar.height
                        position: HusNotification.Position_TopRight
                        stackMode: stackSwitch.checked
                        stackThreshold: stackThresholdInput.value
                    }

                    HusButton {
                        anchors.verticalCenter: parent.verticalCenter
                        text: 'Open the notification box'
                        type: HusButton.Type_Primary
                        onClicked: {
                            notification10.open({
                                                    message: 'Notification Title',
                                                    description: 'This is the content of the notification. This is the content of the notification. This is the content of the notification.',
                                                    duration: 99999999
                                                });
                        }
                    }

                    HusText {
                        text: 'Enabled stackMode:'
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    HusSwitch {
                        id: stackSwitch
                        anchors.verticalCenter: parent.verticalCenter
                        checked: true
                    }

                    HusInputNumber {
                        id: stackThresholdInput
                        width: 200
                        anchors.verticalCenter: parent.verticalCenter
                        prefix: 'Threshold: '
                        value: 5
                        min: 1
                        max: 10
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                HusNotification {
                    id: notification10
                    parent: Overlay.overlay
                    anchors.fill: parent
                    anchors.topMargin: captionBar.height
                    position: HusNotification.Position_TopRight
                    stackMode: stackSwitch.checked
                    stackThreshold: stackThresholdInput.value
                }

                HusButton {
                    anchors.verticalCenter: parent.verticalCenter
                    text: 'Open the notification box'
                    type: HusButton.Type_Primary
                    onClicked: {
                        notification10.open({
                                                message: 'Notification Title',
                                                description: 'This is the content of the notification. This is the content of the notification. This is the content of the notification.',
                                                duration: 99999999
                                            });
                    }
                }

                HusText {
                    text: 'Enabled stackMode:'
                    anchors.verticalCenter: parent.verticalCenter
                }

                HusSwitch {
                    id: stackSwitch
                    anchors.verticalCenter: parent.verticalCenter
                    checked: true
                }

                HusInputNumber {
                    id: stackThresholdInput
                    width: 200
                    anchors.verticalCenter: parent.verticalCenter
                    prefix: 'Threshold: '
                    value: 5
                    min: 1
                    max: 10
                }
            }
        }
    }
}

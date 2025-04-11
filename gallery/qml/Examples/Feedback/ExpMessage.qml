import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar {}

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelMessage 消息提示 \n
页面内展示操作反馈信息。\n
* **继承自 { Item }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
closeButtonVisible | bool | 是否显示关闭按钮(默认false)
bgTopPadding | int | 背景上部填充
bgBottomPadding | int | 背景下部填充
bgLeftPadding | int | 背景左部填充
bgRightPadding | int | 背景右部填充
colorBg | color | 背景颜色
colorBgShadow | color | 背景阴影颜色
radiusBg | int | 背景半径
messageFont | font | 消息字体
colorMessage | color | 消息颜色
messageSpacing | int | 消息和图标之间间隔
\n{message}支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
key(可选) | string | 消息键
loading(可选) | sting | 数据索引
message | var | 该列的单元格代理
type(可选) | int | 消息类型(来自 DelMessage)
duration(可选) | int | 消息持续时间(默认3000ms)
iconSource(可选) | int | 消息图标
colorIcon(可选) | color | 消息图标颜色
\n支持的函数：\n
- \`info(message: string, duration = 3000)\` 弹出一条 \`info\` 消息。\n
- \`success(message: string, duration = 3000)\` 弹出一条 \`success\` 消息。\n
- \`error(message: string, duration = 3000)\` 弹出一条 \`error\` 消息。\n
- \`warning(message: string, duration = 3000)\` 弹出一条 \`warning\` 消息。\n
- \`loading(message: string, duration = 3000)\` 弹出一条 \`loading\` 消息。\n
- \`open(object: var)\` 弹出一条消息体为 \`{object}\` 的消息。\n
- \`close(key: string)\` 关闭一条消息键为 \`key\` 的消息。\n
- \`setProperty(key: string, property: string, value: var)\` 设置消息键为 \`key\` 的属性 \`property\` 的值为 \`value\`。\n
\n支持的信号：\n
- \`messageClosed(key: string)\` 消息关闭时发出\n
  - \`key\` 消息键\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 可提供成功、警告和错误等反馈信息。\n
- 顶部居中显示并自动消失，是一种不打断用户操作的轻量级提示方式。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本用法')
            desc: qsTr(`
一般消息，**注意** 推荐通过将 \`parent\` 设置为窗口标题栏(window.captionBar)从而将其置于顶层。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Item {
                    width: parent.width

                    DelMessage {
                        id: message
                        z: 999
                        parent: root.captionBar
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                    }

                    DelButton {
                        type: DelButton.Type_Primary
                        text: 'Display normal message'
                        onClicked: {
                            message.info('Hello, DelegateUI!');
                        }
                    }
                }
            `
            exampleDelegate: Row {
                DelMessage {
                    id: message
                    z: 999
                    parent: galleryWindow.captionBar
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                }

                DelButton {
                    type: DelButton.Type_Primary
                    text: 'Display normal message'
                    onClicked: {
                        message.info('Hello, DelegateUI!');
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('其他提示消息类型')
            desc: qsTr(`
包括成功、失败、警告。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    width: parent.width
                    spacing: 10

                    DelMessage {
                        id: message1
                        z: 999
                        parent: root.captionBar
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                    }

                    DelButton {
                        text: 'Success'
                        onClicked: {
                            message1.success('This is a success message');
                        }
                    }

                    DelButton {
                        text: 'Error'
                        onClicked: {
                            message1.error('This is an error message');
                        }
                    }

                    DelButton {
                        text: 'Warning'
                        onClicked: {
                            message1.warning('This is a warning message');
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelMessage {
                    id: message1
                    z: 999
                    parent: galleryWindow.captionBar
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                }

                DelButton {
                    text: 'Success'
                    onClicked: {
                        message1.success('This is a success message');
                    }
                }

                DelButton {
                    text: 'Error'
                    onClicked: {
                        message1.error('This is an error message');
                    }
                }

                DelButton {
                    text: 'Warning'
                    onClicked: {
                        message1.warning('This is a warning message');
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('修改持续时间')
            desc: qsTr(`
通过 \`duration\` 属性设置持续时间。
自定义时长 10000ms，默认时长为 3000ms。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    width: parent.width
                    spacing: 10

                    DelMessage {
                        id: message2
                        z: 999
                        parent: root.captionBar
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                    }

                    DelButton {
                        text: 'Customized display duration'
                        onClicked: {
                            message2.open({
                                              'type': DelMessage.Type_Success,
                                              'message': 'This is a prompt message for success, and it will disappear in 10 seconds',
                                              'duration': 10000
                                          });
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelMessage {
                    id: message2
                    z: 999
                    parent: galleryWindow.captionBar
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                }

                DelButton {
                    text: 'Customized display duration'
                    onClicked: {
                        message2.open({
                                          'type': DelMessage.Type_Success,
                                          'message': 'This is a prompt message for success, and it will disappear in 10 seconds',
                                          'duration': 10000
                                      });
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('加载中')
            desc: qsTr(`
通过 \`loading\` 属性设置加载中，然后通过 \`close()\` 自行关闭。
**注意** \`close()\` 需要设置 \`key\` 属性。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Row {
                    width: parent.width
                    spacing: 10

                    DelMessage {
                        id: message3
                        z: 999
                        parent: root.captionBar
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                    }

                    DelButton {
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
                            let timer = Qt.createQmlObject(\`import QtQuick; Timer{}\`, Qt.application);
                            timer.interval = interval;
                            timer.triggered.connect(() => { callback(); timer.destroy(); });
                            timer.start();
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelMessage {
                    id: message3
                    z: 999
                    parent: galleryWindow.captionBar
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                }

                DelButton {
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
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义图标和颜色')
            desc: qsTr(`
通过 \`iconSource\` 属性设置图标源(来自 DelIcon)。
通过 \`colorIcon\` 属性设置图标颜色。
通过 \`closeButtonVisible\` 显示关闭按钮。
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Item {
                    width: parent.width

                    DelMessage {
                        id: message4
                        z: 999
                        parent: root.captionBar
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                        closeButtonVisible: true
                    }

                    DelButton {
                        text: 'Display custom message'
                        type: DelButton.Type_Primary
                        onClicked: {
                            message4.open({
                                              'message': 'This is a custom message',
                                              'iconSource': DelIcon.AccountBookOutlined,
                                              'colorIcon': "red"
                                          });
                        }
                    }
                }
            `
            exampleDelegate: Row {
                DelMessage {
                    id: message4
                    z: 999
                    parent: galleryWindow.captionBar
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                    closeButtonVisible: true
                }

                DelButton {
                    text: 'Display custom message'
                    type: DelButton.Type_Primary
                    onClicked: {
                        message4.open({
                                          'message': 'This is a custom message',
                                          'iconSource': DelIcon.AccountBookOutlined,
                                          'colorIcon': "red"
                                      });
                    }
                }
            }
        }
    }
}

import QtQuick
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    HusScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# HusSpin 加载中 \n
显示一个正在加载的状态的图标和提示文本。\n
* **继承自 { Item }**\n
\n<br/>
\n### 支持的代理：\n
- **contentDelegate: Component** 内容代理(作为子组件写会更方便)\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | HusTheme.animationEnabled | 是否开启动画
iconSource | int丨string | 0 | 图标源(0 表示默认四叶草)
size | int | 32 | 图标大小
spinning | bool | true | 是否加载中
tip | string | '' | 描述文本
tipSpacing | int | 8 | 描述文本与图标的间距
colorIcon | color | HusTheme.Primary.colorPrimary | 图标颜色
colorTip | color | HusTheme.Primary.colorTextSecondary | 描述文本颜色
delay | int | - | spinning 状态持续多长时间(正数表示启用延迟)
delayCallback | function | function() | 到达延迟时间后的回调
\n<br/>
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
用于页面和区块的加载中状态。\n
页面局部处于等待异步数据或正在渲染过程时,合适的加载动效会有效缓解用户的焦虑。\n
                       `)
        }

        ThemeToken {
            source: 'HusSpin'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            expTitle: '基本用法'
            desc: '一个简单的 loading 状态。'
            code: `HusSpin {
    spinning: true
}`
            exampleDelegate: Item {
                width: parent.width
                height: 100

                HusSpin {
                    anchors.centerIn: parent
                    spinning: true
                }
            }
        }

        CodeBox {
            width: parent.width
            expTitle: '各种大小'
            desc: '小的用于文本加载,默认用于卡片容器级加载,大的用于页面级加载。'
            code: `Row {
    spacing: 50

    HusSpin {
        size: 16
        spinning: true
    }

    HusSpin {
        size: 32
        spinning: true
    }

    HusSpin {
        size: 48
        spinning: true
    }
}`
            exampleDelegate: Item {
                width: parent.width
                height: 100

                Row {
                    anchors.centerIn: parent
                    spacing: 50

                    HusSpin {
                        size: 16
                        spinning: true
                    }

                    HusSpin {
                        size: 32
                        spinning: true
                    }

                    HusSpin {
                        size: 48
                        spinning: true
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('含子组件内容')
            desc: qsTr(`
最简单的用法，支持图像和描述。\n
通过 \`iconSource\` 属性设置图标地址。\n
通过 \`spinning\` 属性设置是否加载中。\n
通过 \`size\` 属性设置图标大小。\n
通过 \`tip\` 属性设置描述文本。\n
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Column {
                    spacing: 10
    
                    HusSwitch {
                        id: spinningSwitch
                        checkedText: 'Spinning'
                        uncheckedText: 'Not-Spinning'
                    }
    
                    HusSpin {
                        width: 250
                        height: 250
                        spinning: spinningSwitch.checked
                        tip: '加载中...'
                        delay: 3000
                        delayCallback: () => {
                            message.success('延迟函数调用完成');
                        }
    
                        Rectangle {
                            anchors.fill: parent
                            color: HusTheme.Primary.colorBgContainer
    
                            Column {
                                anchors.centerIn: parent
                                spacing: 10
    
                                HusText { text: '这是内容区域' }
                                HusButton { text: '按钮' }
                            }
                        }
                    }

                    HusMessage {
                        id: message
                        z: 999
                        parent: galleryWindow.captionBar
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                HusSwitch {
                    id: spinningSwitch
                    checkedText: '加载中'
                    uncheckedText: '不加载'
                }

                HusSpin {
                    width: 250
                    height: 250
                    spinning: spinningSwitch.checked
                    tip: '加载3秒...'
                    delay: 3000
                    delayCallback: () => {
                        message.success('延迟函数调用完成');
                        spinningSwitch.checked = false
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: HusTheme.Primary.colorBgContainer

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            HusText { text: '这是内容区域' }
                        }
                    }
                }

                HusMessage {
                    id: message
                    z: 999
                    parent: galleryWindow.captionBar
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                }
            }
        }
    }
}

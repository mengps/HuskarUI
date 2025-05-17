import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelCarousel 走马灯\n
一组轮播的区域。\n
* **继承自 { Item }**\n
支持的代理：\n
- **contentDelegate: Component** 内容代理，代理可访问属性：\n
  - \`index: int\` 内容项索引\n
  - \`model: var\` 内容项数据\n
- **indicatorDelegate: Component** 指示器代理，代理可访问属性：\n
  - \`index: int\` 指示器索引\n
  - \`model: var\` 指示器数据\n
- **prevDelegate: Component** 向前箭头代理\n
- **nextDelegate: Component** 向后箭头代理\n
支持的属性：\n
属性名 | 类型 | 默认值 | 描述 |
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画
initModel | list | [] | 初始数据模型
currentIndex | int | -1 | 当前索引
position | enum | DelCarousel.Position_Bottom | 滚动的方向和指示器的位置(来自 DelCarousel)
speed | int | 500 | 切换动效的时间(毫秒)
infinite | bool | true | 是否无限滚动
autoplay | bool | false | 是否自动切换
autoplaySpeed | int | 3000 | 自动切换的时间(毫秒)
draggable | bool | true | 是否启用拖拽切换
showIndicator | bool | true | 是否显示指示器
indicatorSpacing | int | 6 | 指示器间隔
showArrow | bool | false | 是否显示箭头
\n支持的函数：\n
- \`swithTo(index: int, animated: bool = true)\` \n
  - \`index\` 要切换的目标处索引
  - \`animated\` 是否使用切换动效
- \`swithToPrev()\` 切换到前一页 \n
- \`swithToNext()\` 切换到后一页 \n
- \`int getSuitableIndicatorWidth(contentWidth: int, indicatorMaxWidth: int = 18)\` 获取合适的指示器宽度 \n
  - \`contentWidth\` 轮播内容的宽度
  - \`indicatorMaxWidth\` 指示器最大宽度
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 当有一组平级的内容。\n
- 当内容空间不足时，可以用走马灯的形式进行收纳，进行轮播展现。\n
- 常用于一组图片或卡片轮播。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本')
            desc: qsTr(`
最简单的用法。\n
通过 \`infinite\` 属性设置是否无限滚动。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10
                    width: parent.width

                    Row {
                        spacing: 10

                        DelText { text: qsTr('无限滚动') }

                        DelSwitch {
                            id: infiniteSwitch
                            checked: true
                        }
                    }

                    DelCarousel {
                        id: carousel1
                        width: parent.width
                        height: 200
                        infinite: infiniteSwitch.checked
                        initModel: [
                            { label: '1' },
                            { label: '2' },
                            { label: '3' },
                            { label: '4' },
                        ]
                        contentDelegate: Rectangle {
                            width: carousel1.width
                            height: carousel1.height
                            color: '#364d79'

                            DelText {
                                anchors.centerIn: parent
                                text: model.label
                                color: 'white'
                                font.pixelSize: 16
                                font.bold: true
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    DelText { text: qsTr('无限滚动') }

                    DelSwitch {
                        id: infiniteSwitch
                        checked: true
                    }
                }

                DelCarousel {
                    id: carousel1
                    width: parent.width
                    height: 200
                    infinite: infiniteSwitch.checked
                    initModel: [
                        { label: '1' },
                        { label: '2' },
                        { label: '3' },
                        { label: '4' },
                    ]
                    contentDelegate: Rectangle {
                        width: carousel1.width
                        height: carousel1.height
                        color: '#364d79'

                        DelText {
                            anchors.centerIn: parent
                            text: model.label
                            color: 'white'
                            font.pixelSize: 16
                            font.bold: true
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('位置')
            desc: qsTr(`
通过 \`position\` 属性设置滚动的方向和指示器的位置，支持的位置：\n
- 水平滚动，指示器在上方，{ DelTabView.Position_Top }\n
- 水平滚动，指示器在下方{ DelCarousel.Position_Bottom }\n
- 垂直滚动，指示器在左方{ DelCarousel.Position_Left }\n
- 垂直滚动，指示器在右方{ DelCarousel.Position_Right }\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10
                    width: parent.width

                    DelRadioBlock {
                        id: positionBlock
                        initCheckedIndex: 1
                        model: [
                            { label: qsTr('上'), value: DelCarousel.Position_Top },
                            { label: qsTr('下'), value: DelCarousel.Position_Bottom },
                            { label: qsTr('左'), value: DelCarousel.Position_Left },
                            { label: qsTr('右'), value: DelCarousel.Position_Right }
                        ]
                    }

                    DelCarousel {
                        id: carousel2
                        width: parent.width
                        height: 200
                        position: positionBlock.currentCheckedValue
                        initModel: [
                            { label: '1' },
                            { label: '2' },
                            { label: '3' },
                            { label: '4' },
                        ]
                        contentDelegate: Rectangle {
                            width: carousel2.width
                            height: carousel2.height
                            color: '#364d79'

                            DelText {
                                anchors.centerIn: parent
                                text: model.label
                                color: 'white'
                                font.pixelSize: 16
                                font.bold: true
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelRadioBlock {
                    id: positionBlock
                    initCheckedIndex: 1
                    model: [
                        { label: qsTr('上'), value: DelCarousel.Position_Top },
                        { label: qsTr('下'), value: DelCarousel.Position_Bottom },
                        { label: qsTr('左'), value: DelCarousel.Position_Left },
                        { label: qsTr('右'), value: DelCarousel.Position_Right }
                    ]
                }

                DelCarousel {
                    id: carousel2
                    width: parent.width
                    height: 200
                    position: positionBlock.currentCheckedValue
                    initModel: [
                        { label: '1' },
                        { label: '2' },
                        { label: '3' },
                        { label: '4' },
                    ]
                    contentDelegate: Rectangle {
                        width: carousel2.width
                        height: carousel2.height
                        color: '#364d79'

                        DelText {
                            anchors.centerIn: parent
                            text: model.label
                            color: 'white'
                            font.pixelSize: 16
                            font.bold: true
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自动切换')
            desc: qsTr(`
通过 \`autoplay\` 属性设置是否自动切换。\n
通过 \`autoplaySpeed\` 属性设置自动切换时间。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10
                    width: parent.width

                    DelCarousel {
                        id: carousel4
                        width: parent.width
                        height: 200
                        autoplay: true
                        initModel: [
                            { label: '1' },
                            { label: '2' },
                            { label: '3' },
                            { label: '4' },
                        ]
                        contentDelegate: Rectangle {
                            width: carousel4.width
                            height: carousel4.height
                            color: '#364d79'

                            DelText {
                                anchors.centerIn: parent
                                text: model.label
                                color: 'white'
                                font.pixelSize: 16
                                font.bold: true
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelCarousel {
                    id: carousel4
                    width: parent.width
                    height: 200
                    autoplay: true
                    initModel: [
                        { label: '1' },
                        { label: '2' },
                        { label: '3' },
                        { label: '4' },
                    ]
                    contentDelegate: Rectangle {
                        width: carousel4.width
                        height: carousel4.height
                        color: '#364d79'

                        DelText {
                            anchors.centerIn: parent
                            text: model.label
                            color: 'white'
                            font.pixelSize: 16
                            font.bold: true
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('切换箭头')
            desc: qsTr(`
通过 \`showArrow\` 属性设置是否显示切换箭头。\n
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Column {
                    spacing: 10
                    width: parent.width

                    DelCarousel {
                        id: carousel5
                        width: parent.width
                        height: 200
                        showArrow: true
                        initModel: [
                            { label: '1' },
                            { label: '2' },
                            { label: '3' },
                            { label: '4' },
                        ]
                        contentDelegate: Rectangle {
                            width: carousel5.width
                            height: carousel5.height
                            color: '#364d79'

                            DelText {
                                anchors.centerIn: parent
                                text: model.label
                                color: 'white'
                                font.pixelSize: 16
                                font.bold: true
                            }
                        }
                    }
                }
            `
            exampleDelegate: Column {
                spacing: 10

                DelCarousel {
                    id: carousel5
                    width: parent.width
                    height: 200
                    showArrow: true
                    initModel: [
                        { label: '1' },
                        { label: '2' },
                        { label: '3' },
                        { label: '4' },
                    ]
                    contentDelegate: Rectangle {
                        width: carousel5.width
                        height: carousel5.height
                        color: '#364d79'

                        DelText {
                            anchors.centerIn: parent
                            text: model.label
                            color: 'white'
                            font.pixelSize: 16
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}

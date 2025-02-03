import QtQuick
import QtQuick.Controls.Basic
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            id: description
            desc: qsTr(`
## DelWindow 无边框窗口\n
跨平台无边框窗口的最佳实现，基于 [QWindowKit](https://github.com/stdware/qwindowkit)。\n
* **继承自 { Window }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
captionBar | DelCaptionBar | 窗口标题栏
windowAgent | DelWindowAgent | 窗口代理
followThemeSwitch | bool | 是否跟随系统明/暗模式自动切换
initialized | bool | 指示窗口是否已经初始化完毕
specialEffect | int | 特殊效果(仅windows有效，来自 DelWindowSpecialEffect)
\n支持的函数：\n
- \`setWindowMode(isDark: bool)\` 设置窗口明/暗模式 \n
- \`setSpecialEffect(specialEffect: int)\` 设置窗口的特殊效果(仅windows有效) \n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
当用户需要自定义窗口形态时作为基础无边框窗口使用，默认提供一个 [DelCaptionBar](internal://DelCaptionBar)。
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Window\` \n
**注意** 不要嵌套使用 DelWindow (源于Qt的某些BUG)：\n
\`\`\`qml
DelWindow {
    DelWindow { }
}
\`\`\`
更应该使用动态创建：\n
\`\`\`qml
DelWindow {
   Loader {
       id: loader
       visible: false
       sourceComponent: DelWindow {
           visible: loader.visible
       }
   }
}
\`\`\`
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Item {
                    height: 50

                    DelButton {
                        text: (windowLoader.visible ? qsTr("隐藏") : qsTr("显示")) + qsTr("窗口")
                        type: DelButton.Type_Primary
                        onClicked: windowLoader.visible = !windowLoader.visible;
                    }

                    Loader {
                        id: windowLoader
                        visible: false
                        sourceComponent: DelWindow {
                            width: 600
                            height: 400
                            visible: windowLoader.visible
                            title: qsTr("无边框窗口")
                            captionBar.winIconWidth: 0
                            captionBar.winIconHeight: 0
                            captionBar.winIconDelegate: Item { }
                            captionBar.closeCallback: () => windowLoader.visible = false;
                        }
                    }
                }
            `
            exampleDelegate: Item {
                height: 50

                DelButton {
                    text: (windowLoader.visible ? qsTr("隐藏") : qsTr("显示")) + qsTr("窗口")
                    type: DelButton.Type_Primary
                    onClicked: windowLoader.visible = !windowLoader.visible;
                }

                Loader {
                    id: windowLoader
                    visible: false
                    sourceComponent: DelWindow {
                        width: 600
                        height: 400
                        visible: windowLoader.visible
                        title: qsTr("无边框窗口")
                        captionBar.winIconWidth: 0
                        captionBar.winIconHeight: 0
                        captionBar.winIconDelegate: Item { }
                        captionBar.closeCallback: () => windowLoader.visible = false;
                    }
                }
            }
        }
    }
}

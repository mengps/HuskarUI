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
跨平台无边框窗口的最佳实现。\n
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

        Text {
            width: parent.width - 20
            height: implicitHeight - 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("代码演示")
            font {
                family: DelTheme.Primary.fontPrimaryFamily
                pixelSize: DelTheme.Primary.fontPrimarySizeHeading3
            }
            color: DelTheme.Primary.colorTextBase
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法等同于 \`Window\`
                       `)
            code: `
                import QtQuick
                import DelegateUI

                Item {
                    height: 50

                    DelButton {
                        text: (window.visible ? qsTr("隐藏") : qsTr("显示")) + qsTr("窗口")
                        type: DelButtonType.Type_Primary
                        onClicked: window.visible = !window.visible;
                    }

                    DelWindow {
                        id: window
                        width: 600
                        height: 400
                        visible: false
                        title: qsTr("无边框窗口")
                        transientParent: null
                        captionBar.winTitle: ""
                        captionBar.winIconDelegate: Item { }
                    }
                }
            `
            exampleDelegate: Item {
                height: 50

                DelButton {
                    text: (window.visible ? qsTr("隐藏") : qsTr("显示")) + qsTr("窗口")
                    type: DelButtonType.Type_Primary
                    onClicked: window.visible = !window.visible;
                }

                DelWindow {
                    id: window
                    width: 600
                    height: 400
                    visible: false
                    title: qsTr("无边框窗口")
                    transientParent: null
                    captionBar.winTitle: ""
                    captionBar.winIconDelegate: Item { }
                }
            }
        }
    }
}

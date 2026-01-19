import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        DocDescription {
            desc: qsTr(`
# HusContextMenu 上下文菜单\n
上下文菜单，通常作为右键单击后显示的菜单。\n
* **模块 { HuskarUI.Basic }**\n
* **继承自 { [HusPopup](internal://HusPopup) }**\n
\n<br/>
\n### 支持的代理：\n
- 无\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
animationEnabled | bool | true | 是否开启动画
initModel | list | [] | 初始菜单模型
showToolTip | bool | false | 是否显示工具提示
defaultMenuIconSize | int | - | 默认菜单图标大小
defaultMenuIconSpacing | int | 8 | 默认菜单图标间隔
defaultMenuWidth | int | 140 | 默认菜单宽度
defaultMenuTopPadding | int | 5 | 默认菜单上边距
defaultMenuBottomPadding | int | 5 | 默认菜单下边距
defaultMenuSpacing | int | 4 | 默认菜单间隔
subMenuOffset | int | -4 | 子菜单偏移
radiusMenuBg | [HusRadius](internal://HusRadius) | - | 菜单项背景圆角
menu | [HusMenu](internal://HusMenu) | - | 访问内部菜单
\n<br/>
\n### 支持的信号：\n
- \`clickMenu(deep: int, key: string, keyPath: var, data: var)\` 点击任意菜单项时发出\n
  - \`deep\` 菜单项深度\n
  - \`key\` 菜单项的键\n
  - \`keyPath\` 菜单项的键路径数组\n
  - \`data\` 菜单项数据\n
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
需要弹窗式菜单时使用（例如右键菜单），非弹窗式菜单请使用：[HusMenu](internal://HusMenu)。
                       `)
        }

        ThemeToken {
            source: 'HusMenu'
            historySource: 'https://github.com/mengps/HuskarUI/blob/master/src/imports/HusContextMenu.qml'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
使用方法大致等同于 \`HusMenu\`，区别是 \`HusContextMenu\` 内建为弹窗。
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                MouseArea {
                    width: parent.width
                    height: parent.height
                    acceptedButtons: Qt.RightButton
                    onClicked:
                        (mouse) => {
                            if (mouse.button === Qt.RightButton) {
                                contextMenu.x = mouseX;
                                contextMenu.y = mouseY;
                                contextMenu.open();
                            }
                        }

                    HusContextMenu {
                        id: contextMenu
                        initModel: [
                            {
                                key: 'New',
                                label: 'New',
                                iconSource: HusIcon.FileOutlined,
                                menuChildren: [
                                    { key: 'NewFolder', label: 'Folder', },
                                    { key: 'NewImage', label: 'Image File', },
                                    { key: 'NewText', label: 'Text File', },
                                    {
                                        key: 'NewText',
                                        label: 'Other',
                                        menuChildren: [
                                            { key: 'Other1', label: 'Other1', },
                                            { key: 'Other2', label: 'Other2', },
                                        ]
                                    }
                                ]
                            },
                            { key: 'Open', label: 'Open', iconSource: HusIcon.FormOutlined, },
                            { key: 'Save', label: 'Save', iconSource: HusIcon.SaveOutlined },
                            { type: 'divider' },
                            { key: 'Exit', label: 'Exit', iconSource: HusIcon.IcoMoonExit },
                        ]
                        onClickMenu: (deep, key, keyPath, data) => copyableText.append('Click: ' + key);
                    }

                    HusCopyableText {
                        id: copyableText
                        anchors.fill: parent
                        clip: true
                        text: 'Please right-click with the mouse.'
                    }
                }
            `
            exampleDelegate: MouseArea {
                width: parent.width
                height: 200
                acceptedButtons: Qt.RightButton
                onClicked:
                    (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            contextMenu.x = mouseX;
                            contextMenu.y = mouseY;
                            contextMenu.open();
                        }
                    }

                HusContextMenu {
                    id: contextMenu
                    initModel: [
                        {
                            key: 'New',
                            label: 'New',
                            iconSource: HusIcon.FileOutlined,
                            menuChildren: [
                                { key: 'NewFolder', label: 'Folder', },
                                { key: 'NewImage', label: 'Image File', },
                                { key: 'NewText', label: 'Text File', },
                                {
                                    key: 'NewText',
                                    label: 'Other',
                                    menuChildren: [
                                        { key: 'Other1', label: 'Other1', },
                                        { key: 'Other2', label: 'Other2', },
                                    ]
                                }
                            ]
                        },
                        { key: 'Open', label: 'Open', iconSource: HusIcon.FormOutlined, },
                        { key: 'Save', label: 'Save', iconSource: HusIcon.SaveOutlined },
                        { type: 'divider' },
                        { key: 'Exit', label: 'Exit', iconSource: HusIcon.IcoMoonExit },
                    ]
                    onClickMenu: (deep, key, keyPath, data) => copyableText.append('Click: ' + key);
                }

                HusCopyableText {
                    id: copyableText
                    anchors.fill: parent
                    clip: true
                    text: 'Please right-click with the mouse.'
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
对于单选或多选菜单，只需简单自定义代理。
                       `)
            code: `
                import QtQuick
                import HuskarUI.Basic

                Item {
                    width: parent.width
                    height: parent.height

                    Component {
                        id: checkIconDelegate

                        HusIconText {
                            width: menuButton.iconSize
                            iconSize: menuButton.iconSize
                            iconSource: isDark ? (HusTheme.isDark ? HusIcon.CheckOutlined : 0) :
                                                 (HusTheme.isDark ? 0 : HusIcon.CheckOutlined)
                            property bool isDark: menuButton.model.key === 'Dark'
                        }
                    }

                    HusButton {
                        text: qsTr('Open menu')
                        onClicked: {
                            contextMenu2.x = width + 5;
                            contextMenu2.y = 0;
                            contextMenu2.open();
                        }

                        HusContextMenu {
                            id: contextMenu2
                            initModel: [
                                { key: 'Open', label: 'Open', iconSource: HusIcon.FormOutlined, },
                                { key: 'Save', label: 'Save', iconSource: HusIcon.SaveOutlined },
                                { type: 'divider' },
                                { key: 'Exit', label: 'Exit', iconSource: HusIcon.IcoMoonExit },
                                { type: 'divider' },
                                { key: 'Dark', label: 'Dark', iconDelegate: checkIconDelegate, },
                                { key: 'Light', label: 'Light', iconDelegate: checkIconDelegate, },
                            ]
                            onClickMenu:
                                (deep, key, keyPath, data) => {
                                    if (key === 'Dark') {
                                        galleryWindow.captionBar.themeCallback();
                                    } else if (key === 'Light') {
                                        galleryWindow.captionBar.themeCallback();
                                    }
                                }
                        }
                    }
                }
            `
            exampleDelegate: Item {
                height: 100

                Component {
                    id: checkIconDelegate

                    HusIconText {
                        width: menuButton.iconSize
                        iconSize: menuButton.iconSize
                        iconSource: isDark ? (HusTheme.isDark ? HusIcon.CheckOutlined : 0) :
                                             (HusTheme.isDark ? 0 : HusIcon.CheckOutlined)
                        property bool isDark: menuButton.model.key === 'Dark'
                    }
                }

                HusButton {
                    text: qsTr('Open menu')
                    onClicked: {
                        contextMenu2.x = width + 5;
                        contextMenu2.y = 0;
                        contextMenu2.open();
                    }

                    HusContextMenu {
                        id: contextMenu2
                        initModel: [
                            { key: 'Open', label: 'Open', iconSource: HusIcon.FormOutlined, },
                            { key: 'Save', label: 'Save', iconSource: HusIcon.SaveOutlined },
                            { type: 'divider' },
                            { key: 'Exit', label: 'Exit', iconSource: HusIcon.IcoMoonExit },
                            { type: 'divider' },
                            { key: 'Dark', label: 'Dark', iconDelegate: checkIconDelegate, },
                            { key: 'Light', label: 'Light', iconDelegate: checkIconDelegate, },
                        ]
                        onClickMenu:
                            (deep, key, keyPath, data) => {
                                if (key === 'Dark' && !HusTheme.isDark) {
                                    galleryWindow.captionBar.themeCallback();
                                } else if (key === 'Light' && HusTheme.isDark) {
                                    galleryWindow.captionBar.themeCallback();
                                }
                            }
                    }
                }
            }
        }
    }
}

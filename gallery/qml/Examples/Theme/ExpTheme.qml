import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    HusColorGenerator {
        id: husColorGenerator
    }

    Column {
        id: column
        width: parent.width
        spacing: 30

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`HusTheme.installThemePrimaryColorBase()\` 方法设置全局主题的主基础颜色，主基础颜色影响所有颜色的生成。
                       `)
            code: `
                HusTheme.installThemePrimaryColorBase('#ff0000');
            `
            exampleDelegate: Column {
                spacing: 10

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('更改主基础颜色')
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    Repeater {
                        id: repeater
                        model: [
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Red), colorName: 'red' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Volcano), colorName: 'volcano' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Orange), colorName: 'orange' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Gold), colorName: 'gold' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Yellow), colorName: 'yellow' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Lime), colorName: 'lime' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Green), colorName: 'green' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Cyan), colorName: 'cyan' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Blue), colorName: 'blue' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Geekblue), colorName: 'geekblue' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Purple), colorName: 'purple' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Magenta), colorName: 'magenta' },
                            { color: husColorGenerator.presetToColor(HusColorGenerator.Preset_Grey), colorName: 'grey' }
                        ]
                        delegate: Rectangle {
                            id: rootItem
                            width: 50
                            height: 50
                            color: hovered ? HusThemeFunctions.lighter(modelData.color, 110) : modelData.color
                            border.color: isCurrent || hovered ? HusTheme.Primary.colorPrimaryBorderHover :
                                                                 HusTheme.Primary.colorPrimaryBorder
                            radius: HusTheme.Primary.radiusPrimary

                            property bool hovered: false
                            property bool isCurrent: index == repeater.currentIndex

                            Behavior on color { ColorAnimation { } }
                            Behavior on border.color { ColorAnimation { } }

                            HusIconText {
                                anchors.centerIn: parent
                                iconSource: HusIcon.CheckOutlined
                                iconSize: 18
                                color: 'white'
                                visible: rootItem.isCurrent
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: rootItem.hovered = true;
                                onExited: rootItem.hovered = false;
                                onClicked: {
                                    galleryGlobal.themeIndex = repeater.currentIndex = index;
                                    HusTheme.installThemePrimaryColorBase(rootItem.color);
                                }
                            }
                        }
                        property int currentIndex: galleryGlobal.themeIndex
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`HusTheme.installThemePrimaryFontSizeBase()\` 方法设置全局主题的主基础字体大小，主基础字体大小影响所有字体大小的生成。
                       `)
            code: `
                HusTheme.installThemePrimaryFontSizeBase(32);
            `
            exampleDelegate: Column {
                spacing: 10

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('更改主基础字体大小')
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`HusTheme.installThemePrimaryFontFamiliesBase()\` 方法设置全局主题的主基础字体族字符串，该字符串可以是多个字体名，用逗号分隔，主题引擎将自动选择该列表中在本平台支持的字体。
                       `)
            code: `
                HusTheme.installThemePrimaryFontFamiliesBase(''Microsoft YaHei UI', BlinkMacSystemFont, 'Segoe UI', Roboto');
            `
            exampleDelegate: Column {
                spacing: 10

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('更改主基础字体族')
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`HusTheme.installThemePrimaryRadiusBase()\` 方法设置圆角半径基础大小。
                       `)
            code: `
                HusTheme.installThemePrimaryRadiusBase(6);
            `
            exampleDelegate: Column {
                spacing: 10

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('更改圆角半径基础大小')
                }
            }
        }


        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`HusTheme.installThemePrimaryAnimationBase()\` 方法设置动画基础速度。
                       `)
            code: `
                HusTheme.installThemePrimaryAnimationBase(100, 200, 300);
            `
            exampleDelegate: Column {
                spacing: 10

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('更改动画基础速度')
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`HusTheme.animationEnabled\` 属性开启/关闭全局动画，关闭动画资源占用更低。
                       `)
            code: `
                HusTheme.animationEnabled = true;
            `
            exampleDelegate: Column {
                spacing: 10

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('更改全局动画')
                }

                HusSwitch {
                    checked: HusTheme.animationEnabled
                    checkedText: qsTr('开启')
                    uncheckedText: qsTr('关闭')
                    onToggled: {
                        HusTheme.animationEnabled = checked;
                    }
                }
            }
        }
    }
}

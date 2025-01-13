import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import DelegateUI

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    DelColorGenerator {
        id: delColorGenerator
    }

    Column {
        id: column
        width: parent.width
        spacing: 30

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`DelTheme.installThemePrimaryColor()\` 方法设置全局主题的主要颜色，主要颜色影响所有颜色的生成。
                       `)
            code: `
                DelTheme.installThemePrimaryColor("#ff0000");
            `
            exampleDelegate: Column {
                spacing: 10

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("更改主要颜色")
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    Repeater {
                        id: repeater
                        model: [
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Red), colorName: "red" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Volcano), colorName: "volcano" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Orange), colorName: "orange" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Gold), colorName: "gold" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Yellow), colorName: "yellow" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Lime), colorName: "lime" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Green), colorName: "green" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Cyan), colorName: "cyan" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Blue), colorName: "blue" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Geekblue), colorName: "geekblue" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Purple), colorName: "purple" },
                            { color: delColorGenerator.presetToColor(DelColorGenerator.Preset_Grey), colorName: "grey" }
                        ]
                        delegate: Rectangle {
                            id: rootItem
                            width: 50
                            height: 50
                            color: modelData.color
                            radius: 5

                            DelIconText {
                                anchors.centerIn: parent
                                iconSource: DelIcon.CheckOutlined
                                iconSize: 18
                                color: "white"
                                visible: index == repeater.currentIndex
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    repeater.currentIndex = index;
                                    DelTheme.installThemePrimaryColor(rootItem.color);
                                }
                            }
                        }
                        property int currentIndex: 8
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`DelTheme.installThemePrimaryFontSize()\` 方法设置全局主题的主要字体大小，主要字体大小影响所有字体大小的生成。
                       `)
            code: `
                DelTheme.installThemePrimaryFontSize(32);
            `
            exampleDelegate: Column {
                spacing: 10

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("更改主要字体大小")
                }
            }
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`DelTheme.animationEnabled\` 属性开启/关闭全局动画，关闭动画资源占用更低。
                       `)
            code: `
                DelTheme.animationEnabled = true;
            `
            exampleDelegate: Column {
                spacing: 10

                DelDivider {
                    width: parent.width
                    height: 30
                    title: qsTr("更改全局动画")
                }

                DelSwitch {
                    checked: DelTheme.animationEnabled
                    checkedText: qsTr("开启")
                    uncheckedText: qsTr("关闭")
                    onToggled: {
                        DelTheme.animationEnabled = checked;
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import HuskarUI.Basic

import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: HusScrollBar { }

    HusMessage {
        id: message
        z: 999
        parent: galleryWindow.captionBar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        showCloseButton: true
    }

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

                RowLayout {
                    spacing: 50

                    Column {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: 50
                        spacing: 10

                        HusText {
                            padding: 10
                            text: qsTr('预设颜色: ')
                        }

                        Grid {
                            columns: 5
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
                                    scale: hovered ? 1.1 : 1
                                    color: hovered ? HusThemeFunctions.lighter(modelData.color, 110) : modelData.color
                                    border.color: isCurrent || hovered ? HusTheme.Primary.colorPrimaryBorderHover : 'white'
                                    radius: HusTheme.Primary.radiusPrimary

                                    property bool hovered: false
                                    property bool isCurrent: index == repeater.currentIndex

                                    Behavior on color { ColorAnimation { } }
                                    Behavior on border.color { ColorAnimation { } }
                                    Behavior on scale {
                                        NumberAnimation {
                                            easing.type: Easing.OutBack
                                            duration: HusTheme.Primary.durationSlow
                                        }
                                    }

                                    HusIconText {
                                        anchors.centerIn: parent
                                        iconSource: HusIcon.CheckOutlined
                                        iconSize: 18
                                        colorIcon: 'white'
                                        scale: visible ? 1 : 0
                                        visible: rootItem.isCurrent
                                        transformOrigin: Item.Bottom

                                        Behavior on scale {
                                            NumberAnimation {
                                                easing.type: Easing.OutBack
                                                duration: HusTheme.Primary.durationSlow
                                            }
                                        }

                                        Behavior on opacity {
                                            NumberAnimation {
                                                duration: HusTheme.Primary.durationMid
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
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

                        Row {
                            spacing: 10

                            HusText {
                                padding: 10
                                text: qsTr('自定义颜色: ')
                            }

                            HusColorPicker {
                                id: customColorPicker
                                defaultValue: HusTheme.Primary.colorPrimary
                                showText: true
                                autoChange: false
                                onChange: color => selectColor = color;
                                popup.closePolicy: HusPopup.NoAutoClose
                                property color selectColor: value
                                footerDelegate: Item {
                                    height: 45

                                    HusDivider {
                                        width: parent.width - 24
                                        height: 1
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Row {
                                        spacing: 20
                                        anchors.centerIn: parent

                                        HusButton {
                                            text: qsTr('Accept')
                                            onClicked: {
                                                customColorPicker.changeValue = customColorPicker.selectColor;
                                                customColorPicker.open = false;
                                                galleryGlobal.themeIndex = repeater.currentIndex = -1;
                                                HusTheme.installThemePrimaryColorBase(customColorPicker.selectColor);
                                            }
                                        }

                                        HusButton {
                                            text: qsTr('Cancel')
                                            onClicked: {
                                                customColorPicker.changeValue = customColorPicker.value;
                                                customColorPicker.defaultValue = customColorPicker.value;
                                                customColorPicker.open = false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    ListView {
                        id: colorsListView
                        Layout.preferredWidth: 350
                        Layout.preferredHeight: contentHeight
                        Layout.rightMargin: 30
                        Layout.alignment: Qt.AlignVCenter
                        interactive: false
                        model: 10
                        delegate: HusRectangleInternal {
                            width: hovered ? colorsListView.width : colorsListView.width - 30
                            height: 30
                            topRightRadius: hovered ? 4 : 0
                            bottomRightRadius: hovered ? 4 : 0
                            color: HusTheme.Primary[`colorPrimaryBase-${index + 1}`]

                            property bool hovered: false
                            property string colorString: String(color).toUpperCase()

                            Behavior on width { NumberAnimation { duration: HusTheme.Primary.durationMid } }
                            Behavior on topRightRadius { NumberAnimation { duration: HusTheme.Primary.durationMid } }
                            Behavior on bottomRightRadius { NumberAnimation { duration: HusTheme.Primary.durationMid } }

                            HusText {
                                anchors.centerIn: parent
                                color: parent.color.hslLightness > 0.5 ? 'black' : 'white'
                                text: parent.colorString
                                font.bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onEntered: parent.hovered = true;
                                onExited: parent.hovered = false;
                                onClicked: {
                                    HusApi.setClipbordText(parent.colorString);
                                    message.success(`${parent.colorString} copied 🎉`);
                                }
                            }
                        }
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
通过 \`HusTheme.installSizeHintRatio()\` 方法设置尺寸提示比率。\n
已有的尺寸将会覆盖，没有的将添加为新尺寸。\n
                       `)
            code: `
                HusTheme.installSizeHintRatio('normal', 2.0);
                HusTheme.installSizeHintRatio('veryLarge', 5.0);
            `
            exampleDelegate: Column {
                spacing: 10

                HusDivider {
                    width: parent.width
                    height: 30
                    title: qsTr('更改尺寸提示比率')
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

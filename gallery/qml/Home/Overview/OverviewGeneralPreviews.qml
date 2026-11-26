import QtQuick
import HuskarUI.Basic

QtObject {
    readonly property list<OverviewSample> samples: [
        OverviewSample {
            key: 'HusWindow'
            normalSize: Qt.size(336, 258)
            compactSize: Qt.size(300, 240)
            content: Item {
                Column {
                    anchors.fill: parent
                    spacing: 12

                    Row {
                        spacing: 8

                        HusButton {
                            text: previewLoader.visible ? '隐藏窗口' : '显示窗口'
                            type: HusButton.Type_Primary
                            onClicked: previewLoader.visible = !previewLoader.visible
                        }

                        HusButton {
                            text: '暗色'
                            type: HusButton.Type_Outlined
                            onClicked: {
                                if (previewLoader.status === Loader.Ready)
                                    previewLoader.item.setWindowMode(true);
                            }
                        }
                    }

                    HusText {
                        width: parent.width
                        wrapMode: Text.Wrap
                        color: HusTheme.Primary.colorTextSecondary
                        text: '使用官方推荐方式通过 Loader 动态创建 HusWindow，并提供独立窗口开关。'
                    }
                }

                Loader {
                    id: previewLoader
                    visible: false
                    sourceComponent: HusWindow {
                        width: 500
                        height: 320
                        visible: previewLoader.visible
                        title: 'HusWindow Preview'
                        captionBar.winIconWidth: 0
                        captionBar.winIconHeight: 0
                        captionBar.winIconDelegate: Item {}
                        captionBar.closeCallback: () => previewLoader.visible = false

                        Item {
                            anchors.fill: parent

                            HusCard {
                                anchors.centerIn: parent
                                width: 260
                                title: 'Window Content'
                                bodyTitle: 'Detached Preview'
                                bodyDescription: 'This preview runs in a real HusWindow.'
                            }
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusButton'
            content: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    HusButton {
                        text: 'primary'
                        type: HusButton.Type_Primary
                    }

                    HusButton {
                        text: 'link'
                        type: HusButton.Type_Link
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusIconButton'
            content: Item {
                HusIconButton {
                    anchors.centerIn: parent
                    type: HusButton.Type_Outlined
                    iconSource: HusIcon.SearchOutlined
                    text: 'Search'
                }
            }
        },

        OverviewSample {
            key: 'HusCaptionButton'
            content: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    HusCaptionButton {
                        iconSource: HusIcon.LineOutlined
                    }

                    HusCaptionButton {
                        iconSource: HusIcon.SwitcherTwotonePath3
                    }

                    HusCaptionButton {
                        isError: true
                        iconSource: HusIcon.CloseOutlined
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusIconText'
            content: Item {
                HusIconText {
                    anchors.centerIn: parent
                    iconSource: HusIcon.InfoCircleOutlined
                    text: 'Overview item'
                    iconSize: 18
                }
            }
        },

        OverviewSample {
            key: 'HusCopyableText'
            content: Item {
                HusCopyableText {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 220)
                    wrapMode: Text.Wrap
                    text: 'Click and copy HuskarUI gallery.'
                }
            }
        },

        OverviewSample {
            key: 'HusRectangle'
            content: Item {
                HusRectangle {
                    anchors.centerIn: parent
                    width: 150
                    height: 86
                    radius: 18
                    topRightRadius: 4
                    bottomLeftRadius: 30
                    color: HusTheme.Primary.colorInfoBg
                    border.color: HusTheme.Primary.colorInfo
                }
            }
        },

        OverviewSample {
            key: 'HusPopup'
            content: Item {
                HusButton {
                    anchors.centerIn: parent
                    text: 'Open Popup'
                    type: HusButton.Type_Primary
                    onClicked: popup.open()

                    HusPopup {
                        id: popup
                        x: (parent.width - width) * 0.5
                        y: parent.height + 8
                        width: 220
                        height: 110

                        HusFrame {
                            anchors.fill: parent
                            colorBg: HusTheme.Primary.colorBgBase

                            HusText {
                                anchors.centerIn: parent
                                text: 'HusPopup Content'
                            }
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusText'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 6

                    HusText {
                        text: '统一字体文本'
                        font.pixelSize: HusTheme.Primary.fontPrimarySizeHeading5
                    }

                    HusText {
                        text: 'Secondary description'
                        color: HusTheme.Primary.colorTextSecondary
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusButtonBlock'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    HusButtonBlock {
                        model: [
                            {
                                label: 'Apple'
                            },
                            {
                                label: 'Pear'
                            },
                            {
                                label: 'Orange'
                            }
                        ]
                    }

                    HusButtonBlock {
                        model: [
                            {
                                iconSource: HusIcon.PlusOutlined
                            },
                            {
                                iconSource: HusIcon.MinusOutlined
                            },
                            {
                                iconSource: HusIcon.CloseOutlined
                            }
                        ]
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusMoveMouseArea'
            content: Item {
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 24
                    height: parent.height - 24
                    color: 'transparent'
                    border.color: HusTheme.Primary.colorBorder
                    clip: true

                    Rectangle {
                        width: 70
                        height: 70
                        x: 16
                        y: 16
                        radius: 12
                        color: HusTheme.Primary.colorPrimary

                        HusMoveMouseArea {
                            anchors.fill: parent
                            target: parent
                            preventStealing: true
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusResizeMouseArea'
            content: Item {
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 24
                    height: parent.height - 24
                    color: 'transparent'
                    border.color: HusTheme.Primary.colorBorder
                    clip: true

                    Rectangle {
                        width: 86
                        height: 70
                        x: 16
                        y: 16
                        radius: 12
                        color: HusTheme.Primary.colorSuccess

                        HusResizeMouseArea {
                            anchors.fill: parent
                            target: parent
                            movable: true
                            preventStealing: true
                            minimumWidth: 60
                            minimumHeight: 50
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusCaptionBar'
            normalSize: Qt.size(288, 212)
            compactSize: Qt.size(248, 196)
            content: Item {
                HusCaptionBar {
                    width: parent.width
                    height: 42
                    anchors.top: parent.top
                    winTitle: 'Overview'
                    winIcon: Qt.resolvedUrl('../../../images/huskarui_new_square.svg')
                    showReturnButton: true
                    showThemeButton: true
                    showTopButton: true
                    showMinimizeButton: false
                    showMaximizeButton: false
                    showCloseButton: false
                }

                HusText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    color: HusTheme.Primary.colorTextSecondary
                    text: 'HusWindow 默认会内置 HusCaptionBar'
                }
            }
        },

        OverviewSample {
            key: 'HusRadius'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    HusButton {
                        text: 'Capsule Radius'
                        type: HusButton.Type_Primary
                        radiusBg: HusRadius {
                            all: height * 0.5
                        }
                    }

                    HusRectangle {
                        visible: false
                    }

                    HusButton {
                        text: 'Mixed Radius'
                        type: HusButton.Type_Outlined
                        radiusBg: HusRadius {
                            topLeft: 24
                            topRight: 6
                            bottomLeft: 6
                            bottomRight: 24
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusLabel'
            content: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    HusLabel {
                        text: 'Status'
                    }

                    HusLabel {
                        text: 'NEW'
                        colorBg: HusTheme.Primary.colorInfoBg
                        colorText: HusTheme.Primary.colorInfo
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusFrame'
            content: Item {
                HusFrame {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 16, 230)
                    height: 90
                    padding: 12
                    colorBg: HusTheme.Primary.colorBgBase

                    Column {
                        anchors.fill: parent
                        spacing: 8

                        HusText {
                            text: 'Nested HusFrame'
                        }

                        HusDivider {
                            width: parent.width
                        }

                        HusCheckBox {
                            text: 'Enable card'
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusPage'
            normalSize: Qt.size(388, 258)
            compactSize: Qt.size(328, 240)
            content: Item {
                HusPage {
                    anchors.fill: parent
                    header: HusText {
                        width: parent.width
                        padding: 8
                        horizontalAlignment: Text.AlignHCenter
                        text: 'Page Header'
                    }
                    contentItem: Item {
                        HusDivider {
                            width: parent.width
                        }

                        HusText {
                            anchors.centerIn: parent
                            text: 'Page Content'
                        }
                    }
                    footer: HusText {
                        width: parent.width
                        padding: 8
                        horizontalAlignment: Text.AlignHCenter
                        text: 'Page Footer'
                    }
                }
            }
        }
    ]
}

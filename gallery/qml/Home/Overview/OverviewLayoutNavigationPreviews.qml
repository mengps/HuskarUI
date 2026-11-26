import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

QtObject {
    readonly property list<OverviewSample> samples: [
        OverviewSample {
            key: 'HusDivider'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 220)
                    spacing: 12

                    HusText {
                        text: 'Before'
                    }

                    HusDivider {
                        width: parent.width
                    }

                    HusText {
                        text: 'After'
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusSpace'
            content: Item {
                HusSpace {
                    anchors.centerIn: parent
                    layout: 'RowLayout'
                    spacing: 10

                    HusButton {
                        text: 'Alpha'
                    }

                    HusButton {
                        text: 'Beta'
                        type: HusButton.Type_Primary
                    }

                    HusButton {
                        text: 'Gamma'
                        type: HusButton.Type_Outlined
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusGroupBox'
            content: Item {
                HusGroupBox {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 16, 240)
                    title: 'Deploy Options'

                    Column {
                        anchors.fill: parent
                        spacing: 8

                        HusCheckBox {
                            text: 'Build Release'
                        }
                        HusCheckBox {
                            text: 'Upload Symbols'
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusMenu'
            normalSize: Qt.size(388, 258)
            compactSize: Qt.size(328, 240)
            content: Item {
                HusMenu {
                    anchors.fill: parent
                    defaultMenuWidth: parent.width
                    initModel: [
                        {
                            label: 'Home',
                            iconSource: HusIcon.HomeOutlined
                        },
                        {
                            label: 'Workspace',
                            iconSource: HusIcon.AppstoreOutlined,
                            menuChildren: [
                                {
                                    label: 'Boards',
                                    iconSource: HusIcon.BarsOutlined
                                },
                                {
                                    label: 'Tasks',
                                    iconSource: HusIcon.UnorderedListOutlined
                                }
                            ]
                        },
                        {
                            label: 'Settings',
                            iconSource: HusIcon.SettingOutlined
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusScrollBar'
            content: Item {
                Flickable {
                    anchors.fill: parent
                    contentWidth: width
                    contentHeight: 520
                    clip: true
                    ScrollBar.vertical: HusScrollBar {}

                    Column {
                        width: parent.width - 12
                        spacing: 8

                        Repeater {
                            model: 16

                            HusFrame {
                                width: parent.width
                                height: 30

                                HusText {
                                    anchors.centerIn: parent
                                    text: 'Item ' + (index + 1)
                                }
                            }
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusPagination'
            content: Item {
                HusPagination {
                    anchors.centerIn: parent
                    currentPageIndex: 3
                    total: 240
                    pageSizeModel: [
                        {
                            label: '10 / page',
                            value: 10
                        },
                        {
                            label: '20 / page',
                            value: 20
                        },
                        {
                            label: '30 / page',
                            value: 30
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusContextMenu'
            normalSize: Qt.size(388, 258)
            compactSize: Qt.size(328, 240)
            content: Item {
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton
                    onClicked: function (mouse) {
                        if (mouse.button === Qt.RightButton) {
                            contextMenu.x = mouse.x;
                            contextMenu.y = mouse.y;
                            contextMenu.open();
                        }
                    }

                    HusCopyableText {
                        anchors.fill: parent
                        text: '在此区域右键打开 HusContextMenu'
                    }

                    HusContextMenu {
                        id: contextMenu
                        initModel: [
                            {
                                key: 'new',
                                label: 'New',
                                iconSource: HusIcon.FileOutlined
                            },
                            {
                                key: 'open',
                                label: 'Open',
                                iconSource: HusIcon.FormOutlined
                            },
                            {
                                type: 'divider'
                            },
                            {
                                key: 'exit',
                                label: 'Exit',
                                iconSource: HusIcon.CloseOutlined
                            }
                        ]
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusBreadcrumb'
            content: Item {
                HusBreadcrumb {
                    anchors.centerIn: parent
                    initModel: [
                        {
                            label: 'Home'
                        },
                        {
                            label: 'Gallery'
                        },
                        {
                            label: 'Overview'
                        }
                    ]
                }
            }
        }
    ]
}

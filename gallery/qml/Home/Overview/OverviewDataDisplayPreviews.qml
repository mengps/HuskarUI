import QtQuick
import QtQuick.Controls.Basic
import HuskarUI.Basic

QtObject {
    readonly property list<OverviewSample> samples: [
        OverviewSample {
            key: 'HusToolTip'
            content: Item {
                HusButton {
                    anchors.centerIn: parent
                    text: 'Hover me'
                    type: HusButton.Type_Outlined

                    HusToolTip {
                        visible: parent.hovered
                        position: HusToolTip.Position_Bottom
                        text: 'Tooltip Preview'
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusTourFocus'
            normalSize: Qt.size(288, 212)
            compactSize: Qt.size(248, 196)
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    HusButton {
                        text: 'Open Focus'
                        type: HusButton.Type_Primary
                        onClicked: focusPopup.open()
                    }

                    Row {
                        spacing: 8

                        HusButton {
                            id: focusTarget
                            text: 'Target'
                            type: HusButton.Type_Outlined
                        }

                        HusButton {
                            text: 'Close'
                            type: HusButton.Type_Outlined
                            onClicked: focusPopup.close()
                        }
                    }

                    HusSlider {
                        id: focusMarginSlider
                        width: 180
                        min: 0
                        max: 16
                        value: 6
                    }
                }

                HusTourFocus {
                    id: focusPopup
                    target: focusTarget
                    penetrationEvent: true
                    focusMargin: focusMarginSlider.currentValue
                    focusRadius: 8
                    closePolicy: Popup.CloseOnEscape
                }
            }
        },

        OverviewSample {
            key: 'HusTourStep'
            normalSize: Qt.size(336, 212)
            compactSize: Qt.size(300, 196)
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    HusButton {
                        text: 'Start Tour'
                        type: HusButton.Type_Primary
                        onClicked: {
                            tour.resetStep();
                            tour.open();
                        }

                        HusTourStep {
                            id: tour
                            stepModel: [
                                {
                                    target: stepOne,
                                    title: 'Step 1',
                                    description: 'Choose a source'
                                },
                                {
                                    target: stepTwo,
                                    title: 'Step 2',
                                    description: 'Confirm the action'
                                }
                            ]
                        }
                    }

                    Row {
                        spacing: 10

                        HusButton {
                            id: stepOne
                            text: 'Source'
                            type: HusButton.Type_Outlined
                        }

                        HusButton {
                            id: stepTwo
                            text: 'Confirm'
                            type: HusButton.Type_Outlined
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusTabView'
            normalSize: Qt.size(388, 188)
            compactSize: Qt.size(328, 174)
            content: Item {
                Component {
                    id: tabOneDelegate

                    HusText {
                        anchors.centerIn: parent
                        text: 'Tab Content 1'
                    }
                }

                Component {
                    id: tabTwoDelegate

                    HusText {
                        anchors.centerIn: parent
                        text: 'Tab Content 2'
                    }
                }

                Component {
                    id: tabThreeDelegate

                    HusText {
                        anchors.centerIn: parent
                        text: 'Tab Content 3'
                    }
                }

                HusTabView {
                    anchors.fill: parent
                    initModel: [
                        {
                            title: 'Tab 1',
                            contentDelegate: tabOneDelegate
                        },
                        {
                            title: 'Tab 2',
                            contentDelegate: tabTwoDelegate
                        },
                        {
                            title: 'Tab 3',
                            contentDelegate: tabThreeDelegate
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusCollapse'
            normalSize: Qt.size(388, 188)
            compactSize: Qt.size(328, 174)
            content: Item {
                Component {
                    id: collapseAlphaDelegate

                    HusText {
                        text: 'Alpha'
                        padding: 10
                    }
                }

                Component {
                    id: collapseBetaDelegate

                    HusText {
                        text: 'Beta'
                        padding: 10
                    }
                }

                HusCollapse {
                    anchors.fill: parent
                    initModel: [
                        {
                            title: 'Panel A',
                            contentDelegate: collapseAlphaDelegate
                        },
                        {
                            title: 'Panel B',
                            contentDelegate: collapseBetaDelegate
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusAvatar'
            content: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: 12

                    HusAvatar {
                        size: 44
                        textSource: 'HU'
                    }

                    HusAvatar {
                        size: 44
                        iconSource: HusIcon.UserOutlined
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusCard'
            content: Item {
                HusCard {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 12, 240)
                    title: 'Card title'
                    showShadow: true
                    extraDelegate: HusButton {
                        text: 'More'
                        type: HusButton.Type_Link
                    }
                    bodyDescription: 'Card content\\nCard content\\nCard content'
                }
            }
        },

        OverviewSample {
            key: 'HusTimeline'
            content: Item {
                HusTimeline {
                    anchors.fill: parent
                    initModel: [
                        {
                            title: 'Draft',
                            desc: 'Create overview sketch'
                        },
                        {
                            title: 'Build',
                            desc: 'Add live previews'
                        },
                        {
                            title: 'Preview',
                            desc: 'Verify result'
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusTag'
            content: Item {
                Flow {
                    anchors.centerIn: parent
                    width: Math.min(parent.width, 220)
                    spacing: 8

                    HusTag {
                        text: 'default'
                    }

                    HusTag {
                        text: 'success'
                        tagState: HusTag.State_Success
                    }

                    HusTag {
                        text: 'closable'
                        closeIconSource: HusIcon.CloseOutlined
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusTableView'
            normalSize: Qt.size(388, 236)
            compactSize: Qt.size(328, 220)
            content: Item {
                Component {
                    id: tableTextDelegate

                    HusText {
                        leftPadding: 8
                        rightPadding: 8
                        text: cellData
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Component {
                    id: actionDelegate

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        HusButton {
                            text: 'Edit'
                            type: HusButton.Type_Link
                        }

                        HusButton {
                            text: 'Delete'
                            type: HusButton.Type_Link
                        }
                    }
                }

                HusTableView {
                    anchors.fill: parent
                    alternatingRow: true
                    showColumnGrid: true
                    initModel: [
                        {
                            key: '1',
                            name: 'John Brown',
                            age: '32',
                            role: 'Developer'
                        },
                        {
                            key: '2',
                            name: 'Jim Green',
                            age: '42',
                            role: 'Designer'
                        },
                        {
                            key: '3',
                            name: 'Joe Black',
                            age: '29',
                            role: 'Teacher'
                        }
                    ]
                    columns: [
                        {
                            title: 'Name',
                            dataIndex: 'name',
                            delegate: tableTextDelegate,
                            width: 120
                        },
                        {
                            title: 'Age',
                            dataIndex: 'age',
                            delegate: tableTextDelegate,
                            width: 70,
                            align: 'center'
                        },
                        {
                            title: 'Role',
                            dataIndex: 'role',
                            delegate: tableTextDelegate,
                            width: 110
                        },
                        {
                            title: 'Action',
                            dataIndex: 'action',
                            delegate: actionDelegate,
                            width: 120
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusBadge'
            content: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: 18

                    HusAvatar {
                        size: 42
                        iconSource: HusIcon.UserOutlined

                        HusBadge {
                            count: 8
                        }
                    }

                    HusIconText {
                        iconSource: HusIcon.NotificationOutlined
                        iconSize: 22

                        HusBadge {
                            dot: true
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusCarousel'
            normalSize: Qt.size(388, 236)
            compactSize: Qt.size(328, 220)
            content: Item {
                HusCarousel {
                    anchors.fill: parent
                    autoplay: true
                    autoplaySpeed: 2400
                    initModel: [
                        {
                            coverSource: Qt.resolvedUrl('../../../images/switch_effect1.jpg')
                        },
                        {
                            coverSource: Qt.resolvedUrl('../../../images/switch_effect2.jpg')
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusImage'
            content: Item {
                HusImage {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 16, 220)
                    height: Math.min(parent.height - 16, 130)
                    source: Qt.resolvedUrl('../../../images/switch_effect1.jpg')
                }
            }
        },

        OverviewSample {
            key: 'HusAnimatedImage'
            content: Item {
                HusAnimatedImage {
                    anchors.centerIn: parent
                    width: 150
                    height: 110
                    source: 'https://media.giphy.com/media/ICOgUNjpvO0PC/giphy.gif'
                }
            }
        },

        OverviewSample {
            key: 'HusImagePreview'
            normalSize: Qt.size(388, 236)
            compactSize: Qt.size(328, 220)
            content: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    HusImage {
                        width: 110
                        height: 76
                        previewEnabled: false
                        source: Qt.resolvedUrl('../../../images/switch_effect1.jpg')

                        TapHandler {
                            onTapped: {
                                imagePreview.currentIndex = 0;
                                imagePreview.open();
                            }
                        }
                    }

                    HusImage {
                        width: 110
                        height: 76
                        previewEnabled: false
                        source: Qt.resolvedUrl('../../../images/switch_effect2.jpg')

                        TapHandler {
                            onTapped: {
                                imagePreview.currentIndex = 1;
                                imagePreview.open();
                            }
                        }
                    }
                }

                HusImagePreview {
                    id: imagePreview
                    items: [
                        {
                            url: Qt.resolvedUrl('../../../images/switch_effect1.jpg')
                        },
                        {
                            url: Qt.resolvedUrl('../../../images/switch_effect2.jpg')
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusEmpty'
            content: Item {
                HusEmpty {
                    anchors.centerIn: parent
                    description: 'No component data'
                }
            }
        },

        OverviewSample {
            key: 'HusQrCode'
            content: Item {
                HusQrCode {
                    anchors.centerIn: parent
                    width: 110
                    height: 110
                    text: 'https://github.com/mengps/HuskarUI'
                }
            }
        },

        OverviewSample {
            key: 'HusCheckerBoard'
            content: Item {
                HusCheckerBoard {
                    anchors.centerIn: parent
                    width: 180
                    height: 120
                }
            }
        },

        OverviewSample {
            key: 'HusTreeView'
            normalSize: Qt.size(388, 236)
            compactSize: Qt.size(328, 220)
            content: Item {
                HusTreeView {
                    anchors.fill: parent
                    checkable: true
                    Component.onCompleted: expandForKeys(['0'])
                    initModel: [
                        {
                            title: 'Project',
                            key: '0',
                            children: [
                                {
                                    title: 'gallery',
                                    key: '0-0'
                                },
                                {
                                    title: 'src',
                                    key: '0-1'
                                },
                                {
                                    title: 'docs',
                                    key: '0-2'
                                }
                            ]
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusSegmented'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    HusSegmented {
                        options: ['Daily', 'Weekly', 'Monthly']
                    }

                    HusSegmented {
                        options: [
                            {
                                label: 'List',
                                iconSource: HusIcon.BarsOutlined
                            },
                            {
                                label: 'Kanban',
                                iconSource: HusIcon.AppstoreOutlined
                            }
                        ]
                    }
                }
            }
        }
    ]
}

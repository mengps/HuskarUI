import QtQuick
import HuskarUI.Basic

QtObject {
    readonly property list<OverviewSample> samples: [
        OverviewSample {
            key: 'HusWatermark'
            normalSize: Qt.size(388, 258)
            compactSize: Qt.size(328, 240)
            content: Item {
                Column {
                    anchors.fill: parent
                    spacing: 10

                    HusSlider {
                        id: angleSlider
                        width: Math.min(parent.width - 20, 220)
                        min: 0
                        max: 360
                        value: 20
                    }

                    Rectangle {
                        width: parent.width
                        height: parent.height - angleSlider.height - 10
                        color: 'transparent'
                        border.color: HusTheme.Primary.colorBorder

                        HusWatermark {
                            anchors.fill: parent
                            anchors.margins: 1
                            text: 'HUSKARUI'
                            rotate: angleSlider.currentValue
                            offset.x: -40
                            offset.y: -40
                            colorText: '#55ff4d4f'
                            font.family: HusTheme.Primary.fontPrimaryFamily
                        }

                        HusText {
                            anchors.centerIn: parent
                            text: 'Watermark Preview'
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusDrawer'
            normalSize: Qt.size(336, 212)
            compactSize: Qt.size(300, 196)
            content: Item {
                Column {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 260)
                    spacing: 10

                    HusButton {
                        text: 'Open Drawer'
                        type: HusButton.Type_Primary
                        onClicked: drawer.open()

                        HusDrawer {
                            id: drawer
                            title: 'Basic Drawer'
                            edge: drawerEdgeRadio.currentCheckedValue ?? Qt.RightEdge
                            contentDelegate: HusCopyableText {
                                leftPadding: 15
                                text: 'Some contents...\nSome contents...\nSome contents...'
                            }
                        }
                    }

                    HusRadioBlock {
                        id: drawerEdgeRadio
                        initCheckedIndex: 3
                        model: [
                            {
                                label: 'Top',
                                value: Qt.TopEdge
                            },
                            {
                                label: 'Bottom',
                                value: Qt.BottomEdge
                            },
                            {
                                label: 'Left',
                                value: Qt.LeftEdge
                            },
                            {
                                label: 'Right',
                                value: Qt.RightEdge
                            }
                        ]
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusMessage'
            content: Item {
                HusMessage {
                    id: message
                    width: parent.width
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 10

                    HusButton {
                        text: 'Success'
                        type: HusButton.Type_Primary
                        onClicked: message.success('Success message')
                    }

                    HusButton {
                        text: 'Warning'
                        type: HusButton.Type_Outlined
                        onClicked: message.warning('Warning message')
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusProgress'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 220)
                    spacing: 10

                    HusProgress {
                        width: parent.width
                        percent: 68
                    }

                    HusProgress {
                        width: parent.width
                        type: HusProgress.Type_Circle
                        percent: 82
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusNotification'
            normalSize: Qt.size(336, 212)
            compactSize: Qt.size(300, 196)
            content: Item {
                HusNotification {
                    id: notification
                    anchors.fill: parent
                    position: HusNotification.Position_TopRight
                    showProgress: true
                    stackMode: true
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    HusText {
                        text: '统一点击触发'
                        color: HusTheme.Primary.colorTextSecondary
                    }

                    Row {
                        spacing: 10

                        HusButton {
                            text: 'Success'
                            type: HusButton.Type_Primary
                            onClicked: notification.success('Notification Title', 'This is a success notification!')
                        }

                        HusButton {
                            text: 'Info'
                            type: HusButton.Type_Outlined
                            onClicked: notification.info('Notification Title', 'This is an info notification!')
                        }

                        HusButton {
                            text: 'Warning'
                            type: HusButton.Type_Outlined
                            onClicked: notification.warning('Notification Title', 'This is a warning notification!')
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusPopconfirm'
            normalSize: Qt.size(288, 188)
            compactSize: Qt.size(248, 174)
            content: Item {
                HusMessage {
                    id: popMessage
                    width: parent.width
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 12

                    HusButton {
                        text: 'Add'
                        type: HusButton.Type_Primary
                        onClicked: addConfirm.open()

                        HusPopconfirm {
                            id: addConfirm
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 260
                            iconSource: HusIcon.QuestionCircleOutlined
                            title: 'Add the task'
                            description: 'Are you sure to add this task?'
                            confirmText: 'Yes'
                            cancelText: 'No'
                            onConfirm: {
                                popMessage.success('Added');
                                close();
                            }
                            onCancel: {
                                popMessage.warning('Canceled');
                                close();
                            }
                        }
                    }

                    HusButton {
                        text: 'Delete'
                        type: HusButton.Type_Outlined
                        onClicked: deleteConfirm.open()

                        HusPopconfirm {
                            id: deleteConfirm
                            x: (parent.width - width) * 0.5
                            y: parent.height + 6
                            width: 260
                            title: 'Delete the task'
                            description: 'Are you sure to delete this task?'
                            confirmText: 'Yes'
                            cancelText: 'No'
                            onConfirm: {
                                popMessage.error('Deleted');
                                close();
                            }
                            onCancel: {
                                popMessage.info('Kept');
                                close();
                            }
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusPopover'
            normalSize: Qt.size(288, 188)
            compactSize: Qt.size(248, 174)
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    HusText {
                        text: '统一点击触发'
                        color: HusTheme.Primary.colorTextSecondary
                    }

                    Row {
                        spacing: 12

                        HusButton {
                            text: 'Details'
                            type: HusButton.Type_Primary
                            onClicked: detailPopover.open()

                            HusPopover {
                                id: detailPopover
                                x: (parent.width - width) * 0.5
                                y: parent.height + 6
                                width: 260
                                title: 'Click details'
                                description: 'This is a HusPopover preview.'
                            }
                        }

                        HusButton {
                            text: 'Help'
                            type: HusButton.Type_Outlined
                            onClicked: helpPopover.open()

                            HusPopover {
                                id: helpPopover
                                x: (parent.width - width) * 0.5
                                y: parent.height + 6
                                width: 260
                                iconSource: HusIcon.InfoCircleOutlined
                                title: 'Help content'
                                description: 'Use the same click-trigger pattern across feedback components.'
                            }
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusModal'
            normalSize: Qt.size(336, 212)
            compactSize: Qt.size(300, 196)
            content: Item {
                HusButton {
                    anchors.centerIn: parent
                    text: 'Open Modal'
                    type: HusButton.Type_Primary
                    onClicked: modal.open()

                    HusModal {
                        id: modal
                        width: 320
                        title: 'Basic Modal'
                        description: 'Some contents...\\nSome contents...'
                        confirmText: 'Yes'
                        cancelText: 'No'
                        onConfirm: close()
                        onCancel: close()
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusSpin'
            content: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: 18

                    HusSpin {
                        sizeHint: 'small'
                    }
                    HusSpin {
                        sizeHint: 'normal'
                    }
                    HusSpin {
                        sizeHint: 'large'
                    }
                }
            }
        }
    ]
}

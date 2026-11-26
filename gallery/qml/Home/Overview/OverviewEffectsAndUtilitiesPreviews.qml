import QtQuick
import HuskarUI.Basic

QtObject {
    readonly property list<OverviewSample> samples: [
        OverviewSample {
            key: 'HusAcrylic'
            content: Item {
                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0.2, 0.45, 0.95, 0.08)

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                        source: Qt.resolvedUrl('../../../images/switch_effect1.jpg')
                    }

                    HusAcrylic {
                        anchors.centerIn: parent
                        width: 180
                        height: 100

                        HusText {
                            anchors.centerIn: parent
                            text: 'Acrylic'
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusLiquidGlass'
            content: Item {
                Rectangle {
                    anchors.fill: parent
                    color: HusTheme.Primary.colorInfoBg

                    HusLiquidGlass {
                        anchors.centerIn: parent
                        width: 190
                        height: 96

                        HusText {
                            anchors.centerIn: parent
                            text: 'Liquid Glass'
                        }

                        HusResizeMouseArea {
                            anchors.fill: parent
                            target: parent
                            movable: true
                            preventStealing: true
                            minimumWidth: 140
                            minimumHeight: 70
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusSwitchEffect'
            normalSize: Qt.size(388, 258)
            compactSize: Qt.size(328, 240)
            content: Item {
                Column {
                    anchors.fill: parent
                    spacing: 10

                    HusButton {
                        id: switchButton
                        text: 'Switch'
                        type: HusButton.Type_Primary
                        onClicked: {
                            showingFirst = !showingFirst;
                            if (showingFirst) {
                                switchEffect.startSwitch(card2, card1);
                            } else {
                                switchEffect.startSwitch(card1, card2);
                            }
                        }
                        property bool showingFirst: true
                    }

                    Item {
                        width: parent.width
                        height: parent.height - switchButton.height - 10

                        Image {
                            id: card1
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            source: Qt.resolvedUrl('../../../images/switch_effect1.jpg')
                            visible: true
                        }

                        Image {
                            id: card2
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            source: Qt.resolvedUrl('../../../images/switch_effect2.jpg')
                            visible: false
                        }

                        HusSwitchEffect {
                            id: switchEffect
                            anchors.fill: parent
                            type: HusSwitchEffect.Type_Opacity
                            duration: 900
                            onFinished: {
                                card1.visible = switchButton.showingFirst;
                                card2.visible = !switchButton.showingFirst;
                            }
                        }
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusShadow'
            content: Item {
                Item {
                    anchors.fill: parent

                    Rectangle {
                        id: shadowSource
                        width: 140
                        height: 80
                        radius: 18
                        anchors.centerIn: parent
                        color: HusTheme.Primary.colorPrimary
                    }

                    HusShadow {
                        anchors.fill: shadowSource
                        source: shadowSource
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusAsyncHasher'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 260)
                    spacing: 10

                    HusInput {
                        id: hashInput
                        width: parent.width
                        text: 'HuskarUI'
                    }

                    HusButton {
                        text: 'Create Hash'
                        type: HusButton.Type_Primary
                        onClicked: hasher.sourceText = hashInput.text
                    }

                    HusCopyableText {
                        width: parent.width
                        wrapMode: Text.WrapAnywhere
                        text: hasher.hashValue || '等待生成摘要'
                    }
                }

                HusAsyncHasher {
                    id: hasher
                    sourceText: 'HuskarUI'
                }
            }
        },

        OverviewSample {
            key: 'HusRouter'
            content: Item {
                QtObject {
                    id: routeState
                    property string currentText: '/'
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Row {
                        spacing: 8

                        HusButton {
                            text: '/overview'
                            type: HusButton.Type_Outlined
                            onClicked: router.push('/overview');
                        }

                        HusButton {
                            text: '/gallery'
                            type: HusButton.Type_Primary
                            onClicked: router.push('/gallery');
                        }
                    }

                    HusCopyableText {
                        text: routeState.currentText
                    }
                }

                HusRouter {
                    id: router
                    onCurrentUrlChanged: routeState.currentText = 'Current URL: ' + currentUrl
                }
            }
        }
    ]
}

import QtQuick
import HuskarUI.Basic

QtObject {
    readonly property list<OverviewSample> samples: [
        OverviewSample {
            key: 'HusSwitch'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 12

                    HusSwitch {
                        checkedText: 'ON'
                        uncheckedText: 'OFF'
                    }

                    HusSwitch {
                        checkedIconSource: HusIcon.CheckOutlined
                        uncheckedIconSource: HusIcon.CloseOutlined
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusSlider'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 24, 220)
                    spacing: 8

                    HusSlider {
                        id: slider
                        width: parent.width
                        min: 0
                        max: 100
                        value: 64
                        handleToolTipDelegate: HusToolTip {
                            visible: handleHovered || handlePressed
                            text: slider.currentValue.toFixed(0)
                        }
                    }

                    HusText {
                        text: 'Value: ' + slider.currentValue.toFixed(0)
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusSelect'
            content: Item {
                HusSelect {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 220)
                    placeholderText: 'Choose city'
                    model: [
                        {
                            label: 'Hangzhou',
                            value: 'hz'
                        },
                        {
                            label: 'Shanghai',
                            value: 'sh'
                        },
                        {
                            label: 'Shenzhen',
                            value: 'sz'
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusInput'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    HusInput {
                        width: Math.min(parent.width - 20, 220)
                        iconSource: HusIcon.UserOutlined
                        placeholderText: 'Username'
                    }

                    HusInput {
                        width: Math.min(parent.width - 20, 220)
                        clearEnabled: 'active'
                        placeholderText: 'Search'
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusOTPInput'
            content: Item {
                HusOTPInput {
                    anchors.centerIn: parent
                    length: 6
                }
            }
        },

        OverviewSample {
            key: 'HusRate'
            content: Item {
                HusRate {
                    anchors.centerIn: parent
                    count: 5
                    value: 3
                }
            }
        },

        OverviewSample {
            key: 'HusRadio'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    HusRadio {
                        text: 'Option A'
                        checked: true
                    }

                    HusRadio {
                        text: 'Option B'
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusRadioBlock'
            content: Item {
                HusRadioBlock {
                    anchors.centerIn: parent
                    initCheckedIndex: 1
                    model: [
                        {
                            label: 'Daily',
                            value: 'day'
                        },
                        {
                            label: 'Weekly',
                            value: 'week'
                        },
                        {
                            label: 'Monthly',
                            value: 'month'
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusCheckBox'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 8

                    HusCheckBox {
                        text: 'Mail'
                        checked: true
                    }

                    HusCheckBox {
                        text: 'Calendar'
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusAutoComplete'
            content: Item {
                HusAutoComplete {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 220)
                    placeholderText: 'Search'
                    iconSource: HusIcon.SearchOutlined
                    options: [
                        {
                            label: 'HusButton'
                        },
                        {
                            label: 'HusTableView'
                        },
                        {
                            label: 'HusMenu'
                        }
                    ]
                }
            }
        },

        OverviewSample {
            key: 'HusMultiSelect'
            content: Item {
                HusMultiSelect {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 240)
                    options: [
                        {
                            key: 'ui',
                            label: 'UI'
                        },
                        {
                            key: 'qml',
                            label: 'QML'
                        },
                        {
                            key: 'cpp',
                            label: 'C++'
                        }
                    ]
                    defaultSelectedKeys: ['ui', 'qml']
                }
            }
        },

        OverviewSample {
            key: 'HusTextArea'
            content: Item {
                HusTextArea {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 240)
                    height: 90
                    placeholderText: 'Write your note...'
                    text: 'HuskarUI overview sample'
                }
            }
        },

        OverviewSample {
            key: 'HusInputInteger'
            content: Item {
                HusInputInteger {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 220)
                    value: 42
                    min: 0
                    max: 100
                }
            }
        },

        OverviewSample {
            key: 'HusInputNumber'
            content: Item {
                HusInputNumber {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 220)
                    value: 3.14
                    precision: 2
                    step: 0.25
                }
            }
        },

        OverviewSample {
            key: 'HusColorPickerPanel'
            normalSize: Qt.size(288, 188)
            compactSize: Qt.size(248, 174)
            content: Item {
                HusColorPickerPanel {
                    anchors.centerIn: parent
                }
            }
        },

        OverviewSample {
            key: 'HusColorPicker'
            content: Item {
                Row {
                    anchors.centerIn: parent
                    spacing: 12

                    HusColorPicker {
                        id: picker
                        autoChange: false
                        changeValue: HusTheme.Primary.colorPrimary
                        onChange: function (color) {
                            changeValue = color;
                        }
                    }

                    HusRectangle {
                        width: 56
                        height: 56
                        radius: 14
                        color: picker.value
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusDateTimePicker'
            content: Item {
                HusDateTimePicker {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 220)
                }
            }
        },

        OverviewSample {
            key: 'HusDateTimePickerPanel'
            normalSize: Qt.size(288, 188)
            compactSize: Qt.size(248, 174)
            content: Item {
                HusDateTimePickerPanel {
                    anchors.centerIn: parent
                }
            }
        },

        OverviewSample {
            key: 'HusTransfer'
            normalSize: Qt.size(388, 258)
            compactSize: Qt.size(328, 240)
            content: Item {
                HusTransfer {
                    anchors.fill: parent
                    titles: ['Source', 'Target']
                    showSearch: true
                    dataSource: [
                        {
                            key: '1',
                            title: 'Content 1'
                        },
                        {
                            key: '2',
                            title: 'Content 2'
                        },
                        {
                            key: '3',
                            title: 'Content 3'
                        },
                        {
                            key: '4',
                            title: 'Content 4'
                        },
                        {
                            key: '5',
                            title: 'Content 5'
                        }
                    ]
                    targetKeys: ['2', '4']
                }
            }
        },

        OverviewSample {
            key: 'HusMultiCheckBox'
            content: Item {
                HusMultiCheckBox {
                    anchors.centerIn: parent
                    width: Math.min(parent.width - 20, 240)
                    options: [
                        {
                            key: 'apple',
                            label: 'Apple'
                        },
                        {
                            key: 'pear',
                            label: 'Pear'
                        },
                        {
                            key: 'orange',
                            label: 'Orange'
                        }
                    ]
                }
            }
        }
    ]
}

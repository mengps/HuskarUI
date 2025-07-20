import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: root

    width: parent.width
    height: column.height

    property string source: ''
    property var primaryTokens: []

    Component.onCompleted: {
        for (const key in HusTheme.Primary) {
            primaryTokens.push({ label: `@${key}` });
        }
    }

    Component {
        id: tagDelegate

        Item {
            HusTag {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: cellData
                presetColor: 'orange'
                font.pixelSize: HusTheme.Primary.fontPrimarySize

                HoverHandler {
                    id: hoverHandler
                }

                HusToolTip {
                    text: parent.text
                    visible: hoverHandler.hovered
                }
            }
        }
    }

    Component {
        id: editDelegate

        Item {
            Row {
                id: editRow
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 5

                property string key: cellData.key
                property string rawValue: cellData.value
                property string value: cellData.value

                HusIconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    iconSource: HusIcon.EditOutlined
                    topPadding: 2
                    bottomPadding: 2
                    leftPadding: 4
                    rightPadding: 4
                    onClicked: {
                        editInput.text = editRow.value;
                        editInput.filter();
                        editPopup.open();
                    }

                    HusPopup {
                        id: editPopup
                        padding: 5
                        contentItem: Row {
                            spacing: 5

                            HusAutoComplete {
                                id: editInput
                                width: 200
                                options: root.primaryTokens
                                tooltipVisible: true
                                filterOption: function(input, option){
                                    return option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1;
                                }
                            }

                            HusButton {
                                text: qsTr('确认')
                                onClicked: {
                                    editRow.value = editInput.text;
                                    HusTheme.installComponentToken(root.source, editRow.key, editInput.text);
                                    editPopup.close();
                                }
                            }

                            HusButton {
                                text: qsTr('取消')
                                onClicked: {
                                    editPopup.close();
                                }
                            }

                            HusButton {
                                text: qsTr('重置')
                                onClicked: {
                                    editRow.value = editRow.rawValue;
                                    HusTheme.installComponentToken(root.source, editRow.key, editRow.rawValue);
                                    editPopup.close();
                                }
                            }
                        }
                    }

                    HusToolTip {
                        visible: parent.hovered
                        text: qsTr('编辑Token')
                    }
                }

                HusTag {
                    anchors.verticalCenter: parent.verticalCenter
                    text: editRow.value
                    presetColor: 'green'
                    font.pixelSize: HusTheme.Primary.fontPrimarySize

                    HoverHandler {
                        id: hoverHandler
                    }

                    HusToolTip {
                        text: parent.text
                        visible: hoverHandler.hovered
                    }
                }
            }
        }
    }

    Component {
        id: colorTagDelegate

        Item {
            property var theCellData: HusTheme[root.source][cellData]

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Rectangle {
                    width: tag.height
                    height: tag.height
                    color: value.startsWith('#') ? value : 'transparent'
                    property string value: theCellData
                }

                HusTag {
                    id: tag
                    Layout.leftMargin: 15
                    Layout.alignment: Qt.AlignVCenter
                    text: theCellData
                    presetColor: 'blue'
                    font.pixelSize: HusTheme.Primary.fontPrimarySize
                }
            }
        }
    }

    Column {
        id: column
        width: parent.width - 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 15

        HusText {
            text: qsTr('主题变量（Design Token）')
            width: parent.width
            font {
                pixelSize: HusTheme.Primary.fontPrimarySizeHeading3
                weight: Font.DemiBold
            }
        }

        Loader {
            width: parent.width
            active: root.source != ''
            sourceComponent: HusTableView {
                propagateWheelEvent: true
                columnGridVisible: true
                columns: [
                    {
                        title: qsTr('Token 名称'),
                        dataIndex: 'tokenName',
                        key: 'tokenName',
                        delegate: tagDelegate,
                        width: 250
                    },
                    {
                        title: qsTr('Token 值'),
                        key: 'tokenValue',
                        dataIndex: 'tokenValue',
                        delegate: editDelegate,
                        width: 400
                    },
                    {
                        title: qsTr('Token 计算值'),
                        key: 'tokenCalcValue',
                        dataIndex: 'tokenCalcValue',
                        delegate: colorTagDelegate,
                        width: 250
                    }
                ]
                Component.onCompleted: {
                    if (root.source != '') {
                        const themeFile = `:/HuskarUI/theme/${root.source}.json`;
                        const object = JSON.parse(HusApi.readFileToString(themeFile));
                        let model = [];
                        for (const key in object) {
                            model.push({
                                           'tokenName': key,
                                           'tokenValue': { 'key': key, 'value': object[key] },
                                           'tokenCalcValue': key,
                                       });
                        }
                        height = defaultColumnHeaderHeight + model.length * minimumRowHeight;
                        initModel = model;
                    }
                }
            }
        }
    }
}

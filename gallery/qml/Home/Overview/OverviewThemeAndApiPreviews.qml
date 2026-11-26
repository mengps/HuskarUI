import QtQuick
import HuskarUI.Basic

QtObject {
    readonly property list<OverviewSample> samples: [
        OverviewSample {
            key: 'HusTheme'
            content: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    HusButton {
                        text: 'Toggle Dark Mode'
                        type: HusButton.Type_Primary
                        onClicked: HusTheme.darkMode = HusTheme.isDark ? HusTheme.Light : HusTheme.Dark
                    }

                    HusButton {
                        text: 'Toggle Animation'
                        type: HusButton.Type_Outlined
                        onClicked: HusTheme.animationEnabled = !HusTheme.animationEnabled
                    }

                    HusCopyableText {
                        text: 'isDark=' + HusTheme.isDark + ', animation=' + HusTheme.animationEnabled
                    }
                }
            }
        },

        OverviewSample {
            key: 'HusApi'
            content: Item {
                QtObject {
                    id: apiState
                    property string text: 'Click buttons to call HusApi'
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    Row {
                        spacing: 8

                        HusButton {
                            text: 'Clamp 148'
                            type: HusButton.Type_Primary
                            onClicked: apiState.text = 'clamp(148, 0, 100) = ' + HusApi.clamp(148, 0, 100)
                        }

                        HusButton {
                            text: 'Platform'
                            type: HusButton.Type_Outlined
                            onClicked: apiState.text = 'platform = ' + Qt.platform.os
                        }
                    }

                    HusCopyableText {
                        width: 240
                        wrapMode: Text.WrapAnywhere
                        text: apiState.text
                    }
                }
            }
        }
    ]
}

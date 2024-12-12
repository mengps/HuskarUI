import QtQuick
import QtQuick.Layouts
import DelegateUI

Item {

    DelColorGenerator {
        id: delColorGenerator
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
                border.color: Qt.darker(color)
                border.width: 2

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        DelTheme.installThemePrimaryColor(rootItem.color);
                    }
                }
            }
        }
    }
}

import QtQuick
import DelegateUI

Rectangle {
    id: control

    enum State {
        State_Default = 0,
        State_Success = 1,
        State_Processing = 2,
        State_Error = 3,
        State_Warning  = 4
    }

    signal close()

    property bool animationEnabled: DelTheme.animationEnabled
    property int tagState: DelTag.State_Default
    property string text: ""
    property font font
    property bool rotating: false
    property int iconSource: 0
    property int iconSize: DelTheme.DelButton.fontSize
    property int closeIconSource: 0
    property int closeIconSize: DelTheme.DelButton.fontSize
    property alias spacing: __row.spacing
    property string presetColor: ""
    property color colorText: presetColor == "" ? DelTheme.DelTag.colorDefaultText : __private.isCustom ? "#fff" : __private.colorArray[5]
    property color colorBg: presetColor == "" ? DelTheme.DelTag.colorDefaultBg : __private.isCustom ? presetColor : __private.colorArray[0]
    property color colorBorder: presetColor == "" ? DelTheme.DelTag.colorDefaultBorder : __private.isCustom ? "transparent" : __private.colorArray[2]
    property color colorIcon: colorText

    onTagStateChanged: {
        switch (tagState) {
        case DelTag.State_Success: presetColor = "#52c41a"; break;
        case DelTag.State_Processing: presetColor = "#1677ff"; break;
        case DelTag.State_Error: presetColor = "#ff4d4f"; break;
        case DelTag.State_Warning: presetColor = "#faad14"; break;
        case DelTag.State_Default:
        default: presetColor = "";
        }
    }

    onPresetColorChanged: {
        let preset = -1;
        switch (presetColor) {
        case "red": preset = DelColorGenerator.Preset_Red; break;
        case "volcano": preset = DelColorGenerator.Preset_Volcano; break;
        case "orange": preset = DelColorGenerator.Preset_Orange; break;
        case "gold": preset = DelColorGenerator.Preset_Gold; break;
        case "yellow": preset = DelColorGenerator.Preset_Yellow; break;
        case "lime": preset = DelColorGenerator.Preset_Lime; break;
        case "green": preset = DelColorGenerator.Preset_Green; break;
        case "cyan": preset = DelColorGenerator.Preset_Cyan; break;
        case "blue": preset = DelColorGenerator.Preset_Blue; break;
        case "geekblue": preset = DelColorGenerator.Preset_Geekblue; break;
        case "purple": preset = DelColorGenerator.Preset_Purple; break;
        case "magenta": preset = DelColorGenerator.Preset_Magenta; break;
        }

        if (tagState == DelTag.State_Default) {
            __private.isCustom = preset == -1 ? true : false;
            __private.presetColor = preset == -1 ? "#000" : delColorGenerator.presetToColor(preset);
        } else {
            __private.isCustom = false;
            __private.presetColor = presetColor;
        }
    }

    implicitWidth: __row.implicitWidth + 16
    implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight, __closeIcon.implicitHeight) + 8
    font.family: DelTheme.DelTag.fontFamily
    font.pixelSize: DelTheme.DelTag.fontSize - 2
    color: colorBg
    border.color: colorBorder
    radius: 4

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

    DelColorGenerator {
        id: delColorGenerator
    }

    QtObject {
        id: __private
        property bool isCustom: false
        property color presetColor: "#000"
        property var colorArray: DelThemeFunctions.genColor(presetColor, !DelTheme.isDark, DelTheme.Primary.colorBgBase)
    }

    Row {
        id: __row
        anchors.centerIn: parent
        spacing: 5

        DelIconText {
            id: __icon
            anchors.verticalCenter: parent.verticalCenter
            color: control.colorIcon
            iconSize: control.iconSize
            iconSource: control.iconSource
            verticalAlignment: Text.AlignVCenter
            visible: iconSource != 0

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

            NumberAnimation on rotation {
                id: __animation
                running: control.rotating
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }

        DelCopyableText {
            id: __text
            anchors.verticalCenter: parent.verticalCenter
            text: control.text
            font: control.font
            color: control.colorText

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
        }

        DelIconText {
            id: __closeIcon
            anchors.verticalCenter: parent.verticalCenter
            color: hovered ? DelTheme.DelTag.colorCloseIconHover : DelTheme.DelTag.colorCloseIcon
            iconSize: control.closeIconSize
            iconSource: control.closeIconSource
            verticalAlignment: Text.AlignVCenter
            visible: iconSource != 0

            property alias hovered: __hoverHander.hovered
            property alias down: __tapHander.pressed

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

            HoverHandler {
                id: __hoverHander
                cursorShape: Qt.PointingHandCursor
            }

            TapHandler {
                id: __tapHander
                onTapped: control.close();
            }
        }
    }
}

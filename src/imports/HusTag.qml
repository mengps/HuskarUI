import QtQuick
import HuskarUI.Basic

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

    property bool animationEnabled: HusTheme.animationEnabled
    property int tagState: HusTag.State_Default
    property string text: ''
    property font font: Qt.font({
                                    family: HusTheme.HusTag.fontFamily,
                                    pixelSize: parseInt(HusTheme.HusTag.fontSize) - 2
                                })
    property bool rotating: false
    property var iconSource: 0 ?? ''
    property int iconSize: parseInt(HusTheme.HusButton.fontSize)
    property var closeIconSource: 0 ?? ''
    property int closeIconSize: parseInt(HusTheme.HusButton.fontSize)
    property alias spacing: __row.spacing
    property string presetColor: ''
    property color colorText: presetColor == '' ? HusTheme.HusTag.colorDefaultText : __private.isCustom ? '#fff' : __private.colorArray[5]
    property color colorBg: presetColor == '' ? HusTheme.HusTag.colorDefaultBg : __private.isCustom ? presetColor : __private.colorArray[0]
    property color colorBorder: presetColor == '' ? HusTheme.HusTag.colorDefaultBorder : __private.isCustom ? 'transparent' : __private.colorArray[2]
    property color colorIcon: colorText

    objectName: '__HusTag__'
    implicitWidth: __row.implicitWidth + 16
    implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight, __closeIcon.implicitHeight) + 8
    color: colorBg
    border.color: colorBorder
    radius: HusTheme.HusTag.radiusBg
    onTagStateChanged: {
        switch (tagState) {
        case HusTag.State_Success: presetColor = '#52c41a'; break;
        case HusTag.State_Processing: presetColor = '#1677ff'; break;
        case HusTag.State_Error: presetColor = '#ff4d4f'; break;
        case HusTag.State_Warning: presetColor = '#faad14'; break;
        case HusTag.State_Default:
        default: presetColor = '';
        }
    }
    onPresetColorChanged: {
        let preset = -1;
        switch (presetColor) {
        case 'red': preset = HusColorGenerator.Preset_Red; break;
        case 'volcano': preset = HusColorGenerator.Preset_Volcano; break;
        case 'orange': preset = HusColorGenerator.Preset_Orange; break;
        case 'gold': preset = HusColorGenerator.Preset_Gold; break;
        case 'yellow': preset = HusColorGenerator.Preset_Yellow; break;
        case 'lime': preset = HusColorGenerator.Preset_Lime; break;
        case 'green': preset = HusColorGenerator.Preset_Green; break;
        case 'cyan': preset = HusColorGenerator.Preset_Cyan; break;
        case 'blue': preset = HusColorGenerator.Preset_Blue; break;
        case 'geekblue': preset = HusColorGenerator.Preset_Geekblue; break;
        case 'purple': preset = HusColorGenerator.Preset_Purple; break;
        case 'magenta': preset = HusColorGenerator.Preset_Magenta; break;
        }

        if (tagState == HusTag.State_Default) {
            __private.isCustom = preset == -1 ? true : false;
            __private.presetColor = preset == -1 ? '#000' : husColorGenerator.presetToColor(preset);
        } else {
            __private.isCustom = false;
            __private.presetColor = presetColor;
        }
    }

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    HusColorGenerator {
        id: husColorGenerator
    }

    QtObject {
        id: __private
        property bool isCustom: false
        property color presetColor: '#000'
        property var colorArray: HusThemeFunctions.genColor(presetColor, !HusTheme.isDark, HusTheme.Primary.colorBgBase)
    }

    Row {
        id: __row
        anchors.centerIn: parent
        spacing: 5

        HusIconText {
            id: __icon
            anchors.verticalCenter: parent.verticalCenter
            color: control.colorIcon
            iconSize: control.iconSize
            iconSource: control.iconSource
            verticalAlignment: Text.AlignVCenter
            visible: !empty

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

            NumberAnimation on rotation {
                id: __animation
                running: control.rotating
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1000
            }
        }

        HusCopyableText {
            id: __text
            anchors.verticalCenter: parent.verticalCenter
            text: control.text
            font: control.font
            color: control.colorText

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
        }

        HusIconText {
            id: __closeIcon
            anchors.verticalCenter: parent.verticalCenter
            color: hovered ? HusTheme.HusTag.colorCloseIconHover : HusTheme.HusTag.colorCloseIcon
            iconSize: control.closeIconSize
            iconSource: control.closeIconSource
            verticalAlignment: Text.AlignVCenter
            visible: !empty

            property alias hovered: __hoverHander.hovered
            property alias down: __tapHander.pressed

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

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

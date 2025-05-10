import QtQuick
import QtQuick.Layouts
import DelegateUI

Item {
    id: control

    enum State {
        State_Success = 1,
        State_Processing = 2,
        State_Error = 3,
        State_Warning  = 4,
        State_Default = 5
    }

    width: __badge.width
    height: __badge.height
    anchors.left: __parentIsLayout ? undefined : parent.right
    anchors.leftMargin: __parentIsLayout ? 0 : -width * 0.5
    anchors.bottom: __parentIsLayout ? undefined : parent.top
    anchors.bottomMargin: __parentIsLayout ? 0 : -height * 0.5

    font {
        family: DelTheme.Primary.fontFamilyBase
        pixelSize: iconSource == 0 ? 12 : 16
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property int badgeState: DelBadge.State_Error
    property string presetColor: ''
    property int count: 0
    property int iconSource: 0
    property bool dot: false
    property bool showZero: false
    property int overflowCount: 99
    property font font
    property color colorBg: presetColor == '' ? (iconSource !== 0 ? 'transparent' : DelTheme.Primary.colorError) :
                                                __private.isCustom ? presetColor : __private.colorArray[5]
    property alias colorBorder: __border.border.color
    property color colorText: 'white'

    property bool __parentIsLayout: parent instanceof Row || parent instanceof Column || parent instanceof Grid ||
                                    parent instanceof RowLayout || parent instanceof ColumnLayout || parent instanceof GridLayout

    onCountChanged: {
        const max = Math.min(count, overflowCount);
        if (max !== __private.lastCount) {
            if (max > __private.lastCount) {
                __numberList.model = [__private.lastCount, max];
                __upAnimation.restart();
            } else {
                __numberList.model = [max, __private.lastCount];
                __downAnimation.restart();
            }
            __private.lastCount = max;
        }
    }
    onBadgeStateChanged: {
        switch (badgeState) {
        case DelBadge.State_Success: presetColor = '#52c41a'; break;
        case DelBadge.State_Processing: presetColor = '#1677ff'; break;
        case DelBadge.State_Error: presetColor = '#ff4d4f'; break;
        case DelBadge.State_Warning: presetColor = '#faad14'; break;
        case DelBadge.State_Default: presetColor = '#888888'; break;
        default: presetColor = '';
        }
    }
    onPresetColorChanged: {
        let preset = -1;
        switch (presetColor) {
        case 'red': preset = DelColorGenerator.Preset_Red; break;
        case 'volcano': preset = DelColorGenerator.Preset_Volcano; break;
        case 'orange': preset = DelColorGenerator.Preset_Orange; break;
        case 'gold': preset = DelColorGenerator.Preset_Gold; break;
        case 'yellow': preset = DelColorGenerator.Preset_Yellow; break;
        case 'lime': preset = DelColorGenerator.Preset_Lime; break;
        case 'green': preset = DelColorGenerator.Preset_Green; break;
        case 'cyan': preset = DelColorGenerator.Preset_Cyan; break;
        case 'blue': preset = DelColorGenerator.Preset_Blue; break;
        case 'geekblue': preset = DelColorGenerator.Preset_Geekblue; break;
        case 'purple': preset = DelColorGenerator.Preset_Purple; break;
        case 'magenta': preset = DelColorGenerator.Preset_Magenta; break;
        }

        if (badgeState === DelBadge.State_Error) {
            __private.isCustom = preset == -1 ? true : false;
            __private.presetColor = preset == -1 ? '#000' : delColorGenerator.presetToColor(preset);
        } else {
            __private.isCustom = false;
            __private.presetColor = presetColor;
        }
    }

    DelColorGenerator { id: delColorGenerator }

    QtObject {
        id: __private
        property bool isCustom: false
        property color presetColor: '#000'
        property var colorArray: DelThemeFunctions.genColor(presetColor, !DelTheme.isDark, DelTheme.Primary.colorBgBase)
        property int lastCount: control.count
        property bool isNumber: control.iconSource == 0
    }

    Rectangle {
        id: __effect
        visible: control.badgeState === DelBadge.State_Processing
        x: __border.x + (__border.width - width) * 0.5
        y: __border.y + (__border.height - height) * 0.5
        radius: height * 0.5
        color: 'transparent'
        border.color: __badge.color

        ParallelAnimation {
            running: __effect.visible
            loops: Animation.Infinite

            NumberAnimation {
                target: __effect
                property: 'width'
                from: __border.width + 2
                to: __border.width + 8
                easing.type: Easing.OutQuart
                duration: 1000
            }

            NumberAnimation {
                target: __effect
                property: 'height'
                from: __border.height + 2
                to: __border.height + 8
                easing.type: Easing.OutQuart
                duration: 1000
            }

            NumberAnimation {
                target: __effect
                property: 'opacity'
                from: 0.4
                to: 0
                duration: 1000
            }
        }
    }

    Rectangle {
        id: __border
        visible: __badge.visible
        width: __badge.width + 2
        height: __badge.height + 2
        anchors.centerIn: __badge
        radius: height * 0.5
        color: 'transparent'
        border.width: 2
        border.color: control.iconSource !== 0 ? 'transparent' : 'white'
        scale: __badge.scale
    }

    Rectangle {
        id: __badge
        visible: scale !== 0
        width: control.dot ? 8 : Math.max(__content.width + 12, height)
        height: control.dot ? 8 : 20
        anchors.centerIn: parent
        radius: height * 0.5
        color: control.colorBg
        scale: (control.dot || control.count > 0 || control.showZero || control.iconSource != 0) ? 1 : 0

        Behavior on scale {
            enabled: control.animationEnabled
            NumberAnimation {
                duration: DelTheme.Primary.durationMid
                easing.type: Easing.InOutBack
            }
        }

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
        Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }
        Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }

        Item {
            visible: !control.dot
            anchors.fill: parent

            DelText {
                id: __content
                visible: (control.count > 0 || control.showZero || control.iconSource != 0) && !__upAnimation.running && !__downAnimation.running
                font: control.font
                text: control.iconSource === 0 ? (control.count > control.overflowCount ? `${control.overflowCount}+` : control.count) :
                                                 String.fromCharCode(control.iconSource)
                color: control.colorText
                anchors.centerIn: parent
            }

            ListView {
                id: __numberList
                visible: (control.count > 0 || control.showZero || control.iconSource != 0) && control.iconSource === 0 && !__content.visible
                anchors.fill: parent
                interactive: false
                clip: true
                delegate: Text {
                    width: __numberList.width
                    height: __numberList.height
                    text: modelData
                    color: control.colorText
                    font: control.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                NumberAnimation on contentY {
                    id: __upAnimation
                    from: 0
                    to: __numberList.height
                    duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
                    easing.type: Easing.InOutBack
                }

                NumberAnimation on contentY {
                    id: __downAnimation
                    from: __numberList.height
                    to: 0
                    duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
                    easing.type: Easing.InOutBack
                }
            }
        }
    }
}

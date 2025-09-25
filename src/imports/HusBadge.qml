import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: control

    enum State {
        State_Success = 1,
        State_Processing = 2,
        State_Error = 3,
        State_Warning  = 4,
        State_Default = 5
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property int badgeState: HusBadge.State_Error
    property string presetColor: ''
    property int count: 0
    property var iconSource: 0 ?? ''
    property bool dot: false
    property bool showZero: false
    property int overflowCount: 99
    property font font: Qt.font({
                                    family: __private.isNumber ? HusTheme.Primary.fontPrimaryFamily : 'HuskarUI-Icons',
                                    pixelSize: __private.isNumber ? 12 : 16
                                })
    property color colorBg: presetColor == '' ? (!__private.isNumber ? 'transparent' : HusTheme.Primary.colorError) :
                                                __private.isCustom ? presetColor : __private.colorArray[5]
    property alias colorBorder: __border.border.color
    property color colorText: 'white'

    property bool __parentIsLayout: parent instanceof Row || parent instanceof Column || parent instanceof Grid ||
                                    parent instanceof RowLayout || parent instanceof ColumnLayout || parent instanceof GridLayout ||
                                    parent instanceof Flow

    objectName: '__HusBadge__'
    width: __badge.width
    height: __badge.height
    anchors.left: __parentIsLayout ? undefined : parent.right
    anchors.leftMargin: __parentIsLayout ? 0 : -width * 0.5
    anchors.bottom: __parentIsLayout ? undefined : parent.top
    anchors.bottomMargin: __parentIsLayout ? 0 : -height * 0.5

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
        case HusBadge.State_Success: presetColor = '#52c41a'; break;
        case HusBadge.State_Processing: presetColor = '#1677ff'; break;
        case HusBadge.State_Error: presetColor = '#ff4d4f'; break;
        case HusBadge.State_Warning: presetColor = '#faad14'; break;
        case HusBadge.State_Default: presetColor = '#888888'; break;
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

        if (badgeState === HusBadge.State_Error) {
            __private.isCustom = preset == -1 ? true : false;
            __private.presetColor = preset == -1 ? '#000' : husColorGenerator.presetToColor(preset);
        } else {
            __private.isCustom = false;
            __private.presetColor = presetColor;
        }
    }

    HusColorGenerator { id: husColorGenerator }

    QtObject {
        id: __private
        property bool isCustom: false
        property color presetColor: '#000'
        property var colorArray: HusThemeFunctions.genColor(presetColor, !HusTheme.isDark, HusTheme.Primary.colorBgBase)
        property int lastCount: control.count
        property bool isNumber: control.iconSource === 0 || control.iconSource === ''
    }

    Rectangle {
        id: __effect
        visible: control.badgeState === HusBadge.State_Processing
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
        border.color: !__private.isNumber ? 'transparent' : 'white'
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
        scale: (control.dot || control.count > 0 || control.showZero || !__private.isNumber) ? 1 : 0

        Behavior on scale {
            enabled: control.animationEnabled
            NumberAnimation {
                duration: HusTheme.Primary.durationMid
                easing.type: Easing.InOutBack
            }
        }

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
        Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
        Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

        Item {
            visible: !control.dot
            anchors.fill: parent

            HusText {
                id: __content
                visible: (control.count > 0 || control.showZero || !__private.isNumber) && !__upAnimation.running && !__downAnimation.running
                font: control.font
                text: control.iconSource === 0 ? (control.count > control.overflowCount ? `${control.overflowCount}+` : control.count) :
                                                 String.fromCharCode(control.iconSource)
                color: control.colorText
                anchors.centerIn: parent
            }

            ListView {
                id: __numberList
                visible: (control.count > 0 || control.showZero || !__private.isNumber) && control.iconSource === 0 && !__content.visible
                anchors.fill: parent
                interactive: false
                clip: true
                delegate: HusText {
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
                    duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
                    easing.type: Easing.InOutBack
                }

                NumberAnimation on contentY {
                    id: __downAnimation
                    from: __numberList.height
                    to: 0
                    duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
                    easing.type: Easing.InOutBack
                }
            }
        }
    }
}

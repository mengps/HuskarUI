import QtQuick
import QtQuick.Effects
import QtQuick.Templates as T
import DelegateUI

T.Popup {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property bool movable: false
    property bool resizable: false
    property real minimumX: Number.NaN
    property real maximumX: Number.NaN
    property real minimumY: Number.NaN
    property real maximumY: Number.NaN
    property real minimumWidth: 0
    property real maximumWidth: Number.NaN
    property real minimumHeight: 0
    property real maximumHeight: Number.NaN
    property color colorShadow: DelTheme.DelPopup.colorShadow
    property color colorBg: DelTheme.isDark ? DelTheme.DelPopup.colorBgDark : DelTheme.DelPopup.colorBg
    property int radiusBg: DelTheme.DelPopup.radiusBg

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    enter: Transition {
        NumberAnimation {
            property: "opacity";
            from: 0.0
            to: 1.0
            duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0
            duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
        }
    }
    background: Item {
        MultiEffect {
            anchors.fill: __popupRect
            source: __popupRect
            shadowColor: control.colorShadow
            shadowEnabled: true
            shadowBlur: 1.0
            shadowOpacity: DelTheme.isDark ? 0.5 : 0.2
            shadowScale: 1.02
        }
        Rectangle {
            id: __popupRect
            anchors.fill: parent
            color: control.colorBg
            radius: control.radiusBg
        }
        Loader {
            active: control.movable || control.resizable
            sourceComponent: DelResizeMouseArea {
                anchors.fill: parent
                target: control
                movable: control.movable
                resizable: control.resizable
                minimumX: control.minimumX
                maximumX: control.maximumX
                minimumY: control.minimumY
                maximumY: control.maximumY
                minimumWidth: control.minimumWidth
                maximumWidth: control.maximumWidth
                minimumHeight: control.minimumHeight
                maximumHeight: control.maximumHeight
            }
        }
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
}

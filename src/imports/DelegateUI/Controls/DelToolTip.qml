import QtQuick
import QtQuick.Effects
import QtQuick.Templates as T
import DelegateUI

T.ToolTip {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property bool arrowVisible: true
    property int position: DelToolTipType.Top
    property color colorText: DelTheme.DelToolTip.colorText
    property color colorBg: DelTheme.isDark ? DelTheme.DelToolTip.colorBgDark : DelTheme.DelToolTip.colorBg

    component Arrow: Canvas {
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onColorBgChanged: requestPaint();
        onPaint: {
            const ctx = getContext("2d");
            ctx.fillStyle = colorBg;
            ctx.beginPath();
            switch (position) {
            case DelToolTipType.Top: {
                ctx.moveTo(0, 0);
                ctx.lineTo(width, 0);
                ctx.lineTo(width * 0.5, height);
            } break;
            case DelToolTipType.Bottom: {
                ctx.moveTo(0, height);
                ctx.lineTo(width, height);
                ctx.lineTo(width * 0.5, 0);
            } break;
            case DelToolTipType.Left: {
                ctx.moveTo(0, 0);
                ctx.lineTo(0, height);
                ctx.lineTo(width, height * 0.5);
            } break;
            case DelToolTipType.Right: {
                ctx.moveTo(width, 0);
                ctx.lineTo(width, height);
                ctx.lineTo(0, height * 0.5);
            } break;
            }
            ctx.closePath();
            ctx.fill();
        }
        property color colorBg: control.colorBg
    }

    x: {
        switch (position) {
        case DelToolTipType.Top:
        case DelToolTipType.Bottom:
            return (__private.controlParentWidth - implicitWidth) * 0.5;
        case DelToolTipType.Left:
            return -implicitWidth - 4;
        case DelToolTipType.Right:
            return __private.controlParentWidth + 4;
        }
    }
    y: {
        switch (position) {
        case DelToolTipType.Top:
            return -implicitHeight - 4;
        case DelToolTipType.Bottom:
            return __private.controlParentHeight + 4;
        case DelToolTipType.Left:
        case DelToolTipType.Right:
            return (__private.controlParentHeight - implicitHeight) * 0.5;
        }
    }

    enter: Transition {
        enabled: control.animationEnabled
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: DelTheme.Primary.durationMid }
    }
    exit: Transition {
        enabled: control.animationEnabled
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: DelTheme.Primary.durationMid }
    }

    delay: 300
    padding: 0
    implicitWidth: implicitContentWidth
    implicitHeight: implicitContentHeight
    font {
        family: DelTheme.DelToolTip.fontFamily
        pixelSize: DelTheme.DelToolTip.fontSize
    }
    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent
    contentItem: Item {
        implicitWidth: __bg.width + (__private.isHorizontal ? 0 : __arrow.width)
        implicitHeight: __bg.height + (__private.isHorizontal ? __arrow.height : 0)

        MultiEffect {
            anchors.fill: __item
            source: __item
            shadowColor: control.colorText
            shadowEnabled: true
            shadowBlur: DelTheme.isDark ? 0.8 : 0.4
            shadowOpacity: DelTheme.isDark ? 0.8 : 0.4
        }

        Item {
            id: __item
            anchors.fill: parent

            Arrow {
                id: __arrow
                x: __private.isHorizontal ? (-control.x + (__private.controlParentWidth - width) * 0.5) : 0
                y: __private.isHorizontal ? 0 : (-control.y + (__private.controlParentHeight - height)) * 0.5
                width: __private.arrowSize.width
                height: __private.arrowSize.height
                anchors.top: control.position == DelToolTipType.Bottom ? parent.top : undefined
                anchors.bottom: control.position == DelToolTipType.Top ? parent.bottom : undefined
                anchors.left: control.position == DelToolTipType.Right ? parent.left : undefined
                anchors.right: control.position == DelToolTipType.Left ? parent.right : undefined

                Connections {
                    target: control
                    function onPositionChanged() {
                        __arrow.requestPaint();
                    }
                }
            }

            Rectangle {
                id: __bg
                width: __text.implicitWidth + 14
                height: __text.implicitHeight + 12
                anchors.top: control.position == DelToolTipType.Top ? parent.top : undefined
                anchors.bottom: control.position == DelToolTipType.Bottom ? parent.bottom : undefined
                anchors.left: control.position == DelToolTipType.Left ? parent.left : undefined
                anchors.right: control.position == DelToolTipType.Right ? parent.right : undefined
                anchors.margins: 1
                radius: 4
                color: control.colorBg

                Text {
                    id: __text
                    text: control.text
                    font: control.font
                    color: control.colorText
                    wrapMode: Text.Wrap
                    anchors.centerIn: parent
                }
            }
        }
    }
    background: Item { }

    QtObject {
        id: __private
        property bool isHorizontal: control.position == DelToolTipType.Top || control.position == DelToolTipType.Bottom
        property size arrowSize: control.arrowVisible ? (isHorizontal ? Qt.size(12, 6) : Qt.size(6, 12)) : Qt.size(0, 0)
        property real controlParentWidth: control.parent ? control.parent.width : 0
        property real controlParentHeight: control.parent ? control.parent.height : 0
    }
}

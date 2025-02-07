import QtQuick
import QtQuick.Effects
import DelegateUI

Item {
    id: control

    implicitWidth: __mouseArea.width
    implicitHeight: __mouseArea.height
    toolTipFont {
        family: DelTheme.DelRate.fontFamily
        pixelSize: DelTheme.DelRate.fontSize
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property int count: 5
    property real initValue: -1
    property real value: 0
    property alias spacing: __row.spacing
    property int iconSize: 24
    /* 文字提示 */
    property font toolTipFont
    property bool toolTipVisible: false
    property list<string> toolTipTexts: []
    property color colorFill: DelTheme.DelRate.colorFill
    property color colorEmpty: DelTheme.DelRate.colorEmpty
    property color colorHalf: DelTheme.DelRate.colorHalf
    property color colorToolTipText: DelTheme.DelRate.colorToolTipText
    property color colorToolTipBg: DelTheme.isDark ? DelTheme.DelRate.colorToolTipBgDark : DelTheme.DelRate.colorToolTipBg
    /* 允许半星 */
    property bool allowHalf: false
    property bool isDone: false
    property int fillIcon: DelIcon.StarFilled
    property int emptyIcon: DelIcon.StarFilled
    property int halfIcon: DelIcon.StarFilled
    property Component fillDelegate: DelIconText {
        colorIcon: control.colorFill
        iconSource: control.fillIcon
        iconSize: control.iconSize
    }
    property Component emptyDelegate: DelIconText {
        colorIcon: control.colorEmpty
        iconSource: control.emptyIcon
        iconSize: control.iconSize
    }
    property Component halfDelegate: DelIconText {
        colorIcon: control.colorEmpty
        iconSource: control.emptyIcon
        iconSize: control.iconSize

        DelIconText {
            id: __source
            colorIcon: control.colorHalf
            iconSource: control.halfIcon
            iconSize: control.iconSize
            layer.enabled: true
            layer.effect: halfRateHelper
        }
    }
    property Component toolTipDelegate: Item {
        width: 12
        height: 6
        opacity: hovered ? 1 : 0

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }

        MultiEffect {
            anchors.fill: __item
            source: __item
            shadowEnabled: true
            shadowColor: control.colorToolTipBg
            shadowBlur: DelTheme.isDark ? 0.8 : 0.4
            shadowOpacity: DelTheme.isDark ? 0.8 : 0.4
        }

        Item {
            id: __item
            width: __toolTipBg.width
            height: __arrow.height + __toolTipBg.height - 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            Rectangle {
                id: __toolTipBg
                width: __toolTipText.implicitWidth + 14
                height: __toolTipText.implicitHeight + 12
                anchors.bottom: __arrow.top
                anchors.bottomMargin: -1
                anchors.horizontalCenter: parent.horizontalCenter
                color: control.colorToolTipBg
                radius: 4

                Text {
                    id: __toolTipText
                    color: control.colorToolTipText
                    text: control.toolTipTexts[index]
                    font: control.toolTipFont
                    anchors.centerIn: parent
                }
            }

            Canvas {
                id: __arrow
                width: 12
                height: 6
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onColorBgChanged: requestPaint();
                onPaint: {
                    const ctx = getContext("2d");
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width, 0);
                    ctx.lineTo(width * 0.5, height);
                    ctx.closePath();
                    ctx.fillStyle = colorBg;
                    ctx.fill();
                }
                property color colorBg: control.colorToolTipBg
            }
        }
    }

    property Component halfRateHelper: ShaderEffect {
        fragmentShader: "qrc:/DelegateUI/shaders/delrate.frag.qsb"
    }

    onInitValueChanged: {
        __private.doneValue = value = initValue;
        isDone = true;
    }

    /* 结束 */
    signal done(int value);

    QtObject {
        id: __private
        property real doneValue: 0
    }

    MouseArea {
        id: __mouseArea
        width: __row.width
        height: control.iconSize
        hoverEnabled: true
        enabled: control.enabled
        onExited: {
            if (control.isDone) {
                control.value = __private.doneValue;
            }
        }

        Row {
            id: __row
            spacing: 4

            Repeater {
                id: __repeater

                property int fillCount: Math.floor(control.value)
                property int emptyStartIndex: Math.round(control.value)
                property bool hasHalf: control.value - fillCount > 0

                model: control.count
                delegate: MouseArea {
                    id: __rootItem
                    width: control.iconSize
                    height: control.iconSize
                    hoverEnabled: true
                    enabled: control.enabled
                    onEntered: hovered = true;
                    onExited: hovered = false;
                    onClicked: {
                        control.isDone = !control.isDone;
                        if (control.isDone) {
                            __private.doneValue = control.value;
                            control.done(__private.doneValue);
                        }
                    }
                    onPositionChanged: function(mouse) {
                        if (control.allowHalf) {
                            if (mouse.x > (width * 0.5)) {
                                control.value = index + 1;
                            } else {
                                control.value = index + 0.5;
                            }

                        } else {
                            control.value = index + 1;
                        }
                    }
                    required property int index
                    property bool hovered: false

                    Loader {
                        active: index < __repeater.fillCount
                        sourceComponent: control.fillDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }

                    Loader {
                        active: __repeater.hasHalf && index === (__repeater.emptyStartIndex - 1)
                        sourceComponent: control.halfDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }

                    Loader {
                        active: index >= __repeater.emptyStartIndex
                        sourceComponent: control.emptyDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }

                    Loader {
                        x: (parent.width - width) * 0.5
                        y: -height - 4
                        z: 10
                        active: control.toolTipVisible
                        sourceComponent: control.toolTipDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }
                }
            }
        }
    }
}

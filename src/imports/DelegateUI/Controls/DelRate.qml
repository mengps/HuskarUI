import QtQuick
import DelegateUI

Item {
    id: control

    implicitWidth: __mouseArea.width
    implicitHeight: __mouseArea.height

    property int count: 5
    property real initValue: -1
    property real value: 0
    property alias spacing: __row.spacing
    property int iconSize: 24
    property color colorFill: DelTheme.DelRate.colorFill
    property color colorEmpty: DelTheme.DelRate.colorEmpty
    property color colorHalf: DelTheme.DelRate.colorHalf
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
            colorIcon: control.colorHalf
            iconSource: control.halfIcon
            iconSize: control.iconSize
            layer.enabled: true
            layer.effect: halfRateHelper
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
                        sourceComponent: fillDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }

                    Loader {
                        active: __repeater.hasHalf && index === (__repeater.emptyStartIndex - 1)
                        sourceComponent: halfDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }

                    Loader {
                        active: index >= __repeater.emptyStartIndex
                        sourceComponent: emptyDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }
                }

                property int fillCount: Math.floor(control.value)
                property int emptyStartIndex: Math.round(control.value)
                property bool hasHalf: control.value - fillCount > 0
            }
        }
    }
}

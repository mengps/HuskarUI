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
    property int hoverCursorShape: Qt.PointingHandCursor
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
    /* 是否支持半星动画 */
    property bool supportsHalfAnimation: allowHalf && ((fillIcon === DelIcon.StarFilled && emptyIcon === DelIcon.StarFilled) || halfIcon !== emptyIcon)
    property Component fillDelegate: DelIconText {
        colorIcon: control.colorFill
        iconSource: control.fillIcon
        iconSize: control.iconSize
        
        Behavior on opacity {
            enabled: control.animationEnabled
            NumberAnimation { duration: DelTheme.Primary.durationFast }
        }
    }
    property Component emptyDelegate: DelIconText {
        colorIcon: control.colorEmpty
        iconSource: control.emptyIcon
        iconSize: control.iconSize
        
        Behavior on opacity {
            enabled: control.animationEnabled
            NumberAnimation { duration: DelTheme.Primary.durationFast }
        }
    }
    property Component halfDelegate: DelIconText {
        colorIcon: control.colorEmpty
        iconSource: control.emptyIcon
        iconSize: control.iconSize
        
        Behavior on opacity {
            enabled: control.animationEnabled
            NumberAnimation { duration: DelTheme.Primary.durationFast }
        }

        DelIconText {
            id: __source
            colorIcon: control.colorHalf
            iconSource: control.halfIcon
            iconSize: control.iconSize
            layer.enabled: true
            layer.effect: halfRateHelper
            
            Behavior on opacity {
                enabled: control.animationEnabled
                NumberAnimation { duration: DelTheme.Primary.durationFast }
            }
            
            Behavior on width {
                enabled: control.animationEnabled
                NumberAnimation { duration: DelTheme.Primary.durationFast }
            }
        }
    }
    property Component toolTipDelegate: Item {
        width: 12
        height: 6
        opacity: hovered ? 1 : 0

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }

        MultiEffect {
            anchors.fill: __item
            source: __item
            shadowEnabled: true
            shadowColor: control.colorToolTipBg
            shadowBlur: 1.0
            shadowOpacity: DelTheme.isDark ? 0.5 : 0.2
            shadowScale: 1.02
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
                property bool hasHalf: control.allowHalf && control.value - fillCount > 0 && control.supportsHalfAnimation
                
                Behavior on fillCount {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: DelTheme.Primary.durationFast }
                }
                
                Behavior on emptyStartIndex {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: DelTheme.Primary.durationFast }
                }

                model: control.count
                delegate: MouseArea {
                    id: __rootItem
                    width: control.iconSize
                    height: control.iconSize
                    hoverEnabled: true
                    cursorShape: hovered ? control.hoverCursorShape : Qt.ArrowCursor
                    enabled: control.enabled
                    onEntered: {
                        hovered = true;
                        if (control.animationEnabled) {
                            __scaleAnim.start();
                        }
                    }
                    onExited: hovered = false;
                    onClicked: {
                        control.isDone = !control.isDone;
                        if (control.isDone) {
                            __private.doneValue = control.value;
                            control.done(__private.doneValue);
                        }
                    }
                    onPositionChanged: function(mouse) {
                        let newValue;
                        if (control.allowHalf) {
                            if (mouse.x > (width * 0.5)) {
                                newValue = index + 1;
                            } else {
                                newValue = index + 0.5;
                            }
                        } else {
                            newValue = index + 1;
                        }
                        
                        // 只有当评分值变化时才触发动画
                        if (newValue !== control.value) {
                            control.value = newValue;
                            if (control.animationEnabled && !__scaleAnim.running) {
                                __scaleAnim.start();
                            }
                        }
                    }
                    required property int index
                    property bool hovered: false

                    SequentialAnimation {
                        id: __scaleAnim
                        NumberAnimation {
                            target: __rootItemContainer
                            property: "scale"
                            from: 1.0
                            to: 1.15
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: __rootItemContainer
                            property: "scale"
                            from: 1.15
                            to: 1.0
                            duration: 100
                            easing.type: Easing.OutBounce
                        }
                    }

                    Item {
                        id: __rootItemContainer
                        width: parent.width
                        height: parent.height
                        
                        Loader {
                            id: fillLoader
                            anchors.fill: parent
                            active: true
                            opacity: index < __repeater.fillCount ? 1.0 : 0.0
                            sourceComponent: control.fillDelegate
                            property int index: __rootItem.index
                            property bool hovered: __rootItem.hovered
                            
                            Behavior on opacity {
                                enabled: control.animationEnabled
                                NumberAnimation { duration: DelTheme.Primary.durationFast }
                            }
                        }

                        Loader {
                            id: halfLoader
                            anchors.fill: parent
                            active: control.allowHalf && control.supportsHalfAnimation
                            opacity: __repeater.hasHalf && index === (__repeater.emptyStartIndex - 1) ? 1.0 : 0.0
                            sourceComponent: control.halfDelegate
                            property int index: __rootItem.index
                            property bool hovered: __rootItem.hovered
                            
                            Behavior on opacity {
                                enabled: control.animationEnabled && control.supportsHalfAnimation
                                NumberAnimation { duration: DelTheme.Primary.durationFast }
                            }
                        }

                        Loader {
                            id: emptyLoader
                            anchors.fill: parent
                            active: true
                            opacity: index >= __repeater.emptyStartIndex ? 1.0 : 0.0
                            sourceComponent: control.emptyDelegate
                            property int index: __rootItem.index
                            property bool hovered: __rootItem.hovered
                            
                            Behavior on opacity {
                                enabled: control.animationEnabled
                                NumberAnimation { duration: DelTheme.Primary.durationFast }
                            }
                        }
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

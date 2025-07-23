import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.CheckBox {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property int indicatorSize: 20
    property color colorText: enabled ? HusTheme.HusCheckBox.colorText : HusTheme.HusCheckBox.colorTextDisabled
    property color colorIndicator: {
        if (enabled) {
            return (checkState != Qt.Unchecked) ? hovered ? HusTheme.HusCheckBox.colorIndicatorCheckedHover :
                                                            HusTheme.HusCheckBox.colorIndicatorChecked : HusTheme.HusCheckBox.colorIndicator
        } else {
            return HusTheme.HusCheckBox.colorIndicatorDisabled;
        }
    }
    property color colorIndicatorBorder: enabled ?
                                             (hovered || checked) ? HusTheme.HusCheckBox.colorIndicatorBorderChecked :
                                                                    HusTheme.HusCheckBox.colorIndicatorBorder : HusTheme.HusCheckBox.colorIndicatorDisabled
    property string contentDescription: ''

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorIndicator { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorIndicatorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    objectName: '__HusCheckBox__'
    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight, implicitIndicatorHeight) + topPadding + bottomPadding
    font.family: HusTheme.HusCheckBox.fontFamily
    font.pixelSize: HusTheme.HusCheckBox.fontSize
    spacing: 6
    indicator: Item {
        x: control.leftPadding
        implicitWidth: __bg.implicitWidth
        implicitHeight: __bg.implicitHeight
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: __effect
            width: __bg.implicitWidth
            height: __bg.implicitHeight
            radius: HusTheme.Primary.radiusPrimaryXS
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: 'transparent'
            border.width: 0
            border.color: control.enabled ? HusTheme.HusCheckBox.colorEffectBg : 'transparent'
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: 'width'; from: __bg.implicitWidth + 2; to: __bg.implicitWidth + 6;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'height'; from: __bg.implicitHeight + 2; to: __bg.implicitHeight + 6;
                    duration: HusTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: 'opacity'; from: 0.2; to: 0;
                    duration: HusTheme.Primary.durationSlow
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled && control.effectEnabled) {
                        __effect.border.width = 6;
                        __animation.restart();
                    }
                }
            }
        }

        HusIconText {
            id: __bg
            iconSize: control.indicatorSize
            iconSource: HusIcon.BorderOutlined
            anchors.centerIn: parent
            colorIcon: control.colorIndicatorBorder

            /*! 勾选背景 */
            Rectangle {
                id: __checkedBg
                anchors.fill: parent
                anchors.margins: 2
                color: control.colorIndicator
                visible: opacity !== 0
                opacity: control.checkState == Qt.Checked ? 1.0 : 0.0

                Behavior on opacity {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: HusTheme.Primary.durationFast }
                }
            }

            /*! 勾选标记 */
            Item {
                id: __checkMarkContainer
                anchors.centerIn: parent
                width: parent.iconSize * 0.6
                height: parent.iconSize * 0.6
                visible: opacity !== 0
                scale: control.checkState == Qt.Checked ? 1.1 : 0.2
                opacity: control.checkState == Qt.Checked ? 1.0 : 0.0

                Behavior on scale {
                    enabled: control.animationEnabled
                    NumberAnimation { easing.overshoot: 2.5; easing.type: Easing.OutBack; duration: HusTheme.Primary.durationSlow }
                }

                Behavior on opacity {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: HusTheme.Primary.durationFast }
                }

                Canvas {
                    id: __checkMark
                    anchors.fill: parent
                    visible: control.checkState == Qt.Checked

                    property real animationProgress: control.animationEnabled ? 0 : 1
                    property real lineWidth: 2
                    property color checkColor: control.enabled ? '#fff' : HusTheme.HusCheckBox.colorIndicatorDisabled

                    onAnimationProgressChanged: requestPaint();

                    onPaint: {
                        let ctx = getContext('2d');
                        ctx.clearRect(0, 0, width, height);

                        ctx.lineWidth = lineWidth;
                        ctx.strokeStyle = checkColor;
                        ctx.fillStyle = 'transparent';
                        ctx.lineCap = 'round';
                        ctx.lineJoin = 'round';

                        const startX = width * 0.2;
                        const midPointX = width * 0.4;
                        const endX = width * 0.8;
                        const midPointY = height * 0.7;
                        const startY = height * 0.5;
                        const endY = height * 0.2;

                        ctx.beginPath();

                        if (animationProgress > 0) {
                            ctx.moveTo(startX, startY);
                            if (animationProgress < 0.5) {
                                const currentX = startX + (midPointX - startX) * (animationProgress * 2);
                                const currentY = startY + (midPointY - startY) * (animationProgress * 2);
                                ctx.lineTo(currentX, currentY);
                            } else {
                                const t = (animationProgress - 0.5) * 2;
                                const currentX = midPointX + (endX - midPointX) * t;
                                const currentY = midPointY + (endY - midPointY) * t;
                                ctx.lineTo(midPointX, midPointY);
                                ctx.lineTo(currentX, currentY);
                            }
                        }

                        ctx.stroke();
                    }

                    SequentialAnimation {
                        id: __checkMarkAnimation
                        running: control.checkState == Qt.Checked && control.animationEnabled

                        NumberAnimation {
                            target: __checkMark
                            property: 'animationProgress'
                            from: 0
                            to: 1
                            duration: HusTheme.Primary.durationSlow
                            easing.type: Easing.OutCubic
                        }

                        onStarted: {
                            __checkMark.visible = true;
                            __checkMark.requestPaint();
                        }

                        onRunningChanged: {
                            if (!running && control.checkState != Qt.Checked) {
                                __checkMark.animationProgress = 0;
                                __checkMark.visible = false;
                            }
                            __checkMark.requestPaint();
                        }
                    }
                }
            }

            /*! 部分选择状态 */
            HusIconText {
                id: __partialCheckMark
                anchors.centerIn: parent
                iconSource: HusIcon.XFilledPath1
                iconSize: parent.iconSize * 0.5
                colorIcon: control.colorIndicator
                visible: opacity !== 0
                opacity: control.checkState == Qt.PartiallyChecked ? 1.0 : 0.0

                Behavior on opacity {
                    enabled: control.animationEnabled
                    NumberAnimation { duration: HusTheme.Primary.durationFast }
                }
            }
        }
    }
    contentItem: HusText {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing

        Behavior on opacity {
            enabled: control.animationEnabled
            NumberAnimation { duration: HusTheme.Primary.durationMid }
        }
    }
    background: Item { }

    onCheckStateChanged: {
        if (control.checkState == Qt.Unchecked) {
            __checkMark.animationProgress = 0;
            __checkMark.visible = false;
            __checkMark.requestPaint();
        } else if (control.checkState == Qt.Checked && !control.animationEnabled) {
            /*! 不开启动画时立即显示完整勾选标记 */
            __checkMark.animationProgress = 1;
            __checkMark.visible = true;
            __checkMark.requestPaint();
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}

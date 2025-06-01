import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.CheckBox {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property int indicatorSize: 20
    property color colorText: enabled ? DelTheme.DelCheckBox.colorText : DelTheme.DelCheckBox.colorTextDisabled
    property color colorIndicator: enabled ?
                                       (checkState != Qt.Unchecked) ? DelTheme.DelCheckBox.colorIndicatorChecked :
                                                                      DelTheme.DelCheckBox.colorIndicator : DelTheme.DelCheckBox.colorIndicatorDisabled
    property color colorIndicatorBorder: enabled ?
                                             (hovered || checked) ? DelTheme.DelCheckBox.colorIndicatorBorderChecked :
                                                                    DelTheme.DelCheckBox.colorIndicatorBorder : DelTheme.DelCheckBox.colorIndicatorDisabled
    property string contentDescription: ""

    font {
        family: DelTheme.DelCheckBox.fontFamily
        pixelSize: DelTheme.DelCheckBox.fontSize
    }

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight, implicitIndicatorHeight) + topPadding + bottomPadding
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
            radius: 4
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: "transparent"
            border.width: 0
            border.color: control.enabled ? DelTheme.DelCheckBox.colorEffectBg : "transparent"
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: "width"; from: __bg.implicitWidth + 2; to: __bg.implicitWidth + 6;
                    duration: DelTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: "height"; from: __bg.implicitHeight + 2; to: __bg.implicitHeight + 6;
                    duration: DelTheme.Primary.durationFast
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: "opacity"; from: 0.2; to: 0;
                    duration: DelTheme.Primary.durationSlow
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

        DelIconText {
            id: __bg
            iconSize: control.indicatorSize
            iconSource: DelIcon.BorderOutlined
            anchors.centerIn: parent
            colorIcon: control.colorIndicatorBorder

            Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

            /*! 勾选背景 */
            Rectangle {
                id: __checkedBg
                anchors.fill: parent
                anchors.margins: 2
                radius: 2
                color: control.colorIndicator
                visible: control.checkState == Qt.Checked
                opacity: control.checkState == Qt.Checked ? 1.0 : 0.0
                
                Behavior on opacity { 
                    enabled: control.animationEnabled && control.checkState == Qt.Checked
                    NumberAnimation { duration: DelTheme.Primary.durationFast }
                }
            }

            /*! 勾选标记 */
            Item {
                id: __checkMarkContainer
                anchors.centerIn: parent
                width: parent.iconSize * 0.6
                height: parent.iconSize * 0.6
                visible: control.checkState == Qt.Checked
                scale: 1.1
                opacity: control.checkState == Qt.Checked ? 1.0 : 0.0
                
                Behavior on opacity { 
                    enabled: control.animationEnabled && control.checkState == Qt.Checked
                    NumberAnimation { duration: DelTheme.Primary.durationFast }
                }
                
                Canvas {
                    id: __checkMark
                    anchors.fill: parent
                    contextType: "2d"
                    visible: control.checkState == Qt.Checked
                    
                    property real animationProgress: control.animationEnabled ? 0 : 1
                    property real lineWidth: 2
                    property color checkColor: "#fff"
                    
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        
                        ctx.lineWidth = lineWidth;
                        ctx.strokeStyle = checkColor;
                        ctx.fillStyle = "transparent";
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";
                        
                        var startX = width * 0.2;
                        var midPointX = width * 0.4;
                        var endX = width * 0.8;
                        var midPointY = height * 0.7;
                        var startY = height * 0.5;
                        var endY = height * 0.2;
                        
                        ctx.beginPath();
                        
                        if (animationProgress > 0) {
                            ctx.moveTo(startX, startY);
                            if (animationProgress < 0.5) {
                                var currentX = startX + (midPointX - startX) * (animationProgress * 2);
                                var currentY = startY + (midPointY - startY) * (animationProgress * 2);
                                ctx.lineTo(currentX, currentY);
                            } else {
                                ctx.lineTo(midPointX, midPointY);
                                
                                var t = (animationProgress - 0.5) * 2;
                                var currentX = midPointX + (endX - midPointX) * t;
                                var currentY = midPointY + (endY - midPointY) * t;
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
                            property: "animationProgress"
                            from: 0
                            to: 1
                            duration: DelTheme.Primary.durationMid
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
                    
                    onAnimationProgressChanged: requestPaint()
                }
            }

            /*! 部分选择状态 */
            DelIconText {
                id: __partialCheckMark
                anchors.centerIn: parent
                iconSource: DelIcon.XFilledPath1
                iconSize: parent.iconSize * 0.5
                colorIcon: control.colorIndicator
                visible: control.checkState == Qt.PartiallyChecked
                opacity: control.checkState == Qt.PartiallyChecked ? 1.0 : 0.0
                
                Behavior on opacity { 
                    enabled: control.animationEnabled && control.checkState == Qt.PartiallyChecked
                    NumberAnimation { duration: DelTheme.Primary.durationFast }
                }
            }
        }
    }
    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
        
        Behavior on opacity { 
            enabled: control.animationEnabled
            NumberAnimation { duration: DelTheme.Primary.durationFast }
        }
    }
    background: Item { }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
    
    onCheckStateChanged: {
        if (control.checkState == Qt.Unchecked) {
            __checkMark.animationProgress = 0;
            __checkMark.visible = false;
            __checkMark.requestPaint();
        } else if (control.checkState == Qt.Checked && !control.animationEnabled) {
            // 不开启动画时立即显示完整勾选标记
            __checkMark.animationProgress = 1;
            __checkMark.visible = true;
            __checkMark.requestPaint();
        }
    }
}

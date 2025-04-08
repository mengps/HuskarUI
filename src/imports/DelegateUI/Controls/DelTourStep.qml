import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Popup {
    id: control

    x: __private.focusX - (stepCardWidth - focusWidth) * 0.5
    y: __private.focusY + focusHeight + 5

    stepTitleFont {
        bold: true
        family: DelTheme.DelTour.fontFamily
        pixelSize: DelTheme.DelTour.fontSizeTitle
    }
    stepDescriptionFont {
        family: DelTheme.DelTour.fontFamily
        pixelSize: DelTheme.DelTour.fontSizeDescription
    }
    indicatorFont {
        family: DelTheme.DelTour.fontFamily
        pixelSize: DelTheme.DelTour.fontSizeIndicator
    }
    buttonFont {
        family: DelTheme.DelTour.fontFamily
        pixelSize: DelTheme.DelTour.fontSizeButton
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property var stepModel: []
    property Item currentTarget: null
    property int currentStep: 0
    property color colorOverlay: DelTheme.DelTour.colorOverlay
    property bool showArrow: true
    property real arrowWidth: 20
    property real arrowHeight: 10
    property real focusMargin: 5
    property real focusWidth: currentTarget ? (currentTarget.width + focusMargin * 2) : 0
    property real focusHeight: currentTarget ? (currentTarget.height + focusMargin * 2) : 0
    property real stepCardWidth: 250
    property real radiusStepCard: DelTheme.DelTour.radiusCard
    property color colorStepCard: DelTheme.DelTour.colorBg
    property font stepTitleFont
    property color colorStepTitle: DelTheme.DelTour.colorText
    property font stepDescriptionFont
    property color colorStepDescription: DelTheme.DelTour.colorText
    property font indicatorFont
    property color colorIndicator: DelTheme.DelTour.colorText
    property font buttonFont
    property Component arrowDelegate: Canvas {
        id: __arrowDelegate
        width: arrowWidth
        height: arrowHeight
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onFillStyleChanged: requestPaint();
        onPaint: {
            const ctx = getContext("2d");
            ctx.fillStyle = fillStyle;
            ctx.beginPath();
            ctx.moveTo(0, height);
            ctx.lineTo(width * 0.5, 0);
            ctx.lineTo(width, height);
            ctx.closePath();
            ctx.fill();
        }
        property color fillStyle: control.colorStepCard

        Connections {
            target: control
            function onCurrentTargetChanged() {
                if (control.stepModel.length > control.currentStep) {
                    const stepData = control.stepModel[control.currentStep];
                    __arrowDelegate.fillStyle = Qt.binding(() => stepData.cardColor ? stepData.cardColor : control.colorStepCard);
                }
                __arrowDelegate.requestPaint();
            }
        }
    }
    property Component stepCardDelegate: Rectangle {
        id: __stepCardDelegate
        width: stepData.cardWidth ? stepData.cardWidth : control.stepCardWidth
        height: stepData.cardHeight ? stepData.cardHeight : (__stepCardColumn.height + 20)
        color: stepData.cardColor ? stepData.cardColor : control.colorStepCard
        radius: stepData.cardRadius ? stepData.cardRadius : control.radiusStepCard
        clip: true

        property var stepData: new Object

        Connections {
            target: control
            function onCurrentTargetChanged() {
                if (control.stepModel.length > control.currentStep)
                    stepData = control.stepModel[control.currentStep];
            }
        }

        Column {
            id: __stepCardColumn
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: stepData.title ? stepData.title : ""
                color: stepData.titleColor ? stepData.titleColor : control.colorStepTitle
                font: control.stepTitleFont
            }

            Text {
                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAnywhere
                text: stepData.description || ""
                visible: text.length !== 0
                color: stepData.descriptionColor ? stepData.descriptionColor : control.colorStepDescription
                font: control.stepDescriptionFont
            }

            Item {
                width: parent.width
                height: 30

                Loader {
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: control.indicatorDelegate
                }

                DelButton {
                    id: __prevButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: __nextButton.left
                    anchors.rightMargin: 15
                    anchors.bottom: __nextButton.bottom
                    visible: control.currentStep != 0
                    text: qsTr("上一步")
                    font: control.buttonFont
                    type: DelButton.Type_Outlined
                    onClicked: {
                        if (control.currentStep > 0) {
                            control.currentStep -= 1;
                            __stepCardDelegate.stepData = control.stepModel[control.currentStep];
                            control.currentTarget = __stepCardDelegate.stepData.target;
                        }
                    }
                }

                DelButton {
                    id: __nextButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.bottom: parent.bottom
                    text: (control.currentStep + 1 == control.stepModel.length) ? qsTr("结束导览") : qsTr("下一步")
                    font: control.buttonFont
                    type: DelButton.Type_Primary
                    onClicked: {
                        if ((control.currentStep + 1 == control.stepModel.length)) {
                            control.resetStep();
                            control.close();
                        } else if (control.currentStep + 1 < control.stepModel.length) {
                            control.currentStep += 1;
                            __stepCardDelegate.stepData = control.stepModel[control.currentStep];
                            control.currentTarget = __stepCardDelegate.stepData.target;
                        }
                    }
                }
            }
        }

        DelCaptionButton {
            radiusBg: 4
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.topMargin: 2
            iconSource: DelIcon.CloseOutlined
            onClicked: {
                control.resetStep();
                control.close();
            }
        }
    }
    property Component indicatorDelegate: Text {
        text: (control.currentStep + 1) + " / " + control.stepModel.length
        font: control.indicatorFont
        color: control.colorIndicator
    }

    function resetStep() {
        control.currentStep = 0;
        if (control.stepModel.length > control.currentStep) {
            const stepData = control.stepModel[control.currentStep];
            currentTarget = stepData.target;
        }
    }

    function appendStep(object) {
        stepModel.push(object);
    }

    onStepModelChanged: __private.recalcPosition();
    onCurrentTargetChanged: __private.recalcPosition();
    onAboutToShow: __private.recalcPosition();

    Behavior on x { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }
    Behavior on y { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }

    QtObject {
        id: __private
        property bool first: true
        property real focusX: 0
        property real focusY: 0
        function recalcPosition() {
            /*! 需要延时计算 */
            __privateTimer.restart();
        }
    }

    Timer {
        id: __privateTimer
        interval: 40
        onTriggered: {
            if (!control.currentTarget) return;
            const pos = control.currentTarget.mapToItem(null, 0, 0);
            __private.focusX = pos.x - control.focusMargin;
            __private.focusY = pos.y - control.focusMargin;
        }
    }

    T.Overlay.modal: Item {
        id: __overlayItem
        onWidthChanged: __private.recalcPosition();
        onHeightChanged: __private.recalcPosition();

        Rectangle {
            id: source
            color: colorOverlay
            anchors.fill: parent
            layer.enabled: true
            layer.effect: ShaderEffect {
                property real xMin: __private.focusX / __overlayItem.width
                property real xMax: (__private.focusX + focusWidth) / __overlayItem.width
                property real yMin: __private.focusY / __overlayItem.height
                property real yMax: (__private.focusY + focusHeight) / __overlayItem.height

                Behavior on xMin { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }
                Behavior on xMax { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }
                Behavior on yMin { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }
                Behavior on yMax { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }

                fragmentShader: "qrc:/DelegateUI/shaders/deltour.frag.qsb"
            }
        }
    }
    closePolicy: T.Popup.CloseOnEscape
    parent: T.Overlay.overlay
    focus: true
    modal: true
    background: Item {
        width: stepLoader.item == null ? control.arrowWidth : Math.max(control.arrowWidth, stepLoader.item.width)
        height: stepLoader.item == null ? control.arrowHeight : (control.arrowHeight + stepLoader.item.height - 1)

        Loader {
            id: arrowLoader
            width: control.arrowWidth
            height: control.arrowHeight
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: control.arrowDelegate
        }

        Loader {
            id: stepLoader
            anchors.top: arrowLoader.bottom
            anchors.topMargin: -1
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: control.stepCardDelegate
        }
    }
}

import QtQuick
import QtQuick.Templates as T
import DelegateUI

T.Popup {
    id: control

    x: __private.focusX - (stepCardWidth - focusWidth) * 0.5
    y: __private.focusY + focusHeight + 5

    stepTitleFont {
        bold: true
        family: DelTheme.DelTourStep.fontFamily
        pixelSize: DelTheme.DelTourStep.fontSizeTitle
    }
    stepDescriptionFont {
        family: DelTheme.DelTourStep.fontFamily
        pixelSize: DelTheme.DelTourStep.fontSizeDescription
    }
    indicatorFont{
        family: DelTheme.DelTourStep.fontFamily
        pixelSize: DelTheme.DelTourStep.fontSizeIndicator
    }
    buttonFont {
        family: DelTheme.DelTourStep.fontFamily
        pixelSize: DelTheme.DelTourStep.fontSizeButton
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property var stepModel: []
    property Item currentTarget: null
    property int currentStep: 0
    property color overlayColor: DelTheme.DelTourStep.colorOverlay
    property bool showArrow: true
    property real arrowWidth: 20
    property real arrowHeight: 10
    property real focusMargin: 5
    property real focusWidth: currentTarget ? (currentTarget.width + focusMargin * 2) : 0
    property real focusHeight: currentTarget ? (currentTarget.height + focusMargin * 2) : 0
    property real stepCardWidth: 250
    property real stepCardRadius: DelTheme.DelTourStep.radiusCard
    property color stepCardColor: DelTheme.DelTourStep.colorBg
    property font stepTitleFont
    property color stepTitleColor: DelTheme.DelTourStep.colorText
    property font stepDescriptionFont
    property color stepDescriptionColor: DelTheme.DelTourStep.colorText
    property font indicatorFont
    property color indicatorColor: DelTheme.DelTourStep.colorText
    property font buttonFont
    property Component arrowDelegate:  Canvas {
        id: __arrowDelegate
        width: arrowWidth
        height: arrowHeight
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
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
        property color fillStyle: control.stepCardColor

        Connections {
            target: control
            function onCurrentTargetChanged() {
                if (control.stepModel.length > control.currentStep) {
                    const stepData = control.stepModel[control.currentStep];
                    __arrowDelegate.fillStyle = stepData.cardColor ? stepData.cardColor : control.stepCardColor;
                }
                __arrowDelegate.requestPaint();
            }
        }
    }
    property Component stepCardDelegate: Rectangle {
        id: __stepCardDelegate
        width: stepData.cardWidth ? stepData.cardWidth : control.stepCardWidth
        height: stepData.cardHeight ? stepData.cardHeight : (__stepCardColumn.height + 20)
        color: stepData.cardColor ? stepData.cardColor : control.stepCardColor
        radius: stepData.cardRadius ? stepData.cardRadius : control.stepCardRadius

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
                color: stepData.titleColor ? stepData.titleColor : control.stepTitleColor
                font: control.stepTitleFont
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: stepData.description || ""
                color: stepData.descriptionColor ? stepData.descriptionColor : control.stepDescriptionColor
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
                    text: qsTr("上一步")
                    anchors.right: __nextButton.left
                    anchors.rightMargin: 15
                    anchors.bottom: __nextButton.bottom
                    visible: control.currentStep != 0
                    font: control.buttonFont
                    type: DelButton.Type_Primary
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
                    text: (control.currentStep + 1 == control.stepModel.length) ? qsTr("结束导览") : qsTr("下一步")
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.bottom: parent.bottom
                    font: control.buttonFont
                    type: DelButton.Type_Primary
                    onClicked: {
                        if ((control.currentStep + 1 == control.stepModel.length))
                            control.close();
                        else if (control.currentStep + 1 < control.stepModel.length) {
                            control.currentStep += 1;
                            __stepCardDelegate.stepData = control.stepModel[control.currentStep];
                            control.currentTarget = __stepCardDelegate.stepData.target;
                        }
                    }
                }
            }
        }
    }
    property Component indicatorDelegate: Text {
        text: (control.currentStep + 1) + " / " + control.stepModel.length
        font: control.indicatorFont
        color: control.indicatorColor
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
            color: overlayColor
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
    background: Column {
        width: stepLoader.item == null ? control.arrowWidth : Math.max(control.arrowWidth, stepLoader.item.width)
        spacing: -1

        Loader {
            id: arrowLoader
            width: control.arrowWidth
            height: control.arrowHeight
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: control.arrowDelegate
        }

        Loader {
            id: stepLoader
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: control.stepCardDelegate
        }
    }
}

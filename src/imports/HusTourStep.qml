import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.Popup {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property bool penetrationEvent: false
    property bool closable: true
    property bool maskClosable: false
    property var stepModel: []
    property Item currentTarget: null
    property int currentStep: 0
    property color colorOverlay: HusTheme.HusTour.colorOverlay
    property bool showArrow: true
    property int arrowWidth: 16
    property int arrowHeight: 8
    property int focusMargin: 5
    property int focusRadius: 2
    property int stepCardWidth: 250
    property HusRadius radiusStepCard: HusRadius { all: HusTheme.HusTour.radiusCard }
    property color colorStepCard: HusTheme.HusTour.colorBg
    property font stepTitleFont: Qt.font({
                                             bold: true,
                                             family: HusTheme.HusTour.fontFamily,
                                             pixelSize: parseInt(HusTheme.HusTour.fontSizeTitle)
                                         })
    property color colorStepTitle: HusTheme.HusTour.colorText
    property font stepDescriptionFont: Qt.font({
                                                   family: HusTheme.HusTour.fontFamily,
                                                   pixelSize: parseInt(HusTheme.HusTour.fontSizeDescription)
                                               })
    property color colorStepDescription: HusTheme.HusTour.colorText
    property font indicatorFont: Qt.font({
                                             family: HusTheme.HusTour.fontFamily,
                                             pixelSize: parseInt(HusTheme.HusTour.fontSizeIndicator)
                                         })
    property color colorIndicator: HusTheme.HusTour.colorText
    property font buttonFont: Qt.font({
                                          family: HusTheme.HusTour.fontFamily,
                                          pixelSize: parseInt(HusTheme.HusTour.fontSizeButton)
                                      })
    property Component arrowDelegate: Canvas {
        id: __arrowDelegate
        width: arrowWidth
        height: arrowHeight
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onFillStyleChanged: requestPaint();
        onPaint: {
            const ctx = getContext('2d');
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
    property Component closeButtonDelegate: HusCaptionButton {
        topPadding: 2
        bottomPadding: 2
        leftPadding: 4
        rightPadding: 4
        animationEnabled: control.animationEnabled
        radiusBg.all: HusTheme.HusTour.radiusButtonBg
        iconSource: HusIcon.CloseOutlined
        hoverCursorShape: Qt.PointingHandCursor
        onClicked: {
            control.close();
        }
    }
    property Component stepCardDelegate: HusRectangleInternal {
        id: __stepCardDelegate
        width: stepData.cardWidth ? stepData.cardWidth : control.stepCardWidth
        height: stepData.cardHeight ? stepData.cardHeight : (__stepCardColumn.height + 20)
        color: stepData.cardColor ? stepData.cardColor : control.colorStepCard
        radius: stepData.cardRadius ? stepData.cardRadius : control.radiusStepCard.all
        topLeftRadius: stepData.cardRadius ? stepData.cardRadius : control.radiusStepCard.topLeft
        topRightRadius: stepData.cardRadius ? stepData.cardRadius : control.radiusStepCard.topRight
        bottomLeftRadius: stepData.cardRadius ? stepData.cardRadius : control.radiusStepCard.bottomLeft
        bottomRightRadius: stepData.cardRadius ? stepData.cardRadius : control.radiusStepCard.bottomRight
        clip: true

        property var stepData: control.stepModel[control.currentStep]

        Connections {
            target: control
            function onCurrentTargetChanged() {
                if (control.stepModel.length > control.currentStep)
                    __stepCardDelegate.stepData = control.stepModel[control.currentStep];
            }
        }

        Column {
            id: __stepCardColumn
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            HusText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: stepData.title ? stepData.title : ''
                color: stepData.titleColor ? stepData.titleColor : control.colorStepTitle
                font: control.stepTitleFont
            }

            HusText {
                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAnywhere
                text: stepData.description || ''
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

                HusButton {
                    id: __prevButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: __nextButton.left
                    anchors.rightMargin: 15
                    anchors.bottom: __nextButton.bottom
                    visible: control.currentStep != 0
                    animationEnabled: control.animationEnabled
                    text: qsTr('上一步')
                    font: control.buttonFont
                    type: HusButton.Type_Outlined
                    onClicked: {
                        if (control.currentStep > 0) {
                            control.currentStep -= 1;
                            __stepCardDelegate.stepData = control.stepModel[control.currentStep];
                            control.currentTarget = __stepCardDelegate.stepData.target;
                        }
                    }
                }

                HusButton {
                    id: __nextButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.bottom: parent.bottom
                    animationEnabled: control.animationEnabled
                    text: (control.currentStep + 1 == control.stepModel.length) ? qsTr('结束导览') : qsTr('下一步')
                    font: control.buttonFont
                    type: HusButton.Type_Primary
                    onClicked: {
                        if ((control.currentStep + 1 == control.stepModel.length)) {
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

        Loader {
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.topMargin: 2
            sourceComponent: control.closeButtonDelegate
            active: control.closable
        }
    }
    property Component indicatorDelegate: HusText {
        text: (control.currentStep + 1) + ' / ' + control.stepModel.length
        font: control.indicatorFont
        color: control.colorIndicator
    }

    function gotoStep(step: int) {
        if (stepModel.length > step) {
            currentStep = step;
            currentTarget = stepModel[control.currentStep].target;
        }
    }

    function resetStep() {
        currentStep = 0;
        if (stepModel.length > currentStep) {
            currentTarget = stepModel[control.currentStep].target;
        }
    }

    function appendStep(object) {
        stepModel.push(object);
        stepModelChanged();
    }

    function close() {
        if (!visible || __private.isClosing) return;
        if (animationEnabled) {
            __private.startClosing();
        } else {
            visible = false;
        }
    }

    x: 0
    y: 0
    objectName: '__HusTourStep__'
    onStepModelChanged: {
        resetStep();
        __private.recalcPosition();
    }
    onCurrentTargetChanged: __private.recalcPosition();
    onFocusMarginChanged: {
        __private.recalcPosition();
    }
    onFocusRadiusChanged: {
        __private.repaint();
    }
    onAboutToShow: {
        __private.recalcPosition();
        opacity = 1.0;
    }
    onAboutToHide: {
        if (animationEnabled && !__private.isClosing && opacity > 0) {
            visible = true;
            __private.startClosing();
        }
    }
    enter: Transition {
        NumberAnimation {
            property: 'opacity';
            from: 0.0
            to: 1.0
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    exit: null
    focus: true
    modal: !penetrationEvent
    dim: true
    closePolicy: maskClosable ? T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside : T.Popup.NoAutoClose
    parent: T.Overlay.overlay
    T.Overlay.modal: Item {
        Canvas {
            id: __canvas
            anchors.fill: parent
            opacity: control.opacity
            onPaint: {
                const ctx = getContext('2d');
                ctx.clearRect(0, 0, width, height);

                ctx.save();
                ctx.fillStyle = control.colorOverlay;
                ctx.fillRect(0, 0, width, height);

                ctx.globalCompositeOperation = 'destination-out';
                ctx.fillStyle = '#fff';

                const rect = Qt.rect(__private.focusX, __private.focusY, __private.focusWidth, __private.focusHeight);
                ctx.beginPath();
                ctx.moveTo(rect.x + control.focusRadius, rect.y);
                ctx.lineTo(rect.x + rect.width - control.focusRadius, rect.y);
                ctx.arcTo(rect.x + rect.width, rect.y, rect.x + rect.width, rect.y + control.focusRadius, control.focusRadius);
                ctx.lineTo(rect.x + rect.width, rect.y + rect.height - control.focusRadius);
                ctx.arcTo(rect.x + rect.width, rect.y + rect.height, rect.x + rect.width - control.focusRadius, rect.y + rect.height, control.focusRadius);
                ctx.lineTo(rect.x + control.focusRadius, rect.y + rect.height);
                ctx.arcTo(rect.x, rect.y + rect.height, rect.x, rect.y + rect.height - control.focusRadius, control.focusRadius);
                ctx.lineTo(rect.x, rect.y + control.focusRadius);
                ctx.arcTo(rect.x, rect.y, rect.x + control.focusRadius, rect.y, control.focusRadius);
                ctx.closePath();
                ctx.fill();

                ctx.restore();
            }
        }

        Connections {
            target: __private
            function onRepaint() {
                __canvas.requestPaint();
            }
        }

        Item {
            id: __eventArea
            x: __private.focusX
            y: __private.focusY
            width: __private.focusWidth
            height: __private.focusHeight
            visible: false
        }

        /*! 禁止 currentTarget 外的滚动 */
        WheelHandler {
            onWheel:
                event => {
                    if (!__eventArea.contains(Qt.point(event.x, event.y))) {
                        event.accepted = true;
                    }
                }
        }
    }
    T.Overlay.modeless: T.Overlay.modal
    background: Item {
        Item {
            id: __anchor
            x: __private.focusX + __private.focusWidth * 0.5
            y: __private.focusY + __private.focusHeight
            opacity: control.opacity
            onYChanged: recalcPosition();

            property bool isTop: false

            function recalcPosition() {
                isTop = (__anchor.y + __arrowLoader.height + __stepLoader.itemHeight + 5) > __stepLoader.winHeight;
            }

            Loader {
                id: __arrowLoader
                y: __anchor.isTop ? (-__private.focusHeight - height - 5) : 5
                width: control.arrowWidth
                height: control.arrowHeight
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: control.arrowDelegate
                rotation: __anchor.isTop ? 180 : 0
            }

            Loader {
                id: __stepLoader
                x: {
                    if (__anchor.x - itemWidth * 0.5 > 0) {
                        if (__anchor.x + itemWidth * 0.5 > winWidth) {
                            /*! 最右 */
                            return winWidth - __anchor.x - itemWidth;
                        } else {
                            /*! 中心 */
                            return -itemWidth * 0.5;
                        }
                    } else {
                        /*! 最左 */
                        return -__anchor.x;
                    }
                }
                y: __anchor.isTop ? (__arrowLoader.y - itemHeight + 1) : (__arrowLoader.y + __arrowLoader.height - 1)
                sourceComponent: control.stepCardDelegate
                onItemWidthChanged: __anchor.recalcPosition();
                onItemHeightChanged: __anchor.recalcPosition();
                onWinWidthChanged: {
                    __private.recalcPosition(true);
                    __anchor.recalcPosition();
                }
                onWinHeightChanged: {
                    __private.recalcPosition(true);
                    __anchor.recalcPosition();
                }

                property real itemWidth: item?.width ?? 0
                property real itemHeight: item?.height ?? 0
                property real winWidth: Window.window?.width ?? 0
                property real winHeight: Window.window?.height ?? 0
            }
        }
    }

    NumberAnimation {
        running: __private.isClosing
        target: control
        property: 'opacity'
        from: 1.0
        to: 0.0
        duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        easing.type: Easing.InQuad
        onFinished: {
            __private.isClosing = false;
            control.resetStep();
            control.visible = false;
        }
    }

    Item {
        id: __private

        signal repaint()

        property bool first: true
        property real focusX: 0
        property real focusY: 0
        property real focusWidth: control.currentTarget ? (currentTarget.width + focusMargin * 2) : 0
        property real focusHeight: control.currentTarget ? (currentTarget.height + focusMargin * 2) : 0
        property bool isClosing: false

        onFocusXChanged: repaint();
        onFocusYChanged: repaint();
        onFocusWidthChanged: repaint();
        onFocusHeightChanged: repaint();

        function recalcPosition(delay = false) {
            if (delay) {
                /*! 需要延时计算 */
                __privateTimer.restart();
            } else {
                __privateTimer.calcPosition();
            }
        }

        function startClosing() {
            if (isClosing) return;
            isClosing = true;
        }

        Behavior on focusX {
            enabled: control.animationEnabled
            NumberAnimation { easing.type: Easing.OutQuart; duration: HusTheme.Primary.durationSlow }
        }
        Behavior on focusY {
            enabled: control.animationEnabled
            NumberAnimation { easing.type: Easing.OutQuart; duration: HusTheme.Primary.durationSlow }
        }
        Behavior on focusWidth {
            enabled: control.animationEnabled
            NumberAnimation { easing.type: Easing.OutQuart; duration: HusTheme.Primary.durationSlow }
        }
        Behavior on focusHeight {
            enabled: control.animationEnabled
            NumberAnimation { easing.type: Easing.OutQuart; duration: HusTheme.Primary.durationSlow }
        }
    }

    Timer {
        id: __privateTimer
        interval: 200
        onTriggered: calcPosition();

        function calcPosition() {
            if (!control.currentTarget) return;
            const pos = control.currentTarget.mapToItem(null, 0, 0);
            __private.focusX = pos.x - control.focusMargin;
            __private.focusY = pos.y - control.focusMargin;
            __private.repaint();
        }
    }
}

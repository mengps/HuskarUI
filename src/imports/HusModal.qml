import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

HusPopup {
    id: control

    enum Position {
        Position_Top = 0,
        Position_Bottom = 1,
        Position_Center = 2,
        Position_Left = 3,
        Position_Right = 4
    }

    signal confirm()
    signal cancel()

    property int position: HusModal.Position_Center
    property int positionMargin: 120
    property bool closable: true
    property bool maskClosable: true
    property var iconSource: 0 || ''
    property int iconSize: 24
    property string title: ''
    property string description: ''
    property string confirmText: ''
    property string cancelText: ''
    property color colorOverlay: control.themeSource.colorOverlay
    property color colorIcon: control.themeSource.colorIcon
    property color colorTitle: control.themeSource.colorTitle
    property color colorDescription: control.themeSource.colorDescription
    property font titleFont: Qt.font({
                                         family: control.themeSource.fontFamily,
                                         bold: true,
                                         pixelSize: parseInt(control.themeSource.fontSizeTitle)
                                     })
    property font descriptionFont: Qt.font({
                                               family: control.themeSource.fontFamily,
                                               pixelSize: parseInt(control.themeSource.fontSizeDescription)
                                           })
    property Component iconDelegate: HusIconText {
        color: control.colorIcon
        iconSource: control.iconSource
        iconSize: control.iconSize
    }
    property Component titleDelegate: HusText {
        height: control.title == '' ? 0 : implicitHeight
        font: control.titleFont
        color: control.colorTitle
        text: control.title
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component descriptionDelegate: HusText {
        height: control.description == '' ? 0 : implicitHeight
        font: control.descriptionFont
        color: control.colorDescription
        text: control.description
        lineHeight: control.themeSource.fontLineHeightDescription
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component confirmButtonDelegate: HusButton {
        animationEnabled: control.animationEnabled
        text: control.confirmText
        type: HusButton.Type_Primary
        onClicked: control.confirm();
    }
    property Component cancelButtonDelegate: HusButton {
        animationEnabled: control.animationEnabled
        text: control.cancelText
        type: HusButton.Type_Default
        onClicked: control.cancel();
    }
    property Component closeButtonDelegate: HusCaptionButton {
        animationEnabled: control.animationEnabled
        topPadding: 4
        bottomPadding: 4
        leftPadding: 8
        rightPadding: 8
        hoverCursorShape: Qt.PointingHandCursor
        iconSource: HusIcon.CloseOutlined
        radiusBg.all: control.themeSource.radiusCloseBg
        onClicked: control.close();
    }
    property Component footerDelegate: Item {
        height: __footer.height

        Row {
            id: __footer
            anchors.right: parent.right
            spacing: 10

            Loader {
                active: control.confirmText !== ''
                sourceComponent: control.confirmButtonDelegate
            }

            Loader {
                active: control.cancelText !== ''
                sourceComponent: control.cancelButtonDelegate
            }
        }
    }
    property Component contentDelegate: Item {
        height: __columnLayout.implicitHeight + 40

        Column {
            id: __columnLayout
            width: parent.width - 40
            anchors.centerIn: parent
            spacing: 10

            RowLayout {
                width: parent.width
                spacing: 10

                Loader {
                    id: __iconLoader
                    Layout.alignment: Qt.AlignVCenter
                    visible: active
                    active: control.iconSource !== 0 && control.iconSource !== ''
                    sourceComponent: control.iconDelegate
                }

                Loader {
                    id: __titleLoader
                    Layout.alignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                    sourceComponent: control.titleDelegate
                }
            }

            Loader {
                width : parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: __iconLoader.active ? (__iconLoader.width + 10) : 0
                sourceComponent: control.descriptionDelegate
            }

            Loader {
                width : parent.width
                sourceComponent: control.footerDelegate
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
    property Component bgDelegate: HusRectangleInternal {
        color: control.colorBg
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    function openInfo() {
        iconSource = HusIcon.ExclamationCircleFilled;
        colorIcon = HusTheme.Primary.colorInfo;
        open();
    }

    function openSuccess() {
        iconSource = HusIcon.CheckCircleFilled;
        colorIcon = HusTheme.Primary.colorSuccess;
        open();
    }

    function openError() {
        iconSource = HusIcon.CloseCircleFilled;
        colorIcon = HusTheme.Primary.colorError;
        open();
    }

    function openWarning() {
        iconSource = HusIcon.ExclamationCircleFilled;
        colorIcon = HusTheme.Primary.colorWarning;
        open();
    }

    function close() {
        if (!visible || __private.isClosing) return;
        if (animationEnabled) {
            __private.startClosing();
        } else {
            visible = false;
        }
    }

    objectName: '__HusModal__'
    themeSource: HusTheme.HusModal
    parent: T.Overlay.overlay
    x: {
        switch (control.position) {
        case HusModal.Position_Top:
            return (parent.width - width) * 0.5;
        case HusModal.Position_Bottom:
            return (parent.width - width) * 0.5;
        case HusModal.Position_Center:
            return (parent.width - width) * 0.5;
        case HusModal.Position_Left:
            return positionMargin;
        case HusModal.Position_Right:
            return parent.width - width - positionMargin;
        }
    }
    y: {
        switch (control.position) {
        case HusModal.Position_Top:
            return positionMargin;
        case HusModal.Position_Bottom:
            return parent.height - height - positionMargin;
        case HusModal.Position_Center:
            return (parent.height - height) * 0.5;
        case HusModal.Position_Left:
            return (parent.height - height) * 0.5;
        case HusModal.Position_Right:
            return (parent.height - height) * 0.5;
        }
    }
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset
    modal: true
    focus: true
    closePolicy: maskClosable ? T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutside : T.Popup.NoAutoClose
    enter: Transition {
        NumberAnimation {
            property: 'scale'
            from: 0.5
            to: 1.0
            easing.type: Easing.OutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
        NumberAnimation {
            property: 'opacity'
            from: 0.0
            to: 1.0
            easing.type: Easing.OutQuad
            duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        }
    }
    exit: null
    background: Item {
        implicitHeight: __bgLoader.height

        HusShadow {
            anchors.fill: __bgLoader
            source: __bgLoader
            shadowColor: control.colorShadow
        }

        Loader {
            active: control.movable || control.resizable
            sourceComponent: HusResizeMouseArea {
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

        Loader {
            id: __bgLoader
            width: parent.width
            height: __contentLoader.height
            sourceComponent: control.bgDelegate
        }

        Loader {
            id: __contentLoader
            width: parent.width
            sourceComponent: control.contentDelegate
        }
    }
    onAboutToHide: {
        if (animationEnabled && !__private.isClosing && opacity > 0) {
            visible = true;
            __private.startClosing();
        }
    }
    T.Overlay.modal: Item {
        Rectangle {
            anchors.fill: parent
            color: control.colorOverlay
            opacity: control.opacity
        }
    }

    QtObject {
        id: __private

        property bool isClosing: false

        function startClosing() {
            if (isClosing) return;
            isClosing = true;
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
            control.visible = false;
        }
    }

    NumberAnimation  {
        running: __private.isClosing
        target: control
        property: 'scale'
        from: 1.0
        to: 0.5
        easing.type: Easing.InQuad
        duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
    }
}

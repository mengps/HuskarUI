import QtQuick
import QtQuick.Controls.Basic as T
import HuskarUI.Basic

Item {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property alias wheelEnabled: __scrollView.wheelEnabled
    readonly property bool active: __scrollView.hovered || __scrollView.activeFocus
    readonly property alias hovered: __scrollView.hovered
    property alias topPadding: __scrollView.topPadding
    property alias bottomPadding: __scrollView.bottomPadding
    property alias leftPadding: __scrollView.leftPadding
    property alias rightPadding: __scrollView.rightPadding
    property bool resizable: false
    property int minResizeHeight: 30
    property bool autoSize: false
    property int minRows: -1
    property int maxRows: -1
    readonly property alias lineCount: __textArea.lineCount
    property alias length: __textArea.length
    property int maxLength: -1
    property alias readOnly: __textArea.readOnly
    property alias font: __scrollView.font
    property alias text: __textArea.text
    property alias placeholderText: __textArea.placeholderText
    property alias colorText: __textArea.color
    property alias colorPlaceholderText: __textArea.placeholderTextColor
    property alias colorSelectedText: __textArea.selectedTextColor
    property alias colorSelection: __textArea.selectionColor
    property color colorBorder: enabled ?
                                    active ? themeSource.colorBorderHover :
                                             themeSource.colorBorder : themeSource.colorBorderDisabled
    property color colorBg: enabled ? themeSource.colorBg : themeSource.colorBgDisabled
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusTextArea

    property alias textArea: __textArea
    property alias verScrollBar: __vScrollBar
    property alias horScrollBar: __hScrollBar

    property Component bgDelegate: HusRectangleInternal {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    objectName: '__HusTextArea__'
    topPadding: 6
    bottomPadding: 6
    leftPadding: 10
    rightPadding: 10
    height: {
        if (autoSize) {
            if (minRows > 0 && maxRows > 0) {
                if (lineCount < minRows)
                    return __private.minHeight + __textArea.topPadding + __textArea.bottomPadding + topPadding + bottomPadding;
                else if (lineCount > maxRows) {
                    return __private.maxHeight + __textArea.topPadding + __textArea.bottomPadding + topPadding + bottomPadding;
                } else {
                    return lineCount * __private.lineHeight + __textArea.topPadding + __textArea.bottomPadding + topPadding + bottomPadding;
                }
            } else {
                return __textArea.implicitHeight + topPadding + bottomPadding;
            }
        } else {
            return minResizeHeight;
        }
    }
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    wheelEnabled: autoSize ? (minRows > 0 && maxRows > 0) : (__vScrollBar.visible || __vScrollBar.active)

    onTextChanged: __private.removeExcess();
    onMaxLengthChanged: __private.removeExcess();

    Behavior on height { enabled: control.animationEnabled && !__resize.pressed; NumberAnimation { duration: HusTheme.Primary.durationMid } }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorPlaceholderText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorSelectedText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    function scrollToBeginning() {
        __textArea.cursorPosition = 0;
    }

    function scrollToEnd() {
        __textArea.cursorPosition = __textArea.length;
    }

    T.ScrollView {
        id: __scrollView
        focus: true
        anchors.fill: parent
        background: Loader {
            sourceComponent: control.bgDelegate
        }
        T.ScrollBar.vertical: HusScrollBar {
            id: __vScrollBar
            policy: T.ScrollBar.AlwaysOn
            animationEnabled: control.animationEnabled
        }
        T.ScrollBar.horizontal: HusScrollBar {
            id: __hScrollBar
            policy: T.ScrollBar.AlwaysOn
            animationEnabled: control.animationEnabled
        }
        Component.onCompleted: {
            contentItem.boundsBehavior = Flickable.StopAtBounds;
        }

        T.TextArea {
            id: __textArea
            focus: true
            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0
            wrapMode: T.TextArea.WrapAnywhere
            renderType: HusTheme.textRenderType
            color: control.themeSource.colorText
            selectByMouse: true
            selectByKeyboard: true
            placeholderTextColor: control.themeSource.colorPlaceholderText
            selectedTextColor: control.themeSource.colorTextSelected
            selectionColor: control.themeSource.colorSelection
            font: control.font
        }
    }

    HusIconText {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 1
        iconSource: HusIcon.MinusOutlined
        rotation: -45
        visible: control.resizable
        enabled: visible

        HusIconText {
            y: 4
            iconSource: HusIcon.MinusOutlined
            scale: 0.5
        }

        MouseArea {
            id: __resize
            anchors.fill: parent
            hoverEnabled: true
            preventStealing: true
            onEntered: cursorShape = Qt.SizeVerCursor;
            onExited: cursorShape = Qt.ArrowCursor;
            onPressed:
                mouse => {
                    startY =  mouseY;
                    mouse.accepted = true;
                }
            onReleased: mouse => mouse.accepted = true;
            onPositionChanged:
                mouse => {
                    if (pressed) {
                        const offsetY = mouse.y - startY;
                        control.height = Math.max(control.height + offsetY, control.minResizeHeight);
                        mouse.accepted = true;
                    }
                }
            property int startY: 0
        }
    }

    QtObject {
        id: __private

        property real minHeight: lineHeight * control.minRows
        property real maxHeight: lineHeight * control.maxRows
        property real lineHeight: __textArea.contentHeight / __textArea.lineCount

        function removeExcess() {
            if (control.maxLength > 0 && control.length > control.maxLength) {
                __textArea.remove(control.maxLength, control.length);
            }
        }
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: control.readOnly
    Accessible.description: control.contentDescription
}

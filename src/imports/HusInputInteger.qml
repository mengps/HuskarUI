import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

T.SpinBox {
    id: control

    signal beforeActivated(index: int, var data)
    signal afterActivated(index: int, var data)

    property bool animationEnabled: HusTheme.animationEnabled
    property alias clearEnabled: __input.clearEnabled
    property alias clearIconSource: __input.clearIconSource
    property alias clearIconSize: __input.clearIconSize
    property alias clearIconPosition: __input.clearIconPosition
    property alias readOnly: __input.readOnly
    property bool showHandler: true
    property bool alwaysShowHandler: false
    property bool useWheel: false
    property bool useKeyboard: true
    property alias min: control.from
    property alias max: control.to
    property alias step: control.stepSize
    property string prefix: ''
    property string suffix: ''
    property var upIcon: HusIcon.UpOutlined || ''
    property var downIcon: HusIcon.DownOutlined || ''
    property font labelFont: Qt.font({
                                         family: 'HuskarUI-Icons',
                                         pixelSize: parseInt(themeSource.fontSize)
                                     })
    property var beforeLabel: '' || []
    property var afterLabel: '' || []
    property int initBeforeLabelIndex: 0
    property int initAfterLabelIndex: 0
    property string currentBeforeLabel: ''
    property string currentAfterLabel: ''
    property var formatter: (value, locale) => value.toLocaleString(locale, 'f', 0)
    property var parser: (text, locale) => Number.fromLocaleString(locale, text)
    property int defaultHandlerWidth: 24
    property alias colorText: __input.colorText
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property var themeSource: HusTheme.HusInput

    property alias input: __input

    property Component beforeDelegate: HusRectangleInternal {
        enabled: control.enabled
        width: Math.max(30, __beforeLoader.implicitWidth + 10)
        topLeftRadius: control.radiusBg.topLeft
        bottomLeftRadius: control.radiusBg.bottomLeft
        color: enabled ? control.themeSource.colorLabelBg : control.themeSource.colorLabelBgDisabled
        border.color: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        Loader {
            id: __beforeLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.beforeLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: true
        }
    }
    property Component afterDelegate: HusRectangleInternal {
        enabled: control.enabled
        width: Math.max(30, __afterLoader.implicitWidth + 10)
        topRightRadius: control.radiusBg.topRight
        bottomRightRadius: control.radiusBg.bottomRight
        color: enabled ? control.themeSource.colorLabelBg : control.themeSource.colorLabelBgDisabled
        border.color: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        Loader {
            id: __afterLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.afterLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: false
        }
    }
    property Component handlerDelegate: Item {
        id: __handlerRoot
        clip: true
        enabled: control.enabled
        width: enabled && (__input.hovered || control.alwaysShowHandler) ? control.defaultHandlerWidth : 0

        property real halfHeight: height * 0.5
        property real hoverHeight: height * 0.6
        property real noHoverHeight: height * 0.4
        property color colorBorder: enabled ? control.themeSource.colorBorder : control.themeSource.colorBorderDisabled

        Behavior on width {
            enabled: control.animationEnabled;
            NumberAnimation {
                easing.type: Easing.OutCubic
                duration: HusTheme.Primary.durationMid
            }
        }

        HusIconButton {
            id: __upButton
            width: parent.width
            height: hovered ? parent.hoverHeight :
                              __downButton.hovered ? parent.noHoverHeight : parent.halfHeight
            padding: 0
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? control.themeSource.colorBorderHover :
                                     control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
            iconSize: parseInt(control.themeSource.fontSize) - 4
            iconSource: control.upIcon
            hoverCursorShape: control.value >= control.max ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: HusRectangleInternal {
                topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
                color: 'transparent'
                border.color: __handlerRoot.colorBorder
            }
            onClicked: {
                control.increase();
                control.valueModified();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        }

        HusIconButton {
            id: __downButton
            width: parent.width
            height: (hovered ? parent.hoverHeight :
                               __upButton.hovered ? parent.noHoverHeight : parent.halfHeight) + 1
            anchors.top: __upButton.bottom
            anchors.topMargin: -1
            padding: 0
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? control.themeSource.colorBorderHover :
                                     control.themeSource.colorBorder : control.themeSource.colorBorderDisabled
            iconSize: parseInt(control.themeSource.fontSize) - 4
            iconSource: control.downIcon
            hoverCursorShape: control.value <= control.min ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: HusRectangleInternal {
                bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
                color: 'transparent'
                border.color: __handlerRoot.colorBorder
            }
            onClicked: {
                control.decrease();
                control.valueModified();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }
        }
    }

    function getFullText() {
        return __input.text;
    }

    function select(start: int, end: int) {
        __input.select(start, end);
    }

    function selectAll(start: int, end: int) {
        __input.selectAll(start, end);
    }

    function selectWord(start: int, end: int) {
        __input.selectWord(start, end);
    }

    function clear() {
        __input.clear();
        control.valueChanged();
    }

    function copy() {
        __input.copy();
    }

    function cut() {
        __input.cut();
        control.valueChanged();
    }

    function paste() {
        __input.paste();
        control.valueChanged();
    }

    function redo() {
        __input.redo();
        control.valueChanged();
    }

    function undo() {
        __input.undo();
        control.valueChanged();
    }

    objectName: '__HusInputNumber__'
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    editable: true
    min: -2147483648
    max: 2147483647
    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }
    valueFromText: parser
    textFromValue: formatter
    contentItem: RowLayout {
        id: __row
        spacing: 0

        Loader {
            Layout.rightMargin: -1
            Layout.fillHeight: true
            active: control.beforeLabel?.length !== 0
            sourceComponent: control.beforeDelegate
        }

        HusInput {
            id: __input
            z: 10
            Layout.fillHeight: true
            Layout.fillWidth: true
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            leftPadding: (__prefixLoader.active ? __prefixLoader.implicitWidth : (leftClearIconPadding > 0 ? 5 : 10))
                         + leftIconPadding + leftClearIconPadding
            rightPadding: (__suffixLoader.active ? __suffixLoader.implicitWidth : (rightClearIconPadding > 0 ? 5 : 10))
                          + (rightClearIconPadding > 0 ? 0 : __handlerLoader.implicitWidth)
                          + rightIconPadding + rightClearIconPadding
            validator: control.validator
            background: HusRectangleInternal {
                color: __input.colorBg
                topLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.topLeft : 0
                topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
                bottomLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.bottomLeft : 0
                bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
            }
            clearIconDelegate: HusIconText {
                iconSource: control.clearIconSource
                iconSize: control.clearIconSize
                leftPadding: control.clearIconPosition === HusInput.Position_Left ? (control.leftIconPadding > 0 ? 5 : 10) * __input.sizeRatio : 0
                rightPadding: control.clearIconPosition === HusInput.Position_Right ?
                                  ((control.rightIconPadding > 0 ? 5 : 10) * __input.sizeRatio + __handlerLoader.implicitWidth) : 0
                colorIcon: {
                    if (control.enabled) {
                        return __tapHandler.pressed ? control.themeSource.colorClearIconActive :
                                                      __hoverHandler.hovered ? control.themeSource.colorClearIconHover :
                                                                               control.themeSource.colorClearIcon;
                    } else {
                        return control.themeSource.colorClearIconDisabled;
                    }
                }

                Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

                HoverHandler {
                    id: __hoverHandler
                    enabled: (control.clearEnabled === 'active' || control.clearEnabled === true) && !control.readOnly
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: __tapHandler
                    enabled: (control.clearEnabled === 'active' || control.clearEnabled === true) && !control.readOnly
                    onTapped: {
                        control.clear();
                        control.valueModified();
                    }
                }
            }
            text: control.displayText
            onTextEdited: control.valueChanged();
            onEditingFinished: control.valueChanged();

            Keys.onUpPressed: {
                if (control.enabled && control.useKeyboard) {
                    control.increase();
                    control.valueModified();
                }
            }
            Keys.onDownPressed: {
                if (control.enabled && control.useKeyboard) {
                    control.decrease();
                    control.valueModified();
                }
            }

            WheelHandler {
                enabled: control.enabled && control.useWheel
                onWheel: function(wheel) {
                    if (wheel.angleDelta.y > 0) {
                        control.increase();
                        control.valueModified();
                    } else {
                        control.decrease();
                        control.valueModified();
                    }
                }
            }

            Loader {
                id: __prefixLoader
                height: parent.height
                active: control.prefix != ''
                sourceComponent: HusText {
                    leftPadding: 10
                    rightPadding: 5
                    text: control.prefix
                    color: __input.colorText
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Loader {
                id: __suffixLoader
                height: parent.height
                anchors.right: __handlerLoader.left
                active: control.suffix != ''
                sourceComponent: HusText {
                    leftPadding: 5
                    rightPadding: 10
                    text: control.suffix
                    color: __input.colorText
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Loader {
                id: __handlerLoader
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                active: control.showHandler && !__input.readOnly
                sourceComponent: control.handlerDelegate
            }

            HusRectangleInternal {
                anchors.fill: parent
                color: 'transparent'
                border.color: __input.colorBorder
                topLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.topLeft : 0
                bottomLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg.bottomLeft : 0
                topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.topRight : 0
                bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg.bottomRight : 0
            }
        }

        Loader {
            Layout.leftMargin: -1
            Layout.fillHeight: true
            active: control.afterLabel?.length !== 0
            sourceComponent: control.afterDelegate
        }
    }
    background: Item { }

    onPrefixChanged: valueChanged();
    onSuffixChanged: valueChanged();
    onCurrentAfterLabelChanged: valueChanged();
    onCurrentBeforeLabelChanged: valueChanged();
    Component.onCompleted: valueChanged();

    Component {
        id: __selectComp

        HusSelect {
            id: __afterText
            rightPadding: 4
            animationEnabled: control.animationEnabled
            colorBg: 'transparent'
            colorBorder: 'transparent'
            clearEnabled: false
            model: isBefore ? control.beforeLabel : control.afterLabel
            currentIndex: isBefore ? control.initBeforeLabelIndex : control.initAfterLabelIndex
            onActivated:
                (index) => {
                    if (isBefore) {
                        control.beforeActivated(index, valueAt(index));
                    } else {
                        control.afterActivated(index, valueAt(index));
                    }
                }
            onCurrentTextChanged: {
                if (isBefore)
                    control.currentBeforeLabel = currentText;
                else
                    control.currentAfterLabel = currentText;
            }
        }
    }

    Component {
        id: __labelComp

        HusText {
            text: isBefore ? control.beforeLabel : control.afterLabel
            color: __input.colorText
            font: control.labelFont
            Component.onCompleted: {
                if (isBefore)
                    control.currentBeforeLabel = control.beforeLabel;
                else
                    control.currentAfterLabel = control.afterLabel;
            }
        }
    }
}

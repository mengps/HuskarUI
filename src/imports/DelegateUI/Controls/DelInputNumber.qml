import QtQuick
import QtQuick.Layouts
import DelegateUI

Item {
    id: control

    height: __row.implicitHeight
    onValueChanged: __input.text = formatter(value);
    onPrefixChanged: valueChanged();
    onSuffixChanged: valueChanged();
    onCurrentAfterLabelChanged: valueChanged();
    onCurrentBeforeLabelChanged: valueChanged();
    Component.onCompleted: valueChanged();

    signal activedBefore(index: int, var data)
    signal activedAfter(index: int, var data)

    property bool animationEnabled: DelTheme.animationEnabled
    property bool showHandler: true
    property bool alwaysShowHandler: false
    property bool useWheel: false
    property bool useKeyboard: true
    property real value: 0
    property real min: Number.MIN_SAFE_INTEGER
    property real max: Number.MAX_SAFE_INTEGER
    property real step: 1
    property int precision: 0
    property string prefix: ''
    property string suffix: ''
    property var upIcon: DelIcon.UpOutlined || ''
    property var downIcon: DelIcon.DownOutlined || ''
    property var beforeLabel: '' || []
    property var afterLabel: '' || []
    property string currentBeforeLabel: ''
    property string currentAfterLabel: ''
    property var formatter: value => value.toFixed(precision)
    property var parser: text => Number(text)
    property int defaultHandlerWidth: 24
    property alias colorText: __input.colorText
    property int radiusBg: 6

    property Component beforeDelegate: DelRectangle {
        enabled: control.enabled
        width: Math.max(30, __beforeLoader.implicitWidth + 10)
        topLeftRadius: control.radiusBg
        bottomLeftRadius: control.radiusBg
        color: enabled ? DelTheme.DelInput.colorLabelBg : DelTheme.DelInput.colorLabelBgDisabled
        border.color: enabled ? DelTheme.DelInput.colorBorder : DelTheme.DelInput.colorBorderDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

        Loader {
            id: __beforeLoader
            anchors.centerIn: parent
            sourceComponent: typeof control.beforeLabel == 'string' ? __labelComp : __selectComp
            property bool isBefore: true
        }
    }
    property Component afterDelegate: DelRectangle {
        enabled: control.enabled
        width: Math.max(30, __afterLoader.implicitWidth + 10)
        topRightRadius: control.radiusBg
        bottomRightRadius: control.radiusBg
        color: enabled ? DelTheme.DelInput.colorLabelBg : DelTheme.DelInput.colorLabelBgDisabled
        border.color: enabled ? DelTheme.DelInput.colorBorder : DelTheme.DelInput.colorBorderDisabled

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

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
        property color colorBorder: enabled ? DelTheme.DelInput.colorBorder : DelTheme.DelInput.colorBorderDisabled

        Behavior on width {
            enabled: control.animationEnabled;
            NumberAnimation {
                easing.type: Easing.OutCubic
                duration: DelTheme.Primary.durationMid
            }
        }

        DelIconButton {
            id: __upButton
            enabled: control.enabled
            width: parent.width
            height: hovered ? parent.hoverHeight :
                              __downButton.hovered ? parent.noHoverHeight : parent.halfHeight
            padding: 0
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? DelTheme.DelInput.colorBorderHover :
                                     DelTheme.DelInput.colorBorder : DelTheme.DelInput.colorBorderDisabled
            iconSize: DelTheme.DelInput.fontSize - 4
            iconSource: control.upIcon
            hoverCursorShape: control.value >= control.max ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: DelRectangle {
                topRightRadius: control.beforeLabel?.length === 0 ? control.radiusBg : 0
                color: 'transparent'
                border.color: __handlerRoot.colorBorder
            }
            onClicked: {
                control.increase();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
        }

        DelIconButton {
            id: __downButton
            enabled: control.enabled
            width: parent.width
            height: (hovered ? parent.hoverHeight :
                               __upButton.hovered ? parent.noHoverHeight : parent.halfHeight) + 1
            anchors.top: __upButton.bottom
            anchors.topMargin: -1
            padding: 0
            autoRepeat: true
            colorIcon: control.enabled ?
                           hovered ? DelTheme.DelInput.colorBorderHover :
                                     DelTheme.DelInput.colorBorder : DelTheme.DelInput.colorBorderDisabled
            iconSize: DelTheme.DelInput.fontSize - 4
            iconSource: control.downIcon
            hoverCursorShape: control.value <= control.min ? Qt.ForbiddenCursor : Qt.PointingHandCursor
            background: DelRectangle {
                bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg : 0
                color: 'transparent'
                border.color: __handlerRoot.colorBorder
            }
            onClicked: {
                control.decrease();
            }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationFast } }
        }
    }

    function increase() {
        value = value + step > max ? max : value + step;
    }

    function decrease() {
        value = value - step < min ? min : value - step;
    }

    function getFullText() {
        return __input.text;
    }

    function select(start: int, end: int) {
        __input.select(start, end);
    }

    function selectAll(start: int, end: int) {
        __input.selectAll();
    }

    function selectWord(start: int, end: int) {
        __input.selectWord();
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

    Component {
        id: __selectComp

        DelSelect {
            id: __afterText
            rightPadding: 4
            colorBg: 'transparent'
            colorBorder: 'transparent'
            model: isBefore ? control.beforeLabel : control.afterLabel
            onActivated:
                (index) => {
                    if (isBefore) {
                        control.activedBefore(index, valueAt(index));
                    } else {
                        control.activedAfter(index, valueAt(index));
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

        DelText {
            text: isBefore ? control.beforeLabel : control.afterLabel
            color: __input.colorText
            Component.onCompleted: {
                if (isBefore)
                    control.currentBeforeLabel = control.beforeLabel;
                else
                    control.currentAfterLabel = control.afterLabel;
            }
        }
    }

    RowLayout {
        id: __row
        width: parent.width
        height: parent.height
        spacing: 0

        Loader {
            Layout.rightMargin: -1
            Layout.fillHeight: true
            active: control.beforeLabel?.length !== 0
            sourceComponent: control.beforeDelegate
        }

        DelInput {
            id: __input
            z: 10
            Layout.fillHeight: true
            Layout.fillWidth: true
            enabled: control.enabled
            animationEnabled: control.animationEnabled
            leftPadding: __prefixLoader.active ? __prefixLoader.implicitWidth : 10
            rightPadding: __handlerLoader.implicitWidth + (__suffixLoader.active ? __suffixLoader.implicitWidth : 10)
            background: DelRectangle {
                color: __input.colorBg
                topLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg : 0
                bottomLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg : 0
                topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg : 0
                bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg : 0
            }
            onTextChanged: {
                let v = control.parser(text);
                if (v >= control.min && v <= control.max) control.value = v;
            }
            onEditingFinished: control.valueChanged();

            Keys.onUpPressed: if (control.enabled && control.useKeyboard) control.increase();
            Keys.onDownPressed: if (control.enabled && control.useKeyboard) control.decrease();

            WheelHandler {
                enabled: control.enabled && control.useWheel
                onWheel: function(wheel) {
                    if (wheel.angleDelta.y > 0)
                        control.increase();
                    else
                        control.decrease();
                }
            }

            Loader {
                id: __prefixLoader
                height: parent.height
                active: control.prefix != ''
                sourceComponent: DelText {
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
                sourceComponent: DelText {
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
                active: control.showHandler
                sourceComponent: control.handlerDelegate
            }

            DelRectangle {
                anchors.fill: parent
                color: 'transparent'
                border.color: __input.colorBorder
                topLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg : 0
                bottomLeftRadius: control.beforeLabel?.length === 0 ? control.radiusBg : 0
                topRightRadius: control.afterLabel?.length === 0 ? control.radiusBg : 0
                bottomRightRadius: control.afterLabel?.length === 0 ? control.radiusBg : 0
            }
        }

        Loader {
            Layout.leftMargin: -1
            Layout.fillHeight: true
            active: control.afterLabel?.length !== 0
            sourceComponent: control.afterDelegate
        }
    }
}

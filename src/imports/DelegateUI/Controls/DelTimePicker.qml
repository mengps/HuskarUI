import QtQuick
import QtQuick.Effects
import QtQuick.Controls.Basic as T
import DelegateUI

T.TextField {
    id: control

    enum IconPosition {
        Position_Left = 0,
        Position_Right = 1
    }

    enum TimeFormat {
        Format_HHMMSS = 0,
        Format_HHMM = 1,
        Format_MMSS = 2
    }

    popupFont {
        family: DelTheme.DelTimePicker.fontFamily
        pixelSize: DelTheme.DelTimePicker.fontSize
    }

    property bool animationEnabled: DelTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property int format: DelTimePicker.Format_HHMMSS
    property int iconSize: DelTheme.DelTimePicker.fontIconSize
    property int iconPosition: DelTimePicker.Position_Right
    property color colorText: enabled ? DelTheme.DelTimePicker.colorText : DelTheme.DelTimePicker.colorTextDisabled
    property color colorBorder: enabled ?
                                    active ? DelTheme.DelTimePicker.colorBorderHover :
                                              DelTheme.DelTimePicker.colorBorder : DelTheme.DelTimePicker.colorBorderDisabled
    property color colorBg: enabled ? DelTheme.DelTimePicker.colorBg : DelTheme.DelTimePicker.colorBgDisabled
    property color colorPopupText: DelTheme.DelTimePicker.colorPopupText
    property font popupFont
    property int radiusBg: 6
    property int radiusPopupBg: 6
    property string contentDescription: ""

    signal acceptedTime(time: string);

    function clearTime() {
        if (__private.cleared) {
            control.text = "";
        } else {
            control.text = __private.getTime();
        }
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    Behavior on placeholderTextColor { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

    objectName: "__DelTimePicker__"
    focus: __picker.opened
    padding: 5
    leftPadding: 10 + (iconPosition == DelTimePicker.Position_Left ? iconSize : 0)
    rightPadding: 10 + (iconPosition == DelTimePicker.Position_Right ? iconSize : 0)
    width: 130
    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding
    placeholderText: qsTr("请选择时间")
    color: colorText
    placeholderTextColor: enabled ? DelTheme.DelTimePicker.colorPlaceholderText : DelTheme.DelTimePicker.colorPlaceholderTextDisabled
    selectedTextColor: DelTheme.DelTimePicker.colorSelectedText
    selectionColor: DelTheme.DelTimePicker.colorSelection
    font {
        family: DelTheme.DelTimePicker.fontFamily
        pixelSize: DelTheme.DelTimePicker.fontSize
    }
    background: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg
    }
    onActiveFocusChanged: {
        if (activeFocus)
            __picker.open();
    }
    onTextEdited: {
        __private.commit();
    }
    onEditingFinished: {
        clearTime();
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            __confirmButton.clicked();
        }
    }

    component TimeListView: MouseArea {
        id: __rootItem

        property string value: "00"
        property string checkValue: "00"
        property string tempValue: "00"
        property alias model: __listView.model

        function clearCheck() {
            value = checkValue = tempValue = "00";
            if (__buttonGroup.checkedButton != null)
                __buttonGroup.checkedButton.checked = false;
            const item = __listView.itemAtIndex(0);
            if (item)
                item.checked = true;
            __listView.positionViewAtBeginning();
        }

        function initValue(v) {
            value = checkValue = tempValue = v;
        }

        function checkIndex(index) {
            checkValue = tempValue = (String(index).padStart(2, '0'));
            const item = __listView.itemAtIndex(index);
            if (item) {
                item.checked = true;
                item.clicked();
            }
            __listView.positionViewAtIndex(index, ListView.Beginning);
        }

        function positionViewAtIndex(index, mode) {
            __listView.positionViewAtIndex(index, mode);
        }

        width: 50
        height: parent.height
        hoverEnabled: true
        onExited: {
            tempValue = checkValue;
            control.text = __private.getCheckTime();
        }

        ListView {
            id: __listView
            height: parent.height
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 2
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.AbstractButton {
                width: __listView.width
                height: 28
                checkable: true
                contentItem: Text {
                    id: __viewText
                    font: control.popupFont
                    text: String(index).padStart(2, '0')
                    color: control.colorPopupText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: 4
                    color: hovered ? DelTheme.DelTimePicker.colorButtonBgHover :
                                     checked ? DelTheme.DelTimePicker.colorButtonBgActive : "transparent"
                }
                T.ButtonGroup.group: __buttonGroup
                onClicked: {
                    __rootItem.checkValue = __viewText.text;
                }
                onHoveredChanged: {
                    if (hovered) {
                        __rootItem.tempValue = __viewText.text;
                        control.text = __private.getTempTime();
                    }
                }
                Component.onCompleted: checked = (index == 0);
            }
            onContentHeightChanged: cacheBuffer = contentHeight;
            T.ScrollBar.vertical: DelScrollBar { policy: T.ScrollBar.AsNeeded }

            T.ButtonGroup {
                id: __buttonGroup
            }
        }
    }

    Item {
        id: __private
        property var window: Window.window
        property bool cleared: true
        function getTime() {
            switch (control.format) {
            case DelTimePicker.Format_HHMMSS:
                return`${__hourListView.value}:${__minuteListView.value}:${__secondListView.value}`;
            case DelTimePicker.Format_HHMM:
                return`${__hourListView.value}:${__minuteListView.value}`;
            case DelTimePicker.Format_MMSS:
                return`${__minuteListView.value}:${__secondListView.value}`;
            }
        }
        function getCheckTime() {
            switch (control.format) {
            case DelTimePicker.Format_HHMMSS:
                return`${__hourListView.checkValue}:${__minuteListView.checkValue}:${__secondListView.checkValue}`;
            case DelTimePicker.Format_HHMM:
                return`${__hourListView.checkValue}:${__minuteListView.checkValue}`;
            case DelTimePicker.Format_MMSS:
                return`${__minuteListView.checkValue}:${__secondListView.checkValue}`;
            }
        }
        function getTempTime() {
            switch (control.format) {
            case DelTimePicker.Format_HHMMSS:
                return`${__hourListView.tempValue}:${__minuteListView.tempValue}:${__secondListView.tempValue}`;
            case DelTimePicker.Format_HHMM:
                return`${__hourListView.tempValue}:${__minuteListView.tempValue}`;
            case DelTimePicker.Format_MMSS:
                return`${__minuteListView.tempValue}:${__secondListView.tempValue}`;
            }
        }
        function testValid() {
            let reg;
            switch (control.format) {
            case DelTimePicker.Format_HHMMSS:
                reg = /^([0-1]\d|2[0-3]):([0-5]\d):([0-5]\d)$/;
                break;
            case DelTimePicker.Format_HHMM:
                reg = /^([0-1]\d|2[0-3]):([0-5]\d)$/;
                break;
            case DelTimePicker.Format_MMSS:
                reg = /^([0-5]\d):([0-5]\d)$/;
                break;
            }
            return reg.test(control.text);
        }

        function commit() {
            let hour = "";
            let minute = "";
            let second = "";

            if (testValid()) {
                switch (control.format) {
                case DelTimePicker.Format_HHMMSS:
                    hour = control.getText(0, 2);
                    minute = control.getText(3, 5);
                    second = control.getText(6, 8);
                    break;
                case DelTimePicker.Format_HHMM:
                    hour = control.getText(0, 2);
                    minute = control.getText(3, 5);
                    break;
                case DelTimePicker.Format_MMSS:
                    minute = control.getText(0, 2);
                    second = control.getText(3, 5);
                    break;
                }

                if (hour.length === 2) {
                    const index = parseInt(hour);
                    __hourListView.value = hour;
                    __hourListView.checkIndex(index);
                }
                if (minute.length === 2) {
                    const index = parseInt(minute);
                    __minuteListView.value = minute;
                    __minuteListView.checkIndex(index);
                }
                if (second.length === 2) {
                    const index = parseInt(second);
                    __secondListView.value = second;
                    __secondListView.checkIndex(index);
                }
            }
        }
    }

    TapHandler {
        onTapped: {
            __picker.open();
        }
    }

    DelIconText {
        anchors.left: control.iconPosition == DelTimePicker.Position_Left ? parent.left : undefined
        anchors.right: control.iconPosition == DelTimePicker.Position_Right ? parent.right : undefined
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        iconSource: (control.hovered && control.text.length !== 0) ? DelIcon.CloseCircleFilled : DelIcon.ClockCircleOutlined
        iconSize: control.iconSize
        colorIcon: control.enabled ?
                       __iconMouse.hovered ? DelTheme.DelTimePicker.colorIconHover :
                                             DelTheme.DelTimePicker.colorIcon : DelTheme.DelTimePicker.colorIconDisabled

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

        MouseArea {
            id: __iconMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: parent.iconSource == DelIcon.CloseCircleFilled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: hovered = true;
            onExited: hovered = false;
            property bool hovered: false
            onClicked: {
                __hourListView.clearCheck();
                __minuteListView.clearCheck();
                __secondListView.clearCheck();
                __private.cleared = true;
                control.text = "";
            }
        }
    }

    DelPopup {
        id: __picker
        implicitWidth: implicitContentWidth + leftPadding + rightPadding
        implicitHeight: implicitContentHeight + topPadding + bottomPadding
        leftPadding: 2
        rightPadding: 2
        topPadding: 6
        bottomPadding: 6
        closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0 } }
        exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0 } }
        onAboutToShow: {
            const pos = control.mapToItem(null, 0, 0);
            x = (control.width - width) * 0.5;
            if (__private.window.height > (pos.y + control.height + height + 6)){
                y = control.height + 6;
            } else if (pos.y > height){
                y = -height - 6;
            } else {
                y = __private.window.height - (pos.y + height + 6);
            }
            __private.commit();
        }
        onAboutToHide: {
            control.editingFinished();
        }
        contentItem: Item {
            implicitWidth: __row.width
            implicitHeight: 250

            Row {
                id: __row
                height: parent.height - 30

                TimeListView {
                    id: __hourListView
                    model: 24
                    visible: control.format == DelTimePicker.Format_HHMMSS ||
                             control.format == DelTimePicker.Format_HHMM

                    DelDivider {
                        width: 1
                        height: parent.height
                        anchors.right: parent.right
                        orientation: Qt.Vertical
                    }
                }

                TimeListView {
                    id: __minuteListView
                    model: 60
                    visible: control.format == DelTimePicker.Format_HHMMSS ||
                             control.format == DelTimePicker.Format_HHMM ||
                             control.format == DelTimePicker.Format_MMSS

                    DelDivider {
                        width: 1
                        height: parent.height
                        anchors.right: parent.right
                        orientation: Qt.Vertical
                        visible: control.format == DelTimePicker.Format_HHMMSS ||
                                 control.format == DelTimePicker.Format_MMSS
                    }
                }

                TimeListView {
                    id: __secondListView
                    model: 60
                    visible: control.format == DelTimePicker.Format_HHMMSS ||
                             control.format == DelTimePicker.Format_MMSS
                }
            }

            Item {
                width: parent.width
                anchors.top: __row.bottom
                anchors.bottom: parent.bottom

                DelDivider {
                    width: parent.width
                    height: 1
                }

                DelButton {
                    padding: 2
                    topPadding: 2
                    bottomPadding: 2
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.bottom: parent.bottom
                    type: DelButton.Type_Text
                    text: qsTr("此刻")
                    colorBg: "transparent"
                    onClicked: {
                        const now = new Date();
                        __hourListView.initValue(String(now.getHours()).padStart(2, '0'));
                        __hourListView.checkIndex(now.getHours());
                        __minuteListView.initValue(String(now.getMinutes()).padStart(2, '0'));
                        __minuteListView.checkIndex(now.getMinutes());
                        __secondListView.initValue(String(now.getSeconds()).padStart(2, '0'));
                        __secondListView.checkIndex(now.getSeconds());

                        __private.cleared = false;
                        __picker.close();

                        control.acceptedTime(__private.getTime());
                        control.text = __private.getTime();
                    }
                }

                DelButton {
                    id: __confirmButton
                    topPadding: 2
                    bottomPadding: 2
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.bottom: parent.bottom
                    type: DelButton.Type_Primary
                    text: qsTr("确定")
                    onClicked: {
                        __hourListView.initValue(__hourListView.tempValue);
                        __minuteListView.initValue(__minuteListView.tempValue);
                        __secondListView.initValue(__secondListView.tempValue);
                        __private.cleared = false;
                        __picker.close();

                        control.acceptedTime(__private.getTime());
                        control.text = __private.getTime();
                    }
                }
            }
        }
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: true
    Accessible.description: control.contentDescription
}

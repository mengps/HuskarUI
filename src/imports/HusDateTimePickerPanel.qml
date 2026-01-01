/*
 * HuskarUI
 *
 * Copyright (C) mengps (MenPenS) (MIT License)
 * https://github.com/mengps/HuskarUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * - The above copyright notice and this permission notice shall be included in
 *   all copies or substantial portions of the Software.
 * - The Software is provided "as is", without warranty of any kind, express or
 *   implied, including but not limited to the warranties of merchantability,
 *   fitness for a particular purpose and noninfringement. In no event shall the
 *   authors or copyright holders be liable for any claim, damages or other
 *   liability, whether in an action of contract, tort or otherwise, arising from,
 *   out of or in connection with the Software or the use or other dealings in the
 *   Software.
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as T
import HuskarUI.Basic

T.Control {
    id: control

    signal selected(date: var)

    property bool animationEnabled: HusTheme.animationEnabled
    property string text: ''
    property string visualText: ''
    property bool showNow: false
    property bool showDate: true
    property bool showTime: true
    property int datePickerMode: HusDateTimePicker.Mode_Day
    property int timePickerMode: HusDateTimePicker.Mode_HHMMSS
    property string format: 'yyyy-MM-dd hh:mm:ss'

    property var prevIconSource: HusIcon.LeftOutlined ?? ''
    property var nextIconSource: HusIcon.RightOutlined ?? ''
    property var superPrevIconSource: HusIcon.DoubleLeftOutlined ?? ''
    property var superNextIconSource: HusIcon.DoubleRightOutlined ?? ''

    property real yearRowSpacing: 10 * control.sizeRatio
    property real yearColumnSpacing: 15 * control.sizeRatio
    property real monthRowSpacing: 10 * control.sizeRatio
    property real monthColumnSpacing: 15 * control.sizeRatio
    property real quarterSpacing: 10 * control.sizeRatio

    property var initDateTime: undefined

    property var currentDateTime: new Date()
    property int currentYear: new Date().getFullYear()
    property int currentMonth: new Date().getMonth()
    property int currentDay: new Date().getDate()
    property int currentWeekNumber: HusApi.getWeekNumber(new Date())
    property int currentQuarter: Math.floor(currentMonth / 3) + 1
    property int currentHours: 0
    property int currentMinutes: 0
    property int currentSeconds: 0

    property int visualYear: currentYear
    property int visualMonth: currentMonth
    property int visualDay: currentDay
    property int visualWeekNumber: currentWeekNumber
    property int visualQuarter: currentQuarter
    property int visualHours: currentHours
    property int visualMinutes: currentMinutes
    property int visualSeconds: currentSeconds

    property color colorBg: themeSource.colorBg
    property color colorBorder: themeSource.colorBorder
    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property HusRadius radiusItemBg: HusRadius { all: themeSource.radiusItemBg }
    property string sizeHint: 'normal'
    property real sizeRatio: HusTheme.sizeHint[sizeHint]
    property var themeSource: HusTheme.HusDateTimePicker

    property Component dayDelegate: HusButton {
        padding: 0
        implicitWidth: 28 * control.sizeRatio
        implicitHeight: 28 * control.sizeRatio
        animationEnabled: control.animationEnabled
        sizeRatio: control.sizeRatio
        type: HusButton.Type_Primary
        text: model.day
        font: control.font
        radiusBg: control.radiusItemBg
        effectEnabled: false
        colorBorder: model.today ? control.themeSource.colorDayBorderToday : 'transparent'
        colorText: {
            if (control.datePickerMode == HusDateTimePicker.Mode_Week) {
                return isCurrentWeek || isHoveredWeek ? 'white' : isVisualMonth ? control.themeSource.colorDayText :
                                                                                         control.themeSource.colorDayTextNone;
            } else {
                return isVisualDay ? 'white' : isVisualMonth ? control.themeSource.colorDayText :
                                                                       control.themeSource.colorDayTextNone;
            }
        }
        colorBg: {
            if (control.datePickerMode == HusDateTimePicker.Mode_Week) {
                return 'transparent';
            } else {
                return isVisualDay ? control.themeSource.colorDayBgCurrent :
                                      isHovered ? control.themeSource.colorDayBgHover :
                                                  control.themeSource.colorDayBg;
            }
        }
    }

    function clearDateTime() {
        if (initDateTime) {
            setDateTime(initDateTime);
        } else {
            const now = new Date();
            currentYear = now.getFullYear();
            currentMonth = now.getMonth();
            currentDay = now.getDate();
            currentWeekNumber = HusApi.getWeekNumber(now);
            currentQuarter = Math.floor(currentMonth / 3) + 1;
            currentHours = 0;
            currentMinutes = 0;
            currentSeconds = 0;
        }
        __hourListView.clearCheck();
        __minuteListView.clearCheck();
        __secondListView.clearCheck();
    }

    function setDateTime(date: var) {
        __private.selectDateTime(date);
    }

    function getDateTime(): var {
        return __private.getDateTime();
    }

    function setDateTimeString(dateTimeString: string) {
        __private.setDateTimeString(dateTimeString);
    }

    function getDateTimeString(): string {
        return __private.getDateTimeString();
    }

    function selectNow() {
        const now = new Date();
        __private.selectDateTime(now);
        __private.initCheckTime(now);
    }

    function resetVisualStatus() {
        const date = __private.getDateTime();
        __private.selectVisualDateTime(date);
        __private.initCheckTime(date);

        switch (datePickerMode) {
        case HusDateTimePicker.Mode_Day:
        case HusDateTimePicker.Mode_Week:
        {
            __pickerHeader.isPickYear = false;
            __pickerHeader.isPickMonth = false;
            __pickerHeader.isPickQuarter = false;
        } break;
        case HusDateTimePicker.Mode_Month:
        {
            __pickerHeader.isPickYear = false;
            __pickerHeader.isPickMonth = true;
            __pickerHeader.isPickQuarter = false;
        } break;
        case HusDateTimePicker.Mode_Quarter:
        {
            __pickerHeader.isPickYear = false;
            __pickerHeader.isPickMonth = false;
            __pickerHeader.isPickQuarter = true;
        } break;
        case HusDateTimePicker.Mode_Year:
        {
            __pickerHeader.isPickYear = true;
            __pickerHeader.isPickMonth = false;
            __pickerHeader.isPickQuarter = false;
        } break;
        default:
        {
            __pickerHeader.isPickYear = false;
            __pickerHeader.isPickMonth = false;
            __pickerHeader.isPickQuarter = false;
        }
        }
    }

    onInitDateTimeChanged: setDateTime(initDateTime);

    padding: 8 * control.sizeRatio
    leftPadding: (control.showDate ? 8 : 2) * control.sizeRatio
    rightPadding: (control.showDate ? (control.showTime ? 2 : 8) : 2) * control.sizeRatio
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
    }
    contentItem: ColumnLayout {
        spacing: 0

        RowLayout {
            spacing: 0

            ColumnLayout {
                visible: control.showDate
                spacing: 5 * control.sizeRatio

                PickerHeader {
                    id: __pickerHeader
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: control.themeSource.colorSplit
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignCenter
                    spacing: 0
                    visible: (control.datePickerMode == HusDateTimePicker.Mode_Day ||
                              control.datePickerMode == HusDateTimePicker.Mode_Week) &&
                             !__pickerHeader.isPickYear && !__pickerHeader.isPickMonth

                    T.DayOfWeekRow {
                        id: __dayOfWeekRow
                        locale: __monthGrid.locale
                        spacing: 10 * control.sizeRatio
                        delegate: HusText {
                            width: __dayOfWeekRow.itemWidth
                            text: shortName
                            font: control.font
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: control.themeSource.colorWeekText

                            required property string shortName
                        }
                        property real itemWidth: (__monthGrid.implicitWidth - 6 * spacing) / 7
                    }

                    T.MonthGrid {
                        id: __monthGrid
                        padding: 0
                        spacing: 0
                        year: control.visualYear
                        month: control.visualMonth
                        locale: control.locale
                        delegate: null
                        contentItem: GridLayout {
                            rows: 6
                            columns: 7
                            rowSpacing: 0
                            columnSpacing: 0

                            Repeater {
                                model: __monthGrid.source
                                delegate: Item {
                                    id: __dayItem
                                    implicitWidth: __dayBg.implicitWidth
                                    implicitHeight: __dayBg.implicitHeight + 6 * control.sizeRatio

                                    required property var model
                                    property int weekYear: (model.weekNumber === 1 && model.month === 11) ? (model.year + 1) : model.year
                                    property int currentYear: (control.currentWeekNumber === 1 && control.currentMonth === 11) ?
                                                                  (control.currentYear + 1) : control.currentYear
                                    property bool isCurrentWeek: control.currentWeekNumber === model.weekNumber && weekYear === __dayItem.currentYear
                                    property bool isHoveredWeek: __monthGrid.hovered && __private.hoveredWeekNumber === model.weekNumber
                                    property bool isCurrentMonth: control.currentYear === model.year && control.currentMonth === model.month
                                    property bool isVisualMonth: control.visualMonth === model.month
                                    property bool isCurrentDay: control.currentYear === model.year &&
                                                                control.currentMonth === model.month &&
                                                                control.currentDay === model.day
                                    property bool isVisualDay: control.visualYear === model.year &&
                                                               control.visualMonth === model.month &&
                                                               control.visualDay === model.day

                                    Rectangle {
                                        id: __dayBg
                                        implicitWidth: __dayLoader.implicitWidth + 16 * control.sizeRatio
                                        implicitHeight: __dayLoader.implicitHeight
                                        anchors.verticalCenter: parent.verticalCenter
                                        clip: true
                                        color: {
                                            if (control.datePickerMode == HusDateTimePicker.Mode_Week) {
                                                return __dayItem.isCurrentWeek ? control.themeSource.colorDayItemBgCurrent :
                                                                                 __dayItem.isHoveredWeek ? control.themeSource.colorDayItemBgHover :
                                                                                                           control.themeSource.colorDayItemBg;
                                            } else {
                                                return 'transparent';
                                            }
                                        }

                                        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

                                        Loader {
                                            id: __dayLoader
                                            anchors.centerIn: parent
                                            sourceComponent: control.dayDelegate
                                            property alias model: __dayItem.model
                                            property alias isHovered: __hoverHandler.hovered
                                            property alias isCurrentWeek: __dayItem.isCurrentWeek
                                            property alias isHoveredWeek: __dayItem.isHoveredWeek
                                            property alias isCurrentMonth: __dayItem.isCurrentMonth
                                            property alias isVisualMonth: __dayItem.isVisualMonth
                                            property alias isCurrentDay: __dayItem.isCurrentDay
                                            property alias isVisualDay: __dayItem.isVisualDay
                                        }

                                        HoverHandler {
                                            id: __hoverHandler
                                            cursorShape: Qt.PointingHandCursor
                                            onHoveredChanged: {
                                                if (hovered) {
                                                    __private.hoveredWeekNumber = __dayItem.model.weekNumber;
                                                    __private.hoveredDay = __dayItem.model.day;
                                                }
                                            }
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                if (control.showDate && control.showTime)
                                                    __private.selectVisualDateTime(model.date);
                                                else
                                                    __private.selectDateTime(model.date);
                                            }
                                            onDoubleClicked: __private.selectDateTime(model.date);
                                        }
                                    }
                                }
                            }
                        }

                        NumberAnimation on scale {
                            running: control.animationEnabled && __monthGrid.visible
                            from: 0
                            to: 1
                            easing.type: Easing.OutCubic
                            duration: HusTheme.Primary.durationMid
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: __yearPicker.implicitWidth
                    Layout.preferredHeight: __yearPicker.implicitHeight
                    Layout.alignment: Qt.AlignCenter
                    Layout.topMargin: 10 * control.sizeRatio
                    visible: __pickerHeader.isPickYear

                    Grid {
                        id: __yearPicker
                        anchors.centerIn: parent
                        rows: 4
                        columns: 3
                        rowSpacing: control.yearRowSpacing
                        columnSpacing: control.yearColumnSpacing

                        NumberAnimation on scale {
                            running: control.animationEnabled && __yearPicker.visible
                            from: 0
                            to: 1
                            easing.type: Easing.OutCubic
                            duration: HusTheme.Primary.durationMid
                        }

                        Repeater {
                            model: 12
                            delegate: Item {
                                width: 80 * control.sizeRatio
                                height: 40 * control.sizeRatio

                                PickerButton {
                                    id: __yearPickerButton
                                    anchors.centerIn: parent
                                    text: year
                                    checked: year == control.visualYear
                                    onClicked: {
                                        control.visualYear = year;
                                        if (control.datePickerMode == HusDateTimePicker.Mode_Day ||
                                                control.datePickerMode == HusDateTimePicker.Mode_Week ||
                                                control.datePickerMode == HusDateTimePicker.Mode_Month) {
                                            __pickerHeader.isPickYear = false;
                                            __pickerHeader.isPickMonth = true;
                                        } else if (control.datePickerMode == HusDateTimePicker.Mode_Quarter) {
                                            __pickerHeader.isPickYear = false;
                                            __pickerHeader.isPickQuarter = true;
                                        } else if (control.datePickerMode == HusDateTimePicker.Mode_Year) {
                                            if (control.showDate && control.showTime)
                                                __private.selectVisualDateTime(new Date(control.visualYear + 1, 0, 0));
                                            else
                                                __private.selectDateTime(new Date(control.visualYear + 1, 0, 0));
                                        }
                                    }
                                    property int year: control.visualYear + modelData - 4
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: __monthPicker.implicitWidth
                    Layout.preferredHeight: __monthPicker.implicitHeight
                    Layout.alignment: Qt.AlignCenter
                    Layout.topMargin: 10 * control.sizeRatio
                    visible: __pickerHeader.isPickMonth

                    Grid {
                        id: __monthPicker
                        anchors.centerIn: parent
                        rows: 4
                        columns: 3
                        rowSpacing: control.monthRowSpacing
                        columnSpacing: control.monthColumnSpacing

                        NumberAnimation on scale {
                            running: control.animationEnabled && __monthPicker.visible
                            from: 0
                            to: 1
                            easing.type: Easing.OutCubic
                            duration: HusTheme.Primary.durationMid
                        }

                        Repeater {
                            model: 12
                            delegate: Item {
                                width: 80 * control.sizeRatio
                                height: 40 * control.sizeRatio

                                PickerButton {
                                    id: __monthPickerButton
                                    anchors.centerIn: parent
                                    text: (month + 1) + qsTr('月')
                                    checked: month == control.visualMonth
                                    onClicked: {
                                        control.visualMonth = month;
                                        if (control.datePickerMode == HusDateTimePicker.Mode_Day ||
                                                control.datePickerMode == HusDateTimePicker.Mode_Week) {
                                            __pickerHeader.isPickMonth = false;
                                        } else if (control.datePickerMode == HusDateTimePicker.Mode_Month) {
                                            if (control.showDate && control.showTime)
                                                __private.selectVisualDateTime(new Date(control.visualYear, control.visualMonth + 1, 0));
                                            else
                                                __private.selectDateTime(new Date(control.visualYear, control.visualMonth + 1, 0),
                                                                         (control.showDate && control.showTime));
                                        }
                                    }
                                    property int month: modelData
                                }
                            }
                        }
                    }
                }

                Row {
                    id: __quarterPicker
                    Layout.alignment: Qt.AlignHCenter
                    visible: __pickerHeader.isPickQuarter
                    spacing: control.quarterSpacing

                    NumberAnimation on scale {
                        running: control.animationEnabled && __quarterPicker.visible
                        from: 0
                        to: 1
                        easing.type: Easing.OutCubic
                        duration: HusTheme.Primary.durationMid
                    }

                    Repeater {
                        model: 4
                        delegate: Item {
                            width: 60 * control.sizeRatio
                            height: 40 * control.sizeRatio

                            PickerButton {
                                anchors.centerIn: parent
                                text: `Q${quarter}`
                                checked: quarter == control.visualQuarter
                                onClicked: {
                                    control.visualQuarter = quarter;
                                    __pickerHeader.isPickYear = false;

                                    if (control.datePickerMode == HusDateTimePicker.Mode_Quarter) {
                                        __private.selectDateTime(new Date(control.visualYear, (quarter - 1) * 3 + 1, 0),
                                                                 (control.showDate && control.showTime));
                                    }
                                }
                                property int quarter: modelData + 1
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    visible: control.showNow && control.datePickerMode == HusDateTimePicker.Mode_Day && !control.showTime
                    color: control.themeSource.colorSplit
                }

                Loader {
                    Layout.alignment: Qt.AlignHCenter
                    active: control.showNow && control.datePickerMode == HusDateTimePicker.Mode_Day && !control.showTime
                    visible: active
                    sourceComponent: HusButton {
                        animationEnabled: control.animationEnabled
                        sizeRatio: control.sizeRatio
                        type: HusButton.Type_Link
                        text: qsTr('今天')
                        onClicked: __private.selectDateTime(new Date());
                    }
                }
            }

            Loader {
                Layout.fillHeight: true
                active: control.showDate && control.showTime
                visible: active
                sourceComponent: Item {
                    width: 8 * control.sizeRatio

                    Rectangle {
                        width: 1
                        height: parent.height
                        anchors.right: parent.right
                        color: control.themeSource.colorSplit
                    }
                }
            }

            ColumnLayout {
                Layout.preferredHeight: Math.max(220 * control.sizeRatio, implicitHeight)
                visible: control.showTime

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: __timeLayout.implicitWidth
                    Layout.preferredHeight: 36 * control.sizeRatio
                    visible: control.showDate

                    HusText {
                        anchors.centerIn: parent
                        font {
                            family: control.themeSource.fontFamily
                            pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
                            bold: true
                        }
                        text: {
                            switch (control.timePickerMode) {
                            case HusDateTimePicker.Mode_HHMMSS:
                                return `${__hourListView.checkValue}:${__minuteListView.checkValue}:${__secondListView.checkValue}`;
                            case HusDateTimePicker.Mode_HHMM:
                                return `${__hourListView.checkValue}:${__minuteListView.checkValue}`;
                            case HusDateTimePicker.Mode_MMSS:
                                return `${__minuteListView.checkValue}:${__secondListView.checkValue}`;
                            }
                        }
                        color: control.themeSource.colorTimeHeaderText
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        anchors.bottom: parent.bottom
                        color: control.themeSource.colorSplit
                        visible: control.showDate && control.showTime
                    }
                }

                RowLayout {
                    id: __timeLayout
                    Layout.fillHeight: true
                    spacing: 0

                    TimeListView {
                        id: __hourListView
                        model: 24
                        visible: control.timePickerMode == HusDateTimePicker.Mode_HHMMSS ||
                                 control.timePickerMode == HusDateTimePicker.Mode_HHMM

                        Rectangle {
                            width: 1
                            height: parent.height
                            anchors.right: parent.right
                            color: control.themeSource.colorSplit
                        }
                    }

                    TimeListView {
                        id: __minuteListView
                        model: 60
                        visible: control.timePickerMode == HusDateTimePicker.Mode_HHMMSS ||
                                 control.timePickerMode == HusDateTimePicker.Mode_HHMM ||
                                 control.timePickerMode == HusDateTimePicker.Mode_MMSS

                        Rectangle {
                            width: 1
                            height: parent.height
                            anchors.right: parent.right
                            visible: control.timePickerMode == HusDateTimePicker.Mode_HHMMSS ||
                                     control.timePickerMode == HusDateTimePicker.Mode_MMSS
                            color: control.themeSource.colorSplit
                        }
                    }

                    TimeListView {
                        id: __secondListView
                        model: 60
                        visible: control.timePickerMode == HusDateTimePicker.Mode_HHMMSS ||
                                 control.timePickerMode == HusDateTimePicker.Mode_MMSS
                    }
                }
            }
        }

        Loader {
            Layout.fillWidth: true
            Layout.preferredHeight: 32 * control.sizeRatio
            active: control.showNow && control.showTime
            visible: active
            sourceComponent: Item {

                Rectangle {
                    width: parent.width
                    height: 1
                    color: control.themeSource.colorSplit
                }

                HusButton {
                    padding: 2 * control.sizeRatio
                    topPadding: 2 * control.sizeRatio
                    bottomPadding: 2 * control.sizeRatio
                    anchors.left: parent.left
                    anchors.leftMargin: 5 * control.sizeRatio
                    anchors.bottom: parent.bottom
                    animationEnabled: control.animationEnabled
                    sizeRatio: control.sizeRatio
                    type: HusButton.Type_Link
                    text: qsTr('此刻')
                    colorBg: 'transparent'
                    onClicked: control.selectNow();
                }

                HusButton {
                    id: __confirmButton
                    topPadding: 4 * control.sizeRatio
                    bottomPadding: 4 * control.sizeRatio
                    leftPadding: 10 * control.sizeRatio
                    rightPadding: 10 * control.sizeRatio
                    anchors.right: parent.right
                    anchors.rightMargin: 5 * control.sizeRatio
                    anchors.bottom: parent.bottom
                    animationEnabled: control.animationEnabled
                    sizeRatio: control.sizeRatio
                    type: HusButton.Type_Primary
                    text: qsTr('确定')
                    onClicked: {
                        __hourListView.initValue(__hourListView.checkValue);
                        __minuteListView.initValue(__minuteListView.checkValue);
                        __secondListView.initValue(__secondListView.checkValue);
                        __private.selectDateTime(__private.getVisualDateTime());
                    }
                }
            }
        }
    }
    background: HusRectangleInternal {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }

    component TimeListView: MouseArea {
        id: __rootItem

        property string value: '00'
        property string checkValue: '00'
        property string tempValue: '00'
        property alias model: __listView.model

        function clearCheck() {
            value = checkValue = tempValue = '00';
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

        Layout.preferredWidth: 52 * control.sizeRatio
        Layout.fillHeight: true
        hoverEnabled: true
        onExited: {
            tempValue = checkValue;
            __private.resetCheckTime();
        }

        ListView {
            id: __listView
            height: parent.height
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 2 * control.sizeRatio
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.AbstractButton {
                width: __listView.width
                height: 28 * control.sizeRatio
                checkable: true
                contentItem: HusText {
                    id: __viewText
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
                    }
                    text: String(index).padStart(2, '0')
                    color: control.themeSource.colorTimeText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Item {
                    HusRectangleInternal {
                        id: selectionRect
                        anchors.fill: parent
                        radius: control.radiusItemBg.all
                        topLeftRadius: control.radiusItemBg.topLeft
                        topRightRadius: control.radiusItemBg.topRight
                        bottomLeftRadius: control.radiusItemBg.bottomLeft
                        bottomRightRadius: control.radiusItemBg.bottomRight
                        color: control.themeSource.colorButtonBgActive
                        opacity: checked ? 1.0 : 0.0

                        Behavior on opacity {
                            enabled: control.animationEnabled && !checked
                            NumberAnimation { duration: HusTheme.Primary.durationFast }
                        }
                    }

                    HusRectangleInternal {
                        anchors.fill: parent
                        radius: control.radiusItemBg.all
                        topLeftRadius: control.radiusItemBg.topLeft
                        topRightRadius: control.radiusItemBg.topRight
                        bottomLeftRadius: control.radiusItemBg.bottomLeft
                        bottomRightRadius: control.radiusItemBg.bottomRight
                        color: hovered && !checked ? control.themeSource.colorButtonBgHover : 'transparent'
                        z: -1

                        Behavior on color {
                            enabled: control.animationEnabled
                            ColorAnimation { duration: HusTheme.Primary.durationFast }
                        }
                    }
                }
                T.ButtonGroup.group: __buttonGroup
                onHoveredChanged: {
                    if (hovered) {
                        __rootItem.tempValue = __viewText.text;
                        __private.resetTempTime();
                    }
                }
                onClicked: {
                    __rootItem.checkValue = __viewText.text;
                    __private.resetCheckTime();
                    __private.timeViewAtBeginning();
                }
                onDoubleClicked: {
                    __private.selectDateTime(__private.getVisualDateTime());
                }

                Component.onCompleted: checked = (index == 0);
            }
            onContentHeightChanged: cacheBuffer = contentHeight;
            T.ScrollBar.vertical: HusScrollBar {
                id: __scrollBar
                policy: T.ScrollBar.AsNeeded
                animationEnabled: control.animationEnabled
            }

            T.ButtonGroup {
                id: __buttonGroup
            }
        }
    }

    component PageButton: HusIconButton {
        leftPadding: 8 * control.sizeRatio
        rightPadding: 8 * control.sizeRatio
        animationEnabled: control.animationEnabled
        sizeRatio: control.sizeRatio
        type: HusButton.Type_Link
        font {
            family: control.themeSource.fontFamily
            pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
        }
        iconSize: 16 * control.sizeRatio
        colorIcon: hovered ? control.themeSource.colorPageIconHover : control.themeSource.colorPageIcon
    }

    component PickerHeader: RowLayout {
        id: __pickerHeaderComp

        property bool isPickYear: false
        property bool isPickMonth: false
        property bool isPickQuarter: control.datePickerMode == HusDateTimePicker.Mode_Quarter

        PageButton {
            Layout.alignment: Qt.AlignVCenter
            iconSource: control.superPrevIconSource
            onClicked: {
                const prevYear = control.visualYear - (__pickerHeaderComp.isPickYear ? 10 : 1);
                if (prevYear > -9999) {
                    control.visualYear = prevYear;
                }
            }
        }

        PageButton {
            Layout.alignment: Qt.AlignVCenter
            iconSource: control.prevIconSource
            visible: !__pickerHeaderComp.isPickMonth && !__pickerHeaderComp.isPickMonth
            onClicked: {
                if (__pickerHeaderComp.isPickYear) {
                    const prev1Year = control.visualYear - 1;
                    if (prev1Year >= -9999) {
                        control.visualYear = prev1Year;
                    }
                } else {
                    const prevMonth = control.visualMonth - 1;
                    if (prevMonth < 0) {
                        const prevYear = control.visualYear - 1;
                        if (prevYear >= -9999) {
                            control.visualYear = prevYear;
                            control.visualMonth = 11;
                        }
                    } else {
                        control.visualMonth = prevMonth;
                    }
                }
            }
        }

        Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.preferredHeight: __centerRow.height

            Row {
                id: __centerRow
                anchors.horizontalCenter: parent.horizontalCenter

                PageButton {
                    text: control.visualYear + qsTr('年')
                    colorText: hovered ? control.themeSource.colorPageTextHover : control.themeSource.colorPageText
                    font.bold: true
                    onClicked: {
                        __pickerHeaderComp.isPickYear = true;
                        __pickerHeaderComp.isPickMonth = false;
                        __pickerHeaderComp.isPickQuarter = false;
                    }
                }

                PageButton {
                    visible: control.datePickerMode != HusDateTimePicker.Mode_Year &&
                             control.datePickerMode != HusDateTimePicker.Mode_Quarter &&
                             !__pickerHeaderComp.isPickQuarter &&
                             !__pickerHeaderComp.isPickYear
                    text: (control.visualMonth + 1) + qsTr('月')
                    colorText: hovered ? control.themeSource.colorPageTextHover : control.themeSource.colorPageText
                    font.bold: true
                    onClicked: {
                        __pickerHeaderComp.isPickYear = false;
                        __pickerHeaderComp.isPickMonth = true;
                    }
                }
            }
        }

        PageButton {
            Layout.alignment: Qt.AlignVCenter
            iconSource: control.nextIconSource
            visible: !__pickerHeaderComp.isPickMonth && !__pickerHeaderComp.isPickMonth
            onClicked: {
                if (__pickerHeaderComp.isPickYear) {
                    const next1Year = control.visualYear + 1;
                    if (next1Year < 9999) {
                        control.visualYear = next1Year;
                    }
                } else {
                    const nextMonth = control.visualMonth + 1;
                    if (nextMonth >= 11) {
                        const nextYear = control.visualYear + 1;
                        if (nextYear <= 9999) {
                            control.visualYear = nextYear;
                            control.visualMonth = 0;
                        }
                    } else {
                        control.visualMonth = nextMonth;
                    }
                }
            }
        }

        PageButton {
            Layout.alignment: Qt.AlignVCenter
            iconSource: control.superNextIconSource
            onClicked: {
                const nextYear = control.visualYear + (__pickerHeaderComp.isPickYear ? 10 : 1);
                if (nextYear < 9999) {
                    control.visualYear = nextYear;
                }
            }
        }
    }

    component PickerButton: HusButton {
        padding: 20 * control.sizeRatio
        topPadding: 6 * control.sizeRatio
        bottomPadding: 6 * control.sizeRatio
        animationEnabled: control.animationEnabled
        sizeRatio: control.sizeRatio
        effectEnabled: false
        colorBorder: 'transparent'
        colorBg: checked ? control.themeSource.colorDayBgCurrent :
                           hovered ? control.themeSource.colorDayBgHover :
                                     control.themeSource.colorDayBg
        colorText: checked ? 'white' : control.themeSource.colorDayText
        font {
            family: control.themeSource.fontFamily
            pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
        }
        radiusBg: control.radiusItemBg
    }

    Item {
        id: __private

        property int hoveredWeekNumber: control.currentWeekNumber
        property int hoveredDay: control.currentDay

        function selectDateTime(date: var) {
            if (isValidDate(date)) {
                const month = date.getMonth();
                const weekNumber = HusApi.getWeekNumber(date);
                const quarter = Math.floor(month / 3) + 1;
                if (control.datePickerMode == HusDateTimePicker.Mode_Week) {
                    let inputDate = date;
                    let weekYear = date.getFullYear();
                    if (weekNumber === 1 && month === 11) {
                        weekYear++;
                        inputDate = new Date(weekYear + 1, 0, 0, date.getHours(), date.getMinutes(), date.getSeconds());
                    }
                    control.text = Qt.formatDateTime(inputDate, control.format.replace('w', String(weekNumber)));
                } else if (control.datePickerMode == HusDateTimePicker.Mode_Quarter) {
                    control.text = Qt.formatDateTime(date, control.format.replace('q', String(quarter)));
                } else {
                    control.text = Qt.formatDateTime(date, control.format);
                }
                control.visualText = control.text;

                control.currentDateTime = date;
                control.visualYear = control.currentYear = date.getFullYear();
                control.visualMonth =control.currentMonth = month;
                control.visualDay = control.currentDay = date.getDate();
                control.visualWeekNumber = control.currentWeekNumber = weekNumber;
                control.visualQuarter = control.currentQuarter = quarter;

                control.visualHours = control.currentHours = date.getHours();
                control.visualMinutes = control.currentMinutes = date.getMinutes();
                control.visualSeconds = control.currentSeconds = date.getSeconds();

                control.selected(date);
            }
        }

        function selectVisualDateTime(date: var) {
            if (isValidDate(date)) {
                const month = date.getMonth();
                const weekNumber = HusApi.getWeekNumber(date);
                const quarter = Math.floor(month / 3) + 1;
                if (control.datePickerMode == HusDateTimePicker.Mode_Week) {
                    let inputDate = date;
                    let weekYear = date.getFullYear();
                    if (weekNumber === 1 && month === 11) {
                        weekYear++;
                        inputDate = new Date(weekYear + 1, 0, 0, date.getHours(), date.getMinutes(), date.getSeconds());
                    }
                    control.visualText = Qt.formatDateTime(inputDate, control.format.replace('w', String(weekNumber)));
                } else if (control.datePickerMode == HusDateTimePicker.Mode_Quarter) {
                    control.visualText = Qt.formatDateTime(date, control.format.replace('q', String(quarter)));
                } else {
                    control.visualText = Qt.formatDateTime(date, control.format);
                }

                control.visualYear = date.getFullYear();
                control.visualMonth = month;
                control.visualDay = date.getDate();
                control.visualWeekNumber = weekNumber;
                control.visualQuarter = quarter;

                control.visualHours = date.getHours();
                control.visualMinutes = date.getMinutes();
                control.visualSeconds = date.getSeconds();
            }
        }

        function getDateTime(): var {
            return new Date(control.currentYear,
                            control.currentMonth,
                            control.currentDay,
                            control.currentHours,
                            control.currentMinutes,
                            control.currentSeconds);
        }

        function getVisualDateTime(): var {
            return new Date(control.visualYear,
                            control.visualMonth,
                            control.visualDay,
                            control.visualHours,
                            control.visualMinutes,
                            control.visualSeconds);
        }

        function setDateTimeString(dateTimeString: string) {
            selectDateTime(HusApi.dateFromString(dateTimeString, control.format));
        }

        function getDateTimeString(): string {
            const text = '';
            const date = getDateTime();
            const month = date.getMonth();
            const weekNumber = HusApi.getWeekNumber(date);
            const quarter = Math.floor(month / 3) + 1;
            if (control.datePickerMode == HusDateTimePicker.Mode_Week) {
                let inputDate = date;
                let weekYear = date.getFullYear();
                if (weekNumber === 1 && month === 11) {
                    weekYear++;
                    inputDate = new Date(weekYear + 1, 0, 0, date.getHours(), date.getMinutes(), date.getSeconds());
                }
                text = Qt.formatDateTime(inputDate, control.format.replace('w', String(weekNumber)));
            } else if (control.datePickerMode == HusDateTimePicker.Mode_Quarter) {
                text = Qt.formatDateTime(date, control.format.replace('q', String(quarter)));
            } else {
                text = Qt.formatDateTime(date, control.format);
            }

            return text;
        }

        function initCheckTime(date: var) {
            __hourListView.initValue(String(date.getHours()).padStart(2, '0'));
            __hourListView.checkIndex(date.getHours());
            __minuteListView.initValue(String(date.getMinutes()).padStart(2, '0'));
            __minuteListView.checkIndex(date.getMinutes());
            __secondListView.initValue(String(date.getSeconds()).padStart(2, '0'));
            __secondListView.checkIndex(date.getSeconds());
            __private.timeViewAtBeginning();
        }

        function resetCheckTime() {
            control.visualHours = parseInt(__hourListView.checkValue);
            control.visualMinutes = parseInt(__minuteListView.checkValue);
            control.visualSeconds = parseInt(__secondListView.checkValue);
            selectVisualDateTime(getVisualDateTime());
        }

        function resetTempTime() {
            control.visualHours = parseInt(__hourListView.tempValue);
            control.visualMinutes = parseInt(__minuteListView.tempValue);
            control.visualSeconds = parseInt(__secondListView.tempValue);
            selectVisualDateTime(getVisualDateTime());
        }

        function timeViewAtBeginning() {
            __hourListView.positionViewAtIndex(control.visualHours, ListView.Beginning);
            __minuteListView.positionViewAtIndex(control.visualMinutes, ListView.Beginning);
            __secondListView.positionViewAtIndex(control.visualSeconds, ListView.Beginning);
        }

        function isValidDate(date) {
            return date && !isNaN(date.getTime());
        }
    }
}

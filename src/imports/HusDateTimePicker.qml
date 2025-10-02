import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as T
import HuskarUI.Basic

HusInput {
    id: control

    enum DatePickerMode {
        Mode_Year = 0,
        Mode_Quarter = 1,
        Mode_Month = 2,
        Mode_Week = 3,
        Mode_Day = 4
    }

    enum TimePickerMode {
        Mode_HHMMSS = 0,
        Mode_HHMM = 1,
        Mode_MMSS = 2
    }

    signal selected(date: var)

    property bool showDate: true
    property bool showTime: true
    property int datePickerMode: HusDateTimePicker.Mode_Day
    property int timePickerMode: HusDateTimePicker.Mode_HHMMSS

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

    property int visualYear: control.currentYear
    property int visualMonth: control.currentMonth
    property int visualDay: control.currentDay
    property int visualQuarter: control.currentQuarter

    property string format: 'yyyy-MM-dd hh:mm:ss'

    property int radiusItemBg: control.themeSource.radiusItemBg
    property int radiusPopupBg: control.themeSource.radiusPopupBg

    property Component dayDelegate: HusButton {
        padding: 0
        implicitWidth: 28
        implicitHeight: 28
        animationEnabled: control.animationEnabled
        type: HusButton.Type_Primary
        text: model.day
        font {
            family: control.themeSource.fontFamily
            pixelSize: control.themeSource.fontSize
        }
        radiusBg: control.radiusItemBg
        effectEnabled: false
        colorBorder: model.today ? control.themeSource.colorDayBorderToday : 'transparent'
        colorText: {
            if (control.datePickerMode === HusDateTimePicker.Mode_Week) {
                return isCurrentWeek || isHoveredWeek ? 'white' : isCurrentVisualMonth ? control.themeSource.colorDayText :
                                                                                         control.themeSource.colorDayTextNone;
            } else {
                return isCurrentDay ? 'white' : isCurrentVisualMonth ? control.themeSource.colorDayText :
                                                                       control.themeSource.colorDayTextNone;
            }
        }
        colorBg: {
            if (control.datePickerMode === HusDateTimePicker.Mode_Week) {
                return 'transparent';
            } else {
                return isCurrentDay ? control.themeSource.colorDayBgCurrent :
                                      isHovered ? control.themeSource.colorDayBgHover :
                                                  control.themeSource.colorDayBg;
            }
        }
    }

    function setDateTime(date: var) {
        if (date)
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

    function openPicker() {
        if (!__picker.opened)
            __picker.open();
    }

    function closePicker() {
        __picker.close();
    }

    objectName: '__HusDateTimePicker__'
    width: showDate && showTime ? 210 : 160
    themeSource: HusTheme.HusDateTimePicker
    iconSource: (__private.interactive && control.hovered && control.length !== 0) ?
                    HusIcon.CloseCircleFilled : control.showDate ? HusIcon.CalendarOutlined :
                                                                   HusIcon.ClockCircleOutlined
    iconPosition: HusInput.Position_Right
    iconDelegate: HusIconText {
        anchors.left: control.iconPosition === HusDateTimePicker.Position_Left ? parent.left : undefined
        anchors.right: control.iconPosition === HusDateTimePicker.Position_Right ? parent.right : undefined
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.enabled ?
                       __iconMouse.hovered ? control.themeSource.colorIconHover :
                                             control.themeSource.colorIcon : control.themeSource.colorIconDisabled

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

        MouseArea {
            id: __iconMouse
            anchors.fill: parent
            enabled: __private.interactive
            hoverEnabled: true
            cursorShape: parent.iconSource === HusIcon.CloseCircleFilled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: hovered = true;
            onExited: hovered = false;
            onClicked: {
                if (control.showTime) {
                    control.currentHours = 0;
                    control.currentMinutes = 0;
                    control.currentSeconds = 0;
                    __hourListView.clearCheck();
                    __minuteListView.clearCheck();
                    __secondListView.clearCheck();
                    __private.cleared = true;
                }
                if (control.length === 0) {
                    control.openPicker();
                } else {
                    if (control.initDateTime) {
                        __private.selectDateTime(control.initDateTime);
                        control.clear();
                    } else {
                        __private.selectDateTime(__private.getDateTime());
                        control.clear();
                    }
                }
            }
            property bool hovered: false
        }
    }
    onInitDateTimeChanged: setDateTime(initDateTime);
    onTextEdited: {
        control.openPicker();
        __private.commit();
    }
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            __private.commit();
            control.closePicker();
        }
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

        width: 52
        height: parent.height
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
            anchors.margins: 2
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.AbstractButton {
                width: __listView.width
                height: 28
                checkable: true
                contentItem: HusText {
                    id: __viewText
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: control.themeSource.fontSize
                    }
                    text: String(index).padStart(2, '0')
                    color: control.themeSource.colorTimeText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Item {
                    Rectangle {
                        id: selectionRect
                        anchors.fill: parent
                        radius: control.radiusItemBg
                        color: control.themeSource.colorButtonBgActive
                        opacity: checked ? 1.0 : 0.0

                        Behavior on opacity {
                            enabled: control.animationEnabled && !checked
                            NumberAnimation { duration: HusTheme.Primary.durationFast }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: control.radiusItemBg
                        color: hovered && !checked ? control.themeSource.colorButtonBgHover : 'transparent'
                        z: -1

                        Behavior on color {
                            enabled: control.animationEnabled
                            ColorAnimation { duration: HusTheme.Primary.durationFast }
                        }
                    }
                }
                T.ButtonGroup.group: __buttonGroup
                onClicked: {
                    __rootItem.checkValue = __viewText.text;
                    __private.resetCheckTime();
                    __private.timeViewAtBeginning();
                }
                onHoveredChanged: {
                    if (hovered) {
                        __rootItem.tempValue = __viewText.text;
                        __private.resetTempTime();
                    }
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
        leftPadding: 8
        rightPadding: 8
        animationEnabled: control.animationEnabled
        type: HusButton.Type_Link
        font {
            family: control.themeSource.fontFamily
            pixelSize: control.themeSource.fontSize
        }
        iconSize: 16
        colorIcon: hovered ? control.themeSource.colorPageIconHover : control.themeSource.colorPageIcon
    }

    component PickerHeader: RowLayout {
        id: __pickerHeaderComp

        property bool isPickYear: false
        property bool isPickMonth: false
        property bool isPickQuarter: control.datePickerMode == HusDateTimePicker.Mode_Quarter

        PageButton {
            Layout.alignment: Qt.AlignVCenter
            iconSource: HusIcon.DoubleLeftOutlined
            onClicked: {
                const prevYear = control.visualYear - (__pickerHeaderComp.isPickYear ? 10 : 1);
                if (prevYear > -9999) {
                    control.visualYear = prevYear;
                }
            }
        }

        PageButton {
            Layout.alignment: Qt.AlignVCenter
            iconSource: HusIcon.LeftOutlined
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
            iconSource: HusIcon.RightOutlined
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
            iconSource: HusIcon.DoubleRightOutlined
            onClicked: {
                const nextYear = control.visualYear + (__pickerHeaderComp.isPickYear ? 10 : 1);
                if (nextYear < 9999) {
                    control.visualYear = nextYear;
                }
            }
        }
    }

    component PickerButton: HusButton {
        padding: 20
        topPadding: 4
        bottomPadding: 4
        animationEnabled: control.animationEnabled
        effectEnabled: false
        colorBorder: 'transparent'
        colorBg: checked ? control.themeSource.colorDayBgCurrent :
                           hovered ? control.themeSource.colorDayBgHover :
                                     control.themeSource.colorDayBg
        colorText: checked ? 'white' : control.themeSource.colorDayText
        font {
            family: control.themeSource.fontFamily
            pixelSize: control.themeSource.fontSize
        }
        radiusBg: control.radiusItemBg
    }

    Item {
        id: __private

        property var window: Window.window
        property int hoveredWeekNumber: control.currentWeekNumber
        property int hoveredDay: control.currentDay
        property bool cleared: true
        property bool interactive: control.enabled && !control.readOnly

        function selectDateTime(date, close = true) {
            if (isValidDate(date)) {
                cleared = false;

                const month = date.getMonth();
                const weekNumber = HusApi.getWeekNumber(date);
                const quarter = Math.floor(month / 3) + 1;
                if (control.datePickerMode === HusDateTimePicker.Mode_Week) {
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

                control.currentDateTime = date;
                control.currentYear = date.getFullYear();
                control.currentMonth = month;
                control.currentDay = date.getDate();
                control.currentWeekNumber = weekNumber;
                control.currentHours = date.getHours();
                control.currentMinutes = date.getMinutes();
                control.currentSeconds = date.getSeconds();

                control.selected(date);

                if (close)
                    control.closePicker();
            }
        }

        function getDateTime() {
            return new Date(control.currentYear,
                            control.currentMonth,
                            control.currentDay,
                            control.currentHours,
                            control.currentMinutes,
                            control.currentSeconds);
        }

        function setDateTimeString(dateTimeString) {
            selectDateTime(HusApi.dateFromString(dateTimeString, control.format));
        }

        function getDateTimeString() {
            const text = '';
            const date = getDateTime();
            const month = date.getMonth();
            const weekNumber = HusApi.getWeekNumber(date);
            const quarter = Math.floor(month / 3) + 1;
            if (control.datePickerMode === HusDateTimePicker.Mode_Week) {
                let inputDate = date;
                let weekYear = date.getFullYear();
                if (weekNumber === 1 && month === 11) {
                    weekYear++;
                    inputDate = new Date(weekYear + 1, 0, 0);
                }
                text = Qt.formatDateTime(inputDate, control.format.replace('w', String(weekNumber)));
            } else if (control.datePickerMode == HusDateTimePicker.Mode_Quarter) {
                text = Qt.formatDateTime(date, control.format.replace('q', String(quarter)));
            } else {
                text = Qt.formatDateTime(date, control.format);
            }

            return text;
        }

        function resetCheckTime() {
            control.currentHours = parseInt(__hourListView.checkValue);
            control.currentMinutes = parseInt(__minuteListView.checkValue);
            control.currentSeconds = parseInt(__secondListView.checkValue);
            selectDateTime(getDateTime(), false);
        }

        function resetTempTime() {
            control.currentHours = parseInt(__hourListView.tempValue);
            control.currentMinutes = parseInt(__minuteListView.tempValue);
            control.currentSeconds = parseInt(__secondListView.tempValue);
            selectDateTime(getDateTime(), false);
        }

        function timeViewAtBeginning() {
            __hourListView.positionViewAtIndex(control.currentHours, ListView.Beginning);
            __minuteListView.positionViewAtIndex(control.currentMinutes, ListView.Beginning);
            __secondListView.positionViewAtIndex(control.currentSeconds, ListView.Beginning);
        }

        function isValidDate(date) {
            return date && !isNaN(date.getTime());
        }

        function commit() {
            const date = HusApi.dateFromString(control.text, control.format);
            if (isValidDate(date)) {
                __hourListView.checkIndex(date.getHours());
                __minuteListView.checkIndex(date.getMinutes());
                __secondListView.checkIndex(date.getSeconds());
                selectDateTime(date, false);
                timeViewAtBeginning();
            }
        }
    }

    TapHandler {
        enabled: __private.interactive
        onTapped: {
            control.openPicker();
        }
    }

    HusPopup {
        id: __picker
        x: (control.width - implicitWidth) * 0.5
        y: control.height + 6
        implicitWidth: implicitContentWidth + leftPadding + rightPadding
        implicitHeight: implicitContentHeight + topPadding + bottomPadding
        padding: 8
        leftPadding: control.showDate ? 8 : 2
        rightPadding: control.showDate ? (control.showTime ? 2 : 8) : 2
        colorBg: HusTheme.isDark ? control.themeSource.colorPopupBgDark : control.themeSource.colorPopupBg
        radiusBg: control.radiusPopupBg
        animationEnabled: control.animationEnabled
        closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        enter: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 0.0
                to: 1.0
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0.0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
        onAboutToShow: {
            control.visualYear = control.currentYear;
            control.visualMonth = control.currentMonth;
            control.visualDay = control.currentDay;
            control.visualQuarter = control.currentQuarter;

            switch (control.datePickerMode) {
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

            if (control.showTime) {
                __private.timeViewAtBeginning();
            }
        }
        contentItem: Item {
            implicitWidth: __pickerColumn.implicitWidth
            implicitHeight: __pickerColumn.implicitHeight

            Column {
                id: __pickerColumn

                Row {

                    Column {
                        visible: control.showDate
                        spacing: 5

                        PickerHeader {
                            id: __pickerHeader
                            width: parent.width
                        }

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: control.themeSource.colorSplitLine
                        }

                        T.DayOfWeekRow {
                            id: __dayOfWeekRow
                            visible: (control.datePickerMode == HusDateTimePicker.Mode_Day || control.datePickerMode == HusDateTimePicker.Mode_Week) &&
                                     !__pickerHeader.isPickYear && !__pickerHeader.isPickMonth
                            locale: __monthGrid.locale
                            spacing: 10
                            delegate: HusText {
                                width: __dayOfWeekRow.itemWidth
                                text: shortName
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    family: control.themeSource.fontFamily
                                    pixelSize: control.themeSource.fontSize
                                }
                                color: control.themeSource.colorWeekText

                                required property string shortName
                            }
                            property real itemWidth: (__monthGrid.implicitWidth - 6 * spacing) / 7
                        }

                        T.MonthGrid {
                            id: __monthGrid
                            visible: __dayOfWeekRow.visible
                            padding: 0
                            spacing: 0
                            year: control.visualYear
                            month: control.visualMonth
                            locale: Qt.locale()
                            delegate: Item {
                                id: __dayItem
                                width: __dayLoader.implicitWidth + 16
                                height: __dayLoader.implicitHeight + 6

                                required property var model
                                property int weekYear: (model.weekNumber === 1 && model.month === 11) ? (model.year + 1) : model.year
                                property int currentYear: (control.currentWeekNumber === 1 && control.currentMonth === 11) ? (control.currentYear + 1) :
                                                                                                                             control.currentYear
                                property bool isCurrentWeek: control.currentWeekNumber === model.weekNumber && weekYear === __dayItem.currentYear
                                property bool isHoveredWeek: __monthGrid.hovered && __private.hoveredWeekNumber === model.weekNumber
                                property bool isCurrentMonth: control.currentYear === model.year && control.currentMonth === model.month
                                property bool isCurrentVisualMonth: control.visualMonth === model.month
                                property bool isCurrentDay: control.currentYear === model.year &&
                                                            control.currentMonth === model.month &&
                                                            control.currentDay === model.day

                                Rectangle {
                                    width: parent.width
                                    height: __dayLoader.implicitHeight
                                    anchors.verticalCenter: parent.verticalCenter
                                    clip: true
                                    color: {
                                        if (control.datePickerMode === HusDateTimePicker.Mode_Week) {
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
                                        property alias isCurrentVisualMonth: __dayItem.isCurrentVisualMonth
                                        property alias isCurrentDay: __dayItem.isCurrentDay
                                    }

                                    HoverHandler {
                                        id: __hoverHandler
                                        onHoveredChanged: {
                                            if (hovered) {
                                                __private.hoveredWeekNumber = __dayItem.model.weekNumber;
                                                __private.hoveredDay = __dayItem.model.day;
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: __private.selectDateTime(model.date, !(control.showDate && control.showTime));
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

                        Grid {
                            id: __yearPicker
                            anchors.horizontalCenter: parent.horizontalCenter
                            rows: 4
                            columns: 3
                            rowSpacing: 10
                            columnSpacing: 10
                            visible: __pickerHeader.isPickYear

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
                                    width: 80
                                    height: 40

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
                                                __private.selectDateTime(new Date(control.visualYear + 1, 0, 0), !(control.showDate && control.showTime));
                                            }
                                        }
                                        property int year: control.visualYear + modelData - 4
                                    }
                                }
                            }
                        }

                        Grid {
                            id: __monthPicker
                            anchors.horizontalCenter: parent.horizontalCenter
                            rows: 4
                            columns: 3
                            rowSpacing: 10
                            columnSpacing: 10
                            visible: __pickerHeader.isPickMonth

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
                                    width: 80
                                    height: 40

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
                                                __private.selectDateTime(new Date(control.visualYear, control.visualMonth + 1, 0),
                                                                         !(control.showDate && control.showTime));
                                            }
                                        }
                                        property int month: modelData
                                    }
                                }
                            }
                        }

                        Row {
                            id: __quarterPicker
                            anchors.horizontalCenter: parent.horizontalCenter
                            visible: __pickerHeader.isPickQuarter
                            spacing: 10

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
                                    width: 60
                                    height: 40

                                    PickerButton {
                                        anchors.centerIn: parent
                                        text: `Q${quarter}`
                                        checked: quarter == control.visualQuarter
                                        onClicked: {
                                            control.visualQuarter = quarter;
                                            __pickerHeader.isPickYear = false;

                                            if (control.datePickerMode == HusDateTimePicker.Mode_Quarter) {
                                                __private.selectDateTime(new Date(control.visualYear, (quarter - 1) * 3 + 1, 0),
                                                                         !(control.showDate && control.showTime));
                                            }
                                        }
                                        property int quarter: modelData + 1
                                    }
                                }
                            }
                        }

                        Loader {
                            width: parent.width
                            active: control.datePickerMode == HusDateTimePicker.Mode_Day && !control.showTime
                            sourceComponent: Rectangle {
                                height: 1
                                color: control.themeSource.colorSplitLine
                            }
                        }

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            active: control.datePickerMode == HusDateTimePicker.Mode_Day && !control.showTime
                            sourceComponent: HusButton {
                                animationEnabled: control.animationEnabled
                                type: HusButton.Type_Link
                                text: qsTr('今天')
                                onClicked: __private.selectDateTime(new Date(), !(control.showDate && control.showTime));
                            }
                        }
                    }

                    Loader {
                        height: parent.height
                        active: control.showDate && control.showTime
                        sourceComponent: Item {
                            width: 8

                            Rectangle {
                                width: 1
                                height: parent.height
                                anchors.right: parent.right
                                color: control.themeSource.colorSplitLine
                            }
                        }
                    }

                    ColumnLayout {
                        visible: control.showTime
                        height: Math.max(220, parent.height)

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            visible: control.showDate

                            HusText {
                                anchors.centerIn: parent
                                font {
                                    family: control.themeSource.fontFamily
                                    pixelSize: control.themeSource.fontSize
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
                                color: control.themeSource.colorSplitLine
                                visible: control.showDate && control.showTime
                            }
                        }

                        Row {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            TimeListView {
                                id: __hourListView
                                model: 24
                                visible: control.timePickerMode == HusDateTimePicker.Mode_HHMMSS ||
                                         control.timePickerMode == HusDateTimePicker.Mode_HHMM

                                Rectangle {
                                    width: 1
                                    height: parent.height
                                    anchors.right: parent.right
                                    color: control.themeSource.colorSplitLine
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
                                    color: control.themeSource.colorSplitLine
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
                    width: parent.width - (control.showDate ? 8 : 0)
                    active: control.showTime
                    sourceComponent: Item {
                        height: 32

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: control.themeSource.colorSplitLine
                        }

                        HusButton {
                            padding: 2
                            topPadding: 2
                            bottomPadding: 2
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            anchors.bottom: parent.bottom
                            animationEnabled: control.animationEnabled
                            type: HusButton.Type_Link
                            text: qsTr('此刻')
                            colorBg: 'transparent'
                            onClicked: {
                                const date = new Date();
                                __hourListView.initValue(String(date.getHours()).padStart(2, '0'));
                                __hourListView.checkIndex(date.getHours());
                                __minuteListView.initValue(String(date.getMinutes()).padStart(2, '0'));
                                __minuteListView.checkIndex(date.getMinutes());
                                __secondListView.initValue(String(date.getSeconds()).padStart(2, '0'));
                                __secondListView.checkIndex(date.getSeconds());
                                __private.selectDateTime(date);
                            }
                        }

                        HusButton {
                            id: __confirmButton
                            topPadding: 4
                            bottomPadding: 4
                            leftPadding: 10
                            rightPadding: 10
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.bottom: parent.bottom
                            animationEnabled: control.animationEnabled
                            type: HusButton.Type_Primary
                            text: qsTr('确定')
                            onClicked: {
                                __hourListView.initValue(__hourListView.checkValue);
                                __minuteListView.initValue(__minuteListView.checkValue);
                                __secondListView.initValue(__secondListView.checkValue);
                                __private.selectDateTime(__private.getDateTime());
                            }
                        }
                    }
                }
            }
        }
    }
}

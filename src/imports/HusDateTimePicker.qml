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

    property HusRadius radiusItemBg: HusRadius { all: themeSource.radiusItemBg }
    property HusRadius radiusPopupBg: HusRadius { all: themeSource.radiusPopupBg }

    property Component dayDelegate: HusButton {
        padding: 0
        implicitWidth: 28 * control.sizeRatio
        implicitHeight: 28 * control.sizeRatio
        animationEnabled: control.animationEnabled
        sizeRatio: control.sizeRatio
        type: HusButton.Type_Primary
        text: model.day
        font {
            family: control.themeSource.fontFamily
            pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
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
    width: (showDate && showTime ? 210 : 160) * control.sizeRatio
    themeSource: HusTheme.HusDateTimePicker
    iconSource: (__private.interactive && control.hovered && control.length !== 0) ?
                    HusIcon.CloseCircleFilled : control.showDate ? HusIcon.CalendarOutlined :
                                                                   HusIcon.ClockCircleOutlined
    iconPosition: HusInput.Position_Right
    iconDelegate: HusIconText {
        leftPadding: control.iconPosition === HusInput.Position_Left ? 10 * sizeRatio: 0
        rightPadding: control.iconPosition === HusInput.Position_Right ? 10 * sizeRatio: 0
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
        padding: 20 * control.sizeRatio
        topPadding: 4 * control.sizeRatio
        bottomPadding: 4 * control.sizeRatio
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
        padding: 8 * control.sizeRatio
        leftPadding: (control.showDate ? 8 : 2) * control.sizeRatio
        rightPadding: (control.showDate ? (control.showTime ? 2 : 8) : 2) * control.sizeRatio
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
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: control.themeSource.colorSplitLine
                    }

                    Column {
                        spacing: 0

                        T.DayOfWeekRow {
                            id: __dayOfWeekRow
                            visible: (control.datePickerMode == HusDateTimePicker.Mode_Day || control.datePickerMode == HusDateTimePicker.Mode_Week)
                                     && !__pickerHeader.isPickYear && !__pickerHeader.isPickMonth
                            locale: __monthGrid.locale
                            spacing: 10 * control.sizeRatio
                            delegate: HusText {
                                width: __dayOfWeekRow.itemWidth
                                text: shortName
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    family: control.themeSource.fontFamily
                                    pixelSize: parseInt(control.themeSource.fontSize) * control.sizeRatio
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
                                width: __dayLoader.implicitWidth + 16 * control.sizeRatio
                                height: __dayLoader.implicitHeight + 6 * control.sizeRatio

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
                    }

                    Grid {
                        id: __yearPicker
                        Layout.alignment: Qt.AlignHCenter
                        visible: __pickerHeader.isPickYear
                        rows: 4
                        columns: 3
                        rowSpacing: 10 * control.sizeRatio
                        columnSpacing: 10 * control.sizeRatio

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
                        Layout.alignment: Qt.AlignHCenter
                        visible: __pickerHeader.isPickMonth
                        rows: 4
                        columns: 3
                        rowSpacing: 10 * control.sizeRatio
                        columnSpacing: 10 * control.sizeRatio

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
                        Layout.alignment: Qt.AlignHCenter
                        visible: __pickerHeader.isPickQuarter
                        spacing: 10 * control.sizeRatio

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
                        visible: active
                        sourceComponent: Rectangle {
                            height: 1
                            color: control.themeSource.colorSplitLine
                        }
                    }

                    Loader {
                        Layout.alignment: Qt.AlignHCenter
                        active: control.datePickerMode == HusDateTimePicker.Mode_Day && !control.showTime
                        visible: active
                        sourceComponent: HusButton {
                            animationEnabled: control.animationEnabled
                            sizeRatio: control.sizeRatio
                            type: HusButton.Type_Link
                            text: qsTr('今天')
                            onClicked: __private.selectDateTime(new Date(), !(control.showDate && control.showTime));
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
                            color: control.themeSource.colorSplitLine
                        }
                    }
                }

                ColumnLayout {
                    visible: control.showTime
                    Layout.preferredHeight: Math.max(220 * control.sizeRatio, implicitHeight)

                    Item {
                        Layout.fillWidth: true
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
                            color: control.themeSource.colorSplitLine
                            visible: control.showDate && control.showTime
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
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
                Layout.fillWidth: true
                Layout.preferredHeight: 32 * control.sizeRatio
                active: control.showTime
                visible: active
                sourceComponent: Item {

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: control.themeSource.colorSplitLine
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
                            __private.selectDateTime(__private.getDateTime());
                        }
                    }
                }
            }
        }
    }
}

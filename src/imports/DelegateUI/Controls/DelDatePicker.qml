import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as T
import DelegateUI

Item {
    id: control

    width: 160
    height: 32

    enum IconPosition {
        Position_Left = 0,
        Position_Right = 1
    }

    enum PickerMode {
        Mode_Year = 0,
        Mode_Quarter = 1,
        Mode_Month = 2,
        Mode_Week = 3,
        Mode_Day = 4
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property alias placeholderText: __input.placeholderText
    property int iconPosition: DelDatePicker.Position_Right
    property int pickerMode: DelDatePicker.Mode_Day

    property var initDate: undefined
    property var currentDate: new Date()
    property int currentYear: new Date().getFullYear()
    property int currentMonth: new Date().getMonth()
    property int currentDay: new Date().getDate()
    property int currentWeekNumber: DelApi.getWeekNumber(new Date())
    property int currentQuarter: Math.floor(currentMonth / 3) + 1

    property int visualYear: control.currentYear
    property int visualMonth: control.currentMonth
    property int visualQuarter: control.currentQuarter

    property string dateFormat: "yyyy-MM-dd"

    property Component dayDelegate: DelButton {
        padding: 0
        implicitWidth: 28
        implicitHeight: 28
        type: DelButton.Type_Primary
        text: model.day
        font {
            family: DelTheme.DelDatePicker.fontFamily
            pixelSize: DelTheme.DelDatePicker.fontSize
        }
        effectEnabled: false
        colorBorder: model.today ? DelTheme.DelDatePicker.colorDayBorderToday : 'transparent'
        colorText: {
            if (control.pickerMode === DelDatePicker.Mode_Week) {
                return isCurrentWeek || isHoveredWeek ? 'white' : isCurrentVisualMonth ? DelTheme.DelDatePicker.colorDayText :
                                                                                         DelTheme.DelDatePicker.colorDayTextNone;
            } else {
                return isCurrentDay ? 'white' : isCurrentVisualMonth ? DelTheme.DelDatePicker.colorDayText :
                                                                       DelTheme.DelDatePicker.colorDayTextNone;
            }
        }
        colorBg: {
            if (control.pickerMode === DelDatePicker.Mode_Week) {
                return 'transparent';
            } else {
                return isCurrentDay ? DelTheme.DelDatePicker.colorDayBgCurrent :
                                      hovered ? DelTheme.DelDatePicker.colorDayBgHover :
                                                DelTheme.DelDatePicker.colorDayBg;
            }
        }
    }

    onInitDateChanged: {
        if (initDate)
            __private.selectDate(initDate);
    }

    function openPicker() {
        if (!__picker.opened)
            __picker.open();
    }

    function closePicker() {
        __picker.close();
    }

    component PageButton: DelIconButton {
        leftPadding: 8
        rightPadding: 8
        type: DelButton.Type_Link
        iconSize: 16
        colorIcon: hovered ? DelTheme.DelDatePicker.colorPageIconHover : DelTheme.DelDatePicker.colorPageIcon
    }

    component PickerHeader: RowLayout {
        id: __pickerHeaderComp

        property bool isPickYear: false
        property bool isPickMonth: false
        property bool isPickQuarter: control.pickerMode == DelDatePicker.Mode_Quarter

        PageButton {
            Layout.alignment: Qt.AlignVCenter
            iconSource: DelIcon.DoubleLeftOutlined
            onClicked: {
                const prevYear = control.visualYear - (__pickerHeaderComp.isPickYear ? 10 : 1);
                if (prevYear > -9999) {
                    control.visualYear = prevYear;
                }
            }
        }

        PageButton {
            Layout.alignment: Qt.AlignVCenter
            iconSource: DelIcon.LeftOutlined
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
                    colorText: hovered ? DelTheme.DelDatePicker.colorPageTextHover : DelTheme.DelDatePicker.colorPageText
                    font.bold: true
                    onClicked: {
                        __pickerHeaderComp.isPickYear = true;
                        __pickerHeaderComp.isPickMonth = false;
                        __pickerHeaderComp.isPickQuarter = false;
                    }
                }

                PageButton {
                    visible: control.pickerMode != DelDatePicker.Mode_Year &&
                             control.pickerMode != DelDatePicker.Mode_Quarter &&
                             !__pickerHeaderComp.isPickQuarter &&
                             !__pickerHeaderComp.isPickYear
                    text: (control.visualMonth + 1) + qsTr('月')
                    colorText: hovered ? DelTheme.DelDatePicker.colorPageTextHover : DelTheme.DelDatePicker.colorPageText
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
            iconSource: DelIcon.RightOutlined
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
            iconSource: DelIcon.DoubleRightOutlined
            onClicked: {
                const nextYear = control.visualYear + (__pickerHeaderComp.isPickYear ? 10 : 1);
                if (nextYear < 9999) {
                    control.visualYear = nextYear;
                }
            }
        }
    }

    component PickerButton: DelButton {
        padding: 20
        topPadding: 4
        bottomPadding: 4
        effectEnabled: false
        colorBorder: 'transparent'
        colorBg: checked ? DelTheme.DelDatePicker.colorDayBgCurrent :
                           hovered ? DelTheme.DelDatePicker.colorDayBgHover :
                                     DelTheme.DelDatePicker.colorDayBg
        colorText: checked ? 'white' : DelTheme.DelDatePicker.colorDayText
    }

    Item {
        id: __private
        property var window: Window.window
        property int hoveredWeekNumber: control.currentWeekNumber

        function selectDate(date) {
            const month = date.getMonth();
            const weekNumber = DelApi.getWeekNumber(date);
            const quarter = Math.floor(month / 3) + 1;
            if (control.pickerMode === DelDatePicker.Mode_Week) {
                let inputDate = date;
                let weekYear = date.getFullYear();
                if (weekNumber === 1 && month === 11) {
                    weekYear++;
                    inputDate = new Date(weekYear + 1, 0, 0);
                }
                __input.text = Qt.formatDate(inputDate, control.dateFormat.replace('w', String(weekNumber)));
            } else if (control.pickerMode == DelDatePicker.Mode_Quarter) {
                __input.text = Qt.formatDate(date, control.dateFormat.replace('q', String(quarter)));
            } else {
                __input.text = Qt.formatDate(date, control.dateFormat);
            }

            control.currentDate = date;
            control.currentYear = date.getFullYear();
            control.currentMonth = month;
            control.currentDay = date.getDate();
            control.currentWeekNumber = weekNumber;

            control.closePicker();
        }
    }

    DelInput {
        id: __input
        width: parent.width
        height: parent.height
        iconPosition: DelInput.Position_Right
        iconDelegate: DelIconText {
            anchors.left: control.iconPosition === DelDatePicker.Position_Left ? parent.left : undefined
            anchors.right: control.iconPosition === DelDatePicker.Position_Right ? parent.right : undefined
            anchors.margins: 5
            anchors.verticalCenter: parent.verticalCenter
            iconSource: (__input.hovered && __input.length !== 0) ? DelIcon.CloseCircleFilled : DelIcon.CalendarOutlined
            iconSize: __input.iconSize
            colorIcon: control.enabled ?
                           __iconMouse.hovered ? DelTheme.DelDatePicker.colorInputIconHover :
                                                 DelTheme.DelDatePicker.colorInputIcon : DelTheme.DelDatePicker.colorInputIconDisabled

            Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

            MouseArea {
                id: __iconMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: parent.iconSource == DelIcon.CloseCircleFilled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onEntered: hovered = true;
                onExited: hovered = false;
                onClicked: {
                    if (initDate) {
                        __private.selectDate(initDate);
                        __input.clear();
                    } else {
                        __private.selectDate(new Date());
                        __input.clear();
                    }
                }
                property bool hovered: false
            }
        }

        TapHandler {
            onTapped: {
                control.openPicker();
            }
        }
    }

    DelPopup {
        id: __picker

        function adjustPosition() {
            const pos = control.mapToItem(null, 0, 0);
            const pickerX = (control.width - implicitWidth) * 0.5;
            if ((pos.x + pickerX) < 0)
                x = pickerX + Math.abs(pos.x + pickerX) + 6;
            else if (__private.window.width < (pos.x + pickerX + implicitWidth)) {
                x = __private.window.width - pos.x - implicitWidth - 6;
            } else {
                x = pickerX;
            }

            if (onTop) {
                y = -implicitHeight - 6;
            } else {
                if (__private.window.height > (pos.y + control.height + implicitHeight + 6)){
                    y = control.height + 6;
                } else if (pos.y > implicitHeight) {
                    y = -implicitHeight - 6;
                    onTop = true;
                } else {
                    y = __private.window.height - (pos.y + implicitHeight + 6);
                }
            }
        }

        property bool onTop: false

        x: (control.width - implicitWidth) * 0.5
        y: control.height + 6
        implicitWidth: implicitContentWidth + leftPadding + rightPadding
        implicitHeight: implicitContentHeight + topPadding + bottomPadding
        padding: 10
        leftPadding: 12
        rightPadding: 12
        closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        enter: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 0.0
                to: 1.0
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0.0
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
            }
        }
        onAboutToShow: {
            control.visualYear = control.currentYear;
            control.visualMonth = control.currentMonth;
            control.visualQuarter = control.currentQuarter;

            switch (control.pickerMode) {
            case DelDatePicker.Mode_Day:
            case DelDatePicker.Mode_Week:
            {
                __pickerHeader.isPickYear = false;
                __pickerHeader.isPickMonth = false;
                __pickerHeader.isPickQuarter = false;
            } break;
            case DelDatePicker.Mode_Month:
            {
                __pickerHeader.isPickYear = false;
                __pickerHeader.isPickMonth = true;
                __pickerHeader.isPickQuarter = false;
            } break;
            case DelDatePicker.Mode_Quarter:
            {
                __pickerHeader.isPickYear = false;
                __pickerHeader.isPickMonth = false;
                __pickerHeader.isPickQuarter = true;
            } break;
            case DelDatePicker.Mode_Year:
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
        onOpened: adjustPosition();
        onHeightChanged: adjustPosition();
        contentItem: Item {
            implicitWidth: __pickerColumn.implicitWidth
            implicitHeight: __pickerColumn.implicitHeight

            Column {
                id: __pickerColumn
                spacing: 5

                PickerHeader {
                    id: __pickerHeader
                    width: parent.width
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: DelTheme.DelDatePicker.colorSplitLine
                }

                T.DayOfWeekRow {
                    id: __dayOfWeekRow
                    visible: (control.pickerMode == DelDatePicker.Mode_Day || control.pickerMode == DelDatePicker.Mode_Week) &&
                             !__pickerHeader.isPickYear && !__pickerHeader.isPickMonth
                    locale: __monthGrid.locale
                    spacing: 10
                    delegate: Text {
                        width: __dayOfWeekRow.itemWidth
                        text: shortName
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font {
                            family: DelTheme.DelDatePicker.fontFamily
                            pixelSize: DelTheme.DelDatePicker.fontSize
                        }
                        color: DelTheme.DelDatePicker.colorWeekText

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
                                if (control.pickerMode === DelDatePicker.Mode_Week) {
                                    return __dayItem.isCurrentWeek ? DelTheme.DelDatePicker.colorDayItemBgCurrent :
                                                                     __dayItem.isHoveredWeek ? DelTheme.DelDatePicker.colorDayItemBgHover :
                                                                                               DelTheme.DelDatePicker.colorDayItemBg;
                                } else {
                                    return 'transparent';
                                }
                            }

                            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }

                            Loader {
                                id: __dayLoader
                                anchors.centerIn: parent
                                sourceComponent: control.dayDelegate
                                property alias model: __dayItem.model
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
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: __private.selectDate(model.date);
                            }
                        }
                    }

                    NumberAnimation on scale {
                        running: control.animationEnabled && __monthGrid.visible
                        from: 0
                        to: 1
                        easing.type: Easing.OutCubic
                        duration: DelTheme.Primary.durationMid
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
                        duration: DelTheme.Primary.durationMid
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
                                    if (control.pickerMode == DelDatePicker.Mode_Day ||
                                            control.pickerMode == DelDatePicker.Mode_Week ||
                                            control.pickerMode == DelDatePicker.Mode_Month) {
                                        __pickerHeader.isPickYear = false;
                                        __pickerHeader.isPickMonth = true;
                                    } else if (control.pickerMode == DelDatePicker.Mode_Quarter) {
                                        __pickerHeader.isPickYear = false;
                                        __pickerHeader.isPickQuarter = true;
                                    } else if (control.pickerMode == DelDatePicker.Mode_Year) {
                                        __private.selectDate(new Date(control.visualYear + 1, 0, 0));
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
                        duration: DelTheme.Primary.durationMid
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
                                    if (control.pickerMode == DelDatePicker.Mode_Day ||
                                            control.pickerMode == DelDatePicker.Mode_Week) {
                                        __pickerHeader.isPickMonth = false;
                                    } else if (control.pickerMode == DelDatePicker.Mode_Month) {
                                        __private.selectDate(new Date(control.visualYear, control.visualMonth + 1, 0));
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
                        duration: DelTheme.Primary.durationMid
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

                                    if (control.pickerMode == DelDatePicker.Mode_Quarter) {
                                        __private.selectDate(new Date(control.visualYear, (quarter - 1) * 3 + 1, 0));
                                    }
                                }
                                property int quarter: modelData + 1
                            }
                        }
                    }
                }

                Loader {
                    width: parent.width
                    active: control.pickerMode == DelDatePicker.Mode_Day
                    sourceComponent: Rectangle {
                        height: 1
                        color: DelTheme.DelDatePicker.colorSplitLine
                    }
                }

                Loader {
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.pickerMode == DelDatePicker.Mode_Day
                    sourceComponent: DelButton {
                        type: DelButton.Type_Link
                        text: qsTr('今天')
                        onClicked: __private.selectDate(new Date());
                    }
                }
            }
        }
    }
}

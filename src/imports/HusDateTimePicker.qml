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
import QtQuick.Templates as T
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

    property alias showDate: __dateTimePickerPanel.showDate
    property alias showTime: __dateTimePickerPanel.showTime
    property alias datePickerMode: __dateTimePickerPanel.datePickerMode
    property alias timePickerMode: __dateTimePickerPanel.timePickerMode
    property alias format: __dateTimePickerPanel.format

    property alias prevIconSource: __dateTimePickerPanel.prevIconSource
    property alias nextIconSource: __dateTimePickerPanel.nextIconSource
    property alias superPrevIconSource: __dateTimePickerPanel.superPrevIconSource
    property alias superNextIconSource: __dateTimePickerPanel.superNextIconSource

    property alias yearRowSpacing: __dateTimePickerPanel.yearRowSpacing
    property alias yearColumnSpacing: __dateTimePickerPanel.yearColumnSpacing
    property alias monthRowSpacing: __dateTimePickerPanel.monthRowSpacing
    property alias monthColumnSpacing: __dateTimePickerPanel.monthColumnSpacing
    property alias quarterSpacing: __dateTimePickerPanel.quarterSpacing

    property alias initDateTime: __dateTimePickerPanel.initDateTime

    property alias currentDateTime: __dateTimePickerPanel.currentDateTime
    property alias currentYear: __dateTimePickerPanel.currentYear
    property alias currentMonth: __dateTimePickerPanel.currentMonth
    property alias currentDay: __dateTimePickerPanel.currentDay
    property alias currentWeekNumber: __dateTimePickerPanel.currentWeekNumber
    property alias currentQuarter: __dateTimePickerPanel.currentQuarter
    property alias currentHours: __dateTimePickerPanel.currentHours
    property alias currentMinutes: __dateTimePickerPanel.currentMinutes
    property alias currentSeconds: __dateTimePickerPanel.currentSeconds

    property alias visualYear: __dateTimePickerPanel.visualYear
    property alias visualMonth: __dateTimePickerPanel.visualMonth
    property alias visualDay: __dateTimePickerPanel.visualDay
    property alias visualWeekNumber: __dateTimePickerPanel.visualWeekNumber
    property alias visualQuarter: __dateTimePickerPanel.visualQuarter
    property alias visualHours: __dateTimePickerPanel.visualHours
    property alias visualMinutes: __dateTimePickerPanel.visualMinutes
    property alias visualSeconds: __dateTimePickerPanel.visualSeconds

    property alias locale: __dateTimePickerPanel.locale

    property alias radiusItemBg: __dateTimePickerPanel.radiusItemBg
    property alias radiusPopupBg: __picker.radiusBg

    property alias dayDelegate: __dateTimePickerPanel.dayDelegate

    property alias popup: __picker
    property alias panel: __dateTimePickerPanel

    function clearDateTime(date: var) {
        control.clear();
        __dateTimePickerPanel.clearDateTime();
    }

    function setDateTime(date: var) {
        __dateTimePickerPanel.setDateTime(date);
    }

    function getDateTime(): var {
        return __dateTimePickerPanel.getDateTime();
    }

    function setDateTimeString(dateTimeString: string) {
        __dateTimePickerPanel.setDateTimeString(dateTimeString);
    }

    function getDateTimeString(): string {
        return __dateTimePickerPanel.getDateTimeString();
    }

    function selectNow() {
        __dateTimePickerPanel.selectNow();
    }

    function resetVisualStatus() {
        __dateTimePickerPanel.resetVisualStatus();
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
                if (control.length === 0) {
                    control.openPicker();
                } else {
                    control.closePicker();
                }
                control.clearDateTime();
            }
            property bool hovered: false
        }
    }
    onTextEdited: {
        control.openPicker();
        control.setDateTimeString(text);
    }
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            control.setDateTimeString(text);
            control.closePicker();
        }
    }

    Item {
        id: __private
        property var window: Window.window
        property bool interactive: control.enabled && !control.readOnly
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
        padding: 0
        implicitWidth: implicitContentWidth + leftPadding + rightPadding
        implicitHeight: implicitContentHeight + topPadding + bottomPadding
        animationEnabled: control.animationEnabled
        colorBg: HusTheme.isDark ? control.themeSource.colorPopupBgDark : control.themeSource.colorPopupBg
        radiusBg.all: control.themeSource.radiusPopupBg
        closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        transformOrigin: isTop ? Item.Bottom : Item.Top
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
        exit: Transition {
            NumberAnimation {
                property: 'scale'
                from: 1.0
                to: 0.5
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0.0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        contentItem: HusDateTimePickerPanel {
            id: __dateTimePickerPanel
            animationEnabled: control.animationEnabled
            themeSource: control.themeSource
            sizeRatio: control.sizeRatio
            showNow: true
            colorBorder: 'transparent'
            background: null
            onSelected:
                date => {
                    control.selected(date);
                    control.closePicker();
                }
            onVisualTextChanged: control.text = visualText;
        }
        onAboutToShow: control.resetVisualStatus();
        onAboutToHide: control.resetVisualStatus();
        Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
        property bool isTop: (y + height * 0.5) < control.height * 0.5
    }
}

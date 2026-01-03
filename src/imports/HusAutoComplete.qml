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
import QtQuick.Templates as T
import HuskarUI.Basic

HusInput {
    id: control

    signal search(input: string)
    signal select(option: var)

    property var options: []
    property var filterOption: (input, option) => true
    property string textRole: 'label'
    property string valueRole: 'value'
    property bool showToolTip: false
    property int defaultPopupMaxHeight: 240 * control.sizeRatio
    property int defaultOptionSpacing: 0

    property Component labelDelegate: HusText {
        text: textData
        color: control.themeSource.colorItemText
        font {
            family: control.themeSource.fontFamily
            pixelSize: parseInt(control.themeSource.fontSize)
            weight: highlighted ? Font.DemiBold : Font.Normal
        }
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
    property Component labelBgDelegate: Rectangle {
        radius: control.themeSource.radiusLabelBg
        color: highlighted ? control.themeSource.colorItemBgActive :
                             (hovered || selected) ? control.themeSource.colorItemBgHover :
                                                     control.themeSource.colorItemBg;

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    }

    function clearInput() {
        control.clear();
        control.textEdited();
        __popupListView.currentIndex = __popupListView.selectedIndex = -1;
    }

    function openPopup() {
        if (!__popup.opened)
            __popup.open();
    }

    function closePopup() {
        __popup.close();
    }

    function filter() {
        __private.model = options.filter(option => filterOption(text, option) === true);
        __popupListView.currentIndex = __popupListView.selectedIndex = -1;
    }

    onClickClear: {
        control.clearInput();
    }
    onOptionsChanged: {
        control.filter();
    }
    onFilterOptionChanged: {
        control.filter();
    }
    onTextEdited: {
        control.search(text);
        control.filter();
        if (__private.model.length > 0)
            control.openPopup();
        else
            control.closePopup();
    }
    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Escape) {
            control.closePopup();
        } else if (event.key === Qt.Key_Up) {
            control.openPopup();
            if (__popupListView.selectedIndex > 0) {
                __popupListView.selectedIndex -= 1;
                __popupListView.positionViewAtIndex(__popupListView.selectedIndex, ListView.Contain);
            } else {
                __popupListView.selectedIndex = __popupListView.count - 1;
                __popupListView.positionViewAtIndex(__popupListView.selectedIndex, ListView.Contain);
            }
        } else if (event.key === Qt.Key_Down) {
            control.openPopup();
            __popupListView.selectedIndex = (__popupListView.selectedIndex + 1) % __popupListView.count;
            __popupListView.positionViewAtIndex(__popupListView.selectedIndex, ListView.Contain);
        } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            if (__popupListView.selectedIndex !== -1) {
                const modelData = __private.model[__popupListView.selectedIndex];
                const textData = modelData[control.textRole];
                const valueData = modelData[control.valueRole] ?? textData;
                control.select(modelData);
                control.text = valueData;
                __popup.close();
                control.filter();
            }
        }
    }

    objectName: '__HusAutoComplete__'
    themeSource: HusTheme.HusAutoComplete
    iconPosition: HusInput.Position_Right
    clearEnabled: 'active'

    Item {
        id: __private
        property var window: Window.window
        property var model: []
    }

    TapHandler {
        enabled: control.enabled && !control.readOnly
        onTapped: {
            if (__private.model.length > 0)
                control.openPopup();
        }
    }

    HusPopup {
        id: __popup
        y: control.height + 6
        implicitWidth: control.width
        implicitHeight: implicitContentHeight + topPadding + bottomPadding
        leftPadding: 4 * control.sizeRatio
        rightPadding: 4 * control.sizeRatio
        topPadding: 6 * control.sizeRatio
        bottomPadding: 6 * control.sizeRatio
        animationEnabled: control.animationEnabled
        closePolicy: T.Popup.NoAutoClose | T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        transformOrigin: isTop ? Item.Bottom : Item.Top
        enter: Transition {
            NumberAnimation {
                property: 'scale'
                from: 0.9
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
                to: 0.9
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
        contentItem: ListView {
            id: __popupListView
            property int selectedIndex: -1
            implicitHeight: Math.min(control.defaultPopupMaxHeight, contentHeight)
            clip: true
            currentIndex: -1
            model: __private.model
            boundsBehavior: Flickable.StopAtBounds
            spacing: control.defaultOptionSpacing
            delegate: T.ItemDelegate {
                id: __popupDelegate

                required property var modelData
                required property int index

                property var textData: modelData[control.textRole]
                property var valueData: modelData[control.valueRole] ?? textData
                property bool selected: __popupListView.selectedIndex === index

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8 * control.sizeRatio
                rightPadding: 8 * control.sizeRatio
                topPadding: 5 * control.sizeRatio
                bottomPadding: 5 * control.sizeRatio
                highlighted: control.text === valueData
                contentItem: Loader {
                    sourceComponent: control.labelDelegate
                    property alias textData: __popupDelegate.textData
                    property alias valueData: __popupDelegate.valueData
                    property alias modelData: __popupDelegate.modelData
                    property alias hovered: __popupDelegate.hovered
                    property alias highlighted: __popupDelegate.highlighted
                }
                background: Loader {
                    sourceComponent: control.labelBgDelegate
                    property alias textData: __popupDelegate.textData
                    property alias valueData: __popupDelegate.valueData
                    property alias modelData: __popupDelegate.modelData
                    property alias hovered: __popupDelegate.hovered
                    property alias selected: __popupDelegate.selected
                    property alias highlighted: __popupDelegate.highlighted
                }
                onClicked: {
                    control.select(__popupDelegate.modelData);
                    control.text = __popupDelegate.valueData;
                    __popup.close();
                    control.filter();
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.showToolTip
                    sourceComponent: HusToolTip {
                        showArrow: false
                        visible: __popupDelegate.hovered && !__popupDelegate.pressed
                        text: __popupDelegate.textData
                        position: HusToolTip.Position_Bottom
                    }
                }
            }
            T.ScrollBar.vertical: HusScrollBar { }
        }
        Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
        property bool isTop: (y + height * 0.5) < control.height * 0.5
    }
}

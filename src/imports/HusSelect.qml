import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.ComboBox {
    id: control

    signal clickClear()

    property bool animationEnabled: HusTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool clearEnabled: true
    property var clearIconSource: HusIcon.CloseCircleFilled ?? ''
    property bool showToolTip: false
    property bool loading: false
    property int defaultPopupMaxHeight: 240
    property color colorText: enabled ?
                                  (popup.visible && !editable) ? themeSource.colorTextActive :
                                                                 themeSource.colorText : themeSource.colorTextDisabled
    property color colorBorder: enabled ?
                                    active ? themeSource.colorBorderHover :
                                             themeSource.colorBorder : themeSource.colorBorderDisabled
    property color colorBg: enabled ? themeSource.colorBg : themeSource.colorBgDisabled

    property HusRadius radiusBg: HusRadius { all: themeSource.radiusBg }
    property HusRadius radiusItemBg: HusRadius { all: themeSource.radiusItemBg }
    property HusRadius radiusPopupBg: HusRadius { all: themeSource.radiusPopupBg }
    property string contentDescription: ''
    property var themeSource: HusTheme.HusSelect

    property Component indicatorDelegate: HusIconText {
        leftPadding: 4
        rightPadding: 8
        colorIcon: {
            if (control.enabled) {
                if (__clearMouseArea.active) {
                    return __clearMouseArea.pressed ? control.themeSource.colorIndicatorActive :
                                                      __clearMouseArea.hovered ? control.themeSource.colorIndicatorHover :
                                                                                 control.themeSource.colorIndicator;
                } else {
                    return control.themeSource.colorIndicator;
                }
            } else {
                return control.themeSource.colorIndicatorDisabled;
            }
        }
        iconSize: parseInt(control.themeSource.fontSize)
        iconSource: {
            if (control.enabled && control.clearEnabled && __clearMouseArea.active)
                return control.clearIconSource;
            else
                control.loading ? HusIcon.LoadingOutlined : HusIcon.DownOutlined
        }

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

        NumberAnimation on rotation {
            running: control.loading
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }

        MouseArea {
            id: __clearMouseArea
            anchors.fill: parent
            enabled: control.enabled
            hoverEnabled: true
            cursorShape: hovered ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: hovered = true;
            onExited: hovered = false;
            onClicked: function(mouse) {
                if (active && control.clearEnabled) {
                    if (control.editable)
                        control.editText = '';
                    control.currentIndex = -1;
                    control.clickClear();
                } else {
                    if (control.popup.opened) {
                        control.popup.close();
                    } else {
                        control.popup.open();
                    }
                }
                mouse.accepted = true;
            }
            property bool active: !control.loading && (control.displayText.length > 0 || control.editText.length > 0) && control.hovered
            property bool hovered: false
        }
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    objectName: '__HusSelect__'
    leftPadding: padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    topPadding: 4
    bottomPadding: 4
    implicitWidth: implicitContentWidth + implicitIndicatorWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    textRole: 'label'
    valueRole: 'value'
    font {
        family: control.themeSource.fontFamily
        pixelSize: parseInt(control.themeSource.fontSize)
    }
    selectTextByMouse: editable
    delegate: T.ItemDelegate { }
    indicator: Loader {
        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: control.topPadding + (control.availableHeight - height) / 2
        sourceComponent: indicatorDelegate
    }
    contentItem: HusInput {
        leftPadding: !control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        rightPadding: control.mirrored ? 12 : control.editable && activeFocus ? 3 : 1
        topPadding: 0
        bottomPadding: 0
        text: control.editable ? control.editText : control.displayText
        readOnly: !control.editable
        autoScroll: control.editable
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse
        verticalAlignment: Text.AlignVCenter
        colorText: control.colorText
        colorBg: 'transparent'
        colorBorder: 'transparent'

        HoverHandler {
            cursorShape: control.editable ? Qt.IBeamCursor : control.hoverCursorShape
        }

        TapHandler {
            onTapped: {
                if (!control.editable) {
                    if (control.popup.opened) {
                        control.popup.close();
                    } else {
                        control.popup.open();
                    }
                } else {
                    __openPopupTimer.restart();
                }
            }
        }

        Timer {
            id: __openPopupTimer
            interval: 100
            onTriggered: {
                if (!control.popup.opened) {
                    control.popup.open();
                }
            }
        }
    }
    background: HusRectangleInternal {
        color: control.colorBg
        border.color: control.colorBorder
        border.width: control.visualFocus ? 2 : 1
        radius: control.radiusBg.all
        topLeftRadius: control.radiusBg.topLeft
        topRightRadius: control.radiusBg.topRight
        bottomLeftRadius: control.radiusBg.bottomLeft
        bottomRightRadius: control.radiusBg.bottomRight
    }
    popup: HusPopup {
        id: __popup
        y: control.height + 2
        implicitWidth: control.width
        implicitHeight: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        animationEnabled: control.animationEnabled
        radiusBg: control.radiusPopupBg
        colorBg: HusTheme.isDark ? control.themeSource.colorPopupBgDark : control.themeSource.colorPopupBg
        enter: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 0.0
                to: 1.0
                easing.type: Easing.OutQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'height'
                to: __popup.implicitHeight
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
            NumberAnimation {
                property: 'height'
                from: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
                to: 0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        contentItem: ListView {
            id: __popupListView
            clip: true
            model: control.popup.visible ? control.model : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.ItemDelegate {
                id: __popupDelegate

                required property var model
                required property int index

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 5
                bottomPadding: 5
                enabled: model.enabled ?? true
                contentItem: HusText {
                    text: __popupDelegate.model[control.textRole]
                    color: __popupDelegate.enabled ? control.themeSource.colorItemText : control.themeSource.colorItemTextDisabled
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: parseInt(control.themeSource.fontSize)
                        weight: highlighted ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: control.radiusItemBg.all
                    topLeftRadius: control.radiusItemBg.topLeft
                    topRightRadius: control.radiusItemBg.topRight
                    bottomLeftRadius: control.radiusItemBg.bottomLeft
                    bottomRightRadius: control.radiusItemBg.bottomRight
                    color: {
                        if (__popupDelegate.enabled)
                            return highlighted ? control.themeSource.colorItemBgActive :
                                                 hovered ? control.themeSource.colorItemBgHover :
                                                           control.themeSource.colorItemBg;
                        else
                            return control.themeSource.colorItemBgDisabled;
                    }

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
                highlighted: control.highlightedIndex === index
                onClicked: {
                    control.currentIndex = index;
                    control.activated(index);
                    control.popup.close();
                }

                HoverHandler {
                    cursorShape: control.hoverCursorShape
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.showToolTip
                    sourceComponent: HusToolTip {
                        showArrow: false
                        visible: __popupDelegate.hovered
                        animationEnabled: control.animationEnabled
                        text: __popupDelegate.model[control.textRole]
                        position: HusToolTip.Position_Bottom
                    }
                }
            }
            T.ScrollBar.vertical: HusScrollBar {
                animationEnabled: control.animationEnabled
            }
        }

        Binding on height { when: __popup.opened; value: __popup.implicitHeight }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.ComboBox
    Accessible.name: control.displayText
    Accessible.description: control.contentDescription
}

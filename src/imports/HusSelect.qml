import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

T.ComboBox {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    readonly property bool active: hovered || activeFocus
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool tooltipVisible: false
    property bool loading: false
    property int defaulPopupMaxHeight: 240
    property color colorText: enabled ?
                                  popup.visible ? HusTheme.HusSelect.colorTextActive :
                                                  HusTheme.HusSelect.colorText : HusTheme.HusSelect.colorTextDisabled
    property color colorBorder: enabled ?
                                    active ? HusTheme.HusSelect.colorBorderHover :
                                             HusTheme.HusSelect.colorBorder : HusTheme.HusSelect.colorBorderDisabled
    property color colorBg: enabled ? HusTheme.HusSelect.colorBg : HusTheme.HusSelect.colorBgDisabled

    property int radiusBg: HusTheme.HusSelect.radiusBg
    property int radiusItemBg: HusTheme.HusSelect.radiusItemBg
    property int radiusPopupBg: HusTheme.HusSelect.radiusPopupBg
    property string contentDescription: ''

    property Component indicatorDelegate: HusIconText {
        colorIcon: HusTheme.HusSelect.colorTextActive
        iconSize: HusTheme.HusSelect.fontSize - 2
        iconSource: control.loading ? HusIcon.LoadingOutlined : HusIcon.DownOutlined

        NumberAnimation on rotation {
            running: control.loading
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    objectName: '__HusSelect__'
    leftPadding: 4
    rightPadding: 8
    topPadding: 4
    bottomPadding: 4
    implicitWidth: implicitContentWidth + implicitIndicatorWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    textRole: 'label'
    valueRole: 'value'
    font {
        family: HusTheme.HusSelect.fontFamily
        pixelSize: HusTheme.HusSelect.fontSize
    }
    delegate: T.ItemDelegate { }
    indicator: Loader {
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        sourceComponent: indicatorDelegate
    }
    contentItem: HusText {
        topPadding: 1
        bottomPadding: 1
        leftPadding: 8
        rightPadding: control.indicator.width + control.spacing
        text: control.displayText
        font: control.font
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        border.width: control.visualFocus ? 2 : 1
        radius: control.radiusBg
    }
    popup: HusPopup {
        id: __popup
        y: control.height + 2
        implicitWidth: control.width
        implicitHeight: Math.min(control.defaulPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        animationEnabled: control.animationEnabled
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
                from: 0
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
                    color: __popupDelegate.enabled ? HusTheme.HusSelect.colorItemText : HusTheme.HusSelect.colorItemTextDisabled;
                    font {
                        family: HusTheme.HusSelect.fontFamily
                        pixelSize: HusTheme.HusSelect.fontSize
                        weight: highlighted ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: control.radiusItemBg
                    color: {
                        if (__popupDelegate.enabled)
                            return highlighted ? HusTheme.HusSelect.colorItemBgActive :
                                                 hovered ? HusTheme.HusSelect.colorItemBgHover :
                                                           HusTheme.HusSelect.colorItemBg;
                        else
                            return HusTheme.HusSelect.colorItemBgDisabled;
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
                    active: control.tooltipVisible
                    sourceComponent: HusToolTip {
                        arrowVisible: false
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

        Binding on height { value: __popup.implicitHeight }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.ComboBox
    Accessible.name: control.displayText
    Accessible.description: control.contentDescription
}

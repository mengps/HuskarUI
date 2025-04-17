import QtQuick
import QtQuick.Effects
import QtQuick.Templates as T
import DelegateUI

T.ComboBox {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool tooltipVisible: false
    property bool loading: false
    property int defaulPopupMaxHeight: 240
    property color colorText: enabled ?
                                  popup.visible ? DelTheme.DelSelect.colorTextActive :
                                                  DelTheme.DelSelect.colorText : DelTheme.DelSelect.colorTextDisabled
    property color colorBorder: enabled ?
                                    hovered ? DelTheme.DelSelect.colorBorderHover :
                                              DelTheme.DelSelect.colorBorder : DelTheme.DelSelect.colorBorderDisabled
    property color colorBg: enabled ? DelTheme.DelSelect.colorBg : DelTheme.DelSelect.colorBgDisabled

    property int radiusBg: 6
    property int radiusPopupBg: 6
    property string contentDescription: ''

    property Component indicatorDelegate: DelIconText {
        iconSize: 12
        iconSource: control.loading ? DelIcon.LoadingOutlined : DelIcon.DownOutlined

        NumberAnimation on rotation {
            running: control.loading
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

    rightPadding: 8
    topPadding: 5
    bottomPadding: 5
    implicitWidth: implicitContentWidth + implicitIndicatorWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    textRole: 'label'
    valueRole: 'value'
    objectName: '__DelSelect__'
    font {
        family: DelTheme.DelSelect.fontFamily
        pixelSize: DelTheme.DelSelect.fontSize
    }
    delegate: T.ItemDelegate { }
    indicator: Loader {
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        sourceComponent: indicatorDelegate
    }
    contentItem: Text {
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
    popup: DelPopup {
        id: __popup
        y: control.height + 2
        implicitWidth: control.width
        implicitHeight: Math.min(control.defaulPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        enter: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 0.0
                to: 1.0
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'height'
                from: 0
                to: __popup.implicitHeight
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
            NumberAnimation {
                property: 'height'
                to: 0
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
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
                topPadding: 4
                bottomPadding: 4
                enabled: model.enabled ?? true
                contentItem: Text {
                    text: __popupDelegate.model[control.textRole]
                    color: __popupDelegate.enabled ? DelTheme.DelSelect.colorItemText : DelTheme.DelSelect.colorItemTextDisabled;
                    font {
                        family: DelTheme.DelSelect.fontFamily
                        pixelSize: DelTheme.DelSelect.fontSize
                        weight: highlighted ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: 2
                    color: {
                        if (__popupDelegate.enabled)
                            return highlighted ? DelTheme.DelSelect.colorItemBgActive :
                                                 hovered ? DelTheme.DelSelect.colorItemBgHover :
                                                           DelTheme.DelSelect.colorItemBg;
                        else
                            return DelTheme.DelSelect.colorItemBgDisabled;
                    }

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
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
                    sourceComponent: DelToolTip {
                        arrowVisible: false
                        visible: __popupDelegate.hovered
                        text: __popupDelegate.model[control.textRole]
                        position: DelToolTip.Position_Bottom
                    }
                }
            }
            T.ScrollBar.vertical: DelScrollBar { }
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.ComboBox
    Accessible.name: control.displayText
    Accessible.description: control.contentDescription
}

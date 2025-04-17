import QtQuick
import QtQuick.Templates as T
import DelegateUI

DelInput {
    id: control

    signal search(input: string)
    signal select(option: var)

    property var options: []
    property var filterOption: (input, option) => true
    property string textRole: 'label'
    property string valueRole: 'value'
    property bool tooltipVisible: false
    property alias clearIconSource: control.iconSource
    property alias clearIconPosition: control.iconPosition
    property int defaulPopupMaxHeight: 240

    property Component labelDelegate: Text {
        text: textData
        color: DelTheme.DelAutoComplete.colorItemText
        font {
            family: DelTheme.DelAutoComplete.fontFamily
            pixelSize: DelTheme.DelAutoComplete.fontSize
            weight: highlighted ? Font.DemiBold : Font.Normal
        }
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
    property Component labelBgDelegate: Rectangle {
        radius: 2
        color: highlighted ? DelTheme.DelAutoComplete.colorItemBgActive :
                             hovered ? DelTheme.DelAutoComplete.colorItemBgHover :
                                       DelTheme.DelAutoComplete.colorItemBg;
    }
    property Component clearIconDelegate: DelIconText {
        iconSource: control.clearIconSource
        iconSize: control.iconSize
        colorIcon: control.enabled ?
                       __iconMouse.hovered ? DelTheme.DelAutoComplete.colorIconHover :
                                             DelTheme.DelAutoComplete.colorIcon : DelTheme.DelAutoComplete.colorIconDisabled

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

        MouseArea {
            id: __iconMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: parent.iconSource == control.clearIconSource ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: hovered = true;
            onExited: hovered = false;
            property bool hovered: false
            onClicked: control.clearInput();
        }
    }

    clearIconPosition: DelInput.Position_Right
    iconDelegate: clearIconDelegate
    onOptionsChanged: __private.model = options;
    onTextEdited: {
        control.search(text);
        __private.filter();
        if (__private.model.length > 0)
            control.openPopup();
        else
            control.closePopup();
    }

    function clearInput() {
        control.clear();
        control.search('');
        __popupListView.currentIndex = -1;
        closePopup();
    }

    function openPopup() {
        if (!__popup.opened)
            __popup.open();
    }

    function closePopup() {
        __popup.close();
    }

    Item {
        id: __private
        property var window: Window.window
        property var model: []
        function filter() {
            __private.model = options.filter(option => filterOption(text, option) === true);
        }
    }

    TapHandler {
        onTapped: {
            if (__private.model.length > 0)
                control.openPopup();
        }
    }

    DelPopup {
        id: __popup
        implicitWidth: control.width
        implicitHeight: Math.min(control.defaulPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        closePolicy: T.Popup.NoAutoClose | T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        onAboutToShow: {
            const pos = control.mapToItem(null, 0, 0);
            x = (control.width - width) * 0.5;
            if (__private.window.height > (pos.y + control.height + implicitHeight + 6)){
                y = control.height + 6;
            } else if (pos.y > implicitHeight) {
                y = -implicitHeight - 6;
            } else {
                y = __private.window.height - (pos.y + implicitHeight + 6);
            }
        }
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
        contentItem: ListView {
            id: __popupListView
            clip: true
            currentIndex: -1
            model: __private.model
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.ItemDelegate {
                id: __popupDelegate

                required property var modelData
                required property int index

                property var textData: modelData[control.textRole]
                property var valueData: modelData[control.valueRole] ?? textData

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 4
                bottomPadding: 4
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
                    property alias highlighted: __popupDelegate.highlighted
                }
                highlighted: __popupListView.currentIndex === index
                onClicked: {
                    control.select(__popupDelegate.modelData);
                    control.text = __popupDelegate.valueData;
                    __popupListView.currentIndex = index;
                    __popup.close();
                    __private.filter();
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.tooltipVisible
                    sourceComponent: DelToolTip {
                        arrowVisible: false
                        visible: __popupDelegate.hovered
                        text: __popupDelegate.textData
                        position: DelToolTip.Position_Bottom
                    }
                }
            }
            T.ScrollBar.vertical: DelScrollBar { }
        }
    }
}

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
    property bool tooltipVisible: false
    property alias clearIconSource: control.iconSource
    property alias clearIconSize: control.iconSize
    property alias clearIconPosition: control.iconPosition
    property int defaultPopupMaxHeight: 240
    property int defaultOptionSpacing: 0

    property Component labelDelegate: HusText {
        text: textData
        color: HusTheme.HusAutoComplete.colorItemText
        font {
            family: HusTheme.HusAutoComplete.fontFamily
            pixelSize: HusTheme.HusAutoComplete.fontSize
            weight: highlighted ? Font.DemiBold : Font.Normal
        }
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
    property Component labelBgDelegate: Rectangle {
        radius: HusTheme.HusAutoComplete.radiusLabelBg
        color: highlighted ? HusTheme.HusAutoComplete.colorItemBgActive :
                             hovered ? HusTheme.HusAutoComplete.colorItemBgHover :
                                       HusTheme.HusAutoComplete.colorItemBg;

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    }
    property Component clearIconDelegate: HusIconText {
        iconSource: control.clearIconSource
        iconSize: control.iconSize
        colorIcon: control.enabled ?
                       __iconMouse.hovered ? HusTheme.HusAutoComplete.colorIconHover :
                                             HusTheme.HusAutoComplete.colorIcon : HusTheme.HusAutoComplete.colorIconDisabled

        Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

        MouseArea {
            id: __iconMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: parent.iconSource == control.clearIconSource ? Qt.PointingHandCursor : Qt.ArrowCursor
            onEntered: hovered = true;
            onExited: hovered = false;
            onClicked: control.clearInput();
            property bool hovered: false
        }
    }

    objectName: '__HusAutoComplete__'
    clearIconPosition: HusInput.Position_Right
    iconDelegate: clearIconDelegate
    onOptionsChanged: {
        __private.model = options;
        __popupListView.currentIndex = -1;
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

    function clearInput() {
        control.clear();
        control.textEdited();
        __popupListView.currentIndex = -1;
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
    }

    Item {
        id: __private
        property var window: Window.window
        property var model: []
    }

    TapHandler {
        onTapped: {
            if (__private.model.length > 0)
                control.openPopup();
        }
    }

    HusPopup {
        id: __popup
        implicitWidth: control.width
        implicitHeight: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
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
                y = Qt.binding(() => -implicitHeight - 6);
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
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'height'
                from: 0
                to: __popup.implicitHeight
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0.0
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
            NumberAnimation {
                property: 'height'
                to: 0
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        contentItem: ListView {
            id: __popupListView
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

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 5
                bottomPadding: 5
                highlighted: __popupListView.currentIndex === index
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
                onClicked: {
                    control.select(__popupDelegate.modelData);
                    control.text = __popupDelegate.valueData;
                    __popupListView.currentIndex = index;
                    __popup.close();
                    control.filter();
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.tooltipVisible
                    sourceComponent: HusToolTip {
                        arrowVisible: false
                        visible: __popupDelegate.hovered && !__popupDelegate.pressed
                        text: __popupDelegate.textData
                        position: HusToolTip.Position_Bottom
                    }
                }
            }
            T.ScrollBar.vertical: HusScrollBar { }
        }

        Binding on height { value: __popup.implicitHeight }
    }
}

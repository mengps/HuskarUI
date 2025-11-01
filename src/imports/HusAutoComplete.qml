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
    property int defaultPopupMaxHeight: 240
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

    objectName: '__HusAutoComplete__'
    themeSource: HusTheme.HusAutoComplete
    iconPosition: HusInput.Position_Right
    clearEnabled: 'active'
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
            if (__popupListView.selectIndex > 0) {
                __popupListView.selectIndex -= 1;
                __popupListView.positionViewAtIndex(__popupListView.selectIndex, ListView.Contain);
            } else {
                __popupListView.selectIndex = __popupListView.count - 1;
                __popupListView.positionViewAtIndex(__popupListView.selectIndex, ListView.Contain);
            }
        } else if (event.key === Qt.Key_Down) {
            control.openPopup();
            __popupListView.selectIndex = (__popupListView.selectIndex + 1) % __popupListView.count;
            __popupListView.positionViewAtIndex(__popupListView.selectIndex, ListView.Contain);
        } else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            if (__popupListView.selectIndex !== -1) {
                const modelData = __private.model[__popupListView.selectIndex];
                const textData = modelData[control.textRole];
                const valueData = modelData[control.valueRole] ?? textData;
                control.select(modelData);
                control.text = valueData;
                __popup.close();
                control.filter();
            }
        }
    }

    function clearInput() {
        control.clear();
        control.textEdited();
        __popupListView.currentIndex = __popupListView.selectIndex = -1;
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
        __popupListView.currentIndex = __popupListView.selectIndex = -1;
    }

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
        implicitHeight: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        animationEnabled: control.animationEnabled
        closePolicy: T.Popup.NoAutoClose | T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
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
                from: Math.min(control.defaultPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
                to: 0
                easing.type: Easing.InQuad
                duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
            }
        }
        contentItem: ListView {
            id: __popupListView
            property int selectIndex: -1
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
                property bool selected: __popupListView.selectIndex == index

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 5
                bottomPadding: 5
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

        Binding on height { when: __popup.opened; value: __popup.implicitHeight }
    }
}

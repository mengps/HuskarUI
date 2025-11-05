import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

HusSelect {
    id: control

    signal search(input: string)
    signal select(option: var)
    signal removeTag(option: var)

    property var options: []
    property var filterOption: (input, option) => true
    property alias text: __input.text
    property string prefix: ''
    property string suffix: ''
    property bool genDefaultKey: true
    property var selectedKeys: []
    property bool searchEnabled: true
    property string placeholderText: ''
    readonly property alias tagCount: __tagListModel.count
    property int maxTagCount: -1
    property int tagSpacing: 5
    property color colorTagText: themeSource.colorTagText
    property color colorTagBg: themeSource.colorTagBg
    property HusRadius radiusTagBg: HusRadius { all: themeSource.radiusTagBg }

    property Component prefixDelegate: HusText {
        font: control.font
        text: control.prefix
        color: control.themeSource.colorText
    }
    property Component suffixDelegate: HusText {
        font: control.font
        text: control.suffix
        color: control.themeSource.colorText
    }
    property Component tagDelegate: HusRectangleInternal {
        id: __tag

        required property int index
        required property var tagData

        implicitWidth: __row.implicitWidth + 16
        implicitHeight: Math.max(__text.implicitHeight, __closeIcon.implicitHeight) + 4
        radius: control.radiusTagBg.all
        topLeftRadius: control.radiusTagBg.topLeft
        topRightRadius: control.radiusTagBg.topRight
        bottomLeftRadius: control.radiusTagBg.bottomLeft
        bottomRightRadius: control.radiusTagBg.bottomRight
        color: control.colorTagBg

        MouseArea {
            anchors.fill: parent
        }

        Row {
            id: __row
            anchors.centerIn: parent
            spacing: 5

            HusText {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: __tag.tagData.label
                font: control.font
                color: control.colorTagText

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
            }

            HusIconText {
                id: __closeIcon
                anchors.verticalCenter: parent.verticalCenter
                colorIcon: __hoverHander.hovered ? control.themeSource.colorTagCloseHover : control.themeSource.colorTagClose
                iconSize: parseInt(control.themeSource.fontSize) - 2
                iconSource: HusIcon.CloseOutlined
                verticalAlignment: Text.AlignVCenter

                Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

                HoverHandler {
                    id: __hoverHander
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: __tapHander
                    onTapped: {
                        control.removeTagAtIndex(__tag.index);
                    }
                }
            }
        }
    }

    Behavior on colorTagText { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorTagBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    function findKey(key: string) {
        return __private.getData(key);
    }

    function filter() {
        model = options.filter(option => filterOption(text, option) === true);
    }

    function removeTagAtKey(key: string) {
        __private.remove(key);
    }

    function removeTagAtIndex(index: int) {
        if (index >= 0 && index < __tagListModel.count) {
            __private.removeAtIndex(index);
        }
    }

    function clearTag() {
        __private.clear();
    }

    function clearInput() {
        __input.clear();
        __input.textEdited();
    }

    function openPopup() {
        if (!__popup.opened)
            __popup.open();
    }

    function closePopup() {
        __popup.close();
    }

    onOptionsChanged: {
        if (genDefaultKey) {
            options.forEach(
                        (item, index) => {
                            if (!item.hasOwnProperty('key')) {
                                item.key = item.label;
                            }
                        });
        }
        filter();
    }
    onFilterOptionChanged: {
        filter();
    }

    objectName: '__HusMultiSelect__'
    themeSource: HusTheme.HusMultiSelect
    font {
        family: themeSource.fontFamily
        pixelSize: parseInt(themeSource.fontSize)
    }
    leftPadding: 2
    clearEnabled: false
    contentItem: Item {
        implicitHeight: Math.max(__flow.implicitHeight, 22)

        Loader {
            id: __prefixLoader
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.prefixDelegate
        }

        Loader {
            id: __suffixLoader
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: control.suffixDelegate
        }

        HusInput {
            id: __input
            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: __flow.left
            anchors.leftMargin: 2
            anchors.right: __flow.right
            background: Item { }
            animationEnabled: control.animationEnabled
            colorText: control.themeSource.colorText
            placeholderTextColor: control.themeSource.colorTextDisabled
            placeholderText: (__tagListModel.count > 0 || length > 0) ? '' : control.placeholderText
            font: control.font
            readOnly: !control.searchEnabled
            onTextEdited: {
                control.search(text);
                control.filter();
                if (control.model.length > 0)
                    control.openPopup();
                else
                    control.closePopup();
            }
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Backspace) {
                    if (length === 0 && __tagListModel.count > 0) {
                        control.removeTagAtIndex(__tagListModel.count - 1);
                    }
                }
            }

            TapHandler {
                onTapped: {
                    if (control.popup.opened) {
                        control.popup.close();
                    } else {
                        control.popup.open();
                    }
                }
            }
        }

        Flow {
            id: __flow
            anchors.left: __prefixLoader.right
            anchors.leftMargin: 4
            anchors.right: __suffixLoader.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.tagSpacing
            onPositioningComplete: {
                const item = __tagRepeater.itemAt(__tagListModel.count - 1);
                __input.leftPadding = item ? (item.x + item.width + 5) : 0;
                __input.topPadding = item ? item.y : 0;
            }

            Repeater {
                id: __tagRepeater
                model: ListModel { id: __tagListModel }
                delegate: control.tagDelegate
            }
        }
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
            clip: true
            model: control.popup.visible ? control.model : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.ItemDelegate {
                id: __popupDelegate

                required property var model
                required property int index
                property string key: model.key
                property bool selected: __private.selectedKeysMap.has(key)

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 5
                bottomPadding: 5
                enabled: (model.enabled ?? true) && ((!selected && control.maxTagCount >= 0) ? (__tagListModel.count < control.maxTagCount) : true)
                contentItem: HusText {
                    text: __popupDelegate.model[control.textRole]
                    color: __popupDelegate.enabled ? control.themeSource.colorItemText :
                                                     control.themeSource.colorItemTextDisabled
                    font {
                        family: control.themeSource.fontFamily
                        pixelSize: parseInt(control.themeSource.fontSize)
                        weight: selected ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter

                    HusIconText {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        colorIcon: control.themeSource.colorIconSelect
                        iconSize: 16
                        iconSource: HusIcon.CheckOutlined
                        visible: __popupDelegate.enabled && selected
                    }
                }
                background: HusRectangleInternal {
                    radius: control.radiusItemBg.all
                    topLeftRadius: control.radiusItemBg.topLeft
                    topRightRadius: control.radiusItemBg.topRight
                    bottomLeftRadius: control.radiusItemBg.bottomLeft
                    bottomRightRadius: control.radiusItemBg.bottomRight

                    color: {
                        if (__popupDelegate.selected) {
                            return control.themeSource.colorItemBgActive;
                        } else {
                            if (__popupDelegate.enabled)
                                return hovered ? control.themeSource.colorItemBgHover :
                                                 control.themeSource.colorItemBg;
                            else
                                return control.themeSource.colorItemBgDisabled;
                        }
                    }

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
                onClicked: {
                    control.currentIndex = index;
                    const data = __popupDelegate.model;
                    const key = data.key;
                    if (__private.contains(key)) {
                        __private.remove(key);
                    } else {
                        __private.insert(key, data);
                    }
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

    QtObject {
        id: __private

        property var selectedKeysMap: new Map

        function contains(key) {
            return selectedKeysMap.has(key);
        }

        function clear() {
            selectedKeysMap.forEach((value, key) => control.removeTag(value));
            __tagListModel.clear();
            selectedKeysMap = new Map;
            selectedKeysMapChanged();
        }

        function insert(key, data) {
            __tagListModel.append({ '__related__': key, 'tagData': data });
            selectedKeysMap.set(key, data);
            selectedKeysMapChanged();
            control.select(data);
        }

        function remove(key) {
            for (let i = 0; i < __tagListModel.count; i++) {
                if (__tagListModel.get(i).__related__ === key) {
                    const relatedKey = __tagListModel.get(i).__related__;
                    const data = selectedKeysMap.get(relatedKey);
                    __tagListModel.remove(i);
                    selectedKeysMap.delete(relatedKey);
                    selectedKeysMapChanged();
                    control.removeTag(data);
                    break;
                }
            }
        }

        function removeAtIndex(index) {
            const relatedKey = __tagListModel.get(index).__related__;
            const data = selectedKeysMap.get(relatedKey);
            __tagListModel.remove(index);
            selectedKeysMap.delete(relatedKey);
            selectedKeysMapChanged();
            control.removeTag(data);
        }

        function getData(key) {
            if (selectedKeysMap.has(key)) {
                return selectedKeysMap.get(key);
            }
            return undefined;
        }

        function updateSelectedKeys() {
            control.selectedKeys = [...selectedKeysMap.keys()];
        }

        onSelectedKeysMapChanged: updateSelectedKeys();
    }
}

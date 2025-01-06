import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import DelegateUI

Item {
    id: control
    clip: true

    property bool animationEnabled: DelTheme.animationEnabled
    property var initModel: []
    property alias count: __tabModel.count
    property alias currentIndex: __tabView.currentIndex
    property int tabType: DelTabViewType.Default
    property int tabSize: DelTabViewType.Auto
    property int tabPosition: DelTabViewType.Top
    property bool tabCentered: false
    property bool tabCardMovable: true
    property int defaultTabWidth: 80
    property int defaultTabHeight: DelTheme.DelTabView.fontSize + 16
    property int defaultTabSpacing: 2
    property int defaultTabBgRadius: DelTheme.DelTabView.radiusTabBg
    property int defaultHighlightWidth: __private.isHorizontal ? 30 : 20
    property var addTabCallback:
        () => {
            append({ title: `New Tab ${__tabView.count + 1}` });
            positionViewAtEnd();
        }
    property Component addButtonDelegate: DelCaptionButton {
        id: __addButton
        iconSize: DelTheme.DelTabView.fontSize
        iconSource: DelIcon.PlusOutlined
        colorIcon: DelTheme.DelTabView.colorTabCloseHover
        background: Rectangle {
            radius: DelTheme.DelTabView.radiusButton
            color: __addButton.colorBg
        }
        onClicked: addTabCallback();
    }
    property Component tabDelegate: tabType == DelTabViewType.Default ? __defaultTabDelegate : __cardTabDelegate
    property Component contentDelegate: Item { }
    property Component highlightDelegate: Item {
        Loader {
            id: __highlight
            width: __private.isHorizontal ? defaultHighlightWidth : 2
            height: __private.isHorizontal ? 2 : defaultHighlightWidth
            anchors {
                bottom: control.tabPosition == DelTabViewType.Top ? parent.bottom : undefined
                right: control.tabPosition == DelTabViewType.Left ? parent.right : undefined
            }
            state: __content.state
            states: [
                State {
                    name: "top"
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: parent.bottom
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: "bottom"
                    AnchorChanges {
                        target: __highlight
                        anchors.top: parent.top
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: "left"
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: parent.right
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: parent.verticalCenter
                    }
                },
                State {
                    name: "right"
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: parent.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            ]
            active: control.tabType === DelTabViewType.Default
            sourceComponent: Rectangle {
                color: DelTheme.isDark ? DelTheme.DelTabView.colorHightlightDark : DelTheme.DelTabView.colorHightlight
            }
        }
    }

    onInitModelChanged: {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    function flick(xVelocity: real, yVelocity: real) {
        __tabView.flick(xVelocity, yVelocity);
    }

    function positionViewAtBeginning() {
        __tabView.positionViewAtBeginning();
    }

    function positionViewAtIndex(index, mode) {
        __tabView.positionViewAtIndex(index, mode);
    }

    function positionViewAtEnd() {
        __tabView.positionViewAtEnd();
    }

    function get(index) {
        return __tabModel.get(index);
    }

    function set(index, object) {
        //默认为true
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.set(index, object);
    }

    function setProperty(index, propertyName, value) {
        __tabModel.setProperty(index, propertyName, value);
    }

    function move(from, to, count = 1) {
        __tabModel.move(from, to, count);
    }

    function insert(index, object) {
        //默认为true
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.insert(index, object);
    }

    function append(object) {
        //默认为true
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.append(object);
    }

    function removeAt(index, count = 1) {
        __tabModel.remove(index, count);
    }

    function clear() {
        __tabModel.clear();
    }

    Component {
        id: __defaultTabDelegate

        DelIconButton {
            id: __tabItem
            width: (!__private.isHorizontal && control.tabSize == DelTabViewType.Auto) ? Math.max(__private.tabMaxWidth, tabWidth) : tabWidth
            height: tabHeight
            leftPadding: 5
            rightPadding: 5
            iconSize: tabIconSize
            iconSource: tabIcon
            text: tabTitle
            effectEnabled: false
            colorBg: "transparent"
            colorBorder: "transparent"
            colorText: {
                if (isCurrent) {
                    return DelTheme.isDark ? DelTheme.DelTabView.colorHightlightDark : DelTheme.DelTabView.colorHightlight;
                } else {
                    return down ? DelTheme.DelTabView.colorTabActive :
                                  hovered ? DelTheme.DelTabView.colorTabHover :
                                            DelTheme.DelTabView.colorTab;
                }
            }
            font {
                family: DelTheme.DelTabView.fontFamily
                pixelSize: DelTheme.DelTabView.fontSize
            }
            contentItem: Item {
                implicitWidth: control.tabSize == DelTabViewType.Auto ? (__text.width + calcIconWidth) : __tabItem.tabFixedWidth
                implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

                property int calcIconWidth: iconSource == 0 ? 0 : (__icon.implicitWidth + __tabItem.tabIconSpacing)

                DelIconText {
                    id: __icon
                    width: iconSource == 0 ? 0 : implicitWidth
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: __tabItem.colorIcon
                    iconSize: __tabItem.iconSize
                    iconSource: __tabItem.iconSource
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: __tabItem.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
                }

                Text {
                    id: __text
                    width: control.tabSize == DelTabViewType.Auto ? implicitWidth :
                                                                    Math.max(0, __tabItem.tabFixedWidth - 5 - parent.calcIconWidth)
                    anchors.left: __icon.right
                    anchors.leftMargin: __icon.iconSource == 0 ? 0 : __tabItem.tabIconSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    text: __tabItem.text
                    font: __tabItem.font
                    color: __tabItem.colorText
                    elide: Text.ElideRight

                    Behavior on color { enabled: __tabItem.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
                }
            }
            onTabWidthChanged: {
                if (index == 0)
                    __private.tabMaxWidth = 0;
                __private.tabMaxWidth = Math.max(__private.tabMaxWidth, __tabItem.tabWidth);
            }
            onClicked: __tabView.currentIndex = index;

            required property int index
            required property var model
            property alias modelData: __tabItem.model
            property bool isCurrent: __tabView.currentIndex === index
            property string tabKey: modelData.key || ""
            property int tabIcon: modelData.icon || 0
            property int tabIconSize: modelData.iconSize || DelTheme.DelTabView.fontSize
            property int tabIconSpacing: modelData.iconSpacing || 5
            property string tabTitle: modelData.title || ""
            property int tabFixedWidth: modelData.tabWidth || defaultTabWidth
            property int tabWidth: control.tabSize == DelTabViewType.Auto ? (implicitContentWidth + leftPadding + rightPadding) :
                                                                            implicitContentWidth
            property int tabHeight: modelData.tabHeight || defaultTabHeight
        }
    }

    Component {
        id: __cardTabDelegate

        Item {
            id: __tabContainer
            width: __tabItem.width
            height: __tabItem.height

            required property int index
            required property var model
            property alias modelData: __tabContainer.model
            property alias tabItem: __tabItem
            property bool isCurrent: __tabView.currentIndex === index
            property string tabKey: modelData.key || ""
            property int tabIcon: modelData.icon || 0
            property int tabIconSize: modelData.iconSize || DelTheme.DelTabView.fontSize
            property int tabIconSpacing: modelData.iconSpacing || 5
            property string tabTitle: modelData.title || ""
            property int tabFixedWidth: modelData.tabWidth || defaultTabWidth
            property int tabWidth: __tabItem.calcWidth
            property int tabHeight: modelData.tabHeight || defaultTabHeight

            property bool tabEditable: modelData.editable && control.tabType == DelTabViewType.CardEditable

            onTabWidthChanged: {
                if (__private.needResetTabMaxWidth) {
                    __private.needResetTabMaxWidth = false;
                    __private.tabMaxWidth = 0;
                }
                __private.tabMaxWidth = Math.max(__private.tabMaxWidth, __tabItem.calcWidth);
            }

            DelRectangle {
                id: __tabItem
                width: (!__private.isHorizontal && control.tabSize == DelTabViewType.Auto) ? Math.max(__private.tabMaxWidth, tabWidth) : tabWidth
                height: tabHeight
                z: __dragHandler.drag.active ? 1 : 0
                color: {
                    if (DelTheme.isDark)
                        return isCurrent ? DelTheme.DelTabView.colorTabCardBgCheckedDark : DelTheme.DelTabView.colorTabCardBgDark;
                    else
                        return isCurrent ? DelTheme.DelTabView.colorTabCardBgChecked : DelTheme.DelTabView.colorTabCardBg;
                }
                border.color: DelTheme.DelTabView.colorTabCardBorder
                topLeftRadius: control.tabPosition == DelTabViewType.Top || control.tabPosition == DelTabViewType.Left ? defaultTabBgRadius : 0
                topRightRadius: control.tabPosition == DelTabViewType.Top || control.tabPosition == DelTabViewType.Right ? defaultTabBgRadius : 0
                bottomLeftRadius: control.tabPosition == DelTabViewType.Bottom || control.tabPosition == DelTabViewType.Left ? defaultTabBgRadius : 0
                bottomRightRadius: control.tabPosition == DelTabViewType.Bottom || control.tabPosition == DelTabViewType.Right ? defaultTabBgRadius : 0

                property int calcIconWidth: __icon.iconSource == 0 ? 0 : (__icon.implicitWidth + __tabContainer.tabIconSpacing)
                property int calcCloseWidth: __close.visible ? (__close.implicitWidth + 5) : 0
                property real calcWidth: control.tabSize == DelTabViewType.Auto ? (__text.width + calcIconWidth + calcCloseWidth + 10)
                                                                                : __tabContainer.tabFixedWidth
                property real calcHeight: Math.max(__icon.implicitHeight, __text.implicitHeight, __close.height)
                property color colorText: {
                    if (isCurrent) {
                        return DelTheme.isDark ? DelTheme.DelTabView.colorHightlightDark : DelTheme.DelTabView.colorHightlight;
                    } else {
                        return down ? DelTheme.DelTabView.colorTabActive :
                                      hovered ? DelTheme.DelTabView.colorTabHover :
                                                DelTheme.DelTabView.colorTab;
                    }
                }
                property bool down: false
                property bool hovered: false

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }

                MouseArea {
                    id: __dragHandler
                    anchors.fill: parent
                    hoverEnabled: true
                    drag.target: control.tabCardMovable ? __tabItem : null
                    drag.axis: __private.isHorizontal ? Drag.XAxis : Drag.YAxis
                    onEntered: __tabItem.hovered = true;
                    onExited: __tabItem.hovered = false;
                    onClicked: __tabView.currentIndex = index;
                    onPressed:
                        (mouse) => {
                            __tabView.currentIndex = index;
                            __tabItem.down = true;

                            if (control.tabCardMovable) {
                                const pos = __tabView.mapFromItem(__tabContainer, 0, 0);
                                __tabItem.parent = __tabView;
                                __tabItem.x = pos.x;
                                __tabItem.y = pos.y;
                            }
                        }
                    onPositionChanged: move();
                    onReleased: {
                        __keepMovingTimer.stop();
                        __tabItem.down = false;
                        __tabItem.parent = __tabContainer;
                        __tabItem.x = __tabItem.y = 0;
                        __tabView.forceLayout();
                    }

                    function move() {
                        if (pressed && control.tabCardMovable) {
                            if (!__keepMovingTimer.running)
                                __keepMovingTimer.restart();
                            const pos = __tabView.mapFromItem(__tabItem, width * 0.5, height * 0.5);
                            const item = __tabView.itemAt(pos.x + __tabView.contentX + 1, pos.y + __tabView.contentY + 1);
                            if (item) {
                                if (item.index !== __tabContainer.index) {
                                    __tabModel.move(item.index, __tabContainer.index, 1);
                                }
                            }
                        }
                    }

                    Timer {
                        id: __keepMovingTimer
                        repeat: true
                        interval: 100
                        onTriggered: __dragHandler.move();
                    }
                }

                DelIconText {
                    id: __icon
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    color: __tabItem.colorText
                    iconSize: tabIconSize
                    iconSource: tabIcon
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
                }

                Text {
                    id: __text
                    width: control.tabSize == DelTabViewType.Auto ? implicitWidth :
                                                                    Math.max(0, __tabContainer.tabFixedWidth - 5 - __tabItem.calcIconWidth - __tabItem.calcCloseWidth)
                    anchors.left: __icon.right
                    anchors.leftMargin: __icon.iconSource == 0 ? 0 : __tabContainer.tabIconSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    text: tabTitle
                    font {
                        family: DelTheme.DelTabView.fontFamily
                        pixelSize: DelTheme.DelTabView.fontSize
                    }
                    color: __tabItem.colorText
                    elide: Text.ElideRight

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }
                }

                DelCaptionButton {
                    id: __close
                    visible: __tabContainer.tabEditable
                    enabled: visible
                    implicitWidth: visible ? (implicitContentWidth + leftPadding + rightPadding) : 0
                    topPadding: 0
                    bottomPadding: 0
                    leftPadding: 2
                    rightPadding: 2
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    iconSize: tabIconSize
                    iconSource: DelIcon.CloseOutlined
                    colorIcon: hovered ? DelTheme.DelTabView.colorTabCloseHover : DelTheme.DelTabView.colorTabClose
                    onClicked: {
                        control.removeAt(index);
                    }
                }
            }
        }
    }

    Connections {
        target: control
        function onTabTypeChanged() {
            __private.needResetTabMaxWidth = true;
        }
        function onTabSizeChanged() {
            __private.needResetTabMaxWidth = true;
        }
    }

    QtObject {
        id: __private
        property bool isHorizontal: control.tabPosition == DelTabViewType.Top || control.tabPosition == DelTabViewType.Bottom
        property int tabMaxWidth: 0
        property bool needResetTabMaxWidth: false
    }

    MouseArea {
        anchors.fill: __tabView
        onWheel:
            (wheel) => {
                if (__private.isHorizontal)
                    __tabView.flick(wheel.angleDelta.y * 6.5, 0);
                else
                    __tabView.flick(0, wheel.angleDelta.y * 6.5);
            }
    }

    ListView {
        id: __tabView
        width: {
            if (__private.isHorizontal) {
                const maxWidth = control.width - (__addButtonLoader.width + 5) * (control.tabCentered ? 2 : 1);
                return (control.tabCentered ? Math.min(contentWidth, maxWidth) : maxWidth);
            } else {
                return __private.tabMaxWidth;
            }
        }
        height: {
            if (__private.isHorizontal) {
                return defaultTabHeight;
            } else {
                const maxHeight = control.height - (__addButtonLoader.height + 5) * (control.tabCentered ? 2 : 1);
                return (control.tabCentered ? Math.min(contentHeight, maxHeight) : maxHeight)
            }
        }
        clip: true
        onContentWidthChanged: if (__private.isHorizontal) cacheBuffer = contentWidth;
        onContentHeightChanged: if (!__private.isHorizontal) cacheBuffer = contentHeight;
        spacing: defaultTabSpacing
        move: Transition {
            enabled: control.animationEnabled
            NumberAnimation { properties: "x,y"; duration: DelTheme.Primary.durationMid }
        }
        model: ListModel { id: __tabModel }
        delegate: tabDelegate
        highlight: highlightDelegate
        highlightMoveDuration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
        orientation: __private.isHorizontal ? Qt.Horizontal : Qt.Vertical
        boundsBehavior: Flickable.StopAtBounds
        state: control.tabCentered ? (__content.state + "Center") : __content.state
        states: [
            State {
                name: "top"
                AnchorChanges {
                    target: __tabView
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: control.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "topCenter"
                AnchorChanges {
                    target: __tabView
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.horizontalCenter: control.horizontalCenter
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "bottom"
                AnchorChanges {
                    target: __tabView
                    anchors.top: undefined
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "bottomCenter"
                AnchorChanges {
                    target: __tabView
                    anchors.top: undefined
                    anchors.bottom: control.bottom
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.horizontalCenter: control.horizontalCenter
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "left"
                AnchorChanges {
                    target: __tabView
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: control.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "leftCenter"
                AnchorChanges {
                    target: __tabView
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.left: control.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: control.verticalCenter
                }
            },
            State {
                name: "right"
                AnchorChanges {
                    target: __tabView
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: control.right
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "rightCenter"
                AnchorChanges {
                    target: __tabView
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: control.right
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: control.verticalCenter
                }
            }
        ]
    }

    Loader {
        id: __addButtonLoader
        x: {
            switch (tabPosition) {
            case DelTabViewType.Top:
            case DelTabViewType.Bottom:
                return Math.min(__tabView.x + __tabView.contentWidth + 5, control.width - width);
            case DelTabViewType.Left:
                return Math.max(0, __tabView.width - width);
            case DelTabViewType.Right:
                return Math.max(0, __tabView.x);
            }
        }
        y: {
            switch (tabPosition) {
            case DelTabViewType.Top:
                return Math.max(0, __tabView.y + __tabView.contentHeight - height);
            case DelTabViewType.Bottom:
                return __tabView.y;
            case DelTabViewType.Left:
            case DelTabViewType.Right:
                return Math.min(__tabView.y + __tabView.contentHeight + 5, control.height - height);
            }
        }
        z: 10
        sourceComponent: addButtonDelegate
    }

    Item {
        id: __content
        state: {
            switch (tabPosition) {
            case DelTabViewType.Top: return "top";
            case DelTabViewType.Bottom: return "bottom";
            case DelTabViewType.Left: return "left";
            case DelTabViewType.Right: return "right";
            }
        }
        states: [
            State {
                name: "top"
                AnchorChanges {
                    target: __content
                    anchors.top: __tabView.bottom
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: control.right
                }
            },
            State {
                name: "bottom"
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: __tabView.top
                    anchors.left: control.left
                    anchors.right: control.right
                }
            },
            State {
                name: "left"
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: control.bottom
                    anchors.left: __tabView.right
                    anchors.right: control.right
                }
            },
            State {
                name: "right"
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: __tabView.left
                }
            }
        ]

        Repeater {
            model: __tabModel
            delegate: Loader {
                id: __contentLoader
                anchors.fill: parent
                sourceComponent: contentDelegate
                visible: __tabView.currentIndex === index
                required property int index
                required property var model
            }
        }
    }
}

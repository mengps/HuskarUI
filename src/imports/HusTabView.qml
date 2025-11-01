import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

Item {
    id: control
    clip: true

    enum TabPosition
    {
        Position_Top = 0,
        Position_Bottom = 1,
        Position_Left = 2,
        Position_Right = 3
    }

    enum TabType
    {
        Type_Default = 0,
        Type_Card = 1,
        Type_CardEditable = 2
    }

    enum TabSize
    {
        Size_Auto = 0,
        Size_Fixed = 1
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property var initModel: []
    property alias count: __tabModel.count
    property alias currentIndex: __tabView.currentIndex
    property int tabType: HusTabView.Type_Default
    property int tabSize: HusTabView.Size_Auto
    property int tabPosition: HusTabView.Position_Top
    property bool tabAddable: false
    property bool tabCentered: false
    property bool tabCardMovable: true
    property int defaultTabWidth: 80
    property int defaultTabHeight: parseInt(HusTheme.HusTabView.fontSize) + 16
    property int defaultTabSpacing: 2
    property int defaultTabBgRadius: HusTheme.HusTabView.radiusTabBg
    property int defaultHighlightWidth: __private.isHorizontal ? 30 : 20
    property var addTabCallback:
        () => {
            append({ title: `New Tab ${__tabView.count + 1}` });
            positionViewAtEnd();
        }
    property var closeTabCallback:
        (index, data) => {
            remove(index);
        }
    property Component addButtonDelegate: HusCaptionButton {
        id: __addButton
        animationEnabled: control.animationEnabled
        iconSize: parseInt(HusTheme.HusTabView.fontSize)
        iconSource: HusIcon.PlusOutlined
        colorIcon: HusTheme.HusTabView.colorTabCloseHover
        hoverCursorShape: Qt.PointingHandCursor
        radiusBg: HusTheme.HusTabView.radiusButton
        onClicked: addTabCallback();
    }
    property Component tabDelegate: tabType == HusTabView.Type_Default ? __defaultTabDelegate : __cardTabDelegate
    property Component contentDelegate: Item { }
    property Component highlightDelegate: Item {
        Loader {
            id: __highlight
            width: __private.isHorizontal ? defaultHighlightWidth : 2
            height: __private.isHorizontal ? 2 : defaultHighlightWidth
            anchors {
                bottom: control.tabPosition == HusTabView.Position_Top ? parent.bottom : undefined
                right: control.tabPosition == HusTabView.Position_Left ? parent.right : undefined
            }
            state: __content.state
            states: [
                State {
                    name: 'top'
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
                    name: 'bottom'
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
                    name: 'left'
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
                    name: 'right'
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
            active: control.tabType === HusTabView.Type_Default
            sourceComponent: Rectangle {
                color: HusTheme.isDark ? HusTheme.HusTabView.colorHightlightDark : HusTheme.HusTabView.colorHightlight
            }
        }
    }

    objectName: '__HusTabView__'
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
        /*! 默认为true */
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
        /*! 默认为true */
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.insert(index, object);
    }

    function append(object) {
        /*! 默认为true */
        if (object.editable === undefined)
            object.editable = true;
        __tabModel.append(object);
    }

    function remove(index, count = 1) {
        __tabModel.remove(index, count);
    }

    function clear() {
        __tabModel.clear();
    }

    Component {
        id: __defaultTabDelegate

        HusIconButton {
            id: __tabItem
            width: (!__private.isHorizontal && control.tabSize == HusTabView.Size_Auto) ? Math.max(__private.tabMaxWidth, tabWidth) : tabWidth
            height: tabHeight
            leftPadding: 5
            rightPadding: 5
            iconSize: tabIconSize
            iconSource: tabIcon
            text: tabTitle
            animationEnabled: control.animationEnabled
            effectEnabled: false
            colorBg: 'transparent'
            colorBorder: 'transparent'
            colorText: {
                if (isCurrent) {
                    return HusTheme.isDark ? HusTheme.HusTabView.colorHightlightDark : HusTheme.HusTabView.colorHightlight;
                } else {
                    return down ? HusTheme.HusTabView.colorTabActive :
                                  hovered ? HusTheme.HusTabView.colorTabHover :
                                            HusTheme.HusTabView.colorTab;
                }
            }
            font {
                family: HusTheme.HusTabView.fontFamily
                pixelSize: parseInt(HusTheme.HusTabView.fontSize)
            }
            contentItem: Item {
                implicitWidth: control.tabSize == HusTabView.Size_Auto ? (__text.width + calcIconWidth) : __tabItem.tabFixedWidth
                implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

                property int calcIconWidth: __icon.empty ? 0 : (__icon.implicitWidth + __tabItem.tabIconSpacing)

                HusIconText {
                    id: __icon
                    width: empty ? 0 : implicitWidth
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: __tabItem.colorIcon
                    iconSize: __tabItem.iconSize
                    iconSource: __tabItem.iconSource
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }

                HusText {
                    id: __text
                    width: control.tabSize == HusTabView.Size_Auto ? implicitWidth :
                                                                     Math.max(0, __tabItem.tabFixedWidth - 5 - parent.calcIconWidth)
                    anchors.left: __icon.right
                    anchors.leftMargin: __icon.empty ? 0 : __tabItem.tabIconSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    text: __tabItem.text
                    font: __tabItem.font
                    color: __tabItem.colorText
                    elide: Text.ElideRight

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
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
            property string tabKey: modelData.key || ''
            property var tabIcon: modelData.iconSource || 0
            property int tabIconSize: modelData.iconSize || parseInt(HusTheme.HusTabView.fontSize)
            property int tabIconSpacing: modelData.iconSpacing || 5
            property string tabTitle: modelData.title || ''
            property int tabFixedWidth: modelData.tabWidth || defaultTabWidth
            property int tabWidth: control.tabSize == HusTabView.Size_Auto ? (implicitContentWidth + leftPadding + rightPadding) :
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
            property string tabKey: modelData.key || ''
            property var tabIcon: modelData.iconSource || 0
            property int tabIconSize: modelData.iconSize || parseInt(HusTheme.HusTabView.fontSize)
            property int tabIconSpacing: modelData.iconSpacing || 5
            property string tabTitle: modelData.title || ''
            property int tabFixedWidth: modelData.tabWidth || defaultTabWidth
            property int tabWidth: __tabItem.calcWidth
            property int tabHeight: modelData.tabHeight || defaultTabHeight

            property bool tabEditable: modelData.editable && control.tabType == HusTabView.Type_CardEditable

            onTabWidthChanged: {
                if (__private.needResetTabMaxWidth) {
                    __private.needResetTabMaxWidth = false;
                    __private.tabMaxWidth = 0;
                }
                __private.tabMaxWidth = Math.max(__private.tabMaxWidth, __tabItem.calcWidth);
            }

            HusRectangleInternal {
                id: __tabItem
                width: (!__private.isHorizontal && control.tabSize == HusTabView.Size_Auto) ? Math.max(__private.tabMaxWidth, tabWidth) : tabWidth
                height: tabHeight
                z: __dragHandler.drag.active ? 1 : 0
                color: {
                    if (HusTheme.isDark)
                        return isCurrent ? HusTheme.HusTabView.colorTabCardBgCheckedDark : HusTheme.HusTabView.colorTabCardBgDark;
                    else
                        return isCurrent ? HusTheme.HusTabView.colorTabCardBgChecked : HusTheme.HusTabView.colorTabCardBg;
                }
                border.color: HusTheme.HusTabView.colorTabCardBorder
                topLeftRadius: control.tabPosition == HusTabView.Position_Top || control.tabPosition == HusTabView.Position_Left ? defaultTabBgRadius : 0
                topRightRadius: control.tabPosition == HusTabView.Position_Top || control.tabPosition == HusTabView.Position_Right ? defaultTabBgRadius : 0
                bottomLeftRadius: control.tabPosition == HusTabView.Position_Bottom || control.tabPosition == HusTabView.Position_Left ? defaultTabBgRadius : 0
                bottomRightRadius: control.tabPosition == HusTabView.Position_Bottom || control.tabPosition == HusTabView.Position_Right ? defaultTabBgRadius : 0

                property bool down: false
                property bool hovered: false
                property int calcIconWidth: __icon.empty ? 0 : (__icon.implicitWidth + __tabContainer.tabIconSpacing)
                property int calcCloseWidth: __close.visible ? (__close.implicitWidth + 5) : 0
                property real calcWidth: control.tabSize == HusTabView.Size_Auto ? (__text.width + calcIconWidth + calcCloseWidth + 10)
                                                                                 : __tabContainer.tabFixedWidth
                property real calcHeight: Math.max(__icon.implicitHeight, __text.implicitHeight, __close.height)
                property color colorText: {
                    if (isCurrent) {
                        return HusTheme.isDark ? HusTheme.HusTabView.colorHightlightDark : HusTheme.HusTabView.colorHightlight;
                    } else {
                        return down ? HusTheme.HusTabView.colorTabActive :
                                      hovered ? HusTheme.HusTabView.colorTabHover :
                                                HusTheme.HusTabView.colorTab;
                    }
                }

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

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

                HusIconText {
                    id: __icon
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    color: __tabItem.colorText
                    iconSize: tabIconSize
                    iconSource: tabIcon
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }

                HusText {
                    id: __text
                    width: control.tabSize == HusTabView.Size_Auto ? implicitWidth :
                                                                     Math.max(0, __tabContainer.tabFixedWidth - 5 - __tabItem.calcIconWidth - __tabItem.calcCloseWidth)
                    anchors.left: __icon.right
                    anchors.leftMargin: __icon.empty ? 0 : __tabContainer.tabIconSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    text: tabTitle
                    font {
                        family: HusTheme.HusTabView.fontFamily
                        pixelSize: parseInt(HusTheme.HusTabView.fontSize)
                    }
                    color: __tabItem.colorText
                    elide: Text.ElideRight

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }

                HusCaptionButton {
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
                    animationEnabled: control.animationEnabled
                    hoverCursorShape: Qt.PointingHandCursor
                    iconSize: tabIconSize
                    iconSource: HusIcon.CloseOutlined
                    colorIcon: hovered ? HusTheme.HusTabView.colorTabCloseHover : HusTheme.HusTabView.colorTabClose
                    onClicked: {
                        control.closeTabCallback(__tabContainer.index, __tabContainer.model);
                    }

                    HoverHandler {
                        cursorShape: Qt.PointingHandCursor
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
        property bool isHorizontal: control.tabPosition == HusTabView.Position_Top || control.tabPosition == HusTabView.Position_Bottom
        property int tabMaxWidth: 0
        property bool needResetTabMaxWidth: false
    }

    MouseArea {
        anchors.fill: __tabView
        onWheel: function(wheel) {
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
            NumberAnimation { properties: 'x,y'; duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 }
        }
        model: ListModel { id: __tabModel }
        delegate: tabDelegate
        highlight: highlightDelegate
        highlightMoveDuration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
        orientation: __private.isHorizontal ? Qt.Horizontal : Qt.Vertical
        boundsBehavior: Flickable.StopAtBounds
        state: control.tabCentered ? (__content.state + 'Center') : __content.state
        states: [
            State {
                name: 'top'
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
                name: 'topCenter'
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
                name: 'bottom'
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
                name: 'bottomCenter'
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
                name: 'left'
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
                name: 'leftCenter'
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
                name: 'right'
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
                name: 'rightCenter'
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
        active: control.tabAddable
        x: {
            switch (tabPosition) {
            case HusTabView.Position_Top:
            case HusTabView.Position_Bottom:
                return Math.min(__tabView.x + __tabView.contentWidth + 5, control.width - width);
            case HusTabView.Position_Left:
                return Math.max(0, __tabView.width - width);
            case HusTabView.Position_Right:
                return Math.max(0, __tabView.x);
            }
        }
        y: {
            switch (tabPosition) {
            case HusTabView.Position_Top:
                return Math.max(0, __tabView.y + __tabView.height - height);
            case HusTabView.Position_Bottom:
                return __tabView.y;
            case HusTabView.Position_Left:
            case HusTabView.Position_Right:
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
            case HusTabView.Position_Top: return 'top';
            case HusTabView.Position_Bottom: return 'bottom';
            case HusTabView.Position_Left: return 'left';
            case HusTabView.Position_Right: return 'right';
            }
        }
        states: [
            State {
                name: 'top'
                AnchorChanges {
                    target: __content
                    anchors.top: __tabView.bottom
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: control.right
                }
            },
            State {
                name: 'bottom'
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: __tabView.top
                    anchors.left: control.left
                    anchors.right: control.right
                }
            },
            State {
                name: 'left'
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: control.bottom
                    anchors.left: __tabView.right
                    anchors.right: control.right
                }
            },
            State {
                name: 'right'
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

import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

Item {
    id: control

    signal actived(key: string)

    property bool animationEnabled: HusTheme.animationEnabled
    property int hoverCursorShape: Qt.PointingHandCursor
    property var initModel: []
    property alias count: __listModel.count
    property alias spacing: __listView.spacing
    property bool accordion: false
    property var activeKey: accordion ? '' : []
    property var defaultActiveKey: []
    property var expandIcon: HusIcon.RightOutlined || ''
    property font titleFont: Qt.font({
                                         family: HusTheme.HusCollapse.fontFamily,
                                         pixelSize: parseInt(HusTheme.HusCollapse.fontSizeTitle)
                                     })
    property color colorBg: HusTheme.HusCollapse.colorBg
    property color colorIcon: HusTheme.HusCollapse.colorIcon
    property color colorTitle: HusTheme.HusCollapse.colorTitle
    property color colorTitleBg: HusTheme.HusCollapse.colorTitleBg
    property font contentFont: Qt.font({
                                           family: HusTheme.HusCollapse.fontFamily,
                                           pixelSize: parseInt(HusTheme.HusCollapse.fontSizeContent)
                                       })
    property color colorContent: HusTheme.HusCollapse.colorContent
    property color colorContentBg: HusTheme.HusCollapse.colorContentBg
    property color colorBorder: HusTheme.isDark ? HusTheme.HusCollapse.colorBorderDark : HusTheme.HusCollapse.colorBorder
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusCollapse.radiusBg }
    property Component titleDelegate: Row {
        leftPadding: 16
        rightPadding: 16
        height: Math.max(40, __icon.height, __title.height)
        spacing: 8

        HusIconText {
            id: __icon
            anchors.verticalCenter: parent.verticalCenter
            iconSource: control.expandIcon
            colorIcon: control.colorIcon
            rotation: isActive ? 90 : 0

            Behavior on rotation { enabled: control.animationEnabled; RotationAnimation { duration: HusTheme.Primary.durationFast } }
        }

        HusText {
            id: __title
            anchors.verticalCenter: parent.verticalCenter
            text: model.title
            elide: Text.ElideRight
            font: control.titleFont
            color: control.colorTitle
        }

        HoverHandler {
            cursorShape: control.hoverCursorShape
        }
    }
    property Component contentDelegate: HusCopyableText {
        padding: 16
        topPadding: 8
        bottomPadding: 8
        text: model.content
        font: control.contentFont
        wrapMode: Text.WordWrap
        color: control.colorContent
    }

    objectName: '__HusCollapse__'
    height: __listView.contentHeight
    onInitModelChanged: {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    function get(index) {
        return __listModel.get(index);
    }

    function set(index, object) {
        __listModel.set(index, object);
    }

    function setProperty(index, propertyName, value) {
        __listModel.setProperty(index, propertyName, value);
    }

    function move(from, to, count = 1) {
        __listModel.move(from, to, count);
    }

    function insert(index, object) {
        __listModel.insert(index, object);
    }

    function append(object) {
        __listModel.append(object);
    }

    function remove(index, count = 1) {
        __listModel.remove(index, count);
    }

    function clear() {
        __listModel.clear();
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorTitle { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorTitleBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorContent { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
    Behavior on colorContentBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

    QtObject {
        id: __private
        function calcActiveKey() {
            if (control.accordion) {
                for (let i = 0; i < __listView.count; i++) {
                    const item = __listView.itemAtIndex(i);
                    if (item && item.active) {
                        control.activeKey = item.model.key;
                        break;
                    }
                }
            } else {
                let keys = [];
                for (let i = 0; i < __listView.count; i++) {
                    const item = __listView.itemAtIndex(i);
                    if (item && item.active) {
                        keys.push(item.model.key);
                    }
                }
                control.activeKey = keys;
            }
        }
    }

    ListView {
        id: __listView
        property real realHeight: 0
        anchors.fill: parent
        interactive: false
        spacing: -1
        model: ListModel { id: __listModel }
        onContentHeightChanged: realHeight = Math.max(contentHeight, 0);
        onRealHeightChanged: cacheBuffer = realHeight;
        delegate: HusRectangleInternal {
            id: __rootItem
            width: __listView.width
            height: __column.height + ((detached && active) ? 1 : 0)
            topLeftRadius: (isStart || detached) ? control.radiusBg.topLeft : 0
            topRightRadius: (isStart || detached) ? control.radiusBg.topRight : 0
            bottomLeftRadius: (isEnd || detached) ? control.radiusBg.bottomLeft : 0
            bottomRightRadius: (isEnd || detached) ? control.radiusBg.bottomRight : 0
            color: control.colorBg
            border.color: control.colorBorder
            border.width: detached ? 1 : 0
            clip: true

            required property var model
            required property int index
            property bool isStart: index == 0
            property bool isEnd: (index + 1) === control.count
            property bool active: false
            property bool detached: __listView.spacing !== -1

            Component.onCompleted: {
                if (control.defaultActiveKey.indexOf(model.key) != -1)
                    active = true;
            }

            Column {
                id: __column
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter

                HusRectangleInternal {
                    width: parent.width
                    height: __titleLoader.height
                    topLeftRadius: (isStart || detached) ? control.radiusBg.topLeft : 0
                    topRightRadius: (isStart || detached) ? control.radiusBg.topRight : 0
                    bottomLeftRadius: (isEnd && !active) || (detached && !active) ? control.radiusBg.bottomLeft : 0
                    bottomRightRadius: (isEnd && !active) || (detached && !active) ? control.radiusBg.bottomRight : 0
                    color: control.colorTitleBg
                    border.color: control.colorBorder

                    Loader {
                        id: __titleLoader
                        width: parent.width
                        sourceComponent: titleDelegate
                        property alias model: __rootItem.model
                        property alias index: __rootItem.index
                        property alias isActive: __rootItem.active

                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            onTapped: {
                                if (control.accordion) {
                                    for (let i = 0; i < __listView.count; i++) {
                                        const item = __listView.itemAtIndex(i);
                                        if (item && item !== __rootItem) {
                                            item.active = false;
                                        }
                                    }
                                    __rootItem.active = !__rootItem.active;
                                } else {
                                    __rootItem.active = !__rootItem.active;
                                }
                                if (__rootItem.active)
                                    control.actived(__rootItem.model.key);
                                __private.calcActiveKey();
                            }
                        }
                    }
                }

                HusRectangleInternal {
                    width: parent.width - __rootItem.border.width * 2
                    height: active ? __contentLoader.height : 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    bottomLeftRadius: control.radiusBg.bottomLeft
                    bottomRightRadius: control.radiusBg.bottomRight
                    color: control.colorContentBg
                    clip: true

                    Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationFast } }

                    Loader {
                        id: __contentLoader
                        width: parent.width
                        anchors.centerIn: parent
                        sourceComponent: control.contentDelegate
                        property alias model: __rootItem.model
                        property alias index: __rootItem.index
                        property alias isActive: __rootItem.active
                    }
                }
            }
        }
    }

    Loader {
        anchors.fill: __listView
        active: spacing === -1
        sourceComponent: Rectangle {
            color: 'transparent'
            border.color: control.colorBorder
            radius: control.radiusBg.all
            topLeftRadius: control.radiusBg.topLeft
            topRightRadius: control.radiusBg.topRight
            bottomLeftRadius: control.radiusBg.bottomLeft
            bottomRightRadius: control.radiusBg.bottomRight
        }
    }
}

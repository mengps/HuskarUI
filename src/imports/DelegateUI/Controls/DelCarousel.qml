import QtQuick
import DelegateUI

Item {
    id: control

    enum Position
    {
        Position_Top = 0,
        Position_Bottom = 1,
        Position_Left = 2,
        Position_Right = 3
    }

    property bool animationEnabled: DelTheme.animationEnabled
    property var initModel: []
    property int currentIndex: -1
    property int position: DelCarousel.Position_Bottom
    property int speed: 500
    property bool infinite: true
    property bool autoplay: false
    property int autoplaySpeed: 3000
    property bool draggable: true
    property bool showIndicator: true
    property int indicatorSpacing: 6
    property bool showArrow: false
    property Component contentDelegate: Item { }
    property Component indicatorDelegate: Rectangle {
        width: isHorizontal ? __width : __height
        height: isHorizontal ? __height : __width
        color: isCurrent ? DelTheme.DelCarousel.colorIndicatorActive :
                           hovered ? DelTheme.DelCarousel.colorIndicatorHover : DelTheme.DelCarousel.colorIndicator
        radius: 2

        required property int index
        required property var model
        property bool isHorizontal: control.position === DelCarousel.Position_Top || control.position === DelCarousel.Position_Bottom
        property bool isCurrent: index == control.currentIndex
        property bool hovered: __hoverHandler.hovered

        property int __width: isCurrent ? __private.indicatorWidth + 10 : __private.indicatorWidth
        property int __height: 4

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }
        Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: DelTheme.Primary.durationMid } }

        HoverHandler {
            id: __hoverHandler
            cursorShape: Qt.PointingHandCursor
        }

        TapHandler {
            onTapped: {
                control.swithTo(index);
            }
        }
    }
    property Component prevDelegate: DelIconButton {
        padding: 5
        iconSource: __private.isHorizontal ? DelIcon.LeftOutlined : DelIcon.UpOutlined
        iconSize: 20
        colorIcon: hovered ? DelTheme.DelCarousel.colorArrowHover : DelTheme.DelCarousel.colorArrow
        type: DelButton.Type_Link
        onClicked: control.swithToPrev();
    }
    property Component nextDelegate: DelIconButton {
        padding: 5
        iconSource: __private.isHorizontal ? DelIcon.RightOutlined : DelIcon.DownOutlined
        iconSize: 20
        colorIcon: hovered ? DelTheme.DelCarousel.colorArrowHover : DelTheme.DelCarousel.colorArrow
        type: DelButton.Type_Link
        onClicked: control.swithToNext();
    }

    onInfiniteChanged: __private.updateModel();
    onInitModelChanged: __private.updateModel();

    function swithTo(index, animated = true) {
        if (animated)
            __listView.currentIndex = infinite ? index + 1 : index;
        else
            __listView.positionViewAtIndex(infinite ? 1 : 0, ListView.SnapPosition);
    }

    function swithToPrev() {
        if (infinite && __listView.currentIndex === 0) {
            __listView.positionViewAtIndex(__listView.count - 2, ListView.SnapPosition);
            __listView.decrementCurrentIndex();
        } else {
            __listView.decrementCurrentIndex();
        }
    }

    function swithToNext() {
        if (infinite && __listView.currentIndex === __listView.count - 1) {
            __listView.positionViewAtIndex(1, ListView.SnapPosition);
            __listView.incrementCurrentIndex();
        } else {
            __listView.incrementCurrentIndex();
        }
    }

    function getSuitableIndicatorWidth(contentWidth) {
        const max = 18;
        let indicatorWidth = 0;
        let totalWidth = 0;
        do {
            if (indicatorWidth >= max) break;
            totalWidth = (++indicatorWidth) * __listModel.count + indicatorSpacing * (__listModel.count - 1) + max;
        } while (totalWidth < contentWidth);

        return indicatorWidth;
    }

    QtObject {
        id: __private
        property bool isHorizontal: control.position === DelCarousel.Position_Top || control.position === DelCarousel.Position_Bottom
        property int indicatorWidth: control.getSuitableIndicatorWidth(__listView.width)

        function updateModel() {
            if (control.initModel.length > 0) {
                const model = control.infinite ? [control.initModel[control.initModel.length - 1], ...control.initModel, control.initModel[0]] :
                                                 [...control.initModel];
                __listModel.clear();
                for (const item of model) {
                    __listModel.append(item);
                }
                __resetTimer.restart();
            } else {
                __listModel.clear();
            }
        }

        function getVirtualModelIndex(index) {
            if (control.infinite) {
                if (index === 0) {
                    return 1;
                } else if (index === (__listModel.count - 2)) {
                    return __listModel.count - 1;
                } else {
                    return index + 1;
                }
            } else {
                return index;
            }
        }

        function getRealModelIndex(index) {
            if (control.infinite) {
                if (index === 0) {
                    return __listModel.count - 3;
                } else if ((index) === (__listModel.count - 1)) {
                    return 0;
                } else {
                    return index - 1;
                }
            } else {
                return index;
            }
        }
    }

    Timer {
        id: __resetTimer
        interval: 33
        onTriggered: {
            __listView.positionViewAtIndex(control.infinite ? 1 : 0, ListView.SnapPosition);
        }
    }

    Timer {
        id: __autoplayTimer
        repeat: true
        interval: control.autoplaySpeed
        running: control.autoplay
        onTriggered: {
            control.swithToNext();
        }
    }

    ListView {
        id: __listView
        anchors.fill: parent
        clip: true
        interactive: control.draggable
        orientation: __private.isHorizontal ? Qt.Horizontal : Qt.Vertical
        snapMode: ListView.SnapOneItem
        highlightMoveDuration: control.animationEnabled ? control.speed : 0
        highlightRangeMode: ListView.StrictlyEnforceRange
        boundsBehavior: ListView.StopAtBounds
        model: ListModel { id: __listModel }
        delegate: Item {
            id: __rootItem
            width: __listView.width
            height: __listView.height

            required property var model
            required property int index

            Loader {
                anchors.fill: parent
                sourceComponent: control.contentDelegate
                property alias model: __rootItem.model
                property int index: __private.getRealModelIndex(__rootItem.index)
            }
        }
        onCurrentIndexChanged: {
            control.currentIndex = __private.getRealModelIndex(currentIndex);
        }
        onOrientationChanged: {
            positionViewAtIndex(control.infinite ? 1 : 0, ListView.SnapPosition);
        }
        onFlickStarted: updateInfiniteIndex();
        onDragStarted: updateInfiniteIndex();
        onMovementEnded: updateInfiniteIndex();

        function updateInfiniteIndex() {
            if (control.infinite) {
                if (__listView.currentIndex === 0) {
                    __listView.positionViewAtIndex(count - 2, ListView.SnapPosition);
                } else if (__listView.currentIndex === count - 1) {
                    __listView.positionViewAtIndex(1, ListView.SnapPosition);
                }
            }
        }

        Loader {
            active: control.position ===  DelCarousel.Position_Top && control.showIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:  parent.top
            anchors.topMargin: 10
            sourceComponent: Row {
                spacing: control.indicatorSpacing
                Repeater {
                    model: control.initModel
                    delegate: control.indicatorDelegate
                }
            }
        }

        Loader {
            active: control.position === DelCarousel.Position_Bottom && control.showIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            sourceComponent: Row {
                spacing: control.indicatorSpacing
                Repeater {
                    model: control.initModel
                    delegate: control.indicatorDelegate
                }
            }
        }

        Loader {
            active: control.position === DelCarousel.Position_Left && control.showIndicator
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            sourceComponent: Column {
                spacing: control.indicatorSpacing
                Repeater {
                    model: control.initModel
                    delegate: control.indicatorDelegate
                }
            }
        }

        Loader {
            active: control.position === DelCarousel.Position_Right && control.showIndicator
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            sourceComponent: Column {
                spacing: control.indicatorSpacing
                Repeater {
                    model: control.initModel
                    delegate: control.indicatorDelegate
                }
            }
        }

        Loader {
            active: control.showArrow && showPrev
            anchors.verticalCenter: __private.isHorizontal ? parent.verticalCenter : undefined
            anchors.horizontalCenter: !__private.isHorizontal ? parent.horizontalCenter : undefined
            anchors.top: !__private.isHorizontal ? parent.top : undefined
            anchors.left: __private.isHorizontal ? parent.left : undefined
            sourceComponent: control.prevDelegate
            property bool showPrev: control.infinite ? true : (control.currentIndex !== 0)
        }

        Loader {
            active: control.showArrow && showNext
            anchors.verticalCenter: __private.isHorizontal ? parent.verticalCenter : undefined
            anchors.horizontalCenter: !__private.isHorizontal ? parent.horizontalCenter : undefined
            anchors.bottom: !__private.isHorizontal ? parent.bottom : undefined
            anchors.right: __private.isHorizontal ? parent.right : undefined
            sourceComponent: control.nextDelegate
            property bool showNext: control.infinite ? true : (control.currentIndex !== __listModel.count - 1)
        }
    }
}

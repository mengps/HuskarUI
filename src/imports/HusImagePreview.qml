import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

HusPopup {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled

    property real scaleMin: 1.0
    property real scaleMax: 5.0
    property real scaleStep: 0.5

    readonly property alias currentScale: __private.scale
    readonly property alias currentRotation: __private.rotation

    property var items: []
    property alias currentIndex: __listView.currentIndex
    readonly property alias count: __listView.count

    property Component sourceDelegate: Image {
        source: sourceUrl
        fillMode: Image.PreserveAspectFit
        onStatusChanged: {
            if (status == Image.Ready)
                control.resetTransform();
        }
    }
    property Component closeDelegate: HusIconButton {
        topPadding: 10
        bottomPadding: 10
        animationEnabled: control.animationEnabled
        effectEnabled: false
        iconSource: HusIcon.CloseOutlined
        iconSize: 20
        shape: HusButton.Shape_Circle
        type: HusButton.Type_Default
        colorIcon: HusTheme.HusImage.colorButtonTextHover
        colorBg: hovered ? HusTheme.HusImage.colorButtonBgHover : HusTheme.HusImage.colorButtonBg
        colorBorder: colorBg
        onClicked: control.close();
    }
    property Component prevDelegate: HusIconButton {
        topPadding: 10
        bottomPadding: 10
        animationEnabled: control.animationEnabled
        effectEnabled: false
        iconSource: HusIcon.LeftOutlined
        iconSize: 20
        shape: HusButton.Shape_Circle
        type: HusButton.Type_Default
        hoverCursorShape: control.currentIndex <= 0 ? Qt.ForbiddenCursor : Qt.PointingHandCursor
        colorIcon: control.currentIndex <= 0 ? HusTheme.HusImage.colorButtonText :
                                               HusTheme.HusImage.colorButtonTextHover
        colorBg: control.currentIndex <= 0 ?
                     'transparent' : hovered ? HusTheme.HusImage.colorButtonBgHover :
                                               HusTheme.HusImage.colorButtonBg
        colorBorder: 'transparent'
        onClicked: control.decrementCurrentIndex();
    }
    property Component nextDelegate: HusIconButton {
        topPadding: 10
        bottomPadding: 10
        animationEnabled: control.animationEnabled
        effectEnabled: false
        iconSource: HusIcon.RightOutlined
        iconSize: 20
        shape: HusButton.Shape_Circle
        type: HusButton.Type_Default
        hoverCursorShape: control.currentIndex >= (control.count - 1) ? Qt.ForbiddenCursor : Qt.PointingHandCursor
        colorIcon: control.currentIndex >= (control.count - 1) ? HusTheme.HusImage.colorButtonText :
                                                                 HusTheme.HusImage.colorButtonTextHover
        colorBg: control.currentIndex >= (control.count - 1) ?
                     'transparent' : hovered ? HusTheme.HusImage.colorButtonBgHover :
                                               HusTheme.HusImage.colorButtonBg
        colorBorder: 'transparent'
        onClicked: control.incrementCurrentIndex();
    }
    property Component indicatorDelegate: HusText {
        color: HusTheme.HusImage.colorIndicatorText
        text: `${control.currentIndex + 1} / ${control.count}`
        font {
            family: HusTheme.HusImage.fontFamily
            pixelSize: parseInt(HusTheme.HusImage.fontSize) + 1
        }
    }
    property Component operationDelegate: MouseArea {
        width: 380
        height: 40
        hoverEnabled: true

        Rectangle {
            id: __operations
            anchors.fill: parent
            radius: height * 0.5
            color: HusTheme.HusImage.colorOperationBg

            Row {
                anchors.centerIn: parent

                HusIconButton {
                    animationEnabled: control.animationEnabled
                    type: HusButton.Type_Link
                    iconSource: HusIcon.SwapOutlined
                    colorIcon: hovered ? HusTheme.HusImage.colorButtonTextHover : HusTheme.HusImage.colorButtonText
                    iconSize: 20
                    contentItem: HusIconText {
                        color: parent.colorIcon
                        iconSource: parent.iconSource
                        iconSize: parent.iconSize
                        rotation: 90
                    }
                    onClicked: control.flipY();

                    HusToolTip {
                        animationEnabled: control.animationEnabled
                        visible: parent.hovered
                        text: qsTr('垂直翻转')
                    }
                }

                HusIconButton {
                    animationEnabled: control.animationEnabled
                    type: HusButton.Type_Link
                    iconSource: HusIcon.SwapOutlined
                    colorIcon: hovered ? HusTheme.HusImage.colorButtonTextHover : HusTheme.HusImage.colorButtonText
                    iconSize: 20
                    onClicked: control.flipX();

                    HusToolTip {
                        animationEnabled: control.animationEnabled
                        visible: parent.hovered
                        text: qsTr('水平翻转')
                    }
                }

                HusIconButton {
                    animationEnabled: control.animationEnabled
                    type: HusButton.Type_Link
                    iconSource: HusIcon.RotateLeftOutlined
                    colorIcon: hovered ? HusTheme.HusImage.colorButtonTextHover : HusTheme.HusImage.colorButtonText
                    iconSize: 20
                    onClicked: control.rotate(-90);

                    HusToolTip {
                        animationEnabled: control.animationEnabled
                        visible: parent.hovered
                        text: qsTr('向左旋转')
                    }
                }

                HusIconButton {
                    animationEnabled: control.animationEnabled
                    type: HusButton.Type_Link
                    iconSource: HusIcon.RotateRightOutlined
                    colorIcon: hovered ? HusTheme.HusImage.colorButtonTextHover : HusTheme.HusImage.colorButtonText
                    iconSize: 20
                    onClicked: control.rotate(90);

                    HusToolTip {
                        animationEnabled: control.animationEnabled
                        visible: parent.hovered
                        text: qsTr('向右旋转')
                    }
                }

                HusIconButton {
                    animationEnabled: control.animationEnabled
                    type: HusButton.Type_Link
                    iconSource: HusIcon.ZoomOutOutlined
                    hoverCursorShape: control.currentScale > control.scaleMin ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                    colorIcon: control.currentScale > control.scaleMin ?
                                   hovered ? HusTheme.HusImage.colorButtonTextHover :
                                             HusTheme.HusImage.colorButtonText : HusTheme.HusImage.colorButtonTextDisabled
                    iconSize: 20
                    onClicked: control.zoomOut();

                    HusToolTip {
                        animationEnabled: control.animationEnabled
                        visible: parent.hovered
                        text: qsTr('缩小')
                    }
                }

                HusIconButton {
                    animationEnabled: control.animationEnabled
                    type: HusButton.Type_Link
                    iconSource: HusIcon.ZoomInOutlined
                    hoverCursorShape: control.currentScale < control.scaleMax ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                    colorIcon: control.currentScale < control.scaleMax ?
                                   hovered ? HusTheme.HusImage.colorButtonTextHover :
                                             HusTheme.HusImage.colorButtonText : HusTheme.HusImage.colorButtonTextDisabled
                    iconSize: 20
                    onClicked: control.zoomIn();

                    HusToolTip {
                        animationEnabled: control.animationEnabled
                        visible: parent.hovered
                        text: qsTr('放大')
                    }
                }
            }
        }
    }

    function get(index) {
        return __listModel.get(index);
    }

    function set(index, object) {
        __listModel.set(index, __private.initObject(object));
    }

    function setProperty(index, propertyName, value) {
        __listModel.setProperty(index, propertyName, value);
    }

    function move(from, to, count = 1) {
        __listModel.move(from, to, count);
    }

    function insert(index, object) {
        __listModel.insert(index, __private.initObject(object));
    }

    function append(object) {
        __listModel.append(__private.initObject(object));
    }

    function remove(index, count = 1) {
        __listModel.remove(index, count);
    }

    function clear() {
        __listModel.clear();
    }

    function zoomIn() {
        __private.isCenterScale = true;
        const nextScale = __private.scale + scaleStep;
        if (nextScale < scaleMax)
            __private.scale = nextScale;
        else
            __private.scale = scaleMax;
    }

    function zoomOut() {
        __private.isCenterScale = true;
        const nextScale = __private.scale - scaleStep;
        if (nextScale > scaleMin)
            __private.scale = nextScale;
        else
            __private.scale = scaleMin;
    }

    function flipX() {
        __private.flipX = !__private.flipX;
    }

    function flipY() {
        __private.flipY = !__private.flipY;
    }

    function rotate(angle: real) {
        __private.rotation += angle;
    }

    function resetTransform() {
        __private.isCenterScale = true;
        __private.flipX = false;
        __private.flipY = false;
        __private.scale = 1.0;
        __private.rotation = 0;
        __private.toCenter();
    }

    function incrementCurrentIndex() {
        __listView.incrementCurrentIndex();
    }

    function decrementCurrentIndex() {
        __listView.decrementCurrentIndex();
    }

    onItemsChanged:  {
        clear();
        for (const object of items) {
            append(object);
        }
    }
    onCurrentIndexChanged: {
        resetTransform();
    }

    objectName: '__HusImagePreview__'
    width: parent.width
    height: parent.height
    closePolicy: T.Popup.NoAutoClose
    parent: T.Overlay.overlay
    modal: true
    focus: true
    onAboutToShow: {
        resetTransform();
        __private.visible = true;
        __imagePreview.forceActiveFocus();
    }
    onAboutToHide: {
        __private.visible = false;
    }
    background: Item { }

    QtObject {
        id: __private

        signal toCenter()

        property bool visible: false
        property real scale: 1.0
        property real scaleOriginX: 0.0
        property real scaleOriginY: 0.0
        property bool isCenterScale: true
        property bool flipX: false
        property bool flipY: false
        property real rotation: 0

        function initObject(object) {
            if (!object.hasOwnProperty('url')) object.url = '';

            return object;
        }

        Behavior on scale {
            enabled: control.animationEnabled
            NumberAnimation {
                duration: HusTheme.Primary.durationMid
                easing.type: Easing.OutCubic
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: HusTheme.HusTour.colorOverlay

        Item {
            id: __imagePreview
            anchors.fill: parent
            focus: true
            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Left) {
                    decrementCurrentIndex();
                } else if (event.key === Qt.Key_Right) {
                    incrementCurrentIndex();
                } else if (event.key === Qt.Key_Escape) {
                    control.close();
                }
            }
            states: [
                State {
                    name: 'open'
                    when: __private.visible
                    PropertyChanges { __imagePreview.opacity: 1.0 }
                    PropertyChanges { __imagePreview.scale: 1.0 }
                },
                State {
                    name: 'close'
                    when: !__private.visible
                    PropertyChanges { __imagePreview.opacity: 0.0 }
                    PropertyChanges { __imagePreview.scale: 0.0 }
                }
            ]
            transitions: [
                Transition {
                    from: 'open'
                    to: 'close'
                    NumberAnimation {
                        properties: 'opacity'
                        easing.type: Easing.InOutQuad
                        duration: control.animationEnabled ? HusTheme.Primary.durationSlow : 0
                    }
                    NumberAnimation {
                        properties: 'scale'
                        easing.type: Easing.InOutQuad
                        duration: control.animationEnabled ? HusTheme.Primary.durationSlow : 0
                    }
                },
                Transition {
                    to: 'open'
                    from: 'close'
                    NumberAnimation {
                        properties: 'opacity'
                        easing.type: Easing.InOutQuad
                        duration: control.animationEnabled ? HusTheme.Primary.durationSlow : 0
                    }
                    NumberAnimation {
                        properties: 'scale'
                        easing.type: Easing.InOutQuad
                        duration: control.animationEnabled ? HusTheme.Primary.durationSlow : 0
                    }
                }
            ]

            ListView {
                id: __listView
                anchors.fill: parent
                clip: true
                model: ListModel { id: __listModel }
                interactive: false
                orientation: ListView.Horizontal
                highlightMoveDuration: control.animationEnabled ? HusTheme.Primary.durationMid : 0
                delegate: MouseArea {
                    id: __rootItem
                    width: __listView.width
                    height: __listView.height
                    clip: true
                    drag.target: __image
                    onClicked:
                        mouse => {
                            if (!imageContains(mouse.x, mouse.y)) {
                                control.close();
                            }
                        }
                    onDoubleClicked:
                        () => {
                            if (__private.scale > 1.0) {
                                __private.scale = 1.0;
                                __private.toCenter();
                            } else {
                                control.zoomIn();
                            }
                        }

                    required property string url
                    property bool isCurrent: ListView.isCurrentItem

                    function imageContains(x, y) {
                        return x >= __image.x && x <= __image.x + __image.width && y >= __image.y && y <= __image.y + __image.height;
                    }

                    Loader {
                        id: __image

                        property string sourceUrl: __rootItem.url
                        property size sourceSize: item ? item.sourceSize : Qt.size(0, 0)

                        property real minViewHeight: __rootItem.height - 200
                        property real aspectRatio: sourceSize.width / sourceSize.height
                        property size realSize: Qt.size(width * __private.scale, height * __private.scale)
                        property point mapTopLeft: mapToItem(parent, 0, 0)
                        property point mapBottomRight: mapToItem(parent, width, height)

                        sourceComponent: control.sourceDelegate
                        onRealSizeChanged: {
                            if (realSize.width < __rootItem.width || realSize.height < __rootItem.height)
                                __adjustTimer.restart();
                        }

                        function calcMapRect() {
                            mapTopLeft = mapToItem(parent, 0, 0);
                            mapBottomRight = mapToItem(parent, width, height);
                        }

                        function toCenterX() {
                            const centerX = __rootItem.width * 0.5 - width * 0.5;
                            const originScaleX = (__scale.origin.x - width * 0.5) * (__private.scale - 1.0);
                            x = centerX - originScaleX * (__private.flipX ? 1 : -1);
                        }

                        function toCenterY() {
                            const centerY = __rootItem.height * 0.5 - height * 0.5;
                            const originScaleY = (__scale.origin.y - height * 0.5) * (__private.scale - 1.0);
                            y = centerY - originScaleY * (__private.flipY ? 1 : -1);
                        }

                        function adjustPosition() {
                            const r = parseInt(__private.rotation) % 360;
                            if (realSize.width > __rootItem.width) {
                                if (__private.flipX) {
                                    if (r == 0 || r == -90 || r == 270) {
                                        if (mapTopLeft.x < __rootItem.width) {
                                            x += (__rootItem.width - mapTopLeft.x);
                                        } else if (mapBottomRight.x > 0) {
                                            x += -mapBottomRight.x;
                                        }
                                    } else {
                                        if (mapBottomRight.x < __rootItem.width) {
                                            x += (__rootItem.width - mapBottomRight.x);
                                        } else if (mapTopLeft.x > 0) {
                                            x += -mapTopLeft.x;
                                        }
                                    }
                                } else {
                                    if (r == 0 || r == -90 || r == 270) {
                                        if (mapBottomRight.x < __rootItem.width) {
                                            x += (__rootItem.width - mapBottomRight.x);
                                        } else if (mapTopLeft.x > 0) {
                                            x += -mapTopLeft.x;
                                        }

                                    } else {
                                        if (mapTopLeft.x < __rootItem.width) {
                                            x += (__rootItem.width - mapTopLeft.x);
                                        } else if (mapBottomRight.x > 0) {
                                            x += -mapBottomRight.x;
                                        }
                                    }
                                }
                            } else {
                                toCenterX();
                            }
                            if (realSize.height > __rootItem.height) {
                                if (__private.flipY) {
                                    if (r == 0 || r == -270 || r == 90) {
                                        if (mapTopLeft.y < __rootItem.height) {
                                            y += __rootItem.height - mapTopLeft.y;
                                        } else if (mapBottomRight.y > 0) {
                                            y += -mapBottomRight.y;
                                        }
                                    } else {
                                        if (mapBottomRight.y < __rootItem.height) {
                                            y += __rootItem.height - mapBottomRight.y;
                                        } else if (mapTopLeft.y > 0) {
                                            y += -mapTopLeft.y;
                                        }
                                    }
                                } else {
                                    if (r == 0 || r == -270 || r == 90) {
                                        if (mapBottomRight.y < __rootItem.height) {
                                            y += __rootItem.height - mapBottomRight.y;
                                        } else if (mapTopLeft.y > 0) {
                                            y += -mapTopLeft.y;
                                        }
                                    } else {
                                        if (mapTopLeft.y < __rootItem.height) {
                                            y += __rootItem.height - mapTopLeft.y;
                                        } else if (mapBottomRight.y > 0) {
                                            y += -mapBottomRight.y;
                                        }
                                    }
                                }
                            } else {
                                toCenterY();
                            }
                        }

                        onXChanged: calcMapRect();
                        onYChanged: calcMapRect();

                        x: (parent.width - width) * 0.5
                        y: (parent.height - height) * 0.5
                        width: height * aspectRatio
                        height: Math.min(sourceSize.height, minViewHeight)
                        transform: [
                            Scale {
                                id: __scale
                                origin.x: __private.isCenterScale ? __image.width * 0.5 : __private.scaleOriginX
                                origin.y: __private.isCenterScale ? __image.height * 0.5 : __private.scaleOriginY
                                xScale: __private.scale
                                yScale: __private.scale
                                onXScaleChanged: __image.calcMapRect();
                            },
                            Rotation {
                                origin.x: __image.width * 0.5
                                origin.y: __image.height * 0.5
                                axis { x: 0; y: 0; z: 1 }
                                angle: __rootItem.isCurrent ? __private.rotation : 0

                                Behavior on angle {
                                    enabled: control.animationEnabled
                                    NumberAnimation {
                                        duration: HusTheme.Primary.durationMid
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            },
                            Rotation {
                                origin.x: __image.width * 0.5
                                origin.y: __image.height * 0.5
                                axis { x: 0; y: 1; z: 0 }
                                angle: __rootItem.isCurrent ? (__private.flipX ? 180 : 0) : 0

                                Behavior on angle {
                                    enabled: control.animationEnabled
                                    NumberAnimation {
                                        duration: HusTheme.Primary.durationMid
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            },
                            Rotation {
                                origin.x: __image.width * 0.5
                                origin.y: __image.height * 0.5
                                axis { x: 1; y: 0; z: 0 }
                                angle: __rootItem.isCurrent ? (__private.flipY ? 180 : 0) : 0
                                onAngleChanged: __image.calcMapRect();

                                Behavior on angle {
                                    enabled: control.animationEnabled
                                    NumberAnimation {
                                        duration: HusTheme.Primary.durationMid
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }
                        ]

                        Behavior on x {
                            enabled: control.animationEnabled
                            NumberAnimation {
                                duration: HusTheme.Primary.durationMid
                                easing.type: Easing.OutCubic
                            }
                        }

                        Behavior on y {
                            enabled: control.animationEnabled
                            NumberAnimation {
                                duration: HusTheme.Primary.durationMid
                                easing.type: Easing.OutCubic
                            }
                        }

                        Timer {
                            id: __adjustTimer
                            running: !__rootItem.drag.active
                            interval: 100
                            onTriggered: __image.adjustPosition();
                        }

                        Connections {
                            target: __private
                            function onToCenter() {
                                __private.isCenterScale = true;
                                __image.toCenterX();
                                __image.toCenterY();
                            }
                        }

                        HoverHandler {
                            cursorShape: Qt.ClosedHandCursor
                        }

                        WheelHandler {
                            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                            onWheel:
                                (wheel) => {
                                    const step = wheel.angleDelta.y / 120 * control.scaleStep;
                                    const nextScale = __private.scale + step;
                                    __private.isCenterScale = false;
                                    __private.scaleOriginX = wheel.x;
                                    __private.scaleOriginY = wheel.y;
                                    if (nextScale < control.scaleMin) {
                                        __private.scale = control.scaleMin;
                                    } else if (nextScale > control.scaleMax) {
                                        __private.scale = control.scaleMax;
                                    } else {
                                        __private.scale = nextScale;
                                    }
                                }
                        }
                    }
                }
            }

            Loader {
                anchors.bottom: operationLoader.top
                anchors.bottomMargin: 18
                anchors.horizontalCenter: parent.horizontalCenter
                active: __listModel.count > 1
                sourceComponent: control.indicatorDelegate
            }

            Loader {
                id: operationLoader
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                sourceComponent: control.operationDelegate
            }

            Loader {
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                active: __listModel.count > 1
                sourceComponent: control.prevDelegate
            }

            Loader {
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                active: __listModel.count > 1
                sourceComponent: control.nextDelegate
            }

            Loader {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 30
                sourceComponent: control.closeDelegate
            }
        }
    }
}

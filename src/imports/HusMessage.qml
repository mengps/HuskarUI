pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

Item {
    id: control

    enum MessageType {
        Type_None = 0,
        Type_Success = 1,
        Type_Warning = 2,
        Type_Message = 3,
        Type_Error = 4
    }

    signal closed(key: string)

    property bool animationEnabled: HusTheme.animationEnabled
    property int defaultIconSize: 18
    property bool showCloseButton: false
    property int spacing: 10
    property int topMargin: 12
    property int bgTopPadding: 12
    property int bgBottomPadding: 12
    property int bgLeftPadding: 12
    property int bgRightPadding: 12
    property color colorMessage: HusTheme.HusMessage.colorMessage
    property color colorBg: HusTheme.isDark ? HusTheme.HusMessage.colorBgDark : HusTheme.HusMessage.colorBg
    property color colorBgShadow: HusTheme.HusMessage.colorBgShadow
    property HusRadius radiusBg: HusRadius { all: HusTheme.HusMessage.radiusBg }

    property font messageFont: Qt.font({
                                           family: HusTheme.HusMessage.fontFamily,
                                           pixelSize: parseInt(HusTheme.HusMessage.fontSize)
                                       })
    property int messageSpacing: 8

    property Component messageDelegate: HusText {
        font: control.messageFont
        color: control.colorMessage
        text: parent.message
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
    }

    function info(message: string, duration = 3000) {
        open({
                 'message': message,
                 'type': HusMessage.Type_Message,
                 'duration': duration
             });
    }

    function success(message: string, duration = 3000) {
        open({
                 'message': message,
                 'type': HusMessage.Type_Success,
                 'duration': duration
             });
    }

    function error(message: string, duration = 3000) {
        open({
                 'message': message,
                 'type': HusMessage.Type_Error,
                 'duration': duration
             });
    }

    function warning(message: string, duration = 3000) {
        open({
                 'message': message,
                 'type': HusMessage.Type_Warning,
                 'duration': duration
             });
    }

    function loading(message: string, duration = 3000) {
        open({
                 'loading': true,
                 'message': message,
                 'type': HusMessage.Type_Message,
                 'duration': duration
             });
    }

    function open(object) {
        __listModel.append(__private.initObject(object));
    }

    function close(key: string) {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                const item = __repeater.itemAt(i);
                if (item)
                    item.removeSelf();
                break;
            }
        }
    }

    function getMessage(key: string): var {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                return object;
            }
        }
        return undefined;
    }

    function setProperty(key: string, property: string, value: var) {
        for (let i = 0; i < __listModel.count; i++) {
            const object = __listModel.get(i);
            if (object.key && object.key === key) {
                __listModel.setProperty(i, property, value);
                break;
            }
        }
    }

    objectName: '__HusMessage__'

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorMessage { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    QtObject {
        id: __private

        function initObject(object) {
            if (!object.hasOwnProperty('key')) object.key = '';
            if (!object.hasOwnProperty('loading')) object.loading = false;
            if (!object.hasOwnProperty('message')) object.message = '';
            if (!object.hasOwnProperty('type')) object.type = HusMessage.Type_None;
            if (!object.hasOwnProperty('duration')) object.duration = 3000;
            if (!object.hasOwnProperty('iconSize')) object.iconSize = control.defaultIconSize;
            if (!object.hasOwnProperty('iconSource')) object.iconSource = 0;

            if (!object.hasOwnProperty('colorIcon')) object.colorIcon = '';
            else object.colorIcon = String(object.colorIcon);

            return object;
        }
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: control.topMargin
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: control.spacing

        Repeater {
            id: __repeater
            model: ListModel { id: __listModel }
            delegate: Item {
                id: __rootItem
                width: __content.width
                height: __content.height
                anchors.horizontalCenter: parent.horizontalCenter

                required property int index
                required property string key
                required property bool loading
                required property string message
                required property int type
                required property int duration
                required property int iconSize
                required property int iconSource
                required property string colorIcon

                function removeSelf() {
                    __content.height = 0;
                    __removeTimer.start();
                }

                Timer {
                    id: __timer
                    running: true
                    interval: __rootItem.duration
                    onTriggered: {
                        __rootItem.removeSelf();
                    }
                }

                HusShadow {
                    anchors.fill: __rootItem
                    source: __bgRect
                    shadowColor: control.colorBgShadow
                }

                HusRectangleInternal {
                    id: __bgRect
                    anchors.fill: parent
                    radius: control.radiusBg.all
                    topLeftRadius: control.radiusBg.topLeft
                    topRightRadius: control.radiusBg.topRight
                    bottomLeftRadius: control.radiusBg.bottomLeft
                    bottomRightRadius: control.radiusBg.bottomRight
                    color: control.colorBg
                    visible: false
                }

                Item {
                    id: __content
                    width: __rowLayout.width + control.bgLeftPadding + control.bgRightPadding
                    height: 0
                    opacity: 0
                    clip: true

                    Component.onCompleted: {
                        opacity = 1;
                        height = Qt.binding(() => __rowLayout.height + control.bgTopPadding + control.bgBottomPadding);
                    }

                    Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
                    Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

                    Timer {
                        id: __removeTimer
                        running: false
                        interval: control.animationEnabled ? HusTheme.Primary.durationMid : 0
                        onTriggered: {
                            control.closed(__rootItem.key);
                            __listModel.remove(__rootItem.index);
                        }
                    }

                    RowLayout {
                        id: __rowLayout
                        width: Math.min(implicitWidth, control.width - control.bgLeftPadding - control.bgRightPadding)
                        anchors.centerIn: parent
                        spacing: control.messageSpacing

                        HusIconText {
                            Layout.alignment: Qt.AlignVCenter
                            iconSize: __rootItem.iconSize
                            iconSource: {
                                if (__rootItem.loading) return HusIcon.LoadingOutlined;
                                if (__rootItem.iconSource != 0) return __rootItem.iconSource;
                                switch (type) {
                                    case HusMessage.Type_Success: return HusIcon.CheckCircleFilled;
                                    case HusMessage.Type_Warning: return HusIcon.ExclamationCircleFilled;
                                    case HusMessage.Type_Message: return HusIcon.ExclamationCircleFilled;
                                    case HusMessage.Type_Error: return HusIcon.CloseCircleFilled;
                                    default: return 0;
                                }
                            }
                            colorIcon: {
                                if (__rootItem.loading) return HusTheme.Primary.colorInfo;
                                if (__rootItem.colorIcon !== '') return __rootItem.colorIcon;
                                switch ((type)) {
                                    case HusMessage.Type_Success: return HusTheme.Primary.colorSuccess;
                                    case HusMessage.Type_Warning: return HusTheme.Primary.colorWarning;
                                    case HusMessage.Type_Message: return HusTheme.Primary.colorInfo;
                                    case HusMessage.Type_Error: return HusTheme.Primary.colorError;
                                    default: return HusTheme.Primary.colorInfo;
                                }
                            }

                            NumberAnimation on rotation {
                                running: __rootItem.loading
                                from: 0
                                to: 360
                                loops: Animation.Infinite
                                duration: 1000
                            }
                        }

                        Loader {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            sourceComponent: control.messageDelegate
                            property alias index: __rootItem.index
                            property alias key: __rootItem.key
                            property alias message: __rootItem.message
                        }

                        Loader {
                            Layout.alignment: Qt.AlignVCenter
                            active: control.showCloseButton
                            sourceComponent: HusCaptionButton {
                                topPadding: 2
                                bottomPadding: 2
                                leftPadding: 4
                                rightPadding: 4
                                radiusBg.all: 2
                                animationEnabled: control.animationEnabled
                                hoverCursorShape: Qt.PointingHandCursor
                                iconSource: HusIcon.CloseOutlined
                                colorIcon: hovered ? HusTheme.HusMessage.colorCloseHover : HusTheme.HusMessage.colorClose
                                onClicked: {
                                    __timer.stop();
                                    __rootItem.removeSelf();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

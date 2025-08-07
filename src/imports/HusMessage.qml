pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Effects
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

    signal messageClosed(key: string)

    property bool animationEnabled: HusTheme.animationEnabled
    property bool closeButtonVisible: false
    property int bgTopPadding: 12
    property int bgBottomPadding: 12
    property int bgLeftPadding: 12
    property int bgRightPadding: 12
    property color colorBg: HusTheme.isDark ? HusTheme.HusMessage.colorBgDark : HusTheme.HusMessage.colorBg
    property color colorBgShadow: HusTheme.HusMessage.colorBgShadow
    property int radiusBg: HusTheme.HusMessage.radiusBg

    property font messageFont: Qt.font({
                                           family: HusTheme.HusMessage.fontFamily,
                                           pixelSize: HusTheme.HusMessage.fontSize
                                       })
    property color colorMessage: HusTheme.HusMessage.colorMessage
    property int messageSpacing: 8

    objectName: '__HusMessage__'

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
            let object = __listModel.get(i);
            if (object.key && object.key === key) {
                let item = repeater.itemAt(i);
                if (item)
                    item.removeSelf();
                break;
            }
        }
    }

    function setProperty(key: string, property: string, value: var) {
        for (let i = 0; i < __listModel.count; i++) {
            let object = __listModel.get(i);
            if (object.key && object.key === key) {
                __listModel.setProperty(i, property, value);
                break;
            }
        }
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }
    Behavior on colorMessage { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    QtObject {
        id: __private
        function initObject(object) {
            if (!object.hasOwnProperty('colorNode')) object.colorNode = String(control.colorNode);
            if (!object.hasOwnProperty('key')) object.key = '';
            if (!object.hasOwnProperty('loading')) object.loading = false;
            if (!object.hasOwnProperty('message')) object.message = '';
            if (!object.hasOwnProperty('type')) object.type = HusMessage.Type_None;
            if (!object.hasOwnProperty('duration')) object.duration = 3000;
            if (!object.hasOwnProperty('iconSource')) object.iconSource = 0;

            if (!object.hasOwnProperty('colorIcon')) object.colorIcon = '';
            else object.colorIcon = String(object.colorIcon);

            return object;
        }
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Repeater {
            id: repeater
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
                required property int iconSource
                required property string colorIcon

                function removeSelf() {
                    __removeAniamtion.restart();
                }

                Timer {
                    id: __timer
                    running: true
                    interval: __rootItem.duration
                    onTriggered: {
                        __removeAniamtion.restart();
                    }
                }

                MultiEffect {
                    anchors.fill: __rootItem
                    source: __bgRect
                    shadowColor: control.colorBgShadow
                    shadowEnabled: true
                    shadowBlur: 0.8
                    shadowOpacity: HusTheme.isDark ? 0.5 : 0.3
                }

                Rectangle {
                    id: __bgRect
                    anchors.fill: parent
                    radius: control.radiusBg
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
                        height = __rowLayout.height + control.bgTopPadding + control.bgBottomPadding;
                    }

                    Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
                    Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

                    NumberAnimation on height {
                        id: __removeAniamtion
                        to: 0
                        running: false
                        alwaysRunToEnd: true
                        onFinished: {
                            __listModel.remove(__rootItem.index);
                            control.messageClosed(__rootItem.key);
                        }
                    }

                    RowLayout {
                        id: __rowLayout
                        width: Math.min(implicitWidth, control.width - control.bgLeftPadding - control.bgRightPadding)
                        anchors.centerIn: parent
                        spacing: control.messageSpacing

                        HusIconText {
                            Layout.alignment: Qt.AlignVCenter
                            iconSize: 18
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

                        HusText {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            font: control.messageFont
                            color: control.colorMessage
                            text: __rootItem.message
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WrapAnywhere
                        }

                        Loader {
                            Layout.alignment: Qt.AlignVCenter
                            active: control.closeButtonVisible
                            sourceComponent: HusCaptionButton {
                                topPadding: 0
                                bottomPadding: 0
                                leftPadding: 2
                                rightPadding: 2
                                animationEnabled: control.animationEnabled
                                hoverCursorShape: Qt.PointingHandCursor
                                iconSource: HusIcon.CloseOutlined
                                colorIcon: hovered ? HusTheme.HusMessage.colorCloseHover : HusTheme.HusMessage.colorClose
                                onClicked: {
                                    __timer.stop();
                                    __removeAniamtion.restart();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

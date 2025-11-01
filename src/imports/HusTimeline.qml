import QtQuick
import QtQuick.Templates as T
import HuskarUI.Basic

Item {
    id: control

    enum Mode {
        Mode_Left = 0,
        Mode_Right = 1,
        Mode_Alternate = 2
    }

    property bool animationEnabled: HusTheme.animationEnabled
    property var initModel: []
    property int mode: HusTimeline.Mode_Left
    property bool reverse: false
    property int defaultNodeSize: 11
    property int defaultLineWidth: 1
    property string defaultTimeFormat: 'yyyy-MM-dd'
    property int defaultContentFormat: Text.AutoText
    property color colorNode: HusTheme.HusTimeline.colorNode
    property color colorNodeBg: HusTheme.HusTimeline.colorNodeBg
    property color colorLine: HusTheme.HusTimeline.colorLine
    property font timeFont: Qt.font({
                                        family: HusTheme.HusTimeline.fontFamily,
                                        pixelSize: parseInt(HusTheme.HusTimeline.fontSize)
                                    })
    property color colorTimeText: HusTheme.HusTimeline.colorTimeText
    property font contentFont: Qt.font({
                                           family: HusTheme.HusTimeline.fontFamily,
                                           pixelSize: parseInt(HusTheme.HusTimeline.fontSize)
                                       })
    property color colorContentText: HusTheme.HusTimeline.colorContentText
    property Component nodeDelegate: Component {
        Item {
            height: __loading.active ? __loading.height : __icon.active ? __icon.height : defaultNodeSize

            Loader {
                id: __dot
                width: parent.height
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                active: !__icon.active && !__loading.active
                sourceComponent: Rectangle {
                    radius: width >> 1
                    color: control.colorNodeBg
                    border.color: model.colorNode
                    border.width: radius * 0.5
                }
            }

            Loader {
                id: __icon
                anchors.horizontalCenter: parent.horizontalCenter
                active: !__loading.active && model.iconSource !== 0 && model.iconSource !== ''
                sourceComponent: HusIconText {
                    iconSource: model.iconSource
                    iconSize: model.iconSize
                    colorIcon: model.colorNode
                }
            }

            Loader {
                id: __loading
                anchors.horizontalCenter: parent.horizontalCenter
                active: model.loading
                sourceComponent: HusIconText {
                    iconSize: model.iconSize
                    iconSource: HusIcon.LoadingOutlined
                    colorIcon: model.colorNode

                    NumberAnimation on rotation {
                        running: model.loading
                        from: 0
                        to: 360
                        loops: Animation.Infinite
                        duration: 1000
                    }
                }
            }
        }
    }
    property Component lineDelegate: Component {
        Rectangle {
            color: control.colorLine
        }
    }
    property Component timeDelegate: Component {
        HusText {
            id: __timeText
            color: control.colorTimeText
            font: control.timeFont
            text: {
                if (!isNaN(model.time))
                    return model.time.toLocaleString(Qt.locale(), model.timeFormat);
                else
                    return '';
            }
            horizontalAlignment: onLeft ? Text.AlignRight : Text.AlignLeft
        }
    }
    property Component contentDelegate: Component {
        HusText {
            id: __contentText
            color: control.colorContentText
            font: control.contentFont
            text: model.content
            textFormat: model.contentFormat
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: onLeft ? Text.AlignRight : Text.AlignLeft
        }
    }

    objectName: '__HusTimeline__'
    onInitModelChanged: {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    function flick(xVelocity: real, yVelocity: real) {
        __listView.flick(xVelocity, yVelocity);
    }

    function positionViewAtBeginning() {
        __listView.positionViewAtBeginning();
    }

    function positionViewAtIndex(index: int, mode: int) {
        __listView.positionViewAtIndex(index, mode);
    }

    function positionViewAtEnd() {
        __listView.positionViewAtEnd();
    }

    function get(index) {
        return __listModel.get(index);
    }

    function set(index, object) {
        __listModel.set(index, __private.initObject(object));
    }

    function setProperty(index, propertyName, value) {
        if (propertyName === 'time')
            __private.noTime = false;
        __listModel.setProperty(index, propertyName, value);
    }

    function move(from, to, count = 1) {
        __listModel.move(from, to, count);
    }

    function insert(index, object) {
        __listModel.insert(index, __private.initObject(object));
    }

    function remove(index, count = 1) {
        __listModel.remove(index, count);
        for (let i = 0; i < __listModel.count; i++) {
            if (__listModel.get(i).hasOwnProperty('time')) {
                __private.noTime = false;
                break;
            }
        }
    }

    function append(object) {
        __listModel.append(__private.initObject(object));
    }

    function clear() {
        __private.noTime = true;
        __listModel.clear();
    }

    QtObject {
        id: __private
        property bool noTime: true
        function initObject(object) {
            /*! 静态角色类型下会有颜色不兼容问题, 统一转换为string即可 */
            if (object.hasOwnProperty('colorNode')) {
                object.colorNode = String(object.colorNode);
            }

            if (!object.hasOwnProperty('colorNode')) object.colorNode = String(control.colorNode);
            if (!object.hasOwnProperty('iconSource')) object.iconSource = 0;
            if (!object.hasOwnProperty('iconSize')) object.iconSize = control.defaultNodeSize;
            if (!object.hasOwnProperty('loading')) object.loading = false;

            if (!object.hasOwnProperty('time')) object.time = new Date(undefined);
            if (!object.hasOwnProperty('timeFormat')) object.timeFormat = control.defaultTimeFormat;

            if (!object.hasOwnProperty('content')) object.content = '';
            if (!object.hasOwnProperty('contentFormat')) object.contentFormat = control.defaultContentFormat;

            /*! 判断是否存在有效时间 */
            if (__private.noTime && object.hasOwnProperty('time') && !isNaN(object.time))
                __private.noTime = false;

            return object;
        }
    }

    ListView {
        id: __listView
        anchors.fill: parent
        clip: true
        verticalLayoutDirection: control.reverse ? ListView.BottomToTop : ListView.TopToBottom
        model: ListModel { id: __listModel }
        T.ScrollBar.vertical: HusScrollBar {
            animationEnabled: control.animationEnabled
        }
        add: Transition {
            NumberAnimation { property: 'opacity'; from: 0; to: 1; duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 }
        }
        remove: Transition {
            NumberAnimation { property: 'opacity'; from: 1; to: 0; duration: control.animationEnabled ? HusTheme.Primary.durationMid : 0 }
        }
        delegate: Item {
            id: __rootItem
            width: __listView.width
            height: contentLoader.height + 25

            required property var model
            required property int index
            property bool timeOnLeft: {
                if (control.mode == HusTimeline.Mode_Right)
                    return false;
                else if (control.mode == HusTimeline.Mode_Alternate)
                    return index % 2 == 0;
                else
                    return true;
            }

            Loader {
                id: lineLoader
                active: {
                    if (control.reverse)
                        return __rootItem.index != 0;
                    else
                        __rootItem.index !== (__listModel.count - 1);
                }
                width: defaultLineWidth
                height: parent.height - nodeLoader.height
                anchors.horizontalCenter: nodeLoader.horizontalCenter
                anchors.top: nodeLoader.bottom
                sourceComponent: lineDelegate
                property alias model: __rootItem.model
                property alias index: __rootItem.index
            }

            Loader {
                id: nodeLoader
                x: {
                    if (__private.noTime && control.mode != HusTimeline.Mode_Alternate)
                        return control.mode == HusTimeline.Mode_Left ? 0 : parent.width - width;
                    else
                        return (__rootItem.width - width) * 0.5;
                }
                width: 30
                sourceComponent: nodeDelegate
                property alias model: __rootItem.model
                property alias index: __rootItem.index
            }

            Loader {
                id: timeLoader
                y: (nodeLoader.height - __timeFontMetrics.height) * 0.5
                anchors.left: __rootItem.timeOnLeft ? parent.left : nodeLoader.right
                anchors.leftMargin: __rootItem.timeOnLeft ? 0 : 5
                anchors.right: __rootItem.timeOnLeft ? nodeLoader.left : parent.right
                anchors.rightMargin: __rootItem.timeOnLeft ? 5 : 0
                sourceComponent: timeDelegate
                property alias model: __rootItem.model
                property alias index: __rootItem.index
                property bool onLeft: __rootItem.timeOnLeft

                FontMetrics {
                    id: __timeFontMetrics
                    font: control.timeFont
                }
            }

            Loader {
                id: contentLoader
                y: (nodeLoader.height - __contentFontMetrics.height) * 0.5
                anchors.left: !__rootItem.timeOnLeft ? parent.left : nodeLoader.right
                anchors.leftMargin: !__rootItem.timeOnLeft ? 0 : 5
                anchors.right: !__rootItem.timeOnLeft ? nodeLoader.left : parent.right
                anchors.rightMargin: !__rootItem.timeOnLeft ? 5 : 0
                sourceComponent: contentDelegate
                property alias model: __rootItem.model
                property alias index: __rootItem.index
                property bool onLeft: !__rootItem.timeOnLeft

                FontMetrics {
                    id: __contentFontMetrics
                    font: control.contentFont
                }
            }
        }
    }
}

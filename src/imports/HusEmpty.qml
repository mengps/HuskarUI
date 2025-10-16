import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import HuskarUI.Basic


Item {
    id: control

    enum Presented_Image
    {
        Image_None = 0,
        Image_Default = 1,
        Image_Simple = 2
    }

    property url imageSource: Qt.url('')
    property int imageType: HusEmpty.Image_Simple
    property int imageWidth: -1
    property int imageHeight: -1
    property string description: ''
    property font descriptionFont: Qt.font({
                                         family: HusTheme.HusEmpty.fontFamily,
                                         pixelSize: HusTheme.HusEmpty.fontSize - 1
                                     })
    property int descriptionPadding: 12
    property bool showDescription: true
    property color colorText: HusTheme.HusEmpty.colorTextSecondary
    property Component descriptionDelegate: Component {
        HusText {
            text: control.description ?? qsTr('暂无数据')
            font: control.descriptionFont
            color: control.colorText
            horizontalAlignment: Text.AlignHCenter
        }
    }

    objectName: '__HusEmpty__'

    width: 200
    height: 200

    ColumnLayout {
        id: __columnLayout
        anchors.centerIn: parent
        spacing: control.descriptionPadding

        Loader {
            id: __imageLoader
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            active: hasCustomImageSource() || control.imageType !== HusEmpty.Image_None
            sourceComponent: Image {
                width: calcImageWidth()
                height: calcImageHeight()
                source: (!!control.imageSource && control.imageSource !== Qt.url('')) ? control.imageSource : Qt.url('qrc:/HuskarUI/resources/images/empty-' + (control.imageType === HusEmpty.Image_Simple ? 'simple' : 'default') + '.svg')
            }
        }

        Loader {
            id: __descriptionLoader
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            active: control.showDescription
            sourceComponent: descriptionDelegate
        }
    }

    function calcImageWidth() {
        if (control.imageWidth > 0) {
            return control.imageWidth;
        }
        if (hasCustomImageSource()) {
            return (control.imageWidth > 0) ? control.imageWidth : control.width / 3;
        }
        if (control.imageType === HusEmpty.Image_Default) {
            return 92;
        } else if (control.imageType === HusEmpty.Image_Simple) {
            return 64;
        }
        return 0;
    }

    function calcImageHeight() {
        if (control.imageHeight > 0) {
            return control.imageHeight;
        }
        if (hasCustomImageSource()) {
            return (control.imageHeight > 0) ? control.imageHeight : control.imageHeight / 3;
        }
        if (control.imageType === HusEmpty.Image_Default) {
            return 76;
        } else if (control.imageType === HusEmpty.Image_Simple) {
            return 41;
        }
        return 0;
    }

    function hasCustomImageSource() {
        return !!control.imageSource && control.imageSource !== Qt.url('');
    }
}

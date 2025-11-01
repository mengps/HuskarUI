import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Item {
    id: control

    enum ImageStyle
    {
        Style_None = 0,
        Style_Default = 1,
        Style_Simple = 2
    }

    property int imageStyle: HusEmpty.Image_Default
    property string imageSource: {
        switch (imageStyle) {
        case HusEmpty.Style_None: return '';
        case HusEmpty.Style_Default: return 'qrc:/HuskarUI/resources/images/empty-default.svg';
        case HusEmpty.Style_Simple: return 'qrc:/HuskarUI/resources/images/empty-simple.svg';
        }
    }
    property int imageWidth: {
        switch (imageStyle) {
        case HusEmpty.Style_None: return width / 3;
        case HusEmpty.Style_Default: return 92;
        case HusEmpty.Style_Simple: return 64;
        }
    }
    property int imageHeight: {
        switch (imageStyle) {
        case HusEmpty.Style_None: return height / 3;
        case HusEmpty.Style_Default: return 76;
        case HusEmpty.Style_Simple: return 41;
        }
    }
    property bool showDescription: true
    property string description: ''
    property int descriptionSpacing: 12
    property font descriptionFont: Qt.font({
                                               family: HusTheme.HusEmpty.fontFamily,
                                               pixelSize: parseInt(HusTheme.HusEmpty.fontSize) - 1
                                           })
    property color colorDescription: HusTheme.HusEmpty.colorDescription

    property Component imageDelegate: Image {
        width: control.imageWidth
        height: control.imageHeight
        source: control.imageSource
        sourceSize: Qt.size(width, height)
    }
    property Component descriptionDelegate: HusText {
        text: control.description
        font: control.descriptionFont
        color: control.colorDescription
        horizontalAlignment: Text.AlignHCenter
    }

    objectName: '__HusEmpty__'
    width: 200
    height: 200

    ColumnLayout {
        anchors.centerIn: parent
        spacing: control.descriptionSpacing

        Loader {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            visible: active
            active: control.imageSource !== '' || control.imageType !== HusEmpty.Image_None
            sourceComponent: control.imageDelegate
        }

        Loader {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            visible: active
            active: control.showDescription
            sourceComponent: control.descriptionDelegate
        }
    }
}

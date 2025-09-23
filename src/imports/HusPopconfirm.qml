import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T
import HuskarUI.Basic

HusPopup {
    id: control

    signal confirm()
    signal cancel()

    property var iconSource: HusIcon.ExclamationCircleFilled || ''
    property int iconSize: 16
    property string title: ''
    property string description: ''
    property string confirmText: ''
    property string cancelText: ''
    property bool showArrow: true
    property int arrowWidth: 16
    property int arrowHeight: 8
    property color colorIcon: HusTheme.HusPopconfirm.colorIcon
    property color colorTitle: HusTheme.HusPopconfirm.colorTitle
    property color colorDescription: HusTheme.HusPopconfirm.colorDescription
    property font titleFont: Qt.font({
                                         family: HusTheme.HusPopconfirm.fontFamily,
                                         weight: Font.DemiBold,
                                         pixelSize: parseInt(HusTheme.HusPopconfirm.fontTitleSize)
                                     })
    property font descriptionFont: Qt.font({
                                               family: HusTheme.HusPopconfirm.fontFamily,
                                               pixelSize: parseInt(HusTheme.HusPopconfirm.fontDescriptionSize)
                                           })
    property Component arrowDelegate: Canvas {
        id: __arrowDelegate
        width: arrowWidth
        height: arrowHeight
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onFillStyleChanged: requestPaint();
        onPaint: {
            const ctx = getContext('2d');
            ctx.fillStyle = fillStyle;
            ctx.beginPath();
            ctx.moveTo(0, height);
            ctx.lineTo(width * 0.5, 0);
            ctx.lineTo(width, height);
            ctx.closePath();
            ctx.fill();
        }
        property color fillStyle: control.colorBg
    }
    property Component iconDelegate: HusIconText {
        color: control.colorIcon
        iconSource: control.iconSource
        iconSize: control.iconSize
    }
    property Component titleDelegate: HusText {
        font: control.titleFont
        color: control.colorTitle
        text: control.title
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component descriptionDelegate: HusText {
        width: parent.width
        font: control.descriptionFont
        color: control.colorDescription
        text: control.description
        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WrapAnywhere
    }
    property Component confirmButtonDelegate: HusButton {
        animationEnabled: control.animationEnabled
        padding: 8
        topPadding: 4
        bottomPadding: 4
        text: control.confirmText
        type: HusButton.Type_Default
        onClicked: control.confirm();
    }
    property Component cancelButtonDelegate: HusButton {
        animationEnabled: control.animationEnabled
        padding: 8
        topPadding: 4
        bottomPadding: 4
        text: control.cancelText
        type: HusButton.Type_Primary
        onClicked: control.cancel();
    }
    property Component contentDelegate: Item {
        height: __columnLayout.implicitHeight + 20

        ColumnLayout {
            id: __columnLayout
            width: parent.width - 20
            anchors.centerIn: parent
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                visible: __iconLoader.active || __titleLoader.active

                Loader {
                    id: __iconLoader
                    Layout.alignment: Qt.AlignVCenter
                    active: control.iconSource !== 0 && control.iconSource !== ''
                    sourceComponent: control.iconDelegate
                }

                Loader {
                    id: __titleLoader
                    Layout.alignment: Qt.AlignVCenter
                    active: control.title !== ''
                    sourceComponent: control.titleDelegate
                }
            }

            Loader {
                Layout.leftMargin: __iconLoader.width + 5
                Layout.fillWidth: true
                visible: active
                active: control.description !== ''
                sourceComponent: control.descriptionDelegate
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 10
                visible: __confirmLoader.active || __cancelLoader.active

                Loader {
                    id: __confirmLoader
                    active: control.confirmText !== ''
                    sourceComponent: control.confirmButtonDelegate
                }

                Loader {
                    id: __cancelLoader
                    active: control.cancelText !== ''
                    sourceComponent: control.cancelButtonDelegate
                }
            }
        }
    }
    property Component bgDelegate: Rectangle {
        color: control.colorBg
        radius: control.radiusBg
    }

    objectName: '__HusPopconfirm__'
    themeSource: HusTheme.HusPopconfirm
    implicitHeight: implicitBackgroundHeight + topInset + bottomInset
    background: Item {
        implicitHeight: __bg.height

        HusShadow {
            anchors.fill: __bg
            source: __bg
            shadowColor: control.colorShadow
        }

        Loader {
            active: control.movable || control.resizable
            sourceComponent: HusResizeMouseArea {
                anchors.fill: parent
                target: control
                movable: control.movable
                resizable: control.resizable
                minimumX: control.minimumX
                maximumX: control.maximumX
                minimumY: control.minimumY
                maximumY: control.maximumY
                minimumWidth: control.minimumWidth
                maximumWidth: control.maximumWidth
                minimumHeight: control.minimumHeight
                maximumHeight: control.maximumHeight
            }
        }

        Item {
            id: __bg
            width: parent.width
            height: __arrowLoader.height + __contentLoader.height

            property real parentWidth: control.parent?.width ?? 0
            property real parentHeight: control.parent?.height ?? 0
            property bool isTop: control.y < parentHeight

            Loader {
                id: __arrowLoader
                x: -control.x + (__bg.parentWidth - width) * 0.5
                y: __bg.isTop ? (__bg.height - height) : 0
                width: control.arrowWidth
                height: control.arrowHeight
                rotation: __bg.isTop ? 180 : 0
                active: control.showArrow
                sourceComponent: control.arrowDelegate
            }

            Loader {
                id: __bgLoader
                y: __bg.isTop ? 0 : __arrowLoader.height
                width: parent.width
                height: __contentLoader.height
                sourceComponent: control.bgDelegate
            }
        }

        Loader {
            id: __contentLoader
            y: __bg.isTop ? 0 : __arrowLoader.height
            width: parent.width
            sourceComponent: control.contentDelegate
        }
    }
    Component.onCompleted: HusApi.setPopupAllowAutoFlip(this);
}

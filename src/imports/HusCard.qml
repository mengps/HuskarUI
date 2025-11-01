import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

Rectangle {
    id: control

    property bool animationEnabled: HusTheme.animationEnabled
    property string title: ''
    property font titleFont: Qt.font({
                                         family: HusTheme.HusCard.fontFamily,
                                         pixelSize: parseInt(HusTheme.HusCard.fontSizeTitle),
                                         weight: Font.DemiBold,
                                     })
    property string coverSource: ''
    property int coverFillMode: Image.Stretch

    property int bodyAvatarSize: 40
    property var bodyAvatarIcon: 0 ?? ''
    property string bodyAvatarSource: ''
    property string bodyAvatarText: ''
    property string bodyTitle: ''
    property font bodyTitleFont: Qt.font({
                                             family: HusTheme.HusCard.fontFamily,
                                             pixelSize: parseInt(HusTheme.HusCard.fontSizeBodyTitle),
                                             weight: Font.DemiBold,
                                         })
    property string bodyDescription: ''
    property font bodyDescriptionFont: Qt.font({
                                                   family: HusTheme.HusCard.fontFamily,
                                                   pixelSize: parseInt(HusTheme.HusCard.fontSizeBodyDescription),
                                               })
    property color colorTitle: HusTheme.HusCard.colorTitle
    property color colorBodyAvatar: HusTheme.HusCard.colorBodyAvatar
    property color colorBodyAvatarBg: 'transparent'
    property color colorBodyTitle: HusTheme.HusCard.colorBodyTitle
    property color colorBodyDescription: HusTheme.HusCard.colorBodyDescription

    property Component titleDelegate: Item {
        height: 60

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            HusText {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: control.title
                font: control.titleFont
                color: control.colorTitle
                wrapMode: Text.WrapAnywhere
                verticalAlignment: Text.AlignVCenter
            }

            Loader {
                Layout.alignment: Qt.AlignVCenter
                sourceComponent: extraDelegate
            }
        }

        HusDivider {
            width: parent.width;
            height: 1
            anchors.bottom: parent.bottom
            visible: control.coverSource == ''
        }
    }
    property Component extraDelegate: Item { }
    property Component coverDelegate: Image {
        height: control.coverSource == '' ? 0 : 180
        source: control.coverSource
        fillMode: control.coverFillMode
    }
    property Component bodyDelegate: Item {
        height: 100

        RowLayout {
            anchors.fill: parent

            Item {
                Layout.preferredWidth: __avatar.visible ? 70 : 0
                Layout.fillHeight: true

                HusAvatar {
                    id: __avatar
                    size: control.bodyAvatarSize
                    anchors.centerIn: parent
                    colorBg: control.colorBodyAvatarBg
                    iconSource: control.bodyAvatarIcon
                    imageSource: control.bodyAvatarSource
                    textSource: control.bodyAvatarText
                    colorIcon: control.colorBodyAvatar
                    colorText: control.colorBodyAvatar
                    visible: !((iconSource === 0 || iconSource === '') && imageSource === '' && textSource === '')
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                HusText {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyTitle
                    font: control.bodyTitleFont
                    color: control.colorBodyTitle
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyTitle != ''
                }

                HusText {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyDescription
                    font: control.bodyDescriptionFont
                    color: control.colorBodyDescription
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyDescription != ''
                }
            }
        }
    }
    property Component actionDelegate: Item { }

    objectName: '__HusCard__'
    width: 300
    height: __column.height
    color: HusTheme.HusCard.colorBg
    border.color: HusTheme.isDark ? HusTheme.HusCard.colorBorderDark : HusTheme.HusCard.colorBorder
    radius: HusTheme.HusCard.radiusBg
    clip: true

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationMid } }

    Column {
        id: __column
        width: parent.width

        Loader {
            width: parent.width
            sourceComponent: titleDelegate
        }
        Loader {
            width: parent.width - control.border.width * 2
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: coverDelegate
        }
        Loader {
            width: parent.width
            sourceComponent: bodyDelegate
        }
        Loader {
            width: parent.width
            sourceComponent: actionDelegate
        }
    }
}

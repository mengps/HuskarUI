import QtQuick
import QtQuick.Layouts
import DelegateUI

Rectangle {
    id: control

    width: 300
    height: __column.height
    color: DelTheme.DelCard.colorBg
    border.color: DelTheme.isDark ? DelTheme.DelCard.colorBorderDark : DelTheme.DelCard.colorBorder
    radius: DelTheme.DelCard.radiusBg
    clip: true

    titleFont {
        family: DelTheme.DelCard.fontFamily
        pixelSize: DelTheme.DelCard.fontSizeTitle
        weight: Font.DemiBold
    }

    bodyTitleFont {
        family: DelTheme.DelCard.fontFamily
        pixelSize: DelTheme.DelCard.fontSizeBodyTitle
        weight: Font.DemiBold
    }

    bodyDescriptionFont {
        family: DelTheme.DelCard.fontFamily
        pixelSize: DelTheme.DelCard.fontSizeBodyDescription
    }

    property bool animationEnabled: DelTheme.animationEnabled

    property string title: ""
    property font titleFont

    property url coverSource: ""
    property int coverFillMode: Image.Stretch

    property int bodyAvatarSize: 40
    property int bodyAvatarIcon: 0
    property string bodyAvatarSource: ""
    property string bodyAvatarText: ""
    property string bodyTitle: ""
    property font bodyTitleFont
    property string bodyDescription: ""
    property font bodyDescriptionFont

    property color colorTitle: DelTheme.DelCard.colorTitle
    property color colorBodyAvatar: DelTheme.DelCard.colorBodyAvatar
    property color colorBodyAvatarBg: "transparent"
    property color colorBodyTitle: DelTheme.DelCard.colorBodyTitle
    property color colorBodyDescription: DelTheme.DelCard.colorBodyDescription

    property Component titleDelegate: Item {
        height: 60

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            Text {
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

        DelDivider {
            width: parent.width;
            height: 1
            anchors.bottom: parent.bottom
            visible: control.coverSource == ""
        }
    }
    property Component extraDelegate: Item { }
    property Component coverDelegate: Image {
        height: control.coverSource == "" ? 0 : 180
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

                DelAvatar {
                    id: __avatar
                    size: control.bodyAvatarSize
                    anchors.centerIn: parent
                    colorBg: control.colorBodyAvatarBg
                    iconSource: control.bodyAvatarIcon
                    imageSource: control.bodyAvatarSource
                    textSource: control.bodyAvatarText
                    colorIcon: control.colorBodyAvatar
                    colorText: control.colorBodyAvatar
                    visible: !(iconSource == 0 && imageSource == "" && textSource == "")
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyTitle
                    font: control.bodyTitleFont
                    color: control.colorBodyTitle
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyTitle != ""
                }

                Text {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyDescription
                    font: control.bodyDescriptionFont
                    color: control.colorBodyDescription
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyDescription != ""
                }
            }
        }
    }
    property Component actionDelegate: Item { }

    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationMid } }

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

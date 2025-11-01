import QtQuick
import QtQuick.Layouts
import HuskarUI.Basic

HusButton {
    id: control

    enum IconPosition {
        Position_Start = 0,
        Position_End = 1
    }

    property bool loading: false
    property var iconSource: 0 ?? ''
    property int iconSize: parseInt(HusTheme.HusButton.fontSize)
    property int iconSpacing: 5 * sizeRatio
    property int iconPosition: HusIconButton.Position_Start
    property int orientation: Qt.Horizontal
    property color colorIcon: colorText

    objectName: '__HusIconButton__'
    contentItem: Item {
        implicitWidth: control.orientation === Qt.Horizontal ? __horLoader.implicitWidth : __verLoader.implicitWidth
        implicitHeight: control.orientation === Qt.Horizontal ? __horLoader.implicitHeight : __verLoader.implicitHeight

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }
        Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: HusTheme.Primary.durationMid } }

        Loader {
            id: __horLoader
            anchors.centerIn: parent
            active: control.orientation === Qt.Horizontal
            sourceComponent: RowLayout {
                spacing: control.iconSpacing
                layoutDirection: control.iconPosition === HusIconButton.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

                HusIconText {
                    id: __icon
                    Layout.minimumHeight: __text.implicitHeight
                    Layout.alignment: Qt.AlignVCenter
                    color: control.colorIcon
                    iconSize: control.iconSize
                    iconSource: control.loading ? HusIcon.LoadingOutlined : control.iconSource
                    verticalAlignment: Text.AlignVCenter
                    visible: !empty

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

                    NumberAnimation on rotation {
                        running: control.loading
                        from: 0
                        to: 360
                        loops: Animation.Infinite
                        duration: 1000
                    }
                }

                HusText {
                    id: __text
                    Layout.alignment: Qt.AlignVCenter
                    text: control.text
                    font: control.font
                    lineHeight: HusTheme.HusButton.fontLineHeight
                    color: control.colorText
                    elide: Text.ElideRight
                    visible: text !== ''

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
            }
        }

        Loader {
            id: __verLoader
            active: control.orientation === Qt.Vertical
            anchors.centerIn: parent
            sourceComponent: ColumnLayout {
                spacing: control.iconSpacing
                Component.onCompleted: relayout();

                function relayout() {
                    if (control.iconPosition === HusIconButton.Position_Start) {
                        children = [__icon, __text];
                    } else {
                        children = [__text, __icon];
                    }
                }

                HusIconText {
                    id: __icon
                    Layout.minimumHeight: __text.implicitHeight
                    Layout.alignment: Qt.AlignHCenter
                    color: control.colorIcon
                    iconSize: control.iconSize
                    iconSource: control.loading ? HusIcon.LoadingOutlined : control.iconSource
                    verticalAlignment: Text.AlignVCenter
                    visible: !empty

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }

                    NumberAnimation on rotation {
                        running: control.loading
                        from: 0
                        to: 360
                        loops: Animation.Infinite
                        duration: 1000
                    }
                }

                HusText {
                    id: __text
                    Layout.alignment: Qt.AlignHCenter
                    text: control.text
                    font: control.font
                    lineHeight: HusTheme.HusButton.fontLineHeight
                    color: control.colorText
                    elide: Text.ElideRight
                    visible: text !== ''

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: HusTheme.Primary.durationFast } }
                }
            }
        }
    }
}

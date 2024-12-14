import QtQuick
import QtQuick.Layouts
import DelegateUI

Item {

    Component.onCompleted: {
        const map = DelIcon.allIconNames();
        for (const key in map) {
            listModel.append({
                                 iconName: key,
                                 iconSource: map[key]
                             });
        }
    }

    GridView {
        id: gridView
        anchors.fill: parent
        cellWidth: Math.floor(width / 6)
        cellHeight: 100
        model: ListModel { id: listModel }
        delegate: Item {
            id: rootItem
            width: gridView.cellWidth
            height: gridView.cellHeight

            required property string iconName
            required property int iconSource

            Rectangle {
                anchors.fill: parent
                anchors.margins: 10
                color: mouseAre.pressed ? DelThemeFunctions.darker(DelTheme.Primary.colorPrimaryBorder) :
                                          mouseAre.hovered ? DelThemeFunctions.lighter(DelTheme.Primary.colorPrimaryBorder)  :
                                                             DelThemeFunctions.alpha(DelTheme.Primary.colorPrimaryBorder, 0);
                radius: 5

                Behavior on color { enabled: DelTheme.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

                MouseArea {
                    id: mouseAre
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: hovered = true;
                    onExited: hovered = false;
                    onClicked: {
                        DelApi.setClipbordText(`DelIcon.${rootItem.iconName}`);
                    }
                    property bool hovered: false
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    spacing: 10

                    DelIconText {
                        id: icon
                        Layout.preferredWidth: 28
                        Layout.preferredHeight: 28
                        Layout.alignment: Qt.AlignHCenter
                        iconSize: 28
                        iconSource: rootItem.iconSource
                    }

                    Text {
                        Layout.preferredWidth: parent.width - 10
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: rootItem.iconName
                        color: icon.iconColor
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }
        }
    }
}

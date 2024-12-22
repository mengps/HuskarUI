import QtQuick
import QtQuick.Layouts
import DelegateUI

import "../../Controls"

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

    Description {
        id: description
        desc: qsTr(`
## DelIconText 图标文本\n
使用开关切换两种状态之间。\n
* **继承自 { Text }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
iconSource | int | 图标源(来自 DelIcon)
iconSize | int | 图标大小
colorIcon | color | 图标颜色
contentDescription | string | 内容描述(提高可用性)
                   `)
    }

    GridView {
        id: gridView
        anchors.top: description.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        cellWidth: Math.floor(width / 8)
        cellHeight: 110
        clip: true
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
                        color: icon.colorIcon
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }
        }
    }
}

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import DelegateUI

import "../../Controls"

Item {

    Description {
        id: description
        desc: qsTr(`
## DelIconText 图标文本\n
语义化的图标文本。\n
* **继承自 { Text }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
iconSource | enum | 图标源(来自 DelIcon)
iconSize | int | 图标大小
colorIcon | color | 图标颜色
contentDescription | string | 内容描述(提高可用性)
\n**注意** 双色风格图标使用需要多个<Path{1~N}>图标覆盖使用\n
                   `)
    }

    DelTabView {
        anchors.top: description.bottom
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        addButtonDelegate: Item {}
        tabCentered: true
        defaultTabWidth: 120
        initModel: [
            {
                key: "1",
                title: qsTr("线框风格图标"),
                styleFilter: "Outlined"
            },
            {
                key: "2",
                title: qsTr("填充风格图标"),
                styleFilter: "Filled"
            },
            {
                key: "3",
                title: qsTr("双色风格图标"),
                styleFilter: "Path1,Path2,Path3,Path4"
            },
            {
                key: "4",
                title: qsTr("IcoMoon图标"),
                styleFilter: "IcoMoon"
            }
        ]
        contentDelegate: Item {
            id: contentItem

            Component.onCompleted: {
                const map = DelIcon.allIconNames();
                const filter = model.styleFilter.split(',');
                for (const key in map) {
                    let has = false;
                    filter.forEach((filterKey) => {
                                       if (key.indexOf(filterKey) !== -1) {
                                           has = true;
                                       }
                                   });
                    if (has) {
                        listModel.append({
                                             iconName: key,
                                             iconSource: map[key]
                                         });
                    }
                }
            }

            GridView {
                id: gridView
                anchors.fill: parent
                cellWidth: Math.floor(width / 8)
                cellHeight: 110
                clip: true
                model: ListModel { id: listModel }
                ScrollBar.vertical: DelScrollBar { }
                delegate: Item {
                    id: rootItem
                    width: gridView.cellWidth
                    height: gridView.cellHeight

                    required property string iconName
                    required property int iconSource

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 10
                        color: mouseArea.pressed ? DelThemeFunctions.darker(DelTheme.Primary.colorPrimaryBorder) :
                                                  mouseArea.hovered ? DelThemeFunctions.lighter(DelTheme.Primary.colorPrimaryBorder)  :
                                                                     DelThemeFunctions.alpha(DelTheme.Primary.colorPrimaryBorder, 0);
                        radius: 5

                        Behavior on color { enabled: DelTheme.animationEnabled; ColorAnimation { duration: DelTheme.Primary.durationFast } }

                        MouseArea {
                            id: mouseArea
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
    }
}

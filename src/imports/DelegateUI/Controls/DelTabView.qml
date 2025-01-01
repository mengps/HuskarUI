import QtQuick
import QtQuick.Templates as T
import DelegateUI

Item {
    id: control

    property bool animationEnabled: DelTheme.animationEnabled
    property var model: []
    property alias currentIndex: __tab.currentIndex
    property int tabPosition: DelTabViewType.Top
    property bool tabCentered: false
    property int defaultTabWidth: 80
    property int defaultTabHeight: DelTheme.DelTabView.fontSize + 16
    property int defaultTabSpacing: 0
    property Component tabDelegate: DelIconButton {
        id: __tabItem
        width: tabWidth
        height: tabHeight
        iconSize: tabIconSize
        iconSource: tabIcon
        iconPosition: tabIconPosition
        text: tabTitle
        effectEnabled: false
        colorBg: "transparent"
        colorBorder: "transparent"
        colorText: {
            if (__tabItem.isCurrent) {
                return DelTheme.isDark ? DelTheme.DelTabView.colorHightlightDark : DelTheme.DelTabView.colorHightlight;
            } else {
                return __tabItem.down ? DelTheme.DelTabView.colorTabActive :
                                        __tabItem.hovered ? DelTheme.DelTabView.colorTabHover :
                                                            DelTheme.DelTabView.colorTab;
            }
        }
        font {
            family: DelTheme.DelTabView.fontFamily
            pixelSize: DelTheme.DelTabView.fontSize
        }
        onClicked: __tab.currentIndex = index;

        property bool isCurrent: __tab.currentIndex == index
        property string tabKey: modelData.key || ""
        property int tabIcon: modelData.icon || 0
        property int tabIconSize: modelData.iconSize || DelTheme.DelTabView.fontSize
        property int tabIconPosition: modelData.iconPosition || DelButtonType.Position_Start
        property string tabTitle: modelData.title || ""
        property int tabWidth: modelData.tabWidth || defaultTabWidth
        property int tabHeight: modelData.tabHeight || defaultTabHeight
    }
    property Component contentDelegate: Item { }
    property Component highlightDelegate: Item {
        Rectangle {
            id: __highlight
            width: __private.isHorizontal ? 30 : 2
            height: __private.isHorizontal ? 2 : 30
            anchors {
                bottom: control.tabPosition == DelTabViewType.Top ? parent.bottom : undefined
                right: control.tabPosition == DelTabViewType.Left ? parent.right : undefined
            }
            state: __tab.state
            states: [
                State {
                    name: "top"
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: parent.bottom
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: "bottom"
                    AnchorChanges {
                        target: __highlight
                        anchors.top: parent.top
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: undefined
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    name: "left"
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: undefined
                        anchors.right: parent.right
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: parent.verticalCenter
                    }
                },
                State {
                    name: "right"
                    AnchorChanges {
                        target: __highlight
                        anchors.top: undefined
                        anchors.bottom: undefined
                        anchors.left: parent.left
                        anchors.right: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            ]
            color: DelTheme.isDark ? DelTheme.DelTabView.colorHightlightDark : DelTheme.DelTabView.colorHightlight
        }
    }

    function insert(index, object) {
        model.splice(index, 0, object);
        modelChanged();
    }

    function append(object) {
        model.push(object);
        modelChanged();
    }

    function removeAt(index) {
        model.splice(index, 1);
        modelChanged();
    }

    function clear() {
        model = [];
    }

    QtObject {
        id: __private
        property bool isHorizontal: control.tabPosition == DelTabViewType.Top || control.tabPosition == DelTabViewType.Bottom
    }

    ListView {
        id: __tab
        width: __private.isHorizontal ? (control.tabCentered ? contentWidth : parent.width) : defaultTabWidth
        height: __private.isHorizontal ? defaultTabHeight : (control.tabCentered ? contentHeight : parent.height)
        clip: true
        spacing: defaultTabSpacing
        model: control.model
        delegate: tabDelegate
        highlight: highlightDelegate
        highlightMoveDuration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
        orientation: __private.isHorizontal ? Qt.Horizontal : Qt.Vertical
        boundsBehavior: Flickable.StopAtBounds
        state: {
            switch (tabPosition) {
            case DelTabViewType.Top: return "top";
            case DelTabViewType.Bottom: return "bottom";
            case DelTabViewType.Left: return "left";
            case DelTabViewType.Right: return "right";
            }
        }
        states: [
            State {
                name: "top"
                AnchorChanges {
                    target: __tab
                    anchors.top: control.top
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.horizontalCenter: control.horizontalCenter
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "bottom"
                AnchorChanges {
                    target: __tab
                    anchors.top: undefined
                    anchors.bottom: control.bottom
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.horizontalCenter: control.horizontalCenter
                    anchors.verticalCenter: undefined
                }
            },
            State {
                name: "left"
                AnchorChanges {
                    target: __tab
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.left: parent.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: control.verticalCenter
                }
            },
            State {
                name: "right"
                AnchorChanges {
                    target: __tab
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.left: undefined
                    anchors.right: parent.right
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: control.verticalCenter
                }
            }
        ]
    }

    Item {
        id: __content
        state: __tab.state
        states: [
            State {
                name: "top"
                AnchorChanges {
                    target: __content
                    anchors.top: __tab.bottom
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: control.right
                }
            },
            State {
                name: "bottom"
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: __tab.top
                    anchors.left: control.left
                    anchors.right: control.right
                }
            },
            State {
                name: "left"
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: control.bottom
                    anchors.left: __tab.right
                    anchors.right: control.right
                }
            },
            State {
                name: "right"
                AnchorChanges {
                    target: __content
                    anchors.top: control.top
                    anchors.bottom: control.bottom
                    anchors.left: control.left
                    anchors.right: __tab.left
                }
            }
        ]

        Repeater {
            model: control.model

            Loader {
                anchors.fill: parent
                sourceComponent: contentDelegate
                visible: isCurrent
                property bool isCurrent: __tab.currentIndex === index
                required property int index
                required property var modelData
            }
        }
    }
}
